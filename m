Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130F76D824D
	for <lists+io-uring@lfdr.de>; Wed,  5 Apr 2023 17:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbjDEPpa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Apr 2023 11:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbjDEPpa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Apr 2023 11:45:30 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFF96EAE
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 08:44:59 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id n17so25865524uaj.10
        for <io-uring@vger.kernel.org>; Wed, 05 Apr 2023 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680709498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEkRg1JTxczp1+GCiBIncEEXPwx9VdNwYT7nOp52QdY=;
        b=X1n/yT2efcJ7X8P8J0EwgSXI+P18rV1TkaSyqPZoRbagcMotKN5nQaRVeMoSnqUnkq
         eWMCsODAbbyrBUTczQHBpl2qQUWFy+Mm1x9mQ4l9NPx0x3K2AoK0DXhWFBXL9pL/pAEH
         TqS5wpc/HLHtei4KHB0zZ+nCQ0gDGhZU3skaXUPw/qiLrJBZzNpKcKhQ69DdFYKgs/31
         6bQYw5yQbN1FoQtrmNgo6hS2ttPtd5vxpklDnyoNIRNuPD7bhyr0sCt1/ulSoAd6jaK1
         Ajz7BY1IMQHxAdHIW6PNhEGS5jy6Bs3qOKQD9y4qCTGccXwr8IlG0ahuXd+AcFZHTasx
         BBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEkRg1JTxczp1+GCiBIncEEXPwx9VdNwYT7nOp52QdY=;
        b=cPatYE4PSbCn9dzv3ci0TwY9EvNJ05BDmUwbUtLPcLo1IC28EQYUukDFNkTqU9Qzxr
         +dgGoe8d6t8cJPgX9EWEvKZ0ySfcKx1FO+UIqx2+xCPHBcgxR+EjoZ9L7D9iKWU3cSsQ
         k2jKXqowHz0EDDOpfyNWZijRoV9Gfoyh9R51r1kG4uqyTn/1dhiRjx2Vma77iVObCwa+
         OG1xgKUeJ6RpO6goMmadVy2U165LeBKE7IJbsysvqy7GcQb6IoYFxZ+kz6lzinbXIIZQ
         i5FJAj4BSkdLUczkJwFjCjpP0aORyPHZmPWfgcNYfA1XV/akbt6L91AXeOBEo86lx895
         N8oA==
X-Gm-Message-State: AAQBX9dKBEq6uXkPRtGq5ai8ojSre13aSSZmwk54LFlOyXmxeiQ5b4K5
        OAbUIFGQm95HY/x39dvBo+yjRIrL63CUOPCwZC4198/FoQ==
X-Google-Smtp-Source: AKy350aYWW060KVlQn3l1SNkk6Z+MMZauG8MlfFzE9fhBKmbq+xzc87+b+29lvjw/H+8lrExz6WnPJLKZwPJazUN8xc=
X-Received: by 2002:a9f:3016:0:b0:764:72bd:aebf with SMTP id
 h22-20020a9f3016000000b0076472bdaebfmr4492572uab.1.1680709498342; Wed, 05 Apr
 2023 08:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
In-Reply-To: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Wed, 5 Apr 2023 21:14:22 +0530
Message-ID: <CACzX3AtFDJy1LqvrdgfJDie34Z+13eoa-nQ5J97mALzKJiHn2Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: assign ioucmd->cmd at async prep time
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 5, 2023 at 7:54=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Rather than check this in the fast path issue, it makes more sense to
> just assign the copy of the data when we're setting it up anyway. This
> makes the code a bit cleaner, and removes the need for this check in
> the issue path.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 3d825d939b13..f7a96bc76ea1 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -73,6 +73,7 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
>         cmd_size =3D uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQ=
E128);
>
>         memcpy(req->async_data, ioucmd->cmd, cmd_size);
> +       ioucmd->cmd =3D req->async_data;
>         return 0;
>  }
>
> @@ -129,9 +130,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
>                 WRITE_ONCE(ioucmd->cookie, NULL);
>         }
>
> -       if (req_has_async_data(req))
> -               ioucmd->cmd =3D req->async_data;
> -
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
>         if (ret =3D=3D -EAGAIN) {
>                 if (!req_has_async_data(req)) {
>
> --
> Jens Axboe
>

Looks good.

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
