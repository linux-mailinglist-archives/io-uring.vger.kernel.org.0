Return-Path: <io-uring+bounces-564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E1A84C24F
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 03:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE9D11F2430A
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 02:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1202B1078D;
	Wed,  7 Feb 2024 02:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cIWe00lb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C545DFC08
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 02:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272126; cv=none; b=BvEvHrTzKrprLRtOt4mR9yFe+ZgM7hypLRKRDWtCXUVSQ0PoHivz5YtnUOoymNYd+ZpToD6alcXbh1N0Zd+ViM1gkFSGFxSnIqnTWLNCjjYNjzKo6dr7bGzphPH3C9xETHZaRXtB3Rt48jdBbUsHSinq79kmZR61+6E5MafSxyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272126; c=relaxed/simple;
	bh=kJzTcej/tuCqBjM69Za/4xC0ysti1cgx6VFSiAqX3bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SR0apIpZLADy4MLL927vW8jR1ISE08XhX6YAovg1FY56oyuzYPEUrJl7GZ1tKzEVKo5+i2IMFbV5nfEQiVTYGOm63y/XsOETwzG9u0Yrh0LLepVo8vSv4MqcihtCXOo7wKn4TqSrVfjOMFgO6h7J9cOWvloHSgaxvC3yZeX2zo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cIWe00lb; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3bc21303a35so74470b6e.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 18:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707272123; x=1707876923; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OKEUVLN4f98aydvB+xzcobBJHyzc7V4a4lyxtTGZYMA=;
        b=cIWe00lbaYxfQPH8kow21hXUu7j+soIn9lI1cPjOyb3QBQw2ukkDykjFCEEjFjKXNn
         NhCVgVH4RSNthR4MDQhl4mMeGy6aW1Yur0HFegMv4Jr+Ho8iRLMz7yFJ3LlB8tVDS6js
         V8kkSDdEwBQhV4brMwElx1HSGsd5lrpmCgS8fywYKeghqxhZhnGDSAD43pEmFhp8m0go
         n7a66DdMGa2cz2TTtN4DsJY1UtwPgqo1TTbdaq7WlLOIa2Rw5uCYwk+bftXMTlF/CZUK
         3mj2hDbQGGelOY3bZKYcMizVQyQFBm2g6nauVmD8kwBWAS7jktHM+gqu+LXWwUa651IX
         WcFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707272123; x=1707876923;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKEUVLN4f98aydvB+xzcobBJHyzc7V4a4lyxtTGZYMA=;
        b=gCSzB1p8YcnozW+aOaMrUNlrL/tKDV0rS33nVD0CTgWVbmjEiRlyfX4jsV6gCUFeaf
         8e+SRX625+BD+lHZYCy+c2k7pACW5uzOSAYWXF9szvk9QVbL+erWDCmxNqlQqCSyKeuj
         F9mrFq2O/wov/KHM1Kt8030s5yjSPjWe6KlsRcy2dRVmI5+QLF6AsRdM97hRa0ZMlGFK
         hxJ17/LPoyFi2f6vrcqN4OvIBcbFmkgECOZWmVGN/lltS4POzXcIkFnJEvJl5m++0I90
         KmOkNyKVhPIPwM7WsdBR5DjY6RbDtFhJ+GPaONmGjLcTFwa/nkhyeEvEwEFA7kxmRZg1
         a6YA==
X-Forwarded-Encrypted: i=1; AJvYcCV90dn+LvYf7fMAZQ204H0UI+IgnsMA6msS0d897kaZUqdfwvznqH3fJRhmnZmGIRT+k5xH3BLJVt6QAsJLdZlrcWsQwpy7dxI=
X-Gm-Message-State: AOJu0YxpZBauL7WVxXJ2brd+oOvW+U2Qag2KN8fk60QTl/g2qugWAmDz
	5PVjLddO6Zxp4XeupQZwf0Ud6sJ0WUwHmteTuPQJBVVz7zrRxrcC0/ApVwGmRtY=
X-Google-Smtp-Source: AGHT+IEj9Ar3BXtE8RUf/+hjhIddojJaL4SR8cygwBFk4gmRpbUlQ1O7vJFeJHxH/rBo9mn93FtK9g==
X-Received: by 2002:a05:6358:7e14:b0:178:9f1d:65ea with SMTP id o20-20020a0563587e1400b001789f1d65eamr5145604rwm.1.1707272122800;
        Tue, 06 Feb 2024 18:15:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUbs1JZvquTTzZtM8YMyeWDIjQsptIlah2EwoQ6eLN/pdFlayeV0QDHseKZUz1Yb8XShdF515yMPXxmkIj6rSs1mSGX38o5xCg=
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id m8-20020a62f208000000b006ddc71607a7sm188449pfh.191.2024.02.06.18.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 18:15:22 -0800 (PST)
Message-ID: <b7ef8fd0-de12-4e5e-bb8c-bfa06b2ec723@kernel.dk>
Date: Tue, 6 Feb 2024 19:15:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: add io_file_can_poll() helper
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-3-axboe@kernel.dk>
 <a0dce2ae-a41b-4fbb-961c-db69d8f1f17f@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a0dce2ae-a41b-4fbb-961c-db69d8f1f17f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 5:57 PM, Pavel Begunkov wrote:
> On 2/6/24 16:22, Jens Axboe wrote:
>> This adds a flag to avoid dipping dereferencing file and then f_op
>> to figure out if the file has a poll handler defined or not. We
>> generally call this at least twice for networked workloads.
> 
> Sends are not using poll every time. For recv, we touch it
> in io_arm_poll_handler(), which is done only once, and so
> ammortised to 0 for multishots.

Correct

> Looking at the patch, the second time we might care about is
> in io_ring_buffer_select(), but I'd argue that it shouldn't
> be there in the first place. It's fragile, and I don't see
> why selected buffers would care specifically about polling
> but not asking more generally "can it go true async"? For
> reads you might want to also test FMODE_BUF_RASYNC.

That is indeed the second case that is hit, and I don't think we can
easily get around that which is the reason for the hint.

> Also note that when called from recv we already know that
> it's pollable, it might be much easier to pass it in as an
> argument.

I did think about that, but I don't see a clean way to do it. We could
potentially do it as an issue flag, but that seems kind of ugly to me.
Open to suggestions!

-- 
Jens Axboe


