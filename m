Return-Path: <io-uring+bounces-6412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EFFA349A8
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:24:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C05EC18944E2
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5A724A046;
	Thu, 13 Feb 2025 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DD4AUQT1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F4A202C5A
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463389; cv=none; b=P5sb4wlcQAIE5/6TeGXDZenUZJNAQmXn6usGm4mSf4xxP9zDZKKXqYUW3mnYu9NN09+IbeZJA+OWME59ATqP/tOPPaNH9MGVgE/OHHb2/K4aS/YqnlIby8fbu4c7G6qBKNHSNAwgT2OKUZzq3whqm4McDuMt8l7OK4mqEct1X64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463389; c=relaxed/simple;
	bh=QyT+Mrzo3ArXxQQzW46RBGkLAhLztgb4hTVOuPEp2fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h7+hqxw0nRLlYuCJ22krJrzImhMVYAiQyZ3JgnYRt9lS9cpCIDFIa83gocV/baPbrpOO9TfD0CloE0ASnUvW+2B7gtigQDDdODMdU+vNlKTHyd6bD1rZriORftF6uV7iZjehjxQLRlE7Giyk607OwYHMeYG1uMsuTHbgY3EFN2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DD4AUQT1; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fa0f70bfecso236789a91.2
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 08:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739463386; x=1740068186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twFFuZnkesMSaVlOWrRXk1PZjDjAiNKsm1AgQUv02J0=;
        b=DD4AUQT10jWrTJGPHLEjT/2O6D3GkeIZzrGom0dZE8+WcjIF7EuYEfHy46h5RUMjRU
         DNFAtBNOqQPvDSM7xEXobapJ1ygiGuBzrl/tLL4JlCnX1I/tzcPrtQhOV/K7mOsI3+uN
         C8SVZhaH29toeZAAYF39Pib4pCOZuw1nTuSiPcZZPR0C9sxiJlt1oXBcXAHNsWAP1C2P
         yHAbrqUZrS14EEhNUFTe8Za4OH8beIUqzVrTVYBLidSKM/sklL/tmwGOdO5R3SicURsP
         HpPIoCDE2k/HIvdFApdmCM8Rdn3qBrng46YpP+YZ2lEYKft5dNOOdtgQbZfhW4HL28Xw
         M5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739463386; x=1740068186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=twFFuZnkesMSaVlOWrRXk1PZjDjAiNKsm1AgQUv02J0=;
        b=IvT2j1t0R458WJ5e5c6EFl6WLtPewIY0AdaClg+fi8hrROK6+gZnSK0M3frB5Zi7DG
         nt4Y0un7wrcOskRyyHe3k+qfHk68i8dXw3brSlMCh5iXhRyFfQkEfnx77TFuiwrUJBIh
         HyvJED8LYTYzs3xrCfnRNOkSYLeyY+LMce5F+Pi83RZQchG2gXAB8ur1EWuyyDLrvuaw
         3ad3JPj30yIUe9cguf32rXv/HYLPJPOp7V/RiV+vmFYPQXWwkefytXWORjOLWMkslexg
         Lokj5SNhk4IENYGivjvAozqxxZ9EBw+azpx/kbM1bMch6oR0xq3MuXRkvykMfrsJLlFm
         2bMA==
X-Gm-Message-State: AOJu0YwhUnGVXNzAtIM4OambK62dVaFjx1bANHH1s88qlWyfWs154w+e
	ve2luUyBCh3mVZUDTVb7MuWVM5ob4b4YjLlTsWk9ZdeATpgZcQJyUnb2ADYa0Ps+EQTitHsdbzY
	TuBblyO3Kl6heSiTC4y6c0/1V//ev/Eel244qYQ==
X-Gm-Gg: ASbGncsRyCux6X40N+DniRaxRAfkU31curgTh7MZKBLghVYDETP/1MnBVadMqXrerDu
	kfVs2kUFaWanAzUKQcl9yikVeujkWQvkc1F0auU92/BcSAy79MpIYF1WdbLCpodB7nwRgzqM=
X-Google-Smtp-Source: AGHT+IGI2ZrFVht2L7xF/b+rggtHE235KxFn7YOrv8ItB+OMCQRrByX72tc72U+Me6MbdZU2/kmx5doaxvRQoRmHtRU=
X-Received: by 2002:a17:90a:c90b:b0:2fc:25b3:6a7b with SMTP id
 98e67ed59e1d1-2fc25b36e65mr576679a91.6.1739463386470; Thu, 13 Feb 2025
 08:16:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9698ab08-3f36-42f1-b412-e2190d2e5b6b@kernel.dk>
In-Reply-To: <9698ab08-3f36-42f1-b412-e2190d2e5b6b@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 13 Feb 2025 08:16:14 -0800
X-Gm-Features: AWEUYZkmaznbt4M-7uRH_t9QGW9KgTmI9UKPzWKiRJCVUOvpZxEjOMx6IWWOOYk
Message-ID: <CADUfDZo-mqM_PwoPK3_JX14QY3sQfVXnSwD=+30tdcAiD9fTJg@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: unconditionally copy SQEs at prep time
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 7:30=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> This isn't generally necessary, but conditions have been observed where
> SQE data is accessed from the original SQE after prep has been done and
> outside of the initial issue. Opcode prep handlers must ensure that any
> SQE related data is stable beyond the prep phase, but uring_cmd is a bit
> special in how it handles the SQE which makes it susceptible to reading
> stale data. If the application has reused the SQE before the original
> completes, then that can lead to data corruption.
>
> Down the line we can relax this again once uring_cmd has been sanitized
> a bit, and avoid unnecessarily copying the SQE.
>
> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> Let's just do the unconditional copy for now. I kept it on top of the
> other patches deliberately, as they tell a story of how we got there.
> This will 100% cover all cases, obviously, and then we can focus on
> future work on avoiding the copy when unnecessary without having any
> rush on that front.

Thanks, we appreciate you quickly addressing the corruption issue.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8af7780407b7..b78d050aaa3f 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -186,9 +186,14 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *=
req,
>         cache->op_data =3D NULL;
>
>         ioucmd->sqe =3D sqe;
> -       /* defer memcpy until we need it */
> -       if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
> -               io_uring_cmd_cache_sqes(req);
> +       /*
> +        * Unconditionally cache the SQE for now - this is only needed fo=
r
> +        * requests that go async, but prep handlers must ensure that any
> +        * sqe data is stable beyond prep. Since uring_cmd is special in
> +        * that it doesn't read in per-op data, play it safe and ensure t=
hat
> +        * any SQE data is stable beyond prep. This can later get relaxed=
.
> +        */
> +       io_uring_cmd_cache_sqes(req);

If you wanted to micro-optimize this, you could probably avoid the
double store to ioucmd->sqe (ioucmd->sqe =3D sqe above and ioucmd->sqe =3D
cache->sqes in io_uring_cmd_cache_sqes()). Because of the intervening
memcpy(), the compiler probably won't be able to eliminate the first
store. Before my change, ioucmd->sqe was only assigned once in
io_uring_cmd_prep_setup(). You could pass sqe into
io_uring_cmd_cache_sqes() instead of obtaining it from ioucmd->sqe.
The cost of an additional (cached) store is probably negligible,
though, so I am fine with the patch as is.

>         return 0;
>  }
>
> @@ -251,16 +256,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int =
issue_flags)
>         }
>
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
> -       if (ret =3D=3D -EAGAIN) {
> -               struct io_uring_cmd_data *cache =3D req->async_data;
> -
> -               if (ioucmd->sqe !=3D cache->sqes)
> -                       io_uring_cmd_cache_sqes(req);
> -               return -EAGAIN;
> -       } else if (ret =3D=3D -EIOCBQUEUED) {
> -               return -EIOCBQUEUED;
> -       }
> -
> +       if (ret =3D=3D -EAGAIN || ret =3D=3D -EIOCBQUEUED)
> +               return ret;
>         if (ret < 0)
>                 req_set_fail(req);
>         io_req_uring_cleanup(req, issue_flags);
> --
> Jens Axboe
>

