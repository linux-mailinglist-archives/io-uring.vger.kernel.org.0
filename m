Return-Path: <io-uring+bounces-8352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41571ADA65D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 04:32:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56F643A64A8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 02:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B1813BC0C;
	Mon, 16 Jun 2025 02:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUg3panp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F391BF58;
	Mon, 16 Jun 2025 02:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750041117; cv=none; b=tTzjNlQY2IVjuQLNzlO+uZvDEMhgQFaWrkB5304NSCIWp4/GAInlBQamiSbK0D6L41epmw4M8G0AVRy3im5+QRiNMU64ENKPU4M5vpyMR6lcagRL7GeEFSiLcsavAw6h3LtbMyvUacyGWrhmJ+hOzrlTAacDlQQNP5NFs6Xht+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750041117; c=relaxed/simple;
	bh=gBw78E6LJ5OS5FjHmXjUBbePI5lWrCM8M+GWNmJQaKE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=Qyg39IPnyRVpzS+yY9BgGgKwLh4L9uiWNghJ1zaBH1LOP3hDst/A1jujWttPLNuoIKSpyhUJuHHfaIaO3/0aDfkvQNVxBzk5XXw89IbzRd1U5fL4tTiIQIhxhvScqi1Sn5wvJu/TsLxvu6yayS1WLTkm4v5AM7qYqMV16ANekPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUg3panp; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-70e4b1acf41so29489547b3.3;
        Sun, 15 Jun 2025 19:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750041114; x=1750645914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b11xe8EtGdLnjAJAgXjDQeEuYfKzv8tn065HnFauzTs=;
        b=NUg3panptms616BEkG9GvtIXIA2B4vvU6hFMCuGpUYH45lVb4qqyS5tumIVQiL6LlI
         tQNfSVThgxcLXRdfvAoYdd8UluGYn2VxTw+8q1tV7mIaiq0NPdhCe7O+aBbE4ABSoS6P
         74y9ZQYkSU/N32s7dwa3laolIPaC6NxvjPWLG95SVMO4pvkybDuoJH9ygq0UhzDOHmNP
         fKUSJzHsHzptcfjgATB2Dwsw0RI54zNlhGsAQSJfC/EV1DQoPIY3JyG0rLQ2dzQhQvuf
         gtvq8qgyH4xLfPw9Zo9/Upu5ScTK3YosdKZgRTkYcW0iXYSPYSODdDNhlx/JHcEcvjzp
         GHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750041114; x=1750645914;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b11xe8EtGdLnjAJAgXjDQeEuYfKzv8tn065HnFauzTs=;
        b=w+2CD6uoy6TFQvJ5R9O+iMbg+cDIt6Bw5LE7FSio4IjDwD6oeDcsafEw9QdU7uB5BX
         EGGIIX/mPBDhh4RQiMvpaDVp1VaHEaghAXItxZalNwQ4Q8DgzLKpyuBtwb+aRRY9v+8N
         13nW0sDPmnd487nXbSzI3GYFuZsufI08zKRk4H+o1bRV0meGR6Ibeg1cH9XAiRe7Li4K
         TsDDcJ3/R/S+ZorE5453LGXbfMBUV9IoclaoQv4FYLwwITrGq0uybWN0GuWHOuFi+zHi
         PBaFiffgY97NaZV1xGM3WI16+n8IMs8bmabecJRrMad7dwGi0soqkQenrNgAlwWFACUQ
         ygHw==
X-Forwarded-Encrypted: i=1; AJvYcCW7oEeouyJtiZkCkTUEYX6O011KDElgMHecZzVou317Tjsp1CH+APzh2/t4U+EMqudfJFvdovou@vger.kernel.org, AJvYcCWJayAWs/q7iPadxH/D67R9kJryAAwMnqOP1a/p3Byyji9nC5ZluwqieFRM/2QWsnoV3EU1KRpCsw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzytX8TgHjyxpnyctE9RPYdi/dvRxpMG5NfV4NJabGOZs0UObZB
	HyyBnAslhs5HcStjv63ChuWhlOQ9J0O6zxOsDdRhmi1TzxqwMbVAhKwi
X-Gm-Gg: ASbGncsFLk/Q5+HibTCTv/N7GVe9RR9BLg2qT0s16IOBzav/YV2nC+XfbHHGGJO7g3t
	skXrLM3LWlhzEA+WCg3xrNkZzoimoCla7B4Klr7l2feAianWrQWDbbNaLBf1zAvK5oK3orvO8Bm
	7Y+RfgfdKWGasRZZMHllQgcmBn1MMZlcX9D7+JopWvPMpUEF4Jw2xHqVPZLbtAxuP/HXNKcVAPh
	/6Fm9jRNay9eu0JMlUcBV9yPqRJGa1+XVx5td8uOSJFFJ2CcipdMVBZqiuQC1wLtGbKIsELL3qc
	sbF6bXXHnwXJpZ10QYXiAt8EIygwClxthk5q0MLjdmnpq32/6gOOpHsegwQzaD6VDtAv8P0gWFz
	cXVSMr/Jz2Yqz9fvDWpGy01YX5tC6WuNWwE5R7IFIR+F6W2IRC9v3
X-Google-Smtp-Source: AGHT+IHQZ1xwoH/TiZcMdzsAkWmj9/O+AgE8/xmY1gxYPlxHRTnwW02nUhMvEBeQ+EMNy6MMf9Oh7Q==
X-Received: by 2002:a05:690c:23c2:b0:70e:2cfb:1848 with SMTP id 00721157ae682-7117552e9a9mr108633357b3.31.1750041114214;
        Sun, 15 Jun 2025 19:31:54 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-71199078e21sm333767b3.14.2025.06.15.19.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jun 2025 19:31:53 -0700 (PDT)
Date: Sun, 15 Jun 2025 22:31:52 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com, 
 netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 Jason Xing <kerneljasonxing@gmail.com>
Message-ID: <684f8218f2e39_1e2690294dd@willemb.c.googlers.com.notmuch>
In-Reply-To: <766c5e599bc94296fe58087e4c30226260cddff8.1749839083.git.asml.silence@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
 <766c5e599bc94296fe58087e4c30226260cddff8.1749839083.git.asml.silence@gmail.com>
Subject: Re: [PATCH v4 1/5] net: timestamp: add helper returning skb's tx
 tstamp
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
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an error queue skb.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/sock.h |  9 +++++++++
>  net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 92e7c1aae3cc..0b96196d8a34 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2677,6 +2677,15 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>  			     struct sk_buff *skb);
>  
> +enum {
> +	NET_TIMESTAMP_ORIGIN_SW		= 0,
> +	NET_TIMESTAMP_ORIGIN_HW		= 1,
> +};

Can you avoid introducing a new enum, and instead just return
SOF_TIMESTAMPING_TX_HARDWARE (1) or SOF_TIMESTAMPING_TX_SOFTWARE (2)?

> +
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
> +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +			 struct timespec64 *ts);
> +
>  static inline void
>  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
>  {
> diff --git a/net/socket.c b/net/socket.c
> index 9a0e720f0859..eefbd730a9a2 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -843,6 +843,52 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>  		 sizeof(ts_pktinfo), &ts_pktinfo);
>  }
>  
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
> +{
> +	const struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
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
> +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +			  struct timespec64 *ts)
> +{
> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> +	ktime_t hwtstamp;
> +	int if_index = 0;
> +
> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
> +	    ktime_to_timespec64_cond(skb->tstamp, ts))
> +		return NET_TIMESTAMP_ORIGIN_SW;
> +
> +	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
> +	    skb_is_swtx_tstamp(skb, false))
> +		return -ENOENT;
> +
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
> +		hwtstamp = get_timestamp(sk, skb, &if_index);
> +	else
> +		hwtstamp = skb_hwtstamps(skb)->hwtstamp;
> +
> +	if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
> +		hwtstamp = ptp_convert_timestamp(&hwtstamp,
> +						READ_ONCE(sk->sk_bind_phc));
> +	if (!ktime_to_timespec64_cond(hwtstamp, ts))
> +		return -ENOENT;
> +
> +	return NET_TIMESTAMP_ORIGIN_HW;
> +}
> +
>  /*
>   * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
>   */
> -- 
> 2.49.0
> 



