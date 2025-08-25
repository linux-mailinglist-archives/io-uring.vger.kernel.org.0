Return-Path: <io-uring+bounces-9286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC86B346FB
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 18:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DAC22A51BE
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 16:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA163002AC;
	Mon, 25 Aug 2025 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1X+B0ZG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2D72ECE8A;
	Mon, 25 Aug 2025 16:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138641; cv=none; b=SptbKSJop3H7dgWw1sL735/1gEinjzjDUprwQm+xPwGYIz5BQqS1la+ZzdpdyQqWHvXJbbKHZQJxzGDqFLeKeM0d3uPmzx6cNdCye0KYVKPVjQv7p2yasunQfr8+yNVJliOe5vHm9v8uqZlmuyCet75Xlo86rqV8WCVbj5E17UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138641; c=relaxed/simple;
	bh=FANVRTF6GTKZEwwkEPlW/tWs0ubXGJ7R1OcvtRKQmn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exXjb3hRCCddd9pnWyEM1lCdYwwTOq1uHNa87hzixgaPOPZaUmdcfACUnD6E/i0azY9+gQgJm44/RYe/CmXANipS+8B2ZFeZhl5JME324D+zb8lOLXNOPpk36G+eGiSYLlyjmr4CYxjxP1/LgckZ49wki91Xkp8Wii2hFXXCq08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1X+B0ZG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3323DC4CEED;
	Mon, 25 Aug 2025 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756138640;
	bh=FANVRTF6GTKZEwwkEPlW/tWs0ubXGJ7R1OcvtRKQmn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z1X+B0ZGv7uHOoHuOLd4SJt16FexWEbZsjEQFQqRUrapr3OCpVgaCrasYjPdbbOyy
	 eytOcCBL+pDQ3AWWdM11/NupldPVN7n787Ac52JA6muufv5Aq5hmbyZm6HiI3UG9/E
	 S3WLhadcDWFA0vrOLjkLNWku02BCbOZumOEeIy+mLkW7A9OWvR0HBF0JMJQllwxMjH
	 McwQict10AbNwzUaf3Fe4rhbDyKvQqV4mNkpdYsg1XXv1bkWDE2ZZQycNZSZHCAubw
	 xxCEDJgzUrllwHg0O5i5LR3vB8H9ddKiEeoiX5nxByJsLox/KvefidsYGinF192ZU3
	 LkZva/mIcA0xQ==
Date: Mon, 25 Aug 2025 19:17:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aKyMfvWe8JetkbRL@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
 <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
 <aKx6SlYrj_hiPXBB@kernel.org>
 <f8140a17-c4ec-489b-b314-d45abe48bf36@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8140a17-c4ec-489b-b314-d45abe48bf36@redhat.com>

On Mon, Aug 25, 2025 at 05:42:33PM +0200, David Hildenbrand wrote:
> On 25.08.25 16:59, Mike Rapoport wrote:
> > On Mon, Aug 25, 2025 at 04:38:03PM +0200, David Hildenbrand wrote:
> > > On 25.08.25 16:32, Mike Rapoport wrote:
> > > > On Mon, Aug 25, 2025 at 02:48:58PM +0200, David Hildenbrand wrote:
> > > > > On 23.08.25 10:59, Mike Rapoport wrote:
> > > > > > On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
> > > > > > > On 22.08.25 06:09, Mika Penttilä wrote:
> > > > > > > > 
> > > > > > > > On 8/21/25 23:06, David Hildenbrand wrote:
> > > > > > > > 
> > > > > > > > > All pages were already initialized and set to PageReserved() with a
> > > > > > > > > refcount of 1 by MM init code.
> > > > > > > > 
> > > > > > > > Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
> > > > > > > > initialize struct pages?
> > > > > > > 
> > > > > > > Excellent point, I did not know about that one.
> > > > > > > 
> > > > > > > Spotting that we don't do the same for the head page made me assume that
> > > > > > > it's just a misuse of __init_single_page().
> > > > > > > 
> > > > > > > But the nasty thing is that we use memblock_reserved_mark_noinit() to only
> > > > > > > mark the tail pages ...
> > > > > > 
> > > > > > And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
> > > > > > disabled struct pages are initialized regardless of
> > > > > > memblock_reserved_mark_noinit().
> > > > > > 
> > > > > > I think this patch should go in before your updates:
> > > > > 
> > > > > Shouldn't we fix this in memblock code?
> > > > > 
> > > > > Hacking around that in the memblock_reserved_mark_noinit() user sound wrong
> > > > > -- and nothing in the doc of memblock_reserved_mark_noinit() spells that
> > > > > behavior out.
> > > > 
> > > > We can surely update the docs, but unfortunately I don't see how to avoid
> > > > hacking around it in hugetlb.
> > > > Since it's used to optimise HVO even further to the point hugetlb open
> > > > codes memmap initialization, I think it's fair that it should deal with all
> > > > possible configurations.
> > > 
> > > Remind me, why can't we support memblock_reserved_mark_noinit() when
> > > CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled?
> > 
> > When CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled we initialize the entire
> > memmap early (setup_arch()->free_area_init()), and we may have a bunch of
> > memblock_reserved_mark_noinit() afterwards
> 
> Oh, you mean that we get effective memblock modifications after already
> initializing the memmap.
> 
> That sounds ... interesting :)

It's memmap, not the free lists. Without deferred init, memblock is active
for a while after memmap initialized and before the memory goes to the free
lists.
 
> So yeah, we have to document this for memblock_reserved_mark_noinit().
> 
> Is it also a problem for kexec_handover?

With KHO it's also interesting, but it does not support deferred struct
page init for now :)
 
> We should do something like:
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 154f1d73b61f2..ed4c563d72c32 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1091,13 +1091,16 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
>  /**
>   * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
> - * for this region.
> + * MEMBLOCK_RSRV_NOINIT which allows for the "struct pages" corresponding
> + * to this region not getting initialized, because the caller will take
> + * care of it.
>   * @base: the base phys addr of the region
>   * @size: the size of the region
>   *
> - * struct pages will not be initialized for reserved memory regions marked with
> - * %MEMBLOCK_RSRV_NOINIT.
> + * "struct pages" will not be initialized for reserved memory regions marked
> + * with %MEMBLOCK_RSRV_NOINIT if this function is called before initialization
> + * code runs. Without CONFIG_DEFERRED_STRUCT_PAGE_INIT, it is more likely
> + * that this function is not effective.
>   *
>   * Return: 0 on success, -errno on failure.
>   */

I have a different version :)
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b96746376e17..d20d091c6343 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
  * via a driver, and never indicated in the firmware-provided memory map as
  * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
  * kernel resource tree.
- * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
- * not initialized (only for reserved regions).
+ * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages don't have
+ * PG_Reserved set and are completely not initialized when
+ * %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled (only for reserved regions).
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
diff --git a/mm/memblock.c b/mm/memblock.c
index 154f1d73b61f..02de5ffb085b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1091,13 +1091,15 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
 
 /**
  * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
- * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
- * for this region.
+ * MEMBLOCK_RSRV_NOINIT
+ *
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * struct pages will not be initialized for reserved memory regions marked with
- * %MEMBLOCK_RSRV_NOINIT.
+ * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
+ * not have %PG_Reserved flag set.
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flags also
+ * completly bypasses the initialization of struct pages for this region.
  *
  * Return: 0 on success, -errno on failure.
  */
 
> Optimizing the hugetlb code could be done, but I am not sure how high
> the priority is (nobody complained so far about the double init).
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

