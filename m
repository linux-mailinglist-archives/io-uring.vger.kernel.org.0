Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDED5A7028
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiH3Vys (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiH3Vx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:53:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1070F8FD66
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x27-20020a25ac9b000000b0069140cfbbd9so714524ybi.8
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=ZStBKMvqZf5cf9FAaMePhJpKdJzTFBwr6u3tFotg8hA=;
        b=VTVsraZqevmRCaObBRFMsjzBHvekcfce8MtBSaZZ5Crg1seH0CtSm9c29RKCC59TBN
         19FBNPHC8dpOcblrHciXVuHQoofaiZfBwdvimHRJsLndFImNdH+eu+YtfXaacByCuPex
         4skGzTc23jNuehJZ1slH7Ll/8rph1Z+dZIGkIrmDgscRY7RIgNnfOz1AT6ADLF2JebGP
         ImyuFSTfbcS7qk97+Srdow1KJqFKbaNXoPDO2ySg/qcfR6YEVvxMJcvJ5RrVZoonHGUz
         PLJ9fn0z6uZxXsmBY3YesylZ0YvtVFfBxK+5t+T1HyPEAGObb07elO3lsln5Hg+z0Hea
         kK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ZStBKMvqZf5cf9FAaMePhJpKdJzTFBwr6u3tFotg8hA=;
        b=J9pgdyxB0G+dxMcdLtjM6sQdzBjh+OR+4TcPGZ3bHueM6q5UasN4fn8G/e2L7wSqfg
         ES1XFcSL5nUE07ZPqaaO6F4TxXOhlLDZJSnTMn207W7jENb5yH1TxcqjnB68PuJb4R+g
         YvYuSBBEvu/Lw/VCL+P/oSijw8v4/5bheXBJt35m3/VWTgdSCJyZDzedYzkqCrk5bhIv
         o/4aLTty3Fvk8B1Mr6dm0tbwTSb3NJJ72dzrDKsnPYhrRc2OI2daRjs8vR4Hn57uWKs1
         wPwqELt0/nfE35qn0r7KNQWkP4hO8Am1ZBvyOWe24RTdeaxW0eFJ2wT/APwhKjrEbJmy
         BdDw==
X-Gm-Message-State: ACgBeo3voJS1jCocLZJF1bfyW1xNhdPwqbHxBJ1tVRAcVYXJ/r2TjNVW
        N9mOp+DX2e5qXpckQ6pJCXBVmk/Ouxk=
X-Google-Smtp-Source: AA6agR5ZJaVBuvkDlBerd8g/D0cXVNCnXViOohqfD6wf3W0FPvTvaQusAJxcQ2WbQWopoioqQ9vnkekcbVo=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a05:6902:15cf:b0:67c:1ee7:149 with SMTP id
 l15-20020a05690215cf00b0067c1ee70149mr13333139ybu.594.1661896238275; Tue, 30
 Aug 2022 14:50:38 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:17 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-29-surenb@google.com>
Subject: [RFC PATCH 28/30] Improved symbolic error names
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

This patch adds per-error-site error codes, with error strings that
include their file and line number.

To use, change code that returns an error, e.g.
    return -ENOMEM;
to
    return -ERR(ENOMEM);

Then, errname() will return a string that includes the file and line
number of the ERR() call, for example
    printk("Got error %s!\n", errname(err));
will result in
    Got error ENOMEM at foo.c:1234

To convert back to the original error code (before returning it to
outside code that does not understand dynamic error codes), use
    return error_class(err);

To test if an error is of some type, replace
    if (err == -ENOMEM)
with
    if (error_matches(err, ENOMEM))

Implementation notes:

Error codes are allocated dynamically on module load and deallocated on
module unload. On memory allocation failure (i.e. the data structures
for indexing error strings and error parents), ERR() will fall back to
returning the error code that it was passed.

MAX_ERRNO has been raised from 4096 to 1 million, which should be
sufficient given the number of lines of code and the fraction that throw
errors in the kernel codebase.

This has implications for ERR_PTR(), since the range of the address
space reserved for errors is unavailable for other purposes. Since
ERR_PTR() ptrs are at the top of the address space there should not be
any major difficulties.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/asm-generic/codetag.lds.h |   3 +-
 include/linux/err.h               |   2 +-
 include/linux/errname.h           |  50 +++++++++++++++
 lib/errname.c                     | 103 ++++++++++++++++++++++++++++++
 4 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
index d799f4aced82..b087cf1874a9 100644
--- a/include/asm-generic/codetag.lds.h
+++ b/include/asm-generic/codetag.lds.h
@@ -11,6 +11,7 @@
 #define CODETAG_SECTIONS()		\
 	SECTION_WITH_BOUNDARIES(alloc_tags)		\
 	SECTION_WITH_BOUNDARIES(dynamic_fault_tags)	\
-	SECTION_WITH_BOUNDARIES(time_stats_tags)
+	SECTION_WITH_BOUNDARIES(time_stats_tags)	\
+	SECTION_WITH_BOUNDARIES(error_code_tags)
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
diff --git a/include/linux/err.h b/include/linux/err.h
index a139c64aef2a..1d8d6c46ab9c 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -15,7 +15,7 @@
  * This should be a per-architecture thing, to allow different
  * error and pointer decisions.
  */
-#define MAX_ERRNO	4095
+#define MAX_ERRNO	((1 << 20) - 1)
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/linux/errname.h b/include/linux/errname.h
index e8576ad90cb7..dd39fe7120bb 100644
--- a/include/linux/errname.h
+++ b/include/linux/errname.h
@@ -5,12 +5,62 @@
 #include <linux/stddef.h>
 
 #ifdef CONFIG_SYMBOLIC_ERRNAME
+
 const char *errname(int err);
+
+#include <linux/codetag.h>
+
+struct codetag_error_code {
+	const char		*str;
+	int			err;
+};
+
+/**
+ * ERR - return an error code that records the error site
+ *
+ * E.g., instead of
+ *   return -ENOMEM;
+ * Use
+ *   return -ERR(ENOMEM);
+ *
+ * Then, when a caller prints out the error with errname(), the error string
+ * will include the file and line number.
+ */
+#define ERR(_err)							\
+({									\
+	static struct codetag_error_code				\
+	__used								\
+	__section("error_code_tags")					\
+	__aligned(8) e = {						\
+		.str	= #_err " at " __FILE__ ":" __stringify(__LINE__),\
+		.err	= _err,						\
+	};								\
+									\
+	e.err;								\
+})
+
+int error_class(int err);
+bool error_matches(int err, int class);
+
 #else
+
+static inline int error_class(int err)
+{
+	return err;
+}
+
+static inline bool error_matches(int err, int class)
+{
+	return err == class;
+}
+
+#define ERR(_err)	_err
+
 static inline const char *errname(int err)
 {
 	return NULL;
 }
+
 #endif
 
 #endif /* _LINUX_ERRNAME_H */
diff --git a/lib/errname.c b/lib/errname.c
index 05cbf731545f..2db8f5301ba0 100644
--- a/lib/errname.c
+++ b/lib/errname.c
@@ -1,9 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/build_bug.h>
+#include <linux/codetag.h>
 #include <linux/errno.h>
 #include <linux/errname.h>
+#include <linux/idr.h>
 #include <linux/kernel.h>
 #include <linux/math.h>
+#include <linux/module.h>
+#include <linux/xarray.h>
+
+#define DYNAMIC_ERRCODE_START	4096
+
+static DEFINE_IDR(dynamic_error_strings);
+static DEFINE_XARRAY(error_classes);
+
+static struct codetag_type *cttype;
 
 /*
  * Ensure these tables do not accidentally become gigantic if some
@@ -200,6 +211,9 @@ static const char *names_512[] = {
 
 static const char *__errname(unsigned err)
 {
+	if (err >= DYNAMIC_ERRCODE_START)
+		return idr_find(&dynamic_error_strings, err);
+
 	if (err < ARRAY_SIZE(names_0))
 		return names_0[err];
 	if (err >= 512 && err - 512 < ARRAY_SIZE(names_512))
@@ -222,3 +236,92 @@ const char *errname(int err)
 
 	return err > 0 ? name + 1 : name;
 }
+
+/**
+ * error_class - return standard/parent error (of a dynamic error code)
+ *
+ * When using dynamic error codes returned by ERR(), error_class() will return
+ * the original errorcode that was passed to ERR().
+ */
+int error_class(int err)
+{
+	int class = abs(err);
+
+	if (class > DYNAMIC_ERRCODE_START)
+		class = (unsigned long) xa_load(&error_classes,
+					      class - DYNAMIC_ERRCODE_START);
+	if (err < 0)
+		class = -class;
+	return class;
+}
+EXPORT_SYMBOL(error_class);
+
+/**
+ * error_matches - test if error is of some type
+ *
+ * When using dynamic error codes, instead of checking for errors with e.g.
+ *   if (err == -ENOMEM)
+ * Instead use
+ *   if (error_matches(err, ENOMEM))
+ */
+bool error_matches(int err, int class)
+{
+	err	= abs(err);
+	class	= abs(class);
+
+	BUG_ON(err	>= MAX_ERRNO);
+	BUG_ON(class	>= MAX_ERRNO);
+
+	if (err != class)
+		err = error_class(err);
+
+	return err == class;
+}
+EXPORT_SYMBOL(error_matches);
+
+static void errcode_module_load(struct codetag_type *cttype, struct codetag_module *mod)
+{
+	struct codetag_error_code *i, *start = (void *) mod->range.start;
+	struct codetag_error_code *end = (void *) mod->range.stop;
+
+	for (i = start; i != end; i++) {
+		int err = idr_alloc(&dynamic_error_strings,
+				    (char *) i->str,
+				    DYNAMIC_ERRCODE_START,
+				    MAX_ERRNO,
+				    GFP_KERNEL);
+		if (err < 0)
+			continue;
+
+		xa_store(&error_classes,
+			 err - DYNAMIC_ERRCODE_START,
+			 (void *)(unsigned long) abs(i->err),
+			 GFP_KERNEL);
+
+		i->err = i->err < 0 ? -err : err;
+	}
+}
+
+static void errcode_module_unload(struct codetag_type *cttype, struct codetag_module *mod)
+{
+	struct codetag_error_code *i, *start = (void *) mod->range.start;
+	struct codetag_error_code *end = (void *) mod->range.stop;
+
+	for (i = start; i != end; i++)
+		idr_remove(&dynamic_error_strings, abs(i->err));
+}
+
+static int __init errname_init(void)
+{
+	const struct codetag_type_desc desc = {
+		.section	= "error_code_tags",
+		.tag_size	= sizeof(struct codetag_error_code),
+		.module_load	= errcode_module_load,
+		.module_unload	= errcode_module_unload,
+	};
+
+	cttype = codetag_register_type(&desc);
+
+	return PTR_ERR_OR_ZERO(cttype);
+}
+module_init(errname_init);
-- 
2.37.2.672.g94769d06f0-goog

