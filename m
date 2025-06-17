Return-Path: <io-uring+bounces-8401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B61ADD7F2
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 18:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BE5719E26A4
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60242EE264;
	Tue, 17 Jun 2025 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cNK7teAq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD42ED84B;
	Tue, 17 Jun 2025 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177857; cv=none; b=J6E9djBj6WVfdfoVLPRjE3tx1BrexiDFPC/KnevSoECQ5oxfyGbGueKNxuvY5oV3Xd527TpQm25gbZL4ux3oy+7O0IFznZuwT5nXfaRJewm37hYK0wIyojsX4KnuclcODx6+YqHVsmza2s3roL5t1dxyxa2hrNgenXv6oUZ0XNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177857; c=relaxed/simple;
	bh=sEFAvjaConErDE1ombaAX/n8ztQniJe56nKOy0ckK8I=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=RvmVjLnk7odMScfE0AWFFLalpFmNZ6OwlduiodGlxv6Xys1AAsDVdYL1iaiIdbkm1e9Mj99vdWKeQhKlfzTvLn+M+CsX8ff4B4wx8pAnKFRAZg2+8MbC1gMB3GV5JnK3ldaiTF3AFj8qPRGsiEuz7Ws3i+Mz6cyRgzdSVA5Shts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cNK7teAq; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-70e767ce72eso51826557b3.1;
        Tue, 17 Jun 2025 09:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750177855; x=1750782655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmNBkTnKHwO5DvjqhNkT+aT8EXqMAox/slYQIzUA+0Q=;
        b=cNK7teAq28E7TeDT8JeA31tyAPG78vSmY2l8tN66SvzK0JGtnGhZq5o8gPFkLETmSy
         57geHBurCx+qXfD3NABenFNHf9NbSNYCWLMJzRuHOALON/OQ3n+V1ET3mfNOkD0toGKI
         pdxffhb3jrnxwMQBzn4u6FLQIykuuK5OMUV4lmBi8pj0oppSo/4C4TMdZytcDeRJSrXJ
         AJM883ChP2BoXH9+SDngDFdzvcRIqok+wxqYFVYGi+1ENQiIw5YhH3tcsV6tcSwpbEg0
         /udJ2wAeHQUzBEh6hPMl7rIECVLeKd7cXP83SeqmkVkmGHpX5V9932EzoYNMBUXlQido
         /33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750177855; x=1750782655;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OmNBkTnKHwO5DvjqhNkT+aT8EXqMAox/slYQIzUA+0Q=;
        b=Si32yftK6A9XlnL8AGqRDUgev49Lm9tMlqAqhUjDmNtFOtpqQoXmKqwAP2WTDcxD/v
         NeUQkSIpJHMcV+bJ8XgpSzBXmCmOxGs2MA8V0lLOwbRAC29I7gcSrUs7ekaIFJjlx/yd
         Yf0yV5GZbd+tTFvtg6MWXcGu1n+Bot+2eo2tBYD2t8t7VUMkI2aVhIsupyC/Rr9Tw0Yk
         udKwPS1RFTcdvtlMVwTtUV9OO6Z3oyvIrVClh0URVuNrhZLrVF3hrToms1V9Dmfh6zew
         6DqDQ3SrHmFewElesFXuGXYR+3UnUf9ADbaLoSpvRpA0xxXkeGiALJDGwGUg4uNSXuiU
         6EZg==
X-Forwarded-Encrypted: i=1; AJvYcCW2DPnpJZWpUJx+bRgq3Ofj/UKdTixxxrs3Lf7EHUuHqA+8x2Akwvf7BulHWCfNNElR8ZfP8fTlQg==@vger.kernel.org, AJvYcCXZbXTcVvwdbhoAyJgTZEuBXwFJSSsFCZX8DeRlyZzaHeIY8R9cGbV/RxitwWNLwxV1l1XT2uJM@vger.kernel.org
X-Gm-Message-State: AOJu0YxnxsYtNHjqsOysHkrrMT5FKryRQXEyDy6zDCX03jbSYYYz6Nwa
	QrrsGzIo2cav9HASMlbnTmu7TASdcggRqFJWv3eg80zERgGbw/TUlxMm93FC3w==
X-Gm-Gg: ASbGncu85dOcy11s1WV+s6vxK7q31Y5hMHy6aemoXh8ZIrk+nN4fu5dnqaB6XTwo++Z
	173dJbQDWjquqWs1n1z1zGzUMU00tqq/6iyZPGcHsvER84xRn6w1rnEVgAzSwABet0eb2MVXDA9
	na+bYmuh2k5gFrYnZlaPN0myG+COYbb8Xi0ljtpi17u+9WTQ9sJowiubhZfu23BqQFfCKYCXBr6
	1s0xnmmf7+nnh1iTxSGAf7INXEUs9vjo9VzmHVhL9biA0iAdj7gv4gVRL9hJrbhZXWpXqjTXPm0
	41aP1qDqLld16CFpyMTFq7LZn+tEgFLqkS7UQl0EVFvvi6y2J+yBb0dWy1j9rm5S0dXgOYbtKWc
	rySmUZ7dHmtqx3QMjBqAyCtxPgMuLIXrzepNLIS7GY3CYZ+iecpSP
X-Google-Smtp-Source: AGHT+IGK8ydo0dFEz0nuzZTQrvu4Bh7sAIac/lWVVgL+g/jhS5E9reNpGbCDfXm/ZGnICZEcw0Lngg==
X-Received: by 2002:a05:690c:dd5:b0:70f:8883:ce60 with SMTP id 00721157ae682-7117552cd20mr211114167b3.26.1750177854866;
        Tue, 17 Jun 2025 09:30:54 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-71194917307sm8940567b3.20.2025.06.17.09.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:30:54 -0700 (PDT)
Date: Tue, 17 Jun 2025 12:30:53 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
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
Message-ID: <6851983d94a2d_2e8c1b294bf@willemb.c.googlers.com.notmuch>
In-Reply-To: <685031d760515_20ce862942c@willemb.c.googlers.com.notmuch>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
 <685031d760515_20ce862942c@willemb.c.googlers.com.notmuch>
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

Willem de Bruijn wrote:
> Pavel Begunkov wrote:
> > Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> > associated with an error queue skb.
> > 
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  include/net/sock.h |  4 ++++
> >  net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 50 insertions(+)
> > 
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 92e7c1aae3cc..f5f5a9ad290b 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >  void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
> >  			     struct sk_buff *skb);
> >  
> > +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
> > +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> > +			 struct timespec64 *ts);
> > +
> >  static inline void
> >  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
> >  {
> > diff --git a/net/socket.c b/net/socket.c
> > index 9a0e720f0859..2cab805943c0 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -843,6 +843,52 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> >  		 sizeof(ts_pktinfo), &ts_pktinfo);
> >  }
> >  
> > +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
> > +{
> 
> I forgot to ask earlier, and not a reason for a respin.
> 
> Is the only reason that skb is not const here skb_hwtstamps?
> 
> I can send a patch to make that container_of_const

Just to follow up.

The container_of_const is not applicable here. As skb_shared_info is
a (cast) pointer, into skb linear.

So even simpler, the skb can be const even if what its member points
to is not. This works fine.

-static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
+static inline struct skb_shared_hwtstamps *skb_hwtstamps(const struct sk_buff *skb)
 {
        return &skb_shinfo(skb)->hwtstamps;
 }

And same for skb_zcopy, skb_zcopy_init, skb_zcopy_set,
skb_zcopy_set_nouarg, skb_zcopy_is_nouarg, skb_zcopy_get_nouarg,
skb_zcopy_clear, __skb_zcopy_downgrade_managed,
skb_zcopy_downgrade_managed, skb_frag_ref and the ubuf_info_ops
complete and link callbacks.

But that's a lot of churn, especially if including ubuf_info
implementations like io_uring.

Not sure it's worth that.

