Return-Path: <io-uring+bounces-8171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DCF6AC95A0
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 20:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DEDA3B70C6
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 18:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1FB225412;
	Fri, 30 May 2025 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P97IB4S/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D11D63C2;
	Fri, 30 May 2025 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748629858; cv=none; b=OlXl5tYEETS1JzruEAGxjEQmGshH3LU7oPJENFnl2csRNYVmhJyDdAaTILiz/Dt4Al0oKXzYHgHl87Uw8l93QgmT+TOXRQIAs+gW1JXo6pvZNq6bL9AFY/gqsDajPB1wXPVxv2l10AU1/JQBZ9H2SZQWB05aMksXVvo/6BLh7+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748629858; c=relaxed/simple;
	bh=HZtEeWx2Sqz3p3UjYrvKi685hgSwL1luo1Q0IbsiZCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meZtSGCXGGgQe2YltLNPMPD2kPsABVkjckSPieLkaQHo7VWL+VliLutMxnfYg0pBTLWEGLHRPA9moPYRmArfxjqOTM+Ir3F+3rS8Mf0FB8fRZzX7xo1ZDaINJTjNOEzjOo2epgAn6byQxH8FRb2+vEhR4vnLNsDALzeXWpMzlUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P97IB4S/; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-745fe311741so2624207b3a.0;
        Fri, 30 May 2025 11:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748629856; x=1749234656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QUymIlVd/rzr0ZuUJ287SExJEIcXoQBwtWT5718kBY=;
        b=P97IB4S/efVpaue5tIHyRgwc5/RBGvVYI/Z09GMJBxKVw7+5M3az/ADc0EJIJFjDzU
         ux9HHtbCHFmO/ybPbJIgKmjfhBnhwLQjRJ4SU5GQYe9j8IrC2w7pF6rZYvXNBHQ+jns0
         CS9xESijcA17/r+agZSg3RgSLxvY2F8ZhqBHtJQVSWzcpeo0/Dfj4ljhe0d83BhmDStm
         FG2DLBr1KCF0Sv44qux3iePAwbJhOfiUzzVn3JKalfwdbGMYEpoFsYvzcV4rYAzSeVhv
         RI8YZCkpotZfiIW75UlSfXmrlPh1UDKnxU1VNdkxqRMphjDLwjtgYOMvFiYBpY68yY08
         tUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748629856; x=1749234656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QUymIlVd/rzr0ZuUJ287SExJEIcXoQBwtWT5718kBY=;
        b=AELAaHTPmhK3Hhw6u2n5TtkftUcQQn1gbRAFp9ahQ4SWPl5lSuZP/+qxok1xAfqZcK
         Omd4ydQuqsrJhgfizeQzQMWnJYCpBMgIuGtOdcRjjKZ5H4wFfwgPwCX4IJbJxCrxgqUc
         AzZ/n2pRdy7kl4yEdBdPkKUEUdvQgDuFWVAWNn/88I51JSqeGq2g9ML1KqyecqZ5MAUA
         YSnRpa2UBqeQe0XS8wHYs1U4XpnIevOBdzk+P7SdTVs2+4n8teHrNubixcGV1InZaEWi
         L9JAhGVb03zMx0uw86IQHNZ6++IN9pgVfe0+rsE+5/Y7Q4ZnfeZYuFUPJilIRLiJErQd
         iOCw==
X-Forwarded-Encrypted: i=1; AJvYcCWrzszRAhAXL+7CRH3674oS967RXHbKtHC43CeVGdVRfSEZSfBc/s6fCJ+UxD5lY8oQxA+dA5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu9vlWyOZ7SMZdKa0P6pVE0hzqvXV63tMKTzpEDCt4rwXtkEip
	pVQUNYKKsfJzuo3xqaERK3gPGnlWvkUzhGeVuAdDUWcnRH6357pSEpsWF+kS
X-Gm-Gg: ASbGncsykgya9PKMF9/6FKclwoeHh6PxJcoBOxnStf5cscm6B7EnDj9LpL9hOru63C0
	kwOwyBfU5Kg2K2ylT9jQOFVuOHGSgjQiiFiQGCGkXzohwf33kxzfzZh7t4fhnj3FD0MjT4D2COe
	9+B+tyL2c9/WHaLYoo4VnZmLYBRQNc2SBh7O1HB+De0KkAsOncatU0DOVEnjaTEKXafqIIZJYD8
	ID6tTgsDgVNjAcahu+4iTBHuZBAY4gsURz6Onwk27G0OHbBf2+UNH4rYjhLZw/3l0jpEeUZGDSo
	ZwSVMG5X0vN8k1plhQI89b0dnkPmzuR0BPmqzI1onQKGplwNklEu+RwGog99RLamhalnDmg74jm
	Vm1OUZmsXLd5A
X-Google-Smtp-Source: AGHT+IFF8HFftq71HOqRYxA9P/m3LILqy2b8N3wHnf16UGRz6qJi4oACk81SBo9cBfUJqG8p7Ib21g==
X-Received: by 2002:a05:6a21:99a5:b0:216:20de:52d9 with SMTP id adf61e73a8af0-21ad952e3a7mr7376290637.14.1748629845534;
        Fri, 30 May 2025 11:30:45 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-747afe9639csm3478676b3a.17.2025.05.30.11.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 11:30:45 -0700 (PDT)
Date: Fri, 30 May 2025 11:30:44 -0700
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
Message-ID: <aDn5VKgXkYg77Qk_@mini-arch>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
 <aDn1fV8D2G90mztp@mini-arch>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aDn1fV8D2G90mztp@mini-arch>

On 05/30, Stanislav Fomichev wrote:
> On 05/30, Pavel Begunkov wrote:
> > Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> > associated with an skb from an queue queue.
> > 
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  include/net/sock.h |  4 ++++
> >  net/socket.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+)
> > 
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 92e7c1aae3cc..b0493e82b6e3 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >  void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
> >  			     struct sk_buff *skb);
> >  
> > +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk);
> > +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> > +			  struct timespec64 *ts);
> > +
> >  static inline void
> >  sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
> >  {
> > diff --git a/net/socket.c b/net/socket.c
> > index 9a0e720f0859..d1dc8ab28e46 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> >  		 sizeof(ts_pktinfo), &ts_pktinfo);
> >  }
> >  
> > +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
> > +{
> > +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> > +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
> > +
> > +	if (serr->ee.ee_errno != ENOMSG ||
> > +	   serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING)
> > +		return false;
> > +
> > +	/* software time stamp available and wanted */
> > +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
> > +		return true;
> > +	/* hardware time stamps available and wanted */
> > +	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> > +		skb_hwtstamps(skb)->hwtstamp;
> > +}
> > +
> > +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> > +			  struct timespec64 *ts)
> > +{
> > +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> > +	bool false_tstamp = false;
> > +	ktime_t hwtstamp;
> > +	int if_index = 0;
> > +
> 
> [..]
> 
> > +	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
> > +		__net_timestamp(skb);
> > +		false_tstamp = true;
> > +	}
> 
> The place it was copy-pasted from (__sock_recv_timestamp) has a comment
> about a race between packet rx and enabling the timestamp. Does the same
> race happen here? Worth keeping the comment?

Or maybe you don't need this case at all? Since you're skipping the
tstamp == 0 cases anyway down below... Pass 'false' to skb_is_swtx_tstamp
instead?

