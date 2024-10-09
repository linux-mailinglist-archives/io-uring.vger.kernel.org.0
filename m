Return-Path: <io-uring+bounces-3533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E8799777D
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D28DB21463
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D261E1C30;
	Wed,  9 Oct 2024 21:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iny9wZto"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBF22119
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 21:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509398; cv=none; b=El5Wy8UJD7+3h4uElNsU37ZKiP00+6Lvjz1gwBOued05O/5eafK8QBysqw6SEOwsg32vGpNvbMzyCKgqw7TdCxYofptOnMO6N2SqdzwIgAmea3hBwGjt9Ab+45Y8W3KnahEIAvCLeavMX5u8RUFljzTpsfyU7QmKgnPQ5z7RShE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509398; c=relaxed/simple;
	bh=fn76Svm8OiX1t6y3rwEUHt/hSEryZJBd25LbsOLHIXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LVx8bn+OVbITPmLNq/nRJWA7U0+YJ51s3v3ORrI41fLyK+tYiO0LAgR2aBwBk6tLx9ulGsQ3Ehtbi50xE+GbyCTy35GAgDeF6Vwk07Ctv6EnRXbqHbDN4369gecPaHlZqeAaLgbKh3BRcU5oBSczB6ZMcHIn2JbDvlUk+wBI5A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iny9wZto; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4603d3e0547so95391cf.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 14:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728509396; x=1729114196; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fn76Svm8OiX1t6y3rwEUHt/hSEryZJBd25LbsOLHIXI=;
        b=iny9wZtotDvRdyN4ZzWNyXIAtGtLK8OXXpUyCQupDhnFjiP45OPspycSDVydZfmp0h
         GABVtjMVIhVZKUGeXOIBbAoAZRU3lfZMEAoWF8n2Zl09fxLSErSCaAoX1Y5ANFrS7dP6
         Gh4hUeAuMjkMDeyusEOUskOht70q4c4nNHUlYyBiclQnlJ/HKNsppSf7M0xx0zLworin
         OU+jBIEN1uetITSYIOqyHYSqcMGVu2uffPqEYak0AhwYakQn1iWxpgsiKeLOiJlU0Ww5
         2pGkGttfgzqipn8mxY73XnDLwncP+pFXLYyFxAwqKBFeYl75MWZjsjL3gnSYH+702XgH
         Lq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728509396; x=1729114196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fn76Svm8OiX1t6y3rwEUHt/hSEryZJBd25LbsOLHIXI=;
        b=KdxTxOkC7jBDlDmaQhFJsbvx6zPLiR/1ntbbuxLCOTgOvhi1bGn9EV+Td7DI8ZgTh1
         bdTBa4q2zGOcrab88MyNTNyid9ajn5mQv+PM3wcMf1Dj4nMqyQ0R6SuKiAlrGEM1nqGV
         9Tw4Rd2c+qOLe3FDAHBtrRN4S9YizeiczNjU7cPaC5gPnM9wDFiTA/67E/ypzAdC0bMM
         bARNJwir6s5dF/ERYH/qM6vbihWX687IncmX05eKMNwpHQTMNy8dhEW8wSFp3k8aQ7hr
         Ok+u/sh4Brmf2/UTJeUWG3zBA5M7jpG3TlMUwNJW37uZ7DWwePJ6u9LMrTcSmiJaHlrM
         5m+A==
X-Gm-Message-State: AOJu0YxZZ34NF68JB/QCjUBCG8sYuoZl9cHP8Bk4n2PhtZ2oafMufDmY
	ua9IQeovL6E6tmvOw8LRVMJKbpeUJzynTINM+Er0FcYq6AF3QY70+V34iedv30tHIYgdWAtKZZG
	uzFqTLQ0PFvORl6Mi4vQnPOingw0YIFraTApy
X-Google-Smtp-Source: AGHT+IEmUrVTOR01x0sMOaDeSFo7MLqbhWFmE6974LVCsvUmTt9WB3PMswxlZAHTXDkBbEUP4EhsNOtnIYy2oHrN+2M=
X-Received: by 2002:a05:622a:8387:b0:45e:f057:3fd6 with SMTP id
 d75a77b69052e-460404743bamr1186711cf.20.1728509395628; Wed, 09 Oct 2024
 14:29:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-11-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-11-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 14:29:41 -0700
Message-ID: <CAHS8izNChXnQaMS5X=--e6Jz6OZGcJsgoSH4D6r4MEmFhxxdyQ@mail.gmail.com>
Subject: Re: [PATCH v1 10/15] io_uring/zcrx: add io_zcrx_area
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: David Wei <davidhwei@meta.com>
>
> Add io_zcrx_area that represents a region of userspace memory that is
> used for zero copy. During ifq registration, userspace passes in the
> uaddr and len of userspace memory, which is then pinned by the kernel.
> Each net_iov is mapped to one of these pages.
>
> The freelist is a spinlock protected list that keeps track of all the
> net_iovs/pages that aren't used.
>
> For now, there is only one area per ifq and area registration happens
> implicitly as part of ifq registration. There is no API for
> adding/removing areas yet. The struct for area registration is there for
> future extensibility once we support multiple areas and TCP devmem.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

This patch, and the later patch to add the io_uring memory provider
are what I was referring to in the other thread as changes I would
like to reuse for a socket extension for this.

In my mind it would be nice to decouple the memory being bound to the
page_pool from io_uring, so I can bind a malloced/pinned block of
memory to the rx queue and use it with regular sockets. Seems a lot of
this patch and the provider can be reused. The biggest issue AFAICT I
see is that there are io_uring specific calls to set up the region
like io_buffer_validate/io_pin_pages, but these in turn seem to call
generic mm helpers and from a quick look I don't see much iouring
specific.

Seems fine to leave this to a future extension.

--
Thanks,
Mina

