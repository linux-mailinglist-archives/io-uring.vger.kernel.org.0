Return-Path: <io-uring+bounces-8327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC246AD7D52
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 23:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C9673B2DB2
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 21:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013622D8DD6;
	Thu, 12 Jun 2025 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YCVKTu8Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F32D877F;
	Thu, 12 Jun 2025 21:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763204; cv=none; b=tunS05YuBEmx45xr4Iab50lgzKD5DIw+jMlY6skKUCxfGGnXWY2qdCUz8X8x7BIhFhp9tiWNS3ttxZM0O1rl5/obxcJCAYsD6YAAaup4WVhJbDi0DTBviSgHntdya7E7givMliGLn4sEK+akv23x1RnRdgNCDc36Jld/txx8lw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763204; c=relaxed/simple;
	bh=vBM+yt3S+gclV/GEltjjt4UsjzxHRvzGZ4Ps5T1FeE4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=qhMA9GnvsFr8yl49meZgVMr1z/oB8T975MzmdmOVA4dYMDGi4hliWZL+jfib0qnSL9/7vVAjyucJtMK4PgXn4vO6eN9H5dE/ANEOSXU5cySG0QFZ4kmMBYWWUnAMrtnrmyT3oY5GuuyIpzbH28iABhZDq0CtPq6lSL5hE50mSGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YCVKTu8Q; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-70e1d8c2dc2so12982067b3.3;
        Thu, 12 Jun 2025 14:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749763202; x=1750368002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r79AE+VxhhVyrHIKJFGwjuZXdM2MCbvI4n+WlYE2tI4=;
        b=YCVKTu8QIAhmH3IDQdUnIv/pBc98gFrSTH3gB2HOvwd8YYR804HgXVVavSX/g9SOyU
         F0sj5z7ZUcv8KI3x3sTnBbYv+bncnkjqNMp5RTH96FslTtaWmGNQf6w4L0gDD5H1/0nb
         rco3Rnmk8+pBzZKqAU/fn+QMdqQE+1GJCm9ysx5FLKqwSZBKIVm4Y4RgyjpK+jqAS+GP
         RYnTEpF5hvCoAeXyPe1MScAlqZReOf22DT4H+hr2QlnG5lmT4rDwQ5wcd59JWICERqDC
         AeuPWsB3Cz2PAoLlOOT7dnGGOFzMSTErF8i2ilbmYQQcszdJ+m/stoPH5edQIOI/+Bte
         l54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749763202; x=1750368002;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r79AE+VxhhVyrHIKJFGwjuZXdM2MCbvI4n+WlYE2tI4=;
        b=w1K2fvCSifo621aLE9EkXVMdjNLz/qXwsGJKGuqjAQUMl02k3ormblNto/j74RokTq
         hWcLnkT2/cgWFDh8s+0y6UMjYiIZ1gcAGDQKH2PC3+khELaERlOewUCUQCQXxQOhoqXk
         /Oo3E8HmY5I0iB+G23JveIefuJLUCeqK2IgjPtFUpFZczR3aj8v5yL+ctyEk1AbU8lCm
         xviUF1YsX2lj1ZIonKciGmsZwUyseGU9XLVaCGdq37zP9Q1/KUZHcfSMSclm45SSFiEi
         EQiF2u2qMg4D1Ice13DbyT4/KGmTLqbddJ2NnquQd79n/bwa6vzkeQT0H1ZtH9B5T6v7
         JOxg==
X-Forwarded-Encrypted: i=1; AJvYcCUmjqWFPjmvTDK6kmgUtIxO3jsssc4ybNxybngkgMFGYjkoxFrfZpCRF1Rnr7XrymYqFvzeGyul@vger.kernel.org, AJvYcCWAOjTWfH6SiGpl0e6In8rCIztKSbr+rHQj+D+vGW+FhWyMH5ghVnOV20jlMiV2rHwxdMI77XhIzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCkWhe0PoG/T0zowh9X1xospAFF+AhD9wKskN/EzZV6yHD44nv
	tKEhXE1OFOOkuL7ApHKLkeGVALU1AHcUKkQDnsysI/e8YxvhDgcOm95K
X-Gm-Gg: ASbGncskg4UaZA3ix8AIcGYtgo6pWaCkZ+dvVjvBV2AYMfDkNUb/PPMJwcnLOr4Ftt7
	8GJbsnT6vIqMtTmOk7goMngN82Fas5a/ltZb7KBGu+uX52R7ghJTJhxDmmkN2JYsgdnbV6i0DoM
	6TPBx9lRgl6oD4gsmyOmvIH/XMsMx/l2BfGoBWKQGbnZL/BRD71e/DuDeHHInV0kNtY3p4psET0
	lut9oWQugtw/j+0pd4lpHtMbQdtEKoORUWsuyxRPPqXlf9TCa/ai6BypZJ8nsuncm9D15xGO4/e
	rVQG1ZSxzklsHI+PgGvBXb67JF0ACmMNmrmPKjH8jg7NQcqLdKT7j7bTfrKDyBi0osh8dTOTlly
	sY+1RqeVp24fuyeD6AtEUFa66oaFiXrxOxzYbla6HIQ==
X-Google-Smtp-Source: AGHT+IHfvv6KUafP82HhJUfDL28RgcspCciXL+F0oqFILP3Ls8eCJTsnCPXDpaKVNDRiZKCliRbCXQ==
X-Received: by 2002:a05:690c:ed4:b0:70e:2d17:84b5 with SMTP id 00721157ae682-711633b62a0mr15413427b3.0.1749763202161;
        Thu, 12 Jun 2025 14:20:02 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-71152059b5esm4185777b3.8.2025.06.12.14.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 14:20:01 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:20:00 -0400
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
Message-ID: <684b4480e230f_cb279294e8@willemb.c.googlers.com.notmuch>
In-Reply-To: <1c21f70cd46cbac49fe5e121014bc72393135c81.1749657325.git.asml.silence@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
 <1c21f70cd46cbac49fe5e121014bc72393135c81.1749657325.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 1/5] net: timestamp: add helper returning skb's tx
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
> associated with an skb from an queue queue.

(minor) repeated queue
 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/sock.h |  9 +++++++++
>  net/socket.c       | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
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
> +
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
> +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +			 struct timespec64 *ts);
> +
>  static inline void
>  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
>  {
> diff --git a/net/socket.c b/net/socket.c
> index 9a0e720f0859..9bb618c32d65 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -843,6 +843,51 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
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

(minor) consider an empty line between the branch and final return stmt.
> +	return NET_TIMESTAMP_ORIGIN_HW;
> +}
> +
>  /*
>   * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
>   */
> -- 
> 2.49.0
> 



