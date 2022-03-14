Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F834D7FA2
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiCNKRz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 06:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiCNKRp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 06:17:45 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E92B3CFFD;
        Mon, 14 Mar 2022 03:16:34 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 25so21051070ljv.10;
        Mon, 14 Mar 2022 03:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g2kQQWoGvuzCNOwjCUHmsQiT1YFlZWmN+JspGoJIih0=;
        b=YYqjj7+S3GqSJBq9m6ML8fw6ENbwQ1C/XWkiDQj2yHu56ewmkX9IZ9vj8EVgD4OjTI
         WajUYxbk4LBdICy7HjinH37zpRvejN6liVIW1ZmghZSNQJIxNtRFrvRQ+BiPNrlG0B/x
         di/g6+ee4yxwJHTCtIyhRV8eA+iBgEBj3ACLJqmOOauRC6xi56AqL383tApYngiTD0px
         7Bru39Ifrxu7bDqNkJOfYlXi3NkQUnuiz9yZJqWW7n7DiPJUhjzWYE1akrxHCnj9mZlJ
         5MiP85uhjXuoTbbI7iUdFcrWlt7zVmuJeyJAMbzGSaWCZcIoNsHBG72+5DChhNlwQ03v
         FllA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g2kQQWoGvuzCNOwjCUHmsQiT1YFlZWmN+JspGoJIih0=;
        b=sowiaAyPmyQdiq9OXPTvvX5NFRWarN2VN/HDJ1cebXON0QytZSWmEccGsPeBpz+Uez
         ERQmj+VPQ19nr6a+YXytUP1B3597BsiZ4xU4tnXequtlRmFvY2LeT6XdXHXgspOrKTT7
         wdRqZqGOW5acwPjt8LFBagJDoUqZZwgTk3i0c/pMvawunpSBf3lYobSNWgQVsiZlRBZE
         6Un11Xqnx3PfmNdMFmu0KigekGBcss2Od8DU396pL+Jj3BiNUpgxBxRtj9K1pn5VV9b4
         Enj8EKM2ZrcJWRGq/nsUJdUOLmjIYGUsOt494S+FGo5VXekKmtOjVeFN8c/oy0aM3xas
         nG/Q==
X-Gm-Message-State: AOAM530t2udKsZNIDzatoRXcrrOyL5lgnTU6nPncybr+u5NYXsFFcQfj
        QgMCI8aYm0jhG1FugVLGw32XtvuV1AO6Cijvnws=
X-Google-Smtp-Source: ABdhPJzgJYIjQH+0jeYRbDg1V9Ghvt/wr18ldnhnYbEGosFiu3tJA4Gv3/AFX2+8vkkE+/syD1C9PBAz7mj6J7oTP/I=
X-Received: by 2002:a2e:808d:0:b0:23e:f35:506b with SMTP id
 i13-20020a2e808d000000b0023e0f35506bmr14196580ljg.285.1647252992365; Mon, 14
 Mar 2022 03:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152723epcas5p34460b4af720e515317f88dbb78295f06@epcas5p3.samsung.com>
 <20220308152105.309618-15-joshi.k@samsung.com> <20220311065007.GC17728@lst.de>
In-Reply-To: <20220311065007.GC17728@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 14 Mar 2022 15:46:08 +0530
Message-ID: <CA+1E3rKKCE53TJ9mJesK3UrPPa=Vqx6fxA+TAhj9v5hT452AuQ@mail.gmail.com>
Subject: Re: [PATCH 14/17] io_uring: add polling support for uring-cmd
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
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

On Fri, Mar 11, 2022 at 12:20 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Mar 08, 2022 at 08:51:02PM +0530, Kanchan Joshi wrote:
> > +             if (req->opcode == IORING_OP_URING_CMD ||
> > +                 req->opcode == IORING_OP_URING_CMD_FIXED) {
> > +                     /* uring_cmd structure does not contain kiocb struct */
> > +                     struct kiocb kiocb_uring_cmd;
> > +
> > +                     kiocb_uring_cmd.private = req->uring_cmd.bio;
> > +                     kiocb_uring_cmd.ki_filp = req->uring_cmd.file;
> > +                     ret = req->uring_cmd.file->f_op->iopoll(&kiocb_uring_cmd,
> > +                           &iob, poll_flags);
> > +             } else {
> > +                     ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob,
> > +                                                        poll_flags);
> > +             }
>
> This is just completely broken.  You absolutely do need the iocb
> in struct uring_cmd for ->iopoll to work.

But, after you did bio based polling, we need just the bio to poll.
iocb is a big structure (48 bytes), and if we try to place it in
struct io_uring_cmd, we will just blow up the cacheline in io_uring
(first one in io_kiocb).
So we just store that bio pointer in io_uring_cmd on submission
(please see patch 15).
And here on completion we pick that bio, and put that into this local
iocb, simply because  ->iopoll needs it.
Do you see I am still missing anything here?

-- 
Kanchan
