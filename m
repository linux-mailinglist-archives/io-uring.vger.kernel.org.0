Return-Path: <io-uring+bounces-6553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8D5A3BADF
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 10:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 640331887196
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 09:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256F51C7013;
	Wed, 19 Feb 2025 09:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAw/N+A+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4DA13DBB1;
	Wed, 19 Feb 2025 09:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739958828; cv=none; b=j5Tv/+g8gsYopxnajw1HUHcVpKwNaOV0Ln0376dXjtZ928fsTt2QwgncvF11hSoUPbIDAhUjJWjdfq5flusa4d5Xt2zs0dU/Gh5y2QQjqBG11DqwSo3d77LJpbuV1wBgjCEt2lp9CqLSoc+f4isxc0Fgednt5seqBnYCQK9FRQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739958828; c=relaxed/simple;
	bh=9zMxULsGqQ7gDfDiKZ5t36pt3F85uAzKX3o+oHMqspM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slRx9YPoMeHZtNYNsgy83DQfPrdPb88AIOiC2UqIE2eDbSjXSqWJsjUnIMa8CBfrk5MdX5Y8CgcJaDqOEAzJbWaz+VFhqp57cloAbeYYRv4o16tzQrurDUZYCZKYoTVpXMfKjkAIRkQqsI0Ni1qp/ReNJQg7ZT3AFwUYBA7H6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAw/N+A+; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e033c2f106so5976327a12.3;
        Wed, 19 Feb 2025 01:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739958825; x=1740563625; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P7o+P8taEpT01om+/+RO+GUypGuL91LJf+fxnfbpHSE=;
        b=CAw/N+A+QybQxXwF1CiqmByu4YSLa29wsiFyPpWxYXGZV5MppmVjk/CO8djcLtGRPL
         CEpvVoYBhOrj1aFfYNqilCYaM+CCff78OKim4Ok1u9U+yhYQXfxP35VFOsckcDwAolZv
         PHBt75KVcspq5X4M4/M2i2nj+lVArKQA7wWCA1MzvwHRvi0/Az0WsqmJS/M0HnfFcsnh
         CkRKY7wbUG5XxV8IivtYJ4FNtbndLi6IPp9Ki2ZX0rtQe84yb9M3kZ4lQhXvRtqkxZ5t
         lImi4wT7jXStWScXo+n+LiPcRyFHzciw/DncpxOxccPGaQurStyy30nmaZpkp0N9XV2G
         7Y9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739958825; x=1740563625;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7o+P8taEpT01om+/+RO+GUypGuL91LJf+fxnfbpHSE=;
        b=MQwn256zEYDVjIUrJ1FjzGs9g2iHkThgNVh7K7cZ/cpHJ1KMgdSrZ8w6lmbQ8opYMQ
         F+SBDMF7R/rIlo/SekTip3bJGBPc7Nk5VLk7EjV9SE6J3YVuuuU9winzMFylocNL+guF
         nDUrlcNWLgGT/TnsMS40ZDw+ybiRGDPKLgQ/C1Pzr6NfqsLXlIw5DsYbWUgNIR3Qztg9
         BMvqKzh0y2P6bwCcSBF40diDSGHH3qm0UU5rxeRPuMbMa9FU/H+U3wd66/fiTYouxkVm
         34CGsu7aWb5hBEoR3tR7qJEmNs6lswqMv+VU77AzKS/MotjCZYDChW4gyV6PNn+TeeJl
         gLfg==
X-Forwarded-Encrypted: i=1; AJvYcCWkVULJVJuh4YhDaLvr0rHhg4b0d1mbZueEll+vWlthyDEFEYEfg6Wudgb1z0Qha/4fDVxv5WOUlg==@vger.kernel.org, AJvYcCWlKPMB1lr0yactnhqqOYDMY0Oaodl/PRj84Z6MnFjbQE9k8kht5Hi+45DSoVUvarrdt/egQBK4@vger.kernel.org
X-Gm-Message-State: AOJu0Yym9kqvD3lJbBRZeYIBUkxJoiMn6SwSo0Ap3f2guTb1C1OT1r8q
	foiIf//F2OHY6SsqKCLTi3aWXcFIKLmdDbSsMqL3SWjIuV70oR55
X-Gm-Gg: ASbGncv5yI8limDfr4B3D3KttR2wmdPaTZxt35V0V+K3ubGu+jbQgM3Rueb77cKO6b/
	bDn+nCK07mbL+vQVnGyWDKBJyqF4QscnmD7H5h57lp20Gjd4kAGmNL6Ir8E8FsI9fYqQC6CIRFE
	Suyt6woqIsu8uux5BzcSYzYyMOXRyw1wHt/m0Xay/tmGwXcaZU/LToI3bel4NISOlxtX+Von76E
	W89ctoMttX4DaNmXOyOAv1gZ5Zvi0PEeKnzP60NNBnL8rhpojTrGfLhrsXy+bLgKSMT6qX8wHcB
	Rv5j9BpXCgWkPxEpwYVw4XOqrXS5KPeYjdkhcnIqdRu4VGFb
X-Google-Smtp-Source: AGHT+IFE8BS5Pf2RumJv8EPw6tTZB3sGCiSpOadUHtqWRlCviFylc2824gtm5/hf98kg5AeOHHeUmQ==
X-Received: by 2002:a05:6402:3547:b0:5dc:cf9b:b04a with SMTP id 4fb4d7f45d1cf-5e035ff9d49mr36537133a12.1.1739958824483;
        Wed, 19 Feb 2025 01:53:44 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:cfff])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb9de73d1csm528737466b.140.2025.02.19.01.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 01:53:43 -0800 (PST)
Message-ID: <78dba0c0-5cc6-4634-b657-f5575fd37770@gmail.com>
Date: Wed, 19 Feb 2025 09:54:50 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/11] io_uring/zcrx: set pp memory provider for an rx
 queue
To: David Wei <dw@davidwei.uk>, Kees Bakker <kees@ijzerbout.nl>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, lizetao <lizetao1@huawei.com>
References: <20250215000947.789731-1-dw@davidwei.uk>
 <20250215000947.789731-8-dw@davidwei.uk>
 <cc1b81b3-f02c-46d0-b4be-34bba23d20c7@ijzerbout.nl>
 <5eac0173-c75e-40b3-a1bd-7cedf86237df@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5eac0173-c75e-40b3-a1bd-7cedf86237df@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 22:06, David Wei wrote:
> On 2025-02-18 11:40, Kees Bakker wrote:
>> Op 15-02-2025 om 01:09 schreef David Wei:
>>> Set the page pool memory provider for the rx queue configured for zero
>>> copy to io_uring. Then the rx queue is reset using
>>> netdev_rx_queue_restart() and netdev core + page pool will take care of
>>> filling the rx queue from the io_uring zero copy memory provider.
>>>
>>> For now, there is only one ifq so its destruction happens implicitly
>>> during io_uring cleanup.
>>>
>>> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>>    io_uring/zcrx.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
>>>    1 file changed, 41 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 8833879d94ba..7d24fc98b306 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>> [...]
>>> @@ -444,6 +475,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>>>          if (ctx->ifq)
>>>            io_zcrx_scrub(ctx->ifq);
>>> +
>>> +    io_close_queue(ctx->ifq);
>> If ctx->ifq is NULL (which seems to be not unlikely given the if statement above)
>> then you'll get a NULL pointer dereference in io_close_queue().
> 
> The only caller of io_shutdown_zcrx_ifqs() is io_ring_exit_work() which
> checks for ctx->ifq first. That does mean the ctx->ifq check is
> redundant in this function though.

And despite the check being outside of the lock, it's even well
synchronised, but in any case we should just make it saner. Thanks
for letting know

-- 
Pavel Begunkov


