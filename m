Return-Path: <io-uring+bounces-11053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ADD6CC05B5
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 01:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 029BD301227A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 00:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635D7212562;
	Tue, 16 Dec 2025 00:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1Be/l93"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C232C1EF36E
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 00:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765845267; cv=none; b=cV5fvUKn5ctGUvLOa1Kw62lC0OMg+r4ce2byw1INjivWt6ift568zWJXtgO/CLHDE39vF7SDerAKsnKQQX0T4VdOgeZl2b2FviRqRBKKZUAAulr+QY1wBjIcVLuBw7qL0gSnVxgst2IUmPSi+iDoes8qtO89x3kekTZhpTycbco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765845267; c=relaxed/simple;
	bh=qhnGceoANUDlJldpj1qoVSdXs4wSWgV0hR1mHIWBhrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PrHFIcfcfzmXe+ICfXNv+D3i3IGplrm98OwJJZl8NHgP+/4yAYufTKiEptKC2j0wCRqDckpA/rr0fcoB/aQKHvQAvw8rg4YdFz6ZAYBESD5kEgTwHbA5KjlzaTc/Sxos8ybdS4PVyRhX/Ja/47doyuZhLnHloBeUhkAHE+Xkx2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1Be/l93; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed7024c8c5so33289371cf.3
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 16:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765845264; x=1766450064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNR5dNLCBpoGfKTSKmZBeRWcn7wrGQ9GJsf8C2g3+Hk=;
        b=Q1Be/l939yWCtClZoP6h1bQyb6BMOv02SaYjn4bj+ZY4x1Yqc4JU9MsIkkFgvyQz3H
         Z0SeIj9d6n5OinZ95li5a2kicJHMX2iKNQwDrTsO0OH2WFiqKyvbG9MumgZm53Hgvdft
         1HYYPwDwWfTyrm2uXIjhuNQlNtHE7wUI9FGdBV7blo2iw8hDurm1fzr9Zx0TpW2Gyx9P
         KrUY1BWQW89MOC5ecPVQCxaQh9Hi6Z662P/tk9YuWK+f+0VU5ujmMbxr4GVaJd8gU1NL
         5GPhii0lx/i94Ii5Bzbkees/PJ+gze/IzmZjKurAdXj1JpWql9trokZ84TqOVt+3dpyX
         4AUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765845264; x=1766450064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wNR5dNLCBpoGfKTSKmZBeRWcn7wrGQ9GJsf8C2g3+Hk=;
        b=iQbks7rK3hPcGF3THo1Did0Iu1i9ug9o481R2VHMDR5Tny9AwexKTOy8o+wU13RWwT
         TY3iutZpywmK1zK6MGZbqLIrlrAe9egly2npN8Xmusu6AiFx6OGFSpVylalJtxmlq3Y3
         Za+wM3xD95a3Q2Fef9wHVOveqZfi1ffIONgFRcUDuGNW2aEusT+J0ol584oVLJPsJOmD
         tj8kIF61IwDTEh1L3xLqIu23JNEUwS3VVX57X4pCoNqk2kQ0TUtWCxJQCNTGE3cgIXJb
         1rgj8bD7NQRUp5D6FOce/3HPDiJdaIoMH/XL6YXOlmcKHERriOqpnZmDIOkC9eDnTO6w
         qcUw==
X-Forwarded-Encrypted: i=1; AJvYcCUzsg3LeomxeG09YuTM9wFVVg5/DqWqC7DqwRH9roMF1ZP3Yir1L8XyAWqLV+QkJ6EpFOceGDXKWA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb09IaS3VuFri24EfKSD+kRdGYM/tkUn/d/uJkVRANUd6fbOOz
	kko+X8Jg9mRwBkiLp704KhwfyjE8XlTcjdk1VqK4r68CaXbQCcJI1QU1jQeX04nGiD0plt/fkVn
	TFnDJtO3mnssqFYDlQKuQwJHcra9IiEc=
X-Gm-Gg: AY/fxX7sKIrky67T1dTPdd1FybjxMbNzHGHS+7DY9K+e+xd5njjUTROZPW01Pws8aJV
	O0b86v4bxOoSD8a6+AWSotrIv5ZtIbnthZOA/E0QPSgbC7PPGcd66fHFmq9/XFjZxp6kY8hLdGF
	DNTpVwolW4FEUwMF0+Hukecx/2TAeV42soj8EAdT2/vpBOiJOG4bzmtPYKFmK5APAmIbYUMcte1
	o5eHWfmsyZI0YHgn2PCeUJLvVYZ5UXTEot+lBOxxuFzEk0afLrHxmlWDuRy6yD4duO/pe1zjbE8
	kJ+btK/imwI=
X-Google-Smtp-Source: AGHT+IE4N56d5NYVSUUmudLDaJmRt7G+U+uCVntJklZyAZAD0y1bQMZ0zVla0oOm0O/glVhaZ1qeOVsZWdn3wl5Thvc=
X-Received: by 2002:a05:622a:19a1:b0:4f1:b795:18bc with SMTP id
 d75a77b69052e-4f1d0629f75mr194108301cf.64.1765845264454; Mon, 15 Dec 2025
 16:34:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com> <20251215200909.3505001-5-csander@purestorage.com>
In-Reply-To: <20251215200909.3505001-5-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Dec 2025 08:34:13 +0800
X-Gm-Features: AQt7F2rJGOC7QTzpTbu0JRISbdMXIbnwAwzBl0SrxBf-HXcBW8H5zYMY6o0hjtk
Message-ID: <CAJnrk1YD=6qpZHRw31X4SRWGZcCraYzfSd0QjOuRg8HcsP+axA@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> Use the io_ring_submit_lock() helper in io_iopoll_req_issued() instead
> of open-coding the logic. io_ring_submit_unlock() can't be used for the
> unlock, though, due to the extra logic before releasing the mutex.
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>

This looks good to me.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  io_uring/io_uring.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6d6fe5bdebda..40582121c6a7 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1670,15 +1670,13 @@ void io_req_task_complete(struct io_tw_req tw_req=
, io_tw_token_t tw)
>   * accessing the kiocb cookie.
>   */
>  static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issu=
e_flags)
>  {
>         struct io_ring_ctx *ctx =3D req->ctx;
> -       const bool needs_lock =3D issue_flags & IO_URING_F_UNLOCKED;
>
>         /* workqueue context doesn't hold uring_lock, grab it now */
> -       if (unlikely(needs_lock))
> -               mutex_lock(&ctx->uring_lock);
> +       io_ring_submit_lock(ctx, issue_flags);
>
>         /*
>          * Track whether we have multiple files in our lists. This will i=
mpact
>          * how we do polling eventually, not spinning if we're on potenti=
ally
>          * different devices.
> @@ -1701,11 +1699,11 @@ static void io_iopoll_req_issued(struct io_kiocb =
*req, unsigned int issue_flags)
>         if (READ_ONCE(req->iopoll_completed))
>                 wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
>         else
>                 wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
>
> -       if (unlikely(needs_lock)) {
> +       if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
>                 /*
>                  * If IORING_SETUP_SQPOLL is enabled, sqes are either han=
dle
>                  * in sq thread task context or in io worker task context=
. If
>                  * current task context is sq thread, we don't need to ch=
eck
>                  * whether should wake up sq thread.
> --
> 2.45.2
>

