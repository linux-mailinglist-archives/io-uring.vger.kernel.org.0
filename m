Return-Path: <io-uring+bounces-10199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B879C0747B
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 18:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 214063A3E4F
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 16:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F112566DF;
	Fri, 24 Oct 2025 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="L1CNAPOc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4EB219A79
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761322938; cv=none; b=S5jwlz/ZEFBJAUMMYtZYev5w3nFqMrmMKsicHBMaVgpvReFbbjpZpv/lVgkmIGS3LybwEgVT5Le9FlsZkFM2975h7pZQLkyJy16eCiMsF/apAv1j1tDNH05KW4c1DvV7xY6UoClxvfS1J9lzb5GUj+89EwF6/nxU3EeIqI8i7YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761322938; c=relaxed/simple;
	bh=YqIu1Y5bvwLvn0u8d007kqJbMWYQeMjJqPgfXDz6fPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f6kPKntS5X/hn1vpBXmdN/xIHZ1OdsWXC8/lhsDtFAxJdRmw7E2d7A/q0e7yciZI0aa6dS6soiCCpGsYjwhydAXs8itbcQmWJvqbcjxleN1YY2pRdmm+YZjgioiZdxNyU5mowM+b9Wyhpumhn+XBC0W6zLn85kG4JGpEzt7fpzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=L1CNAPOc; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a275143acdso156108b3a.0
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 09:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761322936; x=1761927736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRtgNQIpY+Sy5XZ8eBVtMo/ZDVVnMe0fC1zfSz2xam8=;
        b=L1CNAPOcMWPxYgchxL4fW5xCT9H9Uc6LY2IBkAOl+UTC6Ii/uPyvCPIq7KS84Rovxe
         /OOpuFUewjaluljFwdxKn9HE1agm8dOVBztRzihDL3GBvrU31Dc48nyFmb7bpgBT1d4q
         ZtYOxf/sDcILpmr8e/LQ9d1xflNgBN0dbTgN9050ZxKf3HKEhITx9saSFwq0fnpcrLmX
         3rZ0WBNrdx5N9J8qy7U7vdlEdUfuvh812i5PStC+KDbaeAyZhC3LtFNJrR6yLemOmG4w
         ZGaSLVxshpW8otRy8K2L8Ih2hoEzVfSKvvLNWaFopWrF8Io6muUSoVG5lxhp7jf2fzXF
         doDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322936; x=1761927736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WRtgNQIpY+Sy5XZ8eBVtMo/ZDVVnMe0fC1zfSz2xam8=;
        b=wQzyysHfv5bwpWa7UBRwBkngZ0G2lIGvuWAWPit73OBeMNCT24kWnZbTMLmqQPP14P
         DCaTfcuRMxrtL00M9mXckj00WurBjfCUNSHqUaDALTthcHKP9LQvpFLGbbriYdUEmBZ5
         Jcb+I1wU2I/xMC+KH19zlseFcq2qfQvjVCsCUnUtQyDjSE/E64nMPfvzgQrYn1XESn58
         9fuEIl+6mVJ1Chyr3UsxfxE4Y2e7RL3/FgVKgn4+qlMz58rQ1B0/AK4+7EiBo9I5Zg92
         LKQfWDr9Lpl8D1Obzc1jBIxzrCqQu6ymwtdJHnNQRHcahP6C761PlHBO5SidN71tkKJW
         QspQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgba98KSSNs2hPr4bHUDEeKU7qMpat7Z0GgF9UhUZw4yxnR8NFI3mAD+zVq8n4+zdiuk8b8MCCaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyweT83RbAYVZSLtLubuhsM94OFGOlzIbb0nVOIhTu6DY05vS0w
	aFQConLB1sT3EuDX01ReUgjsCFteEhoY85Xxy/gOYM5GW+BCpl+82ZzpWAhPMTdnorP1xMUaRn0
	WaVlW6ahUM5nA+v60/DnbORC9tRx//4kyxmswncyKmA==
X-Gm-Gg: ASbGnctbeIxgt6F12MUa7q3aeGG8djcQTF2SWhGFgIkuyLK3b+GhOFVV8gMBKUkaR6f
	hIpNmApCelxgdtfOqQ7V7bWb0ZjUOcwHpe/6+8AhXln2byizh4hnlc9EHLN9T+8dQHl0CfMPYZp
	WGj2K3Hw29GIqlSaTZfaEYVs+0dew9XR7Zfhkq6EqlQAKshtuo5sJv4Rjz+mKMGqS/8OVqXB1oN
	OMozUGw9Vbmeh9yKuoq7e/YNBC5wZU3XAKRNgwzQ3czBXWPuTLVNsL9LMWsYMS7AQcIbHhoiI6a
	S6gSwPWor5bLVTkcpF+EjunGpdcc0A==
X-Google-Smtp-Source: AGHT+IHEWyIOM2ae/6oPcMSQQ+jTRdgWbJrPgW4KNCdvATifDYinjecT9ZdfWmdWQfoYiNX/fIVC0FBxQkKEdJKooVU=
X-Received: by 2002:a17:903:234d:b0:290:8d7b:4041 with SMTP id
 d9443c01a7336-290cc7d4ac9mr179691585ad.10.1761322936188; Fri, 24 Oct 2025
 09:22:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024155135.798465-1-krisman@suse.de> <20251024155135.798465-2-krisman@suse.de>
In-Reply-To: <20251024155135.798465-2-krisman@suse.de>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 24 Oct 2025 09:22:04 -0700
X-Gm-Features: AS18NWBysObsPcSgO1w_fiMUy_pvcl10G4LG6k9BBHU8pvspCsso1Xu2qmEsevg
Message-ID: <CADUfDZpefFLDygAeAMruskenTL+e9-yT7uBNZkME4xjbmbE5Mw@mail.gmail.com>
Subject: Re: [PATCH liburing 1/4] liburing: Introduce getsockname operation
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 8:52=E2=80=AFAM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> This implements the functionality of getsockname(2) and getpeername(2)
> under a single operation.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>  src/include/liburing.h          | 12 ++++++++++++
>  src/include/liburing/io_uring.h |  1 +
>  2 files changed, 13 insertions(+)
>
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 83819eb7..77b0a135 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -1572,6 +1572,18 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct i=
o_uring_sqe *sqe,
>         sqe->level =3D level;
>  }
>
> +IOURINGINLINE void io_uring_prep_cmd_getsockname(struct io_uring_sqe *sq=
e,
> +                                                int fd, struct sockaddr =
*sockaddr,
> +                                                socklen_t *sockaddr_len,
> +                                                int peer)
> +       LIBURING_NOEXCEPT
> +{
> +       io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, sockaddr, 0, 0);
> +       sqe->cmd_op =3D SOCKET_URING_OP_GETSOCKNAME;

Can this use the recently implemented io_uring_prep_uring_cmd() helper
instead? io_uring_prep_rw() assigns to the 8-byte field sqe->off and
sqe->cmd_op later assigns to 4 of the bytes unioned with it. That
leaves sqe->__pad1 initialized even though the kernel requires it to
be 0, as Keith described in the patch adding
io_uring_prep_uring_cmd().

Best,
Caleb

> +       sqe->addr3 =3D (unsigned long) (uintptr_t) sockaddr_len;
> +       sqe->optlen =3D peer;
> +}
> +
>  IOURINGINLINE void io_uring_prep_waitid(struct io_uring_sqe *sqe,
>                                         idtype_t idtype,
>                                         id_t id,
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
> index 44ce8229..365f0584 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -950,6 +950,7 @@ enum io_uring_socket_op {
>         SOCKET_URING_OP_GETSOCKOPT,
>         SOCKET_URING_OP_SETSOCKOPT,
>         SOCKET_URING_OP_TX_TIMESTAMP,
> +       SOCKET_URING_OP_GETSOCKNAME,
>  };
>
>  /*
> --
> 2.51.0
>
>

