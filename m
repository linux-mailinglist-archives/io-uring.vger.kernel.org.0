Return-Path: <io-uring+bounces-6921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C88A4CF5F
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 00:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12CC11897C03
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 23:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27C422FAC3;
	Mon,  3 Mar 2025 23:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="a0ctZA0o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88AC237185
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741045052; cv=none; b=h2KnXchRMBVjA12WB6pf56zyJn1AoxLB4lqWxNL96exNLoCeuV8NRHFm8EAOd3RPhfxqWza+6a0yAndFLaLoAzcs3iozG1Jr4Z90ZEWb7FaDlpdbgLlaw5JkXK/DD2JWhO06nbTG4Sbv0wfh+0M8BEpmZ9hbJHT7GmlU9CO2wpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741045052; c=relaxed/simple;
	bh=gS5CPIxAeoFhcBHJisn1tTCPABesYUItKOvSkkwqqyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l6YFiqVIUt8gsxC4511kSz4yEq8mOLhxyv2ScWNQHr6akxdbRQsX+3JCbYKG7h2sFKRcBeFDMjF2nrvQRSnslks57f3grohTwDdLvJgeVoksVQLXmeKgKo38WmB8bZkWgiB/5OTNZ4oxErgabG9wLvWfFp4/5e5z9zB52gx1tlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=a0ctZA0o; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fc92215d15so1127774a91.1
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 15:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741045050; x=1741649850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B04rERQf7KmW36GXxBW/uoaLYmKJAk9SZLwjkeAa1nI=;
        b=a0ctZA0oaBo0kx9C/YlL3wcC5PzrnS306Fn8VRHT23PtuH15n32L4jtnGgTgt/wyAi
         gPTL8Ugs18gv4/RLlCuw2QWHtHRju5S52m3/QPXUiiD0BTabpHGF7DDKsDkkQL6i8Ptc
         5oyR07UMd+Xduo+dup8/S3jE0WVlpArulOF8Febh+V+oCePY6DYGPO0JrmeZCNYNPju6
         enpdhDSWDQFvS7FomjDm2Ud2vwGFvh0COzG1WW+NZfV6TPH0mmRPYv07dcUVceEEaSAp
         nlwf0EdWcsgzI0NDuOpF2PgrN9T5OCOOCXEIFH9Ml4240zSsRxCXV9jr1ga380Ry+s+Y
         hUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741045050; x=1741649850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B04rERQf7KmW36GXxBW/uoaLYmKJAk9SZLwjkeAa1nI=;
        b=p1TKAaEVIXuWyVtawzNs3/yt931l3hA0n3057X8YeQvxdi8fojf5pDL98Aa9KDQ0jF
         qNho9zKJjOugs5euKUIK84QXeTa/DSCnzWl6GMcZcmmk6RAGEVJUTsLyRa6IvQBB0hA6
         e5h7pXsWERPY90dGsrTZ8RftyXXdA73h/c3ceDhMClszFf1pHIzGtKOCJgZDXoheTupG
         Qv3oX8dmPOKDS5wDl4uN2VaCxEPtMVbNvP9rsixwnPb6MHB0OJFeAKim6gMyAPzzaA0F
         u6UYsZAnxdmOGYrSKMiFtMZabNDvGyefBd9XzBCKm2B4hA3ttcM3yVUfGhNffOFyhSaH
         flkw==
X-Gm-Message-State: AOJu0YzW3lmKHEukWXxik6uhYdrRG/Z3jbPAo6UcbeJZf3k355f0muZV
	niN82jQ1ilBl/3MBtPQs0VL+W81lzECnj0h3t1xWVWqkynqRS9s40yHVqkDIoBaP/MUEk2FPWNm
	ewdTDadI/YlGkm5QxIoUP+0cvOlDAzuWg5DPL6jBdqhHmSJea
X-Gm-Gg: ASbGnct5cKgrwZ4I9o2hWj8fg0KsgFVkNIIeWul4B2uE4pzj7dV3lkk33eTt053DqWM
	kAkc/2bAcwu327j1KZObzghoZgrZsr0fBcH5OuqK8meEqblKPPDJp41gj0Pc5HKikctROkFHHzP
	zZ4iZ5anBhNOy999D3mxBI2GaH
X-Google-Smtp-Source: AGHT+IEStjpPHodjNPbnLweu9J4+z+ioq9t3ogrn3ZdieOvwCdVouyedv04lp79TaQwiAtfr7Xa1TfxOwwUceqR1igw=
X-Received: by 2002:a17:90b:314d:b0:2fc:1845:9f68 with SMTP id
 98e67ed59e1d1-2ff3534a3bemr378086a91.6.1741045050002; Mon, 03 Mar 2025
 15:37:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com> <52aad74e49bfff5d7751ddd232cd4e2733dabae9.1741014186.git.asml.silence@gmail.com>
In-Reply-To: <52aad74e49bfff5d7751ddd232cd4e2733dabae9.1741014186.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 15:37:18 -0800
X-Gm-Features: AQ5f1Jo8of5x_EFtA4xE81syjW_GbNyzIecBGwnmdu-jgVrZFjJ1YAJbJszewIg
Message-ID: <CADUfDZoE_==mNira1O6yy9vqSkiJRU2tG9s7cJN2JX8zHPjfHQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] io_uring/net: convert to struct iou_vec
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 7:50=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Convert net.c to use struct iou_vec.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/alloc_cache.h |  9 --------
>  io_uring/net.c         | 51 ++++++++++++++++++------------------------
>  io_uring/net.h         |  6 ++---
>  3 files changed, 25 insertions(+), 41 deletions(-)
>
> diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
> index 0dd17d8ba93a..7094d9d0bd29 100644
> --- a/io_uring/alloc_cache.h
> +++ b/io_uring/alloc_cache.h
> @@ -16,15 +16,6 @@ bool io_alloc_cache_init(struct io_alloc_cache *cache,
>
>  void *io_cache_alloc_new(struct io_alloc_cache *cache, gfp_t gfp);
>
> -static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
> -{
> -       if (IS_ENABLED(CONFIG_KASAN)) {
> -               kfree(*iov);
> -               *iov =3D NULL;
> -               *nr =3D 0;
> -       }
> -}
> -
>  static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
>                                       void *entry)
>  {
> diff --git a/io_uring/net.c b/io_uring/net.c
> index cbb889b85cfc..a4b39343f345 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -136,11 +136,8 @@ static bool io_net_retry(struct socket *sock, int fl=
ags)
>
>  static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
>  {
> -       if (kmsg->free_iov) {
> -               kfree(kmsg->free_iov);
> -               kmsg->free_iov_nr =3D 0;
> -               kmsg->free_iov =3D NULL;
> -       }
> +       if (kmsg->vec.iovec)
> +               io_vec_free(&kmsg->vec);

io_vec_free() already checks vec.iovec, is it necessary to duplicate
it? If it's an unlikely case and you'd like to avoid the function call
overhead, then move io_vec_free() to the header file so it can be
inlined?

Best,
Caleb


>  }
>
>  static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_f=
lags)
> @@ -154,7 +151,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, u=
nsigned int issue_flags)
>         }
>
>         /* Let normal cleanup path reap it if we fail adding to the cache=
 */
> -       io_alloc_cache_kasan(&hdr->free_iov, &hdr->free_iov_nr);
> +       io_alloc_cache_vec_kasan(&hdr->vec);
>         if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
>                 req->async_data =3D NULL;
>                 req->flags &=3D ~REQ_F_ASYNC_DATA;
> @@ -171,7 +168,7 @@ static struct io_async_msghdr *io_msg_alloc_async(str=
uct io_kiocb *req)
>                 return NULL;
>
>         /* If the async data was cached, we might have an iov cached insi=
de. */
> -       if (hdr->free_iov)
> +       if (hdr->vec.iovec)
>                 req->flags |=3D REQ_F_NEED_CLEANUP;
>         return hdr;
>  }
> @@ -182,10 +179,7 @@ static void io_net_vec_assign(struct io_kiocb *req, =
struct io_async_msghdr *kmsg
>  {
>         if (iov) {
>                 req->flags |=3D REQ_F_NEED_CLEANUP;
> -               kmsg->free_iov_nr =3D kmsg->msg.msg_iter.nr_segs;
> -               if (kmsg->free_iov)
> -                       kfree(kmsg->free_iov);
> -               kmsg->free_iov =3D iov;
> +               io_vec_reset_iovec(&kmsg->vec, iov, kmsg->msg.msg_iter.nr=
_segs);
>         }
>  }
>
> @@ -208,9 +202,9 @@ static int io_net_import_vec(struct io_kiocb *req, st=
ruct io_async_msghdr *iomsg
>         struct iovec *iov;
>         int ret, nr_segs;
>
> -       if (iomsg->free_iov) {
> -               nr_segs =3D iomsg->free_iov_nr;
> -               iov =3D iomsg->free_iov;
> +       if (iomsg->vec.iovec) {
> +               nr_segs =3D iomsg->vec.nr;
> +               iov =3D iomsg->vec.iovec;
>         } else {
>                 nr_segs =3D 1;
>                 iov =3D &iomsg->fast_iov;
> @@ -468,7 +462,7 @@ static int io_bundle_nbufs(struct io_async_msghdr *km=
sg, int ret)
>         if (iter_is_ubuf(&kmsg->msg.msg_iter))
>                 return 1;
>
> -       iov =3D kmsg->free_iov;
> +       iov =3D kmsg->vec.iovec;
>         if (!iov)
>                 iov =3D &kmsg->fast_iov;
>
> @@ -584,9 +578,9 @@ static int io_send_select_buffer(struct io_kiocb *req=
, unsigned int issue_flags,
>                 .nr_iovs =3D 1,
>         };
>
> -       if (kmsg->free_iov) {
> -               arg.nr_iovs =3D kmsg->free_iov_nr;
> -               arg.iovs =3D kmsg->free_iov;
> +       if (kmsg->vec.iovec) {
> +               arg.nr_iovs =3D kmsg->vec.nr;
> +               arg.iovs =3D kmsg->vec.iovec;
>                 arg.mode =3D KBUF_MODE_FREE;
>         }
>
> @@ -599,9 +593,9 @@ static int io_send_select_buffer(struct io_kiocb *req=
, unsigned int issue_flags,
>         if (unlikely(ret < 0))
>                 return ret;
>
> -       if (arg.iovs !=3D &kmsg->fast_iov && arg.iovs !=3D kmsg->free_iov=
) {
> -               kmsg->free_iov_nr =3D ret;
> -               kmsg->free_iov =3D arg.iovs;
> +       if (arg.iovs !=3D &kmsg->fast_iov && arg.iovs !=3D kmsg->vec.iove=
c) {
> +               kmsg->vec.nr =3D ret;
> +               kmsg->vec.iovec =3D arg.iovs;
>                 req->flags |=3D REQ_F_NEED_CLEANUP;
>         }
>         sr->len =3D arg.out_len;
> @@ -1085,9 +1079,9 @@ static int io_recv_buf_select(struct io_kiocb *req,=
 struct io_async_msghdr *kmsg
>                         .mode =3D KBUF_MODE_EXPAND,
>                 };
>
> -               if (kmsg->free_iov) {
> -                       arg.nr_iovs =3D kmsg->free_iov_nr;
> -                       arg.iovs =3D kmsg->free_iov;
> +               if (kmsg->vec.iovec) {
> +                       arg.nr_iovs =3D kmsg->vec.nr;
> +                       arg.iovs =3D kmsg->vec.iovec;
>                         arg.mode |=3D KBUF_MODE_FREE;
>                 }
>
> @@ -1106,9 +1100,9 @@ static int io_recv_buf_select(struct io_kiocb *req,=
 struct io_async_msghdr *kmsg
>                 }
>                 iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, r=
et,
>                                 arg.out_len);
> -               if (arg.iovs !=3D &kmsg->fast_iov && arg.iovs !=3D kmsg->=
free_iov) {
> -                       kmsg->free_iov_nr =3D ret;
> -                       kmsg->free_iov =3D arg.iovs;
> +               if (arg.iovs !=3D &kmsg->fast_iov && arg.iovs !=3D kmsg->=
vec.iovec) {
> +                       kmsg->vec.nr =3D ret;
> +                       kmsg->vec.iovec =3D arg.iovs;
>                         req->flags |=3D REQ_F_NEED_CLEANUP;
>                 }
>         } else {
> @@ -1874,8 +1868,7 @@ void io_netmsg_cache_free(const void *entry)
>  {
>         struct io_async_msghdr *kmsg =3D (struct io_async_msghdr *) entry=
;
>
> -       if (kmsg->free_iov)
> -               io_netmsg_iovec_free(kmsg);
> +       io_vec_free(&kmsg->vec);
>         kfree(kmsg);
>  }
>  #endif
> diff --git a/io_uring/net.h b/io_uring/net.h
> index b804c2b36e60..43e5ce5416b7 100644
> --- a/io_uring/net.h
> +++ b/io_uring/net.h
> @@ -2,12 +2,12 @@
>
>  #include <linux/net.h>
>  #include <linux/uio.h>
> +#include <linux/io_uring_types.h>
>
>  struct io_async_msghdr {
>  #if defined(CONFIG_NET)
> -       struct iovec                    *free_iov;
> -       /* points to an allocated iov, if NULL we use fast_iov instead */
> -       int                             free_iov_nr;
> +       struct iou_vec                          vec;
> +
>         struct_group(clear,
>                 int                             namelen;
>                 struct iovec                    fast_iov;
> --
> 2.48.1
>
>

