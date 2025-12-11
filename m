Return-Path: <io-uring+bounces-11006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 90FE1CB48D3
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 03:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DEF473024896
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 02:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A002C028B;
	Thu, 11 Dec 2025 02:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2qfM6v1T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C89F2BCF46
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765419369; cv=none; b=DxdQXjQMgDBrIP53pIsjk0/gsB86suybDMxEyAvUxVGs0aJjhQEW4JHZx4GfXK1WBA/+pkhY1kJX43sDOGuvSmH5AgrlaOto3/q2DjvaVmU/kkGgnokBIWgiZwCHdVJGs/MHxvplH5270jvuLzrGaLjr1aVOWBOIBcP1G1rbkhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765419369; c=relaxed/simple;
	bh=IITj8chV1fWqP5ABqf9ciU7vi4pLaCJdeDU26vaW6OA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PG7bmP9KttWMTkKtYStVOIAML5I9K7v5tMa7vOvN4gujIIl+033177g1DkRSydJOcPOGZG94vshgUz4VVelUQlnp13+p7t655KHTciXiXR8ZYQci+gf25ycSswKBAXMIk+8eSjzXvb3xOxJcr8eyrXAg0MOLJrTTwWexkcrP2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2qfM6v1T; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-29806bd47b5so3193515ad.3
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 18:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765419361; x=1766024161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qtx9nimvwBLnbZg89OP0PtMlzJozkG4mIucdatA4lmo=;
        b=2qfM6v1Tsj64HUNHhrC1PxB312WckD7kpvVSYAUeVtDpu0Gdrk/cmC3pxCaaJPu+bS
         kTuQA2uFIx7ig+k8ot+w+Hr/qzXa7TZvcny9rS9lcdj2/BSGvLBrqaOI4Kvi2o9fHb8M
         1kaTizcpYcKhJW/LCJ+01kJL14FJroSYSNqKqYu1CxN0hU+kfZOtfpaDgWqy1KTE0V6S
         10WdHxBm6/l8xJkahMYm2c7fnyNW+GsIq5wSWPSX5fof0+9uaaCVxk7hUqIMqHGVK2hY
         1z3lga73H5CvsF3KIzLR+gzGK0pBe91r8e5oDbJd+XzBtX3laHK0HJlc4k3aB1W5AKvF
         6FEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765419361; x=1766024161;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qtx9nimvwBLnbZg89OP0PtMlzJozkG4mIucdatA4lmo=;
        b=VIOPErIOpStMU2HnneUF/SzPRxIXgvcDcTizxTB2Z/NV/mgYwaNuudkwDcjjOZ1fC+
         LGPXhYdDMOZJo6fvsQh+FMX5V0KlOOC6hiFktSY0WE+dr1ChlKTPHYolORdtQU69TMck
         qj5PIlvHg59YySwiOq1IrrCe47IxdzOz0NrVB9zfJqqOUs0Jy0n7BYGkSzKBxflyoSPZ
         UCJNhlnoN5/yquZWjUtAje3NU3Vj4Ui3BYeXq+SajWXyvbrfg7Qq9V6Xfgjyzksjr+si
         zBXNE4IDTMNG/MBBIFORwfOlfzW89SiPo6JO5KfQjZw+kHuogbfwgcl/ji01zHjYbEoS
         wloQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0KHLgiyBN3OvoG6EIudnE2SYUToXF0U/c9BOjhy6vdBN3C1IT/SC47UzbccfhRXQYqKXzHmnTrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHGayyJuNalWxFYBR9Elh2eZAaiys3MQRL5E1kFBl70sUvIGbx
	Ed23sciZN1JuEtU9LpsNwlwVhVUQxq1uALkCuqMe1J+sqCqRlQJREP/xXzus3TWZV9Y=
X-Gm-Gg: AY/fxX7ytcVVPm131+j6hZvUO6YOWjFUOIOLwr6LyeK/rDDnTUJepM28K7ukemHz8Hj
	aN0pyL9yKboyqogE7tIWK9U1dVVZqDZQn8RydFXq4IowOITz+6YtE9xe+XuEECY8cdveENPDE10
	+4qd6W4ccy+xC0RHveMaCCQwKtHQDK1zldHC4YJuD6xVDjuEtOJvZDr+w3CkWqFFcweJ/cSmlCD
	oWan9jTLFksiSvyzQEss5n8Vv/ZKmbikTjGzeTKtMMlNdbDIsA0KV0X7/0e+zu1O+lLG1g4MhaR
	s1m4QrZd46mjVdX6W35VRjnVvILg9i0StZOxUlu0RfThioEnRKz7ddRmp13D00nWBBfHdtj1vzl
	QTYu+O33aqW1Bp3Gwno+9XZJ5rdvVm/4yP/ieevjlpnqEOR68N4LHor35mql1uTID43KyYybGRv
	E6USqYRyaucXIFkD12Q22641ivNKDTI4UYKBNhBdfUnQ==
X-Google-Smtp-Source: AGHT+IEzsJFla9AuhK68LtA+UI433tkpP9f0tzz3UjT68X7cgNinCxUoJppwPqmU36U5y8uzxhHmDg==
X-Received: by 2002:a17:902:c40d:b0:295:94e1:91da with SMTP id d9443c01a7336-29ec2d3e7ecmr49139005ad.33.1765419361116;
        Wed, 10 Dec 2025 18:16:01 -0800 (PST)
Received: from [10.200.3.177] (fs98a57d9d.tkyc007.ap.nuro.jp. [152.165.125.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea043d21sm6123865ad.81.2025.12.10.18.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 18:16:00 -0800 (PST)
Message-ID: <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
Date: Wed, 10 Dec 2025 19:15:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251210085501.84261-3-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/25 1:55 AM, Fengnan Chang wrote:
> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
> is considered that the current req is the actual completed request.
> This may be reasonable for multi-queue ctx, but is problematic for
> single-queue ctx because the current request may not be done when the
> poll gets to the result. In this case, the completed io needs to wait
> for the first io on the chain to complete before notifying the user,
> which may cause io accumulation in the list.
> Our modification plan is as follows: change io_wq_work_list to normal
> list so that the iopoll_list list in it can be removed and put into the
> comp_reqs list when the request is completed. This way each io is
> handled independently and all gets processed in time.
> 
> After modification,  test with:
> 
> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
> /dev/nvme6n1
> 
> base IOPS is 725K,  patch IOPS is 782K.
> 
> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
> /dev/nvme6n1
> 
> Base IOPS is 880k, patch IOPS is 895K.

A few notes on this:

1) Manipulating the list in io_complete_rw_iopoll() I don't think is
   necessarily safe. Yes generally this is invoked from the
   owning/polling task, but that's not guaranteed.

2) The patch doesn't apply to the current tree, must be an older
   version?

3) When hand-applied, it still throws a compile warning about an unused
   variable. Please don't send untested stuff...

4) Don't just blatantly bloat the io_kiocb. When you change from a
   singly to a doubly linked list, you're growing the io_kiocb size. You
   should be able to use a union with struct io_task_work for example.
   That's already 16b in size - win/win as you don't need to slow down
   the cache management as that can keep using the linkage it currently
   is using, and you're not bloating the io_kiocb.

5) The already mentioned point about the cache free list now being
   doubly linked. This is generally a _bad_ idea as removing and adding
   entries now need to touch other entries too. That's not very cache
   friendly.

#1 is kind of the big one, as it means you'll need to re-think how you
do this. I do agree that the current approach isn't necessarily ideal as
we don't process completions as quickly as we could, so I think there's
merrit in continuing this work.

-- 
Jens Axboe

