Return-Path: <io-uring+bounces-267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23AF280AC17
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 19:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2B022819A8
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 18:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5D8315AE;
	Fri,  8 Dec 2023 18:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ftae7l2C"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B77BA3
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 10:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JTrKGjAeLkBcKGMxQNLd+P7jRhDj7Ie2FUfD3UVG5Xw=; b=ftae7l2CO/3REmdvuZVVFcEEM/
	y13y3H95B90PCINFlfoKOv0Rv5/dhi2hAT5ENgYpBLrTZ5m11rMJeHe6Jby/QgB+kX5ZxVoPJdA6t
	eM/gZIufK7qB8txfOZd1VnG4oUIUZarsEzaNvCksV6fdu8IGVNgcsI47soh3QfeBXnFwai60zqswF
	6PYkC0AqaGsdrrp2fS7ZQXODbxDJo1YS9HedWAayrXlCSC8tDDiz8y4CwqWTtA8OOv3+doUOpiCo1
	7J4oTkt19113Stjyk84v4/nWYWM0NlYEsQ4BYi1hb7E5wWPZJYM/nhxfRe2cObKqXpdpo7RqqoXWp
	0uCvH2IA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rBfdi-006IQY-Tm; Fri, 08 Dec 2023 18:31:55 +0000
Date: Fri, 8 Dec 2023 18:31:54 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Message-ID: <ZXNhGsX32y19a2Xv@casper.infradead.org>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
 <8fa1c95c-4749-33dd-42ba-243e492ab109@suse.cz>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fa1c95c-4749-33dd-42ba-243e492ab109@suse.cz>

On Fri, Dec 08, 2023 at 06:54:19PM +0100, Vlastimil Babka wrote:
> On 8/16/23 17:11, Matthew Wilcox (Oracle) wrote:
> > We can use a bit in page[1].flags to indicate that this folio belongs
> > to hugetlb instead of using a value in page[1].dtors.  That lets
> > folio_test_hugetlb() become an inline function like it should be.
> > We can also get rid of NULL_COMPOUND_DTOR.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> I think this (as commit 9c5ccf2db04b ("mm: remove HUGETLB_PAGE_DTOR")) is
> causing the bug reported by Luis here:
> https://bugzilla.kernel.org/show_bug.cgi?id=218227

Luis, please stop using bugzilla.  If you'd sent email like a normal
kernel developer, I'd've seen this bug earlier.

> > page:000000009006bf10 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x3f8a0 pfn:0x1035c0
> > flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
> > page_type: 0xffffff7f(buddy)
> > raw: 017fffc000000000 ffffe704c422f808 ffffe704c41ac008 0000000000000000
> > raw: 000000000003f8a0 0000000000000005 00000000ffffff7f 0000000000000000
> > page dumped because: VM_BUG_ON_PAGE(n > 0 && !((__builtin_constant_p(PG_head) && __builtin_constant_p((uintptr_t)(&page->flags) != (uintptr_t)((vo>
> > ------------[ cut here ]------------
> > kernel BUG at include/linux/page-flags.h:314!
> > invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > CPU: 6 PID: 2435641 Comm: md5sum Not tainted 6.6.0-rc5 #2
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> > RIP: 0010:folio_flags+0x65/0x70
> > Code: a8 40 74 de 48 8b 47 48 a8 01 74 d6 48 83 e8 01 48 39 c7 75 bd eb cb 48 8b 07 a8 40 75 c8 48 c7 c6 d8 a7 c3 89 e8 3b c7 fa ff <0f> 0b 66 0f >
> > RSP: 0018:ffffad51c0bfb7a8 EFLAGS: 00010246
> > RAX: 000000000000015f RBX: ffffe704c40d7000 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff89be8040 RDI: 00000000ffffffff
> > RBP: 0000000000103600 R08: 0000000000000000 R09: ffffad51c0bfb658
> > R10: 0000000000000003 R11: ffffffff89eacb08 R12: 0000000000000035
> > R13: ffffe704c40d7000 R14: 0000000000000000 R15: ffffad51c0bfb930
> > FS:  00007f350c51b740(0000) GS:ffff9b62fbd80000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000555860919508 CR3: 00000001217fe002 CR4: 0000000000770ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  ? die+0x32/0x80
> >  ? do_trap+0xd6/0x100
> >  ? folio_flags+0x65/0x70
> >  ? do_error_trap+0x6a/0x90
> >  ? folio_flags+0x65/0x70
> >  ? exc_invalid_op+0x4c/0x60
> >  ? folio_flags+0x65/0x70
> >  ? asm_exc_invalid_op+0x16/0x20
> >  ? folio_flags+0x65/0x70
> >  ? folio_flags+0x65/0x70
> >  PageHuge+0x67/0x80
> >  isolate_migratepages_block+0x1c5/0x13b0
> >  compact_zone+0x746/0xfc0
> >  compact_zone_order+0xbb/0x100
> >  try_to_compact_pages+0xf0/0x2f0
> >  __alloc_pages_direct_compact+0x78/0x210
> >  __alloc_pages_slowpath.constprop.0+0xac1/0xdb0
> >  __alloc_pages+0x218/0x240
> >  folio_alloc+0x17/0x50
> 
> It's because PageHuge() now does folio_test_hugetlb() which is documented to
> assume caller holds a reference, but the test in
> isolate_migratepages_block() doesn't. The code is there from 2021 by Oscar,
> perhaps it could be changed to take a reference (and e.g. only test
> PageHead() before), but it will be a bit involved as the
> isolate_or_dissolve_huge_page() it calls has some logic based on the
> refcount being zero/non-zero as well. Oscar, what do you think?
> Also I wonder if any of the the other existing PageHuge() callers are also
> affected because they might be doing so without a reference.

I don't think the warning is actually wrong!  We're living very
dangerously here as PageHuge() could have returned a false positive
before this change [1].  Then we assume that compound_nr() returns a
consistent result (and compound_order() might, for example, return a
value larger than 63, leading to UB).

I think there's a place for a folio_test_hugetlb_unsafe(), but that
would only remove the warning, and do nothing to fix all the unsafe
usage.  The hugetlb handling code in isolate_migratepages_block()
doesn't seem to have any understanding that it's working with pages
that can change under it.  I can have a go at fixing it up, but maybe
Oscar would prefer to do it?

[1] terribly unlikely, but consider what happens if the page starts out
as a non-hugetlb compound allocation.  Then it is freed and reallocated;
the new owner of the second page could have put enough information
into it that tricked PageHuge() into returning true.  Then we call
isolate_or_dissolve_huge_page() which takes a lock, but doesn't take
a refcount.  Now it gets a bogus hstate and things go downhill from
there ...)

