Return-Path: <io-uring+bounces-4328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B289B986F
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA4701F22C62
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 19:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290B41CF7AD;
	Fri,  1 Nov 2024 19:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wVmx6H07"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078B1CFED3
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489088; cv=none; b=mj2/OZM6sQtwbfIUhaPIQRzmMnv3CpdrQg921Lx1kncDN4igzegeCau7d9LN0h4J2Uz+Sr8sIX53M30orgLdfDEYbRLN829WVtggiZzAnD3arkFL+NbpnsbDEPLTpxre/TKw7dtp7tj9YSs1TlGMBALVM+ay+7lBS9jiOZj+seI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489088; c=relaxed/simple;
	bh=A4wWaHrV1wUJzz5E7RONydp+5BMnesqEA6XAkFQ/zHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GjUHpqLjjz7xc2S1EqbwQKW/GQ753eRuhAvfEKBcrqHvXylLG6zZ3IwUmWlhz4jH+O0mOOHqCmAZxcYYrVxm2k/9aXgAlu6g0XynK2rvM1jBVq+R2OafWH4xKenLs/WJ1WLGQN0uNVWCSVgAecIxiz9nhx9Klwhgl0A19rdLr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wVmx6H07; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539e681ba70so116e87.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 12:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489084; x=1731093884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4wWaHrV1wUJzz5E7RONydp+5BMnesqEA6XAkFQ/zHg=;
        b=wVmx6H07p8CacU6on7hG12/HKDtmhXiy9EWQAsl78sgiZTV1eUk+rDglouu28wiLvn
         KS9wCgsZ4W3u9KEk7hLGrtPGXFLvhLapsRgGm/7y7Zu5Miba/ncvT21FqtvzTM3816iY
         1MIhl2zBqhO+utDN1XJF1ADKiPLH7MvWifmA9hfHi3BvCwhQQpAqM+q/dUlIMYKWgB7u
         +oTPcMPNP3bfHBmfGrq/DgZcnoIP/gcOzePgZLLV7FMsNPYdKUXlB3RJj4GXdgUfHEJU
         ijd0jC54skVWKGwqDXEtQ2adyPTpXaeXAJDVSEpb4AOnIhzJtU5/NkixoGY59zITuwaQ
         tP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489084; x=1731093884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4wWaHrV1wUJzz5E7RONydp+5BMnesqEA6XAkFQ/zHg=;
        b=vi+MulOpjI8LEdPCzby9/vAT5zQ7VUdEDPg8cV2e2xOcoKBa0gyQaee4BVq9So6MVu
         R1ptaXO1Yxw97e8zHF38Q+mIFOVVdBEvtKwZr8JwU2zhqbnbQ2l7f30LL54zsQlsEvZn
         rIk08zuGpUAb7c5xo24TLu9vRrx5N0rjHQv+eUEE/uIWP1SsPQhJA26SZTiRtBH6I8Z4
         rlLYBCIQ48y8qSuSfxNGdFjrzeEd+vSWSCygfOHv2WhnQTsXv163wKWx0SYYIqrvhHjU
         KyChEBmEexOSFocWl7yUAMO9E6htpvsx932O0yYi9aRHake0iCeSJ3Y4x/CfO/5HVSyJ
         c1Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUWDiH77xREJ244a2kmEUHIq3VjYDpjYPcQ0Qr6PdNVR+11PG8bX+sYLqb/CYF04yB1QC1wu6ms7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA/l6TCKKSH14yNHj9o9oa4YpMT8C2/ibCxJ+ymhZF80FMnAg5
	YSEKyHUsVifLM+BX6yV8fMw//U/rqzeuZycloZxMbX9XYFoRwqXnbf/UGV4Hj7yqLMlrYyaLeV6
	tZ8yHvnNnMTd9ZMPO/aM7jp3VoOI2yLoesrwohN3mmyHRcsu/Yevn
X-Gm-Gg: ASbGncvWi4WZxoV8scdfK7lmh7y/KdFg6CuqzGbZwSHkGGd2Yl2xnFtKPQWb9sVprSd
	o7nb4eIpYY3gywWe58BXAU7Ma+ygq4q3kMi1U6mRpK66vNNRTQYF8LvOA2JgRqA==
X-Google-Smtp-Source: AGHT+IFsJdl/mtcHkurrBRSdf8eivwl2Pf8VZVyg0nEYfX2RIRwUmqsfB0uvDW/tdOBk3G3rT8JH/hrrr+65DO0p/Lw=
X-Received: by 2002:ac2:4243:0:b0:53b:5ae5:a9c8 with SMTP id
 2adb3069b0e04-53d6ad785f0mr53937e87.7.1730489084164; Fri, 01 Nov 2024
 12:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com> <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk> <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
 <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com> <CAHS8izNXOSGCAT6zvwTOpW7uomuA5L7EwuVD75gyeh2pmqyE2w@mail.gmail.com>
 <58046d4d-4dff-42c2-ae89-a69c2b43e295@gmail.com>
In-Reply-To: <58046d4d-4dff-42c2-ae89-a69c2b43e295@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 12:24:31 -0700
Message-ID: <CAHS8izO6aBdHkN5QF8Z57qGwop3+XObd5T6P8VnMdyT=FUDO1A@mail.gmail.com>
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 11:34=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 11/1/24 17:18, Mina Almasry wrote:
> > On Wed, Oct 16, 2024 at 10:42=E2=80=AFAM Pavel Begunkov <asml.silence@g=
mail.com> wrote:
> ...
> >>> The critical point is as I said above, if you free the memory only
> >>> when the pp is destroyed, then the memory lives from 1 io_uring ZC
> >>> instance to the next. The next instance will see a reduced address
> >>> space because the previously destroyed io_uring ZC connection did not
> >>> free the memory. You could have users in production opening thousands
> >>> of io_uring ZC connections between rxq resets, and not cleaning up
> >>> those connections. In that case I think eventually they'll run out of
> >>> memory as the memory leaks until it's cleaned up with a pp destroy
> >>> (driver reset?).
> >>
> >> Not sure what giving memory from one io_uring zc instance to
> >> another means. And it's perfectly valid to receive a buffer, close
> >> the socket and only after use the data, it logically belongs to
> >> the user, not the socket. It's only bound to io_uring zcrx/queue
> >> object for clean up purposes if io_uring goes down, it's different
> >> from devmem TCP.
> >>
> >
> > (responding here because I'm looking at the latest iteration after
> > vacation, but the discussion is here)
> >
> > Huh, interesting. For devmem TCP we bind a region of memory to the
> > queue once, and after that we can create N connections all reusing the
> > same memory region. Is that not the case for io_uring? There are no
>
> Hmm, I think we already discussed the same question before. Yes, it
> does indeed support arbitrary number of connections. For what I was
> saying above, the devmem TCP analogy would be attaching buffers to the
> netlink socket instead of a tcp socket (that new xarray you added) when
> you give it to user space. Then, you can close the connection after a
> receive and the buffer you've got would still be alive.
>

Ah, I see. You're making a tradeoff here. You leave the buffers alive
after each connection so the userspace can still use them if it wishes
but they are of course unavailable for other connections.

But in our case (and I'm guessing yours) the process that will set up
the io_uring memory provider/RSS/flow steering will be a different
process from the one that sends/receive data, no? Because the former
requires CAP_NET_ADMIN privileges while the latter will not. If they
are 2 different processes, what happens when the latter process doing
the send/receive crashes? Does the memory stay unavailable until the
CAP_NET_ADMIN process exits? Wouldn't it be better to tie the lifetime
of the buffers of the connection? Sure, the buffers will become
unavailable after the connection is closed, but at least you don't
'leak' memory on send/receive process crashes.

Unless of course you're saying that only CAP_NET_ADMIN processes will
run io_rcrx connections. Then they can do their own mp setup/RSS/flow
steering and there is no concern when the process crashes because
everything will be cleaned up. But that's a big limitation to put on
the usage of the feature no?

--=20
Thanks,
Mina

