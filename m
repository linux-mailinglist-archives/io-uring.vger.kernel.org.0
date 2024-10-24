Return-Path: <io-uring+bounces-3963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D439AE8AE
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E91151C22042
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE5F1F941A;
	Thu, 24 Oct 2024 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2XbK3r+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC5F1F8916;
	Thu, 24 Oct 2024 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729779756; cv=none; b=sopk2aBZe8UgboCMAcNf5QbeT6DP/9AriFR9U7wKeR3LPxrwoodafdy+shWupwxhmLeKW4mdNirdXcbHfUo6vvP0prYdcPRIusXPsWcH7jdzJ+pJVBTmTsSEro4TqHdQbongABAqBu55r+RA6kjOSIkU3csAalhBNU07B8u+p7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729779756; c=relaxed/simple;
	bh=sOI8aqHVtj6+g5SMf5Xcjj3u5GOnSPPtIk64foCW2cg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nk2l8jhBY13v+xIuJ7HiMduV4yGIQPZSHBEVSD986I5/UqJzoCH4EoUjWM0GKJix/5r938uddi0hViqFEotrYmBdhoRIqblg6wu2+dW3XaqTYNzHPlLsktRNRp88Vb+xig06gDx4+fuawO8VFGaRqMqe1arqIgM0NT0qf1XdjC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2XbK3r+; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9a68480164so123100666b.3;
        Thu, 24 Oct 2024 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729779752; x=1730384552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pSqi+3PC05VeA94dhrf62qDJWgidvaFzLSlQCgbK+0=;
        b=m2XbK3r+Cy+k4v9BiPCL33+xkHW3rpNNDQdWQz7SUHwLiQXl7dUQRhw5ASuAmnIS7x
         S3SA/jxb6yepLuM8Cc2VnNjiVK0j2K7biRV+yd3ypj2nPuk69qUprFEKnZXD1U/Q4FCX
         SR3yHwzfLmlZ4n0dYTlLddwU458zwvm5yYGdysP76ZAKHTgXtwolfj0Qvzeaz/d8RmXi
         EfGqfpHRIWhqN09LCmtBWMOtHKycKjhOkP4nNDTitwm+ZW83d6eFYyJ7ufwj+iqBnrVu
         KaxO+zXyN1wruA+bofs8GMuCkG3yd6wCvncDx/8vtP3vmHZmwWyQLsxDOSxy2C24lBdO
         U8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729779752; x=1730384552;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0pSqi+3PC05VeA94dhrf62qDJWgidvaFzLSlQCgbK+0=;
        b=pm/zzqZiK9J6P5bhQVhaeXltiXzKiZnRnTT/6AbhHeKJLHV7kcoGrYsz8FYLaAnFRr
         9zqHBP2+/mrXuujjD+fT7fTI2wQmZ+UsEqv0Pah2MUsQ7H/3lgxT3+pWSK0EDkRWCN1y
         fQZjikb5ov5tpsKkf3qp2q72vYQfBOsX1v6b5zKuOZyrXwBypnm2lM+hkGGSjP+sCQyQ
         Z4P6zL+Hr9b8LEuHxvq1BPpd+Guj9DCBLTfcRdG6YW5bX7KASY8FB1jizZ1VHmaYh66v
         oK4JZwdfjWA2enUGlA+wNUppTI7h+4UXvBsKoL0yG1oqEcWG2Cu4t3mOP0nIj244yCst
         sWmw==
X-Forwarded-Encrypted: i=1; AJvYcCU2JuSrSwQeHjvMSiqiVQm6sWfxYQNkZMZtWYhhBhhqUOb4l9Ap3l2Hpk6PTK/T5OGX0OYDYsis@vger.kernel.org, AJvYcCXSMelAkPlenDNL8566ANickytWn/xpgnrHdgLgtm/DZzR6CWe1J3wzHN72ozQgkWXqZ1vc9T9BgA==@vger.kernel.org, AJvYcCXwb4GDphGQLytHnKAcTyAdyL/3w9qjQghkRACrQ3PwGhPvyBCwUjZw035VFhj7vSVFqJjP9qFtLgmiyas=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMVV9qE2riy03adf8e28Bn8qjuAoRQPAsQA+9HxEn3in5t4BVi
	2h+ooXaxj/2c2jiTeLHKPqDuM4nQpVejtHW9dRRFoWRxDyEHfzIu
X-Google-Smtp-Source: AGHT+IEhWU2BvgzQwO2fdoa0iaeVhQCobTSzJZ6wAch+t8B6eIAoD1nCu9Hb/QFiEcfBfYcdzO7TPA==
X-Received: by 2002:a17:907:7e88:b0:a9a:2afc:e4cc with SMTP id a640c23a62f3a-a9ad2861ac4mr203963166b.58.1729779751939;
        Thu, 24 Oct 2024 07:22:31 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d6ef1sm618829266b.38.2024.10.24.07.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:22:31 -0700 (PDT)
Message-ID: <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
Date: Thu, 24 Oct 2024 15:23:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/15] net: generalise net_iov chunk owners
To: Christoph Hellwig <hch@infradead.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk> <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
 <ZxoSBhC6sMEbXQi8@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZxoSBhC6sMEbXQi8@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 10:23, Christoph Hellwig wrote:
> On Wed, Oct 23, 2024 at 03:34:53PM +0100, Pavel Begunkov wrote:
>> It doesn't care much what kind of memory it is, nor it's important
>> for internals how it's imported, it's user addresses -> pages for
>> user convenience sake. All the net_iov setup code is in the page pool
>> core code. What it does, however, is implementing the user API, so
> 
> That's not what this series does.  It adds the new memory_provider_ops
> set of hooks, with once implementation for dmabufs, and one for
> io_uring zero copy.

First, it's not a _new_ abstraction over a buffer as you called it
before, the abstraction (net_iov) is already merged.

Second, you mention devmem TCP, and it's not just a page pool with
"dmabufs", it's a user API to use it and other memory agnostic
allocation logic. And yes, dmabufs there is the least technically
important part. Just having a dmabuf handle solves absolutely nothing.

> So you are precluding zero copy RX into anything but your magic
> io_uring buffers, and using an odd abstraction for that.

Right io_uring zero copy RX API expects transfer to happen into io_uring
controlled buffers, and that's the entire idea. Buffers that are based
on an existing network specific abstraction, which are not restricted to
pages or anything specific in the long run, but the flow of which from
net stack to user and back is controlled by io_uring. If you worry about
abuse, io_uring can't even sanely initialise those buffers itself and
therefore asking the page pool code to do that.

> The right way would be to support zero copy RX into every
> designated dmabuf, and make io_uring work with udmabuf or if

I have no idea what you mean, but shoving dmabufs into every single
place regardless whether it makes sense or not is hardly a good
way forward.

> absolutely needed it's own kind of dmabuf.  Instead we create

I'm even more confused how that would help. The user API has to
be implemented and adding a new dmabuf gives nothing, not even
mentioning it's not clear what semantics of that beast is
supposed to be.

> a maze of incompatible abstractions here.  The use case of e.g.
> doing zero copy receive into a NVMe CMB using PCIe P2P transactions
> is every but made up, so this does create a problem.

That's some kind of a confusion again, there is no reason why
it can't be supported, transparently to the non-setup code at
that. That's left out as other bits to further iterations to
keep this set simpler.

-- 
Pavel Begunkov

