Return-Path: <io-uring+bounces-8214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ACA9ACDF5E
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 15:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5908C7A1D97
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 13:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE0B2557C;
	Wed,  4 Jun 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KxnqyqHl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A028FAAE;
	Wed,  4 Jun 2025 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749044319; cv=none; b=G1bf4l6Ofx96AX8i2rZqPLSQ/9XyNqROlQgRzTTrHyKqId3PODpOjJ5Wy+1EyDE2V/MXnBzI1SntyGwke0S3yIrbymHQP2F4jbDqBpwhZgZ8g7jrndXCEYD7z3Co4EfBdgZNkzpDb3JdR90AQaTyBhRh0LyTviuMpiwUiOfBfgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749044319; c=relaxed/simple;
	bh=zFtLD0szs2A1FVXE1CtGeRje8HHipL+Pi8K1BbJw/qo=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=XYOs6vWzmzSL/iA97M3HLsBtv1Y9w4OIwYB5BedwAS4jk+c9Ar1jB9BoNdhH8uOasvV7h/5pwMktT9mpHZkMQmrnWJtfjoB8OxXLdo9c5gJrpYGoHmm8ec8iwVHZfODWS8Un7doPxP1VAbXWD9JEG+O/6WN+3b9yrJHF1jqYEqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KxnqyqHl; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70e23e9aeefso51426007b3.2;
        Wed, 04 Jun 2025 06:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749044316; x=1749649116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ExCqe1qkMulK2JH6im9AOWv3QeiyPTjWpT4m7ERaXs=;
        b=KxnqyqHl1QZht03z8VD3frQEsc4zqbICCVibDZlbJ4qThlXD4/8oB8IUCPF3LT4Hz1
         7l6ydmtQV+36xR1TTggNnAfxjvo02g6muX1BgpsqoHa18qWvPQ3yCVRA8khwdj1Nrlzq
         Rjm8awzzME2Iw2cZb4eFL4xFsihtG7THku6QzGdyQ5PWdSBSkBF9TGHeKNXwEqbdDj4E
         wnZqcG/uq6y6F9DDElomZ//gGG9B6Tfs8uHHhJ2gweB0KJQ1ZPt+IBjj0WZ9h0osuL6G
         Sfq5qNNheujB8PqouQ7Ppy3djs9Ib6Na0VQFJO0v8SL2mLs23ffZcI8Tyuijf41tTzfg
         hpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749044316; x=1749649116;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/ExCqe1qkMulK2JH6im9AOWv3QeiyPTjWpT4m7ERaXs=;
        b=pfyIU/xN7auh+PouLzo7RqIKpf2IcFxJfm8ogxSCK03HEYgpEHIfBUpdRjRavlr++J
         kUuGI5FZllFWNVEa/VMw7cC+Jf1Djn32JVCv83LrLefWSAM5uI/KaDKd+S62e2sFrIoH
         O180rff2DyC5CfjXv6ybOMLFefVuFLwu3tekN6TePyV1fGuxFN6nY6woQB7rhXgepiL2
         5zUyNqzZtYbXGEpxITTH77j9WKEuRhPIFiJJf7sd8M4ZtaLWrXWVlKG/niJBnOV9FGJD
         mSCIX4Iah5yPtlYJvR1Pt7NpNNSyp5pIlmU7qTBDKolzBXJiT0JQSv1jRB6wkGVC6oNk
         UcOg==
X-Forwarded-Encrypted: i=1; AJvYcCUXvuUq0E8zWKCrR/qFwBr0qpIrPJqRWrRab0KSTLZ5EtLgz5P7jQmn0htzOb9te9D629KS+/EO9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YweILDOaps5Xkqr2245uz7VTjq96wIl8AW9LZkv/Rc4BfoOzBJF
	zP6u6LnciDVYjfk3X44/p0rKxM1cmTjoD3AWEPP07TXDRiHOA4h2IZ69jGi3Bg==
X-Gm-Gg: ASbGncsrtcnk+YBAXuh0LZH3saIFYhvuNA/3b5yKZCbEkATs2Nh3jCGXxGAN8Kk2xiY
	EiTopJt2KjFmYzPHRoOSqn6dAiZXZYeaPHMNWN7a2U5yXJeXwnZPfWY8jOWxxgzQVink0A845rq
	5vyi3D4yMyF4SiDrSzcPcdIgDR//moQYOeyHfEkf/qI25gOXRdquc0AJgaNtlbedVQQHIS2/GWR
	xtXZSPJUP+VrxCMck+B/mUEgmNnLlsMRNhvL2QJzDM0TA4XLwsu7PppAwJdnC9wbF+lpp94OkhI
	YhWffgNlH4kJbuESUmZd9+YE+GBaeSAadO7WQD/n/FeBeeiAutZyD6s9MBrwBJYeGEFDjMy0Os3
	uv0m6punFOow9Ilqz8x653Zam0OZRo07Gvw==
X-Google-Smtp-Source: AGHT+IHeKnRxhHdDcLKOYMIsAydvgWS24y99vOJHpuPFCu6e97MLMmoJdlteMdZT3v9vz9u6rv6sTw==
X-Received: by 2002:a05:6902:982:b0:e81:84ac:ce1 with SMTP id 3f1490d57ef6-e8184ac19famr951072276.2.1749044304874;
        Wed, 04 Jun 2025 06:38:24 -0700 (PDT)
Received: from localhost (23.67.48.34.bc.googleusercontent.com. [34.48.67.23])
        by smtp.gmail.com with UTF8SMTPSA id 3f1490d57ef6-e7f733ae11asm3197821276.2.2025.06.04.06.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 06:38:24 -0700 (PDT)
Date: Wed, 04 Jun 2025 09:38:23 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>
Message-ID: <68404c4fa8590_1e99f529486@willemb.c.googlers.com.notmuch>
In-Reply-To: <abd16c0d-480e-4bc7-a4ce-6775e6068e70@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
 <683c5b38ed614_232d4429431@willemb.c.googlers.com.notmuch>
 <07d408c8-c816-4997-ab87-1a6521d0bacd@gmail.com>
 <683da7b621fc2_328fa4294e0@willemb.c.googlers.com.notmuch>
 <abd16c0d-480e-4bc7-a4ce-6775e6068e70@gmail.com>
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> On 6/2/25 14:31, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> On 6/1/25 14:52, Willem de Bruijn wrote:
> >>> Pavel Begunkov wrote:
> >>>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> >>>> associated with an skb from an queue queue.
> ...>> ...>> diff --git a/net/socket.c b/net/socket.c
> >>>> index 9a0e720f0859..d1dc8ab28e46 100644
> >>>> --- a/net/socket.c
> >>>> +++ b/net/socket.c
> >>>> @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> >>>>    		 sizeof(ts_pktinfo), &ts_pktinfo);
> >>>>    }
> >>>>    
> >>>> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
> >>>
> >>> Here and elsewhere: consider const pointers where possible
> >>
> >> will do
> 
> I constantized the sock pointer in v2 but can't do same with skb as
> skb_hwtstamps() and other helpers don't work with const. I can follow
> up on top preparing those helpers, but to avoid cross tree conflicts
> it's probably better to leave the helpers from this patch without
> const untill all is merged and pulled, hope that's works for you.

Ok. No need to follow up per se.


