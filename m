Return-Path: <io-uring+bounces-9296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBCDB36DB5
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 17:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4968F1BA350F
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 15:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBB31DF75A;
	Tue, 26 Aug 2025 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="de+BtegF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB90263C8E
	for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222043; cv=none; b=f2KcvoLCrgv1eIOQpjeZCAu+YfHfWJsHnSvqSYhNGpLSgD/z30lHLOUZQUBxYzpaAfLy69AkvjGOGh0el1vYDcNMoUVZnVV5q3vZ9cg29fw5l5ym0GcUA9dO0HHv6KiFUsQPADcv2hjweOtNzi6+JpApJRWBoq8SAPRV1eh148Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222043; c=relaxed/simple;
	bh=bqQqfImRMPYY9evWI26R5BNJfQwEYi3uST2CfV1kqTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=shPQL9laXzhVhPmp8MbqG78EeYDYi3xVvbUN6sNly80MceH0agSaX7BksCyKTocT70aLfK/1zoYKMgCzAbz38ZXUHdWUjvfp6yIcmOb2CuwuMI6i+yEZKDxI6ISLiLvx4YKC19xReR3C9P/nmM9+2gM5WcELomkyNvo5MyPKPT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=de+BtegF; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-246c9de68c8so4345935ad.0
        for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 08:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756222041; x=1756826841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XOZDnSYrw28oY5xTDOGvkcEukIEMGpjg+rWTt9sdus=;
        b=de+BtegF26wgv+ohPZaOo3b2IYjM1sd2TkYnoNyNbozyeTkoO11jpA/nG+zNDS04iA
         L6CO/RddYr4tT6xnEf4YjWtLIrqj4J1TKzQRQHGESDb86wDuPHj6Wew7A6kPbPEc7WMY
         DB7I2CgeaeqICRLvfOt6CDpP3kradwyofsZUAbATamfNgWscEczUNQa74VYHa8eWJM6e
         ZlpSY6Hw3MnA0dCYMzs8NgVZuJr93k1Qx1ivUyPIVCXeWQ3CcssHG02qpDx+tM/F28UW
         r/eR2PhvsAtr9cWbXP9NkSED28Kk/GT0irKefp/VxD8aYEjBcXmSQ9yLzwoSoS7vfp+4
         nE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222041; x=1756826841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3XOZDnSYrw28oY5xTDOGvkcEukIEMGpjg+rWTt9sdus=;
        b=OPagwZAejf7wwguPZg4109QLOVZ4FfT3XHugoAH4E42S7OXSuT0eKFhBDLIixyuweN
         31NnkY6r9IoLrR1jAiWEIbYDN9Z4gOsy0rNdlYdp+wN+D3M4QV9Pb7jFMeSEV1t62MWO
         qFnWFJf+BNtjuwOmFSZi/WM3q6O6/1hFHKoPTfuvlQk/+v7pHgITNDOnkQJtF+4WKNe1
         VqKqwt79mHawdiinEuaaoaBywYp6BP+lR24OlxxrzbYvN2uJhIscjRDj1HlO9eZmjH6/
         EMXFwvs4lvL1VKWRXOEE9rDvocWGQfs1Mq442dOdM6qy6lm6SOfqQAIqA7ITQi+71MRq
         phng==
X-Gm-Message-State: AOJu0Yw8Y5gGDocmPh202eoTNt/aftAKCZPuJmYyrgirxZXUAwDkHomc
	qx6qbXP3LVDWceXH26TvCMkDRBzIMgSnGca0IkJIGteSuUmCjkkHjr0h9Z5AafznNPpc8Zr2+cW
	cTH9pxNiS8AB5wWqFZlel6hjba+DrvYc7GrsV/nL7HqbMS81ZdBdgwAZ7eQ==
X-Gm-Gg: ASbGnctNoqsPeE5WFpHBVUPHBquybmcSBWH4VH0IE4NRWpBcRYVRAlnIUJ/nQ65Ciyj
	Kl++94aQbkvV3BVdZwCZFxw4GQmULxvBmg/pPMQQuqIFF3+PrmJyyZkc2wqTFQ6KPrtkCs3Akf0
	o4aMXIo+9vLb3ZpcJ81N1a98Ao/7S5Dp9GOx/SJbGDRmGda6TSUEJhDITW/FVuEPN5MXhHQHEQO
	UbsAVk3v3IZi0VWYLl3/ws=
X-Google-Smtp-Source: AGHT+IF7G9B73fTw+EDy37pa/AcrSETeCKliriKR0TfMxBRWnvwnFxJ2J2WHgccVIrbA6USiZFetbTV0pLghS2sojBs=
X-Received: by 2002:a17:902:da8b:b0:246:b41d:252e with SMTP id
 d9443c01a7336-246b42c6bbamr69810235ad.2.1756222040879; Tue, 26 Aug 2025
 08:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c93fcc03-ff41-4fe5-bea1-5fe3837eef73@kernel.dk>
In-Reply-To: <c93fcc03-ff41-4fe5-bea1-5fe3837eef73@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 26 Aug 2025 08:27:09 -0700
X-Gm-Features: Ac12FXyWamYeodASWOQT_8-GdwR-ixnSq8EFWSbzCSDZ_8OzNu09DX8-QQfleDk
Message-ID: <CADUfDZqcgkpbdY5jH8UwQNc5RBi-QKR=sw2fsgALPFzKBNcbUw@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: add async data clear/free helpers
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 7:16=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Futex recently had an issue where it mishandled how ->async_data and
> REQ_F_ASYNC_DATA is handled. To avoid future issues like that, add a set
> of helpers that either clear or clear-and-free the async data assigned
> to a struct io_kiocb.
>
> Convert existing manual handling of that to use the helpers. No intended
> functional changes in this patch.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/futex.c b/io_uring/futex.c
> index 9113a44984f3..64f3bd51c84c 100644
> --- a/io_uring/futex.c
> +++ b/io_uring/futex.c
> @@ -43,7 +43,6 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
>
>  static void __io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
>  {
> -       req->async_data =3D NULL;
>         hlist_del_init(&req->hash_node);
>         io_req_task_complete(req, tw);
>  }
> @@ -54,6 +53,7 @@ static void io_futex_complete(struct io_kiocb *req, io_=
tw_token_t tw)
>
>         io_tw_lock(ctx, tw);
>         io_cache_free(&ctx->futex_cache, req->async_data);
> +       io_req_async_data_clear(req, 0);
>         __io_futex_complete(req, tw);
>  }
>
> @@ -72,8 +72,7 @@ static void io_futexv_complete(struct io_kiocb *req, io=
_tw_token_t tw)
>                         io_req_set_res(req, res, 0);
>         }
>
> -       kfree(req->async_data);
> -       req->flags &=3D ~REQ_F_ASYNC_DATA;
> +       io_req_async_data_free(req);
>         __io_futex_complete(req, tw);
>  }
>
> @@ -232,9 +231,7 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int=
 issue_flags)
>                 io_ring_submit_unlock(ctx, issue_flags);
>                 req_set_fail(req);
>                 io_req_set_res(req, ret, 0);
> -               kfree(futexv);
> -               req->async_data =3D NULL;
> -               req->flags &=3D ~REQ_F_ASYNC_DATA;
> +               io_req_async_data_free(req);
>                 return IOU_COMPLETE;
>         }
>
> @@ -310,9 +307,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int =
issue_flags)
>         if (ret < 0)
>                 req_set_fail(req);
>         io_req_set_res(req, ret, 0);
> -       req->async_data =3D NULL;
> -       req->flags &=3D ~REQ_F_ASYNC_DATA;
> -       kfree(ifd);
> +       io_req_async_data_free(req);
>         return IOU_COMPLETE;
>  }
>
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 2e4f7223a767..86613b8224bd 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -281,6 +281,19 @@ static inline bool req_has_async_data(struct io_kioc=
b *req)
>         return req->flags & REQ_F_ASYNC_DATA;
>  }
>
> +static inline void io_req_async_data_clear(struct io_kiocb *req,
> +                                          io_req_flags_t extra_flags)
> +{
> +       req->flags &=3D ~(REQ_F_ASYNC_DATA|extra_flags);
> +       req->async_data =3D NULL;
> +}
> +
> +static inline void io_req_async_data_free(struct io_kiocb *req)
> +{
> +       kfree(req->async_data);
> +       io_req_async_data_clear(req, 0);
> +}

Would it make sense to also add a helper for assigning async_data that
would also make sure to set REQ_F_ASYNC_DATA?

> +
>  static inline void io_put_file(struct io_kiocb *req)
>  {
>         if (!(req->flags & REQ_F_FIXED_FILE) && req->file)
> diff --git a/io_uring/net.c b/io_uring/net.c
> index b00cd2f59091..d2ca49ceb79d 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -178,10 +178,8 @@ static void io_netmsg_recycle(struct io_kiocb *req, =
unsigned int issue_flags)
>         if (hdr->vec.nr > IO_VEC_CACHE_SOFT_CAP)
>                 io_vec_free(&hdr->vec);
>
> -       if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
> -               req->async_data =3D NULL;
> -               req->flags &=3D ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
> -       }
> +       if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr))
> +               io_req_async_data_clear(req, REQ_F_NEED_CLEANUP);
>  }
>
>  static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 906e869d330a..dcde5bb7421a 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -154,10 +154,8 @@ static void io_rw_recycle(struct io_kiocb *req, unsi=
gned int issue_flags)
>         if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
>                 io_vec_free(&rw->vec);
>
> -       if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
> -               req->async_data =3D NULL;
> -               req->flags &=3D ~REQ_F_ASYNC_DATA;
> -       }
> +       if (io_alloc_cache_put(&req->ctx->rw_cache, rw))
> +               io_req_async_data_clear(req, 0);
>  }
>
>  static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_f=
lags)
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index ff1d029633b8..09f2a47a0020 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -37,8 +37,7 @@ static void io_req_uring_cleanup(struct io_kiocb *req, =
unsigned int issue_flags)
>
>         if (io_alloc_cache_put(&req->ctx->cmd_cache, ac)) {
>                 ioucmd->sqe =3D NULL;
> -               req->async_data =3D NULL;
> -               req->flags &=3D ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
> +               io_req_async_data_clear(req, 0);

Looks like the REQ_F_NEED_CLEANUP got lost here. Other than that,

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

>         }
>  }
>
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> index e07a94694397..26c118f3918d 100644
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -37,9 +37,7 @@ static void io_waitid_free(struct io_kiocb *req)
>         struct io_waitid_async *iwa =3D req->async_data;
>
>         put_pid(iwa->wo.wo_pid);
> -       kfree(req->async_data);
> -       req->async_data =3D NULL;
> -       req->flags &=3D ~REQ_F_ASYNC_DATA;
> +       io_req_async_data_free(req);
>  }
>
>  static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
>
> --
> Jens Axboe
>
>

