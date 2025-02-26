Return-Path: <io-uring+bounces-6777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF32DA45CB7
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7E993A35F9
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251372144AE;
	Wed, 26 Feb 2025 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X7FSIOYi"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A820B213E87;
	Wed, 26 Feb 2025 11:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740568248; cv=none; b=S8pTOgrw/m0SiQ38YSOL7fR4yFhwuyIaVmjV3Q9NVQlqyjcel9lCqivbmKfi+qAD+lPNH8nU2wlsUjuGC1FvnMHrJQvZEY9+ujN5lCIpOURjjbiLOvE9e3qF05Nz4cN4khyvIg4xfBt8UUdhtgl3rl8sHHGzL5a0hW2FM0ZtttM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740568248; c=relaxed/simple;
	bh=4I7omasySoZo/JUrFqUPmohfcJJOJWXiXsJQizCs3DE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DUea2mBUy2D7psLjB5gLpjaXDnh5EsmAJ5xypBHL3EcWUPoLofqUS7/52SOoXNYHpyvZJoDevxlYsTJUDkk7V1uvX1g9FwBOiu/H5jgNaVnEe3VvOQXAIEY9iyAoKjIVhzrmayPz4SUzwXQ271qJzcA/0dDQLvZlwyNI2NS/VqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X7FSIOYi; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740568240; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vpAtcTJM/EJCDxxy2WMQ1RGo3EUw0Xe3GtPnY0G1MaE=;
	b=X7FSIOYiW7AQXN6HaL0cIs7ZBQGdggEOG+3rwVAF2jfu9W17aoLsBFHyvYXNVJeH9OD4ACZV87APtHPAGvp+UdOqIuQQ+aNwQC24R5ixXBTVl8IvXqwB60m9Lqe+5GwLMGggNvvxFqKRdHCy7Db+owu2W2AQPz7tFP9gO7DyhtE=
Received: from 30.221.130.195(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WQI5T1B_1740568238 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Feb 2025 19:10:38 +0800
Message-ID: <be8704b0-81a4-403b-8b42-d3612099279f@linux.alibaba.com>
Date: Wed, 26 Feb 2025 19:10:36 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] virtio-blk: add io_uring passthrough support.
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
 <20250219020112.GB38164@fedora>
Content-Language: en-US
From: Ferry Meng <mengferry@linux.alibaba.com>
In-Reply-To: <20250219020112.GB38164@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/25 10:01 AM, Stefan Hajnoczi wrote:
> On Wed, Dec 18, 2024 at 05:24:32PM +0800, Ferry Meng wrote:
>> This patchset implements io_uring passthrough surppot in virtio-blk
>> driver, bypass vfs and part of block layer logic, resulting in lower
>> submit latency and increased flexibility when utilizing virtio-blk.
> Hi,
> What is the status of this patch series?
>
> Stefan

I apologize for the delayed response. It seems that the maintainer has 
not yet provided feedback on this patch series, and I was actually 
waiting for his comments before proceeding. I have received the feedback 
from the other reviewers & have already discovered some obvious mistakes 
in v1 series.


Although I'm occupied with other tasks recently, I expect to send out v2 
patches *in a week*.


Thanks.

>> In this version, currently only supports READ/WRITE vec/no-vec operations,
>> others like discard or zoned ops not considered in. So the userspace-related
>> struct is not complicated.
>>
>> struct virtblk_uring_cmd {
>> 	__u32 type;
>> 	__u32 ioprio;
>> 	__u64 sector;
>> 	/* above is related to out_hdr */
>> 	__u64 data;  // user buffer addr or iovec base addr.
>> 	__u32 data_len; // user buffer length or iovec count.
>> 	__u32 flag;  // only contains whether a vector rw or not.
>> };
>>
>> To test this patch series, I changed fio's code:
>> 1. Added virtio-blk support to engines/io_uring.c.
>> 2. Added virtio-blk support to the t/io_uring.c testing tool.
>> Link: https://github.com/jdmfr/fio
>>
>>
>> ===========
>> Performance
>> ===========
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
>> =======
>> Changes
>> =======
>>
>> Changes in v1:
>> --------------
>> * remove virtblk_is_write() helper
>> * fix rq_flags type definition (blk_opf_t), add REQ_ALLOC_CACHE flag.
>> https://lore.kernel.org/io-uring/202412042324.uKQ5KdkE-lkp@intel.com/
>>
>> RFC discussion:
>> ---------------
>> https://lore.kernel.org/io-uring/20241203121424.19887-1-mengferry@linux.alibaba.com/
>>
>> Ferry Meng (3):
>>    virtio-blk: add virtio-blk chardev support.
>>    virtio-blk: add uring_cmd support for I/O passthru on chardev.
>>    virtio-blk: add uring_cmd iopoll support.
>>
>>   drivers/block/virtio_blk.c      | 320 +++++++++++++++++++++++++++++++-
>>   include/uapi/linux/virtio_blk.h |  16 ++
>>   2 files changed, 331 insertions(+), 5 deletions(-)
>>
>> -- 
>> 2.43.5
>>

