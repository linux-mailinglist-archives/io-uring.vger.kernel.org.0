Return-Path: <io-uring+bounces-8242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3982ACFA63
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 02:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 514F73A7EA1
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 00:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549BD5C96;
	Fri,  6 Jun 2025 00:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kR5Gwz1v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926AB257D;
	Fri,  6 Jun 2025 00:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749169103; cv=none; b=f3jDX1WOiXRYWjdvdRQNkuehvegu+XOtes0dQGgqZBTOJ1MOevR9cRSrsscsaZm8Czd4Q9ygc23ctrHuPzbaLlHFJRjsmj2HQO8dFcf0RX0psMq7xuDyffpDWvZ/B2lMoipeBZ41fmqiDxHW/e9BQ3lcwrkVuNw9uZuVEWBLqC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749169103; c=relaxed/simple;
	bh=afPGX4x4+KsmVCitk1TAmuyskJRq6RcU+QkJK+0JFjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ap5yg122j3zNfcNEfXB6eDD0r5x4QAPgVYxs5McSCvcodQICgeVgDNmb/5p8nb8DkS+8wc79WQs3gAbcMlYtd4NrnobHvnQM1/kHp7GgVqU6vG5q4waX1N3Ut+sIKXYso7ktcKklrbQ5B8Uj7s/3NJHfAjTbGUnOIwzZBZM0B20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kR5Gwz1v; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3dc75fe4e9bso8580825ab.0;
        Thu, 05 Jun 2025 17:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749169100; x=1749773900; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgwbHvBoczoJieXBooLMQ38TI5ZL4QgmCGl0bb41wGE=;
        b=kR5Gwz1vHpHqHc9IboGyYtNRAEYS5ZnjWk9fR6lCZswOFzB/afqDj+zxBdRPvbOfKh
         tzWVdqNJK7c+K5W9U4t8lqyPVd/se8ZBqGKy//ATz3RX0SOWx9AD5TRHQFaTYpH1noCx
         p3VQ/2HI7Ja+O43IM3xq8mWZFwkE8mH2f6I+CCPvu0u4oGGmvfSD2luqnbLxrrgGSZg5
         rJBa2dWlTwMQeH+w4r/Csqf3f3jibGUkR+0p0P6mjfH7HIq+rH7ktiTKzJCWUXIhekaR
         9Jl3ZlEMgcbRSmBhGfYSKyEuJiVruwGrMebJPXsyhi/Og6upHd5Va9LqttNT3WlLFuSG
         2CoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749169100; x=1749773900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgwbHvBoczoJieXBooLMQ38TI5ZL4QgmCGl0bb41wGE=;
        b=XiLCDHeAL/fWp1zvAnQxOSDwxnNBS7/8XSYVy/kK07/Bov9PHgeeBAc8FLTa7TqudS
         3OuqyDqcZahg3jLgYlArWkwM66nBuO719C3ri0Cpp7ee1D6TzHpmmjbglDumGIx3ndzi
         L4/EPw07KK/mc2npiJxxsLCoEBUHH6q6gOSK5gbT/wZFDLNUp6PX3Udvs3qX6G22NzaM
         mY0+VdFa7IGCgu5jqm/hz3YS2FAuN4FGb8czaQmvYsl6eIl/CBEXt/cLueEij6KeMMYi
         iT22JP1ncTpM5W50VUEz5OKZ0riOEzGeNNPGO52CKSQ5xZj6c+ZnIJBUjOmIey900XXZ
         TUMA==
X-Forwarded-Encrypted: i=1; AJvYcCW2wfrgQ8UNyzgLKyz1AJg3eZu3MwcDwFxsfopIKGwRP9tYSs2cDgmTohn8FpwnLzhw8k2s1ggi@vger.kernel.org, AJvYcCXdFbISVBi6zoeOALPLCNcSwEJ26lVrw1DS6UI/SdsE/OYGGHrhh37DswdCZOrYtZKFg7w7Ex5z7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFJjb31cgLoaSPIW5yRv1gaZ7sCqUR99Ft8lIMUWRDvczLQEdP
	N3NIyLmO7Zet2Gn47+ZTis607+uNRUl8J2Qxb4emL/vFzpaqaFlRmebGIG6vAOSscufCNDKy98x
	H1I1k6i9hN/RJKnRH+FYVftwPBG4YIec=
X-Gm-Gg: ASbGncu0RbSJMpzxyd3P0qBIf5hFigFkhaIkGjEqFL85NUM/OD3JxhIWB78TnRUh3lp
	+0j70T02kJaSpDpWQ9WGKpAp4fgiIZ9q8aQ/x8bZIIEZvuyN3/JkME3/WTxOEyCn73bZy6jehVg
	MN33apPMzDo2tSHsX9GN8j6SsTKZ8jVOO6Rdzxq4TtNFNkkWAQX1oqsg==
X-Google-Smtp-Source: AGHT+IHejsjfafuT+fPslTjI1f4V6IshJEMqFJGslKboGl6wEpseQL93xEqnxajbwweubU3/xpS4P02ua54VYP4+AUE=
X-Received: by 2002:a05:6e02:3e05:b0:3dc:875e:ed8d with SMTP id
 e9e14a558f8ab-3ddce5d8c17mr14437545ab.4.1749169100527; Thu, 05 Jun 2025
 17:18:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749026421.git.asml.silence@gmail.com> <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch> <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
 <68422e4d1b8ef_208a5f2949@willemb.c.googlers.com.notmuch>
In-Reply-To: <68422e4d1b8ef_208a5f2949@willemb.c.googlers.com.notmuch>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 6 Jun 2025 08:17:44 +0800
X-Gm-Features: AX0GCFtKpA2rl6ZhwKKot9X8brZZsv3b9wBx9ab88eM5X_9x7h4XJlHAlfcLWcE
Message-ID: <CAL+tcoDVZUPrGTKwbd-4vSp4uy_6oV6oJgk0ek8nVzO5TkjmdA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 7:55=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Vadim Fedorenko wrote:
> > On 05/06/2025 01:59, Willem de Bruijn wrote:
> > > Pavel Begunkov wrote:
> > >> Add a new socket command which returns tx time stamps to the user. I=
t
> > >> provide an alternative to the existing error queue recvmsg interface=
.
> > >> The command works in a polled multishot mode, which means io_uring w=
ill
> > >> poll the socket and keep posting timestamps until the request is
> > >> cancelled or fails in any other way (e.g. with no space in the CQ). =
It
> > >> reuses the net infra and grabs timestamps from the socket's error qu=
eue.
> > >>
> > >> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked =
with
> > >> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 =
bits
> > >> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). =
The
> > >> timevalue is store in the upper part of the extended CQE. The final
> > >> completion won't have IORING_CQR_F_MORE and will have cqe->res stori=
ng
> > >> 0/error.
> > >>
> > >> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> > >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > >> ---
> > >>   include/uapi/linux/io_uring.h |  6 +++
> > >>   io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++=
++++
> > >>   2 files changed, 83 insertions(+)
> > >>
> > >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_u=
ring.h
> > >> index cfd17e382082..0bc156eb96d4 100644
> > >> --- a/include/uapi/linux/io_uring.h
> > >> +++ b/include/uapi/linux/io_uring.h
> > >> @@ -960,6 +960,11 @@ struct io_uring_recvmsg_out {
> > >>    __u32 flags;
> > >>   };
> > >>
> > >> +struct io_timespec {
> > >> +  __u64           tv_sec;
> > >> +  __u64           tv_nsec;
> > >> +};
> > >> +
> > >>   /*
> > >>    * Argument for IORING_OP_URING_CMD when file is a socket
> > >>    */
> > >> @@ -968,6 +973,7 @@ enum io_uring_socket_op {
> > >>    SOCKET_URING_OP_SIOCOUTQ,
> > >>    SOCKET_URING_OP_GETSOCKOPT,
> > >>    SOCKET_URING_OP_SETSOCKOPT,
> > >> +  SOCKET_URING_OP_TX_TIMESTAMP,
> > >>   };
> > >>
> > >>   /* Zero copy receive refill queue entry */
> > >> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> > >> index e99170c7d41a..dae59aea5847 100644
> > >> --- a/io_uring/cmd_net.c
> > >> +++ b/io_uring/cmd_net.c
> > >> @@ -1,5 +1,6 @@
> > >>   #include <asm/ioctls.h>
> > >>   #include <linux/io_uring/net.h>
> > >> +#include <linux/errqueue.h>
> > >>   #include <net/sock.h>
> > >>
> > >>   #include "uring_cmd.h"
> > >> @@ -51,6 +52,80 @@ static inline int io_uring_cmd_setsockopt(struct =
socket *sock,
> > >>                              optlen);
> > >>   }
> > >>
> > >> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, stru=
ct sock *sk,
> > >> +                               struct sk_buff *skb, unsigned issue_=
flags)
> > >> +{
> > >> +  struct sock_exterr_skb *serr =3D SKB_EXT_ERR(skb);
> > >> +  struct io_uring_cqe cqe[2];
> > >> +  struct io_timespec *iots;
> > >> +  struct timespec64 ts;
> > >> +  u32 tskey;
> > >> +
> > >> +  BUILD_BUG_ON(sizeof(struct io_uring_cqe) !=3D sizeof(struct io_ti=
mespec));
> > >> +
> > >> +  if (!skb_get_tx_timestamp(skb, sk, &ts))
> > >> +          return false;
> > >> +
> > >> +  tskey =3D serr->ee.ee_data;
> > >> +
> > >> +  cqe->user_data =3D 0;
> > >> +  cqe->res =3D tskey;
> > >> +  cqe->flags =3D IORING_CQE_F_MORE;
> > >> +  cqe->flags |=3D (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
> > >> +
> > >> +  iots =3D (struct io_timespec *)&cqe[1];
> > >> +  iots->tv_sec =3D ts.tv_sec;
> > >> +  iots->tv_nsec =3D ts.tv_nsec;
> > >
> > > skb_get_tx_timestamp loses the information whether this is a
> > > software or a hardware timestamp. Is that loss problematic?
> > >
> > > If a process only requests one type of timestamp, it will not be.
> > >
> > > But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
> > > annotation may be necessary.
> >
> > skb_has_tx_timestamp() helper has clear priority of software timestamp,
> > if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW case
> > won't produce both timestamps with the current implementation. Am I
> > missing something?
>
> The point of that option is to request both SW and HW tx
> timestamps. Before that option, the SW timestamp was suppressed if a
> HW timestamp was pending.

Agree, the regular driver does such an implementation in such an order:
XXX_xmit()
{
    if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)...
        skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;

    skb_tx_timestamp(skb); // here, it would not generate timestamp
with SKBTX_IN_PROGRESS being set in advance
}

If both sw and hw flags are set, the software one will not take any effect.

Thanks,
Jason

