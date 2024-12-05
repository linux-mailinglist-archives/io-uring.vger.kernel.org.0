Return-Path: <io-uring+bounces-5250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF6CD9E5230
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 11:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 914262813DE
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 10:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9479F1D63F6;
	Thu,  5 Dec 2024 09:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="n62mLkR1"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587951D63F2;
	Thu,  5 Dec 2024 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733392290; cv=none; b=IbB2/bQ9pmv/rj1pNH0vmT3U6NDmqN9f8qLO4DP4/yr9yYd6iOxuRMQtTg3ZIK6epg8gBSIKoT0eZwrVL3xRBi5Gnnsw5+pl7ddFbKI09XQnqq1hgn4BdYzB4K/OD/WyvKiiNSRUpSiFURnusAR+oPkv9YH9c8rId8hLv7ZkGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733392290; c=relaxed/simple;
	bh=g3ivnEGoj7MuCN0XQRgeZ0FBwp3k/UVGaiGzSKJevkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A55PkaTRqPf4gaPAv9hv6TmY78zUM0047XoqVAv51+5TBXpamGbYwy1G4YwNMfdMMiuHdLYuF0M5nWLIbCyMFUT7eJawZI3Xv11DlMYIdu++aAogfoduAEz96HI7HznfcvPtyofFJPE7/Y7pNTkTUFcKAi8L3YzFzmecHCzJmcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=n62mLkR1; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733392280; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dHHiaBL2W4K1IrTHv1zJkvtT7SdDflWxgl7A3CZWZQ4=;
	b=n62mLkR1Cx6aP1WRsAeCGDO/J1HyN4zN5wkaTZsqesEFQfDFuIedX+/YBKqLpf48wpT/tXZ/REf9HnlZKGaUWQri7EiBUyN7I+Sw0MU7COHGMhDKdI5m4QOZSAZb1lsX+vfRSk9s6vKXMgNtpZ1jhHWYmeC2UghtSqZeVZBTaMo=
Received: from 30.221.128.181(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WKswRxE_1733392279 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Dec 2024 17:51:19 +0800
Message-ID: <6ba6247e-82dd-4e58-8a6b-ecf8247a234c@linux.alibaba.com>
Date: Thu, 5 Dec 2024 17:51:18 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [Resend]Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough
 support for virtio-blk
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
 Ming Lei <ming.lei@redhat.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <CAJSP0QW2GWNCtekar68bniwB6xX=ADsh7YjFjq_bQvExRNxnyA@mail.gmail.com>
Content-Language: en-US
From: Ferry Meng <mengferry@linux.alibaba.com>
In-Reply-To: <CAJSP0QW2GWNCtekar68bniwB6xX=ADsh7YjFjq_bQvExRNxnyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Resend after change this into plain text.

On 12/5/24 5:47 AM, Stefan Hajnoczi wrote:
> On Tue, 3 Dec 2024 at 07:17, Ferry Meng <mengferry@linux.alibaba.com> wrote:
>> We seek to develop a more flexible way to use virtio-blk and bypass the block
>> layer logic in order to accomplish certain performance optimizations. As a
>> result, we referred to the implementation of io_uring passthrough in NVMe
>> and implemented it in the virtio-blk driver. This patch series adds io_uring
>> passthrough support for virtio-blk devices, resulting in lower submit latency
>> and increased flexibility when utilizing virtio-blk.
> First I thought this was similar to Stefano Garzarella's previous
> virtio-blk io_uring passthrough work where a host io_uring was passed
> through into the guest:
> https://static.sched.com/hosted_files/kvmforum2020/9c/KVMForum_2020_io_uring_passthrough_Stefano_Garzarella.pdf
>
> But now I see this is a uring_cmd interface for sending virtio_blk
> commands from userspace like the one offered by the NVMe driver.
>
> Unlike NVMe, the virtio-blk command set is minimal and does not offer
> a rich set of features. Is the motivation really virtio-blk command
> passthrough or is the goal just to create a fast path for I/O?
Sure, this series only works with guest os, not between host and guest. 
Well, 'io_uring passthrough'
gives a 'fast path for I/O' , and is ideal for our use case --- like 
using virtio-blk with command directly
from userspace scales better.
> If the goal is just a fast path for I/O, then maybe Jens would
> consider a generic command set that is not device-specific? That way
> any driver (NVMe, virtio-blk, etc) can implement this uring_cmd
> interface and any application can use it without worrying about the
> underlying command set. I think a generic fast path would be much more
> useful to applications than driver-specific interfaces.
If I understand correctly, io_uring passthrough is already a complete 
abstract framework for I/O request dispatch.
Its aim is to allow driver to handle commands on its own with bypass 
unused logic. Thus I chose this method of
implementation. I really agreed that the command set of virtio-blk is 
sufficient and minimal enough, but I also believe
that this makes it more convenient for us to adapt all command types 
with fewer modifications, so that virtio-blk
can use io_uring passthrough.

Of course, we can wait for Jens' view on the preceding discussion.
>> To test this patch series, I changed fio's code:
>> 1. Added virtio-blk support to engines/io_uring.c.
>> 2. Added virtio-blk support to the t/io_uring.c testing tool.
>> Link: https://github.com/jdmfr/fio
>>
>> Using t/io_uring-vblk, the performance of virtio-blk based on uring-cmd
>> scales better than block device access. (such as below, Virtio-Blk with QEMU,
>> 1-depth fio)
>> (passthru) read: IOPS=17.2k, BW=67.4MiB/s (70.6MB/s)
>> slat (nsec): min=2907, max=43592, avg=3981.87, stdev=595.10
>> clat (usec): min=38, max=285,avg=53.47, stdev= 8.28
>> lat (usec): min=44, max=288, avg=57.45, stdev= 8.28
>> (block) read: IOPS=15.3k, BW=59.8MiB/s (62.7MB/s)
>> slat (nsec): min=3408, max=35366, avg=5102.17, stdev=790.79
>> clat (usec): min=35, max=343, avg=59.63, stdev=10.26
>> lat (usec): min=43, max=349, avg=64.73, stdev=10.21
>>
>> Testing the virtio-blk device with fio using 'engines=io_uring_cmd'
>> and 'engines=io_uring' also demonstrates improvements in submit latency.
>> (passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -n1 -u1 /dev/vdcc0
>> IOPS=189.80K, BW=741MiB/s, IOS/call=4/3
>> IOPS=187.68K, BW=733MiB/s, IOS/call=4/3
>> (block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -n1 -u0 /dev/vdc
>> IOPS=101.51K, BW=396MiB/s, IOS/call=4/3
>> IOPS=100.01K, BW=390MiB/s, IOS/call=4/4
>>
>> The performance overhead of submitting IO can be decreased by 25% overall
>> with this patch series. The implementation primarily references 'nvme io_uring
>> passthrough', supporting io_uring_cmd through a separate character interface
>> (temporarily named /dev/vdXc0). Since this is an early version, many
>> details need to be taken into account and redesigned, like:
>> ● Currently, it only considers READ/WRITE scenarios, some more complex operations
>> not included like discard or zone ops.(Normal sqe64 is sufficient, in my opinion;
>> following upgrades, sqe128 and cqe32 might not be needed).
>> ● ......
>>
>> I would appreciate any useful recommendations.
>>
>> Ferry Meng (3):
>>    virtio-blk: add virtio-blk chardev support.
>>    virtio-blk: add uring_cmd support for I/O passthru on chardev.
>>    virtio-blk: add uring_cmd iopoll support.
>>
>>   drivers/block/virtio_blk.c      | 325 +++++++++++++++++++++++++++++++-
>>   include/uapi/linux/virtio_blk.h |  16 ++
>>   2 files changed, 336 insertions(+), 5 deletions(-)
>>
>> --
>> 2.43.5
>>
>>

