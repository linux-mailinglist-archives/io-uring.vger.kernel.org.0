Return-Path: <io-uring+bounces-5517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C7F9F4348
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 07:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FE70167D22
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 06:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162F7155326;
	Tue, 17 Dec 2024 06:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qtMU7+QX"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781E9150994;
	Tue, 17 Dec 2024 06:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734415714; cv=none; b=LaqR1y3WG7r21lQXJmZxDXRc8xZ4l3744swu4LLZSPs0zoS4Owa74mPrXfqSv8/fdA9gFoYj0HvyXmR5bp7kcDJNVuTwcr3MDyWwA6hc7iPR5OLDp9v3yRkuB6zTxaErgbUhBXUoxvO/x3RsFXt4AUGKovqRSfTti0DbdkEPDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734415714; c=relaxed/simple;
	bh=oiAvLMPsMgZzEivH5VJj51Hqd0MMOhOJQd/2QXeY5mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M6bK2l79Cc25xCwhWG+/lUxzZGMfBc4+O2uiRIWZZ68GAPdaiMC+XEMz6I6KTOC2HRhB+xPEagEpXC72wxu+87HnKvv6ZHTAhH8e5Jj/srZolhdZVCj1dbd3skam6gaTldVLzsHVHCslKLXHHxvoBoK+NHwfaipvX5mmJWd/k+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qtMU7+QX; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734415709; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iSUAqEtIVozqVmN/iyji3v3vEfG6rUwbxmxWRBFEjLE=;
	b=qtMU7+QXbZCpFijKCqD84sD7bfWK72WqHyJMOxFcGm5LD/1ufmNoC95rA3ipKnMJnLuv0tALohl8B20+QlsThTd+a4RoDDnc7hNw5d+XNHiR39YXGq/Ov8GP8W+Hmjk/m+1qj7sxxgS3GThZPUcRd/r+ykHxZRnXke+RnA0Zlh8=
Received: from 30.221.144.145(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0WLhfemn_1734415707 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 14:08:28 +0800
Message-ID: <0535520b-a6a6-4578-9aca-c698e148004e@linux.alibaba.com>
Date: Tue, 17 Dec 2024 14:08:25 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for
 virtio-blk
To: Stefan Hajnoczi <stefanha@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Ferry Meng <mengferry@linux.alibaba.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <Z2BNHWFWgLjEMiAn@infradead.org>
 <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Stefan & Christoph,

On 12/17/24 12:13 AM, Stefan Hajnoczi wrote:
> On Mon, 16 Dec 2024 at 10:54, Christoph Hellwig <hch@infradead.org> wrote:
>>
>> Hacking passthrough into virtio_blk seems like not very good layering.
>> If you have a use case where you want to use the core kernel virtio code
>> but not the protocol drivers we'll probably need a virtqueue passthrough
>> option of some kind.
> 
> I think people are finding that submitting I/O via uring_cmd is faster
> than traditional io_uring. The use case isn't really passthrough, it's
> bypass :).

Right, the initial purpose is bypassing the block layer (in the guest)
to achieve better latency when the user process is operating on a raw
virtio-blk device directly.


> 
> That's why I asked Jens to weigh in on whether there is a generic
> block layer solution here. If uring_cmd is faster then maybe a generic
> uring_cmd I/O interface can be defined without tying applications to
> device-specific commands. Or maybe the traditional io_uring code path
> can be optimized so that bypass is no longer attractive.

We are fine with that if it looks good to Jens.


-- 
Thanks,
Jingbo

