Return-Path: <io-uring+bounces-10051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BD03EBEA029
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 17:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 58E715A1059
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 15:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49516332ED8;
	Fri, 17 Oct 2025 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="CG9gAm+g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A01D5CE0
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714557; cv=none; b=e6Ht/mFAf7wQfEKDGYJqPW80xBa9s/jBZBKPOOWxRzj4cFaNcOZLA66gUtQG2F1bzZof5Gcjh9bg6T0VXxrsMDW6GeKta2tWYQori+93xWj+LTWUV9IKP0JyHz6H9U8FvGdFW5XkUic9WBeOraWOGRMaJgJTO0E3/yWCPS8UrH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714557; c=relaxed/simple;
	bh=BwJ12T3X4oAmkiiCPjoU+/e2dtybflTFYeARE8wxhj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j/Azk1TtIPaAPSBbHcEwsOTf7pwkhKisWDL59P7NuZyiRH13x5s4NUcLf16IeEfheVivvuA+3WKfgD1D+Z8YWxd+aIpl4jCS6U88n89UK2CkvXce/lWuFwkgebQ3Ry7Tg+XQua5faioC8k99gnedFbGzJzl4jpRCsIg/qI1vb9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=CG9gAm+g; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27eca7297a7so2961275ad.1
        for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 08:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760714555; x=1761319355; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTjzQg6fME5Htnka1zGGW8fMUUb/C0+5xowaL8K/8eQ=;
        b=CG9gAm+g2SK5cHlHqqJKpfdcvtuXUQ1x6hzKpzHSh3eu3kiWk/6AFfig9xTP6a1/d6
         1/bMDYOfA7KhDMUo9Ygsdhtr8b5V+n1vAu3cmI89+bJZN7tufwJjAG6DTNLLvcCxaud3
         k/6dXkC2rQq/M1hgJ445KEqFshK4mqMxgkUk/B0sLkG2kGxjsVvw+vqUjeA22XaVm17s
         yZ2NhHDu5VLJETFpuKGvjX1PhUgwyiHccb6X1gr0k/vBDUlPHbEc6S/QbIWehlxNS4Hk
         xmWYIVkUt9HI9V7QCFP+Wc75tlSIpdC8C2jSfwNFrXGRKQJQLs+8QdRdxO0yD3trf4fq
         tH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760714555; x=1761319355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTjzQg6fME5Htnka1zGGW8fMUUb/C0+5xowaL8K/8eQ=;
        b=YV4L2mRH+oAa+xgQUdlETnPZDe3uijjVR5Bwb/xhfXv3hjPWBLJxYyiD4Mfno3C3be
         8xS6pS/7wf5Ln4QNw9kdynav99Bb8ubB3camcT7PHv1n7Xb+CX2/2G3y2Er5u+qvsKPW
         DXO/5ZZJzH3w4cscDiIqQYj7I6JENV5adLWLw6xfy7zEZ764GDQrsergwFlPa+H0Y+Au
         nk+tbzPULfnF+hbzY6AdR8POp0nmXYGCBFg+RuthEzBnMvASukSkfxU+myZjcbOWy7ek
         LyyJ+MsIZ0vq+P9+9qdA2vwiTNLOHznlmsW/eHDoWzzHgKV2oNCkOCp9JbfFnQqKWYfo
         3IDg==
X-Forwarded-Encrypted: i=1; AJvYcCVA5mnQ+v2Irz9L/y7/DNyX1NiNUaT69eZjmVkes5s1WvIMsblYGfYvmHEwe+IUUCtYmLjVOfTNLg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj/F/DkLhhL+EMZ831akdspwYPnio9hyMuTV4BT8DvBL7FpzLO
	SprxzqQobeWX6vnDdbeWaF2/cILhONrSARG+pKAdZIw9ftOKBQpUF89U2WYieRj2X0lgT3U9RM0
	x0f+zzpSinuRvwnQR9AX3XZlGepbC9ri52+5caqCweQ==
X-Gm-Gg: ASbGncs3FtW0MmhNg2+7ZGJ/xC7pJz2mp0Qi//9wdNUxe/LkRaIln3LK82kdW9pmWYg
	Vk4aiNcqb/DbHR0XtlcHd5murf9+6RIjcYR8fN7Bdrn/CuE6ddCVM0oweQ4t+Id03G8tAiJJSip
	FF7OH7rMqr2XKa9JtAdSxjINtoAbyzF6CAUkJC3lU9imeQcwMFREobD2x9qo7S6ngGme2K+1DQY
	+l4T37Pbr+RV2RKitCXsTntprJg6l0p2Sp7zSuOqlph1Va3sz5Ozvexy+hjiTcYxjq6j5WBNpNr
	usJAHXHwIyNM1YaEWG9U/zvSXWNz
X-Google-Smtp-Source: AGHT+IFiDehX314o1n6Oft238RHJONQp6EJYlI6AsjptA2zyEX5KGWqbID6Gp2Kt8NqcCpDjOl6xg+TonsSy8mg6E40=
X-Received: by 2002:a17:902:ce0a:b0:27e:da7d:32d2 with SMTP id
 d9443c01a7336-290caf83194mr26000145ad.7.1760714554591; Fri, 17 Oct 2025
 08:22:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017124117.1435973-1-alok.a.tiwari@oracle.com>
In-Reply-To: <20251017124117.1435973-1-alok.a.tiwari@oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 17 Oct 2025 08:22:22 -0700
X-Gm-Features: AS18NWBrEidgc0ydWNCwnfB7QToQeY2Nzp_kQM7XjmGSGbBHsLxZcROuy0Gh0W8
Message-ID: <CADUfDZruQ7baruoBhSMBt6HcP-E-KiM1MHV=L9hn6OxFgEaXcw@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix incorrect unlikely() usage in io_waitid_prep()
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 5:41=E2=80=AFAM Alok Tiwari <alok.a.tiwari@oracle.c=
om> wrote:
>
> The negation operator incorrectly places outside the unlikely() macro:
>
>     if (!unlikely(iwa))
>
> This caused the compiler hint to be applied to the constant result
> of the negation rather than the pointer check itself.

Not sure what you mean by "constant". But yes, applying !unlikely(iwa)
inverts the hint, saying iwa is unlikely to be non-NULL and therefore
the if branch is likely. It certainly seems more likely that the whole
if condition was meant to me marked unlikely.

Best,
Caleb

>
> Fix it by moving the negation inside unlikely(), matching the usual
> kernel pattern:
>
>     if (unlikely(!iwa))
>
> Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handl=
er")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---
>  io_uring/waitid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> index f25110fb1b12..53532ae6256c 100644
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -250,7 +250,7 @@ int io_waitid_prep(struct io_kiocb *req, const struct=
 io_uring_sqe *sqe)
>                 return -EINVAL;
>
>         iwa =3D io_uring_alloc_async_data(NULL, req);
> -       if (!unlikely(iwa))
> +       if (unlikely(!iwa))
>                 return -ENOMEM;
>         iwa->req =3D req;
>
> --
> 2.50.1
>
>

