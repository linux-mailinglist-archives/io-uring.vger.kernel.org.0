Return-Path: <io-uring+bounces-6182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1213A22490
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 20:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18B5A164A8F
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 19:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473061E0DFE;
	Wed, 29 Jan 2025 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UhTihInd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFB2190462;
	Wed, 29 Jan 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738179028; cv=none; b=ZkqpCQKpmQHggCywwxcA+ZI8w471l4E9sUNay+CEvyONcdl16DvjA7f0vkjcs98ysekaiQo2Gg/sZrIzxZQyxcVgD7Fpo8oz33Mi+yZMyWLKVdBSUEQ8WUj/y02+qT7DuMpvf9qVuBYu3tQCtVJFepPI93rLmvwgOfDEA5zw6Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738179028; c=relaxed/simple;
	bh=rWQreQiAU48uL9T3JNDkwkNmknGBAbDTji6X7fbwfKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8K7BXq0Lq1hKeG073/r9fk2uNlXqRLfvwvMjXKuqvWmLHDD9rOqXfwlnw2cByuRaHENtzunpw3NjR+tZ4WWRxapElGUgOLd0z/cuoN1mR44Rft5Raz9KC6dg/E3O3frX3xEa426fJxtaq4v1PTnowrKbgZ6c6XyQJ0Nro/ROLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UhTihInd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43624b2d453so81243665e9.2;
        Wed, 29 Jan 2025 11:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738179025; x=1738783825; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FmDVhjSuNtL0NR/wOvEkkLqWRufG3IvH9lliz9davJI=;
        b=UhTihIndgdHqvVQXNuVCH24YFnYWho7AKEna7t/cXuFYrCLX0pbr5Sve2sOBjurfs3
         zWY0O7PN+pbY9vX0NggluyVOBbOQrwnibsQLi5Kk3zjrUvGydqiRA9ZwkYFtLpHqr73T
         XbJ9/83IN8fRb1RPn+PR6ttE/aBNCgMV2EJSPD3rqJD6w3EAT9IwTb6HQyQ1CrjJrgBH
         uvkM9FxBaVARsYjfS7Y32yXQ/xHrMkHLJI5CC+jg6Vr9alwFjdJmOx6PpEBs58JHhwk+
         6Aaz0FcPRoaeaNFbbXJvYk7HdkI8i0ulgAyG730TDL/cwMoxUYDnJV0kZXaiHZgR+ugq
         YUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738179025; x=1738783825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmDVhjSuNtL0NR/wOvEkkLqWRufG3IvH9lliz9davJI=;
        b=FDFbSarX2WBy3CXNVCjLt2SgXO8154uItrr/oDFKuHq6xBwZCmylMwJCDiAbLjTcvc
         lt6Dlv6XJ8PB9s0RDzEcUudEuZPQuf1LKXqmXq/fCnReq+sxuulvh/7Oe6sSKFWzFW+b
         Q6GkiWmSDKAhg99guBaIEpAeu5z/n7jq37ar0uf2Qk32SXgOjHzfLsVA/d0xv4bUdtJH
         kss+y0SAo5QBcDGISNUfdwlNGob/6KXJsT/9R6G2dj+8SdpSii9vzC+Nud3jKqtpdASe
         BZxmhXzUVrR6fPxbQRX8FcyrP/HkpFtzwj74jp4dbBW5IsfVFPi3ts3Nyi5PVKgKPpmZ
         y2Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUxWZI+tCVAJoB25rKCVxg2bvqDzXEQNEPan+olO0dmgFRL8u9BgOp2rrE+FXhKS8IUEz0WYDSADjU3pNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwebNCHxOgfCjZSe2VPl6RUfCy7hPetw9WEbgYE+LM6q41mR48j
	5T+iroWjtaQVolKDMouL/5bJp1yIbbIRsm7fF6/uVNmbscg8EdxP
X-Gm-Gg: ASbGnctDLsulDLvXTUF2JAPJzETHRZz39X3X5BVXCvCVU2jpugEVCeVoD7MFVNhccXB
	GLFK2AGW500Daununi5HmG0w1LJeahLXbzQebaD6IzIhTguqvj56FsPGBpmH9pq8M5azCMj5Q8+
	cgrC6OeUHNjR2QJA34rhy3KjKdBInv9iJHpY27R4/vqH5fY8kV5MPYge0aFPi2lOSQvKWWEsTtO
	0oYOvkhkAhYT0dGH/RbqNnJ6/kIQmOwXA6OAZXarvYlWnCq2mN/sp239EO6QhUtRl34p27sF4WX
	2IfsrRMXn+8FtJzoZx20rRDH1Q==
X-Google-Smtp-Source: AGHT+IFO4M9+9EH1K7BeLhcwlrue3FMAM0Y/HMdT3eAAsdx74yDxpJEgJikBayBE6IUVp0idwQVq/g==
X-Received: by 2002:a05:600c:4f55:b0:434:a1d3:a321 with SMTP id 5b1f17b1804b1-438dc3aada7mr42461765e9.3.1738179024523;
        Wed, 29 Jan 2025 11:30:24 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcbbc52dsm34178265e9.0.2025.01.29.11.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 11:30:23 -0800 (PST)
Message-ID: <a5d8d039-f2d7-4adb-afd7-693b3be41e45@gmail.com>
Date: Wed, 29 Jan 2025 19:30:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock
 contention)
To: Max Kellermann <max.kellermann@ionos.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk>
 <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/29/25 17:39, Max Kellermann wrote:
> On Wed, Jan 29, 2025 at 6:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>> The other patches look pretty straight forward to me. Only thing that
>> has me puzzled a bit is why you have so much io-wq activity with your
>> application, in general I'd expect 0 activity there. But Then I saw the
>> forced ASYNC flag, and it makes sense. In general, forcing that isn't a
>> great idea, but for a benchmark for io-wq it certainly makes sense.
> 
> I was experimenting with io_uring and wanted to see how much
> performance I can squeeze out of my web server running
> single-threaded. The overhead of io_uring_submit() grew very large,
> because the "send" operation would do a lot of synchronous work in the
> kernel. I tried SQPOLL but it was actually a big performance
> regression; this just shifted my CPU usage to epoll_wait(). Forcing
> ASYNC gave me large throughput improvements (moving the submission
> overhead to iowq), but then the iowq lock contention was the next
> limit, thus this patch series.

It's great to see iowq getting some optimisations, but note that
it wouldn't be fair comparing it to single threaded peers when
you have a lot of iowq activity as it might be occupying multiple
CPUs. A curious open question is whether it'd be more performant
to have several user threads with their private rings.

> I'm still experimenting, and I will certainly revisit SQPOLL to learn
> more about why it didn't help and how to fix it.

It's wasteful unless you saturate it close to 100%, and then you
usually have SQPOLL on a separate CPU than the user task submitting
requests, and so it'd take some cache bouncing. It's not a silver
bullet.

-- 
Pavel Begunkov


