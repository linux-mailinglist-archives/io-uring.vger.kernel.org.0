Return-Path: <io-uring+bounces-8244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A46E9ACFE62
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 10:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6477A163F80
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 08:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3181127C14B;
	Fri,  6 Jun 2025 08:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQGa+fE2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F41DF739;
	Fri,  6 Jun 2025 08:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749198846; cv=none; b=I7f2shniXxMvbG+dmLIeO9wkb6u0DBZhbN7xH2wpwLVgLqsBcswk767QOzSxAaMsElsZRcPDNi4xJCNI+8HORM4rs/2eOcb+9W6J6wUbY6UFYcQ9G7X78QLJSmSHLGqlZVh+q8uMtK2kM4ubw/pRW6+qxyDcUgTN+hEq0oaaaWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749198846; c=relaxed/simple;
	bh=MlWjKv6N8n786ldv+fOBqFDX6cRovDX3bUWZpnnE31s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prZPZWbGh5A1ZwgqZck600LZRz2PqA9LNddU5IkWutct9HTtbTr13aJ7TMG1yWqhO4s/EXN6CFGeAtNGu9n8ZErWTcLuBVf+8cEV0BeH+yLlFMKPrGR9zgoy09MkcN6sR4MOh06dXbu0HvvhMjP+kphUYfIWT2ys1DkZxfUjntM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQGa+fE2; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3dc7294716cso15118835ab.2;
        Fri, 06 Jun 2025 01:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749198843; x=1749803643; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEV0yP7e+tTurJnFgSwDfnrgYjosGeo8ZE0291CoQy0=;
        b=iQGa+fE24dMKW6CWAg1AJz9Jy5EvlihR9LAYCEHD2WhfkJUSfwERVkWibWykWULNpV
         jWuqJR8nktCo3wPvVeXIrrYavui73npgS4Pg7A8w0P4mrVhem6iFZQ68bTcktW+5PRIe
         FdIlnUj0UyI91LEYfSq1R4BpT5Vm9/fwB4L7s6vrkWJlgEQCxnjxeyg/KjoCjEyZm5Ge
         gpzLeCSr2LJqPGXGqljElsufbWPVkbWatMwfQGpjLxf274RgzpuRT/MBX0GWRx3z+xrL
         UJYXqhJVgghLWnMAiQsqqjUirsSHnuTKTa+fP3JLf0P5zPowneHa7hE7j5k0v/Z09UuP
         WDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749198843; x=1749803643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEV0yP7e+tTurJnFgSwDfnrgYjosGeo8ZE0291CoQy0=;
        b=nnfRZJjFGw3+dtkNhQabnrktFHocmU5xvz160sD2/DkW532aekd3pJww4qlASBk6M+
         HenOi+vk9QMFFQxbdUnKXw6ZrpG1wNvmwDbjx62O945k64WAlNcwrpVHM+pt12oAEy8v
         UXq5kXN4tkk2DY+daop4u/dZLbc8c3gfZZbfJFjfz5XzPsqb/yHp3UPJmqQRp7IZ8VL+
         8RdEwm2reYCQjGMU4+VhsWX5E+z5k1Gy/pD229aUvlpWcBL/Bxo9CAieE+0lLK3pGm47
         r/5YK/TlQJtl0NrbEIzIo8EGDM5rpBHcXPM4kyrWmKriGkL/C4ZnrqpF9gp3HFIuBPQd
         +3xA==
X-Forwarded-Encrypted: i=1; AJvYcCUNmhQVpPAjEBhynuCHMJAi7e9KKGeCDOGK8LJXMLUxdiwB0m3KdwAamrha03i+zor53LAWGJa4@vger.kernel.org, AJvYcCXR0g2IuUGZbh4Ihc9qj29upGcSF3e4vdtw5Oc+2eAK8FTu/vsXmaedhO9AhlN6/QGapoarw0rQqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoufUOKp74ByMJEUomiEoQ3cF+W4E5+a1IcHwbuunGA1xxXp1+
	6iJJDToWujNffRGmf6sduFcmGzIMT7OgsP7ufrub3jyj8T6bjxEkxuqS6+Z9MwvoTQSMzSg+EHG
	LGvcHkOsO/6cmPUx5EPAzN/g7n2NURss=
X-Gm-Gg: ASbGncvDCG9MyKyZlDUIZN1oysWYxv7Kj4G9X0Udf4mED1DRNj9sbl7MbAs14C9Wcm1
	Y2b7naaJ41Sh3+wTOcdw/cHH5w1aZ+eE3jSc2pA3if+jPsqZI1PJwuf1LizY7rNLuwLGf8jUjEA
	q6/B4QMyt9soM53EXLC0+iIugPX1qzKipWPZJ9L19fFu0=
X-Google-Smtp-Source: AGHT+IHAgZYASrsHIPplviCv7Kp5d6BKggJOd+4qBlUUUxN/muYGA+0S/uDR7cuuebsle4hZYPd02SUtsGFLrtfpPfs=
X-Received: by 2002:a05:6e02:1aac:b0:3dd:c40d:787e with SMTP id
 e9e14a558f8ab-3ddce4136damr29394415ab.2.1749198843531; Fri, 06 Jun 2025
 01:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749026421.git.asml.silence@gmail.com> <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch> <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
 <CAL+tcoAPV03jr6p2=XyRhdC1KiZBojtqn-frBdKjh+0=f=G2Qw@mail.gmail.com> <449d5c82-7af5-42ce-bd69-00c2bb135a21@gmail.com>
In-Reply-To: <449d5c82-7af5-42ce-bd69-00c2bb135a21@gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 6 Jun 2025 16:33:25 +0800
X-Gm-Features: AX0GCFt8Lln1mFEw0D1s0DEDHPnsYV1ib0zPKGoBdwXWUHV_nP_V2Sa2OCKBCeE
Message-ID: <CAL+tcoCTpFm+-CVZb-6=70ZCh3ERHrJ19MmL+u56SNFrkd2QCw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 4:11=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 6/6/25 01:02, Jason Xing wrote:
> ...>>>>                                 optlen);
> >>>>    }
> >>>>
> >>>> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, stru=
ct sock *sk,
> >>>> +                                 struct sk_buff *skb, unsigned issu=
e_flags)
> >>>> +{
> >>>> +    struct sock_exterr_skb *serr =3D SKB_EXT_ERR(skb);
> >>>> +    struct io_uring_cqe cqe[2];
> >>>> +    struct io_timespec *iots;
> >>>> +    struct timespec64 ts;
> >>>> +    u32 tskey;
> >>>> +
> >>>> +    BUILD_BUG_ON(sizeof(struct io_uring_cqe) !=3D sizeof(struct io_=
timespec));
> >>>> +
> >>>> +    if (!skb_get_tx_timestamp(skb, sk, &ts))
> >>>> +            return false;
> >>>> +
> >>>> +    tskey =3D serr->ee.ee_data;
> >>>> +
> >>>> +    cqe->user_data =3D 0;
> >>>> +    cqe->res =3D tskey;
> >>>> +    cqe->flags =3D IORING_CQE_F_MORE;
> >>>> +    cqe->flags |=3D (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIF=
T;
> >>>> +
> >>>> +    iots =3D (struct io_timespec *)&cqe[1];
> >>>> +    iots->tv_sec =3D ts.tv_sec;
> >>>> +    iots->tv_nsec =3D ts.tv_nsec;
> >>>
> >>> skb_get_tx_timestamp loses the information whether this is a
> >>> software or a hardware timestamp. Is that loss problematic?
> >>>
> >>> If a process only requests one type of timestamp, it will not be.
> >>>
> >>> But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
> >>> annotation may be necessary.
> >>
> >> skb_has_tx_timestamp() helper has clear priority of software timestamp=
,
> >> if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW cas=
e
> >> won't produce both timestamps with the current implementation. Am I
> >> missing something?
> >
> > Sorry that I don't know how iouring works at a high level, so my
> > question could be naive and unrelated to what Willem said.
> >
> > Is it possible that applications set various tx sw timestamp flags
> > (like SOF_TIMESTAMPING_TX_SCHED, SOF_TIMESTAMPING_TX_SOFTWARE)? If it
>
> io_uring takes timestamps from the error queue, just like the socket
> api does it. There should be different skbs in the queue for different
> SCM_TSTAMP_{SND,SCHED,ACK,*} timestamps, io_uring only passes the
> type it got in an skb's serr->ee.ee_info to user without changes.
> Hope it answers it

Sure, thanks, io_uring has no difference from other regular
applications in this case. Then the question that Willem proposed
remains because in other applications struct scm_timestamping_internal
can be used to distinguish sw and hw timestamps (please see
__sock_recv_timestamp() as an example).

Thanks,
Jason

