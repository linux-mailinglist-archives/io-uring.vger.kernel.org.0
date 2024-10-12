Return-Path: <io-uring+bounces-3626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C488099B583
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 16:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CAAB1F21495
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 14:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641C7155CBF;
	Sat, 12 Oct 2024 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qv8S1jp+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273608F66
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728743899; cv=none; b=KBbhkGm4qUVUDA7QE2jWkA8bEpufjWneXIVsIwQQPhYtjdKXQtbk2l4UJhbGkvkQj7nLZ3H7LNUDJHdPyws5Di9d8B6B5UQquEL5mF69zYEt2n3B0ZntvsnRMeHgtrFkRzX2nZZUEJa2AZK2FTpFMK043IvTGj1iUC8X1DA4m0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728743899; c=relaxed/simple;
	bh=9WjEWpeEXmwJ7o6zzU3yrZ/J+X2eFQFrx40A+VFRMVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EwrcszeDsCyvREVQNlPqqYSXY8IqeWdbzG/F3hUHJOSPG6NZJQ7NWYMapXGKkqpC6UJChCdQFQtTJOgolj5iEvtYO3NCvo7Ofs3W24gHFXr84GfhLIepSVCwnbJ4VJzH0nPWbTCezgonj5rS8H/qjNpGzzpbW2BBgvKTP7Kj5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qv8S1jp+; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-835496c8d6fso160831639f.0
        for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 07:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728743895; x=1729348695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LxPiBM9s/24QZOERd6VFCLNGvCqjGeYWcxIyXJwt8Uk=;
        b=qv8S1jp+s3cDQFRh+ZbG/IThRr1eiGLSrrF6JtWSchMMFUJEwQMf/50v9uXgN6UOnH
         3DE7EAPW0ED9e5kvNMR3Jo0UCEcL42qJDBvt/5wSIDOBwzhK0c4ymDoxGwtL1TqSUBfM
         798TBuIyFA8B3dC2Ar5ET595vpB2TqD7RLFqQNEmBise+g8LpIHG5HBEtZXMtVWL4L29
         3dTWxAukb830WjTGERTEaPyUali1glLn1GlpMIJEAWddxGfPPrNxi2MJB4bMcOZJUwV+
         y2g5wBRONXU6crHEf2jSsFnCCO/r/+1SlZT+be/NYME6QnkqG9hX/qMMHx8Aq0Xx8fmi
         Osag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728743895; x=1729348695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxPiBM9s/24QZOERd6VFCLNGvCqjGeYWcxIyXJwt8Uk=;
        b=v4vO0yl4foLNQiDZAeV++vBfPA8U10iuDoEQEh1OoEkbgvbMp8x31HVVPOdCvZQZJd
         +KfUwtq4APqmEzVTrul+TD7cPYAbNKU/Dhgx1PehNvltt96zWMaOhD8K5p4D53ME/C5l
         ZkbGqMnF0YxwEceC2mlZ+KD0+++B4lGjDQ5fMB/fITIHBvCZq356eiCqRLR8DABnJs/G
         G6/7vGbqk3bgvwdexq+MOS+FPBz/y+jcqGyPQhe3D6umgWCmSfbax0THThRYPBPyR8ot
         wT6w+AUbYhT1yjr89WcwgXOl3foeorun/yMDM8eeslsd+4eN54+XJUmGQ+Td7BhlpXOk
         9Mrg==
X-Gm-Message-State: AOJu0YzSLY2Oo0XKKyJZHo4Tx6fcYX8mvIepvrwiLJKdS17zpciw0BDj
	ZFHguF60vQjfsD3RM+CPmkbgc1lyR0xtdp56CB0kAW1oMqNNwZdgBmI4vhctGkI=
X-Google-Smtp-Source: AGHT+IHBBBpn8Ny3I6zHLkM9Y7IUypc9SYoA60bAyAZvAGVeM51W/C1+Eg8LtJEk0NGIINJvfiGgfQ==
X-Received: by 2002:a05:6602:6c0e:b0:835:444d:83a9 with SMTP id ca18e2360f4ac-83a64d9c39fmr167814939f.14.1728743895025;
        Sat, 12 Oct 2024 07:38:15 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8354ba5444csm112682139f.50.2024.10.12.07.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2024 07:38:14 -0700 (PDT)
Message-ID: <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
Date: Sat, 12 Oct 2024 08:38:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Ming Lei <tom.leiming@gmail.com>,
 Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/24 7:55 PM, Ming Lei wrote:
> On Fri, Oct 11, 2024 at 4:56?AM Bernd Schubert
> <bernd.schubert@fastmail.fm> wrote:
>>
>> Hello,
>>
>> as discussed during LPC, we would like to have large CQE sizes, at least
>> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
>>
>> Pavel said that this should be ok, but it would be better to have the CQE
>> size as function argument.
>> Could you give me some hints how this should look like and especially how
>> we are going to communicate the CQE size to the kernel? I guess just adding
>> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
>>
>> I'm basically through with other changes Miklos had been asking for and
>> moving fuse headers into the CQE is next.
> 
> Big CQE may not be efficient,  there are copy from kernel to CQE and
> from CQE to userspace. And not flexible, it is one ring-wide property,
> if it is big,
> any CQE from this ring has to be big.

There isn't really a copy - the kernel fills it in, generally the
application itself, just in the kernel, and then the application can
read it on that side. It's the same memory, and it'll also generally be
cache hot when the applicatio reaps it. Unless a lot of time has passed,
obviously.

That said, yeah bigger sqe/cqe is less ideal than smaller ones,
obviously. Currently you can fit 4 normal cqes in a cache line, or a
single sqe. Making either of them bigger will obviously bloat that.

> If you are saying uring_cmd,  another way is to mapped one area for
> this purpose, the fuse driver can write fuse headers to this indexed
> mmap buffer, and userspace read it, which is just efficient, without
> io_uring core changes. ublk uses this way to fill IO request header.
> But it requires each command to have a unique tag.

That may indeed be a decent idea for this too. You don't even need fancy
tagging, you can just use the cqe index for your tag too, as it should
not be bigger than the the cq ring space. Then you can get away with
just using normal cqe sizes, and just have a shared region between the
two where data gets written by the uring_cmd completion, and the app can
access it directly from userspace.

-- 
Jens Axboe

