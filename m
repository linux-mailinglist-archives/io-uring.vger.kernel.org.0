Return-Path: <io-uring+bounces-8225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7257ACE8C3
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 05:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B7C1171669
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 03:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C051E5B64;
	Thu,  5 Jun 2025 03:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AS5Duhxh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1585928E3F;
	Thu,  5 Jun 2025 03:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749095545; cv=none; b=LRAjFN5OABbNCUm5tl9msW4kKTR/ElmZ89S9qdDlc+ogy/XbVCX+XtpjCP8xRdeP07IG+s5Y+SiUcIwmM+CiD3bJcRh2MQqegxTKN4VDdRIt4l2XBgm6l8O42rickzBKt9bKILgGHdwEynduCJMTYPY7Eu6aBg1Zy66Q3aRP0zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749095545; c=relaxed/simple;
	bh=WsBcEF5Vk9zu59plNm8YB14WF93vTT9/YNQv/4rVels=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FfqjlJb8sylDmX8bqufLZVpJCg3lMmLAxCGIpVT1Uu3L9mJTNgd8FIOKegyyrKdubyppXo+W38CjPIhLJ2qt+9xbOSM7datCzU/+SMgRjHi58k653Z8vZe0+cqcbvJfRd6QynErzKzT0SYWzKZBatGJ3vfKuyMt0BFrVrABju3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AS5Duhxh; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3dc6f653152so2252585ab.3;
        Wed, 04 Jun 2025 20:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749095543; x=1749700343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPVBhlWTmTtlcRNbwPpHykHu+57//l3De842R/TvUM0=;
        b=AS5DuhxhXkptQ+Wmbubi4WX3fVejzFIipVpR5R0mkUxByC4p+q4tvRNNwoycZf+pv7
         Gkbx0kGxzOefgfzKXhcv42vuRNfpaBeNdRf3piUIvmfX5+xwNA9qFsVzc5GsWSXHT3bS
         gd5Sl2MnSRneGu9FvX1EBLKXO838Oi8tMTHwy8uogQ+UTe7g9xIa+Uy3V1e8gfrxaRoH
         xmD6VUJwGTGwuPh1wWfVFWeoXT3FN4oGq07l71jhMeLAq6gTwYZ0kIjQKjKoEZY3oZb4
         0sl9IsuOnBJU+M7pVfqqcE3g3L+shRQ+Uqpge1rnEdf/8rgpnpFOg3EVuKgy4XY5KiPr
         7H4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749095543; x=1749700343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPVBhlWTmTtlcRNbwPpHykHu+57//l3De842R/TvUM0=;
        b=sDkZc4vRsT0/ifMl1vbrCzB/mKjrY8cKNSriHvcKAnHV6CO7Fb9j5+qcg7a8+RQGQK
         O2SjyBWiYO0p8rwy702rUW8eR+ymHA5/W+ACUjkyPRyVzSEipNsKSqMQvPbSQckw7bkU
         UMnKZgMFS8tUXbb1yG5sWOsvSs4eZ4DGEHcM1fy0G8HfK6WF6UrLEGRhD8/efzMb3vaT
         sIIgxb9NjSdCIJiRyAkG/bkU50xx5Tnb5zpdqRwBsJfSrTRK2CIog7rCZ0nTcXqlVrwQ
         /lypsrWzVJwx7JWBI4Fc8SEQJUJa4rZJ4TBGSox/xptqp9n2pCeWZaIaC2HZ4SCb2OhD
         PCGw==
X-Forwarded-Encrypted: i=1; AJvYcCUbTW4Wef7avKLjlPoUrnmH2pePFrurwW0drUOtblWCRHjdDAYuw2ApfPqg2/3dmdtz/dONYKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrAESlU3dMRagZ/TDw2rLMwHmEzjv7jqb6VdwiaZH/E7C3l2cg
	Tf8XRmxyKugdaI5593uSIPhUFOnQRzKShi0KnjgSQaJQsN2NAgGIMd0lDL85vinfNtcOOZCx+gs
	dCLxn5KPUqhxkdSxFXkCaGAFOublZujw=
X-Gm-Gg: ASbGnctT8pE5jJGzGyi+I6wJ/IRgxbbSPxkRFJKAmbOxf3guNvoS1CAS1Gxt/nUJKx7
	bN1hT5E3V9CAT6nNT0iEO2iod4a2nsXTSguKGzrKVNNLS78tL+MM/4hRA6EFrKJrTYszJCgfdsV
	r8SVJs1l3lDKKA8v/Tan2vqtHbiQoKaQKK
X-Google-Smtp-Source: AGHT+IEzVWwXunS4V0IhyJlhpIY8PZaxyoVuPkYTbqMmiUd20TeFp/vtkI5InCPj6aeaHYNdrFC8QQH3HjBcwltkVLg=
X-Received: by 2002:a05:6e02:32c3:b0:3dc:868e:dae7 with SMTP id
 e9e14a558f8ab-3ddbedd26e1mr64549655ab.15.1749095543075; Wed, 04 Jun 2025
 20:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749026421.git.asml.silence@gmail.com> <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>
In-Reply-To: <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Thu, 5 Jun 2025 11:51:46 +0800
X-Gm-Features: AX0GCFtvbvnMIVB9Sz7ymrwtuhEQK_VocHTxFhcdh9T3pxLTINsZIycfw4n5bT4
Message-ID: <CAL+tcoAVq5AcD+YAjT3OgLEgrvFeY8phZgqk23m++A+hdEu9RQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] net: timestamp: add helper returning skb's tx tstamp
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 4, 2025 at 4:41=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an skb from an queue queue.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks,
Jason

> ---
>  include/net/sock.h |  4 ++++
>  net/socket.c       | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 92e7c1aae3cc..1cd288880ab3 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, str=
uct sock *sk,
>  void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>                              struct sk_buff *skb);
>
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +                         struct timespec64 *ts);
> +
>  static inline void
>  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff =
*skb)
>  {
> diff --git a/net/socket.c b/net/socket.c
> index 9a0e720f0859..e9c8f3074fe1 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -843,6 +843,49 @@ static void put_ts_pktinfo(struct msghdr *msg, struc=
t sk_buff *skb,
>                  sizeof(ts_pktinfo), &ts_pktinfo);
>  }
>
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
> +{
> +       const struct sock_exterr_skb *serr =3D SKB_EXT_ERR(skb);
> +       u32 tsflags =3D READ_ONCE(sk->sk_tsflags);
> +
> +       if (serr->ee.ee_errno !=3D ENOMSG ||
> +          serr->ee.ee_origin !=3D SO_EE_ORIGIN_TIMESTAMPING)
> +               return false;
> +
> +       /* software time stamp available and wanted */
> +       if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
> +               return true;
> +       /* hardware time stamps available and wanted */
> +       return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> +               skb_hwtstamps(skb)->hwtstamp;
> +}
> +
> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +                         struct timespec64 *ts)
> +{
> +       u32 tsflags =3D READ_ONCE(sk->sk_tsflags);
> +       ktime_t hwtstamp;
> +       int if_index =3D 0;
> +
> +       if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
> +           ktime_to_timespec64_cond(skb->tstamp, ts))
> +               return true;
> +
> +       if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
> +           skb_is_swtx_tstamp(skb, false))
> +               return false;
> +
> +       if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
> +               hwtstamp =3D get_timestamp(sk, skb, &if_index);
> +       else
> +               hwtstamp =3D skb_hwtstamps(skb)->hwtstamp;
> +
> +       if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
> +               hwtstamp =3D ptp_convert_timestamp(&hwtstamp,
> +                                               READ_ONCE(sk->sk_bind_phc=
));
> +       return ktime_to_timespec64_cond(hwtstamp, ts);
> +}
> +
>  /*
>   * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
>   */
> --
> 2.49.0
>
>

