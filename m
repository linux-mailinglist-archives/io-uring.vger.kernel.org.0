Return-Path: <io-uring+bounces-4224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E51139B6AE8
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A56812824ED
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472EA1BD9C8;
	Wed, 30 Oct 2024 17:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ssq9kQ0E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39771E572F
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730308873; cv=none; b=pFWhyl5Y48okZQaNKpg4zK299WRZ33obmLwxtIb8j/pxYYwwPQZmQHxL0uTo0vT3PCRQDneZplg4t9qftxphXXrvEaHB1ApeYXPvLUL8rQi1AjOJ//7lN6xYiskN6Tjb5c+PtVCVAVDrJqZV2Mgm8boPq6FulAeSNvzDzF57P9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730308873; c=relaxed/simple;
	bh=fTvKbc3u9GDFHrX929DHRRdELxUE7wiV0TVd2chMj/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YdAKFkoGi1MzT0drOofrW/nKJqdfwlZy8lBaFwBj8QP0+6Hee9UMiKb1wdZxAE3NcYL0lhbn3PZLliFSYbywERgYb/KqGxUB/nn0AuJBbj8A3ErSGC8twENocLuRSQy5CY5xw0xnKPwlBXp6hO47BXt96Z+9IAvPceLZg9/f0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ssq9kQ0E; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4315ee633dcso14105e9.1
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 10:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730308869; x=1730913669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LV0B6hOqqgFXE9J5HuacEFRSqPWxYydHN4mwLVQPTxE=;
        b=Ssq9kQ0ELl66hVhMgqRA4PRqCzcA+TxjXSB+Q3sXNqlqkWDZMkVXVTgPqWVBDj+GL+
         25UZ2ZE/TcD88dmU9Ms1jf1UoD9n4sVKBNy4a24wo3jSHOgZPVsaKx/kONEt/FyUKYMc
         Ol8XNpCGnjbwuDRgTfOKS+WNbIouaoKnr7aGafpuEuLKrWKGD1E+ovKYwmbyFki4iDbY
         Psjy4AOMZWi8mYDMnot/AKwIR5SUOtgoNTVzEKPp9ZXJDy3V1UgxRJlXFGPMGSPo/LU1
         8a9tg7w/MQD5Y7FEhMwtUwBxjRlcU1xL3ydX+2kDiSuPxoYnOLlP71jsgfpgqavEP0zQ
         0FPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730308869; x=1730913669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LV0B6hOqqgFXE9J5HuacEFRSqPWxYydHN4mwLVQPTxE=;
        b=FPctPHetWiYE/pEDBPmkXgF9mXsuc2puwPFyr8nODUxOb9cSXxsGTLvgP0abJpr/qk
         XXRRcDAJzHqCXUIVpNoU8Ku7xIPTrPd6QoGFd6MW5ukNebDLjhnV2C1j0t/GaD1iTv03
         8ach/71TY+qDhzG4voywm37vhZMznjUYhSZyeE7YTKszANYmBjT0mUiPX4shcp7mCIZl
         zl3mGse05XVRCPs755beBmDyz24VZRRdd5tItxRe/LZXwO3vHJMdE4qtu6XwFO0obSED
         JxXi3JdOTYzPmXFeiAvE9xdcRXYuRzeE5wW+hww+LMHL8vT+CmxXNhdjvveuvLCjgOby
         Ji8A==
X-Gm-Message-State: AOJu0YyDCtE77ycbaPB9it96KdZSPP720Nyx1Yyz2I1giakphXz1ZedJ
	xc5ZhCGcIfvJawaSv/jgCSYPgNKOG8ObfG+EXQT6L/6CDAX1uVQprrpddufvJrgfSYNuEF6Xrx0
	vNLKU6gMH6j1nrV3K0sr3YUvcnjdrLGPeRoej
X-Gm-Gg: ASbGncuQ6XXebzd369xBv9d2CHR+kFVRoJh9K34p1LaD3kAqMbBujEvKlayusiRHQPr
	EzQy8Tgg7+anXSU5288GEV/QZmlMJ/79p9ZpKdH+FZ/+ENyzVzA1ALaeU3RI=
X-Google-Smtp-Source: AGHT+IFv2cA3kNVTY2aopwAGjF0cJtX5HlzKkYx+vp9b95ekiPOzRvDP5EipnnTkm42OdJ7xOW8tEj3/tH4sfShwSgE=
X-Received: by 2002:a05:600c:1d83:b0:42c:acd7:b59b with SMTP id
 5b1f17b1804b1-431b3cdeb16mr11554935e9.6.1730308868717; Wed, 30 Oct 2024
 10:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
In-Reply-To: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Wed, 30 Oct 2024 18:20:29 +0100
Message-ID: <CAG48ez1291n=0yi3PvT0V0YXxwtP9rUbXMghYsFdkia1Op8Mzw@mail.gmail.com>
Subject: Re: [PATCH RFC] io_uring/rsrc: add last-lookup cache hit to io_rsrc_node_lookup()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 5:58=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> This avoids array_index_nospec() for repeated lookups on the same node,
> which can be quite common (and costly). If a cached node is removed from

You're saying array_index_nospec() can be quite costly - which
architecture is this on? Is this the cost of the compare+subtract+and
making the critical path longer?

> the given table, it'll get cleared in the cache as well.
> io_reset_rsrc_node() takes care of that, which is used in the spots
> that's replacing a node.
>
> Note: need to double check this is 100% safe wrt speculation, but I
> believe it should be as we're not using the passed in value to index
> any arrays (directly).
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> Sending this out as an RFC, as array_index_nospec() can cause stalls for
> frequent lookups. For buffers, it's not unusual to have larger regions
> registered, which means hitting the same resource node lookup all the
> time.
>
> At the same time, I'm not 100% certain on the sanity of this. Before
> you'd always do:
>
> index =3D array_index_nospec(index, max_nr);
> node =3D some_table[index];
>
> and now you can do:
>
> if (index =3D=3D last_index)
>         return last_node;
> last_node =3D some_table[array_index_nospec(index, max_nr)];
> last_index =3D index;
> return last_node;
>
> which _seems_ like it should be safe as no array indexing occurs. Hence
> the Jann CC :-)

I guess the overall approach should be safe as long as you make sure
that last_node is always valid or NULL, though I wonder if it wouldn't
be a more straightforward improvement to make sure the table has a
power-of-two size and then using a bitwise AND to truncate the
index... with that I think you'd maybe just have a single-cycle
lengthening of the critical path? Though we would need a new helper
for that in nospec.h.

> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 77fd508d043a..c283179b0c89 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -57,6 +57,8 @@ struct io_wq_work {
>
>  struct io_rsrc_data {
>         unsigned int                    nr;
> +       unsigned int                    last_index;
> +       struct io_rsrc_node             *last_node;
>         struct io_rsrc_node             **nodes;
>  };
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 9829c51105ed..413d003bc5d7 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -139,6 +139,8 @@ __cold void io_rsrc_data_free(struct io_rsrc_data *da=
ta)
>                 if (data->nodes[data->nr])
>                         io_put_rsrc_node(data->nodes[data->nr]);
>         }
> +       data->last_node =3D NULL;
> +       data->last_index =3D -1U;
>         kvfree(data->nodes);
>         data->nodes =3D NULL;
>         data->nr =3D 0;
> @@ -150,6 +152,7 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *da=
ta, unsigned nr)
>                                         GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>         if (data->nodes) {
>                 data->nr =3D nr;
> +               data->last_index =3D -1U;
>                 return 0;
>         }
>         return -ENOMEM;
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index a40fad783a69..e2795daa877d 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -70,8 +70,16 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __u=
ser *arg,
>  static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_da=
ta *data,
>                                                        int index)
>  {
> -       if (index < data->nr)
> -               return data->nodes[array_index_nospec(index, data->nr)];
> +       if (index < data->nr) {
> +               if (index !=3D data->last_index) {
> +                       index =3D array_index_nospec(index, data->nr);
> +                       if (data->nodes[index]) {

I guess I'm not sure if eliding the array_index_nospec() is worth
adding a new branch here that you could mispredict... probably depends
on your workload, I guess?

> +                               data->last_index =3D index;
> +                               data->last_node =3D data->nodes[index];

This seems a bit functionally broken - if data->nodes[index] is NULL,
you just leave data->last_node set to its previous value and return
that?


> +                       }
> +               }
> +               return data->last_node;
> +       }
>         return NULL;
>  }
>
> @@ -85,8 +93,14 @@ static inline bool io_reset_rsrc_node(struct io_rsrc_d=
ata *data, int index)
>  {
>         struct io_rsrc_node *node =3D data->nodes[index];
>
> -       if (!node)
> +       if (!node) {
> +               WARN_ON_ONCE(index =3D=3D data->last_index);
>                 return false;
> +       }
> +       if (index =3D=3D data->last_index) {
> +               data->last_node =3D NULL;
> +               data->last_index =3D -1U;
> +       }
>         io_put_rsrc_node(node);
>         data->nodes[index] =3D NULL;
>         return true;
>
> --
> Jens Axboe
>

