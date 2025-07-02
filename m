Return-Path: <io-uring+bounces-8586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE263AF63C4
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78CE4480D2E
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 21:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD54238C1A;
	Wed,  2 Jul 2025 21:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="eJuEA5uR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4762376F8
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 21:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751490715; cv=none; b=IJX3HHuO/PN7r9H74jtOXjSI2ecKLVKKu7G6JZxlQLHIpM77DU5jDt8x2QjpHyqI1IMGNofPy5aikFBkflGScMBCpjR8GZ4e2pZQjHXeiHiqz8p1jzE2iqv+XQFdMwyKeGdkyGDn7r6LU9GNuWntnWp7DdsZN9iltLoHOOmSnpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751490715; c=relaxed/simple;
	bh=r4ycxoolYmuKX0m2fIW1oV8sY58bOT134WmsNhkmxdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W/seeKYvqHkifNP0qlfLMO5Q+59hsMTeDV8Q14MqDmkcVngTeZNeyJV5fuO0+LbgNYb7UigCUD5xfTn5OSvvi16KDyxt4kyKbiQzJRn4uvvLQYi8TWELFa4rXPi4J+nSSvmloMxqEmzy8u0tNrOXRrIaQiPaB6aIjIYn05MXZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=eJuEA5uR; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2369dd5839dso12901405ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 14:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1751490713; x=1752095513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sHPw+gFNU4kcte4+DjGEOa7pSlzMKOzoy1+5anqcCg0=;
        b=eJuEA5uRye4ewsbqqtf3mko+4VCMtWArFtfxu+IphRRxyCpyR19cUc+9vvbruZq5v2
         eDHL0HK2i/e0kibposvkeF/M9zToe21sUJ4XygzHek51RnbkGB/GVlcLHlDd/b8kag2H
         UsKnWEqPtgzn8QH5NY/yVYcjNs7cSyeB6FPdBArimfEnPWJvi1kwbQiVK/7pRIUyrRBf
         wvlNiMEaaDxkZQFN1Ccrxs8UrujlKG49AdzAn/95s0ALMgXyRQh4Pu2DyFQ9zc4loIUs
         bmWV0OUROTySQP377KJNTEwM6p1oZ3aLEsFMDq9KGtndcnpzp5vt906JNTe0LoVQG9Qg
         By2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751490713; x=1752095513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sHPw+gFNU4kcte4+DjGEOa7pSlzMKOzoy1+5anqcCg0=;
        b=tuFI6gze0bRtCP3Q1MkRlLQTeGl3g3KgSfvJ9E+a/UmPxpAmDmEz+ZYxjNraGvCbHJ
         T+r80JdFnB8Lh8lYDGYeqoAdTUXrbYBcsg/c05zM/Su9XJwGH7VkwabZr2tHlej8Yuuc
         mj9+nx05AxKFncdZBvQfMoogtKbt6ApdGKlubapFaW3HKtESWdpxumDak75mX0+08U5F
         UbhB2qAXttc6/vBezzXDM/89uocLvEnilsVjA96aR4orHuiXJ/MJvVg9acuEFzU6J5Di
         frecfzkmoaAOS2XOlBalIaIcEWF15PlyOz2bHsRRzW23HQj6jZy9DKiULvu19PogVuod
         LagQ==
X-Gm-Message-State: AOJu0YxNlPgyEtePEQ+ONnWYoGi0je2rvESKlWFcVepwquDg8Jo3fQ9O
	Fva/mEiT26KAKdiDDN4v7890dAiOss8KcXbLJb41sZ3DLeyHYSOBzZasoQi3ZK+7xJjmz5Nu7z+
	8+98DUQQOoo5jqNx6bcucrUj1KX+kVyGgbQphaCpBxwBs4KKR1qQlcQc=
X-Gm-Gg: ASbGncsaCGQRCKv+f1UfTNs2+RBpo19g6jfq52nu2itEQfdepmSxT3VvoVMsyQOUWd3
	M8vd4jpAk2NyJIhUaT9FXBWCHNwJrTOyrSkr76LM36pLTfKK0X5S0H/17/uR3jpYAmEvs2u5Q10
	k0609qcxHfBLwgcOTi9PAIkHzs6+/fVsE92nh2/TiDGX7J+t0hr2hA5A==
X-Google-Smtp-Source: AGHT+IFuNZwePMXtrGGiy+Lal9FBipRUHE+tVSTERSi9lHrrMb5JTmkuRgmPnmoBG4HWQ7kRECEakR5dz4NREEM6yVA=
X-Received: by 2002:a17:902:d4c5:b0:234:db06:ab5 with SMTP id
 d9443c01a7336-23c6e50f8bcmr28811895ad.12.1751490713407; Wed, 02 Jul 2025
 14:11:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619143435.3474028-1-csander@purestorage.com>
In-Reply-To: <20250619143435.3474028-1-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 2 Jul 2025 17:11:42 -0400
X-Gm-Features: Ac12FXyYeIjTfBC7VX_f4PgJXEIGElJPaVB7WXMGWA-c8qyxwbh-DBbEEDN0jU0
Message-ID: <CADUfDZo5O1zONAdyLnp+Nm2ackD5K5hMtQsO_q4fqfxF2wTcPA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: skip atomic refcount for uncloned buffers
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,
Any concerns with this one? I thought it was a fairly straightforward
optimization in the ublk zero-copy I/O path.

Thanks,
Caleb

On Thu, Jun 19, 2025 at 10:34=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> io_buffer_unmap() performs an atomic decrement of the io_mapped_ubuf's
> reference count in case it has been cloned into another io_ring_ctx's
> registered buffer table. This is an expensive operation and unnecessary
> in the common case that the io_mapped_ubuf is only registered once.
> Load the reference count first and check whether it's 1. In that case,
> skip the atomic decrement and immediately free the io_mapped_ubuf.
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/rsrc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 94a9db030e0e..9a1f24a43035 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -133,12 +133,14 @@ static void io_free_imu(struct io_ring_ctx *ctx, st=
ruct io_mapped_ubuf *imu)
>                 kvfree(imu);
>  }
>
>  static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ub=
uf *imu)
>  {
> -       if (!refcount_dec_and_test(&imu->refs))
> -               return;
> +       if (unlikely(refcount_read(&imu->refs) > 1)) {
> +               if (!refcount_dec_and_test(&imu->refs))
> +                       return;
> +       }
>
>         if (imu->acct_pages)
>                 io_unaccount_mem(ctx, imu->acct_pages);
>         imu->release(imu->priv);
>         io_free_imu(ctx, imu);
> --
> 2.45.2
>

