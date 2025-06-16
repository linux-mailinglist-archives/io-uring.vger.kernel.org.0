Return-Path: <io-uring+bounces-8366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E77EADB4AC
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB6D83B14F8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 14:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1239721A928;
	Mon, 16 Jun 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ag4JA8mP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAB20FAA4;
	Mon, 16 Jun 2025 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085896; cv=none; b=SGpqI5VRIBQ47I/rMvxjFCqjmE3yI84BLGV7zUTupHI0c/UjPs95pr7oGVbkOSYdDiSY/dwcbOX+R+3LQSx8InWis1BSUvqxmDWnOMA6puK+QFI4AqVjc+Q4K7VRqjvHyPbCkLD7nibA3M8a73+ry+ZGhz2zaawsvWFRaAix10Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085896; c=relaxed/simple;
	bh=YgF8FWWcAL3UKZ+RTPJFUS7+G0j3bDTqrYwd16DZsEo=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=rqVd1+4TSxqYNEHP/I28T6hRQu7B4cYo/nue8kRPPah2eJ8xCb2vIeTUVJ5jPford+o67uuY/o18jDpGh0HborpusiJg7bxLBBn/TsuWIoo2oIzcVvba4A9eiM7EXmW0m0odiaQIkisuuMYhqd2mxQ1/zudXL4Ew6r7vslbtScc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ag4JA8mP; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-711756ae8c9so19913547b3.3;
        Mon, 16 Jun 2025 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750085894; x=1750690694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mthsLnsT+CmR/hCYL4lW5xo1Ic/pHf8tPVpsM8iPfCk=;
        b=ag4JA8mPnISbL9DEtZTNJKBW4QCsChAMILNJ+TP3183HFbJiqx2abzZsj9OCPANNzg
         +iQk2jvJbenrv2SzMe9y9PbmF2YOOxDjkZp+eKqAkSThKrjCpreeVcBaQBf+BUuI2Nwp
         Ii8jyzMRVvVpPXK4yeuAxnAeqgtXVW1BFxmuuT2VP+/LPKORmX6J0d6IRCJgiwv8oj+R
         Xp3v9gKhhFJ2Nygro0DHknhrH9SkCgobGOpl1HV1itiD4oBjIe3aCuzZPvgVeEOHW/hx
         BKymCmDFsTtnbH7OuJYkP0RaSVxN/8GdHVxMmfQF62cSa6sCFKdQcei611NgHYhoW8Zo
         aueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750085894; x=1750690694;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mthsLnsT+CmR/hCYL4lW5xo1Ic/pHf8tPVpsM8iPfCk=;
        b=iby5Ws+hTD8m2iRcxCJvkPdkoU6XSDV0Mmb2DNGtB/3N/VkX37dqPDUT8SInMt+PR2
         tWl9oiR2kjdVu1n93/MQiwgk33tlsF0EicgGt6457IHwZZ5JAZL1Wksvlyqx6qxfd59V
         ne1QPe9ycvMkWTGC9J58OUuOqbC9OUNPDJyTcYY3QSt3GxIwguGm55ruQUi0Jv/PuIrJ
         3f/Bb3VX5K0WBKuW6A9qKQRMc0LRxqm+fizEI4DTbZVA3UAEdKwJWM2lYg1Qeq/QMTpd
         6sWI+I6/3GKh7NY8T50wij59cBlJMOaaJfW9XD9VwKIB2ZXp0GD2pywGf/cLhEAJYU1l
         Elqw==
X-Forwarded-Encrypted: i=1; AJvYcCW5dPY0Bj/XhuaWuV57H4hJoZngLLnFwI6b6sPHfKV8yvxeKKuajzZFSzmvNYuCJtc1txY/lUVOYw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/WXyzFrlKgY4cIC9gQo4OAveC6uMcNJQDDCwMbYs1sGjZJArj
	mIaZQCGRjDrypR0IkSu8a6j8+vmxyL6zaCJR808o9KD6KaT6Vc514qJE
X-Gm-Gg: ASbGncua+17vO0gEb23We6uFoSvFXrgInYqBc5izySmvX1FeSFyOAM6advROR5IqUXH
	m8E7g+br8RYjebYjy6OQz6zg8KTtOTy/Dbd1Ggs2kaLoNW2yWqO8k2ZZ73SCbzjW0YRbW2XGwkt
	Ay3SDPvEDeTeJ7wRtugFxVbDEaqwP3X9aejuCXoO5j550xIcTY65KCzN5B+MOK9FLbptdb3oZkZ
	LhEVw1pr7VYZ90KrloiJdhLq4sWDgeap1fvpzdTfZ2ubLABsMcKhNs7s1cE3mXcf5D0mnanX3lp
	JC+a2l6KVC28GzWQ96z8cReQ0YfLCFw8Ml91SO8cNoIUxAuYCSjoNfzQXP4kSPM5zjrMsxOv6l5
	qvl+rrdTW1Vu/WTvBGT1MrdRxRfPVt0iEbt+HCnBBqA==
X-Google-Smtp-Source: AGHT+IEw9/WjTxn1NuAzjhUGh3JwWJStTsTt9/qc/bNze1EFuIMzP7MW55ZoJI4mFhWkZ52A38yCAA==
X-Received: by 2002:a05:690c:4a10:b0:70e:185b:356d with SMTP id 00721157ae682-7117539fd48mr130224337b3.14.1750085894168;
        Mon, 16 Jun 2025 07:58:14 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-71181595c14sm8149807b3.94.2025.06.16.07.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:58:13 -0700 (PDT)
Date: Mon, 16 Jun 2025 10:58:13 -0400
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
Message-ID: <685031054a4b2_20ce86294c8@willemb.c.googlers.com.notmuch>
In-Reply-To: <560f6cd7-f66e-43ca-b458-ae362d0779de@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
 <766c5e599bc94296fe58087e4c30226260cddff8.1749839083.git.asml.silence@gmail.com>
 <684f8218f2e39_1e2690294dd@willemb.c.googlers.com.notmuch>
 <560f6cd7-f66e-43ca-b458-ae362d0779de@gmail.com>
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
> On 6/16/25 03:31, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> >> associated with an error queue skb.
> >>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> ---
> >>   include/net/sock.h |  9 +++++++++
> >>   net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 55 insertions(+)
> >>
> >> diff --git a/include/net/sock.h b/include/net/sock.h
> >> index 92e7c1aae3cc..0b96196d8a34 100644
> >> --- a/include/net/sock.h
> >> +++ b/include/net/sock.h
> >> @@ -2677,6 +2677,15 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >>   void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
> >>   			     struct sk_buff *skb);
> >>   
> >> +enum {
> >> +	NET_TIMESTAMP_ORIGIN_SW		= 0,
> >> +	NET_TIMESTAMP_ORIGIN_HW		= 1,
> >> +};
> > 
> > Can you avoid introducing a new enum, and instead just return
> > SOF_TIMESTAMPING_TX_HARDWARE (1) or SOF_TIMESTAMPING_TX_SOFTWARE (2)?
> 
> I can't say I like it more because TX_{SW,HW} is just a small
> subset of SOF_TIMESTAMPING_* flags and the caller by default
> could assume that there might be other values as well, but let
> me send v5 and we'll see which is better.

This is quite a lot of new timestamping logic for only io_uring as
user, and I don't see any other user of it coming soon. I also see no
easy way to make it more concise, so it's fine. But this at least
avoids one extra new enum.

