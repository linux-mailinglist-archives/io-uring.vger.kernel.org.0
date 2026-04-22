Return-Path: <io-uring+bounces-13111-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BAUF8ky6GmeGgIAu9opvQ
	(envelope-from <io-uring+bounces-13111-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 04:30:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F2F441732
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 04:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 821353021E75
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 02:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B349F35A3B8;
	Wed, 22 Apr 2026 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="U3/UW2ch"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B3334A3DC
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 02:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824782; cv=none; b=mH1gFSj+bSFSbTAgagCzmD8QMZGJU4P+o1zsHHpjN7NJBwBwfzrGujKk0lYp/kSgBwMbOhMV7hzPVOVBmIlPeUEF4htnL0f+saAUANlt1C69DnsvUIVUVeEC3LvTzbz4IOBgXkUDBaGLe1DZSI9T9FvdDi/S4thliDVPAE7WeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824782; c=relaxed/simple;
	bh=hrslHY69ar0huTAFRx0qpXfYcoST6k1Lud2oeEtrSCs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=eU88W57qJx4qqjiCjP0zTMFgoVzn9VUAKfOGo87w0HLsyma0x4mNMEINVcitI5jPdK/9m8fRezmNSi4x1UHcQNQqqMLWOhToQdGJFoVJWhaXnVNAQtkUWpwbiWG6d0fPgNf6+mL9DIRPz1PjEObQ0pYEjUp9OgAnLhBCspXzxA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=U3/UW2ch; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-67e0d3f288aso3153599eaf.0
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 19:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776824770; x=1777429570; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqXPQ33vu4QiZZNckBCJuYcIBUv7Qscjdjeu6HAivm8=;
        b=U3/UW2chDPuY0pnKU78MkNb+pGvcYZZyVmZGONFAdARtmU6S/3oGwNDKYc4qTJFSRl
         LxTlToyQNBFwCmzFJWgLv3ZkSU9MXf+WNj9Hl13iwbxQxelNfWz0l/rPhvx4KPjpSNZw
         r0f8sVALcLUWS4WAdZopplQEgURYkrp4XynymvWOEs6ts1VxVxODPhavNWcjBsSL3PQU
         ad0GhKQUWn3T9tijPpnE+cJ+PJz5PTjZwzYXV5MZGNuRiCjZ2jaa9Ud4A3lYYIBaYIa4
         2sSk2UCwdzoRzSP8SJ+s2Fz9PdNvrAezBC7wBeI6B/iXFaYSR7N9UbZcyD5NA9U6gOtj
         mmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776824770; x=1777429570;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HqXPQ33vu4QiZZNckBCJuYcIBUv7Qscjdjeu6HAivm8=;
        b=qC0lkYdy9hNez+ni2qxcc2B0KK2zOHEdoZXcAWzUdrxBZXbF0WXxGTLFhzO614jAzz
         fnfjNOPdedGg55gF66nD5aSNE49HiipJYqNXk73qSimGZ1Qc+ozeM9BfiKaEEKwASNf9
         YZA2GEO5n90+4cTZBzqGDB5Eg7APD1j5wrb6mplypwrPoNgJv/MqUKYz7aH79cepPxZ8
         tv/deeo/RUcooi61o3JOEEaIk3KgoX16z1nAhydxrpogn0Q+wfKmvHn9ekxySGJRaZT1
         F7A4pxBQPJe1QE3J/upng1EU1aVuOubieI0r1RPtdIAZwo+gvGgRyoO5nda+SUtF9KxD
         12gg==
X-Gm-Message-State: AOJu0YyItkJIX9DpMsifDYnd+d6oPi/HeWwtmgLQ/GzjJvm0mc9bP+sC
	ERDG84tE71HGn2lWtgnOSSkfWJoklFST4L5dfwmtju9M5gbEGCAmAyc39LGK7AGZiPyq+5xR7hk
	2X/yy63w=
X-Gm-Gg: AeBDiev0EaGaFXI/Kl3+jAE7eeC3m8ttttRQ2NXKHGZxQOr5Qkfl3aoapZb3jzkS/Ul
	7LMpxZyc4YHdDvgIRs5wAzAl8W0QBJFAy8fgsQ9JX8IbT1MFkuHuimNVzFCWTwTt8RJi+qsewuX
	dYB/GwR0xAsaZZgKPABaWd4oSrNnoex1omsVfe29IpgSMaUIOYR77EtyYtuyFC+vUmlHFyBWTRE
	59f999SqMji733hGr2+YcSEM27nwwaW0pbQAKy+B3QKuUGl9Ova9aVjnTvyTAS0cVZ+FKDbTh9s
	mVKX2qYrEq8rLeF9/7Tl0TQpVn8isYHre1Siqu1xjmBeSlbqDBoXQLA1ejG9iab4KByRQ1cyv0M
	k7sxRszb0pAUgR9ByysOuMIr+o3JbIfuBSuywc/Nf00hVH2hYwQFBUoDge2SqLSGW7j7BAEtxA1
	THA02Ymznle6SWAe4g6/2UGrpCtqkN/+SWliKOAwbAMmya8d0652AerJpCfcjwa8MjMg30AZn+C
	9/16T0oHOwT63NrAktT
X-Received: by 2002:a05:6820:4cc8:b0:686:409c:a6f9 with SMTP id 006d021491bc7-69462dee204mr11814749eaf.11.1776824769859;
        Tue, 21 Apr 2026 19:26:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b934a2dd1sm14217281fac.9.2026.04.21.19.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 19:26:09 -0700 (PDT)
Message-ID: <9c20876f-1cdb-429a-abb3-5ddbcd8cac00@kernel.dk>
Date: Tue, 21 Apr 2026 20:26:08 -0600
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
 <f1b43e56-4724-4635-b18b-bae2add37936@kernel.dk>
Content-Language: en-US
In-Reply-To: <f1b43e56-4724-4635-b18b-bae2add37936@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13111-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 94F2F441732
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 7:56 PM, Jens Axboe wrote:
> On 4/21/26 7:17 PM, Jens Axboe wrote:
>> On 4/21/26 11:39 AM, Jens Axboe wrote:
>>>
>>> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
>>>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
>>>> virtual address of the io_mapped_region's backing pages directly;
>>>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
>>>> just returns 0 -- it takes no page references.
>>>>
>>>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
>>>> each inserted page.  Those references are released when the VMA is torn
>>>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
>>>> drops the io_uring-side references, but the pages survive until munmap
>>>> drops the VMA-side references.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
>>>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e
>>
>> Actually, I take that back - what prevents the io_mmap_get_region()
>> in the newly added io_uring_nommu_vm_close() from getting the same
>> region that we initially referenced the pages from in the nommu
>> variant of io_uring_mmap()?
> 
> I think we can get rid of that and simplify the code at the same
> time. Rather than need to re-lookup the buffer list, we can just iterate
> the pages mapped in the vma. Since this is a file backed mapping and
> io_uring doesn't allow remaps, that should always be the same.
> 
> Greg, can you test this? I will fold this in.

Here's the full patch - the incremental was missing a ')'. And
for good measure, ensure that the vma size matches the pages in
the region.

commit d0be8884f56b0b800cd8966e37ce23417cd5044e
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue Apr 21 15:46:16 2026 +0200

    io_uring: take page references for NOMMU pbuf_ring mmaps
    
    Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
    virtual address of the io_mapped_region's backing pages directly;
    the user's VMA aliases the kernel allocation. io_uring_mmap() then
    just returns 0 -- it takes no page references.
    
    The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
    each inserted page.  Those references are released when the VMA is torn
    down (zap_pte_range -> put_page). io_free_region() -> release_pages()
    drops the io_uring-side references, but the pages survive until munmap
    drops the VMA-side references.
    
    Under NOMMU there are no VMA-side references. io_unregister_pbuf_ring ->
    io_put_bl -> io_free_region -> release_pages drops the only references
    and the pages return to the buddy allocator while the user's VMA still
    has vm_start pointing into them.  The user can then write into whatever
    the allocator hands out next.
    
    Mirror the MMU lifetime: take get_page references in io_uring_mmap() and
    release them via vm_ops->close.  NOMMU's delete_vma() calls vma_close()
    which runs ->close on munmap.
    
    This also incidentally addresses the duplicate-vm_start case: two mmaps
    of SQ_RING and CQ_RING resolve to the same ctx->ring_region pointer.
    With page refs taken per mmap, the second mmap takes its own refs and
    the pages survive until both mmaps are closed.  The nommu rb-tree BUG_ON
    on duplicate vm_start is a separate mm/nommu.c concern (it should share
    the existing region rather than BUG), but the page lifetime is now
    correct.
    
    Cc: Jens Axboe <axboe@kernel.dk>
    Reported-by: Anthropic
    Assisted-by: gkh_clanker_t1000
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Link: https://patch.msgid.link/2026042115-body-attention-d15b@gregkh
    [axboe: get rid of region lookup, just iterate pages in vma]
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index e6958968975a..4f9b439319c4 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -366,9 +366,53 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 
 #else /* !CONFIG_MMU */
 
+/*
+ * Drop the pages that were initially referenced and added in
+ * io_uring_mmap(). We cannot have had a mremap() as that isn't supported,
+ * hence the vma should be identical to the one we initially referenced and
+ * mapped, and partial unmaps and splitting isn't possible on a file backed
+ * mapping.
+ */
+static void io_uring_nommu_vm_close(struct vm_area_struct *vma)
+{
+	unsigned long index;
+
+	for (index = vma->vm_start; index < vma->vm_end; index += PAGE_SIZE)
+		put_page(virt_to_page((void *) index));
+}
+
+static const struct vm_operations_struct io_uring_nommu_vm_ops = {
+	.close = io_uring_nommu_vm_close,
+};
+
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
+	struct io_ring_ctx *ctx = file->private_data;
+	struct io_mapped_region *region;
+	unsigned long i;
+
+	if (!is_nommu_shared_mapping(vma->vm_flags))
+		return -EINVAL;
+
+	guard(mutex)(&ctx->mmap_lock);
+	region = io_mmap_get_region(ctx, vma->vm_pgoff);
+	if (!region || !io_region_is_set(region))
+		return -EINVAL;
+
+	if ((vma->vm_end - vma->vm_start) !=
+	    (unsigned long) region->nr_pages << PAGE_SHIFT)
+		return -EINVAL;
+
+	/*
+	 * Pin the pages so io_free_region()'s release_pages() does not
+	 * drop the last reference while this VMA exists. delete_vma()
+	 * in mm/nommu.c calls vma_close() which runs ->close above.
+	 */
+	for (i = 0; i < region->nr_pages; i++)
+		get_page(region->pages[i]);
+
+	vma->vm_ops = &io_uring_nommu_vm_ops;
+	return 0;
 }
 
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file)

-- 
Jens Axboe


