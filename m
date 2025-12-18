Return-Path: <io-uring+bounces-11160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2EC7CC9E2F
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 01:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2C80E30088E3
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 00:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD6115B0EC;
	Thu, 18 Dec 2025 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FaSAfCAE"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFB91514E4
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766017989; cv=none; b=kBBLZ3f/3EymMqXSMrP6Wvo3toiMHgbYNTbmeBJLVRxOrnMg5YagMhCWMERT8lubCvINMGleI3bMtl2jwbvRONjvzcw0koVXz3Abq5VWVemnlU7h1Owr4CMwlPIHUR5C9nTbjPAvdGffK67lbbuFCTdOM2+wQ34LtZ3EMM/pInc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766017989; c=relaxed/simple;
	bh=gKed0hLpEVPf6mLXBxmFnjYftNDjUy1iSyO4pVZAVzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUhQXfUzjAdIi/2OTdzAOiNdcnqGucPJ8p23O7CQKX2A8eZpTgCrlXhZIQSvRlprg52o6c0e/tGI52JhcY4XDtsKpEOxIoBn47576nEp1w9e+uU6QAwdeywKPfUIbniyYvrVFVXzMWSilrf6NkrfvEDIMOr8u0EqRreT93ftJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FaSAfCAE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766017986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9DhaefjBg33wyFqsGGCcJJMfWtOrtMDQ2W3yoF80Zg=;
	b=FaSAfCAEUeuqIG14jRqVhwlmXzyEgGpLkN1Qm4BkqmEyaadUW3df/60ig2iT9p18cukrxV
	hB2PFtH7lnxWT7hZHNrTPEPbWEZ1/PGSBM9aQZ5u2VnCE7yOuHCJCtWc2uaD91CE1smfpm
	sjLmjheHSoPFZoW4yzTcvVE2Q0ElYvY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-P5zOtKEQPnWFfq9gLi1Nrg-1; Wed,
 17 Dec 2025 19:33:03 -0500
X-MC-Unique: P5zOtKEQPnWFfq9gLi1Nrg-1
X-Mimecast-MFC-AGG-ID: P5zOtKEQPnWFfq9gLi1Nrg_1766017981
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EE781800451;
	Thu, 18 Dec 2025 00:33:01 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99B5C19560B4;
	Thu, 18 Dec 2025 00:32:57 +0000 (UTC)
Date: Thu, 18 Dec 2025 08:32:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: veygax <veyga@veygax.dev>
Cc: Jens Axboe <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
Message-ID: <aUNLs5g3Qed4tuYs@fedora>
References: <20251217210316.188157-3-veyga@veygax.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217210316.188157-3-veyga@veygax.dev>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Dec 17, 2025 at 09:04:01PM +0000, veygax wrote:
> From: Evan Lambert <veyga@veygax.dev>
> 
> The function io_buffer_register_bvec() calculates the allocation size
> for the io_mapped_ubuf based on blk_rq_nr_phys_segments(rq). This
> function calculates the number of scatter-gather elements after megine
> physically contiguous pages.
> 
> However, the subsequent loop uses rq_for_each_bvec() to populate the
> array, which iterates over every individual bio_vec in the request,
> regardless of physical contiguity.
> 
> If a request has multiple bio_vec entries that are physically
> contiguous, blk_rq_nr_phys_segments() returns a value smaller than
> the total number of bio_vecs. This leads to a slab-out-of-bounds write.
> 
> The path is reachable from userspace via the ublk driver when a server
> issues a UBLK_IO_REGISTER_IO_BUF command. This requires the
> UBLK_F_SUPPORT_ZERO_COPY flag which is protected by CAP_NET_ADMIN.
> 
> Fix this by calculating the total number of bio_vecs by iterating
> over the request's bios and summing their bi_vcnt.
> 
> KASAN report:
> 
> [18:01:50] BUG: KASAN: slab-out-of-bounds in io_buffer_register_bvec+0x813/0xb80
> [18:01:50] Write of size 8 at addr ffff88800223b238 by task kunit_try_catch/27

Can you share the test case so that we can understand why page isn't merged
to last bvec? Maybe there is chance to improve block layer(bio add page
related code)

> [18:01:50]
> [18:01:50] CPU: 0 UID: 0 PID: 27 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1-g346af1a0c65a-dirty #44 PREEMPT(none)
> [18:01:50] Tainted: [N]=TEST
> [18:01:50] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
> [18:01:50] Call Trace:
> [18:01:50]  <TASK>
> [18:01:50]  dump_stack_lvl+0x4d/0x70
> [18:01:50]  print_report+0x151/0x4c0
> [18:01:50]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [18:01:50]  ? io_buffer_register_bvec+0x813/0xb80
> [18:01:50]  kasan_report+0xec/0x120
> [18:01:50]  ? io_buffer_register_bvec+0x813/0xb80
> [18:01:50]  io_buffer_register_bvec+0x813/0xb80
> [18:01:50]  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
> [18:01:50]  ? __pfx_io_buffer_register_bvec_overflow_test+0x10/0x10
> [18:01:50]  ? __pfx_pick_next_task_fair+0x10/0x10
> [18:01:50]  ? _raw_spin_lock+0x7e/0xd0
> [18:01:50]  ? finish_task_switch.isra.0+0x19a/0x650
> [18:01:50]  ? __pfx_read_tsc+0x10/0x10
> [18:01:50]  ? ktime_get_ts64+0x79/0x240
> [18:01:50]  kunit_try_run_case+0x19b/0x2c0
> [18:01:50]  ? __pfx_kunit_try_run_case+0x10/0x10
> [18:01:50]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
> [18:01:50]  kunit_generic_run_threadfn_adapter+0x80/0xf0
> [18:01:50]  kthread+0x323/0x670
> [18:01:50]  ? __pfx_kthread+0x10/0x10
> [18:01:50]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [18:01:50]  ? __pfx_kthread+0x10/0x10
> [18:01:50]  ret_from_fork+0x329/0x420
> [18:01:50]  ? __pfx_ret_from_fork+0x10/0x10
> [18:01:50]  ? __switch_to+0xa0f/0xd40
> [18:01:50]  ? __pfx_kthread+0x10/0x10
> [18:01:50]  ret_from_fork_asm+0x1a/0x30
> [18:01:50]  </TASK>
> [18:01:50]
> [18:01:50] Allocated by task 27:
> [18:01:50]  kasan_save_stack+0x30/0x50
> [18:01:50]  kasan_save_track+0x14/0x30
> [18:01:50]  __kasan_kmalloc+0x7f/0x90
> [18:01:50]  io_cache_alloc_new+0x35/0xc0
> [18:01:50]  io_buffer_register_bvec+0x196/0xb80
> [18:01:50]  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
> [18:01:50]  kunit_try_run_case+0x19b/0x2c0
> [18:01:50]  kunit_generic_run_threadfn_adapter+0x80/0xf0
> [18:01:50]  kthread+0x323/0x670
> [18:01:50]  ret_from_fork+0x329/0x420
> [18:01:50]  ret_from_fork_asm+0x1a/0x30
> [18:01:50]
> [18:01:50] The buggy address belongs to the object at ffff88800223b000
> [18:01:50]  which belongs to the cache kmalloc-1k of size 1024
> [18:01:50] The buggy address is located 0 bytes to the right of
> [18:01:50]  allocated 568-byte region [ffff88800223b000, ffff88800223b238)
> [18:01:50]
> [18:01:50] The buggy address belongs to the physical page:
> [18:01:50] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2238
> [18:01:50] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> [18:01:50] flags: 0x4000000000000040(head|zone=1)
> [18:01:50] page_type: f5(slab)
> [18:01:50] raw: 4000000000000040 ffff888001041dc0 dead000000000122 0000000000000000
> [18:01:50] raw: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
> [18:01:50] head: 4000000000000040 ffff888001041dc0 dead000000000122 0000000000000000
> [18:01:50] head: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
> [18:01:50] head: 4000000000000002 ffffea0000088e01 00000000ffffffff 00000000ffffffff
> [18:01:50] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> [18:01:50] page dumped because: kasan: bad access detected
> [18:01:50]
> [18:01:50] Memory state around the buggy address:
> [18:01:50]  ffff88800223b100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [18:01:50]  ffff88800223b180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [18:01:50] >ffff88800223b200: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
> [18:01:50]                                         ^
> [18:01:50]  ffff88800223b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [18:01:50]  ffff88800223b300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [18:01:50] ==================================================================
> [18:01:50] Disabling lock debugging due to kernel taint
> 
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> Signed-off-by: Evan Lambert <veyga@veygax.dev>
> ---
>  io_uring/rsrc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b331bf..7602b71543e0 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -946,6 +946,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>  	struct io_mapped_ubuf *imu;
>  	struct io_rsrc_node *node;
>  	struct bio_vec bv;
> +	struct bio *bio;
>  	unsigned int nr_bvecs = 0;
>  	int ret = 0;
>  
> @@ -967,11 +968,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>  		goto unlock;
>  	}
>  
> -	/*
> -	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
> -	 * but avoids needing to iterate over the bvecs
> -	 */
> -	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
> +	__rq_for_each_bio(bio, rq)
> +		nr_bvecs += bio->bi_vcnt;

This way is wrong, bio->bi_vcnt can't be trusted for this purpose, you may
have to use rq_for_each_bvec() for calculating the real nr_bvecs.


Thanks, 
Ming


