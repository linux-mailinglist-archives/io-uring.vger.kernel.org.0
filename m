Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86705F0CFF
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 16:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiI3OFM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 10:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiI3OFK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 10:05:10 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F567BF1F2;
        Fri, 30 Sep 2022 07:05:09 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id a4so1765448uao.0;
        Fri, 30 Sep 2022 07:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gIimetwHznaZAvAfIsX13X27CMEyzU9Pww8hIggO0fw=;
        b=cnW1BdIwQxXFqQdIGdQKkJQdMdHlrKFHz1p4DhziNtTs0tO+tJ9Lx0H7U2/5rqoCei
         kk77fR3R4/LKx7IXh8tJMuljKjNchkGeNslTpaetLqrO/jmGRHySVscKwyt5W8W0H0Nw
         3Z6JJ31hsijU0lnXF0jz2TCTRxpt1aBEu5KedM50mNY7biix0dLKjOvd5HttVj+vXILa
         rjTnTgsrQgBGipEnQz6+zfsUH9JS0qqUyO9nV5yrwJB/0vWoDjgwzQL0zn2EUjQx3LEG
         bM+suOgoWvq/QlXHRqddlEtzJ57p+nHhC5P/DH4RSLKyHZ8zRL6Spaboiwp9JTaeKWwO
         teaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gIimetwHznaZAvAfIsX13X27CMEyzU9Pww8hIggO0fw=;
        b=oXOIEsDiwqbCNaZUgGyIwKV/AF+rbm00UEq+xvOWO5Od3/rVx+v19ZQ6Q7BbSWYxNo
         vqlkHceht/FyhGRHjSPwc9cZS9bbUj2CMHAAecrntoretnq9WXvEeYzpN/+Oo8t2k3RX
         VAzN2R7Su23WL86b3u9Zvyf0w4FcSUr2JI4rhpBpZGeB/M4E7+48VYDC/8gXxaez5xA9
         Jpg/PiBfUYdK0wYScBjAkTB2jKLlbKsSDzauViBE/5eIUlvp+3vz8zr79x6UdDlkMH5/
         HoBaaaGD4H7WxrAXGka4/YFqdLJXSHmChgLQyZCgtBT1/x24EPJMEnzgJLsrAp3/yaj2
         +M1Q==
X-Gm-Message-State: ACrzQf2JiQGdzsgo3mFHAz4DjGOkPWEjG7Ga9/xDrMRc1YqRqbSFSe3z
        dZRhDDKdBqav4+bxiPreOXvbbTYmj/96yKcG0I9dQT8znUYEvPbtEQ==
X-Google-Smtp-Source: AMsMyM7nKCE11zyNdHQZhsFQnKND0g9ACmhxTByy15NScbKCJquyPwcdiRsiKjb6uEP6Kf3aSxAStueT5FM5lY0t4aM=
X-Received: by 2002:a9f:2c46:0:b0:39e:fdd4:d272 with SMTP id
 s6-20020a9f2c46000000b0039efdd4d272mr5040761uaj.64.1664546706776; Fri, 30 Sep
 2022 07:05:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220930062749.152261-1-anuj20.g@samsung.com> <CGME20220930063809epcas5p328b9e14ead49e9612b905e6f5b6682f7@epcas5p3.samsung.com>
 <20220930062749.152261-3-anuj20.g@samsung.com> <a08df763-b84f-0360-f1bf-4dd1da3a97bc@kernel.dk>
In-Reply-To: <a08df763-b84f-0360-f1bf-4dd1da3a97bc@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Fri, 30 Sep 2022 19:34:30 +0530
Message-ID: <CACzX3At9PmwEV03E0PqjS1H1yz07tco-7GyLCKw_mOqFDHVq6g@mail.gmail.com>
Subject: Re: [PATCH for-next v12 02/12] io_uring: introduce fixed buffer
 support for io_uring_cmd
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Anuj Gupta <anuj20.g@samsung.com>, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 30, 2022 at 7:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/30/22 12:27 AM, Anuj Gupta wrote:
> > Add IORING_URING_CMD_FIXED flag that is to be used for sending io_uring
> > command with previously registered buffers. User-space passes the buffer
> > index in sqe->buf_index, same as done in read/write variants that uses
> > fixed buffers.
> >
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > ---
> >  include/linux/io_uring.h      |  2 +-
> >  include/uapi/linux/io_uring.h |  9 +++++++++
> >  io_uring/uring_cmd.c          | 18 +++++++++++++++++-
> >  3 files changed, 27 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> > index 1dbf51115c30..e10c5cc81082 100644
> > --- a/include/linux/io_uring.h
> > +++ b/include/linux/io_uring.h
> > @@ -28,7 +28,7 @@ struct io_uring_cmd {
> >               void *cookie;
> >       };
> >       u32             cmd_op;
> > -     u32             pad;
> > +     u32             flags;
> >       u8              pdu[32]; /* available inline for free use */
> >  };
> >
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 92f29d9505a6..ab7458033ee3 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -56,6 +56,7 @@ struct io_uring_sqe {
> >               __u32           hardlink_flags;
> >               __u32           xattr_flags;
> >               __u32           msg_ring_flags;
> > +             __u32           uring_cmd_flags;
> >       };
> >       __u64   user_data;      /* data to be passed back at completion time */
> >       /* pack this to avoid bogus arm OABI complaints */
> > @@ -219,6 +220,14 @@ enum io_uring_op {
> >       IORING_OP_LAST,
> >  };
> >
> > +/*
> > + * sqe->uring_cmd_flags
> > + * IORING_URING_CMD_FIXED    use registered buffer; pass thig flag
> > + *                           along with setting sqe->buf_index.
> > + */
> > +#define IORING_URING_CMD_FIXED       (1U << 0)
> > +
> > +
> >  /*
> >   * sqe->fsync_flags
> >   */
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 6a6d69523d75..05e8ad8cef87 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -4,6 +4,7 @@
> >  #include <linux/file.h>
> >  #include <linux/io_uring.h>
> >  #include <linux/security.h>
> > +#include <linux/nospec.h>
> >
> >  #include <uapi/linux/io_uring.h>
> >
> > @@ -77,7 +78,22 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >  {
> >       struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> >
> > -     if (sqe->rw_flags || sqe->__pad1)
> > +     if (sqe->__pad1)
> > +             return -EINVAL;
> > +
> > +     ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
> > +     if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> > +             struct io_ring_ctx *ctx = req->ctx;
> > +             u16 index;
> > +
> > +             req->buf_index = READ_ONCE(sqe->buf_index);
> > +             if (unlikely(req->buf_index >= ctx->nr_user_bufs))
> > +                     return -EFAULT;
> > +             index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
> > +             req->imu = ctx->user_bufs[index];
> > +             io_req_set_rsrc_node(req, ctx, 0);
> > +     }
> > +     if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
> >               return -EINVAL;
>
> Not that it _really_ matters, but why isn't this check the first thing
> that is done after reading the flags? No need to respin, I can just move
> it myself.
>
Right, checking this condition should have been the first thing to do after
reading the flags. Thanks for taking care of it.

> --
> Jens Axboe

--
Anuj Gupta
