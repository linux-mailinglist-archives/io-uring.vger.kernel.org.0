Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F4D224064
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGQQNg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 12:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGQQNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 12:13:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A38C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 09:13:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o8so15721448wmh.4
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 09:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LcaQI6rjpd2pTrCl4Jxk3+Vq7XQbVb0ciH3Fz1Aq2jw=;
        b=nxGsNDxfvHSul8B9zzG54yBABZ4tu5NwuutOF3R8ZS3QOLXsaru9YJhYQvTOiPLsEQ
         PkTG2dpXCGbSTpVCs5X6hpHG4YG7CcARNS4U2PdIxXhjAY5JscNl0vqAjDQZdWO3LsOd
         5+LS1vtsLSV5PX/hgEUX2uQdDkvYL8UGKZaLSRopYxFXMFWmU/awo8l4NpfdXTsr58UP
         nmr0nqlpDu5Yn+yRGuPJutMZUCNkKSswLwr2PnOXDQpUxCNa8reASYtlInoL2gpNGulW
         7cnxLlRcLhI8mCsShZolSQFMH/J/pD1S87XwUlLK7fIuMneRgsP381LjjSjflpm/xpay
         W1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LcaQI6rjpd2pTrCl4Jxk3+Vq7XQbVb0ciH3Fz1Aq2jw=;
        b=k0blBkkW4Kv7PQWmBnSAMNlSHoy/DoxuM30xT7K4oNlcfZhEnABXj3KI5TJN6bXN1L
         vaZ8jisU4+MM1CDhrEvEFmncK7xM1LB4W9Sy7hshctjPaRLjCGbhMcHUIkg+EBuhv2l1
         BfjcDB6mccwapxpEMIpMueJ44k2B+UhI5C24im3fhz1uWZWtS6bLAslcSIIjdlah2Y+b
         P1w/XMOgKGsB5w6x3Wecg5IldcX6LSVsnJMSzKcI7/7tCs0Yl7rXzC3yX3ORuEPhjH18
         AhBh+wSxhhFp7QLHJl/NwS6ECayktn+9fqBPkPflE6S7pFdqGuallsmoCRyGKrbn1afS
         y8sA==
X-Gm-Message-State: AOAM533hA+v0w14uasfZHaUWcZNrzChskXtHR+nMdIA4gWXDDINvqImP
        kbBZ9TwUodNqOno7kXtNrR08AZCjVEE+qLi4Odnimr8m
X-Google-Smtp-Source: ABdhPJworqr9WwUGfQMtkBYcO4o8/eS47lHqxwePYU3kzEvclR9nlzo3U57CkXmNi7wZTXW6+rqZSM0WWtyRFaoVGBw=
X-Received: by 2002:a1c:2109:: with SMTP id h9mr9797328wmh.174.1595002413531;
 Fri, 17 Jul 2020 09:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
In-Reply-To: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Fri, 17 Jul 2020 17:13:07 +0100
Message-ID: <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags invalid
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 14 Jul 2020 at 18:32, Daniele Salvatore Albano
<d.albano@gmail.com> wrote:
>
> Currently when an IORING_OP_FILES_UPDATE is submitted with the
> IOSQE_IO_LINK flag it fails with EINVAL even if it's considered a
> valid because the expectation is that there are no flags set for the
> sqe.
>
> The patch updates the check to allow IOSQE_IO_LINK and ensure that
> EINVAL is returned only for IOSQE_FIXED_FILE and IOSQE_BUFFER_SELECT.
>
> Signed-off-by: Daniele Albano <d.albano@gmail.com>
> ---
>  fs/io_uring.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ba70dc62f15f..7058b1a0bd39 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5205,7 +5205,14 @@ static int io_async_cancel(struct io_kiocb *req)
>  static int io_files_update_prep(struct io_kiocb *req,
>                                 const struct io_uring_sqe *sqe)
>  {
> -       if (sqe->flags || sqe->ioprio || sqe->rw_flags)
> +       unsigned flags = 0;
> +
> +       if (sqe->ioprio || sqe->rw_flags)
> +               return -EINVAL;
> +
> +       flags = READ_ONCE(sqe->flags);
> +
> +       if (flags & (IOSQE_FIXED_FILE | IOSQE_BUFFER_SELECT))
>                 return -EINVAL;
>
>         req->files_update.offset = READ_ONCE(sqe->off);
> --
> 2.25.1

Hi,

Did you get the chance to review this patch? Would you prefer to get
the flags loaded before the first branching?

Thanks!

Daniele
