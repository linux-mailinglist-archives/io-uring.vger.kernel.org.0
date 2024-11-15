Return-Path: <io-uring+bounces-4710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D349CD4C2
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 01:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10175B24130
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 00:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C477B44C8F;
	Fri, 15 Nov 2024 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mqKWVytS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9AB433C9
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 00:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731631419; cv=none; b=Kjghf0JENPC24aI315xrkN85BZrSlbfV/HAT5r39IK72lIwAgsCENegrDRdaMvaAWWglemkGh/e4JRYcuqpw/RvSg0oLEwBc36rfEt//pe+fGft/XnB7xvuasVxs98JeOdAGRWh5qn62EKTYgfV8h1XuylAoe62zOywOgrTGQQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731631419; c=relaxed/simple;
	bh=FJIOGWCLd0zOn2KJU/YW/Xn5hiEiN8d8QFD12OSHxzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HSkPdlyOmvvuD7GqMaQ8CIy2UBYbB73uul5UVrzq3M2KkQuYV0kHOjdTK4PA5egkIcpAFcJQIn33/fS5lHdvDMW4Wdlc0Gaai4oGLb/lK//kUoc5KDKqNZnvM3WNSVVhPqkS/u2BMvNGHGr8fN9gn8qR907do35Lt6T+DFspRg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mqKWVytS; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-460a8d1a9b7so51851cf.1
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 16:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731631417; x=1732236217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6L3F4z6VvLws6sCdgJuhbmYdQVM2hzBWnjk8WbNzj8s=;
        b=mqKWVytSnmZH+ox7GAloiueBvnhTPcdv9j0VY4DHNara9xYCXsdCBQz6dfckYNAIVQ
         pHaxdjneAvC9SkJu2bMDa64WvtQ1Kd4/bjDM73bAnehHOdFFZF3vsbuXquFrvMJOXqI9
         vkWGhzOVq83GUHQbZ28XNHPmJM5yxPoKJAPV0r1E9YZWwOSbTSxSup3nOObvz6ppbH2x
         xmjdsgZhu+VtZUNHBCFPNDnRY2ilyO8UXhdavDpZjmN08K6d3ad2FQaAI16i2U0jdhxN
         Z//Bep5BmGUS0ZspIZXRCHZV7vJJeXCzkRMS7ckG3EAHxQtm4/sAEshBz+8m5mSYuoip
         0H8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731631417; x=1732236217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6L3F4z6VvLws6sCdgJuhbmYdQVM2hzBWnjk8WbNzj8s=;
        b=U7q/xjwZjp/Mh89e9+M0Ff6C59mMzIbSVIJc+vIyNjoqPEzzl8w9JUOEplijrywYOV
         ZqsuaZCz+mK1Bkh0FelV4sWxj+xzKWIlS1HuQmv1p+/qsVp3Gad4tmEgCpDVVPACETcC
         I4cYH8ePaX1btFEDC3U/wyT+EpXUWsCz0G2OdP8+vrDGYxVHX5vpvTetRraa3eKDJXLC
         pPe6h5icv2VIm52K69AViurDaHXjfrkNabFEZcAYeZiddDIf8XZsV/qFHRbNdO1kPRq0
         0zGNjfFn3inzjx28XsIHAEX7uo2mO2p2VV7+s5V+/GjIodQ7hs8Zq7ZxB3RCw3YJok9z
         QMzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVER2cLkYrbLqfHKA2w7pgXdkNM2fuKz1pgZXJqDVYpNRm6aW5FbzISCpyDiNm+n/RwVZJOk8nknA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjPmAecmJ1rb6dtW4eBVosyDuTVq2fyY1zyekDeUsh1gz+HFDb
	UcHh1jEDstluivQ2pYJg/i91yxWkSDab+re0SSEamPl0bGQNfgrV/pdi5LBLl09gDni7+wInbem
	7lxs/HH4nvHV1k5jxjlyUqKtT/7IsgGpuBV28
X-Gm-Gg: ASbGnctKtUr7fmCgRbrEtEAiaLLxI865NMPfZgaCPNBYjhsumurCuLHEQhU/JagVUuy
	iqMSB+fOtsT83mTnTnIK3LgU46+oZuLI=
X-Google-Smtp-Source: AGHT+IEyGdliSHvtMyXSP/W6yT+yNwxpe//bWguU5hFzmSUkQYmcbAnAlQj03BMC20ZVFq0x1pqImhz3wa71bPHBzfw=
X-Received: by 2002:ac8:58c3:0:b0:461:70cc:3799 with SMTP id
 d75a77b69052e-46364d97befmr575061cf.21.1731631416763; Thu, 14 Nov 2024
 16:43:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-5-dw@davidwei.uk>
 <CAHS8izPZ3bzmPx=geE0Nb0q8kG8fvzsGT2YgohoFJbSz2r21Zw@mail.gmail.com>
 <5b928f0e-f3f8-4eaa-b750-e3f445d2fa46@gmail.com> <CAHS8izMTuEMS2hyHs0cit0Wvo3DcuHxReE1WS-crJ8zDTs=_Wg@mail.gmail.com>
 <c5213478-a6ec-431e-b11b-cc8271a84d59@davidwei.uk>
In-Reply-To: <c5213478-a6ec-431e-b11b-cc8271a84d59@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 14 Nov 2024 16:43:24 -0800
Message-ID: <CAHS8izMat6eN9b-anHOqkrkmfTpBQ6hn3rj2FqeKj=FLVhcTmw@mail.gmail.com>
Subject: Re: [PATCH v7 04/15] net: prepare for non devmem TCP memory providers
To: David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 11:01=E2=80=AFAM David Wei <dw@davidwei.uk> wrote:
>
> On 2024-11-04 05:20, Mina Almasry wrote:
> > On Fri, Nov 1, 2024 at 10:41=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >> ...
> >>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >>>> index e928efc22f80..31e01da61c12 100644
> >>>> --- a/net/ipv4/tcp.c
> >>>> +++ b/net/ipv4/tcp.c
> >>>> @@ -277,6 +277,7 @@
> >>>>   #include <net/ip.h>
> >>>>   #include <net/sock.h>
> >>>>   #include <net/rstreason.h>
> >>>> +#include <net/page_pool/types.h>
> >>>>
> >>>>   #include <linux/uaccess.h>
> >>>>   #include <asm/ioctls.h>
> >>>> @@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk=
, const struct sk_buff *skb,
> >>>>                          }
> >>>>
> >>>>                          niov =3D skb_frag_net_iov(frag);
> >>>> +                       if (net_is_devmem_page_pool_ops(niov->pp->mp=
_ops)) {
> >>>> +                               err =3D -ENODEV;
> >>>> +                               goto out;
> >>>> +                       }
> >>>> +
> >>>
> >>> I think this check needs to go in the caller. Currently the caller
> >>> assumes that if !skb_frags_readable(), then the frag is dma-buf, and
> >>
> >> io_uring originated netmem that are marked unreadable as well
> >> and so will end up in tcp_recvmsg_dmabuf(), then we reject and
> >> fail since they should not be fed to devmem TCP. It should be
> >> fine from correctness perspective.
> >>
> >> We need to check frags, and that's the place where we iterate
> >> frags. Another option is to add a loop in tcp_recvmsg_locked
> >> walking over all frags of an skb and doing the checks, but
> >> that's an unnecessary performance burden to devmem.
> >>
> >
> > Checking each frag in tcp_recvmsg_dmabuf (and the equivalent io_uring
> > function) is not ideal really. Especially when you're dereferencing
> > nio->pp to do the check which IIUC will pull a cache line not normally
> > needed in this code path and may have a performance impact.
>
> This check is needed currently because the curent assumption in core
> netdev code is that !skb_frags_readable() means devmem TCP. Longer term,
> we need to figure out how to distinguish skb frag providers in both code
> and Netlink introspection.
>

Right. In my mind the skb_frags_readable() check can be extended to
tell us whether the entire skb is io_uring or devmem or readable. So
that we don't have to:

1. Do a per-frag check, and
2. pull and keep an entire new cacheline hot to do the check.

> Since your concerns here are primarily around performance rather than
> correctness, I suggest we defer this as a follow up series.
>

OK.

> >
> > We currently have a check in __skb_fill_netmem_desc() that makes sure
> > all frags added to an skb are pages or dmabuf. I think we need to
> > improve it to make sure all frags added to an skb are of the same type
> > (pages, dmabuf, iouring). sending it to skb_copy_datagram_msg or
> > tcp_recvmsg_dmabuf or error.
>
> It should not be possible for drivers to fill in an skb with frags from
> different providers. A provider can only change upon a queue reset.
>

Right, drivers shouldn't fill in an skb with different providers. We
should probably protect the core net from weird driver behavior. We
could assert/force at skb_add_rx_frag_netmem() time that the entire
skb has frags of the same type. Then we only need to check
skb->frags[0] once to determine the type of the entire skb.

But as you mention this is a performance optimization. Probably OK to
punt this to a later iteration. But to me the changes are
straightforward enough that it may have been good to carry them in the
first iteration anyway. But OK to leave this out.

--
Thanks,
Mina

