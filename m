Return-Path: <io-uring+bounces-3472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B67995A09
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 00:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B83D1C20E10
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 22:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC7D215005;
	Tue,  8 Oct 2024 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fastly.com header.i=@fastly.com header.b="O8c5nTIm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D906B212EF2
	for <io-uring@vger.kernel.org>; Tue,  8 Oct 2024 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728426312; cv=none; b=kvK+3J6QDtgxs8H5Og9Yg9NPfV8dlkH04ohZ97bX5cjYFXzeB5MruV6s5oShHLGdehWtUyaIpI6hVFdPD41FxYNAihflEQjWmDQ56AeFBEJf7kEz+WkXdZgNuRbZ1HWllE0oXN6F2Ox8RLLCREVy/uL+EdqXXD77FbsbAP6O71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728426312; c=relaxed/simple;
	bh=6xjWqoMjoS04Fu8Y/ReLttlzp2emX/zBTrOXdY7poa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEaO3/0vo5zhE/aE1Q1L6NRkwtvKCW3LBxrnv81PwlRZd5DxVms/mijC/qaBpxrzt3ohoUjg7uiGmh/7c6hVUL/WlPg76SWpE4lWDhuU9V3mGdDTi0jpbdy9j5jnNWs5eysWu4FQVz9Jc24qFlS+c7FP2hFT3mVSxb8Dn1Kv8oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fastly.com; spf=pass smtp.mailfrom=fastly.com; dkim=pass (1024-bit key) header.d=fastly.com header.i=@fastly.com header.b=O8c5nTIm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fastly.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastly.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-208cf673b8dso68126865ad.3
        for <io-uring@vger.kernel.org>; Tue, 08 Oct 2024 15:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1728426310; x=1729031110; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBtjijl+VgecyHMO/fQ1xjwWXBxhVsIl5s6BOBtNKSs=;
        b=O8c5nTImXTJp4j6EzN34BiN1vfiu7mrRI4PpEkFBFyrYrLLGk3YC/IE0/JGATKZJud
         bI+t1GLegHlMnaIPJi1nSUFagKTyUWHKaLwt12l2cqM8njjSrNbjNuKNZCpKqBpsqMvW
         odFGVSbU5o69A3R+q6EPPlpVR3mLTsZtusqp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728426310; x=1729031110;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBtjijl+VgecyHMO/fQ1xjwWXBxhVsIl5s6BOBtNKSs=;
        b=nJDbEfMKhWL7liZxTUzphrNvA177VZ7sVKpb3AYwnz3B/8PbMSDiy7wKfVQ+ti0knq
         3ASSxpUGtN1J+IIYqqmd5Sy6p6UvkE4MlCdBT3aAw8aH4DoQypa7oHD86BU7PQXmlJm2
         cxXhf9WhrgTRGP/SgJgnOCRjizNv7glYdi2JeRXEJiJzhsnom851rklO/3n+6RO/fhLH
         Cbsng4TZEidhbpMnhHsze/QGJ9zLWP2nS6AGeNvtSB6bZS3FajhPrUUOvD4y8BmSbS9p
         cnKs0EvjiLt96oYeHiOkdFL7yP6SD/M8OgwVfGeCuqgqDMKsbiyNnhUI2ID11PI5kK0b
         OdLw==
X-Gm-Message-State: AOJu0Yw6ULGY6YR6s/VheSbq6wbgk64AU8WHPi37An9mlgSprXeu+6hp
	xQw7fT4ISazbsy1oyKH8Z1xeHDiCL7Koq8BeXL6o5lckp5JNaB/O9LpAsPFSGoI=
X-Google-Smtp-Source: AGHT+IHjokayAWXB/wBd7DPiiHew11bkwY08IBmzQRFlhWrxAfQO5L7a6FUAkg0Z9Ei5TUfmPNeyWg==
X-Received: by 2002:a17:903:187:b0:20b:b0ab:4fc3 with SMTP id d9443c01a7336-20c6378d269mr6733225ad.49.1728426310185;
        Tue, 08 Oct 2024 15:25:10 -0700 (PDT)
Received: from LQ3V64L9R2 (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138cbbc2sm59955925ad.78.2024.10.08.15.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 15:25:09 -0700 (PDT)
Date: Tue, 8 Oct 2024 15:25:06 -0700
From: Joe Damato <jdamato@fastly.com>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v1 08/15] net: add helper executing custom callback from
 napi
Message-ID: <ZwWxQjov3Zc_oeiR@LQ3V64L9R2>
Mail-Followup-To: Joe Damato <jdamato@fastly.com>,
	David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-9-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007221603.1703699-9-dw@davidwei.uk>

On Mon, Oct 07, 2024 at 03:15:56PM -0700, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>

[...]

> However, from time to time we need to synchronise with the napi, for
> example to add more user memory or allocate fallback buffers. Add a
> helper function napi_execute that allows to run a custom callback from
> under napi context so that it can access and modify napi protected
> parts of io_uring. It works similar to busy polling and stops napi from
> running in the meantime, so it's supposed to be a slow control path.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

[...]

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1e740faf9e78..ba2f43cf5517 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6497,6 +6497,59 @@ void napi_busy_loop(unsigned int napi_id,
>  }
>  EXPORT_SYMBOL(napi_busy_loop);
>  
> +void napi_execute(unsigned napi_id,
> +		  void (*cb)(void *), void *cb_arg)
> +{
> +	struct napi_struct *napi;
> +	bool done = false;
> +	unsigned long val;
> +	void *have_poll_lock = NULL;
> +
> +	rcu_read_lock();
> +
> +	napi = napi_by_id(napi_id);
> +	if (!napi) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		preempt_disable();
> +	for (;;) {
> +		local_bh_disable();
> +		val = READ_ONCE(napi->state);
> +
> +		/* If multiple threads are competing for this napi,
> +		* we avoid dirtying napi->state as much as we can.
> +		*/
> +		if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
> +			  NAPIF_STATE_IN_BUSY_POLL))
> +			goto restart;
> +
> +		if (cmpxchg(&napi->state, val,
> +			   val | NAPIF_STATE_IN_BUSY_POLL |
> +				 NAPIF_STATE_SCHED) != val)
> +			goto restart;
> +
> +		have_poll_lock = netpoll_poll_lock(napi);
> +		cb(cb_arg);

A lot of the above code seems quite similar to __napi_busy_loop, as
you mentioned.

It might be too painful, but I can't help but wonder if there's a
way to refactor this to use common helpers or something?

I had been thinking that the napi->state check /
cmpxchg could maybe be refactored to avoid being repeated in both
places?

