Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727CA701B41
	for <lists+io-uring@lfdr.de>; Sun, 14 May 2023 04:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjENCyV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 22:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjENCyU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 22:54:20 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0B72137
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 19:54:19 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-61b79b97ed8so53227446d6.1
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 19:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684032858; x=1686624858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjYv/aeMpMZX8G03VQ95cAuQ1U4HkB5pCa9C6VvmksY=;
        b=SobrXkMmbAj9HDO4f0zWPfKCFU5VBKlO8ivAgj6DebyG0CpvMakJhGTjs6QXiks8Mi
         w/bUSWEhWObgzcXs11HMuaX0uxlaTD1Wbt0nNehpFbNQps3pQnDYYSE6SrISlH9AOhR2
         K7MWns7woX/dOo22dtpmKhIPNRRdUa5xITVqt/OAMl2v/fjD7z0zn6d+HrSn5fMyj0gP
         zqGKKnLNnXxEHrtiOZooHcf51IZ2/vtx6W8qmhN8ffWdZW23DpzPNLJdRXkZ6OCVTATS
         d1WxUzxpxozjjWcisyjT+xIP8bKl0YpaGQb0XT7wDW33qhrl9mG8ZtL7OWNbToIiRdX5
         UyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684032858; x=1686624858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjYv/aeMpMZX8G03VQ95cAuQ1U4HkB5pCa9C6VvmksY=;
        b=VyHmYrbSuSFachoSoiY0WZwd3eADtQlM1hXLuXedCzwVvClddx7/++Ts0IuNPQf3ee
         ExJ4SayF8VQo8JVnxksqRWa2PGsh1jfSo5+n0IY9AGBaW3xthkMi5/VK2jBrw+SfM4Ya
         UewVyFcyE1zevviecDjRSlnZEnbI+RT0CWMYQiD+472nhV6+vXwHfxHpR2OePO0l6ajJ
         S5oZXJu0sIPm9iQnxIsCn0LndF5CCTcVaqf62Dym91kEUXVcdHXLr0BUQUL1omM8IJPB
         OzK9fIcXfJQXQOQ52g2PL+1XEWhilbFJ28cSPh382Y+yMytVPNUzUf9OC0F4RuVyXbpg
         Ikxg==
X-Gm-Message-State: AC+VfDzU8bO/aBUmlCFP1ixK/QwN9FZI/qjdPEceSCDIn9Af4aCkJlWE
        I9tGZvOkJMu8DeSgHDPwwTxBwXQDwX98vmglQ2gTV8FJ
X-Google-Smtp-Source: ACHHUZ73LTf7yVkVD/HWPGVj0zek7cypnEGDJUu7KsDDd56HvYIOlmgz+euO7wAs7cX1bP6/SYqBUUiEKlhnMc3XlQo=
X-Received: by 2002:a05:6214:234a:b0:61b:7aa5:d063 with SMTP id
 hu10-20020a056214234a00b0061b7aa5d063mr44834672qvb.41.1684032858234; Sat, 13
 May 2023 19:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230513141643.1037620-1-axboe@kernel.dk> <20230513141643.1037620-3-axboe@kernel.dk>
In-Reply-To: <20230513141643.1037620-3-axboe@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Sun, 14 May 2023 09:54:07 +0700
Message-ID: <CAOKbgA5U_o2igDLfsbmd7NSCSxtNXA=GV+1k3H-F5VF2szb-uQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] io_uring: return error pointer from io_mem_alloc()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On Sat, May 13, 2023 at 9:19=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> In preparation for having more than one time of ring allocator, make the
> existing one return valid/error-pointer rather than just NULL.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 3695c5e6fbf0..6266a870c89f 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2712,8 +2712,12 @@ static void io_mem_free(void *ptr)
>  static void *io_mem_alloc(size_t size)
>  {
>         gfp_t gfp =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __=
GFP_COMP;
> +       void *ret;
>
> -       return (void *) __get_free_pages(gfp, get_order(size));
> +       ret =3D (void *) __get_free_pages(gfp, get_order(size));
> +       if (ret)
> +               return ret;
> +       return ERR_PTR(-ENOMEM);
>  }
>
>  static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq=
_entries,
> @@ -3673,6 +3677,7 @@ static __cold int io_allocate_scq_urings(struct io_=
ring_ctx *ctx,
>  {
>         struct io_rings *rings;
>         size_t size, sq_array_offset;
> +       void *ptr;
>
>         /* make sure these are sane, as we already accounted them */
>         ctx->sq_entries =3D p->sq_entries;
> @@ -3683,8 +3688,8 @@ static __cold int io_allocate_scq_urings(struct io_=
ring_ctx *ctx,
>                 return -EOVERFLOW;
>
>         rings =3D io_mem_alloc(size);
> -       if (!rings)
> -               return -ENOMEM;
> +       if (IS_ERR(rings))
> +               return PTR_ERR(rings);
>
>         ctx->rings =3D rings;
>         ctx->sq_array =3D (u32 *)((char *)rings + sq_array_offset);
> @@ -3703,13 +3708,14 @@ static __cold int io_allocate_scq_urings(struct i=
o_ring_ctx *ctx,
>                 return -EOVERFLOW;
>         }
>
> -       ctx->sq_sqes =3D io_mem_alloc(size);
> -       if (!ctx->sq_sqes) {
> +       ptr =3D io_mem_alloc(size);
> +       if (IS_ERR(ptr)) {
>                 io_mem_free(ctx->rings);
>                 ctx->rings =3D NULL;
> -               return -ENOMEM;
> +               return PTR_ERR(ptr);
>         }
>
> +       ctx->sq_sqes =3D io_mem_alloc(size);

Should be 'ptr' rather than 'io_mem_alloc(size)' here.


--=20
Dmitry Kadashev
