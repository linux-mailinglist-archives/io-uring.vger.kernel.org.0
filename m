Return-Path: <io-uring+bounces-8836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF71B141C0
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 20:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91A713A6BD9
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 18:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A2521E08D;
	Mon, 28 Jul 2025 18:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ks/LWNRP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C4FBA45
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753726317; cv=none; b=McmVPKkS3uT+Dkc6O9g9QqfJcr0MqzSAbZsGvogeUkD+WgwLW3P0owBe3J/gA6XevxHOuqXFoRNrpi0f2QvIczC2js/7RtoqZQjxCpnkGPpqvor+RAKGhkHecrzreTy3W9D6Uzz6Kfejyh38ITTXbqXTvfK1pw3ExTmyK05eG04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753726317; c=relaxed/simple;
	bh=E0aZ5ltePXU2tr39eM4OyimHIPNcEOkRmRYfDURu1Nc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XfGzC2/qL9Fu8h7UItwEGMPqbHAO5T2S715fufXmu8MxvMoayVB97ev9zMgfofDtn/KFtfckqY/cR+b/NQnuaL1/KT+hcDvDRGmfenxUqW/1jFcbcv+404pnSM3sIq2PrZQzYMVdqtR2usbXZcQd+860hrAQUN3pWOC6knwxIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ks/LWNRP; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23dd9ae5aacso21135ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 11:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753726315; x=1754331115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWrTGKCGEGfsZ4s2TOJbLUNCxakJMocxAgR9drUPZeQ=;
        b=ks/LWNRPLsZmDBzViHD6mXGaSWHc3pDG2oHf6TZut176LCmlFEKQ6Ki0TgQfHcFsUF
         JskzyT7e7jytCF1TEbcvi6PXer0esj5Y+nNQD2sKk9zSu4KeODGaAaDw/t2OHkH12bAw
         U8NTv1st4OPUDfFa55Hh6JmkPcEFlfFH4RKm0Fb4EN3Bgb3uJ5MYnKk1dCCjS9q+l/d8
         2ql3Y1+frATAaFeZnR/+PsFvGQKvwz33ss9BRStcq7lp6mRO5mpyqz+9mF8VLu0eyVaV
         RdpqBCMizeEqk0abIarwCD73PV0p8KXRwjNaClxPVABKyjLCOc4S0CRZtDYhzXglv7UX
         NngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753726315; x=1754331115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWrTGKCGEGfsZ4s2TOJbLUNCxakJMocxAgR9drUPZeQ=;
        b=mLldiBUa/rbb6pd8elq9SDxP+E1ktZIP9YASYN+ntz3YTlfOaAvnxtXRIajkfmcaAb
         XbgVfkN5bcAEWQXaXJ0LampZ73uVxz9u6c+iA+i84C5iFSXhtEyoLOjfy2IKlZ242qBV
         pFDBcLoxKC7evsK5dX8SbHCQjE987k7zLrUBq2ReNaoN5pWo8L79QGKtyJBulwQ0c/8e
         GHwVi9pvVjm3+OIOY7AwA2J9vhfiZ2wMxNpon916sVRsKy8/IbispiJmabonIyAmtwNC
         mVgb2jMcB3PGxG/NkPJeWSS/P3S+EtJZfiYmF/oQ07gBZ8T/ZLz4CXw/eiNgajkZWkqw
         E1cw==
X-Forwarded-Encrypted: i=1; AJvYcCXPncKWLXwrFuA0DRi++RR+wDOkyLG86gkWC9KZ0CZiik7e4bgGgQ7p3Fj2ulWSrwnpY3k5tma/Tw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGCVFzXiZLbC7W4T5q+q5vsY1pFI6MlZB4ED3dFmsMIrIdQR6a
	QB3biTIpCujpDeLOEnAEsDfpUyA8k3+aZEaaDc+M+lbTvT3fb2JnNDxAzzv/igH5knnYwswfj1X
	8MVfenUaJWchBBWoncq119yoPsamXZDZeXqwAxWJe
X-Gm-Gg: ASbGncsxRjOyyJXuUgqSQmNGTMOBvYOQldWOMC7/CjO9c6X6UBYIm1H5vG4TQW2ifYz
	FC8VJZs1OKy7wvMos3+pusIon9GEj986jIKaoYDs1+SlAcfI1J9LNA+AvtOopADI7fz3aLoPFW6
	I13JCxYzfzR2FKmShWw17QpKGfsxke/0sFu5E2nljQ8Jaq8vg5QZgnFI3PqHBdGjahxfyPSnEol
	xHeAad3MGRn0DdaTo/T8GOFP08Equ8zD31qdQ==
X-Google-Smtp-Source: AGHT+IEbF6oW+7FfHRssAd7lvdEZmBJqJX7xc2FzdGeBBdXR/cp8CUttG7vSZuTX1Aoawhbozd8z21A/66I2sgi7yDQ=
X-Received: by 2002:a17:902:e890:b0:240:3c64:8638 with SMTP id
 d9443c01a7336-2406789b433mr265765ad.6.1753726315246; Mon, 28 Jul 2025
 11:11:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <e131c00d9d0a8cf191c8dbcef41287cbea5ff365.1753694913.git.asml.silence@gmail.com>
In-Reply-To: <e131c00d9d0a8cf191c8dbcef41287cbea5ff365.1753694913.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 11:11:42 -0700
X-Gm-Features: Ac12FXw5Q6EZZJ_i95sjCdIxpCkEiHb1OpsZvkKkuTR8Kp9jbXcTTEN4sj2bIT8
Message-ID: <CAHS8izO-TyoKd8qu05H3BKrD=eYST3ZKKd3rtdrYZQwuVQ58dA@mail.gmail.com>
Subject: Re: [RFC v1 01/22] docs: ethtool: document that rx_buf_len must
 control payload lengths
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Document the semantics of the rx_buf_len ethtool ring param.
> Clarify its meaning in case of HDS, where driver may have
> two separate buffer pools.
>
> The various zero-copy TCP Rx schemes we have suffer from memory
> management overhead. Specifically applications aren't too impressed
> with the number of 4kB buffers they have to juggle. Zero-copy
> TCP makes most sense with larger memory transfers so using
> 16kB or 32kB buffers (with the help of HW-GRO) feels more
> natural.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/networking/ethtool-netlink.rst | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index b6e9af4d0f1b..eaa9c17a3cb1 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -957,7 +957,6 @@ Kernel checks that requested ring sizes do not exceed=
 limits reported by
>  driver. Driver may impose additional constraints and may not support all
>  attributes.
>
> -
>  ``ETHTOOL_A_RINGS_CQE_SIZE`` specifies the completion queue event size.
>  Completion queue events (CQE) are the events posted by NIC to indicate t=
he
>  completion status of a packet when the packet is sent (like send success=
 or
> @@ -971,6 +970,11 @@ completion queue size can be adjusted in the driver =
if CQE size is modified.
>  header / data split feature. If a received packet size is larger than th=
is
>  threshold value, header and data will be split.
>
> +``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffer chunks dr=
iver
> +uses to receive packets. If the device uses different memory polls for h=
eaders

pools, not polls.

> +and payload this setting may control the size of the header buffers but =
must
> +control the size of the payload buffers.
> +


--=20
Thanks,
Mina

