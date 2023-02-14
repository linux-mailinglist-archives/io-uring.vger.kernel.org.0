Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24048697194
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 00:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjBNXKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 18:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjBNXKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 18:10:07 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C540135;
        Tue, 14 Feb 2023 15:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676416198; bh=nipe/yeIVrSBm3gj0ujYlwZ8i3najLx3nnvsHGw+1Ig=;
        h=X-UI-Sender-Class:Date:From:To:Subject:In-Reply-To;
        b=KX/fG1xDoq1rjc2iFjRlOZSAIUry166N6wOh+NWluVjOibLgKEKVLE56L2863Ozbl
         gbWu+dpt/aiFaE5X6zx9JJRIE5qRv/8y+btAsyx/46M+Ge/gBSOhKvDMXtbI8eO6jt
         6Yq3FY30VCFuDs8WUuujtGdTnhjFBMkCLoHXhY1QKKdaER4u+drtP53tTFdgMACtC/
         wGHRTATOp49B7UZ+DjvIwmPCAQsGSG76HifUb15bp3fa3LPRVxKgwrNY77HHdx8+2H
         Dimhf/7tiPgF4iJ76RcuGnsz3ObzDLCHiwl1hELNuFVml/JaNXZq0I5QWmCmhOvaSf
         ZLkQasHZ06x6g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.155.167]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdvmO-1osSQt3v78-00b3uM; Wed, 15
 Feb 2023 00:09:58 +0100
Date:   Wed, 15 Feb 2023 00:09:53 +0100
From:   Helge Deller <deller@gmx.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: io_uring failure on parisc with VIPT caches
Message-ID: <Y+wUwVxeN87gqN6o@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507c7873-8888-dbcb-c512-4659af486848@bell.net>
X-Provags-ID: V03:K1:a2HKuS2dxu5jBnAK5SHVNjLlMuIw+02rmBd9/q0E5L2E5tAbbAj
 jFilLG7rIa+9BmYGY4L/I7V+zKBUCnizi4Y9sIccpRf+NpW3jmZULxviPhTZ+OStsPEdFBt
 0T6HsR/1v5/cRj2QXxSo72Idj8F+hT76weO+XMmVWBd6Y2LelSOPk416Fz+1MQ+lFoCS44g
 mgvOAjHO7N+VTBuyMHIgA==
UI-OutboundReport: notjunk:1;M01:P0:rFAq2Y3AaiA=;apj4HGQbeRQ/kxuv7lEMQn6boTq
 z0lhxzpdW+brYQV6YtXS7YxGlEZhOvMHGqjvW0j99IPA58O8ruL/L0EO2dY2vnDwSt2UQXTHj
 MjQhazIEmMS/PQ7mIk9nuHYT690NMNbQLIkRnJcwrjKytwh46VeZmUwl6r7DKTSGBaTl81NOL
 yihZmAdeN5vXSKYIepL7RxdKQSb/3yuCRKOE9TlrslQAI+NPVQSabUeqqU7g7ktYCu10XSZF9
 JfYRUKrhf/PDNlGt48jSK2yUBQBME+TA8YDcC33mwCeS5ra1Q25qJEI88GH5gWRa22cSAMZ2B
 Rsn9LPk92fCC2K1zp85mTVH8CAsnQgAdkhs0v+uqnBT9bbdVd2QnNtVTden4N4XaynDGYYl52
 f4h+vtmv7rMpYLfthYsqKdaXcps/mAd1KlTmhdy2ww3uYYH0LzG55YxzrZdVxQIZTTos/SSRt
 4R3UcvnUAmbFp8r0ah6Hqhdffb0A9Lsz3o/Xj7qa5fiE//gvJTSsqlw1ZaQECcumuRLCI4LF4
 4oyxvCzCQJCt0Lq6YdZlgTfWC/2vRbBSqA3ZMEymQ1tipOMNDsxYPvjlm17zlmynAzZ+lB/9L
 VLyUc6oZfYV6jOCutDak1nEGFs2xfHfgV8YRz/sw0htoSl62qF8miCOItbaOdxH5/tpScgHuP
 8o9hKAmloqGBkh3UnahqGUU2UgEW8I4f7FqXd0McuU22tSfe8IKQlaSuYyaUWtkWVuzAnxZRk
 0WXuUcMO1uI8E7L/UrM7czASDFYic/FD5gA/z+ERj+vPZ0dlPGRToL7CcHw3QVHUnYbiBSpZu
 evrr2tDdPwP5CX8I2jhTBx1/1u4iRrkBryXgxUtRpS8Sd5JVGhQ7OR40MLFyUhdI9FTz0kHEv
 +43eER98t/pyQGKl/RSXkhyEG3g2awhFFPiTRJF43h1xm7phlLZ9WcSp/WSoONJE+3ek6rfUM
 3TqV6LQVHrxncDc2U+nTmgdCyes=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

* John David Anglin <dave.anglin@bell.net>:
> On 2023-02-13 5:05 p.m., Helge Deller wrote:
> > On 2/13/23 22:05, Jens Axboe wrote:
> > > On 2/13/23 1:59?PM, Helge Deller wrote:
> > > > > Yep sounds like it. What's the caching architecture of parisc?
> > > >
> > > > parisc is Virtually Indexed, Physically Tagged (VIPT).
> > >
> > > That's what I assumed, so virtual aliasing is what we're dealing wit=
h
> > > here.
> > >
> > > > Thanks for the patch!
> > > > Sadly it doesn't fix the problem, as the kernel still sees
> > > > ctx->rings->sq.tail as being 0.
> > > > Interestingly it worked once (not reproduceable) directly after bo=
otup,
> > > > which indicates that we at least look at the right address from ke=
rnel side.
> > > >
> > > > So, still needs more debugging/testing.
> > >
> > > It's not like this is untested stuff, so yeah it'll generally be
> > > correct, it just seems that parisc is a bit odd in that the virtual
> > > aliasing occurs between the kernel and userspace addresses too. At l=
east
> > > that's what it seems like.
> >
> > True.
> >
> > > But I wonder if what needs flushing is the user side, not the kernel
> > > side? Either that, or my patch is not flushing the right thing on th=
e
> > > kernel side.


The patch below seems to fix the issue.

I've successfuly tested it with the io_uring-test testcase on
physical parisc machines with 32- and 64-bit 6.1.11 kernels.

The idea is similiar on how a file is mmapped shared by two
userspace processes by keeping the lower bits of the virtual address
the same.

Cache flushes from userspace don't seem to be needed.

I think similiar code is needed for mips (uses SHMLBA 0x40000) and
some other architectures....

Helge


=46rom efde7ed7ad380a924448b8ab8ea30d52782aa8e6 Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Tue, 14 Feb 2023 23:41:14 +0100
Subject: [PATCH] io_uring: DRAFT Fix io_uring on machines with VIPT caches

This is a DRAFT patch to fix io_uring to function on machines
with VIPT caches (like PA-RISC).
It will currently only compile on parisc, because of the usage
of the SHM_COLOUR constant.

Basic idea is to ensure that the page colour matches between the kernel
ring address and mmap'ed userspace address and by flushing the caches
before accessing the rings.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 862e05e6691d..606e23671453 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2208,6 +2208,8 @@ static const struct io_uring_sqe *io_get_sqe(struct =
io_ring_ctx *ctx)
 	unsigned head, mask =3D ctx->sq_entries - 1;
 	unsigned sq_idx =3D ctx->cached_sq_head++ & mask;

+	flush_dcache_page(virt_to_page(ctx->sq_array + sq_idx));
+
 	/*
 	 * The cached sq head (or cq tail) serves two purposes:
 	 *
@@ -2238,6 +2240,9 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned=
 int nr)
 	unsigned int left;
 	int ret;

+	struct io_rings *rings =3D ctx->rings;
+	flush_dcache_page(virt_to_page(rings));
+
 	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
@@ -3059,6 +3067,51 @@ static __cold int io_uring_mmap(struct file *file, =
struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }

+unsigned long
+io_uring_mmu_get_unmapped_area(struct file *filp, unsigned long addr,
+				  unsigned long len, unsigned long pgoff,
+				  unsigned long flags)
+{
+	struct mm_struct *mm =3D current->mm;
+	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
+	struct vm_unmapped_area_info info;
+	void *ptr;
+
+	ptr =3D io_uring_validate_mmap_request(filp, pgoff, len);
+	if (IS_ERR(ptr))
+		return -ENOMEM;
+
+
+	/* we do not support requesting a specific address */
+	if (addr)
+		return -EINVAL;
+
+	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
+	info.length =3D len;
+	info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit =3D arch_get_mmap_base(addr, mm->mmap_base);
+	info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1);
+	info.align_offset =3D (unsigned long)ptr & (SHM_COLOUR - 1);
+
+	addr =3D vm_unmapped_area(&info);
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	if (offset_in_page(addr)) {
+		VM_BUG_ON(addr !=3D -ENOMEM);
+		info.flags =3D 0;
+		info.low_limit =3D TASK_UNMAPPED_BASE;
+		info.high_limit =3D mmap_end;
+		addr =3D vm_unmapped_area(&info);
+	}
+
+	return addr;
+}
+
 #else /* !CONFIG_MMU */

 static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
@@ -3273,6 +3326,8 @@ static const struct file_operations io_uring_fops =
=3D {
 #ifndef CONFIG_MMU
 	.get_unmapped_area =3D io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities =3D io_uring_nommu_mmap_capabilities,
+#else
+	.get_unmapped_area =3D io_uring_mmu_get_unmapped_area,
 #endif
 	.poll		=3D io_uring_poll,
 #ifdef CONFIG_PROC_FS
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 90b675c65b84..b8bc682ef240 100644
=2D-- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -204,6 +204,7 @@ static inline void io_ring_submit_lock(struct io_ring_=
ctx *ctx,
 static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	/* order cqe stores with ring update */
+	flush_dcache_page(virt_to_page(ctx->rings));
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }

