HTML := html
TEXT := text

WORD_LIST := word-list.txt.gz

EXTRACT := bin/extract.py

# Base URL for the HTML-format dictionaries.
BASE_URL := https://www.mso.anu.edu.au/~ralph/OPTED/v003/wb1913_

# Text files containing valid words from the dictionary.
TEXT_FILES :=																														\
	$(TEXT)/a.txt $(TEXT)/b.txt $(TEXT)/c.txt $(TEXT)/d.txt $(TEXT)/e.txt	\
	$(TEXT)/f.txt $(TEXT)/g.txt $(TEXT)/h.txt $(TEXT)/i.txt $(TEXT)/j.txt	\
	$(TEXT)/k.txt $(TEXT)/l.txt $(TEXT)/m.txt $(TEXT)/n.txt $(TEXT)/o.txt	\
	$(TEXT)/p.txt $(TEXT)/q.txt $(TEXT)/r.txt $(TEXT)/s.txt $(TEXT)/t.txt	\
	$(TEXT)/u.txt $(TEXT)/v.txt $(TEXT)/w.txt $(TEXT)/x.txt $(TEXT)/y.txt	\
	$(TEXT)/z.txt


.PHONY: all clean rebuild prepare html-files text-files


all: prepare |	\
	html-files		\
	text-files		\
	$(WORD_LIST)


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
$(WORD_LIST): $(TEXT_FILES)
	@cat $^ | gzip -c > $@
