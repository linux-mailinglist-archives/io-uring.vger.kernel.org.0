Return-Path: <io-uring+bounces-3493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D448299713A
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 047611C22563
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780621DF997;
	Wed,  9 Oct 2024 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fastly.com header.i=@fastly.com header.b="XoVKaUu0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F7E1F4723
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728490428; cv=none; b=nHht0+NLic1x+QzLuPbabSOP++U9N5ASfcFNBV42oH4D3CNpy6V3rA5AhkIKtQONS77B9hmv8+9GEaWYFZUdT5nMfjB6hPI0yYiEg3OYGPOcAmEPAmP1TIXvMeYgACBOEtaWNAt7l7IhXDMfMa7nPTt4pwhByMnHLVweZIpueGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728490428; c=relaxed/simple;
	bh=qRDhwbKc4gqUv4odZFgBRE0svDDR1jk8/VJtFT5BLpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eP8+iF0CHeMzx32jTu2umnJqNthjXR/afZsc+I3CqGJOcf7PGuuHfFww3w5gIGE02ZkrkLvGacQd9xgScqvQEQv6wptzh8EQDfSOP1+GzS59DnL1Sfo1CTcBvu23nfsai9Hoa+KKGIWLRVj3CpDITEuAm2V76rTRU/Qpozjr43I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fastly.com; spf=pass smtp.mailfrom=fastly.com; dkim=pass (1024-bit key) header.d=fastly.com header.i=@fastly.com header.b=XoVKaUu0; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fastly.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastly.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71df7632055so4156142b3a.3
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 09:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1728490426; x=1729095226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I33A6jYeY45I8ALsp4gxb0eFudKjIyGKk+ralmB1OTU=;
        b=XoVKaUu0G1Rst4uSlyRoYXVfFtnrboa/r9k4ROZ3JBauitnIZwVtHZcheD4q55SBNs
         nJq1dqNOghuDvZW44ATEXNHUfykrfxu9tuqTPPxzKE4GqcNvr3f56+YAWR1ueV+arm7u
         WOa5nnVRCG0A7ylr0cUrcg80l/fgCzjtnl8C8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728490426; x=1729095226;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I33A6jYeY45I8ALsp4gxb0eFudKjIyGKk+ralmB1OTU=;
        b=jfU0NIiyNgFYf4zAucFxclIGCSSuFuX3uD47fzuWWmHCHOBJFWSYx+hRQIxR+Pp/24
         btpdZJoK0prlg3SqYwd+LU3BWMwhR48GnG8Fj+ZlqUKUpyN0kkNormZ5cPaokRSbQEak
         xPQRrCWTQSObK0bC4G2PwhpveQyKA1JFAXfbDse/8EDUFp0u9+2u6skwRlcvS7FKj2O2
         DRh2zQ43K7NZeMDS89Yk7IFZ78+EBvaWUhRkSwq481Yfg8TOasZIJR6KUhPBLh9TkQG3
         UDVqjX+Pyy+qm0bs4sGF3tXNjizDNJzakBAtd614atqnCsnLdRpcNSmo0NnxbAvRF0dU
         I9Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUk4ushyZcKuhuSovfFlK6i+EdpzbFl7u3eRx4ZLUFkhcwE8/oGPWuxam3rEHSv77+9REHopFXULw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZKdYN2EHBrPlVfWOCpmy1BQ5dY2/QWDEtbP9QJIa5uETlSR7u
	cR3N5fZGO1BtpbRxQmaN9+HN8iOX2zanzLq4RrOge8SgDVRbUucUxhbCjuCfNeA4AkjGFrbVExB
	y
X-Google-Smtp-Source: AGHT+IE+LFDDXBBvy4teY9len83ORvaHirPjVhFZMIZBw5XnRw0clMLhZarJLPm7Q34wgwkMUTUgLw==
X-Received: by 2002:a05:6a00:2d83:b0:71d:e93e:f53b with SMTP id d2e1a72fcca58-71e1dbbc1cemr5337089b3a.22.1728490426111;
        Wed, 09 Oct 2024 09:13:46 -0700 (PDT)
Received: from LQ3V64L9R2 (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cbba1csm7968933b3a.33.2024.10.09.09.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 09:13:45 -0700 (PDT)
Date: Wed, 9 Oct 2024 09:13:43 -0700
From: Joe Damato <jdamato@fastly.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v1 08/15] net: add helper executing custom callback from
 napi
Message-ID: <ZwartzLxnL7MXam6@LQ3V64L9R2>
Mail-Followup-To: Joe Damato <jdamato@fastly.com>,
	Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
	io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-9-dw@davidwei.uk>
 <ZwWxQjov3Zc_oeiR@LQ3V64L9R2>
 <6e20af86-8b37-4e84-8ac9-ab9f8c215d00@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e20af86-8b37-4e84-8ac9-ab9f8c215d00@gmail.com>

On Wed, Oct 09, 2024 at 04:09:53PM +0100, Pavel Begunkov wrote:
> On 10/8/24 23:25, Joe Damato wrote:
> > On Mon, Oct 07, 2024 at 03:15:56PM -0700, David Wei wrote:
> > > From: Pavel Begunkov <asml.silence@gmail.com>
> > 
> > [...]
> > 
> > > However, from time to time we need to synchronise with the napi, for
> > > example to add more user memory or allocate fallback buffers. Add a
> > > helper function napi_execute that allows to run a custom callback from
> > > under napi context so that it can access and modify napi protected
> > > parts of io_uring. It works similar to busy polling and stops napi from
> > > running in the meantime, so it's supposed to be a slow control path.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > Signed-off-by: David Wei <dw@davidwei.uk>
> > 
> > [...]
> > 
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 1e740faf9e78..ba2f43cf5517 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -6497,6 +6497,59 @@ void napi_busy_loop(unsigned int napi_id,
> > >   }
> > >   EXPORT_SYMBOL(napi_busy_loop);
> > > +void napi_execute(unsigned napi_id,
> > > +		  void (*cb)(void *), void *cb_arg)
> > > +{
> > > +	struct napi_struct *napi;
> > > +	bool done = false;
> > > +	unsigned long val;
> > > +	void *have_poll_lock = NULL;
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	napi = napi_by_id(napi_id);
> > > +	if (!napi) {
> > > +		rcu_read_unlock();
> > > +		return;
> > > +	}
> > > +
> > > +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> > > +		preempt_disable();
> > > +	for (;;) {
> > > +		local_bh_disable();
> > > +		val = READ_ONCE(napi->state);
> > > +
> > > +		/* If multiple threads are competing for this napi,
> > > +		* we avoid dirtying napi->state as much as we can.
> > > +		*/
> > > +		if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
> > > +			  NAPIF_STATE_IN_BUSY_POLL))
> > > +			goto restart;
> > > +
> > > +		if (cmpxchg(&napi->state, val,
> > > +			   val | NAPIF_STATE_IN_BUSY_POLL |
> > > +				 NAPIF_STATE_SCHED) != val)
> > > +			goto restart;
> > > +
> > > +		have_poll_lock = netpoll_poll_lock(napi);
> > > +		cb(cb_arg);
> > 
> > A lot of the above code seems quite similar to __napi_busy_loop, as
> > you mentioned.
> > 
> > It might be too painful, but I can't help but wonder if there's a
> > way to refactor this to use common helpers or something?
> > 
> > I had been thinking that the napi->state check /
> > cmpxchg could maybe be refactored to avoid being repeated in both
> > places?
> 
> Yep, I can add a helper for that, but I'm not sure how to
> deduplicate it further while trying not to pollute the
> napi polling path.

It was just a minor nit; I wouldn't want to hold back this important
work just for that.

I'm still looking at the code myself to see if I can see a better
arrangement of the code.

But that could always come later as a cleanup for -next ?

