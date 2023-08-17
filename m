Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E0977EF8C
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 05:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347849AbjHQDbX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 23:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347851AbjHQDbL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 23:31:11 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 229272686
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 20:31:05 -0700 (PDT)
Received: from loongson.cn (unknown [112.20.109.102])
        by gateway (Coremail) with SMTP id _____8Bx5fB4lN1kH1wZAA--.52240S3;
        Thu, 17 Aug 2023 11:31:04 +0800 (CST)
Received: from [192.168.100.8] (unknown [112.20.109.102])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxJ8x0lN1kmXRcAA--.55498S3;
        Thu, 17 Aug 2023 11:31:02 +0800 (CST)
Message-ID: <61a85639-8716-4df0-80f4-5a58620a049f@loongson.cn>
Date:   Thu, 17 Aug 2023 11:31:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] mm: Convert free_huge_page() to
 free_huge_folio()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-4-willy@infradead.org>
From:   Yanteng Si <siyanteng@loongson.cn>
In-Reply-To: <20230816151201.3655946-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxJ8x0lN1kmXRcAA--.55498S3
X-CM-SenderInfo: pvl1t0pwhqwqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj9fXoW3CF1rGF1xJrW7ZFWxWr1Utwc_yoW8GF1xto
        WftwsFva1fGF13tr48GryDtF1UWayYk3yrJa13Cr1kAF17Zrn0vw47tF98Jr97uFW5WF1x
        CFW8J34fKF97JFn3l-sFpf9Il3svdjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUY67kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWU
        XVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
        kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
        6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
        vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kfnx
        nUUI43ZEXa7IU8hiSPUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


在 2023/8/16 23:11, Matthew Wilcox (Oracle) 写道:
> Pass a folio instead of the head page to save a few instructions.
> Update the documentation, at least in English.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Yanteng Si <siyanteng@loongson.cn>
> ---
>   Documentation/mm/hugetlbfs_reserv.rst         | 14 +++---
>   .../zh_CN/mm/hugetlbfs_reserv.rst             |  4 +-
>   include/linux/hugetlb.h                       |  2 +-
>   mm/hugetlb.c                                  | 48 +++++++++----------
>   mm/page_alloc.c                               |  2 +-
>   5 files changed, 34 insertions(+), 36 deletions(-)
>
> diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
> index d9c2b0f01dcd..4914fbf07966 100644
> --- a/Documentation/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/mm/hugetlbfs_reserv.rst
> @@ -271,12 +271,12 @@ to the global reservation count (resv_huge_pages).
>   Freeing Huge Pages
>   ==================
>   
> -Huge page freeing is performed by the routine free_huge_page().  This routine
> -is the destructor for hugetlbfs compound pages.  As a result, it is only
> -passed a pointer to the page struct.  When a huge page is freed, reservation
> -accounting may need to be performed.  This would be the case if the page was
> -associated with a subpool that contained reserves, or the page is being freed
> -on an error path where a global reserve count must be restored.
> +Huge pages are freed by free_huge_folio().  It is only passed a pointer
> +to the folio as it is called from the generic MM code.  When a huge page
> +is freed, reservation accounting may need to be performed.  This would
> +be the case if the page was associated with a subpool that contained
> +reserves, or the page is being freed on an error path where a global
> +reserve count must be restored.
>   
>   The page->private field points to any subpool associated with the page.
>   If the PagePrivate flag is set, it indicates the global reserve count should
> @@ -525,7 +525,7 @@ However, there are several instances where errors are encountered after a huge
>   page is allocated but before it is instantiated.  In this case, the page
>   allocation has consumed the reservation and made the appropriate subpool,
>   reservation map and global count adjustments.  If the page is freed at this
> -time (before instantiation and clearing of PagePrivate), then free_huge_page
> +time (before instantiation and clearing of PagePrivate), then free_huge_folio
>   will increment the global reservation count.  However, the reservation map
>   indicates the reservation was consumed.  This resulting inconsistent state
>   will cause the 'leak' of a reserved huge page.  The global reserve count will
> diff --git a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> index b7a0544224ad..0f7e7fb5ca8c 100644
> --- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> @@ -219,7 +219,7 @@ vma_commit_reservation()之间，预留映射有可能被改变。如果hugetlb_
>   释放巨页
>   ========
>   
> -巨页释放是由函数free_huge_page()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
> +巨页释放是由函数free_huge_folio()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
>   递一个指向页面结构体的指针。当一个巨页被释放时，可能需要进行预留计算。如果该页与包含保
>   留的子池相关联，或者该页在错误路径上被释放，必须恢复全局预留计数，就会出现这种情况。
@@ -219,9 +219,10 @@ 
vma_commit_reservation()之间，预留映射有可能被改变。如果hugetlb_
  释放巨页
  ========

-巨页释放是由函数free_huge_page()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
-递一个指向页面结构体的指针。当一个巨页被释放时，可能需要进行预留计算。如果该页与包含保
-留的子池相关联，或者该页在错误路径上被释放，必须恢复全局预留计数，就会出现这种情况。
+巨页由free_huge_folio()释放。从公共MM代码中调用free_huge_folio()时，只会传递一个folio
+（物理连续、虚拟连续的2^n次的PAGE_SIZE的一些bytes的集合，当然这个n也是允许是0的）指针。
+当一个巨页被释放时，可能需要进行预留计算。如果该页与包含保留的子池相关联，或者该页在错
+误路径上被释放，必须恢复全局预留计数，就会出现这种情况。

  page->private字段指向与该页相关的任何子池。如果PagePrivate标志被设置，它表明全局预留计数

  应该被调整（关于如何设置这些标志的信息，请参见



Thanks,

Yanteng

>   
> @@ -387,7 +387,7 @@ region_count()在解除私有巨页映射时被调用。在私有映射中，预
>   
>   然而，有几种情况是，在一个巨页被分配后，但在它被实例化之前，就遇到了错误。在这种情况下，
>   页面分配已经消耗了预留，并进行了适当的子池、预留映射和全局计数调整。如果页面在这个时候被释放
> -（在实例化和清除PagePrivate之前），那么free_huge_page将增加全局预留计数。然而，预留映射
> +（在实例化和清除PagePrivate之前），那么free_huge_folio将增加全局预留计数。然而，预留映射
>   显示报留被消耗了。这种不一致的状态将导致预留的巨页的 “泄漏” 。全局预留计数将比它原本的要高，
>   并阻止分配一个预先分配的页面。
>   
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 5a1dfaffbd80..5b2626063f4f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -26,7 +26,7 @@ typedef struct { unsigned long pd; } hugepd_t;
>   #define __hugepd(x) ((hugepd_t) { (x) })
>   #endif
>   
> -void free_huge_page(struct page *page);
> +void free_huge_folio(struct folio *folio);
>   
>   #ifdef CONFIG_HUGETLB_PAGE
>   
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e327a5a7602c..086eb51bf845 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1706,10 +1706,10 @@ static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>   	zeroed = folio_put_testzero(folio);
>   	if (unlikely(!zeroed))
>   		/*
> -		 * It is VERY unlikely soneone else has taken a ref on
> -		 * the page.  In this case, we simply return as the
> -		 * hugetlb destructor (free_huge_page) will be called
> -		 * when this other ref is dropped.
> +		 * It is VERY unlikely soneone else has taken a ref
> +		 * on the folio.  In this case, we simply return as
> +		 * free_huge_folio() will be called when this other ref
> +		 * is dropped.
>   		 */
>   		return;
>   
> @@ -1875,13 +1875,12 @@ struct hstate *size_to_hstate(unsigned long size)
>   	return NULL;
>   }
>   
> -void free_huge_page(struct page *page)
> +void free_huge_folio(struct folio *folio)
>   {
>   	/*
>   	 * Can't pass hstate in here because it is called from the
>   	 * compound page destructor.
>   	 */
> -	struct folio *folio = page_folio(page);
>   	struct hstate *h = folio_hstate(folio);
>   	int nid = folio_nid(folio);
>   	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
> @@ -1936,7 +1935,7 @@ void free_huge_page(struct page *page)
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   		update_and_free_hugetlb_folio(h, folio, true);
>   	} else {
> -		arch_clear_hugepage_flags(page);
> +		arch_clear_hugepage_flags(&folio->page);
>   		enqueue_hugetlb_folio(h, folio);
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   	}
> @@ -2246,7 +2245,7 @@ static int alloc_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
>   		folio = alloc_fresh_hugetlb_folio(h, gfp_mask, node,
>   					nodes_allowed, node_alloc_noretry);
>   		if (folio) {
> -			free_huge_page(&folio->page); /* free it into the hugepage allocator */
> +			free_huge_folio(folio); /* free it into the hugepage allocator */
>   			return 1;
>   		}
>   	}
> @@ -2429,13 +2428,13 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   	 * We could have raced with the pool size change.
>   	 * Double check that and simply deallocate the new page
>   	 * if we would end up overcommiting the surpluses. Abuse
> -	 * temporary page to workaround the nasty free_huge_page
> +	 * temporary page to workaround the nasty free_huge_folio
>   	 * codeflow
>   	 */
>   	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
>   		folio_set_hugetlb_temporary(folio);
>   		spin_unlock_irq(&hugetlb_lock);
> -		free_huge_page(&folio->page);
> +		free_huge_folio(folio);
>   		return NULL;
>   	}
>   
> @@ -2547,8 +2546,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>   	__must_hold(&hugetlb_lock)
>   {
>   	LIST_HEAD(surplus_list);
> -	struct folio *folio;
> -	struct page *page, *tmp;
> +	struct folio *folio, *tmp;
>   	int ret;
>   	long i;
>   	long needed, allocated;
> @@ -2608,21 +2606,21 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>   	ret = 0;
>   
>   	/* Free the needed pages to the hugetlb pool */
> -	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> +	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
>   		if ((--needed) < 0)
>   			break;
>   		/* Add the page to the hugetlb allocator */
> -		enqueue_hugetlb_folio(h, page_folio(page));
> +		enqueue_hugetlb_folio(h, folio);
>   	}
>   free:
>   	spin_unlock_irq(&hugetlb_lock);
>   
>   	/*
>   	 * Free unnecessary surplus pages to the buddy allocator.
> -	 * Pages have no ref count, call free_huge_page directly.
> +	 * Pages have no ref count, call free_huge_folio directly.
>   	 */
> -	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
> -		free_huge_page(page);
> +	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
> +		free_huge_folio(folio);
>   	spin_lock_irq(&hugetlb_lock);
>   
>   	return ret;
> @@ -2836,11 +2834,11 @@ static long vma_del_reservation(struct hstate *h,
>    * 2) No reservation was in place for the page, so hugetlb_restore_reserve is
>    *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
>    *
> - * In case 1, free_huge_page later in the error path will increment the
> - * global reserve count.  But, free_huge_page does not have enough context
> + * In case 1, free_huge_folio later in the error path will increment the
> + * global reserve count.  But, free_huge_folio does not have enough context
>    * to adjust the reservation map.  This case deals primarily with private
>    * mappings.  Adjust the reserve map here to be consistent with global
> - * reserve count adjustments to be made by free_huge_page.  Make sure the
> + * reserve count adjustments to be made by free_huge_folio.  Make sure the
>    * reserve map indicates there is a reservation present.
>    *
>    * In case 2, simply undo reserve map modifications done by alloc_hugetlb_folio.
> @@ -2856,7 +2854,7 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
>   			 * Rare out of memory condition in reserve map
>   			 * manipulation.  Clear hugetlb_restore_reserve so
>   			 * that global reserve count will not be incremented
> -			 * by free_huge_page.  This will make it appear
> +			 * by free_huge_folio.  This will make it appear
>   			 * as though the reservation for this folio was
>   			 * consumed.  This may prevent the task from
>   			 * faulting in the folio at a later time.  This
> @@ -3232,7 +3230,7 @@ static void __init gather_bootmem_prealloc(void)
>   		if (prep_compound_gigantic_folio(folio, huge_page_order(h))) {
>   			WARN_ON(folio_test_reserved(folio));
>   			prep_new_hugetlb_folio(h, folio, folio_nid(folio));
> -			free_huge_page(page); /* add to the hugepage allocator */
> +			free_huge_folio(folio); /* add to the hugepage allocator */
>   		} else {
>   			/* VERY unlikely inflated ref count on a tail page */
>   			free_gigantic_folio(folio, huge_page_order(h));
> @@ -3264,7 +3262,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
>   					&node_states[N_MEMORY], NULL);
>   			if (!folio)
>   				break;
> -			free_huge_page(&folio->page); /* free it into the hugepage allocator */
> +			free_huge_folio(folio); /* free it into the hugepage allocator */
>   		}
>   		cond_resched();
>   	}
> @@ -3542,7 +3540,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>   	while (count > persistent_huge_pages(h)) {
>   		/*
>   		 * If this allocation races such that we no longer need the
> -		 * page, free_huge_page will handle it by freeing the page
> +		 * page, free_huge_folio will handle it by freeing the page
>   		 * and reducing the surplus.
>   		 */
>   		spin_unlock_irq(&hugetlb_lock);
> @@ -3658,7 +3656,7 @@ static int demote_free_hugetlb_folio(struct hstate *h, struct folio *folio)
>   			prep_compound_page(subpage, target_hstate->order);
>   		folio_change_private(inner_folio, NULL);
>   		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
> -		free_huge_page(subpage);
> +		free_huge_folio(inner_folio);
>   	}
>   	mutex_unlock(&target_hstate->resize_lock);
>   
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 548c8016190b..b569fd5562aa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -620,7 +620,7 @@ void destroy_large_folio(struct folio *folio)
>   	enum compound_dtor_id dtor = folio->_folio_dtor;
>   
>   	if (folio_test_hugetlb(folio)) {
> -		free_huge_page(&folio->page);
> +		free_huge_folio(folio);
>   		return;
>   	}
>   

