require 'pre-commit/checks/plugin'

module PreCommit
  module Checks
    class Whitespace < Plugin

      def self.aliases
        [:white_space]
      end

      def call(_)
        errors = `git diff-index --check --cached HEAD -- 2>&1`
        return if $?.success?

        # Initial commit: diff against the empty tree object
        if errors =~ /fatal: bad revision 'HEAD'/
          errors = `git diff-index --check --cached 4b825dc642cb6eb9a060e54bf8d69288fbee4904 -- 2>&1`
          return if $?.success?
        end

        errors
      end

      def self.description
        "Finds white space." # TODO: really??? how?
      end

    end
  end
end
