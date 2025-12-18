Return-Path: <io-uring+bounces-11219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B15A1CCCC04
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 17:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5910E30BEA40
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 16:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41D323D7CD;
	Thu, 18 Dec 2025 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIxlsgnC"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE39E331A4D
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074156; cv=none; b=LeSOldIvH4pqTM38Lg2GCiwvKjatbmrvdU8BDTlNZfeL9sBgEQs6BbSn7EhQ1iPk3bFdVfNYsxGEu9yA6QdR/2mNgALfB27lC4aPnGdf3EJP2vxFmr1J5Eeh73h5uTbKLkrK3xDRowIBrv8UnjStpoPmOyuuxR34/L7G1lxvs6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074156; c=relaxed/simple;
	bh=Tr9+xx0Px/D03EawGODeyaT/8YYgfmAviFlrAXVV9fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXJpMSbc4xA6B7X4PIUcEbVnl4sFmvqom+Nx5WT5fCYCnF2+vp/oNdgjWauk/hBGV2u9gv5nf3MrZyTkwHmXsMHYQvG0Ec1Sdlj6eln8dnpm2evFwn6z6usxn9jhrbGEKLhFKZL13Ce4KwFjk6ZP2tDaDU43t2CpReb5hufyXMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIxlsgnC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766074151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHJIFVWe/DYq44cqnbzs7j9+orLzb+mX4JCiPeWS9kc=;
	b=eIxlsgnC6Ih3G98lZmbCQ317ImYWblTVoQJu7l15G4Sxstm26oMmL9gEwzYQ49ZdUDisHz
	PzhcWQxbrAAvdXYeGtiCi64v/xwdVXmv1TdoBz7OPVHQGTuMG42/IU2vJpro1gtFW410Zt
	L+FG80UDeMFpk4hdG91I3MoOkC2Q5rQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-iQuwRU1bP4GgaXxE2GuQ0A-1; Thu,
 18 Dec 2025 11:09:05 -0500
X-MC-Unique: iQuwRU1bP4GgaXxE2GuQ0A-1
X-Mimecast-MFC-AGG-ID: iQuwRU1bP4GgaXxE2GuQ0A_1766074144
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E7251955DE1;
	Thu, 18 Dec 2025 16:09:03 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E55E830001B9;
	Thu, 18 Dec 2025 16:08:56 +0000 (UTC)
Date: Fri, 19 Dec 2025 00:08:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>
Subject: Re: [PATCH 1/3] block: fix bio_may_need_split() by using bvec
 iterator way
Message-ID: <aUQnE0b46XFGrLOd@fedora>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
 <20251218093146.1218279-2-ming.lei@redhat.com>
 <aUPLYcAx2dh-DvuP@infradead.org>
 <aUPNLNHVz2-Y-Z4C@fedora>
 <CGME20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e@epcas5p2.samsung.com>
 <20251218151522.m4dgyf4nkrfsgkrv@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218151522.m4dgyf4nkrfsgkrv@green245.gost>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Dec 18, 2025 at 08:46:47PM +0530, Nitesh Shetty wrote:
> On 18/12/25 05:45PM, Ming Lei wrote:
> > On Thu, Dec 18, 2025 at 01:37:37AM -0800, Christoph Hellwig wrote:
> > > On Thu, Dec 18, 2025 at 05:31:42PM +0800, Ming Lei wrote:
> > > > ->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
> > > > passed to bio_may_need_split().
> > > >
> > > > So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
> > > > checking with help from bio size and bvec->len.
> > > >
> > > > Meantime retrieving the 1st bvec via __bvec_iter_bvec().
> > > 
> > > That totally misses the point.  The ->bi_vcnt is a fast and lose
> > > check to see if we need the fairly expensive iterators to do the
> > > real check.
> > 
> > It is just __bvec_iter_bvec(), whatever it should be in cache sooner or
> > later.
> > 
> > 
> Functionality wise overall patch looks fine to me, but as Christoph
> stated there is slight performance(IOPS) penalty.
> Here is my benchmarking numbers[1], I suspect Jens setup might show
> more regression.
> 
> Regards,
> Nitesh
> 
> 
> [1]
> ===============================
> a. two optane nvme device setup:
> ----------
> base case:
> ----------
> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
> submitter=0, tid=206586, file=/dev/nvme0n1, nfiles=1, node=-1
> submitter=1, tid=206587, file=/dev/nvme1n1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=6.45M, BW=3.15GiB/s, IOS/call=32/31
> IOPS=6.47M, BW=3.16GiB/s, IOS/call=32/32
> IOPS=6.47M, BW=3.16GiB/s, IOS/call=32/32
> Exiting on timeout
> Maximum IOPS=6.47M
> 
> ----------------
> with this patch:
> ----------------
> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
> submitter=0, tid=6352, file=/dev/nvme0n1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=1, tid=6353, file=/dev/nvme1n1, nfiles=1, node=-1
> IOPS=6.30M, BW=3.08GiB/s, IOS/call=32/31
> IOPS=6.35M, BW=3.10GiB/s, IOS/call=32/31
> IOPS=6.37M, BW=3.11GiB/s, IOS/call=32/32
> Exiting on timeout
> Maximum IOPS=6.37M
> 
> =============================
> b. two null-blk device setup:
> ------------------
> null device setup:
> ------------------
> sudo modprobe null_blk queue_mode=2 gb=10 bs=512 nr_devices=2 irqmode=2 \
> completion_nsec=1000000 hw_queue_depth=256 memory_backed=0 discard=0 \
> use_per_node_hctx=1
> 
> ----------
> base case:
> ----------
> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nullb0 /dev/nullb1
> submitter=0, tid=6743, file=/dev/nullb0, nfiles=1, node=-1
> submitter=1, tid=6744, file=/dev/nullb1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=7.89M, BW=3.85GiB/s, IOS/call=32/31
> IOPS=7.96M, BW=3.89GiB/s, IOS/call=32/32
> IOPS=7.99M, BW=3.90GiB/s, IOS/call=32/32
> Exiting on timeout
> Maximum IOPS=7.99M
> 
> -------------------
> with this patchset:
> -------------------
> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nullb0 /dev/nullb1
> submitter=0, tid=35633, file=/dev/nullb0, nfiles=1, node=-1
> submitter=1, tid=35634, file=/dev/nullb1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=7.79M, BW=3.80GiB/s, IOS/call=32/31
> IOPS=7.86M, BW=3.84GiB/s, IOS/call=32/32
> IOPS=7.89M, BW=3.85GiB/s, IOS/call=32/32
> Exiting on timeout
> Maximum IOPS=7.89M

Thanks for the perf test!

This patch only adds bio->bi_iter memory footprint, which is supposed
to hit from L1, maybe because `bi_io_vec` is in the 2nd cacheline, can
you see any difference with the following change?


diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5dc061d318a4..1c4570b37436 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -240,6 +240,7 @@ struct bio {
                /* for plugged zoned writes only: */
                unsigned int            __bi_nr_segments;
        };
+       struct bio_vec          *bi_io_vec;     /* the actual vec list */
        bio_end_io_t            *bi_end_io;
        void                    *bi_private;
 #ifdef CONFIG_BLK_CGROUP
@@ -275,8 +276,6 @@ struct bio {

        atomic_t                __bi_cnt;       /* pin count */

-       struct bio_vec          *bi_io_vec;     /* the actual vec list */
-
        struct bio_set          *bi_pool;
 };



Thanks,
Ming


