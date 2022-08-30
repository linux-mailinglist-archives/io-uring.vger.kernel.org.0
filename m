Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE05A6FD7
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiH3Vvv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiH3VvG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:51:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED08E18B31
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-336c3b72da5so187501697b3.6
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=lEzLHp5EUALGBDR080eL/ZTXye/B6ScLofp8WoGZutw=;
        b=b1R/0Nzef/8svLYP03pWrgs7vVHFpmq4XPsUT6SPRcEERNTFUBKXL3gF3rV3lAxbCu
         zXGaLab/bgugeQVtB6fQn7BhC15GHiYy8yfVXRL4GYXQsnil0/qsZR4erD7n1daSxUT/
         hbKk1xyU9Ykc1njB28pQzjTGt5yf81XdbMvnJj3jJrZZVKL0FDy5ZPsMSVZCq6qj2GNq
         5xqR3jFoEpuD7VZT5PIkQzsQQ7XeVpMK6yxsDE98VmdfDUzKzdP+i7iVBsy7CZO0ECYl
         ds6ZVkTkDhj6OOx/cOiCWsxrgV2NyVoWxYPRsclO00W2nRWfmYoOg0iJH72Y79yCTeat
         6jXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=lEzLHp5EUALGBDR080eL/ZTXye/B6ScLofp8WoGZutw=;
        b=guOlqXcyEI9Dpwxnfav79KM80vN+ldz2tv/6oP1pw6j8qkqecPgIjVWxVcQ8Vqrhjs
         jwUauTwHQPVjMzgEU/K7mYd/bgtLkS8m++o5DxVgnD0oCr+cg29lI67/a6pn4Hr4LZxS
         /x9MbICrFyE6Eb9TxnX8UlXpYox1LFarAjoSNDjzVF3U+p5on4OaqOx8m3ySWlLmEf1f
         0vQvrFiothGcwRKZ4t1/Zx7F7PlTXLesrk85pUfM21kvcfEwJuDkLybWRz7AgvPGU38q
         tHk5V8xFswn++2xqzSBjRr/+AIcTT3QUJE3Xyl7amFGnabT9Ti5WqCe49Dcsmx1v7bLt
         DVCA==
X-Gm-Message-State: ACgBeo3sr4bPpxYV6NQVmxasWpzB7ytW8LonJXVeNwgdZvYRz9I9PUd+
        N5wGkQuaCG/UCJTXcqu14GRQ6UbmRws=
X-Google-Smtp-Source: AA6agR5aFDFTV93gABXVtI6sO2HuTqIfM7XjbTB1z4Gt/hzYUN7LO58jr4g2RITDfY5OEI/Zy7OiK9gpPj0=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a05:6902:89:b0:695:7ed0:d8cb with SMTP id
 h9-20020a056902008900b006957ed0d8cbmr13360099ybs.77.1661896198026; Tue, 30
 Aug 2022 14:49:58 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:02 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-14-surenb@google.com>
Subject: [RFC PATCH 13/30] mm/slab: introduce SLAB_NO_OBJ_EXT to avoid obj_ext creation
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

Slab extension objects can't be allocated before slab infrastructure is
initialized. Some caches, like kmem_cache and kmem_cache_node, are created
before slab infrastructure is initialized. Objects from these caches can't
have extension objects. Introduce SLAB_NO_OBJ_EXT slab flag to mark these
caches and avoid creating extensions for objects allocated from these
slabs.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/slab.h | 7 +++++++
 mm/slab.c            | 2 +-
 mm/slub.c            | 5 +++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0fefdf528e0d..55ae3ea864a4 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -124,6 +124,13 @@
 #define SLAB_RECLAIM_ACCOUNT	((slab_flags_t __force)0x00020000U)
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
+#ifdef CONFIG_SLAB_OBJ_EXT
+/* Slab created using create_boot_cache */
+#define SLAB_NO_OBJ_EXT         ((slab_flags_t __force)0x20000000U)
+#else
+#define SLAB_NO_OBJ_EXT         0
+#endif
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
diff --git a/mm/slab.c b/mm/slab.c
index 10e96137b44f..ba97aeef7ec1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1233,7 +1233,7 @@ void __init kmem_cache_init(void)
 	create_boot_cache(kmem_cache, "kmem_cache",
 		offsetof(struct kmem_cache, node) +
 				  nr_node_ids * sizeof(struct kmem_cache_node *),
-				  SLAB_HWCACHE_ALIGN, 0, 0);
+				  SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 	list_add(&kmem_cache->list, &slab_caches);
 	slab_state = PARTIAL;
 
diff --git a/mm/slub.c b/mm/slub.c
index 862dbd9af4f5..80199d5ac7c9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4825,7 +4825,8 @@ void __init kmem_cache_init(void)
 		node_set(node, slab_nodes);
 
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
-		sizeof(struct kmem_cache_node), SLAB_HWCACHE_ALIGN, 0, 0);
+			sizeof(struct kmem_cache_node),
+			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
 	register_hotmemory_notifier(&slab_memory_callback_nb);
 
@@ -4835,7 +4836,7 @@ void __init kmem_cache_init(void)
 	create_boot_cache(kmem_cache, "kmem_cache",
 			offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *),
-		       SLAB_HWCACHE_ALIGN, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
 	kmem_cache = bootstrap(&boot_kmem_cache);
 	kmem_cache_node = bootstrap(&boot_kmem_cache_node);
-- 
2.37.2.672.g94769d06f0-goog

