Return-Path: <io-uring+bounces-8968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66063B27D05
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 11:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD2CAB06B7F
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 09:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C72526059B;
	Fri, 15 Aug 2025 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmB/GsHO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F971259CBF;
	Fri, 15 Aug 2025 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755249463; cv=none; b=ApbXFzL/4aipjYB8jPa1rwpYOJUbuPsuyGIhXQQZiPaaS19t98xTB7mzB3mb9saSPhhct2Wa2PXOzLG2SL7CdokO1LmF7Oe5Xf4DIPWE5YUSzNUGGaLW3MItDpkXXDamN/U0qD4pNLjBnUV/5nFRW8GLK6PpX5tgpHm9nEUg7zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755249463; c=relaxed/simple;
	bh=4lb2nhzhOh4J+oq+Tf+VHBjUjMl6+VNGdCEVkE4qIt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sk8MVaUBw7yypk3o+knQ7xW6YbEgeX7U+YdvTBmcqp62dj0flE0D6XB+AVkCRzgCiiYPbmFCi/nmyHkJtRjDcPTrpggjiE7qkdsOeeGfcAIr2qLH2VsIk4Gm2DRgl141dfLvwinmYb42KMEnDsBfzo/IMSZ1ie1Yd3l87kBVL8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmB/GsHO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb79db329so241537666b.2;
        Fri, 15 Aug 2025 02:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755249458; x=1755854258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrnDlRuXmoG8LkU7jAkwnOj3EM8GV8NHzXfjcHUe/N0=;
        b=BmB/GsHOKHEaRjKJSWEemUtyGMTwUQe40cKAoIIcReYPG2Xu3Qf+GF2sZ3ot4JwaP9
         +eiSRk+0g7aXNxQrwOMzGrlZzMrpclTsFFsUY0ugHJ693iOzV+DfdwcBqnENgGVLlrUr
         lWvNGkASJ3kGxdDXqVw/o4DaYMb9Tv2xUwTSV0IuKcYWgiOYU0AHXGxxz65+LFe4Zwfo
         pywYcb3cqSeN4HAwezdlClxTO7aCqj+7micvnKNYziLfGwWI87lpnQCn/OqXsbCerUJC
         Yg2+xRey1duwZmYsDIKndUso5eH2HVJtmW4u9oFifbmqw6aO9gl2lMTEjn3sDnkbVOc7
         JjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755249458; x=1755854258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrnDlRuXmoG8LkU7jAkwnOj3EM8GV8NHzXfjcHUe/N0=;
        b=iEjSbrgq4XQgczlp3jWkB3IrROnf4N5M+icAEjrLQ7np+J8DJKj3gwOMgZlQZgE3KQ
         2T69kqT3ObefH5p0PWsyXl5IH9DHNPbi6bSWdDO8NrmgfpV0HqnWikTCmF1ejUD20OX2
         zF9E5NWsOxaL47yXqt7DPORRyjIDzjvaegybD8lMVo7ZDiNis5ooa5/3F6Sda3bVyLJV
         J3PgwGy6H+a4jEeY3VETh0FMNWFZWrHodyin8LLi9iWJdTnRP/5I1h77GT/8Df/6s0Mn
         WVskGl9q0qjk/n8c2L93fDcAmmGDGTBsD7la0L4tf2jgrFT9hOcpUv3x0apJ775Yvfhh
         4Lbw==
X-Forwarded-Encrypted: i=1; AJvYcCVg/BJwm0ovgrJMiP+Vnd5imuPoWE09f+Zn1uHh+LZIVNrbtcxTlSeZCIpEg3H5CdCgpRBSHunqcZdzjsLc@vger.kernel.org, AJvYcCXnjyp2ixHiyoNQ+8v7TPQ75L/ipraU4ZbtBa8nNTErj1giLW/lhyGmOE6mRFnv5xY6Liv5Nb8dIacw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw38J0YqPxXRdPrJCijFDU8SSzGBTQ3TdQYj0pmqalH0LaPmedb
	HEJebPv6SNYrCOyNIvYUVtezuMn9nEG8zbBHZJ9lIomXmKYYaH98S7izu8X68IsbC4HEeoyaenV
	cKuSXY65wX6jMoxgNqdpVec0WhhY3k0k=
X-Gm-Gg: ASbGncs5sQQygkVPGDG7NnCwh02dqDyDb6lW30rp6iKy6WrlTQalh6dkSyPtDDeN3sh
	bT1zhqvlCGj0XatjRuPmOLYar6ATG0pn7mNsNhz8PKspOD7j8h7Sth40DRh445JwtMseZ2pJoVm
	N06MIUVxKPMneKTgqkUwHdW0wwOI2aTeEAngaTC392OdWxZ+hh15XeXcEj6FerqATn47WKT05PX
	+fArKM=
X-Google-Smtp-Source: AGHT+IHuXBMfyghsRB4ltM/E02Aya9aFwOzWO2c3Vy09/HrhEhzAiHccyzTS7sMQopaK/q0KoHre7G8IToVzJp719EM=
X-Received: by 2002:a17:906:c113:b0:ae0:bee7:ad7c with SMTP id
 a640c23a62f3a-afcdc288e23mr104940666b.46.1755249457698; Fri, 15 Aug 2025
 02:17:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com> <20250814235431.995876-4-tahbertschinger@gmail.com>
In-Reply-To: <20250814235431.995876-4-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 11:17:26 +0200
X-Gm-Features: Ac12FXy0btvM0I7I7k3TZ8czVbyLSOE2zdmS_n_URJM0jPRfM0nz8gZ-cz0aA1Q
Message-ID: <CAOQ4uxhhSRVyyfZuuPpbF7GpcTiPcxt3RAywbtNVVV_QDPkBRQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] fhandle: do_handle_open() should get FD with user flags
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 1:52=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> In f07c7cc4684a, do_handle_open() was switched to use the automatic
> cleanup method for getting a FD. In that change it was also switched
> to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
> of passing the user-specified flags.
>
> I don't see anything in that commit description that indicates this was
> intentional, so I am assuming it was an oversight.
>
> With this fix, the FD will again be opened with, or without, O_CLOEXEC
> according to what the user requested.
>
> Fixes: f07c7cc4684a ("fhandle: simplify error handling")
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

This patch does not seem to be conflicting with earlier patches in the seri=
es
but it is still preferred to start the series with the backportable fix pat=
ch.

Fee free to add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/fhandle.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 57da648ca866..dbb273a26214 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -409,7 +409,7 @@ static long do_handle_open(int mountdirfd, struct fil=
e_handle __user *ufh,
>         if (retval)
>                 return retval;
>
> -       CLASS(get_unused_fd, fd)(O_CLOEXEC);
> +       CLASS(get_unused_fd, fd)(open_flag);
>         if (fd < 0)
>                 return fd;
>
> --
> 2.50.1
>
>

