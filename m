Return-Path: <io-uring+bounces-8375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 880F3ADB743
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 18:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4DD47A1E3F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A422877F3;
	Mon, 16 Jun 2025 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gsKat6yq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0782868B3;
	Mon, 16 Jun 2025 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750092231; cv=none; b=VZT069Dk5cGg+feljKDFA3ZjcIJHoZ/iPFj4F8juw23ZDiCEkFuoXn5fYtUkwg9Byo9kS8lAQu+oaq0sAxz24WRGhd2kL1Mjv5R3/CP5IsrbAK0zybcZGxvS4q58ESOIayCUpGXfXVOgkY4Vu77rPNw281QcwLfZnULWoXRXXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750092231; c=relaxed/simple;
	bh=GToAKMJOAzgaPnwur4vcXJJz5zZVnXepZMpNIkxPKEY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=LL4M1cD5oq2wtayvdgcYtFQlGg0bKt/b7BWzTPyX8jRRgzmd/86s6ZghWsw2T4UCY6XJIS+u+LnOssBM6N1M3mYmsh7ixHXP+oTKVnFDPj5eSALEZZonHpktpnG65AOgiim7Qf3iKxxlO4lw3pKhBZtq4WTfFgjJf1oHr0v1sDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gsKat6yq; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70b4e497d96so42625607b3.2;
        Mon, 16 Jun 2025 09:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750092229; x=1750697029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zLCRVz2k1at0n1nr33b0V9j3klWouJOz2HIaXuHS5yk=;
        b=gsKat6yqTPsW9yeMqwG3bF8XcpFekzlrGdOx/Em3ZOnuVvFanDy9nRzCss1OeF86jO
         t5jIhCOSHx3t2VV0aNrcxf24+ZPthNfUE2f013e4EWdiCQCNirDVrkbBg++NSZh1jbZU
         qdFJbBrjgEQD6cpPsyXTGj5w7TUoEDd7Kp9igtlc5c8IsJgsaKzblEcEjcbDjjhapooZ
         vPFE0YbBYA92TLO0ZV3TIK5IHTvoldt8wgH6l6GzNGxwFykHn7r5iqik8JqoHWwYxtLb
         5X/l2mOYB0TgmIQPTydoeeUo8q8SXP4SPZwiJC+XrbGXv1uNrjG1bEFFNgZrxWKfx9l1
         hcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750092229; x=1750697029;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zLCRVz2k1at0n1nr33b0V9j3klWouJOz2HIaXuHS5yk=;
        b=Zbdxnr1wYnmxPoOWckcsSuWlh2ufgVuOBiRJrz0dSfUZLm5YmeZ49kvte049o9yT/P
         e+UJn6RlqY3/pjOIM6TLyQceyvIEYIAshJYKog3G0eee95JyCCNw6Wedx0YPw+lM6Isq
         RyjuLLloKBcGqHk6dZJaOapta2U3u1YXe6lX8QIt+kknpf8BdAz8XWaYZbZ9PTjC+ZGZ
         u9uJTc1axITB+u/3bD0I21PwL6pZlwbwa6xSRRudibsiFAhEEzyz2ojNjZZd9jCTEH91
         MVCp5J1HoyGwfNnoM4w365l+PNGEFkMsBUiFhBnFvx2yXdnwsTWnStqhr7ZxlKdUBUFf
         zlpA==
X-Forwarded-Encrypted: i=1; AJvYcCWKqP0pw7hY3Gp33OaQFkRBM0vSwzNnYLrrqDCDjUCsUzKkET6ttF9HVhjbo/6kh7HDj4+hrIxvvw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0+bNkWoiKtzlyzzwcGtKDaLEXHcrQkKuRWoW+2rA5FDyQWojJ
	Psnybh8UvmL1ljawZq3qVyLDSqKC35izpWRAVE5MfS0wMEmmYm43NffT
X-Gm-Gg: ASbGnctDbUQ4H2h9SirLcW37vJi6luLRqR6S1OFlqn755suTPFn9o47VVJhUFaOyrDq
	mxpif3pb9XyycrVuFoJvTLVCoBGNDcpd05sGwUFmxydQajk9m3mYpGaKoRI+gQoBf43+548LGPR
	dFOH5iw1/E6oqXk9n1IpmtPce9mxwftvnfBbn86zXorrM+OzUQWsHRGZszDQONsYdUvsftgVrAq
	0dAurmg0cqUFqM/csXRaSNYauZ6lfzFYsggTJVKedGNxAQaVlM0eYz7omDWW+lQQX964IRhXCyY
	klZ5Oik1tBxJ3eH0Cbi0koqXDXYdeb/WHQgd2PTXvJOFp+DNzkstfYQdZNJj8ilGwL/8ABasnGU
	YE90N3sP/VFLXXpvK8bNOZwSDDNQJYI88cr3gqlQz/w==
X-Google-Smtp-Source: AGHT+IEe2ShsQXChv0t1KlspZ6IbgyUhhI5A4khvWSqPzGJvZ0uxWm69ALzGppn56dPOERUY5UbwwQ==
X-Received: by 2002:a05:690c:89:b0:70d:ed5d:b4cd with SMTP id 00721157ae682-71175457355mr132435637b3.17.1750092228534;
        Mon, 16 Jun 2025 09:43:48 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-71194917307sm4336667b3.20.2025.06.16.09.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 09:43:47 -0700 (PDT)
Date: Mon, 16 Jun 2025 12:43:47 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 Jason Xing <kerneljasonxing@gmail.com>
Message-ID: <685049c36304b_2150e229495@willemb.c.googlers.com.notmuch>
In-Reply-To: <65907669-80cb-4c79-9979-4bd2c159c0ed@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
 <685031d760515_20ce862942c@willemb.c.googlers.com.notmuch>
 <65907669-80cb-4c79-9979-4bd2c159c0ed@gmail.com>
Subject: Re: [PATCH v5 1/5] net: timestamp: add helper returning skb's tx
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
> On 6/16/25 16:01, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> >> associated with an error queue skb.
> >>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> ---
> >>   include/net/sock.h |  4 ++++
> >>   net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 50 insertions(+)
> >>
> >> diff --git a/include/net/sock.h b/include/net/sock.h
> >> index 92e7c1aae3cc..f5f5a9ad290b 100644
> >> --- a/include/net/sock.h
> >> +++ b/include/net/sock.h
> >> @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >>   void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
> >>   			     struct sk_buff *skb);
> >>   
> >> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
> >> +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> >> +			 struct timespec64 *ts);
> >> +
> >>   static inline void
> >>   sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
> >>   {
> >> diff --git a/net/socket.c b/net/socket.c
> >> index 9a0e720f0859..2cab805943c0 100644
> >> --- a/net/socket.c
> >> +++ b/net/socket.c
> >> @@ -843,6 +843,52 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> >>   		 sizeof(ts_pktinfo), &ts_pktinfo);
> >>   }
> >>   
> >> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
> >> +{
> > 
> > I forgot to ask earlier, and not a reason for a respin.
> > 
> > Is the only reason that skb is not const here skb_hwtstamps?
> 
> Yes, and also get_timestamp() for skb_get_tx_timestamp(). It's easy to patch,
> but I was hoping we can merge it through the io_uring tree without deps on
> net-next and add const to the new helpers after. It's definitely less trouble
> than orchestrating a separate branch otherwise.

Makes sense.

> FWIW, it'd be fine to add
> const to the existing helpers in the meantime as long as the new functions
> stay non-const for now. Hope that works

Yeah, agreed no need to add such dependencies.

> -- 
> Pavel Begunkov
> 



