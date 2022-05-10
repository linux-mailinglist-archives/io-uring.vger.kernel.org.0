Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F97521D44
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244770AbiEJPBf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 11:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345492AbiEJPBN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 11:01:13 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C3B2BD203
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 07:24:20 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-edf9ddb312so17529763fac.8
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 07:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H8wZgU8UvZmckDD6XyjCSOwNe0fm/wzNV87CQKI4JyQ=;
        b=HYUku0OB1BO6au16AbfhELM3xx7b9xUXKdpFDm0I58f4tun6q2dBn2jRYh6uhyYcm8
         rt0lQeKckkRmSSo3DyIZJBywihDGOPJYgjIvqAfkprtgwkjQpi9tppcjTA7da0aJoSPD
         PxIHSD1bABTWWRH9u+/re6wzIgIhtw3hpiJQ3wFKR8ubXnVWZdhaZiuMQOSKAGoz37np
         cWB1PTneD/sjMEVpvpKrcoluKNrye7V3dYwFG5xdbM0hFccolqM5Sa7zHm/eyg88wEaY
         +6phBg5Y1FRkSsdCljSQOZjGIn7khCH7jXo9ctbw/1wYdVNrfmiPG6lUhtxxRNXXwdgO
         McOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H8wZgU8UvZmckDD6XyjCSOwNe0fm/wzNV87CQKI4JyQ=;
        b=7ibCZaBmFByvz9i5Fbo43GZyV0/x2vdUq5hC2g06ZwdFht8MyuW2VBJwkfNzXt/EL6
         y3xSrl8NZB0hMNA9Pe5W2/VVzEMPgzFSeQk8MHjsjm+pdY8sp39m1UHTmtWqETnup6TG
         zrXBSQy5SB1aQLX+T6ODhnZOs2BQRsJliZVKz7FuCTPb3UQGE+TR9yazg161GQf+gAIc
         nM4gXOZB0Vv3x7Ba+haD2jLF4J/S8JDvNFxofn/Gv9LaDAkAt+5mhZRseufz7drPnIbC
         tsE2SYeFu6gy8lkl8PAK+IbDo4Ck3B/nhAVvfe6/eKEAPRI5xBltvwD69M80kK9szW8c
         ASrQ==
X-Gm-Message-State: AOAM533gEU54sVV81fyBbu7Je2gQB8/7Agk6QmLsClZJOke78sNDanPr
        gAUWkt+0uTMYih0CrRZleCoTodFRuv5aC2mFX4I=
X-Google-Smtp-Source: ABdhPJzRfni1auhMC02gcn9MizbEEslal9V5Y98Pt/yQeQaEf4FgqtJf6KUyCMjcsHW9tVOoEoniGI9PYmVjSDjhtrI=
X-Received: by 2002:a05:6870:c392:b0:e9:f20:fa8a with SMTP id
 g18-20020a056870c39200b000e90f20fa8amr175116oao.15.1652192659312; Tue, 10 May
 2022 07:24:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
 <20220505060616.803816-2-joshi.k@samsung.com> <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
In-Reply-To: <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 10 May 2022 19:53:53 +0530
Message-ID: <CA+1E3r+airL_U0BzmLhiVPVkWdbiAXxxyHXONy9bGx4uuJFhdA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, Anuj Gupta <anuj20.g@samsung.com>,
        gost.dev@samsung.com
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

On Thu, May 5, 2022 at 9:47 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> > +static int io_uring_cmd_prep(struct io_kiocb *req,
> > +                          const struct io_uring_sqe *sqe)
> > +{
> > +     struct io_uring_cmd *ioucmd = &req->uring_cmd;
> > +     struct io_ring_ctx *ctx = req->ctx;
> > +
> > +     if (ctx->flags & IORING_SETUP_IOPOLL)
> > +             return -EOPNOTSUPP;
> > +     /* do not support uring-cmd without big SQE/CQE */
> > +     if (!(ctx->flags & IORING_SETUP_SQE128))
> > +             return -EOPNOTSUPP;
> > +     if (!(ctx->flags & IORING_SETUP_CQE32))
> > +             return -EOPNOTSUPP;
> > +     if (sqe->ioprio || sqe->rw_flags)
> > +             return -EINVAL;
> > +     ioucmd->cmd = sqe->cmd;
> > +     ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
> > +     return 0;
> > +}
>
> While looking at the other suggested changes, I noticed a more
> fundamental issue with the passthrough support. For any other command,
> SQE contents are stable once prep has been done. The above does do that
> for the basic items, but this case is special as the lower level command
> itself resides in the SQE.
>
> For cases where the command needs deferral, it's problematic. There are
> two main cases where this can happen:
>
> - The issue attempt yields -EAGAIN (we ran out of requests, etc). If you
>   look at other commands, if they have data that doesn't fit in the
>   io_kiocb itself, then they need to allocate room for that data and have
>   it be persistent

While we have io-wq retrying for this case, async_data is not allocated.
We need to do that explicitly inside io_uring_cmd(). Something like this -

if (ret == -EAGAIN) {
if (!req_has_async_data(req)) {
if (io_alloc_async_data(req)) return -ENOMEM;
io_uring_cmd_prep_async(req);
}
return ret;
}

> - Deferral is specified by the application, using eg IOSQE_IO_LINK or
>   IOSQE_ASYNC.
For this to work, we are missing ".needs_async_setup = 1" for
IORING_OP_URING_CMD.
