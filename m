Return-Path: <io-uring+bounces-3495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14B8E9971BD
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEEBE281CD9
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503B01E25F0;
	Wed,  9 Oct 2024 16:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4gyktCo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48FA1E1C2F;
	Wed,  9 Oct 2024 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491423; cv=none; b=Z8Ga3DsCQ1SSSdvZU9/EBpha6VZJ0nt60lQoQYJd3DFJdpJBvrJbUMnGCjuhzz+fCyGiZY4PhydwceueSgF8W4uzGNJr+paXEUEtSH2K/iTssO6wePixMkV/7l63p4aiAepVpuHTRC3Aqiwp/gDmcvw2lH5IP2sA+AooEYL9Qi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491423; c=relaxed/simple;
	bh=rnFfpJwKKpScDBZ/fxV66dFCup5vbrrMbx4avl30qTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGfvhgeFUK4PRyIbvE6F7r8S5B1xhLOFmCcsYfpZEqI4R5Jkdp0jQiAnsJTG1GP2Qb6rPddn1XlOxptA0IHIq9pcY1+lbMsZvs8XgfHS2kIG9v2wUBKkiaF3961HvFLCNUAZCxFfKwT73eELOWsiFxUm0RTsd8gqGEsxyJHQgAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4gyktCo; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71dfe07489dso6899b3a.3;
        Wed, 09 Oct 2024 09:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728491421; x=1729096221; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J6tBkoAxRcUXBcH6ylPks977Lpgg87dO/N6OEdsN19E=;
        b=X4gyktColLiHenZNV+zTuEVM5jA7OzUIoGwhqf8iHy2n4LZ6JE0JyyBvluFBcZETAD
         U/uQYFifqrNkAao+TmrqaXdseKyTI8dC5aY87l9xCxpRjsGieT11aVcAAo7G7q8KBeHK
         RccLzDzt6gH6AoKeiXh5xfQC/1RUShRtR3tWXp6E4SGjwNiw/r0f4ZVzX6VLbUyhD2x7
         CtsoN178mer0jB/1KLF7LhsSGTQ9LnUQ47KLSHpJSX7uQyKUwXGJIHxVgQxjngO/frW4
         6m+Z1EjkSRszSvlejUbOmbg6oKrYyONYbB5dMhi4sZtgWn4U5bvyYjohOCGnOYlnRDjA
         EAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728491421; x=1729096221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6tBkoAxRcUXBcH6ylPks977Lpgg87dO/N6OEdsN19E=;
        b=B8dJiZWsFKki0gRdulFzgg42vJUpJk2eKLChIo9SgEptB+nzEWmOFGFfWnBwxGuLR6
         ngYCfU69n6WtfZzvJ0USh7D4U9dUMCW9DlN1RxY0b81NKE51z+7OWdklmGmOLyb4ptW2
         fE5tS3wq8Xr+wh/0AtaZPe41YhiBpcp+IXCYJGNqUZN18VhwgJ5xFnLWlR0UTBj0Sd18
         ClQKqG0MuxnayOJ7JQdu0sJvv9TSWDm4hEzk/vUPO5SCk2CDpjBic4/soBAUUcC5ueEa
         A4IK7awOaUe1yXcSKaNHOYaxtwcC3Su7RHCnc972a8AshwJBieoC4JofIm78MM2QeIrK
         EpKA==
X-Forwarded-Encrypted: i=1; AJvYcCXlUBEk/nOi9FAcoB/yBwSbzd5wVWQOnP2YvrX05/YmUfA7DQDbFwHdQwNaQSxknG0fFIfkOBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFOH5RgLMe9jJhKzFPEEEsnxtmJ1D4NcfBoFJ/ofwMnu5fay8P
	+mwpx9E5lXPfZkQoOCTAVuceBSpLBGLv1jEDDuphprn+VqB3EcP1TzUih10=
X-Google-Smtp-Source: AGHT+IFRc1VOyNUx/b1CtreCkgFTK2fjRI8fIwedmCY5kXeD2Hy0fDwik3qSG4NsU7tlUTGii5GHNg==
X-Received: by 2002:a05:6a00:4616:b0:71d:fd34:aa98 with SMTP id d2e1a72fcca58-71e1dbca3bcmr5161902b3a.24.1728491420989;
        Wed, 09 Oct 2024 09:30:20 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f680cbd5sm7484366a12.8.2024.10.09.09.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 09:30:20 -0700 (PDT)
Date: Wed, 9 Oct 2024 09:30:19 -0700
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
Message-ID: <Zwavm2w30YAdoFsB@mini-arch>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk>
 <ZwVWrAeKsVj5gbXY@mini-arch>
 <6b57fb43-1271-4487-9342-5f82c972b9c5@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6b57fb43-1271-4487-9342-5f82c972b9c5@davidwei.uk>

On 10/08, David Wei wrote:
> On 2024-10-08 08:58, Stanislav Fomichev wrote:
> > On 10/07, David Wei wrote:
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> There are scenarios in which the zerocopy path might get a normal
> >> in-kernel buffer, it could be a mis-steered packet or simply the linear
> >> part of an skb. Another use case is to allow the driver to allocate
> >> kernel pages when it's out of zc buffers, which makes it more resilient
> >> to spikes in load and allow the user to choose the balance between the
> >> amount of memory provided and performance.
> > 
> > Tangential: should there be some clear way for the users to discover that
> > (some counter of some entry on cq about copy fallback)?
> > 
> > Or the expectation is that somebody will run bpftrace to diagnose
> > (supposedly) poor ZC performance when it falls back to copy?
> 
> Yeah there definitely needs to be a way to notify the user that copy
> fallback happened. Right now I'm relying on bpftrace hooking into
> io_zcrx_copy_chunk(). Doing it per cqe (which is emitted per frag) is
> too much. I can think of two other options:
> 
> 1. Send a final cqe at the end of a number of frag cqes with a count of
>    the number of copies.
> 2. Register a secondary area just for handling copies.
> 
> Other suggestions are also very welcome.

SG, thanks. Up to you and Pavel on the mechanism and whether to follow
up separately. Maybe even move this fallback (this patch) into that separate
series as well? Will be easier to review/accept the rest.

