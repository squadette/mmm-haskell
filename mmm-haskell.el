;;; mmm-haskell.el --- MMM submode class for Haskell literate programs
;;
;; Copyright 2005 Christopher Dutchyn <cdutchyn@cs.ubc.ca>.
;;
;; If you use and/or change this code; please email me.  The most
;; recent version will be kept (during my graduate career) at
;; <http://www.cs.ubc.ca/~cdutchyn/download/mmm-haskell.el>.
;;

;;{{{ GPL

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;}}}

;;; Commentary:

;; This file contains the definition of an MMM mode submode class for
;; editing Bird/Wadler-style literate Haskell programs.  There are some limitations; search for
;; `!! later' in this file to examine these.

;; How to install:
;;    1. install mmm-mode (http://mmm-mode.sourceforge.net)
;;          this code was written for mmm-mode-0.4.8
;;
;;    2. copy this file into your Emacs sitelisp directory
;;
;;    3. add several lines to your .emacs file
;;            ;; Haskell [requires MMM]
;;            (require 'mmm-auto)
;;            (require 'mmm-haskell)
;;            (setq mmm-global-mode 'maybe)
;;            (add-to-list 'mmm-mode-ext-classes-alist
;;                         '(latex-mode "\\.lhs$" haskell))
;;
;; Usage notes:
;;    1. several practical inserts have been supplied:
;;          Key             Inserts
;;          ---             -------
;;          C-c % /         universal          mmm-mode ... ignore
;;          C-c % c         {code}
;;
;;    2. As with all mmm-mode operations, MMM->Parse Buffer is useful
;;       to tell emacs to find and decorate manually-entered Haskell
;;       subregions.
;;
;;    3. There appears to be a bug in mmm-mode-0.4.8 where a totally
;;       empty subregion breaks the parser.  The message I receive is
;;       `Wrong type argument: integer-or-marker-p, nil'.  In this
;;       case, the problematic subregion will show up undecorated.
;;       [Any subregions following the failed one, may remain
;;       decorated because MMM-ification didn't rewrite them.]
;;       Therefore, I've made the insertions automatically put insert
;;       `...' as a placeholder.
;;
;;    4.  At mmm-submode-decoration-level 1, all code and
;;        results are shown in mmm-default-submode-face.  At
;;        mmm-submode-decoration-level 2, code is displayed in
;;        mmm-code-submode-face.  You can customize these three
;;        faces for yourself: for Emacs 21, try using the menu path
;;        Options->Customize Emacs->Faces Matching Regexp ...->`mmm-*'
;;

;;; Code:

(require 'mmm-vars)
(require 'mmm-auto)

;;{{{ Variables
;;}}}
;;{{{ Support for mmm submode stuff
;;}}}
;;{{{ mmm haskell submode group

(mmm-add-group                          ;mmm-add-to-group
 'haskell
 `(;;code chunks
   (haskell-code
    :match-name       haskell-code
    :submode          haskell-mode
    :front            "\\\\begin[ \t]*{code}"
    :back             "\\\\end[ \t]*{code}"
    :face             mmm-code-submode-face
    :insert           ((?c {code} "Haskell code block"
                           @ "\\begin{code}" ?\n @ _ "..." @ ?\n "\\end{code}"))
    :delimiter-mode   latex-mode
    :case-fold-search nil
    :end-not-begin    t)

   (haskell-bird
    :match-name       haskell-code-bird
    :submode          haskell-mode
    :front            "^>"
    :include-front    t
    :back             "^>\\|$"
    :face             mmm-code-submode-face
    )

   (haskell-spec
    :match-name       haskell-spec
    :submode          haskell-mode
    :front            "\\\\begin[ \t]*{spec}"
    :back             "\\\\end[ \t]*{spec}"
    :face             mmm-code-submode-face
    :insert           ((?c {spec} "Haskell spec block"
                           @ "\\begin{spec}" ?\n @ _ "..." @ ?\n "\\end{spec}"))
    :delimiter-mode   latex-mode
    :case-fold-search nil
    :end-not-begin    t)

   (haskell-inline
    :match-name       haskell-inline
    :submode          haskell-mode
    :front            "|"
    :back             "|"
    :face             mmm-code-submode-face
    :insert           ((?| |...| "Haskell inline code" @ "|" @ _ "..." @ "|"))
    :delimiter-mode   latex-mode
    :case-fold-search nil
    :end-not-begin    t)

   (haskell-verbatim
    :match-name       haskell-verbatim
    :submode          haskell-mode
    :front            "@"
    :back             "@"
    :face             mmm-code-submode-face
    :insert           ((?v @...@ "Haskell verbatim" @ "@" @ _ "..." @ "@"))
    :delimiter-mode   latex-mode
    :case-fold-search nil
    :end-not-begin    t)


   ;;evaluation chunks
   (haskell-eval
    :match-name       haskell-eval
    :submode          haskell-mode
    :front            "\\\\eval[ \t]*{"
    :back             "}"
    :face             mmm-code-submode-face
    :insert           ((?e eval{} nil @ "\\eval{" @ _ "..." @ "}" @))
    :delimiter-mode   latex-mode
    :case-fold-search nil
    :end-not-begin    t)

   (haskell-perform
    :match-name       haskell-perform
    :submode          haskell-mode
    :front            "\\\\perform[ \t]*{"
    :back             "}"
    :face             mmm-code-submode-face
    :insert           ((?p perform{} nil @ "\\eval{" @ _ "..." @ "}" @))
    :delimiter-mode   latex-mode
    :case-fold-search nil
    :end-not-begin    t)
   ))

;;}}}
;;{{{ Set Mode Line
;;}}}

(provide 'mmm-haskell)

;;; mmm-haskell.el ends here