Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B75A6FF0
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiH3VwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiH3Vvh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:51:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1175A3D6
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v5-20020a2583c5000000b006964324be8cso714998ybm.14
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=ofrC1PqNoYIKnyKYWjHD7inVuacSGBJJLHypr0RookE=;
        b=VGRf/84iZ1p67fJnvZ/X1xcCS67elVIPk9IGJJ+bUuWMMIF3sRy7RxzaFdrO+WG7dH
         d/TlbooTEmNgUOWOqFkIyFyAhgj636EU+aMGf3bhfUhI9LPGF0x0v39+rp3COSYRpICF
         emKVXtjPhIhzNDYojpJwNosafP0nhIDkwMZkM1SszHz/jzoceNfVxm+3TZcljgHgvL8y
         TVQxs/Koc6RZpeES3hIup/YjX0wdMTaa96AxFv1wg+iYYTwvZ7GGZBg+tBO+knqi5Juw
         fEBz0idUpafaOWyAi5+6IN+BrsO4tEn9FOM/qV9RCHSE0DEDO6hWPkFyyM8anxAPc5xB
         lw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ofrC1PqNoYIKnyKYWjHD7inVuacSGBJJLHypr0RookE=;
        b=B5mFxuc/IV2HkC928KIdjjJwvhyA0tCPTl1RmTQ1LK1nFvrD+l8pYuIhHwulH6YBNU
         FM+q/oFcQIXfg57Vh6QZu3L53/GZC/CWt/yaX0fhcIl3rplildRPfD7stWq7nB5bHSEf
         Gkm7O3DzPU0JKQIJiTD7joJVoe/VFy2hfyK55kwxSX6KscpGA+FDIYBdbyXiHAPkQUub
         fcVTrg2cuttccv995TdZPS3yPlf224DNwVRpwj7XVjB6a9O5l9If2+x8rHM/QAZyToZ6
         SMOIagB+AkO15Ba8PJbl1oa3lZd6FwSWtEkAEraxODBnug8nbLHiY310fZJnAKmamjzq
         tSFw==
X-Gm-Message-State: ACgBeo0qwl0BgvATV468yQZLGGmuG4JZ6UTbm65PN0JCqAPzhNrs5IYm
        lQ8oEFwWOT2xqPWJ3TGf+GEnqL8n0EQ=
X-Google-Smtp-Source: AA6agR5S9pMWRwrdqx3FNbA74RB4ArEfkNsuNbxmIMNnFeUvwj+w6zosapneZCdX4VxzXX80wAu2gx5OQhs=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a0d:cd43:0:b0:329:febf:8c25 with SMTP id
 p64-20020a0dcd43000000b00329febf8c25mr15393402ywd.90.1661896211649; Tue, 30
 Aug 2022 14:50:11 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:07 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-19-surenb@google.com>
Subject: [RFC PATCH 18/30] codetag: add codetag query helper functions
From:   Suren Baghdasaryan <surenb@google.com>
To:     akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        surenb@google.com, kernel-team@android.com, linux-mm@kvack.org,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

Provide codetag_query_parse() to parse codetag queries and
codetag_matches_query() to check if the query affects a given codetag.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/codetag.h |  27 ++++++++
 lib/codetag.c           | 135 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 162 insertions(+)

diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 386733e89b31..0c605417ebbe 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -80,4 +80,31 @@ static inline void codetag_load_module(struct module *mod) {}
 static inline void codetag_unload_module(struct module *mod) {}
 #endif
 
+/* Codetag query parsing */
+
+struct codetag_query {
+	const char	*filename;
+	const char	*module;
+	const char	*function;
+	const char	*class;
+	unsigned int	first_line, last_line;
+	unsigned int	first_index, last_index;
+	unsigned int	cur_index;
+
+	bool		match_line:1;
+	bool		match_index:1;
+
+	unsigned int	set_enabled:1;
+	unsigned int	enabled:2;
+
+	unsigned int	set_frequency:1;
+	unsigned int	frequency;
+};
+
+char *codetag_query_parse(struct codetag_query *q, char *buf);
+bool codetag_matches_query(struct codetag_query *q,
+			   const struct codetag *ct,
+			   const struct codetag_module *mod,
+			   const char *class);
+
 #endif /* _LINUX_CODETAG_H */
diff --git a/lib/codetag.c b/lib/codetag.c
index f0a3174f9b71..288ccfd5cbd0 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -246,3 +246,138 @@ void codetag_unload_module(struct module *mod)
 	}
 	mutex_unlock(&codetag_lock);
 }
+
+/* Codetag query parsing */
+
+#define CODETAG_QUERY_TOKENS()	\
+	x(func)			\
+	x(file)			\
+	x(line)			\
+	x(module)		\
+	x(class)		\
+	x(index)
+
+enum tokens {
+#define x(name)		TOK_##name,
+	CODETAG_QUERY_TOKENS()
+#undef x
+};
+
+static const char * const token_strs[] = {
+#define x(name)		#name,
+	CODETAG_QUERY_TOKENS()
+#undef x
+	NULL
+};
+
+static int parse_range(char *str, unsigned int *first, unsigned int *last)
+{
+	char *first_str = str;
+	char *last_str = strchr(first_str, '-');
+
+	if (last_str)
+		*last_str++ = '\0';
+
+	if (kstrtouint(first_str, 10, first))
+		return -EINVAL;
+
+	if (!last_str)
+		*last = *first;
+	else if (kstrtouint(last_str, 10, last))
+		return -EINVAL;
+
+	return 0;
+}
+
+char *codetag_query_parse(struct codetag_query *q, char *buf)
+{
+	while (1) {
+		char *p = buf;
+		char *str1 = strsep_no_empty(&p, " \t\r\n");
+		char *str2 = strsep_no_empty(&p, " \t\r\n");
+		int ret, token;
+
+		if (!str1 || !str2)
+			break;
+
+		token = match_string(token_strs, ARRAY_SIZE(token_strs), str1);
+		if (token < 0)
+			break;
+
+		switch (token) {
+		case TOK_func:
+			q->function = str2;
+			break;
+		case TOK_file:
+			q->filename = str2;
+			break;
+		case TOK_line:
+			ret = parse_range(str2, &q->first_line, &q->last_line);
+			if (ret)
+				return ERR_PTR(ret);
+			q->match_line = true;
+			break;
+		case TOK_module:
+			q->module = str2;
+			break;
+		case TOK_class:
+			q->class = str2;
+			break;
+		case TOK_index:
+			ret = parse_range(str2, &q->first_index, &q->last_index);
+			if (ret)
+				return ERR_PTR(ret);
+			q->match_index = true;
+			break;
+		}
+
+		buf = p;
+	}
+
+	return buf;
+}
+
+bool codetag_matches_query(struct codetag_query *q,
+			   const struct codetag *ct,
+			   const struct codetag_module *mod,
+			   const char *class)
+{
+	size_t classlen = q->class ? strlen(q->class) : 0;
+
+	if (q->module &&
+	    (!mod->mod ||
+	     strcmp(q->module, ct->modname)))
+		return false;
+
+	if (q->filename &&
+	    strcmp(q->filename, ct->filename) &&
+	    strcmp(q->filename, kbasename(ct->filename)))
+		return false;
+
+	if (q->function &&
+	    strcmp(q->function, ct->function))
+		return false;
+
+	/* match against the line number range */
+	if (q->match_line &&
+	    (ct->lineno < q->first_line ||
+	     ct->lineno > q->last_line))
+		return false;
+
+	/* match against the class */
+	if (classlen &&
+	    (strncmp(q->class, class, classlen) ||
+	     (class[classlen] && class[classlen] != ':')))
+		return false;
+
+	/* match against the fault index */
+	if (q->match_index &&
+	    (q->cur_index < q->first_index ||
+	     q->cur_index > q->last_index)) {
+		q->cur_index++;
+		return false;
+	}
+
+	q->cur_index++;
+	return true;
+}
-- 
2.37.2.672.g94769d06f0-goog

