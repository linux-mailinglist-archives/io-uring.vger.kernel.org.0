Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3714D54AD5C
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 11:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbiFNJ0j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 05:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbiFNJ0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 05:26:38 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E006EBE2D
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 02:26:36 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id p13so14198412ybm.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 02:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V/BnXF4Po6lT1XZ2J8UaiK92xTYbPrXaIJWtM2yCsTs=;
        b=DmEJPrYQ5KRdr/IysRapxIrM6PLZSlQCFCpbJa66mnsMYTCh8iqWd75CUkzo8QomQ8
         AdGsm/f5u2/noUYgSk7sCqDub+p3NZD8rDm6XjFL8FPXOYnZZZsrd2gjOXnsNZKEdTzn
         NRJlKSHnKC7wkCTLE2Nb66+t69XLGhqE4LqlYeBk6ozNqwJjyaQG70hKLcuezkp6CT4M
         snxQAqH4IK3Rj+w5Lh/vsaHZ3pvO2BitKp6YXcqJdU2Ey8/cnTp+ZL6dYQTSs31IOjQ8
         0xMuZvhxvzYZVsWY/1ugMuiA5lLo33JV0kLwUbNI6Z2YXp0dbVfKbAYjegB9tgqDzvYQ
         PY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/BnXF4Po6lT1XZ2J8UaiK92xTYbPrXaIJWtM2yCsTs=;
        b=c8XwJ/1PqpN3C2esKz3yQNm/+7daCOttb4G2/qQ667t8tkKH31TdMRVwiUR9zQVdUB
         KgmQdSFFur99fKLutRSbTt5GcrlWdI8C6aLk5VpaW+UDWyfgzaGsshp1zgzHsCdoQC26
         tX8R/ytA73Lf7eXH0pBmZmJV7ML5f/q4fN75yrYGsY7Fb75841Bl8IDyKxNJY73a6YZI
         2c7upFOPEASqwz6hPihdqUURBvm39Pw8bIu73eLtSMsaQRXbV7WfVgMCoJVaJRZhbZYw
         ZoO7kPXubEU8DX7px4JgNM9yFWqvdmUQoehTHsrMW/e9+vbyiTk48O8V2R4hHk9I5zNP
         6mrQ==
X-Gm-Message-State: AJIora/922Zkv5CbWFzkrSjkZQFId6Oe66GU7zEkhPrEACa1klnruPhy
        xy4Tq2CMtfX269mqLuBa4qYGIxAJXOPk0JN3RZ01XQ==
X-Google-Smtp-Source: AGRyM1u3euMHtMvSA3zS5wPrpM58C3v/B1a3dw8lQ53DFIsPSQpTHB/39Y7pVNF6nJbISO77GRAPVIoO5s1To7sUX7M=
X-Received: by 2002:a25:b218:0:b0:664:6da5:b5c5 with SMTP id
 i24-20020a25b218000000b006646da5b5c5mr4062165ybj.6.1655198796171; Tue, 14 Jun
 2022 02:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220614091359.124571-1-dzm91@hust.edu.cn>
In-Reply-To: <20220614091359.124571-1-dzm91@hust.edu.cn>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 14 Jun 2022 17:26:00 +0800
Message-ID: <CAMZfGtWswvFRp8UmnETRENsq1WBx9QvG7A_v8Eq62aaNA96wMw@mail.gmail.com>
Subject: Re: [PATCH] fs: io_uring: remove NULL check before kfree
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        mudongliang <mudongliangabcd@gmail.com>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 14, 2022 at 5:14 PM Dongliang Mu <dzm91@hust.edu.cn> wrote:
>
> From: mudongliang <mudongliangabcd@gmail.com>
>
> kfree can handle NULL pointer as its argument.
> According to coccinelle isnullfree check, remove NULL check
> before kfree operation.
>
> Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
> ---
>  fs/io_uring.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3aab4182fd89..bec47eae2a9b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3159,8 +3159,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>                         if ((req->flags & REQ_F_POLLED) && req->apoll) {
>                                 struct async_poll *apoll = req->apoll;
>
> -                               if (apoll->double_poll)
> -                                       kfree(apoll->double_poll);
> +                               kfree(apoll->double_poll);
>                                 list_add(&apoll->poll.wait.entry,
>                                                 &ctx->apoll_cache);
>                                 req->flags &= ~REQ_F_POLLED;
> @@ -4499,8 +4498,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>         kiocb_done(req, ret, issue_flags);
>  out_free:
>         /* it's faster to check here then delegate to kfree */

I am feeling you are not on the right way. See the comment
here.

Thanks.

> -       if (iovec)
> -               kfree(iovec);
> +       kfree(iovec);
>         return 0;
>  }
>
> @@ -4602,8 +4600,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>         }
>  out_free:
>         /* it's reportedly faster than delegating the null check to kfree() */

See here.

> -       if (iovec)
> -               kfree(iovec);
> +       kfree(iovec);
>         return ret;
>  }
>
> @@ -6227,8 +6224,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>                 req_set_fail(req);
>         }
>         /* fast path, check for non-NULL to avoid function call */

here.

> -       if (kmsg->free_iov)
> -               kfree(kmsg->free_iov);
> +       kfree(kmsg->free_iov);
>         req->flags &= ~REQ_F_NEED_CLEANUP;
>         if (ret >= 0)
>                 ret += sr->done_io;
> @@ -6481,8 +6477,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>         }
>
>         /* fast path, check for non-NULL to avoid function call */

And here.

> -       if (kmsg->free_iov)
> -               kfree(kmsg->free_iov);
> +       kfree(kmsg->free_iov);
>         req->flags &= ~REQ_F_NEED_CLEANUP;
>         if (ret >= 0)
>                 ret += sr->done_io;
> --
> 2.35.1
>
