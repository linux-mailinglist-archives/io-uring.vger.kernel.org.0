Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303D25A6FDC
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiH3Vv4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiH3VvO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:51:14 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C465422B02
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33f8988daecso180743287b3.12
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=w9gVcgQRdZitDZxjqrDoJq6Gs/0aEjUQjbVWDU06BvI=;
        b=Q1PzL2bThBJ4iiSWL0d7IheB5VfLNxWH1gqUohex8OE2QSiGR/fpg9gqy0yixW+Isb
         pxJFdeTMvRwdBwAcg7flVNtX1j9eJ9C9tS/tDg05AImXSgWHVN2GUlakKwYKuvgZhIEZ
         53DiKTHKeM16TZHvnMmCYNdJyP0y2AnTT97Oi3Zv6WKFja6rmmzzL6Teq1ArHTNPI2TC
         NVjO3wFAVKlA4rp9aDdNwzT8IVNC+AXM7IGd6mywh1LPpaNIM2cA8K+l/DF+pItxSR+n
         jG8tcEuC2nhcd/7nioVG87S+Xo+Y8ZaGYAgx8HTdNWhJ4JbCh9BURQy523rvt+lhf5xu
         HCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=w9gVcgQRdZitDZxjqrDoJq6Gs/0aEjUQjbVWDU06BvI=;
        b=du9nRbtA35hcqZJOmxy2Oi3rayjaptAjRi1C2Xgjz8B2Q0kJU7mnpbdRehVxeVOzla
         1J/F+drUstWPlGlyreQW8Z/xcbx2/fD2ei7e8d5caFixVBoXgntC71aaqlccBdEUuaLi
         3xxndD0JkiNQVJTcVvpNAa7qH2lnwRGGPiYV+eRmIQiBSoJxYCstqqGxFJlN2nbbnqwN
         p1mOkNhIni8aHx+1bi/lx7T940SmxC00gbn+dHitJAds04bvu8u071cj949L31frUpPV
         n0T/7IJnAK6MDaQ8p6NMRB3F2tz7FfIzwgpy9RL8ICsV0nLam/2AsY6fxLz8OmKwoecs
         rcJQ==
X-Gm-Message-State: ACgBeo024mLa6HfQkQie4C5Q55Tqk91T6XtLMuwZ3FUKTiUKETfuT9Hc
        TSSxJhL3Se+YOnX2W53TZJ9Zq5+E8KU=
X-Google-Smtp-Source: AA6agR4vG82TMLNZbe9b42TzeXUrvZHL0ChO+lv1LMjTJEyr7xCSEiF1DQ2YaYAniXhteJjohj+5Rf5pvb8=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:e6c6:0:b0:695:f4dc:8c4f with SMTP id
 d189-20020a25e6c6000000b00695f4dc8c4fmr13235724ybh.329.1661896203524; Tue, 30
 Aug 2022 14:50:03 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:04 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-16-surenb@google.com>
Subject: [RFC PATCH 15/30] lib: introduce slab allocation tagging
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

Introduce CONFIG_SLAB_ALLOC_TAGGING which provides helper functions
to easily instrument slab allocators and adds a codetag_ref field into
slabobj_ext to store a pointer to the allocation tag associated with
the code that allocated the slab object.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Co-developed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/memcontrol.h |  5 +++++
 include/linux/slab.h       | 25 +++++++++++++++++++++++++
 include/linux/slab_def.h   |  2 +-
 include/linux/slub_def.h   |  4 ++--
 lib/Kconfig.debug          | 11 +++++++++++
 mm/slab_common.c           | 33 +++++++++++++++++++++++++++++++++
 6 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 315399f77173..97c0153f0247 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -232,7 +232,12 @@ struct obj_cgroup {
  * if MEMCG_DATA_OBJEXTS is set.
  */
 struct slabobj_ext {
+#ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *objcg;
+#endif
+#ifdef CONFIG_SLAB_ALLOC_TAGGING
+	union codetag_ref ref;
+#endif
 } __aligned(8);
 
 /*
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 55ae3ea864a4..5a198aa02a08 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -438,6 +438,31 @@ static __always_inline unsigned int __kmalloc_index(size_t size,
 #define kmalloc_index(s) __kmalloc_index(s, true)
 #endif /* !CONFIG_SLOB */
 
+#ifdef CONFIG_SLAB_ALLOC_TAGGING
+
+#include <linux/alloc_tag.h>
+
+union codetag_ref *get_slab_tag_ref(const void *objp);
+
+#define slab_tag_add(_old, _new)					\
+do {									\
+	if (!ZERO_OR_NULL_PTR(_new) && _old != _new)			\
+		alloc_tag_add(get_slab_tag_ref(_new), __ksize(_new));	\
+} while (0)
+
+static inline void slab_tag_dec(const void *ptr)
+{
+	if (!ZERO_OR_NULL_PTR(ptr))
+		alloc_tag_sub(get_slab_tag_ref(ptr), __ksize(ptr));
+}
+
+#else
+
+#define slab_tag_add(_old, _new) do {} while (0)
+static inline void slab_tag_dec(const void *ptr) {}
+
+#endif
+
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __alloc_size(1);
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t flags) __assume_slab_alignment __malloc;
 void *kmem_cache_alloc_lru(struct kmem_cache *s, struct list_lru *lru,
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index e24c9aff6fed..25feb5f7dc32 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -106,7 +106,7 @@ static inline void *nearest_obj(struct kmem_cache *cache, const struct slab *sla
  *   reciprocal_divide(offset, cache->reciprocal_buffer_size)
  */
 static inline unsigned int obj_to_index(const struct kmem_cache *cache,
-					const struct slab *slab, void *obj)
+					const struct slab *slab, const void *obj)
 {
 	u32 offset = (obj - slab->s_mem);
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index f9c68a9dac04..940c146768d4 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -170,14 +170,14 @@ static inline void *nearest_obj(struct kmem_cache *cache, const struct slab *sla
 
 /* Determine object index from a given position */
 static inline unsigned int __obj_to_index(const struct kmem_cache *cache,
-					  void *addr, void *obj)
+					  void *addr, const void *obj)
 {
 	return reciprocal_divide(kasan_reset_tag(obj) - addr,
 				 cache->reciprocal_size);
 }
 
 static inline unsigned int obj_to_index(const struct kmem_cache *cache,
-					const struct slab *slab, void *obj)
+					const struct slab *slab, const void *obj)
 {
 	if (is_kfence_address(obj))
 		return 0;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6686648843b3..08c97a978906 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -989,6 +989,17 @@ config PAGE_ALLOC_TAGGING
 	  initiated at that code location. The mechanism can be used to track
 	  memory leaks with a low performance impact.
 
+config SLAB_ALLOC_TAGGING
+	bool "Enable slab allocation tagging"
+	default n
+	select ALLOC_TAGGING
+	select SLAB_OBJ_EXT
+	help
+	  Instrument slab allocators to track allocation source code and
+	  collect statistics on the number of allocations and their total size
+	  initiated at that code location. The mechanism can be used to track
+	  memory leaks with a low performance impact.
+
 source "lib/Kconfig.kasan"
 source "lib/Kconfig.kfence"
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 17996649cfe3..272eda62ecaa 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -202,6 +202,39 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 	return NULL;
 }
 
+#ifdef CONFIG_SLAB_ALLOC_TAGGING
+
+union codetag_ref *get_slab_tag_ref(const void *objp)
+{
+	struct slabobj_ext *obj_exts;
+	union codetag_ref *res = NULL;
+	struct slab *slab;
+	unsigned int off;
+
+	slab = virt_to_slab(objp);
+	/*
+	 * We could be given a kmalloc_large() object, skip those. They use
+	 * alloc_pages and can be tracked by page allocation tracking.
+	 */
+	if (!slab)
+		goto out;
+
+	obj_exts = slab_obj_exts(slab);
+	if (!obj_exts)
+		goto out;
+
+	if (!slab->slab_cache)
+		goto out;
+
+	off = obj_to_index(slab->slab_cache, slab, objp);
+	res = &obj_exts[off].ref;
+out:
+	return res;
+}
+EXPORT_SYMBOL(get_slab_tag_ref);
+
+#endif /* CONFIG_SLAB_ALLOC_TAGGING */
+
 static struct kmem_cache *create_cache(const char *name,
 		unsigned int object_size, unsigned int align,
 		slab_flags_t flags, unsigned int useroffset,
-- 
2.37.2.672.g94769d06f0-goog

