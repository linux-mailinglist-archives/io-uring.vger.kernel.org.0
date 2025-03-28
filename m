Return-Path: <io-uring+bounces-7277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55691A74E82
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 17:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B3371897089
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDEC1D86D6;
	Fri, 28 Mar 2025 16:24:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1284A935
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743179063; cv=none; b=JTDfz3d09PTSTmwhyz3cI6e208Fcn7ugDEaNybyhEsVh/RIVns6bH7e1EkEii0eLcQLHLE3CovC/l4gMHn4E80R/N0wHDKEHajrxCG+LNKPDWbrexRr8b6IfG8E5t4JbLzl4Z/NfFLLATyAnyl96/gRV3rpk/yzYcWZzmOg22Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743179063; c=relaxed/simple;
	bh=+MvUFuYzb97LX8ICIqK9rHlbHywyqNdUPum8D4pGCWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRFEB+QklFIYsQ3C+wwY7FBu+CTd6jqfSUyEKzkbSYIN52HxbdzwR34OSzW4E1539DwNuHY+VSZL3BsExoIiGupDhduYdKa/Vmt9KvhTq78hn+IiqNeA+SdiP/aFbbYD+4pObaZJw3VYECASw676jNLDj+UJk1Orrg1szG4b0PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so304558666b.3
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 09:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743179060; x=1743783860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/3AOMfE1dZzd7hApPMsAvbA0NJtPN85Z3Fvp8YCVrs=;
        b=g0yuX9OwvqQbgh/ytLuZEsFgKln20VyS5MUv2ESRvIvkyC0UiZAiraEL3eRX9Bj1r8
         29WYRbM90eAhK0z8fBD2/a6+1zhRlm//O+nPhquXAT/ulWTGpLJlsPwgaDCXu8R9iWB4
         +Jlu+n9bxmi1fhkhS92ODTNXY4M05hWHlMnwzB0fR0t/0ypAGFm6Cj2ByjJYzGhXThDp
         xYjWoKNed4ea0aWrpoivP/qDpjGzGxvofc3OeW+/85wn46MQZGyYbnfOjfln8gIjrvlh
         zrY3bzFqExbbgyWJWy3kAvf/8lXmDlu0q7KlGlFIf8GfIBM0Vb/tOBEJdb/a7hq9dL1i
         7IIw==
X-Forwarded-Encrypted: i=1; AJvYcCU1VxiVDgmOQ3Dzv4ty/73Upj2cksgKHCqyhPG/5XJB3NDCK7OZHSA6k42104b1CR6nAy1NORZJqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ruIxn+J0tU1cB+KWrQ/v41SX7XjMT8SpFvxR/QVvSpQOSHHP
	9fokUx/0goPIKo6r1FTWUpYKsoO/1ZyYrJ19V231W4YbKrU5/p2noW/ybQ==
X-Gm-Gg: ASbGncvA4UpKIrOuH9aLS6uOxTiChP+luoiM5Z4pCEsxmfvqZDWGcQ93nxy2EZnB/j0
	XIvjOFOaYkfwc+Dp2rZTcAddRupMCBM0RkltQLnG6aHHpuNmgF8ilQbrf4irw5QnwUhOq7KSpiT
	zcEoBqmk7+cJWdKvJQv55X3+AOPAGh99GdZS47/vsxQFRE2P5vbLk9VxUxFaQUa/iPNBqflbQ2L
	A/Weho+Zkq9wfsYfy2s+kjbXJ44Ar56yZUboHVDGswtu/FaInOTiuNu/2mzzfO1wkaRakmIkPzL
	Ez9+/Dp2oP2B1JJiW5JrIvG4SLcI7MU4l8Ws
X-Google-Smtp-Source: AGHT+IHNovzTSNPdHIFxcqcWSkpahSvZMkPd4fpnnWXySLeXj0s6TWLxH/O+6XGjb/RoeZl1/oMmkQ==
X-Received: by 2002:a17:907:9485:b0:ac2:87b0:e4a5 with SMTP id a640c23a62f3a-ac6faeaf925mr783278966b.2.1743179059619;
        Fri, 28 Mar 2025 09:24:19 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:70::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71927b0ffsm188283066b.66.2025.03.28.09.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 09:24:19 -0700 (PDT)
Date: Fri, 28 Mar 2025 09:24:17 -0700
From: Breno Leitao <leitao@debian.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
Message-ID: <20250328-careful-sturdy-jellyfish-ddabbb@leitao>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <0fd93d3b-6646-4399-8eb8-32262fd32ab3@samba.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fd93d3b-6646-4399-8eb8-32262fd32ab3@samba.org>

Hello Stefan,

On Fri, Mar 28, 2025 at 04:02:35PM +0100, Stefan Metzmacher wrote:
> Am 28.03.25 um 15:30 schrieb Jens Axboe:
> > On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
> > > Hi Jens,
> > > 
> > > while playing with the kernel QUIC driver [1],
> > > I noticed it does a lot of getsockopt() and setsockopt()
> > > calls to sync the required state into and out of the kernel.
> > > 
> > > My long term plan is to let the userspace quic handshake logic
> > > work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
> > > 
> > > The used level is SOL_QUIC and that won't work
> > > as io_uring_cmd_getsockopt() has a restriction to
> > > SOL_SOCKET, while there's no restriction in
> > > io_uring_cmd_setsockopt().
> > > 
> > > What's the reason to have that restriction?
> > > And why is it only for the get path and not
> > > the set path?
> > 
> > There's absolutely no reason for that, looks like a pure oversight?!
> 
> It seems RFC had the limitation on both:
> https://lore.kernel.org/io-uring/20230724142237.358769-1-leitao@debian.org/
> 
> v0 had it only for get because of some userpointer restrictions:
> https://lore.kernel.org/io-uring/20230724142237.358769-1-leitao@debian.org/
> 
> The merged v7 also talks about the restriction:
> https://lore.kernel.org/all/20231016134750.1381153-1-leitao@debian.org/
> 
> Adding Breno ...
> 
> It seems proto_ops->getsockopt is the problem as it's not changed
> to sockptr_t yet.

Correct. That is because Linus detests sockptr and didn't recommend
adding new code to use it.

 > New code does *not* have that excuse.

  https://lore.kernel.org/all/CAHk-=wgGV61xrG=gO0=dXH64o2TDWWrXn1mx-CX885JZ7h84Og@mail.gmail.com/

This was raised by Jakub in:

  https://lore.kernel.org/all/20230905154951.0d0d3962@kernel.org/

So, in order to implement the missing part, we need to move this to
something else. The initial suggestion was to use iovec, but, I found it
very hard to move that code to iovec.

