Return-Path: <io-uring+bounces-9085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEEEB2CF00
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 00:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04985560CAB
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 22:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D1A3277B1;
	Tue, 19 Aug 2025 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/KduMwC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F88E3277A1
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 21:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640678; cv=none; b=TOFhcg84ft7Izn92vH7IQkO6pPZqYCV3P3HlBJZIHw7ZjD+9EQWPXKR1/E+9+Th7TW+40qvdk6hb6ONgzCILlfNZizANDItwroES//3ltZKTnRBEcaKWjTMG5dguClNevLJU2XEIv7R2cVbg0HYvB5MZAdW4TeTsW3x4oJzWXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640678; c=relaxed/simple;
	bh=CvJtxLbc27on48vID65kXKtMHxJ5HMnLMk4STwfZJ9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HeI1F8Gg03eAq7hHmgiJHYXoFPUNgxowT4ogIcQfpCMeTLSFX4W9Ky/Dg67lIVF9OxKLCn/prOgf6xtnzNKehLgw8jzbMYO0B33oqnFFCnOHt0yQhk6tlvJF24kX4lCRJOXyvTNgTgW2pEE9dZG0xLGJC5zhGZGr5m+I4/vRm2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/KduMwC; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55cef2f624fso653e87.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640674; x=1756245474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvJtxLbc27on48vID65kXKtMHxJ5HMnLMk4STwfZJ9A=;
        b=n/KduMwCc9rjzThjM4rt7oiPlGe25BI86/yktxRQuzW19y5MEbUQsBwjTAckCACiGP
         UbrMx1DPZsDwWWmbMoJUwWLnjlGp2Td5gU3gTiCncXOx0ddTZ1Eb54BmhuPCmCIZkcDA
         QIUP3WgNJY9y2taXuQmQyd3wcQp9UDI/2dRu3h1qdCqgPqWvZmp+pqh+0IfXKL9XU6at
         pBBv3KEqEtflpsB5CzHbRnLF6vcF7M0oJJ9Qm8wWXcQ2TIAm/LPq1EMCbZZ6Q6nVCM2g
         58eCD3PSxSluZFV8EEEMoSk3zfNtckJiTFlO0fj9xRW5fHs6eIlNOhfzBz5bq8RyEn3D
         NTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640674; x=1756245474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CvJtxLbc27on48vID65kXKtMHxJ5HMnLMk4STwfZJ9A=;
        b=f6Ix6wHbQg1qcKTvaQcko0e64ggWOrEjxfv1bcFFAXgrNqqLP8d7PiKZOG2hWcjLIo
         N1prpv7hPf4azsp1CISOXWbagwRohqR9AwAXov/FKiLwPPSnxXymeG1or8Mm0wxlgnd9
         UATR0jlPJ+fvgDGcoAHeRP2WPMGk9V37XpL1x9dzdA3BjssUDvpIBQD9iqWaW7fQGSW2
         DMe4HCSUWc8G4HoJABPa8kUsAsX3Qz6bGyKksPoFeRyu1y90ED/JB3c+mq5Dmu8NxwEd
         3lvmSGrbeTKkrK5Yz3pSXI6SbC9Lcw8YyFFYc1qPviy4XqPQGPjIY4qmdWnynGafUsgl
         RbDA==
X-Forwarded-Encrypted: i=1; AJvYcCVLb32KkwjoNztEtBlwZnGs+80Pn5kGUKOyv7Uatj6if6R9r6nXABpz+/S1TqrxtGB78KG/ZdDt/g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4Ljv+92Vorsh3b9IhxtEccmqIwukcCmJcTWDs8gtR3rbR7Qc7
	pYFS8XQdZKyM6jeIOKry/9tSc2MuMB4UQe4GLF/CM9wlTxAxN6T21pxIbyHo5maLo/rmu1QX5/K
	TPsial8JcUkDnTm/mioprgIJuRJ2xmsmnG7VT3jP1
X-Gm-Gg: ASbGncugUKIAaysGr419HgZYMniU2ytHKjgWAeCYWP/dyZ1rFbvFfVsCpGHBOhEYeul
	wMvFVoyjmWD+aB6V/An2AKiRSwp3o/1iCq2ePliPBlw7G/UxnInOWvwFn/WWyZXxoz+81jwXg46
	LdYTIHRJnTcou7C9r/4+x6v+sLm4fRn3pz0DfS7dIP+bvArYBV09s6BvXZTCBt6YVET0hoTRJ40
	nRSC2/hKCNefRiwOcAdUlyGRhN1477m0Zy6aVqNCDE2n1at9y1B1Wg=
X-Google-Smtp-Source: AGHT+IFjnm783G9/tzKiECTrCe8fFRAJeZ3G/drDLRd9Ku7K+BYBH4Eh6bxrOn+3eJeQcD9yP73r6e7X+DEQbcuDRLk=
X-Received: by 2002:ac2:5e36:0:b0:55b:7c73:c5f0 with SMTP id
 2adb3069b0e04-55e06752de0mr73920e87.2.1755640674063; Tue, 19 Aug 2025
 14:57:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <63cfaa6b723410ec24c1f7b865ca66fc94fe9cce.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <63cfaa6b723410ec24c1f7b865ca66fc94fe9cce.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 14:57:42 -0700
X-Gm-Features: Ac12FXwUdfa4vW85A0T9LBksUrTPzJOsMtQHo15Ay6MIOEBEQOu6vZwDcE8HLDY
Message-ID: <CAHS8izPM4QdvdQurnO1RYaHcW8Xq5yK21c0g4uuqbLJPdjTpNg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 15/23] eth: bnxt: always set the queue mgmt ops
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Core provides a centralized callback for validating per-queue settings
> but the callback is part of the queue management ops. Having the ops
> conditionally set complicates the parts of the driver which could
> otherwise lean on the core to feed it the correct settings.
>

On first look, tbh doing this feels like adding boiler plate code
where core could treat !dev->queue_mgmt_ops as the same thing as
(dev->queue_mgmt_ops &&
!dev->queue_mgmt_ops->ndo_queue_config_validate).

But if this is direction you want to go, patch itself looks fine to me:

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

