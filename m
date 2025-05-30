Return-Path: <io-uring+bounces-8169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF253AC9586
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 20:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E80E83A7D98
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 18:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7D925E806;
	Fri, 30 May 2025 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8JWaHTF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA223BCF2;
	Fri, 30 May 2025 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748628877; cv=none; b=ESOOrGmK4E3C2Boi8JCktGiTd/3UQr8V0WJzHB5Dm8E3nxGooh6CGczkdD+dCSafqjYeXYf/as2z/j15o9MpnAFJQWOEs9VWdPtU7QvvIF88kWRvsNpHeMA+KcFHhqoZjSCYsOGaA0veiCDrqLxLujQDzks95SSRTLZZ1sHPoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748628877; c=relaxed/simple;
	bh=0/LJdMMBFZufeWFQpLvRMZf0W/wvKpXrJD93YvQZzlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kis+iannJuoq2SDDrm6BX66TWIz1ZKvA1jjVX62pX5a7bwZUCBkvLidMpR8go7n2RX6Vb5p3iLF1gqp2n8/VIUhtTuTmIJo6W3YZT4QGiu6I3ZkJQ7sgwCfPoaG922TC9JR9OjYAq0w9iLeh9sPstKiHD/PqoLvE4l9D3t/J+p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A8JWaHTF; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47692b9d059so32714701cf.3;
        Fri, 30 May 2025 11:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748628874; x=1749233674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2mlu/cFEAP71vZoW0SmXluLf/QnE9T/XdYy82QnTAHU=;
        b=A8JWaHTF6W2qNl3htkvUexoGU4NuA+TUt0fE6mSmdgLegwHGUTb3ZSNzTaoYLekMkA
         sjYtF5Sohegchj14KaWpokj7KmyCfUAiY74JM2Eo+HIBem12Y64XVpIHLgdaU5U1afnc
         eJy4ICflkgQSfyQhT0wcF1EkLJtlufAeTC5JooUq2tCFpeOl483GnLw1bwtXgI2sgoYI
         hS6bS6DGv+GG5Ix15lebaAGPA3zMzu6ug5+VGAY69x/MVXq2DmNqNUj5Yu6WlORtWD6z
         M+I/vc9KOt9BKDhcDtAPXeLmExoVCMeApL+w2Un9HQG0g5DXZVJ1YZav3FZnYb0RgFIy
         diIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748628874; x=1749233674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mlu/cFEAP71vZoW0SmXluLf/QnE9T/XdYy82QnTAHU=;
        b=RVZqY6Z/tlzjf6U5Hx6NzxKVlFQXgfM2GTJ9i/AyasqEblb1nYBVs2Tfs9Iv3Et6Jp
         kzQlwyK6XfbuMSKBtlP7prrOeL14xtZ2k23LuQRcADg4afvh980IpWGXWTnI7HNX2h/O
         tDHksPEo3B5H2CGzIRxpq+tBrgftHEA2PWcKlXH/a2tWdOXL0yIgn1wdrpKZa3dTlpPQ
         w/KkFUSuj6rg4MmBGITNAG+JASFXkv0Z16g3o/WMbup/94QX5uYc8eYfQ2OvyjFaSSHp
         vmilahM/RPll84zgoC/GqUBZGFTTlMe8Q+fy7KxS2WUkzDiTfEgcJ32lQI2MZeAdE4na
         +48w==
X-Forwarded-Encrypted: i=1; AJvYcCVPMrlgbsJjY9pvPo4kZCDzF6LGCaPaNZBwqRHnjiXhYPGdgtaDiJwgmJP5UaMHfQfMWl6drxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC+8gnNxaQSTKPn/jfcjwNpOHEy8g1Cs5d1FPm5OycQjHN5niz
	Gq/VSR1LnmxvtPNqNdvB5wDmoUYTVMW3leS5Mp3TGU7O0nlB3vUnXq3IZXTN
X-Gm-Gg: ASbGnctcqMcu34hiC2n79BhaLe0gGSIWZeSn/8/xDeIJ06hnc+yhJoUu3t4pUKuJ4r2
	e3HTNcphh1BlTLeQxXQdvbTR4rg6zhs8INe2IJOp1emlRIbThpjYHP/M3HGVBJa49Ze1uUix3gO
	rqtLd3d2yIOrYvxyszFXvcwkFGYuYVBctzUJq/nEQCCRGphybA0paDQkrgRd+NB0TtljhOkPehE
	m5Xl7QQrOdSxSvaFjA1ePsOfsP4ZaccvD3tJ4WLXi4yuyl7kbg9JrDLO13URFhvZ312XsjrpJ1l
	MbprNNYFBSQAl//qOotc4EykwewvnmoWIMlqHAI1kHoA5q5zmvpYt2/zMo2slrCsr6dPhWLcb7C
	uQSHdKOdOcmbz
X-Google-Smtp-Source: AGHT+IEVaptM4qGrZCEQ0mrpIX9BWZ9v5bJXKqGZDzSaNDTnshPS1NrrfjUBGZzefc011ClT6EG6Bg==
X-Received: by 2002:a17:903:4404:b0:234:f4a3:f737 with SMTP id d9443c01a7336-235395bff87mr50633305ad.34.1748628863927;
        Fri, 30 May 2025 11:14:23 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-23506bc85fcsm31363575ad.38.2025.05.30.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 11:14:23 -0700 (PDT)
Date: Fri, 30 May 2025 11:14:21 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
Message-ID: <aDn1fV8D2G90mztp@mini-arch>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>

On 05/30, Pavel Begunkov wrote:
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an skb from an queue queue.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/sock.h |  4 ++++
>  net/socket.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 92e7c1aae3cc..b0493e82b6e3 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>  			     struct sk_buff *skb);
>  
> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk);
> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +			  struct timespec64 *ts);
> +
>  static inline void
>  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
>  {
> diff --git a/net/socket.c b/net/socket.c
> index 9a0e720f0859..d1dc8ab28e46 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>  		 sizeof(ts_pktinfo), &ts_pktinfo);
>  }
>  
> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
> +{
> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
> +
> +	if (serr->ee.ee_errno != ENOMSG ||
> +	   serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING)
> +		return false;
> +
> +	/* software time stamp available and wanted */
> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
> +		return true;
> +	/* hardware time stamps available and wanted */
> +	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> +		skb_hwtstamps(skb)->hwtstamp;
> +}
> +
> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +			  struct timespec64 *ts)
> +{
> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> +	bool false_tstamp = false;
> +	ktime_t hwtstamp;
> +	int if_index = 0;
> +

[..]

> +	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
> +		__net_timestamp(skb);
> +		false_tstamp = true;
> +	}

The place it was copy-pasted from (__sock_recv_timestamp) has a comment
about a race between packet rx and enabling the timestamp. Does the same
race happen here? Worth keeping the comment?

