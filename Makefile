HTML := html
TEXT := text

WORD_LIST_1 := word-list-1.txt.gz
WORD_LIST_2 := word-list-2.txt.gz

EXTRACT := bin/extract.py

# Base URL for the HTML-format dictionaries.
BASE_URL := https://www.mso.anu.edu.au/~ralph/OPTED/v003/wb1913_

# Github URL for wordlist-2
WORD_LIST_2_URL := https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt

# Text files containing valid words from the dictionary.
TEXT_FILES :=																														\
	$(TEXT)/a.txt $(TEXT)/b.txt $(TEXT)/c.txt $(TEXT)/d.txt $(TEXT)/e.txt	\
	$(TEXT)/f.txt $(TEXT)/g.txt $(TEXT)/h.txt $(TEXT)/i.txt $(TEXT)/j.txt	\
	$(TEXT)/k.txt $(TEXT)/l.txt $(TEXT)/m.txt $(TEXT)/n.txt $(TEXT)/o.txt	\
	$(TEXT)/p.txt $(TEXT)/q.txt $(TEXT)/r.txt $(TEXT)/s.txt $(TEXT)/t.txt	\
	$(TEXT)/u.txt $(TEXT)/v.txt $(TEXT)/w.txt $(TEXT)/x.txt $(TEXT)/y.txt	\
	$(TEXT)/z.txt


.PHONY: all clean rebuild prepare html-files text-files


all: prepare       |\
	html-files		\
	text-files		\
	$(WORD_LIST_1)  \
	$(WORD_LIST_2)


clean:
	@echo rm -rf $(HTML) $(TEXT)


rebuild: clean
	@rm -f $(WORD_LIST)


prepare:
	@mkdir -p $(HTML)
	@mkdir -p $(TEXT)


html-files: prepare | $(patsubst $(TEXT)/%.txt,$(HTML)/%.html,$^)

# Fetch the raw HTML-format dictionary files, one for each letter of the
# English alphabet.
$(HTML)/%.html:
	@wget -q $(BASE_URL)$(shell basename $@) -O $@


text-files: $(TEXT_FILES)

# Extract the words from the dictionary files.
$(TEXT)/%.txt: $(HTML)/%.html
	@python3 $(EXTRACT) $< > $@


# Combine the word files into a single compressed word-list file.
$(WORD_LIST_1): $(TEXT_FILES)
	@cat $^ | gzip -c > $@


$(patsubst %.gz,%,$(WORD_LIST_2)):
	@curl $(WORD_LIST_2_URL) -o $@

$(WORD_LIST_2): $(patsubst %.gz,%,$(WORD_LIST_2))
	@gzip $<
