Return-Path: <io-uring+bounces-8241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1486DACFA3E
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 02:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 709053A2A8B
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 00:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276B1A41;
	Fri,  6 Jun 2025 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TF/TxvBf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C663207;
	Fri,  6 Jun 2025 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749168184; cv=none; b=Sp1SF1iZRP4hnH5FdlyWvOdnunW9aWsRcz/3KsGv9NY0Ii9YUPobkQiaxsMGquHUu3xmq58m6Dh3zigHvSa8qh3iPDtgSyg/dR1LDohBUfBjRmobiukJLJ+Xc2PPSXQngrvjXHEBlwQXaXAclnaPCBaFGXlhAKQTt5yzpeQObls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749168184; c=relaxed/simple;
	bh=FdcIHdPx0ksSAZBIJwMGRXFW7FvprZitYI2rHCS8GQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=meZqYwfiRE3mtAXTkvgs0hNY88RnA+WY9byUz9bzGmXUsyj86VXM3NbZBoHryDCLkcntsyg83FmZXuJ3JUMqdwA2r0oUEnpQgkFWhuvF9l+rxpKdTyQFdU9JDRGuOjrEBl06zPTPC5kEOmnGELVBqIGLUim9QxlbFYAqszSJ2e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TF/TxvBf; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3dc729471e3so5612495ab.1;
        Thu, 05 Jun 2025 17:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749168181; x=1749772981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ol1H35GQ5gfDlnvCO31964QgUmjH2VB97/PUdrK9o3M=;
        b=TF/TxvBfJtKNeuiDBhyQJd5jOTSo/awY0hqhdDZKlJPD/jFbimBy31GxyYs/qAearL
         RmMAk+UoWsFsRN5ueg3Ct5b1C0KJiPR1lbl8Ew+KODWCIlHZOLo1ZBdowopgXlAnBqCC
         aqQe26ADYAwF2zUIKsrfTzMd9KOe/bIaASkiuEBzVA3zjN7F0kFvQWkdCau+eIKjfYaA
         j6ORQ6fs8+fCaOEyCzcFBVJULmd/VmTSAL50wUW4VGC7uuKFXGWsmxUcV55caPoVgBZj
         CYtBU7Zk9HsHAuIoeJFtLVHGy9/cPcn0E5DUPLPWENnKBHWt8gQOGcp2kvMTGw5Gsb+y
         aHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749168181; x=1749772981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ol1H35GQ5gfDlnvCO31964QgUmjH2VB97/PUdrK9o3M=;
        b=FNLowFPJYZ7mWKMSlFS+P6mq29Fgml0g1Gco43+3kdd2M3sjhd9FSMrpMKgHqvuaz1
         5e0sinG1/sfK5AxiOCPwM1teb5ZOsLMtg3NGYkjvhPx+BxXl5P6dytzM/B3iUaPxpxe/
         m2zOm34T58LuWY4qeFWO5i2f9eQ7awP2+T6pNNhwq99xfcrZHGZZEwIdl33cnw7XaQ9E
         XMfA8m32pWk2Wybpt/KqeVrA6J7eFHFAsApWd5WzdbPWheJITmIFf6Pj8p4L+eNBdl5B
         y4R4m9O4NvmLan16mck/4De6Ydtn1JQFwnajIfeXfg2pcF36yBVZY+Nlu44lkYZGzv0f
         Okxg==
X-Forwarded-Encrypted: i=1; AJvYcCWGo3fpaWA1bF/cx/tZw6v4+7aZF20tYu9AlaEk0KOp2iup+cK6D/+W/KlSq+lKKEoCH3QmDWiHew==@vger.kernel.org, AJvYcCWS4ntju3bPM1qw6SNxPoVJatkQQ+wJ1FF4KNJ+VeTxgzFWY07/hyf6vsvBi5wmxbxHqrL7O3zy@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd7K9MTvJwUyAudF4XhEOYt/V7LakbbWFTSo2SERlqhCxo6aOJ
	KzEEi6NfDv3yorAArxsCNMp/PkYIy2G7iTWiQLMM9LoKHN2f1jZ7/A+UhQNG1rVeIQqL6aw2gdD
	CgEh1ISEtp+TN3eqqRF3s3SCmEzfH8Jw=
X-Gm-Gg: ASbGncsXeEbyWqcyTAy9UzkekLivFA0tp0sfouxVCeJYMC9vSIxSqWEfbPTJy5YDLxJ
	6wSoCddE/NwDu2gQkFp1CShDo//saWELgb1Ww0bfYanccWrUqzvvVw7qE/RBeoJPGB058K9DRoI
	HEMtg2yEd+tL03QONjQvJoYdFghImB4DHUIvt4Xt6Ps0E=
X-Google-Smtp-Source: AGHT+IHLfv9+lEKkIRQLvwrCEx2VFHQlUePZMcpGHIOg/YJJJeF+B5L/32Y8Q93/SdtUlH+uRpOWFRXJYOKLJztCMWA=
X-Received: by 2002:a05:6e02:1a01:b0:3dd:8663:d182 with SMTP id
 e9e14a558f8ab-3ddce4165c5mr12540765ab.13.1749168181302; Thu, 05 Jun 2025
 17:03:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749026421.git.asml.silence@gmail.com> <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch> <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
In-Reply-To: <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 6 Jun 2025 08:02:24 +0800
X-Gm-Features: AX0GCFtgQAerDX_M4E5U1c3zC5rS9cPc8GwS46Em7ONLTI31iNoD9nCFyA5YAj8
Message-ID: <CAL+tcoAPV03jr6p2=XyRhdC1KiZBojtqn-frBdKjh+0=f=G2Qw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vadim,

On Thu, Jun 5, 2025 at 6:26=E2=80=AFPM Vadim Fedorenko
<vadim.fedorenko@linux.dev> wrote:
>
> On 05/06/2025 01:59, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> Add a new socket command which returns tx time stamps to the user. It
> >> provide an alternative to the existing error queue recvmsg interface.
> >> The command works in a polled multishot mode, which means io_uring wil=
l
> >> poll the socket and keep posting timestamps until the request is
> >> cancelled or fails in any other way (e.g. with no space in the CQ). It
> >> reuses the net infra and grabs timestamps from the socket's error queu=
e.
> >>
> >> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked wi=
th
> >> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bi=
ts
> >> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). Th=
e
> >> timevalue is store in the upper part of the extended CQE. The final
> >> completion won't have IORING_CQR_F_MORE and will have cqe->res storing
> >> 0/error.
> >>
> >> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> ---
> >>   include/uapi/linux/io_uring.h |  6 +++
> >>   io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++++=
++
> >>   2 files changed, 83 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uri=
ng.h
> >> index cfd17e382082..0bc156eb96d4 100644
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -960,6 +960,11 @@ struct io_uring_recvmsg_out {
> >>      __u32 flags;
> >>   };
> >>
> >> +struct io_timespec {
> >> +    __u64           tv_sec;
> >> +    __u64           tv_nsec;
> >> +};
> >> +
> >>   /*
> >>    * Argument for IORING_OP_URING_CMD when file is a socket
> >>    */
> >> @@ -968,6 +973,7 @@ enum io_uring_socket_op {
> >>      SOCKET_URING_OP_SIOCOUTQ,
> >>      SOCKET_URING_OP_GETSOCKOPT,
> >>      SOCKET_URING_OP_SETSOCKOPT,
> >> +    SOCKET_URING_OP_TX_TIMESTAMP,
> >>   };
> >>
> >>   /* Zero copy receive refill queue entry */
> >> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> >> index e99170c7d41a..dae59aea5847 100644
> >> --- a/io_uring/cmd_net.c
> >> +++ b/io_uring/cmd_net.c
> >> @@ -1,5 +1,6 @@
> >>   #include <asm/ioctls.h>
> >>   #include <linux/io_uring/net.h>
> >> +#include <linux/errqueue.h>
> >>   #include <net/sock.h>
> >>
> >>   #include "uring_cmd.h"
> >> @@ -51,6 +52,80 @@ static inline int io_uring_cmd_setsockopt(struct so=
cket *sock,
> >>                                optlen);
> >>   }
> >>
> >> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct=
 sock *sk,
> >> +                                 struct sk_buff *skb, unsigned issue_=
flags)
> >> +{
> >> +    struct sock_exterr_skb *serr =3D SKB_EXT_ERR(skb);
> >> +    struct io_uring_cqe cqe[2];
> >> +    struct io_timespec *iots;
> >> +    struct timespec64 ts;
> >> +    u32 tskey;
> >> +
> >> +    BUILD_BUG_ON(sizeof(struct io_uring_cqe) !=3D sizeof(struct io_ti=
mespec));
> >> +
> >> +    if (!skb_get_tx_timestamp(skb, sk, &ts))
> >> +            return false;
> >> +
> >> +    tskey =3D serr->ee.ee_data;
> >> +
> >> +    cqe->user_data =3D 0;
> >> +    cqe->res =3D tskey;
> >> +    cqe->flags =3D IORING_CQE_F_MORE;
> >> +    cqe->flags |=3D (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
> >> +
> >> +    iots =3D (struct io_timespec *)&cqe[1];
> >> +    iots->tv_sec =3D ts.tv_sec;
> >> +    iots->tv_nsec =3D ts.tv_nsec;
> >
> > skb_get_tx_timestamp loses the information whether this is a
> > software or a hardware timestamp. Is that loss problematic?
> >
> > If a process only requests one type of timestamp, it will not be.
> >
> > But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
> > annotation may be necessary.
>
> skb_has_tx_timestamp() helper has clear priority of software timestamp,
> if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW case
> won't produce both timestamps with the current implementation. Am I
> missing something?

Sorry that I don't know how iouring works at a high level, so my
question could be naive and unrelated to what Willem said.

Is it possible that applications set various tx sw timestamp flags
(like SOF_TIMESTAMPING_TX_SCHED, SOF_TIMESTAMPING_TX_SOFTWARE)? If it
might happen, then applications can get lost on which type of tx
timestamp it acquires without explicitly specifying in cqe.

Thanks,
Jason

