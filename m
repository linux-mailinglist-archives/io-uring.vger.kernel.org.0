Return-Path: <io-uring+bounces-3468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A75B59953E0
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 17:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 283AFB25E67
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 15:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746481E0B64;
	Tue,  8 Oct 2024 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVVXmx+0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC73BBDE;
	Tue,  8 Oct 2024 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728403119; cv=none; b=SK4WaG65V75jEBl1Ha8yrP826PyOYDKugL2mq8tH2T+5F8ZVPant9IvWJ3KlNa/EmEao/jBByvFLn/uwTyKiePOfPje+WZdQGkN5+1qSv5Bk7ygJo/+Cy6u5vdQP4Rwk3bEpjkmm1RsbNSiJ8YQz3KCODDOiIn/UbeXGAfvVRoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728403119; c=relaxed/simple;
	bh=RcnmA2y+lFY00Q8koaFTh9TpHxcyMTUoQ5jIu/PB91M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Su88I94zHbeGsMXwBIiPyl8b3e5bDSXfvG3abSRF61WE3hOn2QwD41ronejoJ2w5dU+ZvWAy8afyJ12pX8q1D8kZdfqVJ50QBHy4rzLwGTmPDNN/JFzxs4nIN0D6zdgzjyBXEy0RhBspipo/enON6WGIL6USFXAwFGQyMBhCbwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TVVXmx+0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20b5affde14so42586165ad.3;
        Tue, 08 Oct 2024 08:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728403117; x=1729007917; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2gqWRMcSezJjwbjIKM9AA+mXNNB6QleluEZzSxjg6iU=;
        b=TVVXmx+0BjAVsSnAc1NTNHkVm/VNVEk6eAGhc0spE+mt6Tx+TqK3nrK/i1fsFrami3
         ECLT8q+OmOV+u1tbahiQzTLhhjAEYj58wN4ITqWkDzuTRJMAVbpRtXQwfV+w5BElwFWr
         F0DbwODgw2hVX5W2IfvhEuVmu+UrGCTAd9MRx9CdSdg7Km/644nnTq9Vgc67/puk23nA
         w+upEhCquwOz6hv5pUc78lzzdMMbuPZqCA/5S6dxhGooX/5W7Fqrvy8YOvTz0ikJPXHL
         n0RlKG4TmOda5MSyv78NGCnJNSRXwpoiSHxQSGCjpxcHJ5H6NOloExsRU0MyxHSu9Q57
         W2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728403117; x=1729007917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gqWRMcSezJjwbjIKM9AA+mXNNB6QleluEZzSxjg6iU=;
        b=KKKyCrTlxryjgDPXaFFX+CUw2PPVLRvd3+uVyqHPG5eAHAmj4XIeTTnBlqBze8p6ua
         QKV9u1lug/tZ3C3oHE2JgUoegsoT46QbkjblHTzF7sTuVWPYDolw+g7DCM1pYat32JHF
         A/xB7D/22KrNGNMgwRNauG3BL8/kmOPwXJzqydBG+kKN4ztersDT2mfnDZVlWymIxynJ
         eOfKFpnMutKk4K13rbtrK7+ZZbmQX9vyd/3Dghf8wsOHJAX+ApzCcZsMOKvfb+40B3oT
         PUjzabHqEmrjP7Yw28yp7gvS3QERG66Mb4gd5ZNECkL9kPND6JA7182RK6//llJOGqBn
         GGrw==
X-Forwarded-Encrypted: i=1; AJvYcCWEUOYk9kG86xMiKyWmpkclO1q1zOzjakmTbHIDpeW8AK0jzsdu+teeTv+KW6fdT/2P9T8IYbs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb+jzAyNtxSK/kK6sPjFKsxG+QoglHt3lf+kMgxIvJDlvc/h/p
	pnIUHSl+3Iei0ZWj59JLEz9eB+IotFfvF3szmmkE+qj83b3HAPw=
X-Google-Smtp-Source: AGHT+IF36XOQl8E0WWIv06SaFTX+CS5c8jDMCcn/c6ZBGQ8nDF+zuLNnz4A0Om97IqYcdGAoLUOrYw==
X-Received: by 2002:a17:902:d484:b0:20b:94a3:19d4 with SMTP id d9443c01a7336-20bff0475d3mr215457795ad.37.1728403117039;
        Tue, 08 Oct 2024 08:58:37 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c54010718sm13365895ad.240.2024.10.08.08.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 08:58:36 -0700 (PDT)
Date: Tue, 8 Oct 2024 08:58:36 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
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
Subject: Re: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
Message-ID: <ZwVWrAeKsVj5gbXY@mini-arch>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241007221603.1703699-14-dw@davidwei.uk>

On 10/07, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> There are scenarios in which the zerocopy path might get a normal
> in-kernel buffer, it could be a mis-steered packet or simply the linear
> part of an skb. Another use case is to allow the driver to allocate
> kernel pages when it's out of zc buffers, which makes it more resilient
> to spikes in load and allow the user to choose the balance between the
> amount of memory provided and performance.

Tangential: should there be some clear way for the users to discover that
(some counter of some entry on cq about copy fallback)?

Or the expectation is that somebody will run bpftrace to diagnose
(supposedly) poor ZC performance when it falls back to copy?

