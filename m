Return-Path: <io-uring+bounces-8839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1D2B1423D
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 20:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FB9A7A3A9A
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 18:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD52275B1A;
	Mon, 28 Jul 2025 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PwgavwS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0AD21FF36
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753728867; cv=none; b=MetxcfI/7W4lDPKGfwi9x/8b25mBTkZdegNAJRX3IeoTfcLzB1nwoIiolXiYsO6DyBzKonwrhBw3LYhpC8Z1yKCMGI/vpOK6TUoq2C5XN/U2bfyypuk9RYkAAU8tWZ5ye2CptTlBc9B8rgA2GsQpDGKWMUDiOOXqCdaSS6hxBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753728867; c=relaxed/simple;
	bh=k65gmv20u1ZM+EkgdD6WRee7XJJqgv4mn+/eHRc9zhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNLFIe2BZGqWL+fkcHGo9eTfQOZsEIlGCm2dcXrS0hN/pv4PAVYBf94dzJZFbw+qfI9+caBokQGPt9lPQxY7F2l/GmH85FmktRVyl8mjxCd/L1sQCSevu/2tT+X1PU37nI9njmDltn6G7FaUvd/TUmXUOiBB155xX+/m+zhkNTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PwgavwS8; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-237f18108d2so31875ad.0
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 11:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753728865; x=1754333665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k65gmv20u1ZM+EkgdD6WRee7XJJqgv4mn+/eHRc9zhg=;
        b=PwgavwS8nIxww/og6EbqFSsbgi41L98qS8OUOT4ExrPoRpTeqCLeNcGEeh0CbluOQb
         hiECGRAOH26BLJxQWa2s49DgmEn3hjreExWZopyFghMjUwsF1uZcG613tAHOeH0oy9BB
         v32/e8DcAM54zluSKBAUW9eedNk8ve83ogRqHqHupIUOo8nPisvWjxEC2QDaL06Ih4QJ
         IVo+hPiYBb/sUXsdGEoqM0AvWOFhG3V60ps8w2mXHSfWngEIkkWH6zIAuudeU136yLnc
         hoZdS22oKTNGzZQVT+QXqbF8aIaNDFx5OueSVIaxOBo2WZYudKOAtZwTeOKR0clHHQoy
         3xrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753728865; x=1754333665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k65gmv20u1ZM+EkgdD6WRee7XJJqgv4mn+/eHRc9zhg=;
        b=XmVgVmriP4zeIIE1hxYSE1LMixv9lHGgWIzsua/gqr8Vk2Wdh9DvChopb9k2YLRiTy
         1BLL7g3C69Sj247RKewZxH7i2+HtqzYG3bCb/TOt1PR0V6gQVfRsoWyG3c5o2nuE5/S6
         ktclW0Aw5f0DOlK2drmbNBS5TQ9BBn6MPw1aMsO7iJgfvasQSiHVGDD9tttU/nEGRIg1
         CIP7/dqiZSkYYp0Y69fy0P9+37SBrHZ1lPFACO1/nvBrBq9OEIGxV6BD6eaB/Jb+onTY
         fVGragV52EgpfWP/PFKOYu/xAOAyaYUK6etjvGHhOGnsWCRHOgpCHHe3Dq3TXXLrzeaU
         BrYw==
X-Forwarded-Encrypted: i=1; AJvYcCWGMxyNmQn1BlGnhz6LFUBIUwv1w9rqpvmZT8z03I2PcHjnPYVeXTJ7zcP8MeRrJ31Wi53ph8uu6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7jcBDS4QWIBe1uK+WPFciJnDGgww43Hi+vwN9l8ozxJaw6bL6
	amnELJ21P7qTWan7d+7vPajhnQWt6ZnX1vjcSU0kCHxmP5IYT7fIBeVprrGt9Zad4dkIqD9LXbk
	O3olZ3IpOmIOA3PRP6VitLka0/pJNNcWTAVax6fIY
X-Gm-Gg: ASbGnculcCFSTLXAdlawS4DWIUpavyFrc1leSR6tIG3j8JWwwEonHLUxrwqg3VDbEyB
	6NdOt+jMMGmpZc6ViI2yWFUJC27OR7T78yhkvTn81/lSrzWcSjbRU3RDxNZijzcNDQpILxq2FYW
	1Ho9QPh9vmvvqyFLJ83RQ7EEkFQBAAxfP11kg5tq59a3uLDpj3HEpHH2ezr7uh2eqH0RFaDfL5z
	XkPedcLYABdF1hs03NNUXXXCsuQ390GYgoR8w==
X-Google-Smtp-Source: AGHT+IG/DZTSmaKHsprKCdV9Q2aojWsxO0LZXBlVNhJKGj8xTF6s76f/cK53VifN5frM0gYX4u1vA2jwx5WFjG87MlY=
X-Received: by 2002:a17:903:41c1:b0:231:f6bc:5c84 with SMTP id
 d9443c01a7336-2406789c4c3mr382465ad.8.1753728865109; Mon, 28 Jul 2025
 11:54:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com>
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 11:54:12 -0700
X-Gm-Features: Ac12FXyNUD9YZfoZ5HOXQ7kpyeivuaarWVnbjQRSmqY09ZCfvuOl2u61PG5hmNY
Message-ID: <CAHS8izMyhMFA5DwBmHNJpEfPLE6xUmA453V+tF4pdWAenbrV3w@mail.gmail.com>
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> This series implements large rx buffer support for io_uring/zcrx on
> top of Jakub's queue configuration changes, but it can also be used
> by other memory providers. Large rx buffers can be drastically
> beneficial with high-end hw-gro enabled cards that can coalesce traffic
> into larger pages, reducing the number of frags traversing the network
> stack and resuling in larger contiguous chunks of data for the
> userspace. Benchamrks showed up to ~30% improvement in CPU util.
>

Very exciting.

I have not yet had a chance to thoroughly look, but even still I have
a few high level questions/concerns. Maybe you already have answers to
them that can make my life a bit easier as I try to take a thorough
look.

- I'm a bit confused that you're not making changes to the core net
stack to support non-PAGE_SIZE netmems. From a quick glance, it seems
that there are potentially a ton of places in the net stack that
assume PAGE_SIZE:

cd net
ackc "PAGE_SIZE|PAGE_SHIFT" | wc -l
468

Are we sure none of these places assuming PAGE_SIZE or PAGE_SHIFT are
concerning?

- You're not adding a field in the net_iov that tells us how big the
net_iov is. It seems to me you're configuring the driver to set the rx
buffer size, then assuming all the pp allocations are of that size,
then assuming in the rxzc code that all the net_iov are of that size.
I think a few problems may happen?

(a) what happens if the rx buffer size is re-configured? Does the
io_uring rxrc instance get recreated as well?
(b) what happens with skb coalescing? skb coalescing is already a bit
of a mess. We don't allow coalescing unreadable and readable skbs, but
we do allow coalescing devmem and iozcrx skbs which could lead to some
bugs I'm guessing already. AFAICT as of this patch series we may allow
coalescing of skbs with netmems inside of them of different sizes, but
AFAICT so far, the iozcrx assume the size is constant across all the
netmems it gets, which I'm not sure is always true?

For all these reasons I had assumed that we'd need space in the
net_iov that tells us its size: net_iov->size.

And then netmem_size(netmem) would replace all the PAGE_SIZE
assumptions in the net stack, and then we'd disallow coalescing of
skbs with different-sized netmems (else we need to handle them
correctly per the netmem_size).

--=20
Thanks,
Mina

