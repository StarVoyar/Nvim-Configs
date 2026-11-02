return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "mxsdev/nvim-dap-vscode-js",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Detect Python command dynamically
      local function get_python_command()
        -- Try common Python commands in order of preference
        -- On Windows, try py launcher first, then python
        -- On Unix-like systems, try python3 first, then python
        local python_commands = {}
        if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
          python_commands = { "py", "python" }
        else
          python_commands = { "python3", "python" }
        end

        for _, cmd in ipairs(python_commands) do
          if vim.fn.executable(cmd) == 1 then
            return cmd
          end
        end
        -- Fallback to python if none found (will show error later if not available)
        return "python"
      end

      local python_cmd = get_python_command()

      -- Configure Python adapter manually to ensure proper path
      dap.adapters.python = function(callback, config)
        callback({
          type = "executable",
          command = python_cmd,
          args = { "-m", "debugpy.adapter" },
        })
      end

      -- Python debug configuration management
      local dap_config_file = vim.fn.stdpath("config") .. "/dap-python-configs.json"
      local python_configs = {}

      -- Load saved configurations
      local function load_python_configs()
        local f = io.open(dap_config_file, "r")
        if f then
          local content = f:read("*a")
          f:close()
          local ok, decoded = pcall(vim.fn.json_decode, content)
          if ok then
            python_configs = decoded
          end
        end
      end

      -- Save configurations
      local function save_python_configs()
        local f = io.open(dap_config_file, "w")
        if f then
          f:write(vim.fn.json_encode(python_configs))
          f:close()
        end
      end

      -- Add a new configuration
      local function add_python_config()
        local name = vim.fn.input("Configuration name: ")
        if name == "" then
          return
        end
        local args = vim.fn.input("Arguments (space separated): ")
        local args_list = vim.fn.split(args, " ")
        table.insert(python_configs, {
          name = name,
          args = args_list,
        })
        save_python_configs()
        refresh_python_dap_configs()
        print("Configuration '" .. name .. "' added")
      end

      -- Remove a configuration
      local function remove_python_config()
        if #python_configs == 0 then
          print("No custom configurations to remove")
          return
        end
        print("Custom configurations:")
        for i, config in ipairs(python_configs) do
          print(i .. ": " .. config.name .. " (" .. table.concat(config.args, " ") .. ")")
        end
        local choice = tonumber(vim.fn.input("Enter number to remove (or 0 to cancel): "))
        if choice and choice > 0 and choice <= #python_configs then
          local removed = table.remove(python_configs, choice)
          save_python_configs()
          refresh_python_dap_configs()
          print("Configuration '" .. removed.name .. "' removed")
        end
      end

      -- List configurations
      local function list_python_configs()
        if #python_configs == 0 then
          print("No custom configurations")
          return
        end
        print("Custom configurations:")
        for i, config in ipairs(python_configs) do
          print(i .. ": " .. config.name .. " - " .. table.concat(config.args, " "))
        end
      end

      -- Refresh DAP configurations
      function refresh_python_dap_configs()
        dap.configurations.python = {}

        -- Basic launch without args
        table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          console = "integratedTerminal",
          justMyCode = true,
          stopOnEntry = false,
        })

        -- Launch with args (prompt each time)
        table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch file with args",
          program = "${file}",
          console = "integratedTerminal",
          justMyCode = true,
          stopOnEntry = false,
          args = function()
            local args_str = vim.fn.input("Arguments: ")
            return vim.fn.split(args_str, " ")
          end,
        })

        -- Add saved configurations
        for _, config in ipairs(python_configs) do
          table.insert(dap.configurations.python, {
            type = "python",
            request = "launch",
            name = config.name,
            program = "${file}",
            console = "integratedTerminal",
            justMyCode = true,
            stopOnEntry = false,
            args = config.args,
          })
        end

        -- Attach remote
        table.insert(dap.configurations.python, {
          type = "python",
          request = "attach",
          name = "Attach remote",
          connect = {
            host = "localhost",
            port = 5678,
          },
        })
      end

      -- Create commands for managing configurations
      vim.api.nvim_create_user_command("DapPythonAddConfig", add_python_config, {})
      vim.api.nvim_create_user_command("DapPythonRemoveConfig", remove_python_config, {})
      vim.api.nvim_create_user_command("DapPythonListConfigs", list_python_configs, {})

      -- Load and initialize
      load_python_configs()
      refresh_python_dap_configs()

      -- Don't let nvim-dap-python add its own configurations
      require("dap-python").setup(python_cmd, {
        include_configs = false,
      })

      -- Python configuration management keybindings (must be after setup)
      vim.keymap.set("n", "<leader>da", add_python_config, { desc = "Add Python debug config" })
      vim.keymap.set("n", "<leader>dr", remove_python_config, { desc = "Remove Python debug config" })
      vim.keymap.set("n", "<leader>dl", list_python_configs, { desc = "List Python debug configs" })
      require("dap-go").setup()
      require("dap-vscode-js").setup({
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "node-terminal",
          "pwa-extensionHost",
        },
      })
      require("jdtls").setup_dap()

      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      dap.configurations.c = {
        {
          name = "Launch C",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch Rust",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }


      dap.configurations.cpp = dap.configurations.c

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 27,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 7,
            position = "bottom",
          },
        },
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      -- Don't auto-close DAP UI on exit - let user close with F8 or press F5 to restart
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end

      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end

      -- Reset neo-tree width when DAP UI closes
      dap.listeners.after.event_terminated.dapui_config = function()
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "neo-tree" then
                vim.api.nvim_win_set_width(win, 28)
                break
              end
            end
          end
        end)
      end

      dap.listeners.after.event_exited.dapui_config = function()
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "neo-tree" then
                vim.api.nvim_win_set_width(win, 28)
                break
              end
            end
          end
        end)
      end

      vim.keymap.set("n", "<F8>", dapui.toggle)
      vim.keymap.set("n", "<C-b>", dap.toggle_breakpoint)

      -- F5 toggles debugging: stop if running, start if not
      vim.keymap.set("n", "<F5>", function()
        local session = dap.session()
        if session and session.initialized then
          -- Session is active and initialized, stop debugging
          dap.terminate()
          dapui.close()
          -- Reset neo-tree width
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "neo-tree" then
                  vim.api.nvim_win_set_width(win, 28)
                  break
                end
              end
            end
          end)
        else
          -- Check if UI is open but session is dead
          local ui_open = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match("dap%-") then
              ui_open = true
              break
            end
          end
          if ui_open then
            dapui.close()
            -- Reset neo-tree width
            vim.schedule(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(win) then
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.bo[buf].filetype == "neo-tree" then
                    vim.api.nvim_win_set_width(win, 28)
                    break
                  end
                end
              end
            end)
          else
            -- No active session or UI, start debugging
            dap.continue()
          end
        end
      end)

      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<S-F11>", dap.step_out)
    end,
  },
}
