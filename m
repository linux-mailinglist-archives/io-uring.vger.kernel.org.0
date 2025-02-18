Return-Path: <io-uring+bounces-6507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C74A3A457
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 634B3169AE2
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B80426FDBD;
	Tue, 18 Feb 2025 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ICt233yL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7058D26FA66
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899803; cv=none; b=DqvlheKwhZ/ejo4+/MwH5hqmoMvdUzovvhENRm0lbW+wo8MwtC2oZa1PKlxWnowvRwUJKGYQiy5eDkjzXPE4TWWXPIAXQgNt140ZqHc8iufu1Sw8fSe1lnzrecPKTLAQooWBvnXNy57JQ8/gcScCfN/NhjlHoug2hea2MmSAraY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899803; c=relaxed/simple;
	bh=JPepBJMSRAuLJ4M8oZdJ9/BBgMwNySHzUtLfR8bYIH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MWb24WWhflQBCDUvLDcKiYOYAVihuXs02plMgSV4xd2VpVFUeGe/xixY2EG23HteIB3OY8a+dpxob/7JorVbDWb+B/NTep/QpYCviRzC/CgNL3fpZ/8UBjgt4tEQ3ZoVFcy9LlWgjWkbXJ+g4pDgQF1rrEGKTsNL1QxCG0ZG+EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ICt233yL; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2f9b8ef4261so1395097a91.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739899801; x=1740504601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUt8o7+hB6Njb2oYjIlPOyCXaxcxvi9o7/BTnTuLLWw=;
        b=ICt233yLGb2YiKRo7yb4VlcpoVL99K6EG+9ATWylgcGqTSw1Oxwd8L7PWyJ/v4RkBE
         V930TQl0qSRcPhR3YiEUwDODUNyrhtUlVwD8LKJwkvQ/nYKrlITP2mLKile7uuW7GJPm
         yxcIvcMBlttktj/fCOqESOzYHTJdEf2dlE78YWIuzxWfBiWwvXVZnPjFtPQOUM8aGY6o
         V+lV3YEjNqGH2g2mz2OLA2uexMORM8JO1Xga4jzs+iqv0DDmJPHDM0LwI+FQSIOhErES
         w05R7tqS6SkpRO0DWQAb/l4BhMmjYbA/mlNd4yuauvWQfqZl2iQwsDYz21Kpk08Ov1T2
         rRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899801; x=1740504601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUt8o7+hB6Njb2oYjIlPOyCXaxcxvi9o7/BTnTuLLWw=;
        b=bMPY+OXWwJJog9KK+hI9AY4YDPjiVk/Jd9LsvSy2xqoSquAF5bEdCnIaZOprtWjkdF
         hYESCaNpa3D+8IbBBX6pzz9nYD+O2T72D+cu0+X8HksUkmz6vcWaKdw3QxqtzxR+EQLA
         QTS1M4ospSNI+O9vzY2rUouX01p7YuDDTQyb5qovuZz3rYJS2xo/QewKZTHzPZk3t4eN
         Y9Sg5mhbtEb3+67S0KTjJoMP0XbSMmgTG7ZDqWDI71YFCszojbKQBF/TK4US0lpUo8IX
         ELJ1xm1Bdel8zVGmFCxivmOYUBkLdqfYtgokyH5kiF3UT6bPP2UdbOHfqOGzTLGQYDad
         w+BQ==
X-Gm-Message-State: AOJu0Yz3QQH4zTKtqRKzP5E/7Ft+Ynfa5EjKFUmtXhPqeD1tGvF9EGkV
	KfpThJuALjJuf6vQ8RAqJVYrqWTbsrW1b/GFutfeYXsl3ZhVTFwAGY5wRn1WugAXgvTlWWxfIdo
	9g34ZphtRfXZOrHq1lGms/KKQKo0m+w4GYs9d0Q==
X-Gm-Gg: ASbGncsmaI4Pz5CyE7aZJD1tD71PWKu3avXxyCmBG+MfDZIpzqhvnM7lwH1BaQnCDOU
	geKTpnuok5dZzRwH00hiUjJF0XqsDurtzxurque3Rm0VV1K3QFicsmTrIGkNlBTxohUZek4k=
X-Google-Smtp-Source: AGHT+IFeBNyWIAXh+EPk2eKwL5jW8rtVQKGRkR7rVYTeqSsk3nJIqHBXaNrLW/pvXwUtVLFmBHgNEHZDu2Oo9qOd5KI=
X-Received: by 2002:a17:90b:2fc3:b0:2ee:a558:b6bf with SMTP id
 98e67ed59e1d1-2fc4117c0cfmr8724982a91.8.1739899800674; Tue, 18 Feb 2025
 09:30:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212005119.3433005-1-csander@purestorage.com>
In-Reply-To: <20250212005119.3433005-1-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 09:29:49 -0800
X-Gm-Features: AWEUYZklYvNbpjeqJ25078hNrYRuo6xnxQiEhKeQ9HuaQYI6Cy_rKvk9qRwhPsw
Message-ID: <CADUfDZo5CMo4cQeZCQ3z5vNFSJ_M_Ckeq=bj2rkA6-sq7ABSNw@mail.gmail.com>
Subject: Re: [PATCH] io_uring: use lockless_cq flag in io_req_complete_post()
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,
Gentle ping on this patch that Li Zetao reviewed last week. Do you
think the comment should be removed/reworded to match the new if
condition?

Thanks,
Caleb

On Tue, Feb 11, 2025 at 4:51=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> io_uring_create() computes ctx->lockless_cq as:
> ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)
>
> So use it to simplify that expression in io_req_complete_post().
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ec98a0ec6f34..0bd94599df81 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -897,11 +897,11 @@ static void io_req_complete_post(struct io_kiocb *r=
eq, unsigned issue_flags)
>
>         /*
>          * Handle special CQ sync cases via task_work. DEFER_TASKRUN requ=
ires
>          * the submitter task context, IOPOLL protects with uring_lock.
>          */
> -       if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> +       if (ctx->lockless_cq) {
>                 req->io_task_work.func =3D io_req_task_complete;
>                 io_req_task_work_add(req);
>                 return;
>         }
>
> --
> 2.45.2
>

