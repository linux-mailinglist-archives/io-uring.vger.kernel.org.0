Return-Path: <io-uring+bounces-5559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C34DE9F5D7F
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 04:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B16C1890141
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 03:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBB11369B4;
	Wed, 18 Dec 2024 03:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aVra/Rpd"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125CA3597A;
	Wed, 18 Dec 2024 03:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734492929; cv=none; b=kPlFo6WOBEiJYv4SdLF4x3TCyV6H8NtG6Wcv3/BgDenYfZ7v67FlSH3+pi1N/0vxTFmUkwqGZBJS7PQ574bJLpNcsNcGNgrayEl+jSH9GAxJWkKhUhEZXFypDuUfqIN5uXdyez0JFWA4GJ/+xuiM7XEdO+yW0qylAkF4cy3Vet0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734492929; c=relaxed/simple;
	bh=vgO1U/Y8Tyjoq8LUVxkUz+j2i9Ufx61wGRhxHLFOONU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wykyte0l48rNg30J+EYftMee/rkI3cjrCPjw124aPEgenTCcv1mEO7rKmCMe7+WkAAga/ohmtZWub3YctPofJqK6ToUyKFyJp+AIbN82XBVqbcU3abvdeOzFU9aoA0auHpiPw8PgOgyos+N00o+phuJPNbfo52/YN1kX9g1sS3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aVra/Rpd; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734492923; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YGzuGWLAUDC0mlrmUfaEpO0oU9ym4tO687kSt9C3jc0=;
	b=aVra/Rpd+Q7SyqA3GgTngsfIML51prCBzKpA9yEahMzjtC+Pp4SHq6u8/75K0Y1f6uSQWuQC3XEJW4xA42M+bGojTiu3NLBjZDRdcdOuZxMGv/ovRfL25EgSAXhtumAwxYVeJxk776S5+Xbm0e0lWXsZQxXFI4UVnyz15PDVOCc=
Received: from 30.221.131.238(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WLl5IBE_1734492921 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Dec 2024 11:35:22 +0800
Message-ID: <bcc94e61-d4ce-4a33-a7cd-0cb61a516bf9@linux.alibaba.com>
Date: Wed, 18 Dec 2024 11:35:19 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for
 virtio-blk
To: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@gmail.com>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>,
 Christoph Hellwig <hch@infradead.org>, "Michael S . Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <Z2BNHWFWgLjEMiAn@infradead.org>
 <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
 <0535520b-a6a6-4578-9aca-c698e148004e@linux.alibaba.com>
 <acaf46f3-3f6c-44c9-86b5-98aa7845f1b6@kernel.dk>
 <CAJSP0QWfSzD8Z+22SEjUMkG07nrBa+6WU_APYkrvwzNbScRRCw@mail.gmail.com>
 <92eafd0f-943a-4595-8df3-45128cac5ee9@kernel.dk>
Content-Language: en-US
From: Ferry Meng <mengferry@linux.alibaba.com>
In-Reply-To: <92eafd0f-943a-4595-8df3-45128cac5ee9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/18/24 5:07 AM, Jens Axboe wrote:
> On 12/17/24 2:00 PM, Stefan Hajnoczi wrote:
>> On Tue, 17 Dec 2024 at 12:54, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 12/16/24 11:08 PM, Jingbo Xu wrote:
>>>>> That's why I asked Jens to weigh in on whether there is a generic
>>>>> block layer solution here. If uring_cmd is faster then maybe a generic
>>>>> uring_cmd I/O interface can be defined without tying applications to
>>>>> device-specific commands. Or maybe the traditional io_uring code path
>>>>> can be optimized so that bypass is no longer attractive.
>>> It's not that the traditional io_uring code path is slower, it's in fact
>>> basically the same thing. It's that all the other jazz that happens
>>> below io_uring slows things down, which is why passthrough ends up being
>>> faster.
>> Are you happy with virtio_blk passthrough or do you want a different approach?
> I think it looks fine.
>
OK, thx. I will submit the official patch for review soon after 
resolving the test bot warning.

