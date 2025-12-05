Return-Path: <io-uring+bounces-10980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0C3CA8706
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 17:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 83BC0300C52E
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 16:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300E1343D78;
	Fri,  5 Dec 2025 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ms7W5GFa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5103B327C11
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764953723; cv=none; b=i+4jqi23yfjeBFr8p1OHgEIF1lL16eZ/m72laM/u/4XGF6GWlZBMLip1F4mROQixVViHj6QQLHPnF8XRVSwWZdyW4E+ZN52dBVQJmGsNPRtrEJJiZaKKEDghi4C64k6frP+OqINqlEhAg0LydUXVJ10hQB7t63cQV+wU+XG5H+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764953723; c=relaxed/simple;
	bh=416u1D0GOPHHZxwklUjy48aS1SjekuDOV2N6PFB57DM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jDwWdtBH+/SvC6MxtS/At4zpF5vnfHc0Hxx0zXTsZemhW6+6mP2a797B8JJzurE9n+BzthTUESQvcsUHuJ6B4xZaFKgAFqts1tiJTFgzqJQUV2hwanp6DHlKNl246BpKHuHMASl5JDfE4BdRkOd7HDru+hGh766ILYGyipnLJ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ms7W5GFa; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b983fbc731bso273687a12.2
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 08:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764953713; x=1765558513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLY3+mhhYW3/XUXK8GXyxFHEkY2iNhfQX1BG1hSHT/E=;
        b=Ms7W5GFaPQvxmZoiC4O6m/h8GaNZsAxWS7utIjsfAUhgB0DQeHMwUl4/Slz5xG+3/F
         DQBlyM04sGSNjqSSc/RGfeP56crUdB46GZywEKNuE0zzS19oWfBAoYUuZQwC69wvGwLB
         3Hr7OC1RwwI5S0qPiYSGLOoxrUPH6XH5JBcUKEAU9A/Z+n4aLFQWQlGyMCQF55cL7Mt1
         9vvlabN4SyYPdm/MEvR7VuMlRLaKaJYMObVri7DJjjXVWL5dZV35iinfJIX5iIgRGsZR
         VyTF8/xP7q0CU4F0CzO4zE5cLONdh3KyZvLw8qi8DNEOUqSN/w3cOYlMiX5ko20AddHo
         NOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764953713; x=1765558513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MLY3+mhhYW3/XUXK8GXyxFHEkY2iNhfQX1BG1hSHT/E=;
        b=kdan+j0iVdxm8FIo3A3lusCk1Vsp/JW+/Vie3M6nKoWGEMC/VXdMGaYiPnWc5vb0nO
         Sfhw++G4kNvdJJ0sKpL2Lldsb8YGzFuClLwR2VdgMqALEjCqYoDQkpvkPS20z1vRWZ1t
         2XE7EqDSmFMVq5dXuc1WAJx2dre9k8+RiD4tgABkEYYebbYRUxAdteG/K3gnErwrKttt
         ik/rn4y3umL8+X5o+mkLwZpGQlVeUCpjC+lOYhN1P1VfAUGl5LYJr6cPFcxovygIPUGG
         HbyKaWC1Ub4vTrd9VU1F3cx22aJDS4saO2fuYBNjtZ/nbs7I7eJZSZpCP1uLiNOOhhwB
         Jm7g==
X-Forwarded-Encrypted: i=1; AJvYcCWlaz6vFUG28YPbw5D4jJa5vvwwZyKuPtOgqWIhjg/uUGtORTUM3GF1kBUeNOCGUMyK9aLrhEjkaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhRTQEkVw84iTNewS42K1Eq1EaDx1pxGaFTLwe/mVkgiUxJXxK
	ohwF+lFrulrrL8SbpUDNohc0r3qitlLwtmnx60DrbukAbfGLpe7rDzfKb3ylcNsljXyk1AE3KQD
	5F2/8GDBODK1VLWcd/B4ad9WD6Yqf+7xWdJJtxEn4ZQ==
X-Gm-Gg: ASbGncu/7l6/V+kWuISt2j2CtRsEjhVliyOYe/YQnI7PzzeU6gwWDq8kd2wPj4ToN0m
	dmgGvQYo2p4KMB1H2PBZlry9E9D42qoOoTDld1a/qXCX/ELYUgHo/KsBidYbw2SNxIHdLxsWtyw
	/dYp7iQPIzztqfKuw37r6ROSBDdGmwqvb9criTvKgrTQshOQIve/k6KPM9tFifRTQnY+DyoNtTY
	L9CYX7wGdKE4B0OGo/6UtFBDyvbzQbHr8efIZOua0StsPA43f3gz/FHTFG58YwzdAEV0zcO
X-Google-Smtp-Source: AGHT+IFilwZZK4CCMYUdwLVbeehGo02GIebk6FkzRD3+CDobmoMPxyVsHaKctebC2zQAVyV9T4ukbxFA4x+T9J6y4oU=
X-Received: by 2002:a05:7022:f410:b0:11a:5cb2:24a0 with SMTP id
 a92af1059eb24-11df252cba1mr6519711c88.1.1764953712947; Fri, 05 Dec 2025
 08:55:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204235450.1219662-1-joannelkoong@gmail.com>
In-Reply-To: <20251204235450.1219662-1-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 5 Dec 2025 08:55:00 -0800
X-Gm-Features: AWmQ_blpH39OsRTPvUn-GU7PeERNk5LSX9m6Gdxqh0TCQGXjpjD_qty-ejujr2Y
Message-ID: <CADUfDZrbZj+fqqzHddWVjHvhwS2GmUzKTWgknhDLdRt2_ufr=A@mail.gmail.com>
Subject: Re: [PATCH v1] io_uring/kbuf: use WRITE_ONCE() for userspace-shared
 buffer ring fields
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 3:55=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> buf->addr and buf->len reside in memory shared with userspace. They
> should be written with WRITE_ONCE() to guarantee atomic stores and
> prevent tearing or other unsafe compiler optimizations.

I considered this too, but I'm not sure it's necessary. A correctly
written userspace program won't access these fields concurrently with
the kernel, right? I'm not too familiar with the buffer ring UAPI, but
I would assume userspace is notified somehow (via a posted CQE?) that
the io_uring_buf slots have been consumed and are available to reuse.
In that case, a torn store here would only be observable to a buggy
userspace program, so I don't think we need to add WRITE_ONCE().

Best,
Caleb

>
> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer c=
onsumption")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Cc: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/kbuf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 52b636d00a6b..796d131107dd 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -44,11 +44,11 @@ static bool io_kbuf_inc_commit(struct io_buffer_list =
*bl, int len)
>                 buf_len -=3D this_len;
>                 /* Stop looping for invalid buffer length of 0 */
>                 if (buf_len || !this_len) {
> -                       buf->addr =3D READ_ONCE(buf->addr) + this_len;
> -                       buf->len =3D buf_len;
> +                       WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this=
_len);
> +                       WRITE_ONCE(buf->len, buf_len);
>                         return false;
>                 }
> -               buf->len =3D 0;
> +               WRITE_ONCE(buf->len, 0);
>                 bl->head++;
>                 len -=3D this_len;
>         }
> @@ -291,7 +291,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req,=
 struct buf_sel_arg *arg,
>                                 arg->partial_map =3D 1;
>                                 if (iov !=3D arg->iovs)
>                                         break;
> -                               buf->len =3D len;
> +                               WRITE_ONCE(buf->len, len);
>                         }
>                 }
>
> --
> 2.47.3
>

