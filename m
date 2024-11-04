Return-Path: <io-uring+bounces-4439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 525BF9BBEB7
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 21:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83F4C1C2197B
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 20:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4CF1E3DE0;
	Mon,  4 Nov 2024 20:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MysYrUtk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0F21E3DD1
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 20:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730751656; cv=none; b=DlxLPyrAYljuL1cGSs2TPa3AfX/3DDuEuGoTlPxflJVb/7ZPEOyz8yiuj45V+8ibNEEyY/Uxw9RcjrhqHJLJk96VIY9fMmSenMdXLWuvLHEQhKzEXEKHDsaJzI73wzhLgUAHhB3bEH7dCVmaJOLZ/vnJaFJttmip1eEwSvxmw5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730751656; c=relaxed/simple;
	bh=G8UM6S47N1hnQwwcxjbdqO/6J6HHccLXABrZTA+EPTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=chgyS3BxVIyswuphxgpwyFpEp49k6n5euMP126YxMbNOUD51+JoHDKEbD2tI0NMBdfneateet1dCS0yQsa9q5PoyAE1tcWiTPqNzEyO8Ry4sqeWjeP0RLRd7u30i8E00EppQIo8Gbf79ZjQTRdEkdjTQY8MzVgol6BDLhhdcqXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MysYrUtk; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a4e54d3cefso38715ab.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 12:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730751653; x=1731356453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uql/Bw1vcaYh8+NWY2ZEj9oRvcn+EreIycRFoRD4OVw=;
        b=MysYrUtkyTmu7zxzu2II/1nvVCMXbIcUE9hmdCD7Nvf2z4LLNExuRKSjs58DTTpPPL
         NRslZAzS6SIR9nl4E9nqavWmhwDeMWVOY2F5nGcL4dzkO0548/5DnS1peCu+WP59bQBe
         5Ei1nFNTqAajybLmE1H5s1ROndhxzDgnZpUpk5xuXsPf2EQNe3Gg00ciAr7nOk75jBIu
         IxnbRIn5NZKHwsURWBizBohv9IED8CaQ37u+fmtFotmdS/4sF7BJLY/IdJgcEA7TBr9J
         luzYk8yuIE0f/6EPbK9HCIw7tlEi1+VCZiLL5akIRtwFTLAR/of2JGUzhphNmK68w1//
         aUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730751653; x=1731356453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uql/Bw1vcaYh8+NWY2ZEj9oRvcn+EreIycRFoRD4OVw=;
        b=oUc79WoaX0cF3VQFMHggEWafNFVNYAGFVmUU5PwX3SgzJIpuPUyrI9xudK1KJFqWlG
         FNg24z3wtnDyiGnjDrrslVtkjHfxPpzxljf/v+Ty1YNy9VinJBGLy9SQUuowCrGQzNK6
         GzMATirpcQJtyGPgNb+ey3QYPm1bIZ/1dy/EIVj3eO6FZ17/a6g5R/30QJZGR2e7xcfg
         97yqu4XbtoQ/5OVRFGicRzmh4AjyLLxLZjHMTrzARF9rAvkL/NynCLHEHF36IkzxG9YB
         jHzV2e8JwFL1bPn38sbZWNOEheryHlFJfbvdJectnoeE0JM684LmS9tmQmb2lKQQZzuh
         X5fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkU40nrueuZj/gdUYo/7NpMkUvJNiNsAIoeWbGhzxVgFHb1QOZB/akNjEnieVfpETgcxA03S77Tw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOv+Aoest7vRfj5W5oZBjLfu62ASilvk8jyJxLrRvUNI+lx043
	vlkDJ0nv4vceroeD3OahU1K9p3MZOQYEiko62NesKZzxsmzqdMjN7HEOjFDnUwFjoV9mSPMRuRN
	p61RfIIXO6D+s1+PILXEjLPA648V6SX4bGvXjgGye+ejPlDhhzn8l
X-Gm-Gg: ASbGncsOgUQQfd7pKw0ZBghxWiCt6e2LsCHvk0YM3hBIdwdqkmWLFqovLlD5eAtS7vp
	gGfbkgQp8hMgdaWu/darH03XDYZ380etF1kaaTiZ/I1xHG4KS1KFHYGeF8tPw9w==
X-Google-Smtp-Source: AGHT+IFzSkcrUS2LnkOi2cTsx/E8EjUnf3mipQEN/gZ5HS1tCJDpCOnfzB4nfSUr8CDBFueEK+2x9JATC18GABaEGjI=
X-Received: by 2002:a05:6e02:12b4:b0:3a6:b318:3b99 with SMTP id
 e9e14a558f8ab-3a6daa9e751mr547355ab.27.1730751653363; Mon, 04 Nov 2024
 12:20:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-5-dw@davidwei.uk>
 <CAHS8izPZ3bzmPx=geE0Nb0q8kG8fvzsGT2YgohoFJbSz2r21Zw@mail.gmail.com> <5b928f0e-f3f8-4eaa-b750-e3f445d2fa46@gmail.com>
In-Reply-To: <5b928f0e-f3f8-4eaa-b750-e3f445d2fa46@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 4 Nov 2024 12:20:41 -0800
Message-ID: <CAHS8izMTuEMS2hyHs0cit0Wvo3DcuHxReE1WS-crJ8zDTs=_Wg@mail.gmail.com>
Subject: Re: [PATCH v7 04/15] net: prepare for non devmem TCP memory providers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 10:41=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> ...
> >> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >> index e928efc22f80..31e01da61c12 100644
> >> --- a/net/ipv4/tcp.c
> >> +++ b/net/ipv4/tcp.c
> >> @@ -277,6 +277,7 @@
> >>   #include <net/ip.h>
> >>   #include <net/sock.h>
> >>   #include <net/rstreason.h>
> >> +#include <net/page_pool/types.h>
> >>
> >>   #include <linux/uaccess.h>
> >>   #include <asm/ioctls.h>
> >> @@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, =
const struct sk_buff *skb,
> >>                          }
> >>
> >>                          niov =3D skb_frag_net_iov(frag);
> >> +                       if (net_is_devmem_page_pool_ops(niov->pp->mp_o=
ps)) {
> >> +                               err =3D -ENODEV;
> >> +                               goto out;
> >> +                       }
> >> +
> >
> > I think this check needs to go in the caller. Currently the caller
> > assumes that if !skb_frags_readable(), then the frag is dma-buf, and
>
> io_uring originated netmem that are marked unreadable as well
> and so will end up in tcp_recvmsg_dmabuf(), then we reject and
> fail since they should not be fed to devmem TCP. It should be
> fine from correctness perspective.
>
> We need to check frags, and that's the place where we iterate
> frags. Another option is to add a loop in tcp_recvmsg_locked
> walking over all frags of an skb and doing the checks, but
> that's an unnecessary performance burden to devmem.
>

Checking each frag in tcp_recvmsg_dmabuf (and the equivalent io_uring
function) is not ideal really. Especially when you're dereferencing
nio->pp to do the check which IIUC will pull a cache line not normally
needed in this code path and may have a performance impact.

We currently have a check in __skb_fill_netmem_desc() that makes sure
all frags added to an skb are pages or dmabuf. I think we need to
improve it to make sure all frags added to an skb are of the same type
(pages, dmabuf, iouring). sending it to skb_copy_datagram_msg or
tcp_recvmsg_dmabuf or error.

I also I'm not sure dereferencing ->pp to check the frag type is ever
OK in such a fast path when ->pp is not usually needed until the skb
is freed? You may have to add a flag to the niov to indicate what type
it is, or change the skb->unreadable flag to a u8 that determines if
it's pages/io_uring/dmabuf.


--=20
Thanks,
Mina

