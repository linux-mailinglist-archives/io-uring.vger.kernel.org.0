Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63011D1F1C
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 21:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbgEMT0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 15:26:37 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52721 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390658AbgEMT0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 15:26:36 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2020 15:26:35 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id EF1B2194094E;
        Wed, 13 May 2020 15:21:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 13 May 2020 15:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8bsMyx
        zfDx9Zr6FfUcGRIkLCnzWw0XKmR2trMWHzkT4=; b=TCiG3nuh0Q53KOHbhBhap9
        nWsQX29dr8w2sl+TSas6D8KQJPKvwNsPdiCJrCmf5cS2R4oIRA95TVcnQz3SiP8m
        xFv3XFxtj0oQ5lVEDApR9RUodkmJs4vE5Tz1Z6ZfWdrOZ9bwIOrwA3TCm3oAP+7f
        VHaK4s6IAtxCc1zj5tT63FjuU+bCFfPb6wNtbTCabVO3fPoYXOBMhen36bJ4o5fz
        EKKVFo8R3BGEyVHSNhj4r5geovsn31i1WadyxmQHZKNJYXs4mF6MfwUmJB7KcROb
        eedYsPN/u3PG8Arwc2Vlw3mTzrECm58gqFH6Ap1ZjdxIKUB1J6GYqaUn7NODx8iQ
        ==
X-ME-Sender: <xms:mki8XnnJfPr71IsGnPYfCUgxycY9Xcmu4mu5dCf23MqkPHHhdIiqgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefrvghkkhgr
    ucfgnhgsvghrghcuoehpvghnsggvrhhgsehikhhirdhfiheqnecuggftrfgrthhtvghrnh
    epgfffgeekteetvdejledufeelleeuudeigfevvdeileeludehiedugefhleehvdeunecu
    kfhppeekledrvdejrdeffedrudejfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehpvghnsggvrhhgsehikhhirdhfih
X-ME-Proxy: <xmx:mki8Xq2aprX_n819v_Dne_g1BYaC5iSg90Zhj7YyZ-qAaNAQlTxkUQ>
    <xmx:mki8Xtqhw5v-Vi1t0WSlxxUddQjtU7raolxSKzKcl52XmN41phzJBQ>
    <xmx:mki8XvkxkZv8P8i5CGCxbu1rIL7vah7wm3VpEerylPbDX0b7V1pr9w>
    <xmx:nEi8XvzCKsSm7fIuBHtUINQ7-G0IftIJjUGhGPGs8M0HkGyF0D2MrDGph_M>
Received: from localhost (89-27-33-173.bb.dnainternet.fi [89.27.33.173])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A9BA3280059;
        Wed, 13 May 2020 15:20:58 -0400 (EDT)
Date:   Wed, 13 May 2020 22:20:57 +0300
From:   Pekka Enberg <penberg@iki.fi>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
Message-ID: <20200513191919.GA10975@nero>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi,

On Wed, May 13, 2020 at 6:30 PM Jens Axboe <axboe@kernel.dk> wrote:
> > I turned the quick'n dirty from the other day into something a bit 
> > more done. Would be great if someone else could run some
> > performance testing with this, I get about a 10% boost on the pure
> > NOP benchmark with this. But that's just on my laptop in qemu, so
> > some real iron testing would be awesome.

On 5/13/20 8:42 PM, Jann Horn wrote:> +slab allocator people
> 10% boost compared to which allocator? Are you using CONFIG_SLUB?
 
On Wed, May 13, 2020 at 6:30 PM Jens Axboe <axboe@kernel.dk> wrote:
> > The idea here is to have a percpu alloc cache. There's two sets of 
> > state:
> > 
> > 1) Requests that have IRQ completion. preempt disable is not
> > enough there, we need to disable local irqs. This is a lot slower
> > in certain setups, so we keep this separate.
> > 
> > 2) No IRQ completion, we can get by with just disabling preempt.

On 5/13/20 8:42 PM, Jann Horn wrote:> +slab allocator people
> The SLUB allocator has percpu caching, too, and as long as you don't 
> enable any SLUB debugging or ASAN or such, and you're not hitting
> any slowpath processing, it doesn't even have to disable interrupts,
> it gets away with cmpxchg_double.

The struct io_kiocb is 240 bytes. I don't see a dedicated slab for it in
/proc/slabinfo on my machine, so it likely got merged to the kmalloc-256
cache. This means that there's 32 objects in the per-CPU cache. Jens, on
the other hand, made the cache much bigger:

+#define IO_KIOCB_CACHE_MAX 256

So I assume if someone does "perf record", they will see significant
reduction in page allocator activity with Jens' patch. One possible way
around that is forcing the page allocation order to be much higher. IOW,
something like the following completely untested patch:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979d9f977409..c3bf7b72026d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8143,7 +8143,7 @@ static int __init io_uring_init(void)
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
-	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_LARGE_ORDER);
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 6d454886bcaf..316fd821ec1f 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -39,6 +39,8 @@
 #define SLAB_STORE_USER		((slab_flags_t __force)0x00010000U)
 /* Panic if kmem_cache_create() fails */
 #define SLAB_PANIC		((slab_flags_t __force)0x00040000U)
+/* Force slab page allocation order to be as large as possible */
+#define SLAB_LARGE_ORDER	((slab_flags_t __force)0x00080000U)
 /*
  * SLAB_TYPESAFE_BY_RCU - **WARNING** READ THIS!
  *
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 23c7500eea7d..a18bbe9472e4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -51,7 +51,7 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | SLAB_KASAN)
+		SLAB_FAILSLAB | SLAB_KASAN | SLAB_LARGE_ORDER)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
diff --git a/mm/slub.c b/mm/slub.c
index b762450fc9f0..d1d86b1279aa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3318,12 +3318,15 @@ static inline unsigned int slab_order(unsigned int size,
 	return order;
 }
 
-static inline int calculate_order(unsigned int size)
+static inline int calculate_order(unsigned int size, gfp_t flags)
 {
 	unsigned int order;
 	unsigned int min_objects;
 	unsigned int max_objects;
 
+	if (flags & SLAB_LARGE_ORDER)
+		return slub_max_order;
+
 	/*
 	 * Attempt to find best configuration for a slab. This
 	 * works by first attempting to generate a layout with
@@ -3651,7 +3654,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	if (forced_order >= 0)
 		order = forced_order;
 	else
-		order = calculate_order(size);
+		order = calculate_order(size, flags);
 
 	if ((int)order < 0)
 		return 0;

- Pekka
