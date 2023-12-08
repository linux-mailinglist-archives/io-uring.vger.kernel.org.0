Return-Path: <io-uring+bounces-266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 963EB80AB49
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 18:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B4442818F3
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 17:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC64A3C68F;
	Fri,  8 Dec 2023 17:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c87Ek+Z3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A3r9CKYS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="paPwkCqf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3S+flWCe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7429810EB
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 09:54:21 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C08ED1F461;
	Fri,  8 Dec 2023 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702058060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LN1lcvJTjbU3YyrvMi7MvzurPdPogMJu3L2Ox02wf3c=;
	b=c87Ek+Z3AV07FzjVsXlqzL1yVz8U0EHMLBxnIEOmcdPVc56l9vYRIEO1FhTDFSWdNEe+02
	CPDs4FG/pXwx6mEx9pOQjZwIeeBcksa34P1q8m+Ogn/KWdYTpKvclfq00oqSV6tREMHBkv
	nEXPh7ra05MhzE6/3l1nKP+F6UjXzjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702058060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LN1lcvJTjbU3YyrvMi7MvzurPdPogMJu3L2Ox02wf3c=;
	b=A3r9CKYSxvckyYG1LMy2QyxbLlle+ByULP/d49OYGLncif19e9toiDRSRqSHfWai4Q5n+3
	d/CQJFUZbn36AhAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702058059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LN1lcvJTjbU3YyrvMi7MvzurPdPogMJu3L2Ox02wf3c=;
	b=paPwkCqfYK4o1HGQVN34N0yejG1EbktTPlUNaLi+v9Fm6OdYcl4b3kIHskuS7bPVJ5bopP
	GcmEyUcU6FvN6TqX7pDqKHL8KTgYC+u67Cm2gXnaBNFedZhYyrIiMSXe1GeQfH5UHZfdzF
	r7GDg+J3Y83gSqoIZYsP7MPVvLZ7His=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702058059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LN1lcvJTjbU3YyrvMi7MvzurPdPogMJu3L2Ox02wf3c=;
	b=3S+flWCeZDB0K/vRudJM02qUZcqkm6y92M2W48rPrEe72OG3OYL76Tqqr46QMsozFdu8ku
	HkAA+wz1N+SHfiDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7D5613335;
	Fri,  8 Dec 2023 17:54:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U0GXKEtYc2UiIwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Dec 2023 17:54:19 +0000
Message-ID: <8fa1c95c-4749-33dd-42ba-243e492ab109@suse.cz>
Date: Fri, 8 Dec 2023 18:54:19 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Kravetz <mike.kravetz@oracle.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Oscar Salvador <osalvador@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-mm@kvack.org
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230816151201.3655946-8-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: 8.19
X-Spamd-Result: default: False [2.29 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	 TO_DN_SOME(0.00)[];
	 R_SPF_SOFTFAIL(4.60)[~all];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 NEURAL_HAM_SHORT(-0.20)[-0.994];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.cz];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spamd-Bar: ++
X-Rspamd-Server: rspamd1
X-Spam-Flag: NO
X-Rspamd-Queue-Id: C08ED1F461
X-Spam-Score: 2.29
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=paPwkCqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3S+flWCe;
	spf=softfail (smtp-out2.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of vbabka@suse.cz) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none

On 8/16/23 17:11, Matthew Wilcox (Oracle) wrote:
> We can use a bit in page[1].flags to indicate that this folio belongs
> to hugetlb instead of using a value in page[1].dtors.  That lets
> folio_test_hugetlb() become an inline function like it should be.
> We can also get rid of NULL_COMPOUND_DTOR.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I think this (as commit 9c5ccf2db04b ("mm: remove HUGETLB_PAGE_DTOR")) is
causing the bug reported by Luis here:
https://bugzilla.kernel.org/show_bug.cgi?id=218227

> page:000000009006bf10 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x3f8a0 pfn:0x1035c0
> flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
> page_type: 0xffffff7f(buddy)
> raw: 017fffc000000000 ffffe704c422f808 ffffe704c41ac008 0000000000000000
> raw: 000000000003f8a0 0000000000000005 00000000ffffff7f 0000000000000000
> page dumped because: VM_BUG_ON_PAGE(n > 0 && !((__builtin_constant_p(PG_head) && __builtin_constant_p((uintptr_t)(&page->flags) != (uintptr_t)((vo>
> ------------[ cut here ]------------
> kernel BUG at include/linux/page-flags.h:314!
> invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 6 PID: 2435641 Comm: md5sum Not tainted 6.6.0-rc5 #2
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:folio_flags+0x65/0x70
> Code: a8 40 74 de 48 8b 47 48 a8 01 74 d6 48 83 e8 01 48 39 c7 75 bd eb cb 48 8b 07 a8 40 75 c8 48 c7 c6 d8 a7 c3 89 e8 3b c7 fa ff <0f> 0b 66 0f >
> RSP: 0018:ffffad51c0bfb7a8 EFLAGS: 00010246
> RAX: 000000000000015f RBX: ffffe704c40d7000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff89be8040 RDI: 00000000ffffffff
> RBP: 0000000000103600 R08: 0000000000000000 R09: ffffad51c0bfb658
> R10: 0000000000000003 R11: ffffffff89eacb08 R12: 0000000000000035
> R13: ffffe704c40d7000 R14: 0000000000000000 R15: ffffad51c0bfb930
> FS:  00007f350c51b740(0000) GS:ffff9b62fbd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555860919508 CR3: 00000001217fe002 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? die+0x32/0x80
>  ? do_trap+0xd6/0x100
>  ? folio_flags+0x65/0x70
>  ? do_error_trap+0x6a/0x90
>  ? folio_flags+0x65/0x70
>  ? exc_invalid_op+0x4c/0x60
>  ? folio_flags+0x65/0x70
>  ? asm_exc_invalid_op+0x16/0x20
>  ? folio_flags+0x65/0x70
>  ? folio_flags+0x65/0x70
>  PageHuge+0x67/0x80
>  isolate_migratepages_block+0x1c5/0x13b0
>  ? __pv_queued_spin_lock_slowpath+0x16c/0x370
>  compact_zone+0x746/0xfc0
>  compact_zone_order+0xbb/0x100
>  try_to_compact_pages+0xf0/0x2f0
>  __alloc_pages_direct_compact+0x78/0x210
>  __alloc_pages_slowpath.constprop.0+0xac1/0xdb0
>  ? prepare_alloc_pages.constprop.0+0xff/0x1b0
>  __alloc_pages+0x218/0x240
>  folio_alloc+0x17/0x50
>  page_cache_ra_order+0x15a/0x340
>  filemap_get_pages+0x136/0x6c0
>  ? update_load_avg+0x7e/0x780
>  ? current_time+0x2b/0xd0
>  filemap_read+0xce/0x340
>  ? do_sched_setscheduler+0x111/0x1b0
>  ? nohz_balance_exit_idle+0x16/0xc0
>  ? trigger_load_balance+0x302/0x370
>  ? preempt_count_add+0x47/0xa0
>  xfs_file_buffered_read+0x52/0xd0 [xfs]
>  xfs_file_read_iter+0x73/0xe0 [xfs]
>  vfs_read+0x1b1/0x300
>  ksys_read+0x63/0xe0
>  do_syscall_64+0x38/0x90
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> RIP: 0033:0x7f350c615a5d
> Code: 31 c0 e9 c6 fe ff ff 50 48 8d 3d a6 60 0a 00 e8 99 08 02 00 66 0f 1f 84 00 00 00 00 00 80 3d 81 3b 0e 00 00 74 17 31 c0 0f 05 <48> 3d 00 f0 >
> RSP: 002b:00007ffca3ef5108 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 000055ff140712f0 RCX: 00007f350c615a5d
> RDX: 0000000000008000 RSI: 000055ff140714d0 RDI: 0000000000000003
> RBP: 00007f350c6ee600 R08: 0000000000000900 R09: 000000000b9bc05b
> R10: 000055ff140794d0 R11: 0000000000000246 R12: 000055ff140714d0
> R13: 0000000000008000 R14: 0000000000000a68 R15: 00007f350c6edd00
>  </TASK>
> Modules linked in: dm_zero dm_thin_pool dm_persistent_data dm_bio_prison sd_mod sg scsi_mod scsi_common dm_snapshot dm_bufio dm_flakey xfs sunrpc >
> ---[ end trace 0000000000000000 ]---

It's because PageHuge() now does folio_test_hugetlb() which is documented to
assume caller holds a reference, but the test in
isolate_migratepages_block() doesn't. The code is there from 2021 by Oscar,
perhaps it could be changed to take a reference (and e.g. only test
PageHead() before), but it will be a bit involved as the
isolate_or_dissolve_huge_page() it calls has some logic based on the
refcount being zero/non-zero as well. Oscar, what do you think?
Also I wonder if any of the the other existing PageHuge() callers are also
affected because they might be doing so without a reference.

(keeping the rest of patch for new Cc's)

> ---
>  .../admin-guide/kdump/vmcoreinfo.rst          | 10 +---
>  include/linux/mm.h                            |  4 --
>  include/linux/page-flags.h                    | 43 ++++++++++++----
>  kernel/crash_core.c                           |  2 +-
>  mm/hugetlb.c                                  | 49 +++----------------
>  mm/page_alloc.c                               |  2 +-
>  6 files changed, 43 insertions(+), 67 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> index c18d94fa6470..baa1c355741d 100644
> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> @@ -325,8 +325,8 @@ NR_FREE_PAGES
>  On linux-2.6.21 or later, the number of free pages is in
>  vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
>  
> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask
> -------------------------------------------------------------------------------
> +PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask|PG_hugetlb
> +-----------------------------------------------------------------------------------------
>  
>  Page attributes. These flags are used to filter various unnecessary for
>  dumping pages.
> @@ -338,12 +338,6 @@ More page attributes. These flags are used to filter various unnecessary for
>  dumping pages.
>  
>  
> -HUGETLB_PAGE_DTOR
> ------------------
> -
> -The HUGETLB_PAGE_DTOR flag denotes hugetlbfs pages. Makedumpfile
> -excludes these pages.
> -
>  x86_64
>  ======
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7b800d1298dc..642f5fe5860e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1268,11 +1268,7 @@ void folio_copy(struct folio *dst, struct folio *src);
>  unsigned long nr_free_buffer_pages(void);
>  
>  enum compound_dtor_id {
> -	NULL_COMPOUND_DTOR,
>  	COMPOUND_PAGE_DTOR,
> -#ifdef CONFIG_HUGETLB_PAGE
> -	HUGETLB_PAGE_DTOR,
> -#endif
>  	TRANSHUGE_PAGE_DTOR,
>  	NR_COMPOUND_DTORS,
>  };
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 92a2063a0a23..aeecf0cf1456 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -171,15 +171,6 @@ enum pageflags {
>  	/* Remapped by swiotlb-xen. */
>  	PG_xen_remapped = PG_owner_priv_1,
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -	/*
> -	 * Compound pages. Stored in first tail page's flags.
> -	 * Indicates that at least one subpage is hwpoisoned in the
> -	 * THP.
> -	 */
> -	PG_has_hwpoisoned = PG_error,
> -#endif
> -
>  	/* non-lru isolated movable page */
>  	PG_isolated = PG_reclaim,
>  
> @@ -190,6 +181,15 @@ enum pageflags {
>  	/* For self-hosted memmap pages */
>  	PG_vmemmap_self_hosted = PG_owner_priv_1,
>  #endif
> +
> +	/*
> +	 * Flags only valid for compound pages.  Stored in first tail page's
> +	 * flags word.
> +	 */
> +
> +	/* At least one page in this folio has the hwpoison flag set */
> +	PG_has_hwpoisoned = PG_error,
> +	PG_hugetlb = PG_active,
>  };
>  
>  #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
> @@ -812,7 +812,23 @@ static inline void ClearPageCompound(struct page *page)
>  
>  #ifdef CONFIG_HUGETLB_PAGE
>  int PageHuge(struct page *page);
> -bool folio_test_hugetlb(struct folio *folio);
> +SETPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
> +CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
> +
> +/**
> + * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
> + * @folio: The folio to test.
> + *
> + * Context: Any context.  Caller should have a reference on the folio to
> + * prevent it from being turned into a tail page.
> + * Return: True for hugetlbfs folios, false for anon folios or folios
> + * belonging to other filesystems.
> + */
> +static inline bool folio_test_hugetlb(struct folio *folio)
> +{
> +	return folio_test_large(folio) &&
> +		test_bit(PG_hugetlb, folio_flags(folio, 1));
> +}
>  #else
>  TESTPAGEFLAG_FALSE(Huge, hugetlb)
>  #endif
> @@ -1040,6 +1056,13 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>  #define PAGE_FLAGS_CHECK_AT_PREP	\
>  	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
>  
> +/*
> + * Flags stored in the second page of a compound page.  They may overlap
> + * the CHECK_AT_FREE flags above, so need to be cleared.
> + */
> +#define PAGE_FLAGS_SECOND						\
> +	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb)
> +
>  #define PAGE_FLAGS_PRIVATE				\
>  	(1UL << PG_private | 1UL << PG_private_2)
>  /**
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 90ce1dfd591c..dd5f87047d06 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -490,7 +490,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>  #define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
>  	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
>  #ifdef CONFIG_HUGETLB_PAGE
> -	VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
> +	VMCOREINFO_NUMBER(PG_hugetlb);
>  #define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
>  	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
>  #endif
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 086eb51bf845..389490f100b0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1585,25 +1585,7 @@ static inline void __clear_hugetlb_destructor(struct hstate *h,
>  {
>  	lockdep_assert_held(&hugetlb_lock);
>  
> -	/*
> -	 * Very subtle
> -	 *
> -	 * For non-gigantic pages set the destructor to the normal compound
> -	 * page dtor.  This is needed in case someone takes an additional
> -	 * temporary ref to the page, and freeing is delayed until they drop
> -	 * their reference.
> -	 *
> -	 * For gigantic pages set the destructor to the null dtor.  This
> -	 * destructor will never be called.  Before freeing the gigantic
> -	 * page destroy_compound_gigantic_folio will turn the folio into a
> -	 * simple group of pages.  After this the destructor does not
> -	 * apply.
> -	 *
> -	 */
> -	if (hstate_is_gigantic(h))
> -		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
> -	else
> -		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
> +	folio_clear_hugetlb(folio);
>  }
>  
>  /*
> @@ -1690,7 +1672,7 @@ static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>  		h->surplus_huge_pages_node[nid]++;
>  	}
>  
> -	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
> +	folio_set_hugetlb(folio);
>  	folio_change_private(folio, NULL);
>  	/*
>  	 * We have to set hugetlb_vmemmap_optimized again as above
> @@ -1814,9 +1796,8 @@ static void free_hpage_workfn(struct work_struct *work)
>  		/*
>  		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
>  		 * folio_hstate() is going to trigger because a previous call to
> -		 * remove_hugetlb_folio() will call folio_set_compound_dtor
> -		 * (folio, NULL_COMPOUND_DTOR), so do not use folio_hstate()
> -		 * directly.
> +		 * remove_hugetlb_folio() will clear the hugetlb bit, so do
> +		 * not use folio_hstate() directly.
>  		 */
>  		h = size_to_hstate(page_size(page));
>  
> @@ -1955,7 +1936,7 @@ static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>  {
>  	hugetlb_vmemmap_optimize(h, &folio->page);
>  	INIT_LIST_HEAD(&folio->lru);
> -	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
> +	folio_set_hugetlb(folio);
>  	hugetlb_set_folio_subpool(folio, NULL);
>  	set_hugetlb_cgroup(folio, NULL);
>  	set_hugetlb_cgroup_rsvd(folio, NULL);
> @@ -2070,28 +2051,10 @@ int PageHuge(struct page *page)
>  	if (!PageCompound(page))
>  		return 0;
>  	folio = page_folio(page);
> -	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
> +	return folio_test_hugetlb(folio);
>  }
>  EXPORT_SYMBOL_GPL(PageHuge);
>  
> -/**
> - * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
> - * @folio: The folio to test.
> - *
> - * Context: Any context.  Caller should have a reference on the folio to
> - * prevent it from being turned into a tail page.
> - * Return: True for hugetlbfs folios, false for anon folios or folios
> - * belonging to other filesystems.
> - */
> -bool folio_test_hugetlb(struct folio *folio)
> -{
> -	if (!folio_test_large(folio))
> -		return false;
> -
> -	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
> -}
> -EXPORT_SYMBOL_GPL(folio_test_hugetlb);
> -
>  /*
>   * Find and lock address space (mapping) in write mode.
>   *
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9638fdddf065..f8e276de4fd5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1122,7 +1122,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
>  		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
>  
>  		if (compound)
> -			ClearPageHasHWPoisoned(page);
> +			page[1].flags &= ~PAGE_FLAGS_SECOND;
>  		for (i = 1; i < (1 << order); i++) {
>  			if (compound)
>  				bad += free_tail_page_prepare(page, page + i);


