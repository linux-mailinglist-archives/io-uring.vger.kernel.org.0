Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019AB54AD64
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 11:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiFNJ36 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 05:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiFNJ36 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 05:29:58 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269E440A35;
        Tue, 14 Jun 2022 02:29:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id fu3so15971166ejc.7;
        Tue, 14 Jun 2022 02:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9AkUJLjKxpCtPozfky0qDOVE/YUSyibmUCJ911O1ME=;
        b=ZMT+RmlvqNsh5jo2KFs33OQi/LITKKRcaki81YPfuUOcRZ0qhbI+QLlZNU1zMZNdSn
         iHEm2nmHA35CFObgLmW7swjICxFUZqHd+rMTKhEBnDuwCo5OB44g7ouql5/0xT4wJbxf
         AD1Fj0jPiuvutxnLFGwRe3LXAo2OJY3dtt85sVJr28GVSIxFb+pBYeXWoiIQFmDblZTf
         z7ox5702zzd/OpBQXT1TR94ALd5pFYoFlnGOzecOdxoi/8FpHyIwsm2GcIWjLtV2qjSc
         G09zZ3nuinLOAYFJyF7B3vHDqyjKD1I0esdK2f0+NOx3b+yBF22usMv3ycn36F3Cw6gw
         1C1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9AkUJLjKxpCtPozfky0qDOVE/YUSyibmUCJ911O1ME=;
        b=h9+liGcd0L2MB8LrtbK3HDS5PYlphvpLCxPd8deK8K+PLHcIOK18E+IgC7o/PVxkKG
         t7pqWWT5b/rWPI4R8yHpn0r087k/fYhX6u/NpB8vvaD5vsK6+SE1SpdyqtuiuuCUSr8H
         vRdckNMakPJvC+uhvzmI5jOKGVs/N5T7eZpcgq6upnwkW3Oi122pd9Bv2fo+EF5frT1e
         hSp9ORPfENrAqLUl+SSvyaXHWfyA8gm0/QVkPHl4Yyv7qO08KqQyBZk5YXhLXz5X5IUI
         SV4X0sVZZehkeMoilY5LE7wPTy2RbIui7NXsng82nsBgBdBzV8FqZN2ZXmPp1fc8Gqu2
         ClLg==
X-Gm-Message-State: AJIora8VRazfOcxK13uZr7aT3PiPlu4Y2FF12PAh6aPUy0C3En+UU2tO
        Mq67fKrJlTNhDC6Y/Bp2nE+NpWotlkjwfDNuINg=
X-Google-Smtp-Source: ABdhPJzGqoIZfdM7ZWlho9Lg9B9tKFsDGmbPE4Hti4p7EBQcgkEIuSmezedLqrFLwwCUgKELKdbjVV03Z77mJfapERA=
X-Received: by 2002:a17:906:3f02:b0:718:bdf7:790d with SMTP id
 c2-20020a1709063f0200b00718bdf7790dmr3378536ejj.479.1655198992551; Tue, 14
 Jun 2022 02:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220614091359.124571-1-dzm91@hust.edu.cn> <CAMZfGtWswvFRp8UmnETRENsq1WBx9QvG7A_v8Eq62aaNA96wMw@mail.gmail.com>
In-Reply-To: <CAMZfGtWswvFRp8UmnETRENsq1WBx9QvG7A_v8Eq62aaNA96wMw@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 14 Jun 2022 17:29:18 +0800
Message-ID: <CAD-N9QViX0sS+w_g4cL1kaZaRduWwY8ZkOhmLzRL83MP0CVqAw@mail.gmail.com>
Subject: Re: [PATCH] fs: io_uring: remove NULL check before kfree
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 14, 2022 at 5:26 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Tue, Jun 14, 2022 at 5:14 PM Dongliang Mu <dzm91@hust.edu.cn> wrote:
> >
> > From: mudongliang <mudongliangabcd@gmail.com>
> >
> > kfree can handle NULL pointer as its argument.
> > According to coccinelle isnullfree check, remove NULL check
> > before kfree operation.
> >
> > Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
> > ---
> >  fs/io_uring.c | 15 +++++----------
> >  1 file changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 3aab4182fd89..bec47eae2a9b 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -3159,8 +3159,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
> >                         if ((req->flags & REQ_F_POLLED) && req->apoll) {
> >                                 struct async_poll *apoll = req->apoll;
> >
> > -                               if (apoll->double_poll)
> > -                                       kfree(apoll->double_poll);
> > +                               kfree(apoll->double_poll);
> >                                 list_add(&apoll->poll.wait.entry,
> >                                                 &ctx->apoll_cache);
> >                                 req->flags &= ~REQ_F_POLLED;
> > @@ -4499,8 +4498,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
> >         kiocb_done(req, ret, issue_flags);
> >  out_free:
> >         /* it's faster to check here then delegate to kfree */
>
> I am feeling you are not on the right way. See the comment
> here.

Thanks for your reply. I ignore them previously. Any method to make
coccicheck ignore such cases?

>
> Thanks.
>
> > -       if (iovec)
> > -               kfree(iovec);
> > +       kfree(iovec);
> >         return 0;
> >  }
> >
> > @@ -4602,8 +4600,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
> >         }
> >  out_free:
> >         /* it's reportedly faster than delegating the null check to kfree() */
>
> See here.
>
> > -       if (iovec)
> > -               kfree(iovec);
> > +       kfree(iovec);
> >         return ret;
> >  }
> >
> > @@ -6227,8 +6224,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> >                 req_set_fail(req);
> >         }
> >         /* fast path, check for non-NULL to avoid function call */
>
> here.
>
> > -       if (kmsg->free_iov)
> > -               kfree(kmsg->free_iov);
> > +       kfree(kmsg->free_iov);
> >         req->flags &= ~REQ_F_NEED_CLEANUP;
> >         if (ret >= 0)
> >                 ret += sr->done_io;
> > @@ -6481,8 +6477,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
> >         }
> >
> >         /* fast path, check for non-NULL to avoid function call */
>
> And here.
>
> > -       if (kmsg->free_iov)
> > -               kfree(kmsg->free_iov);
> > +       kfree(kmsg->free_iov);
> >         req->flags &= ~REQ_F_NEED_CLEANUP;
> >         if (ret >= 0)
> >                 ret += sr->done_io;
> > --
> > 2.35.1
> >
