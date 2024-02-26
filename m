Return-Path: <io-uring+bounces-729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1341B86726F
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 12:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B728728FFB7
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 11:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BCB1CFA8;
	Mon, 26 Feb 2024 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRdflU6L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0672C688
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 10:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708945168; cv=none; b=CDUDu7dSgOOBozgHbY6yOozPQENjcZoC/8XAsOherZ6Nlb4vM7mPlYxzoCf0WwMbVh55pdKV4qk4tvmSg8pv6OlcsRML+C9VTO3CjDXQXLkq42Yuv4VruT1kvPOtXkUMBhgbBT2CMfDUVTU5QdiFhYjIbMBfQJ2Ugplr/xVKFl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708945168; c=relaxed/simple;
	bh=o2FZMCLW8eUJX7Eaveg7EIPAoiyZQyUo4bmmBkOj4pA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oxb98lNkuF/7tovjPFNwLdH9U1BrR5fMdjW9o07G7rmc3pBirC6vtFb6nN8HL50S+d+T9RYDqgrfKpfyYiwLVgqVKhvOqNmV1LbKkOqfBW/U2XwhhfqCYcgDkAp2U51tJW+8pN5OBDZSFuDRup4PlEmWfzGXUoiesR2yWBarNNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cRdflU6L; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-dc236729a2bso2681183276.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 02:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708945166; x=1709549966; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBw404/sW7s/+gJ3+FrCUZPHPXMtZEm7u846XJB1Pd8=;
        b=cRdflU6Lo+8eDa1D51oPWdHF4CQMZoPE3hsDxU0Nr1DanIRDVXRh9NhMzs9NqTYLA2
         R7Ao4Mx5XLCl6Ezl0ID7t/AA6p39Bxj77ueGdbVzocM/QN2tfrJ62wRHubkzQe3DG4UK
         WUOU7hXnE1OKfZTSgbQ/jyQ8OLmO5Q2vmQ9Lw11Taia2l2IZ2ncsmXGxSDFfqUWviUPM
         ZY8Q9PjNqdvXw1x6y2zIt6pxjLX831BD2iDdcnFJkNWEbL9tXzTYbqwcPxiBzyw3HXMl
         dgSM3xWHT2pQmpNklAegAIPJVmDx13u5f/ovgp4kqnaZPg8VMu+trISXXdiBTTtqI3kw
         wIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708945166; x=1709549966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yBw404/sW7s/+gJ3+FrCUZPHPXMtZEm7u846XJB1Pd8=;
        b=PvCFqIzQk6m+2/UzDIUP8iCWCy+DP1t6DCbqN48s+NcUkKiXoAs/8aY/EjhCL5WTTU
         VQxt9tlJI/OiOIaVlKQZKi0OFiybYF1VNB2DBqFqED7bq/pMgSoI1f5XBwhadrHta6nX
         3/GaJ4ZbYC+V9xYEYz4r8hc0c/v/djD6WKu0kq173wwxO9Sb65LvXU2E/g7xJ0i7im4l
         +Mxbcu1YY5aHCX8kBV4z1g4cy0TMimX4zqXzffpyNLTjWZ2m/qiNA5zJ2TJ8pJvfI8Gp
         3F5p/uKDM5+3HhxZ3C+sMCN342X+o833SGd5ehumWkB78R/oNDmiI0Oz5/c8lC6bslIc
         opBg==
X-Gm-Message-State: AOJu0YyH1yiQ+LEmPQougdSt2UCybWb0XsPCG7PuYK1Oj2JMaiNpR+Ah
	OYQH3298kQUKT7Ilt3gbWuZbl8VHN7raWLmj4LKmGNkF3NZkIwOzEcKntKiDCnRkkA8M5+GC6YI
	ZZfn7AIeFuGEl9mxT5MGNMK/Dyo6Nr9D1k1M=
X-Google-Smtp-Source: AGHT+IG3+u23y+MKW1q3QDHzvIfZmKmJboQZ94JhX1WddcjS3VFg4HpREeQPWkcZdWs6RvthgqQdqjPwYotgVYkx1yI=
X-Received: by 2002:a25:7805:0:b0:dc7:4951:5f8 with SMTP id
 t5-20020a257805000000b00dc7495105f8mr4286150ybc.22.1708945165755; Mon, 26 Feb
 2024 02:59:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240225003941.129030-1-axboe@kernel.dk> <20240225003941.129030-9-axboe@kernel.dk>
In-Reply-To: <20240225003941.129030-9-axboe@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Mon, 26 Feb 2024 10:59:16 +0000
Message-ID: <CAO_Yeohfx1d1Hdopu=0-b3-dKVM1By=unnhHFQHsqCwH=HJSvA@mail.gmail.com>
Subject: Re: [PATCH 8/8] io_uring/net: set MSG_MORE if we're doing multishot
 send and have more
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 25, 2024 at 12:46=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> If we have more data pending, we know we're going to do one more loop.
> If that's the case, then set MSG_MORE to inform the networking stack
> that there's more data coming shortly for this socket.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 240b8eff1a78..07307dd5a077 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -519,6 +519,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
>         if (!io_check_multishot(req, issue_flags))
>                 return io_setup_async_msg(req, kmsg, issue_flags);
>
> +       flags =3D sr->msg_flags;
> +       if (issue_flags & IO_URING_F_NONBLOCK)
> +               flags |=3D MSG_DONTWAIT;
> +
>  retry_multishot:
>         if (io_do_buffer_select(req)) {
>                 void __user *buf;
> @@ -528,12 +532,12 @@ int io_sendmsg(struct io_kiocb *req, unsigned int i=
ssue_flags)
>                 if (!buf)
>                         return -ENOBUFS;
>
> +               if ((req->flags & (REQ_F_BL_EMPTY|REQ_F_APOLL_MULTISHOT))=
 =3D=3D
> +                                  REQ_F_APOLL_MULTISHOT)
> +                       flags |=3D MSG_MORE;
>                 iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len)=
;
>         }

This feels racy. I don't have an exact sequence in mind, but I believe
there are cases where between
the two calls to __sys_sendmsg_sock, another submission could be
issued and drain the buffer list.
I guess the result would be that the packet is never sent out, but I
have not followed the codepaths of MSG_MORE.

The obvious other way to trigger this codepath is if the user messes
with the ring by decrementing
the buffer counter. I do not believe there are any nefarious outcomes
- but just to point out that
REQ_F_BL_EMPTY is essentially user controlled.

