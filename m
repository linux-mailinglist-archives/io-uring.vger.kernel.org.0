Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCE65AA3C5
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 01:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiIAXg2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 19:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiIAXg1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 19:36:27 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBBBA3D35;
        Thu,  1 Sep 2022 16:36:25 -0700 (PDT)
Date:   Thu, 1 Sep 2022 16:35:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662075383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=InNX4damzKIXIFkKIPo7hosE+32IjNQo/Q1jqKqY1l0=;
        b=TfzaA6eaHfVGKKMSS994EkCVPN+PoxcM39qKI9TyTQjexgAwYlNFw7qqlpGMruhf3xUG9j
        SmJFtNE9aVX2nlE9sSq2OBVJu46ZbVXvsOT32de+wdRTt5xKC0OXHu10Bh4rLZAWRSqEDY
        yg+k8hWS3aEnNns1Xuo4Jx7O/CPoymA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     akpm@linux-foundation.org, kent.overstreet@linux.dev,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        mgorman@suse.de, dave@stgolabs.net, willy@infradead.org,
        liam.howlett@oracle.com, void@manifault.com, peterz@infradead.org,
        juri.lelli@redhat.com, ldufour@linux.ibm.com, peterx@redhat.com,
        david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        bristot@redhat.com, vschneid@redhat.com, cl@linux.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, arnd@arndb.de,
        jbaron@akamai.com, rientjes@google.com, minchan@google.com,
        kaleshsingh@google.com, kernel-team@android.com,
        linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/30] mm: introduce slabobj_ext to support slab
 object extensions
Message-ID: <YxFB3tlMqakx+hiL@P9FQF9L96D.corp.robot.car>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-12-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830214919.53220-12-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 30, 2022 at 02:49:00PM -0700, Suren Baghdasaryan wrote:
> Currently slab pages can store only vectors of obj_cgroup pointers in
> page->memcg_data. Introduce slabobj_ext structure to allow more data
> to be stored for each slab object. Wraps obj_cgroup into slabobj_ext
> to support current functionality while allowing to extend slabobj_ext
> in the future.
> 
> Note: ideally the config dependency should be turned the other way around:
> MEMCG should depend on SLAB_OBJ_EXT and {page|slab|folio}.memcg_data would
> be renamed to something like {page|slab|folio}.objext_data. However doing
> this in RFC would introduce considerable churn unrelated to the overall
> idea, so avoiding this until v1.

Hi Suren!

I'd say CONFIG_MEMCG_KMEM and CONFIG_YOUR_NEW_STUFF should both depend on
SLAB_OBJ_EXT.
CONFIG_MEMCG_KMEM depend on CONFIG_MEMCG anyway.

> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  include/linux/memcontrol.h |  18 ++++--
>  init/Kconfig               |   5 ++
>  mm/kfence/core.c           |   2 +-
>  mm/memcontrol.c            |  60 ++++++++++---------
>  mm/page_owner.c            |   2 +-
>  mm/slab.h                  | 119 +++++++++++++++++++++++++------------
>  6 files changed, 131 insertions(+), 75 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 6257867fbf95..315399f77173 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -227,6 +227,14 @@ struct obj_cgroup {
>  	};
>  };
>  
> +/*
> + * Extended information for slab objects stored as an array in page->memcg_data
> + * if MEMCG_DATA_OBJEXTS is set.
> + */
> +struct slabobj_ext {
> +	struct obj_cgroup *objcg;
> +} __aligned(8);

Why do we need this aligment requirement?

> +
>  /*
>   * The memory controller data structure. The memory controller controls both
>   * page cache and RSS per cgroup. We would eventually like to provide
> @@ -363,7 +371,7 @@ extern struct mem_cgroup *root_mem_cgroup;
>  
>  enum page_memcg_data_flags {
>  	/* page->memcg_data is a pointer to an objcgs vector */
> -	MEMCG_DATA_OBJCGS = (1UL << 0),
> +	MEMCG_DATA_OBJEXTS = (1UL << 0),
>  	/* page has been accounted as a non-slab kernel page */
>  	MEMCG_DATA_KMEM = (1UL << 1),
>  	/* the next bit after the last actual flag */
> @@ -401,7 +409,7 @@ static inline struct mem_cgroup *__folio_memcg(struct folio *folio)
>  	unsigned long memcg_data = folio->memcg_data;
>  
>  	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
> -	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJCGS, folio);
> +	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
>  	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_KMEM, folio);
>  
>  	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
> @@ -422,7 +430,7 @@ static inline struct obj_cgroup *__folio_objcg(struct folio *folio)
>  	unsigned long memcg_data = folio->memcg_data;
>  
>  	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
> -	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJCGS, folio);
> +	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
>  	VM_BUG_ON_FOLIO(!(memcg_data & MEMCG_DATA_KMEM), folio);
>  
>  	return (struct obj_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
> @@ -517,7 +525,7 @@ static inline struct mem_cgroup *page_memcg_check(struct page *page)
>  	 */
>  	unsigned long memcg_data = READ_ONCE(page->memcg_data);
>  
> -	if (memcg_data & MEMCG_DATA_OBJCGS)
> +	if (memcg_data & MEMCG_DATA_OBJEXTS)
>  		return NULL;
>  
>  	if (memcg_data & MEMCG_DATA_KMEM) {
> @@ -556,7 +564,7 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
>  static inline bool folio_memcg_kmem(struct folio *folio)
>  {
>  	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
> -	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJCGS, folio);
> +	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>  	return folio->memcg_data & MEMCG_DATA_KMEM;
>  }
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index 532362fcfe31..82396d7a2717 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -958,6 +958,10 @@ config MEMCG
>  	help
>  	  Provides control over the memory footprint of tasks in a cgroup.
>  
> +config SLAB_OBJ_EXT
> +	bool
> +	depends on MEMCG
> +
>  config MEMCG_SWAP
>  	bool
>  	depends on MEMCG && SWAP
> @@ -966,6 +970,7 @@ config MEMCG_SWAP
>  config MEMCG_KMEM
>  	bool
>  	depends on MEMCG && !SLOB
> +	select SLAB_OBJ_EXT
>  	default y
>  
>  config BLK_CGROUP
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index c252081b11df..c0958e4a32e2 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -569,7 +569,7 @@ static unsigned long kfence_init_pool(void)
>  		__folio_set_slab(slab_folio(slab));
>  #ifdef CONFIG_MEMCG
>  		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
> -				   MEMCG_DATA_OBJCGS;
> +				   MEMCG_DATA_OBJEXTS;
>  #endif
>  	}
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b69979c9ced5..3f407ef2f3f1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2793,7 +2793,7 @@ static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>  	folio->memcg_data = (unsigned long)memcg;
>  }
>  
> -#ifdef CONFIG_MEMCG_KMEM
> +#ifdef CONFIG_SLAB_OBJ_EXT
>  /*
>   * The allocated objcg pointers array is not accounted directly.
>   * Moreover, it should not come from DMA buffer and is not readily
> @@ -2801,38 +2801,20 @@ static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>   */
>  #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
>  
> -/*
> - * mod_objcg_mlstate() may be called with irq enabled, so
> - * mod_memcg_lruvec_state() should be used.
> - */
> -static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
> -				     struct pglist_data *pgdat,
> -				     enum node_stat_item idx, int nr)
> -{
> -	struct mem_cgroup *memcg;
> -	struct lruvec *lruvec;
> -
> -	rcu_read_lock();
> -	memcg = obj_cgroup_memcg(objcg);
> -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	mod_memcg_lruvec_state(lruvec, idx, nr);
> -	rcu_read_unlock();
> -}
> -
> -int memcg_alloc_slab_cgroups(struct slab *slab, struct kmem_cache *s,
> -				 gfp_t gfp, bool new_slab)
> +int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> +			gfp_t gfp, bool new_slab)
>  {
>  	unsigned int objects = objs_per_slab(s, slab);
>  	unsigned long memcg_data;
>  	void *vec;
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
> -	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
> +	vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
>  			   slab_nid(slab));
>  	if (!vec)
>  		return -ENOMEM;
>  
> -	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJCGS;
> +	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJEXTS;
>  	if (new_slab) {
>  		/*
>  		 * If the slab is brand new and nobody can yet access its
> @@ -2843,7 +2825,7 @@ int memcg_alloc_slab_cgroups(struct slab *slab, struct kmem_cache *s,
>  	} else if (cmpxchg(&slab->memcg_data, 0, memcg_data)) {
>  		/*
>  		 * If the slab is already in use, somebody can allocate and
> -		 * assign obj_cgroups in parallel. In this case the existing
> +		 * assign slabobj_exts in parallel. In this case the existing
>  		 * objcg vector should be reused.
>  		 */
>  		kfree(vec);
> @@ -2853,6 +2835,26 @@ int memcg_alloc_slab_cgroups(struct slab *slab, struct kmem_cache *s,
>  	kmemleak_not_leak(vec);
>  	return 0;
>  }
> +#endif /* CONFIG_SLAB_OBJ_EXT */
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +/*
> + * mod_objcg_mlstate() may be called with irq enabled, so
> + * mod_memcg_lruvec_state() should be used.
> + */
> +static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
> +				     struct pglist_data *pgdat,
> +				     enum node_stat_item idx, int nr)
> +{
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	mod_memcg_lruvec_state(lruvec, idx, nr);
> +	rcu_read_unlock();
> +}
>  
>  static __always_inline
>  struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
> @@ -2863,18 +2865,18 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
>  	 * slab->memcg_data.
>  	 */
>  	if (folio_test_slab(folio)) {
> -		struct obj_cgroup **objcgs;
> +		struct slabobj_ext *obj_exts;
>  		struct slab *slab;
>  		unsigned int off;
>  
>  		slab = folio_slab(folio);
> -		objcgs = slab_objcgs(slab);
> -		if (!objcgs)
> +		obj_exts = slab_obj_exts(slab);
> +		if (!obj_exts)
>  			return NULL;
>  
>  		off = obj_to_index(slab->slab_cache, slab, p);
> -		if (objcgs[off])
> -			return obj_cgroup_memcg(objcgs[off]);
> +		if (obj_exts[off].objcg)
> +			return obj_cgroup_memcg(obj_exts[off].objcg);
>  
>  		return NULL;
>  	}
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index e4c6f3f1695b..fd4af1ad34b8 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -353,7 +353,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  	if (!memcg_data)
>  		goto out_unlock;
>  
> -	if (memcg_data & MEMCG_DATA_OBJCGS)
> +	if (memcg_data & MEMCG_DATA_OBJEXTS)
>  		ret += scnprintf(kbuf + ret, count - ret,
>  				"Slab cache page\n");
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index 4ec82bec15ec..c767ce3f0fe2 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -422,36 +422,94 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
>  	return false;
>  }
>  
> +#ifdef CONFIG_SLAB_OBJ_EXT
> +
> +static inline bool is_kmem_only_obj_ext(void)
> +{
>  #ifdef CONFIG_MEMCG_KMEM
> +	return sizeof(struct slabobj_ext) == sizeof(struct obj_cgroup *);
> +#else
> +	return false;
> +#endif
> +}
> +
>  /*
> - * slab_objcgs - get the object cgroups vector associated with a slab
> + * slab_obj_exts - get the pointer to the slab object extension vector
> + * associated with a slab.
>   * @slab: a pointer to the slab struct
>   *
> - * Returns a pointer to the object cgroups vector associated with the slab,
> + * Returns a pointer to the object extension vector associated with the slab,
>   * or NULL if no such vector has been associated yet.
>   */
> -static inline struct obj_cgroup **slab_objcgs(struct slab *slab)
> +static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
>  {
>  	unsigned long memcg_data = READ_ONCE(slab->memcg_data);
>  
> -	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS),
> +	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJEXTS),
>  							slab_page(slab));
>  	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, slab_page(slab));
>  
> -	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
> +	return (struct slabobj_ext *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
>  }
>  
> -int memcg_alloc_slab_cgroups(struct slab *slab, struct kmem_cache *s,
> -				 gfp_t gfp, bool new_slab);
> -void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
> -		     enum node_stat_item idx, int nr);
> +int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> +			gfp_t gfp, bool new_slab);
>  
> -static inline void memcg_free_slab_cgroups(struct slab *slab)
> +static inline void free_slab_obj_exts(struct slab *slab)
>  {
> -	kfree(slab_objcgs(slab));
> +	struct slabobj_ext *obj_exts;
> +
> +	if (!memcg_kmem_enabled() && is_kmem_only_obj_ext())
> +		return;

Hm, not sure I understand this. I kmem is disabled and is_kmem_only_obj_ext()
is true, shouldn't slab->memcg_data == NULL (always)?

> +
> +	obj_exts = slab_obj_exts(slab);
> +	kfree(obj_exts);
>  	slab->memcg_data = 0;
>  }
>  
> +static inline void prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
> +{
> +	struct slab *slab;
> +
> +	/* If kmem is the only extension then the vector will be created conditionally */
> +	if (is_kmem_only_obj_ext())
> +		return;
> +
> +	slab = virt_to_slab(p);
> +	if (!slab_obj_exts(slab))
> +		WARN(alloc_slab_obj_exts(slab, s, flags, false),
> +			"%s, %s: Failed to create slab extension vector!\n",
> +			__func__, s->name);
> +}

This looks a bit crypric: the action is wrapped into WARN() and the rest is a set
of (semi-)static checks. Can we, please, invert it? E.g. something like:

if (slab_alloc_tracking_enabled()) {
	slab = virt_to_slab(p);
	if (!slab_obj_exts(slab))
		WARN(alloc_slab_obj_exts(slab, s, flags, false),
		"%s, %s: Failed to create slab extension vector!\n",
		__func__, s->name);
}

The rest looks good to me.

Thank you!
