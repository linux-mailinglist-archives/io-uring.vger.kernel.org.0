Return-Path: <io-uring+bounces-8176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1B5AC9EB5
	for <lists+io-uring@lfdr.de>; Sun,  1 Jun 2025 15:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3ED817A8DD7
	for <lists+io-uring@lfdr.de>; Sun,  1 Jun 2025 13:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828641CCEE0;
	Sun,  1 Jun 2025 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWggFao+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B1E1D52B;
	Sun,  1 Jun 2025 13:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748785981; cv=none; b=PZezIiJVNg03UYRBHBBDv/n828SiMTJoeQ1bkpF6JzWwFR4/dlQdDF6+yJwzIjI4KZ8o0LRDNlp1ibfeAbGjWrifC9rI5LFypeoUuFS2tprXhYJKdtR98/IFnlBINUwzk3bUxI6o4crkEn/V9pohGapI3rlpRn8DpkmCBt/RINw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748785981; c=relaxed/simple;
	bh=iP62HxF1OBfqrYDiJZAEO3adabeM0qKQc/0NyPuejbw=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=b03v65yjoe4OWsTH+E2e8ph/HC+69DXy0off9yxFv+JAooVkXMt4Ra16c1ljU9HinaLA6kydBrYynhH0SChUixi4Krqm2hXdKRQnv+KA5y8p0V75Ur0pu+qyfu7m10Owes44wex3fWXDCgcKHb/L5eBQrdKNd7A39/vOW32Zxgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWggFao+; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7cadd46ea9aso460700485a.1;
        Sun, 01 Jun 2025 06:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748785979; x=1749390779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExwY2BOnIkzoQ6UjXWgIayO0FoXfx4RufFm+NTf1Vhg=;
        b=gWggFao+I1pzpnB5120EJDkHdUlvCGh9+z/ksc5YPbt9Y5B+w/uht0YY036QBzgXs4
         I9W6ERz2l4ti6ySC0xkdxjyI42apmSY6wvhMuaRHgZaew7TxxRWn+Tt1Viep/foAaFRO
         +JnAKXSUExcj7eh+1u8RGs/k4NkUoR979ewtp135esnwlmjoPgZpuBNfXkA4W5xWCjjC
         ss8oWGdg+WnXCBh75knV0WYEF6FLyC4gSZQry4UAV71eeW/swwfdUyA7s4hyQpK7T2nP
         r7piGpNAf496WyYUOTA1dBfDe3pd/7k79/uKLOt+gs/3JqZpyrNau0Mb9ZJKBtzvBX64
         H92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748785979; x=1749390779;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ExwY2BOnIkzoQ6UjXWgIayO0FoXfx4RufFm+NTf1Vhg=;
        b=RnoMjUYZAgTfslKCL/b3rzVrPExBuoaPQ0eLaB5v3ivNkDT+mjvuASeTGF0thFBqtJ
         61sLFwqibZXgMKWb1KAhcIdKrKu3Xxo0UVzwjyZoleh2rQaK3fel4InZHHwj1C1fku0N
         7MqzeNy7UQ76Tn8/9Vfs50AqdiRofFpSsvYfveT9JCvsb8tseOvTzW6B21WJF/LkNhxO
         5Vw37MBTp8jo+oLlAand7wvxb94ojRFxL4xJSH9iLViDQLSQsjlvSi5E9uwH3C7TnSpO
         AlQiYxSGD4Popm9ZmZ2KoEyZ2fFz5YkkVBVJwPXOCHPBvX0R7eigeFIiDqA+9CbGgGSC
         QhQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKaj+bgE1Qs34qUt/7vyNlLPxt1hkSsIs9P0S0ldGyUfJ9ouhc2aDD/qF/eUTMWJbzivlgxbes@vger.kernel.org, AJvYcCWJTR30Ws9D/2Fm9CJrwKh4/BGuxqzJx9biiGXlmHyXMZ/X3w51evieKKYdshyZRvJp963RoWWs1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGMwk9r178xSbSi5vEekJaqfGYTbafZby3mzFIuL9U3CPMek8Y
	mIBq5b77DrZdm0KwwidezifwOzy7Y55m4TYityAAPDDkD7cmDofz9Tyb
X-Gm-Gg: ASbGncsgGAOH6Q/7ByXe96o4XvlJweoqkzcskaulJIAW9OSw2aKh7zI9XvSequ1d4KW
	qK+9eMtfr9R16Zo6uEWlluEGt68J5wXcoWa25bhyEVPmIl8eCzTGtBroXdCDoT3o4KeH+EbLlfY
	1WZPvPrVCtZY3dqBk67mmOgrp2BY40kKCyZcHCXe9rrP/QcxhlqarbWU0KzjhHTzVUKqN/9mdIF
	1yMSP8BjvZuNOixnaNj2O0Kpm9IgrYRtLamR1mhYj/069gtOW1JIG5JFynl0VNdlMONLVE+rGkI
	vXmRcFImxkcGH+0j7MGwGqd7m/BLA+bbAcbnjq0WL9MWSfugp5hCGPjDiJeMgs4pF4FPZu1mh9Y
	H89GAoIz0iRnEIGoLTBD8kgY=
X-Google-Smtp-Source: AGHT+IE1I6nGNWD14xlj1pDVX98xOMgysu86iGfND4x0oZSiUSjWza6ldVSEElDGQmVMbdWTq6icaQ==
X-Received: by 2002:a05:620a:4108:b0:7c5:562d:ccfa with SMTP id af79cd13be357-7d0a4c43e06mr1601774885a.36.1748785978558;
        Sun, 01 Jun 2025 06:52:58 -0700 (PDT)
Received: from localhost (23.67.48.34.bc.googleusercontent.com. [34.48.67.23])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7d09a1a70dfsm492806285a.93.2025.06.01.06.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jun 2025 06:52:57 -0700 (PDT)
Date: Sun, 01 Jun 2025 09:52:56 -0400
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
 Richard Cochran <richardcochran@gmail.com>
Message-ID: <683c5b38ed614_232d4429431@willemb.c.googlers.com.notmuch>
In-Reply-To: <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
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
> associated with an skb from an queue queue.

Just curious: why a timestamp specific operation, rather than a
general error queue report?
 
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

Here and elsewhere: consider const pointers where possible

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
> +	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
> +		__net_timestamp(skb);
> +		false_tstamp = true;
> +	}

This is for SO_TIMESTAMP, not SO_TIMESTAMPING, and intended in the
receive path only, where net_enable_timestamp may be too late for
initial packets.

> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
> +	    ktime_to_timespec64_cond(skb->tstamp, ts))
> +		return true;
> +
> +	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
> +	    skb_is_swtx_tstamp(skb, false_tstamp))
> +		return false;
> +
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
> +		hwtstamp = get_timestamp(sk, skb, &if_index);
> +	else
> +		hwtstamp = skb_hwtstamps(skb)->hwtstamp;
> +
> +	if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
> +		hwtstamp = ptp_convert_timestamp(&hwtstamp,
> +						READ_ONCE(sk->sk_bind_phc));
> +	return ktime_to_timespec64_cond(hwtstamp, ts);

This duplicates code in __sock_recv_timestamp. Perhaps worth a helper.

> +}
> +
>  /*
>   * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
>   */
> -- 
> 2.49.0
> 



