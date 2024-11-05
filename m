Return-Path: <io-uring+bounces-4466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7EC59BD97E
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 00:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D305283D88
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 23:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13902216218;
	Tue,  5 Nov 2024 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSUHKNKS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789341D270A
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848205; cv=none; b=gbsA1VzxPmIFDy0afB5fCjMbBuGM7LSr3GLiyNx1RYvu7a+qR9Lf27cgCZI3lvicwVHawF8svJ+stgyxlnfehV1ddbryzG6kiOrZiZ5IVhDEK7upuE0DaXO35O4Y8zI9fDsk03m6qaBUodaGhzL+tK/QVqQRRET12L8eVdVGmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848205; c=relaxed/simple;
	bh=Fcqj7cRSuieBULC6geQGcMo05W2zjISzRFxfE2W+U+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UXb2EfDIPkGfO0//Hp/VfupjXg7VFiRs/dRO2njbBx00zTIxWcTcyLaMNVbkcQUNj1wzZy2TSpDdwqMn6F1MsHPbZpZX94yB2tTcAT4k2HudbyMe5k/A34R1o5TCToOOu2oEh5WqmcGsfAgxAw8m+VjMrJzV5A9p4evQPsLLmHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSUHKNKS; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-460a8d1a9b7so48451cf.1
        for <io-uring@vger.kernel.org>; Tue, 05 Nov 2024 15:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730848202; x=1731453002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vevq8xujbLscGzB1BNic3kc2zwxvUojFsMbcnYNDKrQ=;
        b=VSUHKNKSkk0y4L+Hh+hQhMt4Ny3GOBA+6LVo68XUePzkXv24f8K9FV9O2W64oUqRhm
         eXxdzB4MA7qmVmQaqQ3a01isD2ZaFpG7wT4RqjsTPA1g2TPuQbmHm9tZGfrjMG1fM/nr
         pY2PehgVA97rcjwVjByetNt88zE1zjF/a2h0cx3jFY2WJSbV8d3YplNQovonUv8rLI3y
         WcgXoi2eZ4c/dlJyPUf5a9uTllEzU+czUN0rgOturh1+mRM5jnSd9N3nsz4onynY/hbu
         NiEK3x3NflHwHxSSfUMWtHTxSmTIvw54ZkegG1fIKZZQcKln6BagYWuTJilIWNSCiSia
         FOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730848202; x=1731453002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vevq8xujbLscGzB1BNic3kc2zwxvUojFsMbcnYNDKrQ=;
        b=JKW6a20zBqjloT/NsklueKQZRECXDHg2xpuH5pZKbjjMw5J3YtuToXzXZSX2ocaIxZ
         tCSQ2xD0E/b1h+dW3QsTRMoLo32y6rs4NpcH6goeYd5Hqnxy1jUGGCjYUAho4fDrxYHR
         rRMd3oojR/BssYxm435xSJYCw2jpyWjuvDjIpNhXxiGkfRFTlNb/GxgaFUwjMnfB+Pzv
         REoA4aFXrsuP76IHrDKm4ubMsp28JQaPamTf8YAGDIzWrl2D2ZsiAUv1ExriBCtJ6lVS
         3731MAH70ozj5pBDF39HQM4iMUsOeonGhSN0Pw8jBcmdDsPxWZponMc5dphGrwCRjpyU
         njfA==
X-Forwarded-Encrypted: i=1; AJvYcCULC0zvVSRONmKm0C7DJB9mzEDL2mDhcsMqAB5L8fDyV6nDcBANC0E7+s1VDjsD2C18xgvEPRo/qw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvkRdRL601a7g5k8ZKb3T0f4stC3N+gjg8kDO4s1Rl6XwdH35r
	OKte6V6piQCgo+qSM9e+S36UPzKolrYKyArYo/l2mJKimTFzEiB2ugSlmIASKKP7sm+QrddvUIC
	TBbWqwzDkcgwhahlpySJlS+tVj8UM0Qt7dpvE
X-Gm-Gg: ASbGncuy8XEXJ16csMAHUkz5RnDX56eYECUedvgb/p5B2ckHtxlbWhF62JCx4y1txal
	ZS9I0NwLyFfOUVfbVR4H9PFrZhPPbxD8=
X-Google-Smtp-Source: AGHT+IGgOnk3snmVp9iOELLat1naRIs7tWJM6qTxPRGkIqZi8cFJ6qrWXxZXVnyGNiJDeHAiJUOpBc00+RRJWBc2cD0=
X-Received: by 2002:a05:622a:1211:b0:460:8444:d017 with SMTP id
 d75a77b69052e-462f16e3ea5mr323331cf.27.1730848202176; Tue, 05 Nov 2024
 15:10:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-13-dw@davidwei.uk>
 <CAHS8izP=S8nEk77A+dfBzOyq7ddcGUNYNkVGDhpfJarzdx3vGw@mail.gmail.com> <f675b3ec-d2b3-4031-8c6e-f5e544faedc2@gmail.com>
In-Reply-To: <f675b3ec-d2b3-4031-8c6e-f5e544faedc2@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 5 Nov 2024 15:09:50 -0800
Message-ID: <CAHS8izNfBEHQea3EHU7BSYKmKL9py2esROySvgpCO48CxijRmw@mail.gmail.com>
Subject: Re: [PATCH v7 12/15] io_uring/zcrx: add io_recvzc request
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 2:16=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 11/1/24 20:11, Mina Almasry wrote:
> > On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM David Wei <dw@davidwei.uk> wrot=
e:
> >>
> > ...
> >> +static void io_zcrx_get_buf_uref(struct net_iov *niov)
> >> +{
> >> +       atomic_long_add(IO_ZC_RX_UREF, &niov->pp_ref_count);
> >> +}
> >> +
> >
> > This is not specific to io_rcrx I think. Please rename this and put it
> > somewhere generic, like netmem.h.
> >
> > Then tcp_recvmsg_dmabuf can use the same helper instead of the very
> > ugly call it currently does:
> >
> > - atomic_long_inc(&niov->pp_ref_count);
> > + net_iov_pp_ref_get(niov, 1);
> >
> > Or something.
> >
> > In general I think io_uring code can do whatever it wants with the
> > io_uring specific bits in net_iov (everything under net_area_owner I
> > think), but please lets try to keep any code touching the generic
> > net_iov fields (pp_pagic, pp_ref_count, and others) in generic
> > helpers.
>
> I'm getting confused, io_uring shouldn't be touching these
> fields, but on the other hand should export net/ private
> netmem_priv.h and page_pool_priv.h and directly hard code a bunch
> of low level setup io_uring that is currently in page_pool.c
>

The only thing requested from this patch is to turn
io_zcrx_get_buf_uref into something more generic. I'm guessing your
confusion is following my other comments in "[PATCH v7 06/15] net:
page pool: add helper creating area from pages". Let me take a closer
look at my feedback there.

--=20
Thanks,
Mina

