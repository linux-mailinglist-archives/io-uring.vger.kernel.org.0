Return-Path: <io-uring+bounces-9761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6987CB53FC8
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 03:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0D5A1C26C58
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 01:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2755312CD8B;
	Fri, 12 Sep 2025 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dCLCoZ0C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40347260D
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757640085; cv=none; b=HOiSWoBa6C/77qoEdGeCjiOud5q97ckmptE6qcahpCb9jLJt3ogt1IwnGP+AHL4y0+b87ipQbLAxw4TWWgJVD6KDfdG+qY3FZsWDYwa2Nl10UfAfDf1fAvLTrTaGe+fPw3bBjDyREzFS/cpHngYWCHo5S00WSZcGceBoiddcfk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757640085; c=relaxed/simple;
	bh=Xa0YEpz+3VPo1Hi6V+S19t8JxtGYU5nJ3wnyT2oaneo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bq0CNu4q8LBun8IPEP9MKF1Pm1vXwfTnkan7j8f/Yg9KwA+GFZHvgbWSzi/auzNUxKvqXLo0D7mvA5OifRGd6qjX9pMucWcVoO/461Y0F85n+6BBw8/QAlE23KXNrhKzdS/TVVpCZl/TyXrzMgsbcq+k4F8MPGv6TDC1JpW1MtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dCLCoZ0C; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-30cce892b7dso674752fac.1
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 18:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757640082; x=1758244882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNvn8dwm9/jQPmmYOQXAYSn+9iI7uf/gD/WC7z1WFd0=;
        b=dCLCoZ0CHYFlRTIp1Tp8FynzOhdJE5IL5HB4omBIzrOfMxy8nycuRlSMGoCAcgK0Js
         EHnXc0mkWhDfdHDaDqc8DJHlJ/AumuElk7qaVpk6sgM8tqGGZTIAtKKHEWGb82sZbwTQ
         eB/8kgNQ3CsLtMgfrQ+Tg5xjYiPJxufSYDSQr7W7Z5RInDQNxc8ecoMppPzvHcXYrGr+
         AZ8o5JkyoL04kvVY0avUKk2XRNRDlNtAMaNaCO+0UlvtMkrTaI5B3RZ9+Bf3WXZ/gmlZ
         PzRDzPYb66BRJ6l3NVj6q8UTCrnPoudoUUxjL5zFhYUy/0ZSz4oKN5Ch/qImYDwTComD
         CHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757640082; x=1758244882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LNvn8dwm9/jQPmmYOQXAYSn+9iI7uf/gD/WC7z1WFd0=;
        b=LOgJzYcj6oMtMJpK3i+NQrv7ySqHUjDrF4B0SvO44clp/8p2/QU/9hzYSQfVn87Kgj
         zYjvz4x/kxn3ZrE2CwpLx/BbpVhh7jtuvj8ba3gFByH7YIire2jc0eSorHoE1axO7tbX
         2+lfghWFIjZLrtpSWRRjxsMLk5py9g/urhXrxHL0s0LVBbkR7SDEywbzgRfqg1t7Hv6I
         Rq9ToEIel5bMbgpGkeDCx87aNPrY+kiwXH81AGNNQDfAPoKSpMVhgbKkImaV/bomqH2U
         iktjqE198FTS90NduApWDzXyMn83rgv2n3WrNi0a8kh26feP4Xhhd+RoI3wBmbk/UpPi
         kHnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhr+6NHD/0urTqsRhTfF4vUjukrf4Vrfq5TJQg23Y3Yrb+lHspLirYYeDv6HApM85bxrQZvbJdZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLhsL5X2dLChTBxiD1UM6aK/snP74rNC8GGNIgXAC3HXPkc1Gi
	VdV9INFVWYHyj1wbrI4Gd4lXnlgEJMWdewT4H5tehcUA8q7kHxpT9gEtx3/aRAHeaN7cOXU/syD
	p5R9dEWkKR72fdDbaeLu4+U0hX2PyXi6ZOJf5r7oDJA==
X-Gm-Gg: ASbGncvkJmpwZIm3JSTNQtrK1aISuSLoUr/xibAYKOQJlVKeTPIYsfbllsKS2ZQN45w
	ozfkyXISlcl4pgg9HKsjLdt6/LzZXE4NFJZRbNKzgiUaOHKVGtI2syh3oPGZol96KoyAF9aXpmM
	CSO7xobYipY9DpvQZVUoaewRRIUr1n+S/bg6oluTUYwaqoCLiZSTZMlbaUGqtwuRSf71Q52ulJw
	ZthPhWQOCYHMKJjNvoGYlI3Tw8=
X-Google-Smtp-Source: AGHT+IENe4W9BbK++7qiIojSfDqtbC6lEInbLpk22z8JE7+q3Y0xd1PU0fHFZPk4jPzlcQVIVGB2YJM40b6QZIBc6fw=
X-Received: by 2002:a05:6870:c69a:b0:316:9864:8d0b with SMTP id
 586e51a60fabf-32e54575db6mr492849fac.12.1757640081657; Thu, 11 Sep 2025
 18:21:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912000609.1429966-1-max.kellermann@ionos.com>
In-Reply-To: <20250912000609.1429966-1-max.kellermann@ionos.com>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Fri, 12 Sep 2025 09:21:10 +0800
X-Gm-Features: Ac12FXzZE38Za4CCeCuscUYLW8mPPYr98VRNgPC9wOUJh37TNzG7c12rb6_jwOA
Message-ID: <CAPFOzZujMZg14Ljp-YsgPqqcJhMFnU68e7XOf09pc=jwoTPytA@mail.gmail.com>
Subject: Re: [External] [PATCH] io_uring/io-wq: fix `max_workers` breakage and
 `nr_workers` underflow
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, 
	Diangang Li <lidiangang@bytedance.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Max Kellermann <max.kellermann@ionos.com> =E4=BA=8E2025=E5=B9=B49=E6=9C=881=
2=E6=97=A5=E5=91=A8=E4=BA=94 08:06=E5=86=99=E9=81=93=EF=BC=9A
>
> Commit 88e6c42e40de ("io_uring/io-wq: add check free worker before
> create new worker") reused the variable `do_create` for something
> else, abusing it for the free worker check.
>
> This caused the value to effectively always be `true` at the time
> `nr_workers < max_workers` was checked, but it should really be
> `false`.  This means the `max_workers` setting was ignored, and worse:
> if the limit had already been reached, incrementing `nr_workers` was
> skipped even though another worker would be created.
>
> When later lots of workers exit, the `nr_workers` field could easily
> underflow, making the problem worse because more and more workers
> would be created without incrementing `nr_workers`.

Thanks, my mistake.
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>

>
> The simple solution is to use a different variable for the free worker
> check instead of using one variable for two different things.
>
> Cc: stable@vger.kernel.org
> Fixes: 88e6c42e40de ("io_uring/io-wq: add check free worker before create=
 new worker")
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  io_uring/io-wq.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 17dfaa0395c4..1d03b2fc4b25 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -352,16 +352,16 @@ static void create_worker_cb(struct callback_head *=
cb)
>         struct io_wq *wq;
>
>         struct io_wq_acct *acct;
> -       bool do_create =3D false;
> +       bool activated_free_worker, do_create =3D false;
>
>         worker =3D container_of(cb, struct io_worker, create_work);
>         wq =3D worker->wq;
>         acct =3D worker->acct;
>
>         rcu_read_lock();
> -       do_create =3D !io_acct_activate_free_worker(acct);
> +       activated_free_worker =3D io_acct_activate_free_worker(acct);
>         rcu_read_unlock();
> -       if (!do_create)
> +       if (activated_free_worker)
>                 goto no_need_create;
>
>         raw_spin_lock(&acct->workers_lock);
> --
> 2.47.3
>

