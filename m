Return-Path: <io-uring+bounces-11218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B62CCC7A7
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 16:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87A483066DED
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 15:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D710234CFC3;
	Thu, 18 Dec 2025 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="idnrF0tj"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DA34BA4C
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766071083; cv=none; b=MDo+0Qx6cxCIcCFrvS11xq1QEfdA4uAcqvaZzwbiwEkGGEx0Zabo6t7CJXCLDDcyrZVOjEUEYh3Y7WQ7FN+rvwsbsRG6GC5SOtNVc+Pm5nu2J2yEByaIii3UVELbaW8W1TDX/3y/uEzy7ssTxg6stT3+CmPQgciDcuuguLR1SRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766071083; c=relaxed/simple;
	bh=ORIcU7qHW2UWE/j28Ma9KQ7RTMfvMi4hnvV8NIjCVO0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=m8vAplQe4+YN+J1n5po7O73GTZ+1eqnax0wi87Iddb9efeKntmvW3HK1dfaRYMAuaeH8ksLfmTcmTIWPcs4T/uuCURTXZ/5F3MEZzly6wXkZdr2mvoluqi/WxpchAOOLCxr01S1+JXhRZV7wv5j/VDi1jXLKJq/4wLPu8yjacNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=idnrF0tj; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251218151757epoutp0461741c58ad579aab51349bab39af7ce6~CWEmqKoQ92121121211epoutp04k
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 15:17:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251218151757epoutp0461741c58ad579aab51349bab39af7ce6~CWEmqKoQ92121121211epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766071077;
	bh=NnYPfNy0MbsOovcoe5ScELa/2h9KjAxMlUY7Kuf4Ms8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=idnrF0tjXtb1M9KeF6yxrkCA4t41jjb2N1ZpxETut/EH5NzVgGzLVVi+WCMefhtbA
	 QWHkDZ79DgcgC9PleuDagj4+zw7MYaZCFJOtJYnN4iP2OicDCAoWbHDk/IQ9RCtiZa
	 GKox8GA3wJxk5JNju7CWNs69zlZVSRITIPWqOYS8=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251218151756epcas5p354850718b40d1fd7920e0f0fa9244970~CWEmT1fZ22316923169epcas5p31;
	Thu, 18 Dec 2025 15:17:56 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dXDnH6zd2z2SSKX; Thu, 18 Dec
	2025 15:17:55 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e~CWEk8s3gC3113831138epcas5p2Y;
	Thu, 18 Dec 2025 15:17:55 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251218151754epsmtip26def445f332412ab594a215f8b16cc08~CWEj8w4im0676306763epsmtip2B;
	Thu, 18 Dec 2025 15:17:54 +0000 (GMT)
Date: Thu, 18 Dec 2025 20:46:47 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, Caleb Sander Mateos
	<csander@purestorage.com>, huang-jl <huang-jl@deepseek.com>
Subject: Re: [PATCH 1/3] block: fix bio_may_need_split() by using bvec
 iterator way
Message-ID: <20251218151522.m4dgyf4nkrfsgkrv@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aUPNLNHVz2-Y-Z4C@fedora>
X-CMS-MailID: 20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_9269c_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e
References: <20251218093146.1218279-1-ming.lei@redhat.com>
	<20251218093146.1218279-2-ming.lei@redhat.com>
	<aUPLYcAx2dh-DvuP@infradead.org> <aUPNLNHVz2-Y-Z4C@fedora>
	<CGME20251218151755epcas5p2da7c90c8fdb9ab22ff3338b7169a6f7e@epcas5p2.samsung.com>

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_9269c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 18/12/25 05:45PM, Ming Lei wrote:
>On Thu, Dec 18, 2025 at 01:37:37AM -0800, Christoph Hellwig wrote:
>> On Thu, Dec 18, 2025 at 05:31:42PM +0800, Ming Lei wrote:
>> > ->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
>> > passed to bio_may_need_split().
>> >
>> > So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
>> > checking with help from bio size and bvec->len.
>> >
>> > Meantime retrieving the 1st bvec via __bvec_iter_bvec().
>>
>> That totally misses the point.  The ->bi_vcnt is a fast and lose
>> check to see if we need the fairly expensive iterators to do the
>> real check.
>
>It is just __bvec_iter_bvec(), whatever it should be in cache sooner or
>later.
>
>
Functionality wise overall patch looks fine to me, but as Christoph
stated there is slight performance(IOPS) penalty.
Here is my benchmarking numbers[1], I suspect Jens setup might show
more regression.

Regards,
Nitesh


[1]
===============================
a. two optane nvme device setup:
----------
base case:
----------
sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
-d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
submitter=0, tid=206586, file=/dev/nvme0n1, nfiles=1, node=-1
submitter=1, tid=206587, file=/dev/nvme1n1, nfiles=1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=6.45M, BW=3.15GiB/s, IOS/call=32/31
IOPS=6.47M, BW=3.16GiB/s, IOS/call=32/32
IOPS=6.47M, BW=3.16GiB/s, IOS/call=32/32
Exiting on timeout
Maximum IOPS=6.47M

----------------
with this patch:
----------------
sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
-d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
submitter=0, tid=6352, file=/dev/nvme0n1, nfiles=1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
submitter=1, tid=6353, file=/dev/nvme1n1, nfiles=1, node=-1
IOPS=6.30M, BW=3.08GiB/s, IOS/call=32/31
IOPS=6.35M, BW=3.10GiB/s, IOS/call=32/31
IOPS=6.37M, BW=3.11GiB/s, IOS/call=32/32
Exiting on timeout
Maximum IOPS=6.37M

=============================
b. two null-blk device setup:
------------------
null device setup:
------------------
sudo modprobe null_blk queue_mode=2 gb=10 bs=512 nr_devices=2 irqmode=2 \
completion_nsec=1000000 hw_queue_depth=256 memory_backed=0 discard=0 \
use_per_node_hctx=1

----------
base case:
----------
sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
-d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nullb0 /dev/nullb1
submitter=0, tid=6743, file=/dev/nullb0, nfiles=1, node=-1
submitter=1, tid=6744, file=/dev/nullb1, nfiles=1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=7.89M, BW=3.85GiB/s, IOS/call=32/31
IOPS=7.96M, BW=3.89GiB/s, IOS/call=32/32
IOPS=7.99M, BW=3.90GiB/s, IOS/call=32/32
Exiting on timeout
Maximum IOPS=7.99M

-------------------
with this patchset:
-------------------
sudo taskset -c 0,1 /home/nitesh/src/private/fio/t/io_uring -b512 \
-d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nullb0 /dev/nullb1
submitter=0, tid=35633, file=/dev/nullb0, nfiles=1, node=-1
submitter=1, tid=35634, file=/dev/nullb1, nfiles=1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=7.79M, BW=3.80GiB/s, IOS/call=32/31
IOPS=7.86M, BW=3.84GiB/s, IOS/call=32/32
IOPS=7.89M, BW=3.85GiB/s, IOS/call=32/32
Exiting on timeout
Maximum IOPS=7.89M

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_9269c_
Content-Type: text/plain; charset="utf-8"


------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_9269c_--

