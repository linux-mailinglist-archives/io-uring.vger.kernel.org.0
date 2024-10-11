Return-Path: <io-uring+bounces-3596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC5199A6A6
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 16:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5584F285024
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 14:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403A4405FB;
	Fri, 11 Oct 2024 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C69a+sid"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1716184;
	Fri, 11 Oct 2024 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728657787; cv=none; b=YMfkjA9Hx6b3bRLYYLPDg2cIWG4cVwbzMyKdKwcIwIF4b+cbw9XYUKmi16SRK7MBBe9XFm2OqwrFczTZk0O97l9ZTpSyJvEaTWFgdjYx+awK4XBEhXukeNXfhfSUXwU+q48a0E8prpm2eI+gqVz5cIZrGSec6XuZXUkEQJM//LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728657787; c=relaxed/simple;
	bh=7PDLe6aX04qqTauZHh3YRl9ClsCusFDRy3uF4rZkfao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucmrqnJcaj4OaoFSd5wJL/uaPeRYu+LylCGdvnBD10JdN8FpJpdyE4wI+zlFRmF8mrhGvD2JTeL+V/jS6dGTe+Pr0Hpob746dNUfuJDLOy90RWvybd3CWPjKvlmaqAWZA03XwePb1z8h52/5H87mqnp7m2E874/qefk8fzbJydU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C69a+sid; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e2ed59a35eso944424a91.0;
        Fri, 11 Oct 2024 07:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728657785; x=1729262585; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oCX7GZSr6GbTinBcx9jtBazjwq9+4MX/z5qScIDqe74=;
        b=C69a+sidzhiq0l0IhBoqWljYK3AuLUdvekmQ6rYPqeYtEHQyvmUCs4+U0hkgNlJAeE
         znhhqt52FSTNqwTlpZ6nUmHSdJgDDiCsUaQHz0pHQGcyA3/UAuFKch9BiCYTOhE1t46T
         52UZHo+sNWXMcYzDyaFlRDBgOPTphpHlogbQOPP4h/SNVo2o/Yw0l7XpPoCenI6XYxkd
         QmCeF0rV0E6j/g99rd/KCO8nMU3jQ868jg0k8aAMtjPlxA6BrZcl2WhzLHD8rdISZXpf
         YFCHDu1OR/tEj1coJbsM033Bok8kQP3RJTm2sEbdCdlOXU01EjKbrLa/se9ujWTcGwbj
         A1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728657785; x=1729262585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCX7GZSr6GbTinBcx9jtBazjwq9+4MX/z5qScIDqe74=;
        b=g8SMi5ks4iWwKsVxPTj3wFqbTEeTT1CZFmh5fzqfrAT0XjfFWRS8GlYr+9RohE1B1T
         T9WLs+jbcD93j1xJg/NBRcvWFqyJqUxNgwbWQLigMhr5/VEKYx5VMILsTK8sJRSlhXBT
         tozwPe7NRZ+mMlrroxAXb+CtIFU8tWK91TXJ8n41J1wRWUPVzBIULhyv3NmAVIcgeP3c
         4S9I60XIP14TP2ir6rXgo4UU8JwkqEMVBoWtrqvP7Rjt370QJDssNcazulg5I9EOA+6x
         oiBKCI7g5nhx/9NOIv6CK+gM3OQJCv1LaLf89PByVYn7ZMWJL8xBnSqaaZxiHU+0xj5R
         OOng==
X-Forwarded-Encrypted: i=1; AJvYcCUbzV/IfrX/Q41tZoMlpBoF4vXCxFxdpA/ZBbM6C0Asz/VXdqPYEqEo+Ow9Cv065yRy7C34OlN9@vger.kernel.org, AJvYcCVaBCJZkHckRMLya+HQL6IfGkPNRqXfVuhatMjt8SFx51m54D2GPCofttTThudmOXv53lMIdyWWxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxP7ng96vh644sfF2vYvkeYkPFtsIC+kgBHmwlYp4GA+OI9Em5p
	7RjN6COCiSMBzcD2tOe0QTlLsNH3SGtCOafEoKmiNn3WnXpEL5A=
X-Google-Smtp-Source: AGHT+IGo3oYW0V8uIvbOLsEwrlmZTbSK4B1n/uXV3D86cvXvGJdenSC+0/S9DGGBEmQnsd896+eRMg==
X-Received: by 2002:a17:90b:1805:b0:2e2:af57:37eb with SMTP id 98e67ed59e1d1-2e2f0da8372mr3664645a91.41.1728657784986;
        Fri, 11 Oct 2024 07:43:04 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2a5712814sm5575697a91.30.2024.10.11.07.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 07:43:04 -0700 (PDT)
Date: Fri, 11 Oct 2024 07:43:03 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
Message-ID: <Zwk5d1QvRmOGDf-r@mini-arch>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk>
 <ZwVWrAeKsVj5gbXY@mini-arch>
 <6b57fb43-1271-4487-9342-5f82c972b9c5@davidwei.uk>
 <Zwavm2w30YAdoFsB@mini-arch>
 <f872e215-25af-4663-a18e-659803cc1ea6@gmail.com>
 <e13c8d8b-eb66-4dd3-bfd4-8303393c592c@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e13c8d8b-eb66-4dd3-bfd4-8303393c592c@davidwei.uk>

On 10/10, David Wei wrote:
> On 2024-10-09 16:05, Pavel Begunkov wrote:
> > On 10/9/24 17:30, Stanislav Fomichev wrote:
> >> On 10/08, David Wei wrote:
> >>> On 2024-10-08 08:58, Stanislav Fomichev wrote:
> >>>> On 10/07, David Wei wrote:
> >>>>> From: Pavel Begunkov <asml.silence@gmail.com>
> >>>>>
> >>>>> There are scenarios in which the zerocopy path might get a normal
> >>>>> in-kernel buffer, it could be a mis-steered packet or simply the linear
> >>>>> part of an skb. Another use case is to allow the driver to allocate
> >>>>> kernel pages when it's out of zc buffers, which makes it more resilient
> >>>>> to spikes in load and allow the user to choose the balance between the
> >>>>> amount of memory provided and performance.
> >>>>
> >>>> Tangential: should there be some clear way for the users to discover that
> >>>> (some counter of some entry on cq about copy fallback)?
> >>>>
> >>>> Or the expectation is that somebody will run bpftrace to diagnose
> >>>> (supposedly) poor ZC performance when it falls back to copy?
> >>>
> >>> Yeah there definitely needs to be a way to notify the user that copy
> >>> fallback happened. Right now I'm relying on bpftrace hooking into
> >>> io_zcrx_copy_chunk(). Doing it per cqe (which is emitted per frag) is
> >>> too much. I can think of two other options:
> >>>
> >>> 1. Send a final cqe at the end of a number of frag cqes with a count of
> >>>     the number of copies.
> >>> 2. Register a secondary area just for handling copies.
> >>>
> >>> Other suggestions are also very welcome.
> >>
> >> SG, thanks. Up to you and Pavel on the mechanism and whether to follow
> >> up separately. Maybe even move this fallback (this patch) into that separate
> >> series as well? Will be easier to review/accept the rest.
> > 
> > I think it's fine to leave it? It shouldn't be particularly
> > interesting to the net folks to review, and without it any skb
> > with the linear part would break it, but perhaps it's not such
> > a concern for bnxt.
> > 
> 
> My preference is to leave it. Actually from real workloads, fully
> linearized skbs are not uncommon due to the minimum size for HDS to kick
> in for bnxt. Taking this out would imo make this patchset functionally
> broken. Since we're all in agreement here, let's defer the improvements
> as a follow up.

Sounds good!

