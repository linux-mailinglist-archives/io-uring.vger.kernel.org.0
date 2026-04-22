Return-Path: <io-uring+bounces-13110-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBWiJMUq6Gm3GAIAu9opvQ
	(envelope-from <io-uring+bounces-13110-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 03:56:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3828F44133B
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 03:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8F5C5300989A
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 01:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9753F3FF1;
	Wed, 22 Apr 2026 01:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Si0yjuwz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542532E8B8A
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 01:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776822979; cv=none; b=cdRgW3XFt6Zqz5jRMNu9Kz2pSIbArstawMn7LQxEePLFbs3167cwE5rr59KzyZpCSKx36WWRkEarGWpIDFAUCkwsnLSouUkDPslSrUVKONwMypcBoN3mvQ8r68yZ0PbCHrag9unFMBAT6wgNmFXj6zGQIxPVd1rMYtkVqZmVuak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776822979; c=relaxed/simple;
	bh=VFgxHtL1ogZb3lJ45j7OUnLna+6rTJspwNBxNqEUEXM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=QuKooR1h1lZ8VBvmuKKWAP+ViGKFpRTkT37B1OfXgaL4YQNJYmy1EjTG56dMCBraRSfLV0Yt+Zb3ib+CO+dQPMLbFU0KTKYEVhpIE9jGl65eI8kBfMsKf3BpQi+qWIg0/DjvY7OsmHGzWv/Vi/oml6zFA0kNn2JMRGDPh8J2Ckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Si0yjuwz; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-67e09232daeso2863605eaf.2
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 18:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776822975; x=1777427775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wbLKR6z8/5gD+ojunLXuP1KEA8ecg/QyOBsvzm+UCw=;
        b=Si0yjuwzC7TYWXG+4dewTbQFfQNbHjUWU87ceZQQk21k8NLU83xvLeuijYfCV2XD32
         qzMRBkvc7RhBxsXgX3la8t5wtEuJilwchJl8VR3I+MroMST6BDOz6S/TZvWOgdxDOtN8
         psnj5jkusNmZS+2mKLJMx2p7l/LbgLvi8bVqS7+5wSnv/MFA1pq37pLmCHGjQXBeMKov
         xVK9ZwA2gSW1jPT4ica6ER2BLQ7IKPbctLW1JE+/bZlnu/o/QzTEUHNFFqbl9Taix+8V
         eLeeRojn/4wOrohTffiar1mVRzlgiHk3BDsCOxUwu0be6rTEQhJFAn/hBFpJrTgfnaZd
         anbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776822975; x=1777427775;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5wbLKR6z8/5gD+ojunLXuP1KEA8ecg/QyOBsvzm+UCw=;
        b=H6j/oPWifVyGkffK/IJke95g492ptFKXYwiAfmjC3pEdvW+3iSIX4gMhmx47V/ks5C
         RiHQRwYqktL3FoXtoJ/POlwtoV047mSygcf44k+4+aik1K9yY3vFTID/lDXYBt50+mY2
         +ijSlPca+3XrhMRYgTLd0QnIYxgGeVfEe713NlZLGJtmRaipwCS7JoOKt7iYRgf8NxNP
         Tw4L5w3yYg6SODoZQt1hvaC+ziwsKfLEDT9NBdxUrzGrOtkcuoc8+A8WRjEADxNXtZPj
         Wa9OM5tgCtJzdcwKwPJ73wnG7Xi8tZGNmdRsoVOCCMRxeElcCY2VcNfGGMPgtDtAfw51
         U+Nw==
X-Gm-Message-State: AOJu0YwnfbaYKMsBg+9dx6CPX3eUcKcxuD7PKb0Hgmqg2xoJ+KK8wvnC
	KYrzYO3GnjK4k370PyrY3j2RrjvJDclV0T1YUfjRUkNFsmx5P7O7FBvly83PbAmi2nK7nvGkqB9
	cMNXa+nU=
X-Gm-Gg: AeBDietGb8CfJyocn2EzMyKPPD8nQKahV3BTciax4++LqUbs1nA/YUIAgaBAXiJN5ri
	ZyL0cTtWIf30G8X44ydkN1oEeOvMtq4Wx3Ap9QRVOgnPJ/VdJTu8iRSivHGSwb5vtxNFkTmLX6X
	twnvDpto4B8NFsWUlucftXcgkpNEqi2RnXklRn9bbgDUQStUKKAdQnpEC5/IOdt19iF2SZvD9pw
	DIrVDkScPXzwhLyFUTsXvxdAnZI4fxLEoV7kMbG+RC+UMCfUajMjFB5FLLbS/eyKk+Cyvj1U2Tf
	5oY+IUScR4zpwR/mYmZiiobkoQwEncXQKz4HjtCgl0NdXY6WOA+mWA72mD45Wdku6tYXKXueOfU
	Vf7UfFX6H03jz9SfcGSQL6FWBrD0DgYeQKDwEl1bJY81VSwXVvJYsGTYUKlbyNMZnMrn+rE3rzk
	GMS/uIEuV2pZsYGhThHm0nPU+hHbQOEhuOz3+XHkhArdeFclRtMaONWcALbHbytFsRvvJ34KZAY
	RA5B83BL8ksa/zX2YVv
X-Received: by 2002:a05:6820:168d:b0:68b:58f4:dce2 with SMTP id 006d021491bc7-69462e3b0a2mr10629837eaf.22.1776822975523;
        Tue, 21 Apr 2026 18:56:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69493183021sm3139876eaf.13.2026.04.21.18.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 18:56:14 -0700 (PDT)
Message-ID: <f1b43e56-4724-4635-b18b-bae2add37936@kernel.dk>
Date: Tue, 21 Apr 2026 19:56:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <2026042115-body-attention-d15b@gregkh>
 <177679318887.642042.703437019420919449.b4-ty@b4>
 <dec29d85-9e79-42df-ae3d-9af65134283c@kernel.dk>
Content-Language: en-US
In-Reply-To: <dec29d85-9e79-42df-ae3d-9af65134283c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13110-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 3828F44133B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 7:17 PM, Jens Axboe wrote:
> On 4/21/26 11:39 AM, Jens Axboe wrote:
>>
>> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
>>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
>>> virtual address of the io_mapped_region's backing pages directly;
>>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
>>> just returns 0 -- it takes no page references.
>>>
>>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
>>> each inserted page.  Those references are released when the VMA is torn
>>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
>>> drops the io_uring-side references, but the pages survive until munmap
>>> drops the VMA-side references.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
>>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e
> 
> Actually, I take that back - what prevents the io_mmap_get_region()
> in the newly added io_uring_nommu_vm_close() from getting the same
> region that we initially referenced the pages from in the nommu
> variant of io_uring_mmap()?

I think we can get rid of that and simplify the code at the same
time. Rather than need to re-lookup the buffer list, we can just iterate
the pages mapped in the vma. Since this is a file backed mapping and
io_uring doesn't allow remaps, that should always be the same.

Greg, can you test this? I will fold this in.


diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 6818e9abf3b3..e80f9eed6efc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -367,45 +367,18 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 #else /* !CONFIG_MMU */
 
 /*
- * Under NOMMU, get_unmapped_area returns the kernel virtual address of
- * the io_mapped_region's backing pages directly -- the user's VMA
- * aliases the kernel allocation rather than holding its own copy or
- * page-table entries. The CONFIG_MMU path's vm_insert_pages() takes
- * page references that survive until munmap; this path takes none, so
- * io_unregister_pbuf_ring() -> io_free_region() -> release_pages()
- * frees the pages while the user's VMA still maps them. The user can
- * then write into whatever the buddy allocator hands out next.
- *
- * Mirror the MMU lifetime by taking page references in io_uring_mmap()
- * and releasing them in vm_ops->close. We re-derive the region from
- * vm_pgoff (same lookup get_unmapped_area used) so we know which pages
- * to grab.
+ * Drop the pages that were initially referenced and added in
+ * io_uring_mmap(). We cannot have had a mremap() as that isnt supported,
+ * hence the vma should be identical to the one we initially referenced and
+ * mapped, and partial unmaps and splitting isn't possible on a file backed
+ * mapping.
  */
-
 static void io_uring_nommu_vm_close(struct vm_area_struct *vma)
 {
-	struct io_ring_ctx *ctx = vma->vm_file->private_data;
-	struct io_mapped_region *region;
-	unsigned long i;
+	unsigned long index;
 
-	guard(mutex)(&ctx->mmap_lock);
-	region = io_mmap_get_region(ctx, vma->vm_pgoff);
-	/*
-	 * The region may have been unregistered (memset to zero in
-	 * io_free_region()) between mmap and munmap. The page refs we
-	 * took in io_uring_mmap() are what kept the pages alive; release
-	 * them via the VMA range since the region->pages array is gone.
-	 */
-	if (region && region->pages) {
-		for (i = 0; i < region->nr_pages; i++)
-			put_page(region->pages[i]);
-	} else {
-		/* Region cleared; walk the VMA range. */
-		unsigned long a;
-
-		for (a = vma->vm_start; a < vma->vm_end; a += PAGE_SIZE)
-			put_page(virt_to_page((void *)a));
-	}
+	for (index = vma->vm_start; index < vma->vm_end; index += PAGE_SIZE)
+		put_page(virt_to_page((void *) index);
 }
 
 static const struct vm_operations_struct io_uring_nommu_vm_ops = {

-- 
Jens Axboe

