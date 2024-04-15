Return-Path: <io-uring+bounces-1556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A48348A561A
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 17:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C84AE1C22017
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 15:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD467602B;
	Mon, 15 Apr 2024 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alA0Q92t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9069763F8;
	Mon, 15 Apr 2024 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713194116; cv=none; b=hqDeLY+N2prV5vCSK1IMx6MybTKoudJJzyWFwKvX2iN+RFuuJfFb0Qi45U5EXwB+S1Meif4asRBtu1sosa+DAq53ptckAUcmv+PlNZDF2mPyQZoJKHKLF7gHrO/N71Ie8TcwRiCEFG8yk8HdP03+W4wUtPIgttD0pu6kdLNBK4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713194116; c=relaxed/simple;
	bh=vnPWNNgEeQVC8tAA1XdUrhPkeotOBtknUiV2y9Q+Io8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=qAM7/zWnt8fwyRNO1Xow4nwCxZV+jMLRQPgjM7peeMyMe5b+He+TtNqzpg5o9104pBKbaGJNycV6s1sADRpPjGbMVXajVZuJj6S9TYkWfTxXv2t1RbJy3YO6Ga8SB+t8tBxE1HcBe5d/u2o7z+wjqpyyzdbSKtY+LlxXzBq8pUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=alA0Q92t; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6964b1c529cso21797676d6.0;
        Mon, 15 Apr 2024 08:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713194114; x=1713798914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaVZDB621skKE1QNAYn4dFJzvmrboxc8hUClPoINSog=;
        b=alA0Q92tyfKsnHuSBP1BCDZ1cWs88Z/3DHehn0NeleKBXt4IcgbrOQp7dw+y3FZn7c
         45iHjz5OhLpcCcK662U/Zvw3lAnrdE4ZT/Z0pLi7uDK2LxHvwJ56TVJQF4vqMR+oYxYP
         smFdJL/ppa6zIfVMFiMq1rOrPcCS7zDQ57TaIEjKsd4baOlIHRH2d2X7pgu4iHD97sjJ
         EkiHOomRx8Jz5kisJ7HCEHFbeGI8NfQvGKkFqpA+kCSta5JjhbU7S/qSnpBuawsZAOfU
         ob3Mydfk073gX/5QmfZopECgjQe/gTlRHH+SoiFvYFZam/g02M1feLiUVY8psKcJ3cNo
         axKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713194114; x=1713798914;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YaVZDB621skKE1QNAYn4dFJzvmrboxc8hUClPoINSog=;
        b=Eo1mvKPMnFCecCNoD0LRMklBtb4C8IJZzrr/GX5ACmOk4IhWFroMeVJ9pV1zSyo1lJ
         /3/peh5ErX0D6ISuEg331bHHa9/DqyUCVgFymjcb8csapNecpGFvlWhSUm2NUr0toz62
         saLamAcUWbZCcBlQkWQIq19Bm6edgBI2ZnDRSCki19SpA8uEPH3FpzcNLsjUXsP6wNQT
         nCFQmavxhFet1eOvxEF4TTid6J2zb+bkVNwHJn+8CdzEdOQI1uzuiOpSzU+4rFts7zLj
         euOxIzD2TFHCFdZU5AgDBiL6HW3U3WyaHeemu113wlxys5KzR4Rv+VEUd24FvLosk0O+
         Rxfw==
X-Forwarded-Encrypted: i=1; AJvYcCXp4nHj6rueaguhQNUa9tP/js8l3jE23cjMM35nv/Fhm3/dfppJVroX+o02SPPqBPaud82A7qx9I6hxGRVnvx/5Dhg088OtMReC4opzf/5J0pITb98UvD4Ouy+G0Km64S8=
X-Gm-Message-State: AOJu0YwNQItAwXkAfg5Htj9vlohmgIQqsgJLoywA1mby1dv5zPXzABUG
	bAkkZcBboSpWfr7U7+i/pfJjCPCtlnEhla6+ASTAd5nWXBXt6XKC
X-Google-Smtp-Source: AGHT+IEemzeNTWYdRaEDwl6ticDNfD2m3c0F+b/8IJIvkUjwQNJA8QwUok2wDQJ27QF5irs8f43/1g==
X-Received: by 2002:a0c:e80b:0:b0:696:aa14:49a1 with SMTP id y11-20020a0ce80b000000b00696aa1449a1mr10996325qvn.65.1713194113726;
        Mon, 15 Apr 2024 08:15:13 -0700 (PDT)
Received: from localhost (73.84.86.34.bc.googleusercontent.com. [34.86.84.73])
        by smtp.gmail.com with ESMTPSA id m8-20020ad44a08000000b0069b7eb7edebsm1135096qvz.71.2024.04.15.08.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 08:15:13 -0700 (PDT)
Date: Mon, 15 Apr 2024 11:15:13 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>
Message-ID: <661d448142aa_1073d2943a@willemb.c.googlers.com.notmuch>
In-Reply-To: <e686d9ba-f5fc-48c7-9399-06fcbed6ebd5@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <3e2ef5f6d39c4631f5bae86b503a5397d6707563.1712923998.git.asml.silence@gmail.com>
 <661c0e083f05e_3e77322946e@willemb.c.googlers.com.notmuch>
 <e686d9ba-f5fc-48c7-9399-06fcbed6ebd5@gmail.com>
Subject: Re: [RFC 6/6] io_uring/notif: implement notification stacking
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
> On 4/14/24 18:10, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> The network stack allows only one ubuf_info per skb, and unlike
> >> MSG_ZEROCOPY, each io_uring zerocopy send will carry a separate
> >> ubuf_info. That means that send requests can't reuse a previosly
> >> allocated skb and need to get one more or more of new ones. That's fine
> >> for large sends, but otherwise it would spam the stack with lots of skbs
> >> carrying just a little data each.
> > 
> > Can you give a little context why each send request has to be a
> > separate ubuf_info?
> > 
> > This patch series aims to make that model more efficient. Would it be
> > possible to just change the model instead? I assume you tried that and
> > it proved unworkable, but is it easy to explain what the fundamental
> > blocker is?
> 
> The uapi is so that you get a buffer completion (analogous to what you
> get with recv(MSG_ERRQUEUE)) for each send request. With that, for skb
> to serve multiple send requests it'd need to store a list of completions
> in some way. 

I probably don't know the io_uring implementation well enough yet, so
take this with a huge grain of salt.

MSG_ZEROCOPY can generate completions for multiple send calls from a
single uarg, by virtue of completions being incrementing IDs.

Is there a fundamental reason why io_uring needs a 1:1 mapping between
request slots in the API and uarg in the datapath? Or differently, is
there no trivial way to associate a range of completions with a single
uarg?

> One could try to track sockets, have one "active" ubuf_info
> per socket which all sends would use, and then eventually flush the
> active ubuf so it can post completions and create a new one.

This is basically what MSG_ZEROCOPY does for TCP. It signals POLLERR
as soon as one completion arrives. Then when a process gets around to
calling MSG_ERRQUEUE, it returns the range of completions that have
arrived in the meantime. A process can thus decide to postpone
completion handling to increase batching.

> but io_uring
> wouldn't know when it needs to "flush", whenever in the net stack it
> happens naturally when it pushes skbs from the queue. Not to mention
> that socket tracking has its own complications.
> 
> As for uapi, in early versions of io_uring's SEND_ZC, ubuf_info and
> requests weren't entangled, roughly speaking, the user could choose
> that this request should use this ubuf_info (I can elaborate if
> interesting). It wasn't too complex, but all feedback was pointing
> that it's much easier to use hot it is now, and honestly it does
> buy with simplicity.

I see. I suppose that answers the 1:1 mapping the ABI question I
asked above. I should reread that patch.

> I'm not sure what a different model would give. We wouldn't win
> in efficiency comparing to this patch, I can go into details
> how there are no extra atomics/locks/kmalloc/etc., the only bit
> is waking up waiting tasks, but that still would need to happen.
> I can even optimise / ammortise ubuf refcounting if that would
> matter.

Slight aside: we know that MSG_ZEROCOPY is quite inefficient for
small sends. Very rough rule of thumb is you need around 16KB or
larger sends for it to outperform regular copy. Part of that is the
memory pinning. The other part is the notification handling.
MSG_ERRQUEUE is expensive. I hope that io_uring cannot just match, but
improve on MSG_ZEROCOPY, especially for smaller packets.

> 
> > MSG_ZEROCOPY uses uarg->len to identify multiple consecutive send
> > operations that can be notified at once.
> 
> -- 
> Pavel Begunkov



