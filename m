Return-Path: <io-uring+bounces-11236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E67CD2A12
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 09:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F30A7300EE41
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 08:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A45C25A655;
	Sat, 20 Dec 2025 08:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OB4R6shZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EC779CD
	for <io-uring@vger.kernel.org>; Sat, 20 Dec 2025 08:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766218648; cv=none; b=a02EIJiE2YhA5flgpoUZhkl8DWh78IW1ZQBG1BThhNahLZ9Cn7x9ql1npMkIeK3ChJ7LqNWmojcXJYtO0XmUmb/s2KAnAyvZEQayU1JPtdFnJUlmA/pFQ9m0jdp3oS+O0RKm4658SQ7RPBIq9WIqzA79q3q4k9/rKm4lTl81SKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766218648; c=relaxed/simple;
	bh=DC1pyE/PFj47pBVOIpH4pz3UcTdqDyzvq7u38ahXhDk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=rwSpjBk2NsojDln7hP82skuKh1gZTQfo23OGF1BIXUHZO2VxQzskiYG7EbggvRp5/2BPYlrZsJPJeukBvNdBaoAB/quC5sDJ61UagTwGI8Aw+GL3onIfCYIgpQolt7qitz6YtsRj1np+En4GKSWfRWtPYwqWD0TaWKLXsMRlCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OB4R6shZ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251220081722epoutp0343041c443897a16f1440907ca679754c~C3n9x0c2V2061120611epoutp039
	for <io-uring@vger.kernel.org>; Sat, 20 Dec 2025 08:17:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251220081722epoutp0343041c443897a16f1440907ca679754c~C3n9x0c2V2061120611epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766218642;
	bh=7PCY1fstkZq5ofA7TJJdu0q7F7BMN3WokJuuMX1ZDxA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OB4R6shZn6qsD5pkAdOALJtI4yuRIqiTWfLfGWDSzJT31YxHwKurDkkN4UPkts+X5
	 p7Y+Du2EDghV/gBxHpkcypIf3F0hGIgEZv30X9snvvc0i95i5TrJrq7StqmtQUyO7U
	 xGGnRKi6nGcGAJwnpb1Sc34CPAAYIKp7DmG5pbLU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251220081722epcas5p259015fe6b11818eca7386b7dc3e0a8d9~C3n9OuQ_R1553915539epcas5p2y;
	Sat, 20 Dec 2025 08:17:22 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dYHM521Vbz2SSKX; Sat, 20 Dec
	2025 08:17:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251220081720epcas5p176bb56ffc4f48f2fb01f26015f7b871f~C3n7K1WcJ0931109311epcas5p1S;
	Sat, 20 Dec 2025 08:17:20 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251220081716epsmtip155215a4a1662bba16d902f407abcd67f~C3n4A80ae0878808788epsmtip1Z;
	Sat, 20 Dec 2025 08:17:16 +0000 (GMT)
Date: Sat, 20 Dec 2025 13:46:07 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, Caleb Sander Mateos
	<csander@purestorage.com>, huang-jl <huang-jl@deepseek.com>
Subject: Re: [PATCH 1/3] block: fix bio_may_need_split() by using bvec
 iterator way
Message-ID: <20251220081607.tvnrltcngl3cc2fh@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aUQnE0b46XFGrLOd@fedora>
X-CMS-MailID: 20251220081720epcas5p176bb56ffc4f48f2fb01f26015f7b871f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_99373_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e
References: <20251218093146.1218279-1-ming.lei@redhat.com>
	<20251218093146.1218279-2-ming.lei@redhat.com>
	<aUPLYcAx2dh-DvuP@infradead.org> <aUPNLNHVz2-Y-Z4C@fedora>
	<CGME20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e@epcas5p2.samsung.com>
	<20251218151522.m4dgyf4nkrfsgkrv@green245.gost> <aUQnE0b46XFGrLOd@fedora>

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_99373_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/12/25 12:08AM, Ming Lei wrote:
>On Thu, Dec 18, 2025 at 08:46:47PM +0530, Nitesh Shetty wrote:
>> On 18/12/25 05:45PM, Ming Lei wrote:
>> > On Thu, Dec 18, 2025 at 01:37:37AM -0800, Christoph Hellwig wrote:
>> > > On Thu, Dec 18, 2025 at 05:31:42PM +0800, Ming Lei wrote:
>> > > > ->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
>> > > > passed to bio_may_need_split().
>> > > >
>> > > > So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
>> > > > checking with help from bio size and bvec->len.
>> > > >
>> > > > Meantime retrieving the 1st bvec via __bvec_iter_bvec().
>> > >
>> > > That totally misses the point.  The ->bi_vcnt is a fast and lose
>> > > check to see if we need the fairly expensive iterators to do the
>> > > real check.
>> >
>> > It is just __bvec_iter_bvec(), whatever it should be in cache sooner or
>> > later.
>> >
>> >
>> Functionality wise overall patch looks fine to me, but as Christoph
>> stated there is slight performance(IOPS) penalty.
>> Here is my benchmarking numbers[1], I suspect Jens setup might show
>> more regression.
>>
>> Regards,
>> Nitesh
>>
>>
>> [1]
>> ===============================
>> a. two optane nvme device setup:
>> ----------
>> base case:
>> ----------
>> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
>> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
>> submitter=0, tid=206586, file=/dev/nvme0n1, nfiles=1, node=-1
>> submitter=1, tid=206587, file=/dev/nvme1n1, nfiles=1, node=-1
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> IOPS=6.45M, BW=3.15GiB/s, IOS/call=32/31
>> IOPS=6.47M, BW=3.16GiB/s, IOS/call=32/32
>> IOPS=6.47M, BW=3.16GiB/s, IOS/call=32/32
>> Exiting on timeout
>> Maximum IOPS=6.47M
>>
>> ----------------
>> with this patch:
>> ----------------
>> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
>> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
>> submitter=0, tid=6352, file=/dev/nvme0n1, nfiles=1, node=-1
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> submitter=1, tid=6353, file=/dev/nvme1n1, nfiles=1, node=-1
>> IOPS=6.30M, BW=3.08GiB/s, IOS/call=32/31
>> IOPS=6.35M, BW=3.10GiB/s, IOS/call=32/31
>> IOPS=6.37M, BW=3.11GiB/s, IOS/call=32/32
>> Exiting on timeout
>> Maximum IOPS=6.37M
>>
>> =============================
>> b. two null-blk device setup:
>> ------------------
>> null device setup:
>> ------------------
>> sudo modprobe null_blk queue_mode=2 gb=10 bs=512 nr_devices=2 irqmode=2 \
>> completion_nsec=1000000 hw_queue_depth=256 memory_backed=0 discard=0 \
>> use_per_node_hctx=1
>>
>> ----------
>> base case:
>> ----------
>> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
>> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nullb0 /dev/nullb1
>> submitter=0, tid=6743, file=/dev/nullb0, nfiles=1, node=-1
>> submitter=1, tid=6744, file=/dev/nullb1, nfiles=1, node=-1
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> IOPS=7.89M, BW=3.85GiB/s, IOS/call=32/31
>> IOPS=7.96M, BW=3.89GiB/s, IOS/call=32/32
>> IOPS=7.99M, BW=3.90GiB/s, IOS/call=32/32
>> Exiting on timeout
>> Maximum IOPS=7.99M
>>
>> -------------------
>> with this patchset:
>> -------------------
>> sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
>> -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nullb0 /dev/nullb1
>> submitter=0, tid=35633, file=/dev/nullb0, nfiles=1, node=-1
>> submitter=1, tid=35634, file=/dev/nullb1, nfiles=1, node=-1
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> IOPS=7.79M, BW=3.80GiB/s, IOS/call=32/31
>> IOPS=7.86M, BW=3.84GiB/s, IOS/call=32/32
>> IOPS=7.89M, BW=3.85GiB/s, IOS/call=32/32
>> Exiting on timeout
>> Maximum IOPS=7.89M
>
>Thanks for the perf test!
>
>This patch only adds bio->bi_iter memory footprint, which is supposed
>to hit from L1, maybe because `bi_io_vec` is in the 2nd cacheline, can
>you see any difference with the following change?
>
>
>diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>index 5dc061d318a4..1c4570b37436 100644
>--- a/include/linux/blk_types.h
>+++ b/include/linux/blk_types.h
>@@ -240,6 +240,7 @@ struct bio {
>                /* for plugged zoned writes only: */
>                unsigned int            __bi_nr_segments;
>        };
>+       struct bio_vec          *bi_io_vec;     /* the actual vec list */
>        bio_end_io_t            *bi_end_io;
>        void                    *bi_private;
> #ifdef CONFIG_BLK_CGROUP
>@@ -275,8 +276,6 @@ struct bio {
>
>        atomic_t                __bi_cnt;       /* pin count */
>
>-       struct bio_vec          *bi_io_vec;     /* the actual vec list */
>-
>        struct bio_set          *bi_pool;
> };
>
With above patch perf numbers match the base case.

Thanks,
Nitesh Shetty

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_99373_
Content-Type: text/plain; charset="utf-8"


------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_99373_--

