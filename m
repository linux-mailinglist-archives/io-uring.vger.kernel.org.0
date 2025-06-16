Return-Path: <io-uring+bounces-8367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46DBEADB4C9
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 17:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B73943A255A
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 15:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD601DFD9A;
	Mon, 16 Jun 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+4kY974"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220281A0BFD;
	Mon, 16 Jun 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750086107; cv=none; b=RPlnQTHvXHfgaiDt+LV+Kby2Hs8n4EP8fhwUQjs6nsuG8+NYDtn/P/u+Orw3ad3/BS1F1JvhCCSb8+8ZVXHH/DwQkP0c6qlKN1IcctBVIgCplk6pZjbgd8JqH+01uoHsVXNExosgXfHrfmY04wbDhRmtQXGzTU74jvhyTn3uqMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750086107; c=relaxed/simple;
	bh=i6YvQtU/tWIASFNM6X7g/OTm6u/gt9EmxowF7U3pNSQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=id5fUES5zfF3BcuDj+MMZ9daW2w4cD3jTeIEDXefEfK5fT/es5TONJVxkrKxm9EjTFEF0xo8043kcKHZ9ExnBnDu3rjYEbvXug2uWZ3ZRLnf/9cpyFl7u1zKMS9j3NgeMHWM7/XrJNOvM/WXXCVzaXAfEmP4IbpsZfEiMCnKtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+4kY974; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e73e9e18556so4299398276.0;
        Mon, 16 Jun 2025 08:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750086105; x=1750690905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkSx/y/oYBnGFADISKuFd5WOPxZYlp+yK0NOedUp3Pc=;
        b=O+4kY974gfbpTqB6g8rpOhHyRYJsBw5cIJL1DS9udbdcGn51/pG0y+oorpeBwvYODp
         U7GwucShuFlpYIcX1fUPxv0nRA7VQu6TRyY6e4wmMOlcxWsjNon1BR/qyfdV1r4bxwDn
         //2A6jJFbenURVcIdVTzXF7BDaGKn4lYumom4KojYeC2ZZ8vOk2OC18f5X6nNPEDSeFC
         dFUwgzVQO74Ds4gJ52J6fE8k2VkvvAh5D/qspVYCswy7kcfYSJh2PXdNkf8xbWlwMwke
         fOlWtlmMuFeKt83AOiBUrmZW0RH3FiB2ZMOKX287ZQ6yepVwh3MdD85IIMt3QTcsfaAR
         5SBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750086105; x=1750690905;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rkSx/y/oYBnGFADISKuFd5WOPxZYlp+yK0NOedUp3Pc=;
        b=ricXUjq4ErvkeroAgqBmAZqJhVzf66XVmkvX3Wvy91JEDQ+YIS6zvNhFvxQb1RHzXX
         PY+/hEmgEHNkHzngqYz9DL0Mzkqw6kNZgAqDAzKvAVScL5tpsdc2GFh/h6W/APQj8yCu
         ItBYkmCY78JDVLNtmFRwiDzWS9uI1SoBGTdRPtdTvFpqyTxFIh6qwuyh2jboM27/vPlB
         QK8rRi3QtX/qu17ie7ZtlLEdrfcxVFzQXBuPweSre05MoqVlhWWBq9vf73O2bJRyC9Tu
         ++XelO9kdYbCBz6mcJWcnYKT45tAAIRz2nOcqAYYf2hE0y8ahTeFy4+90g7Zbf9SJAfn
         FW+g==
X-Forwarded-Encrypted: i=1; AJvYcCWSmOjMbsSoIlAxa0wOB6yuGBxAQDYEEq+Qidm7AnhZfEbNX3IUmkx/Ep1dFO3S/lmD1tx0zeqI@vger.kernel.org, AJvYcCXklqv/ML4OAuY0/v+9ymYKGNET8nTbV4Z7/klbf7fZRc9455BdOMK/yjkioRUmQkk7MwJpVDXmcA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Ocl0TKuEUbSb1yqatwPh91j2y8ta7cOzvrXQkMsCbs0yAgLJ
	KXUQYh7qySKH7NWAVqpw7Rkng8Q4CiGuXlmFetQMVWVweTmg9ttekPKv
X-Gm-Gg: ASbGncsBQFevqlO0XyeiEkrzFe2VX08sUwivzyqsXgn23CTJPp0XZK8cOTQRBaNhptk
	WwUh7MkCymuyPTJWy3qsINv/bz1ZNZ//8JwuRM3gpJqDl3X8nYor3Rb6oeuSokbPdfhmCnz9SYC
	MDsnGLpoA6WJZWqDla24DM+BWVERJmLUO3MxCaOfS7YyS1esHgOhXo9M3d1PVfQwhJMEBKMx4ic
	S/YMWSgZ2qLIctkPleM5LUa6+KuNX4vtK7uIivDe7Pyp93FD6N5kbuR6JnIydoG/Ovrw8/ajAh5
	QrJFuEa9Br01BboRE3jpk8Cq9w1VapGWaHLQwU0qizF05k4HijEdnVD47xfPGYlM+W/3mR77Ax9
	UB0VzN76z9IITuFtnH+YTwUzAb9r+MGZsZwhjhArClg==
X-Google-Smtp-Source: AGHT+IG4RP3kV3UfEIwFWfBLR5no3xQgQjMlr9FEWD4z2eTavLrYYWqE8+zijnjVQQz6dohpxUV+tQ==
X-Received: by 2002:a05:6902:1542:b0:e82:64c2:bf6d with SMTP id 3f1490d57ef6-e8264c2c01bmr722402276.22.1750086104187;
        Mon, 16 Jun 2025 08:01:44 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 3f1490d57ef6-e820e09d3ffsm2971521276.23.2025.06.16.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 08:01:43 -0700 (PDT)
Date: Mon, 16 Jun 2025 11:01:43 -0400
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
Message-ID: <685031d760515_20ce862942c@willemb.c.googlers.com.notmuch>
In-Reply-To: <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
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
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an error queue skb.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/sock.h |  4 ++++
>  net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 92e7c1aae3cc..f5f5a9ad290b 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>  			     struct sk_buff *skb);
>  
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
> +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> +			 struct timespec64 *ts);
> +
>  static inline void
>  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
>  {
> diff --git a/net/socket.c b/net/socket.c
> index 9a0e720f0859..2cab805943c0 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -843,6 +843,52 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>  		 sizeof(ts_pktinfo), &ts_pktinfo);
>  }
>  
> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
> +{

I forgot to ask earlier, and not a reason for a respin.

Is the only reason that skb is not const here skb_hwtstamps?

I can send a patch to make that container_of_const

