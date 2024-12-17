Return-Path: <io-uring+bounces-5516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E10B39F4341
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 07:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60FDE188B361
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 06:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B16D155326;
	Tue, 17 Dec 2024 06:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oeMxCCBW"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCD918E20;
	Tue, 17 Dec 2024 06:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734415459; cv=none; b=JqgnRiuEbkFHC/hGk8HrWZIa6P+w4Wk4U0gs4qeNx1wLfYippTTBPs1JT4uod/lFYUZQg0FnC7Xch4q8Pj2pmiIl0F75o7O87SL03i6ORVQ/R1Rm4wFo8j1LnrbkQQRydDTY9guCvGRhHHpeSttQmGRjDlvTokmT6tJ1jGp62Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734415459; c=relaxed/simple;
	bh=mgE7VurThazcWTFWnM8rKUzhYlIjwW6BRYL6WIpQFK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QymLNWc1ZWeswq9B8OyiH5TLIuXyxFuXNjf254ov4UKKzzEY3Id967KfYg2NbPns7bfMun/Gq8o5cS7ybwUnTWFgNu8SBB4k9IkclSQ6cjUcQG5NEf+MqrK/2MrXd988PzOGdzWGr8UJ/qsxlKbV1QARtx6cGmlQdz9G4SumPMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oeMxCCBW; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734415447; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kMXYp3DgCHQUnOyKJxx00E0pLt7BluIKLu/4adsuhLI=;
	b=oeMxCCBWeluoDkk6M7nDSfDF1rvWW+7y/mal2apAyarZJDorKKJxG/34bKz6jGz9gn1KDtG5qagTbkKwGzPoNmKU3K6HBou+RQfYp2aF3Rdw8POPFXoEENBToRsTAG7QL5I1r1sMgcgyU6fx3uBDecuQFL0H0/s8g4V9N1jtV4c=
Received: from 30.221.131.173(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WLhaV33_1734415446 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 14:04:06 +0800
Message-ID: <6c071252-2b47-48d1-b111-3b01b90b7f1c@linux.alibaba.com>
Date: Tue, 17 Dec 2024 14:04:04 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for
 virtio-blk
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <2d4ad724-f9da-4502-9079-432935f5719d@linux.alibaba.com>
 <CACGkMEuAgAcCDrCMhNHr7gcRB6NtMPPLdSFAOGdt4dXGoQr4Yg@mail.gmail.com>
 <60fd6f1a-ddf5-4b53-8353-18dcd8f6f93c@linux.alibaba.com>
 <CACGkMEu4=nt0R1pmTauuK_vcc_fbObmyWqe0TO0HhuexmZWHJQ@mail.gmail.com>
Content-Language: en-US
From: Ferry Meng <mengferry@linux.alibaba.com>
In-Reply-To: <CACGkMEu4=nt0R1pmTauuK_vcc_fbObmyWqe0TO0HhuexmZWHJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/17/24 10:08 AM, Jason Wang wrote:
> On Mon, Dec 16, 2024 at 8:07 PM Ferry Meng <mengferry@linux.alibaba.com> wrote:
>>
>> On 12/16/24 3:38 PM, Jason Wang wrote:
>>> On Mon, Dec 16, 2024 at 10:01 AM Ferry Meng <mengferry@linux.alibaba.com> wrote:
>>>> On 12/3/24 8:14 PM, Ferry Meng wrote:
>>>>> We seek to develop a more flexible way to use virtio-blk and bypass the block
>>>>> layer logic in order to accomplish certain performance optimizations. As a
>>>>> result, we referred to the implementation of io_uring passthrough in NVMe
>>>>> and implemented it in the virtio-blk driver. This patch series adds io_uring
>>>>> passthrough support for virtio-blk devices, resulting in lower submit latency
>>>>> and increased flexibility when utilizing virtio-blk.
>>>>>
>>>>> To test this patch series, I changed fio's code:
>>>>> 1. Added virtio-blk support to engines/io_uring.c.
>>>>> 2. Added virtio-blk support to the t/io_uring.c testing tool.
>>>>> Link: https://github.com/jdmfr/fio
>>>>>
>>>>> Using t/io_uring-vblk, the performance of virtio-blk based on uring-cmd
>>>>> scales better than block device access. (such as below, Virtio-Blk with QEMU,
>>>>> 1-depth fio)
>>>>> (passthru) read: IOPS=17.2k, BW=67.4MiB/s (70.6MB/s)
>>>>> slat (nsec): min=2907, max=43592, avg=3981.87, stdev=595.10
>>>>> clat (usec): min=38, max=285,avg=53.47, stdev= 8.28
>>>>> lat (usec): min=44, max=288, avg=57.45, stdev= 8.28
>>>>> (block) read: IOPS=15.3k, BW=59.8MiB/s (62.7MB/s)
>>>>> slat (nsec): min=3408, max=35366, avg=5102.17, stdev=790.79
>>>>> clat (usec): min=35, max=343, avg=59.63, stdev=10.26
>>>>> lat (usec): min=43, max=349, avg=64.73, stdev=10.21
>>>>>
>>>>> Testing the virtio-blk device with fio using 'engines=io_uring_cmd'
>>>>> and 'engines=io_uring' also demonstrates improvements in submit latency.
>>>>> (passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -n1 -u1 /dev/vdcc0
>>>>> IOPS=189.80K, BW=741MiB/s, IOS/call=4/3
>>>>> IOPS=187.68K, BW=733MiB/s, IOS/call=4/3
>>>>> (block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -n1 -u0 /dev/vdc
>>>>> IOPS=101.51K, BW=396MiB/s, IOS/call=4/3
>>>>> IOPS=100.01K, BW=390MiB/s, IOS/call=4/4
>>>>>
>>>>> The performance overhead of submitting IO can be decreased by 25% overall
>>>>> with this patch series. The implementation primarily references 'nvme io_uring
>>>>> passthrough', supporting io_uring_cmd through a separate character interface
>>>>> (temporarily named /dev/vdXc0). Since this is an early version, many
>>>>> details need to be taken into account and redesigned, like:
>>>>> ● Currently, it only considers READ/WRITE scenarios, some more complex operations
>>>>> not included like discard or zone ops.(Normal sqe64 is sufficient, in my opinion;
>>>>> following upgrades, sqe128 and cqe32 might not be needed).
>>>>> ● ......
>>>>>
>>>>> I would appreciate any useful recommendations.
>>>>>
>>>>> Ferry Meng (3):
>>>>>      virtio-blk: add virtio-blk chardev support.
>>>>>      virtio-blk: add uring_cmd support for I/O passthru on chardev.
>>>>>      virtio-blk: add uring_cmd iopoll support.
>>>>>
>>>>>     drivers/block/virtio_blk.c      | 325 +++++++++++++++++++++++++++++++-
>>>>>     include/uapi/linux/virtio_blk.h |  16 ++
>>>>>     2 files changed, 336 insertions(+), 5 deletions(-)
>>>> Hi, Micheal & Jason :
>>>>
>>>> What about yours' opinion? As virtio-blk maintainer. Looking forward to
>>>> your reply.
>>>>
>>>> Thanks
>>> If I understand this correctly, this proposal wants to make io_uring a
>>> transport of the virito-blk command. So the application doesn't need
>>> to worry about compatibility etc. This seems to be fine.
>>>
>>> But I wonder what's the security consideration, for example do we
>>> allow all virtio-blk commands to be passthroughs and why.
>> About 'security consideration', the generic char-dev belongs to root, so
>> only root can use this passthrough path.
> This seems like a restriction. A lot of applications want to be run
> without privilege to be safe.
>
I'm sorry that there may have been some misunderstanding in my previous 
explanation. The generic cdev file's default group is 'root,' but we can 
just use 'chgrp' and change it to what we want.

After which, apps can then utilize it, just like they would with a 
standard file.

>> On the other hand, to what I know, virtio-blk commands are all related
>> to 'I/O operations', so we can support all those opcodes with bypassing
>> vfs&block layer (if we want). I just realized the most  basic read/write
>> in this RFC patch series, others will be considered later.
>>
>>> Thanks
>>>
> Thanks

