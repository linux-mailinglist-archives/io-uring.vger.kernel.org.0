Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6552A5A6FE9
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiH3VwX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiH3Vvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:51:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D63A326E2
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l9-20020a252509000000b00695eb4f1422so721684ybl.13
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=DVDWc4n0OUELi9+TR5vEerYUeoJhmwr6oegHq8VoMPY=;
        b=bM/4HTwD/5NvD2z1e/m/chKOx8M+k/cup4NHKUTyLbSRW7GSEIiXXrcH3cV9SZ1SAI
         L09ba1CkrtuU8u1GNYrpa4iH8Pf6SJhzN8yZiOz8fjB8X6SKmg6EcT8m4ikT2VrNvIZC
         fcEJcUtC8cuaOScZm4W400OnCT8oTeDu69+FoT8U0Z8bPUbNNtUMn8N9gtPxsRiO1Jkp
         yHen1YuPdi7I2iwNEDue9JoiosDrnFDYBeVHrjJCFkXdPVyn9cYkcijvjT6kVZJ46mfx
         8WNJGPhwmcInAt8+4wUEyRhB6jGCNZ+WfXvMftBjOymVBGsg95WkR7Uw2/KIXsL46tgh
         o0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=DVDWc4n0OUELi9+TR5vEerYUeoJhmwr6oegHq8VoMPY=;
        b=ZWLXL+8OUpTYK9gSLt9PaHNV1h6A2bBwx3QYvQcztt/uQPodp+5PSGQ8ql3WmSRbuD
         7T7xJBtwlExoyqbx/oyqn6RMoHVLhCB5q9VbLMbWbjvMX0HkTKZ5dartmZi9c4goEFRX
         SzsmZ2grY/JkiC3/6Z0kx5RSwnvngUsPh69K1kpzFdxE4hwhodVtpUaEZTDfSFgaXo9y
         4Zvzj1M8AmeyZEEU48ewzOQq/Ma0U/M8gnQ4+Vv1Juno3jr+w3UsXJu54/sGjKuR98pt
         h3mChWiZex+SsT/JAtOXtQgkKySPSjf+2SJon0Fsc1mQ1BAmE48KL1Yd2KeO2hqMi1Cw
         YwJA==
X-Gm-Message-State: ACgBeo2+7+rESi3qSLKhnF6ah8Eyx7jtXB83snd/3OnmVddOLKl4OafQ
        RvNaQX0IhlolohK+XgIG7w8Q8+fYhws=
X-Google-Smtp-Source: AA6agR7T4bKeuJlf9DAoJiFE4v7Q2R/MdDJESlGt7ahUFYj3Wmkn9a6qQs7FkiNluCNw2Wq41YrDjpcXKsY=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:9f85:0:b0:693:614:cb2a with SMTP id
 u5-20020a259f85000000b006930614cb2amr13240649ybq.143.1661896206375; Tue, 30
 Aug 2022 14:50:06 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:05 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-17-surenb@google.com>
Subject: [RFC PATCH 16/30] mm: enable slab allocation tagging for kmalloc and friends
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

Redefine kmalloc, krealloc, kzalloc, kcalloc, etc. to record allocations
and deallocations done by these functions.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Co-developed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/slab.h | 103 +++++++++++++++++++++++++------------------
 mm/slab.c            |   2 +
 mm/slab_common.c     |  16 +++----
 mm/slob.c            |   2 +
 mm/slub.c            |   2 +
 5 files changed, 75 insertions(+), 50 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 5a198aa02a08..89273be35743 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -191,7 +191,10 @@ int kmem_cache_shrink(struct kmem_cache *s);
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
+void * __must_check _krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
+#define krealloc(_p, _size, _flags)					\
+	krealloc_hooks(_p, _krealloc(_p, _size, _flags))
+
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
@@ -463,6 +466,15 @@ static inline void slab_tag_dec(const void *ptr) {}
 
 #endif
 
+#define krealloc_hooks(_p, _do_alloc)					\
+({									\
+	void *_res = _do_alloc;						\
+	slab_tag_add(_p, _res);						\
+	_res;								\
+})
+
+#define kmalloc_hooks(_do_alloc)	krealloc_hooks(NULL, _do_alloc)
+
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __alloc_size(1);
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t flags) __assume_slab_alignment __malloc;
 void *kmem_cache_alloc_lru(struct kmem_cache *s, struct list_lru *lru,
@@ -541,25 +553,31 @@ static __always_inline void *kmem_cache_alloc_node_trace(struct kmem_cache *s, g
 }
 #endif /* CONFIG_TRACING */
 
-extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment
+extern void *_kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment
 									 __alloc_size(1);
+#define kmalloc_order(_size, _flags, _order)              \
+	kmalloc_hooks(_kmalloc_order(_size, _flags, _order))
 
 #ifdef CONFIG_TRACING
-extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
+extern void *_kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 				__assume_page_alignment __alloc_size(1);
 #else
-static __always_inline __alloc_size(1) void *kmalloc_order_trace(size_t size, gfp_t flags,
+static __always_inline __alloc_size(1) void *_kmalloc_order_trace(size_t size, gfp_t flags,
 								 unsigned int order)
 {
-	return kmalloc_order(size, flags, order);
+	return _kmalloc_order(size, flags, order);
 }
 #endif
+#define kmalloc_order_trace(_size, _flags, _order)      \
+	kmalloc_hooks(_kmalloc_order_trace(_size, _flags, _order))
 
-static __always_inline __alloc_size(1) void *kmalloc_large(size_t size, gfp_t flags)
+static __always_inline __alloc_size(1) void *_kmalloc_large(size_t size, gfp_t flags)
 {
 	unsigned int order = get_order(size);
-	return kmalloc_order_trace(size, flags, order);
+	return _kmalloc_order_trace(size, flags, order);
 }
+#define kmalloc_large(_size, _flags)                    \
+	kmalloc_hooks(_kmalloc_large(_size, _flags))
 
 /**
  * kmalloc - allocate memory
@@ -615,14 +633,14 @@ static __always_inline __alloc_size(1) void *kmalloc_large(size_t size, gfp_t fl
  *	Try really hard to succeed the allocation but fail
  *	eventually.
  */
-static __always_inline __alloc_size(1) void *kmalloc(size_t size, gfp_t flags)
+static __always_inline __alloc_size(1) void *_kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
 #ifndef CONFIG_SLOB
 		unsigned int index;
 #endif
 		if (size > KMALLOC_MAX_CACHE_SIZE)
-			return kmalloc_large(size, flags);
+			return _kmalloc_large(size, flags);
 #ifndef CONFIG_SLOB
 		index = kmalloc_index(size);
 
@@ -636,8 +654,9 @@ static __always_inline __alloc_size(1) void *kmalloc(size_t size, gfp_t flags)
 	}
 	return __kmalloc(size, flags);
 }
+#define kmalloc(_size, _flags)			kmalloc_hooks(_kmalloc(_size, _flags))
 
-static __always_inline __alloc_size(1) void *kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline __alloc_size(1) void *_kmalloc_node(size_t size, gfp_t flags, int node)
 {
 #ifndef CONFIG_SLOB
 	if (__builtin_constant_p(size) &&
@@ -654,6 +673,8 @@ static __always_inline __alloc_size(1) void *kmalloc_node(size_t size, gfp_t fla
 #endif
 	return __kmalloc_node(size, flags, node);
 }
+#define kmalloc_node(_size, _flags, _node)		\
+	kmalloc_hooks(_kmalloc_node(_size, _flags, _node))
 
 /**
  * kmalloc_array - allocate memory for an array.
@@ -661,16 +682,18 @@ static __always_inline __alloc_size(1) void *kmalloc_node(size_t size, gfp_t fla
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1, 2) void *kmalloc_array(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *_kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
-		return kmalloc(bytes, flags);
-	return __kmalloc(bytes, flags);
+		return _kmalloc(bytes, flags);
+	return _kmalloc(bytes, flags);
 }
+#define kmalloc_array(_n, _size, _flags)		\
+	kmalloc_hooks(_kmalloc_array(_n, _size, _flags))
 
 /**
  * krealloc_array - reallocate memory for an array.
@@ -679,7 +702,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array(size_t n, size_t size, gfp_
  * @new_size: new size of a single member of the array
  * @flags: the type of memory to allocate (see kmalloc)
  */
-static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
+static inline __alloc_size(2, 3) void * __must_check _krealloc_array(void *p,
 								    size_t new_n,
 								    size_t new_size,
 								    gfp_t flags)
@@ -689,8 +712,10 @@ static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
 	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
 		return NULL;
 
-	return krealloc(p, bytes, flags);
+	return _krealloc(p, bytes, flags);
 }
+#define krealloc_array(_p, _n, _size, _flags)		\
+	krealloc_hooks(_p, _krealloc_array(_p, _n, _size, _flags))
 
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
@@ -698,10 +723,8 @@ static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1, 2) void *kcalloc(size_t n, size_t size, gfp_t flags)
-{
-	return kmalloc_array(n, size, flags | __GFP_ZERO);
-}
+#define kcalloc(_n, _size, _flags)			\
+	kmalloc_array(_n, _size, (_flags)|__GFP_ZERO)
 
 /*
  * kmalloc_track_caller is a special version of kmalloc that records the
@@ -712,10 +735,10 @@ static inline __alloc_size(1, 2) void *kcalloc(size_t n, size_t size, gfp_t flag
  * request comes from.
  */
 extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
-#define kmalloc_track_caller(size, flags) \
-	__kmalloc_track_caller(size, flags, _RET_IP_)
+#define kmalloc_track_caller(size, flags)		\
+	kmalloc_hooks(__kmalloc_track_caller(size, flags, _RET_IP_))
 
-static inline __alloc_size(1, 2) void *kmalloc_array_node(size_t n, size_t size, gfp_t flags,
+static inline __alloc_size(1, 2) void *_kmalloc_array_node(size_t n, size_t size, gfp_t flags,
 							  int node)
 {
 	size_t bytes;
@@ -723,26 +746,24 @@ static inline __alloc_size(1, 2) void *kmalloc_array_node(size_t n, size_t size,
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
-		return kmalloc_node(bytes, flags, node);
+		return _kmalloc_node(bytes, flags, node);
 	return __kmalloc_node(bytes, flags, node);
 }
+#define kmalloc_array_node(_n, _size, _flags, _node)	\
+	kmalloc_hooks(_kmalloc_array_node(_n, _size, _flags, _node))
 
-static inline __alloc_size(1, 2) void *kcalloc_node(size_t n, size_t size, gfp_t flags, int node)
-{
-	return kmalloc_array_node(n, size, flags | __GFP_ZERO, node);
-}
-
+#define kcalloc_node(_n, _size, _flags, _node)	\
+	kmalloc_array_node(_n, _size, (_flags)|__GFP_ZERO, _node)
 
 #ifdef CONFIG_NUMA
 extern void *__kmalloc_node_track_caller(size_t size, gfp_t flags, int node,
 					 unsigned long caller) __alloc_size(1);
-#define kmalloc_node_track_caller(size, flags, node) \
-	__kmalloc_node_track_caller(size, flags, node, \
-			_RET_IP_)
+#define kmalloc_node_track_caller(size, flags, node)	\
+	kmalloc_hooks(__kmalloc_node_track_caller(size, flags, node, _RET_IP_))
 
 #else /* CONFIG_NUMA */
 
-#define kmalloc_node_track_caller(size, flags, node) \
+#define kmalloc_node_track_caller(size, flags, node)	\
 	kmalloc_track_caller(size, flags)
 
 #endif /* CONFIG_NUMA */
@@ -750,20 +771,16 @@ extern void *__kmalloc_node_track_caller(size_t size, gfp_t flags, int node,
 /*
  * Shortcuts
  */
-static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
-{
-	return kmem_cache_alloc(k, flags | __GFP_ZERO);
-}
+#define kmem_cache_zalloc(_k, _flags)			\
+	kmem_cache_alloc(_k, (_flags)|__GFP_ZERO)
 
 /**
  * kzalloc - allocate memory. The memory is set to zero.
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1) void *kzalloc(size_t size, gfp_t flags)
-{
-	return kmalloc(size, flags | __GFP_ZERO);
-}
+#define kzalloc(_size, _flags)				\
+	kmalloc(_size, (_flags)|__GFP_ZERO)
 
 /**
  * kzalloc_node - allocate zeroed memory from a particular memory node.
@@ -771,10 +788,12 @@ static inline __alloc_size(1) void *kzalloc(size_t size, gfp_t flags)
  * @flags: the type of memory to allocate (see kmalloc).
  * @node: memory node from which to allocate
  */
-static inline __alloc_size(1) void *kzalloc_node(size_t size, gfp_t flags, int node)
+static inline __alloc_size(1) void *_kzalloc_node(size_t size, gfp_t flags, int node)
 {
-	return kmalloc_node(size, flags | __GFP_ZERO, node);
+	return _kmalloc_node(size, flags | __GFP_ZERO, node);
 }
+#define kzalloc_node(_size, _flags, _node)              \
+	kmalloc_hooks(_kzalloc_node(_size, _flags, _node))
 
 extern void *kvmalloc_node(size_t size, gfp_t flags, int node) __alloc_size(1);
 static inline __alloc_size(1) void *kvmalloc(size_t size, gfp_t flags)
diff --git a/mm/slab.c b/mm/slab.c
index ba97aeef7ec1..db344de3b260 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3402,6 +3402,7 @@ static __always_inline void __cache_free(struct kmem_cache *cachep, void *objp,
 
 	if (is_kfence_address(objp)) {
 		kmemleak_free_recursive(objp, cachep->flags);
+		slab_tag_dec(objp);
 		__kfence_free(objp);
 		return;
 	}
@@ -3433,6 +3434,7 @@ void ___cache_free(struct kmem_cache *cachep, void *objp,
 
 	check_irq_off();
 	kmemleak_free_recursive(objp, cachep->flags);
+	slab_tag_dec(objp);
 	objp = cache_free_debugcheck(cachep, objp, caller);
 
 	/*
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 272eda62ecaa..7b6473db5ab4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -938,7 +938,7 @@ gfp_t kmalloc_fix_flags(gfp_t flags)
  * directly to the page allocator. We use __GFP_COMP, because we will need to
  * know the allocation order to free the pages properly in kfree.
  */
-void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
+void *_kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 {
 	void *ret = NULL;
 	struct page *page;
@@ -958,16 +958,16 @@ void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 	kmemleak_alloc(ret, size, 1, flags);
 	return ret;
 }
-EXPORT_SYMBOL(kmalloc_order);
+EXPORT_SYMBOL(_kmalloc_order);
 
 #ifdef CONFIG_TRACING
-void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
+void *_kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 {
-	void *ret = kmalloc_order(size, flags, order);
+	void *ret = _kmalloc_order(size, flags, order);
 	trace_kmalloc(_RET_IP_, ret, NULL, size, PAGE_SIZE << order, flags);
 	return ret;
 }
-EXPORT_SYMBOL(kmalloc_order_trace);
+EXPORT_SYMBOL(_kmalloc_order_trace);
 #endif
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
@@ -1187,7 +1187,7 @@ static __always_inline void *__do_krealloc(const void *p, size_t new_size,
 		return (void *)p;
 	}
 
-	ret = kmalloc_track_caller(new_size, flags);
+	ret = __kmalloc_track_caller(new_size, flags, _RET_IP_);
 	if (ret && p) {
 		/* Disable KASAN checks as the object's redzone is accessed. */
 		kasan_disable_current();
@@ -1211,7 +1211,7 @@ static __always_inline void *__do_krealloc(const void *p, size_t new_size,
  *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
+void *_krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
 
@@ -1226,7 +1226,7 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
 
 	return ret;
 }
-EXPORT_SYMBOL(krealloc);
+EXPORT_SYMBOL(_krealloc);
 
 /**
  * kfree_sensitive - Clear sensitive information in memory before freeing
diff --git a/mm/slob.c b/mm/slob.c
index 2bd4f476c340..23b49f6c9c8f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -554,6 +554,7 @@ void kfree(const void *block)
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 	kmemleak_free(block);
+	slab_tag_dec(block);
 
 	sp = virt_to_folio(block);
 	if (folio_test_slab(sp)) {
@@ -680,6 +681,7 @@ static void kmem_rcu_free(struct rcu_head *head)
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
 	kmemleak_free_recursive(b, c->flags);
+	slab_tag_dec(b);
 	trace_kmem_cache_free(_RET_IP_, b, c->name);
 	if (unlikely(c->flags & SLAB_TYPESAFE_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
diff --git a/mm/slub.c b/mm/slub.c
index 80199d5ac7c9..caf752087ad6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1715,6 +1715,7 @@ static inline void *kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
 static __always_inline void kfree_hook(void *x)
 {
 	kmemleak_free(x);
+	slab_tag_dec(x);
 	kasan_kfree_large(x);
 }
 
@@ -1722,6 +1723,7 @@ static __always_inline bool slab_free_hook(struct kmem_cache *s,
 						void *x, bool init)
 {
 	kmemleak_free_recursive(x, s->flags);
+	slab_tag_dec(x);
 
 	debug_check_no_locks_freed(x, s->object_size);
 
-- 
2.37.2.672.g94769d06f0-goog

