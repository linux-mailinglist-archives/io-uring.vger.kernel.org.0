Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310264F180F
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345897AbiDDPQp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 11:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiDDPQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 11:16:44 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A342B196
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 08:14:47 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id n19-20020a9d7113000000b005cd9cff76c3so7458357otj.1
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 08:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cxv6eRZihM5d2+KA9Gy/o6F4LSNKpnki/Cp9tds22EU=;
        b=V5VblXb5znlCxPmvo3sok6C1BjFPwvtWApDnW/3AmtQzRz2Pb+vAQAjZRiMWfpcTUj
         DAjH0h4DRR8oLoVVKMCPLu8tsp6Tw9+tkz9P6saZJuQiGliDmrLL9VVgKxUpBfLHaU8i
         KxZ+OWEDQFWZi9yVegYuB8Z+FcG6R97cyrpySSjM5tVNJATny9acknhhOnP2ulygmY8S
         oHGjW83qHYGlGFp6Sw/qvlOzkCjaF/VITyR35ynSXIqZl6Hd+GFFckOSHFcm+Wneao9t
         ejDeeAIm9mYJy8RLcJNIKcvcQJrETrtU7HE5rBsK75/lDrok8jD3PJEdgwToS9Wqy6iD
         EW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cxv6eRZihM5d2+KA9Gy/o6F4LSNKpnki/Cp9tds22EU=;
        b=j3wruIrwlE3gD9IHB53XKLTCZcf5mYC9nMlJ6OuqYp6/lJ4WMjBj5cllvFGzPVsU+x
         e0XowFPHlLKZ0wv3GpTrvZs3aRnQ+dpm5RY0qoCkDfihl5W9+PDs/HuostZZma/WDGp4
         5CRoerlDMdRVL7d8SRzEzwhJWxrJiMUIWgrXMjEDUtYRDpQGRn0C9qc5/0yHGr3vVGOH
         eR18UM6IHj9lNSFWkB5/EmqxDYXhPVsqpehtNosbZQnXEeorIgBuPWHMUZ14IZ9C51ml
         AMMi4EZugXAtMJ5aWezR4qaebM/AsXnjk3gOUHcw8W3f1g3UDYnFhhcue3zy8opTniv9
         7vbA==
X-Gm-Message-State: AOAM530TTlYvG+yEWgLbrQak+06mc77oA42lQDSLQ1x47GpTNXxHfxIW
        kTy2GOeooSJoi0+AAbBB994J5hhYvNoqNi3/B57yrEjOWlbAzg==
X-Google-Smtp-Source: ABdhPJyJ8AjKxuFryAua5NpBUOSJbti4efWspiDfTtSRUNZCcdYnfI+uJUnGYQ8d9iPalw+hVsibY3rN7Lc6Tu1Lbvk=
X-Received: by 2002:a9d:eef:0:b0:5d2:8e2f:6729 with SMTP id
 102-20020a9d0eef000000b005d28e2f6729mr241040otj.86.1649085287158; Mon, 04 Apr
 2022 08:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com>
 <20220401110310.611869-4-joshi.k@samsung.com> <20220404071656.GC444@lst.de>
In-Reply-To: <20220404071656.GC444@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 4 Apr 2022 20:44:20 +0530
Message-ID: <CA+1E3r+nHBace_K1Zt-FrOgGF5d0=TDoNtU65bFuWX8R7p8+DQ@mail.gmail.com>
Subject: Re: [RFC 3/5] io_uring: add infra and support for IORING_OP_URING_CMD
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
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

On Mon, Apr 4, 2022 at 12:46 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Cann we plese spell out instastructure here?  Or did you mean
> infraread anyway :)

:-) sure, I see the problem with this shorthand now.

> > -enum io_uring_cmd_flags {
> > -     IO_URING_F_COMPLETE_DEFER       =3D 1,
> > -     IO_URING_F_UNLOCKED             =3D 2,
> > -     /* int's last bit, sign checks are usually faster than a bit test=
 */
> > -     IO_URING_F_NONBLOCK             =3D INT_MIN,
> > -};
>
> This doesn't actually get used anywhere outside of io_uring.c, so why
> move it?

This got missed out.
We are going to use it for things like this in nvme (from past series):

+ if (ioucmd && (ioucmd->flags & IO_URING_F_NONBLOCK)) {
+ rq_flags |=3D REQ_NOWAIT;
+ blk_flags |=3D BLK_MQ_REQ_NOWAIT;
+ }
+ req =3D nvme_alloc_request(q, cmd, blk_flags, rq_flags);

Also for polling too. Will fix this up in the next version.

> > +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
> > +{
> > +     req->uring_cmd.driver_cb(&req->uring_cmd);
> > +}
> > +
> > +void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > +                     void (*driver_cb)(struct io_uring_cmd *))
> > +{
> > +     struct io_kiocb *req =3D container_of(ioucmd, struct io_kiocb, ur=
ing_cmd);
> > +
> > +     req->uring_cmd.driver_cb =3D driver_cb;
> > +     req->io_task_work.func =3D io_uring_cmd_work;
> > +     io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOL=
L));
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
>
> I'm still not a fund of the double indirect call here.  I don't really
> have a good idea yet, but I plan to look into it.
>
> >  static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>
> Also it would be great to not add it between io_req_task_queue_fail and
> the callback set by it.

Right. Will change.

> > +void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret)
> > +{
> > +     struct io_kiocb *req =3D container_of(ioucmd, struct io_kiocb, ur=
ing_cmd);
> > +
> > +     if (ret < 0)
> > +             req_set_fail(req);
> > +     io_req_complete(req, ret);
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>
> It seems like all callers of io_req_complete actually call req_set_fail
> on failure.  So maybe it would be nice pre-cleanup to handle the
> req_set_fail call from =C4=A9o_req_complete?

io_tee and io_splice do slightly different handling.
If we take this route, it seems they can use __io_req_complete() instead.

> > +     /* queued async, consumer will call io_uring_cmd_done() when comp=
lete */
> > +     if (ret =3D=3D -EIOCBQUEUED)
> > +             return 0;
> > +     io_uring_cmd_done(ioucmd, ret);
>
> Why not:
>         if (ret !=3D -EIOCBQUEUED)
>                 io_uring_cmd_done(ioucmd, ret);
>         return 0;
>
> That being said I wonder why not just remove the retun value from
> ->async_cmd entirely and just require the implementation to always call
> io_uring_cmd_done?  That removes the confusion on who needs to call it
> entirely, similarly to what we do in the block layer for ->submit_bio.

Right, this seems doable at this point as we do not do any special
handling (in io_uring) on the return code.

> > +struct io_uring_cmd {
> > +     struct file     *file;
> > +     void            *cmd;
> > +     /* for irq-completion - if driver requires doing stuff in task-co=
ntext*/
> > +     void (*driver_cb)(struct io_uring_cmd *cmd);
> > +     u32             flags;
> > +     u32             cmd_op;
> > +     u16             cmd_len;
>
> The cmd_len field does not seem to actually be used anywhere.

Another stuff that got left out from the previous series :-(
Using this field for a bit of sanity checking at the moment. Like this in n=
vme:

+ if (ioucmd->cmd_len !=3D sizeof(struct nvme_passthru_cmd64))
+ return -EINVAL;
+ cptr =3D (struct nvme_passthru_cmd64 *)ioucmd->cmd;

> > +++ b/include/uapi/linux/io_uring.h
> > @@ -22,10 +22,12 @@ struct io_uring_sqe {
> >       union {
> >               __u64   off;    /* offset into file */
> >               __u64   addr2;
> > +             __u32   cmd_op;
> >       };
> >       union {
> >               __u64   addr;   /* pointer to buffer or iovecs */
> >               __u64   splice_off_in;
> > +             __u16   cmd_len;
> >       };
> >       __u32   len;            /* buffer size or number of iovecs */
> >       union {
> > @@ -60,7 +62,10 @@ struct io_uring_sqe {
> >               __s32   splice_fd_in;
> >               __u32   file_index;
> >       };
> > -     __u64   __pad2[2];
> > +     union {
> > +             __u64   __pad2[2];
> > +             __u64   cmd;
> > +     };
>
> Can someone explain these changes to me a little more?

All these three (cmd_op, cmd_len and cmd) are operation specific
fields. user-space supplies these into SQE, io_uring packages those
into "struct io_uring_cmd" and pass that down to the provider for
doing the real processing.

1. cmd_op =3D operation code for async cmd (e.g. passthru ioctl opcode
or whatever else we want to turn async from user-space)
2. cmd_len =3D actual length of async command (e.g. we have max 80 bytes
with big-sqe and for nvme-passthru we use the max, but for some other
usecase one can go with smaller length)
3. cmd =3D this is the starting-offset where async-command is placed (by
user-space) inside the big-sqe. 16 bytes in first-sqe, and next 64
bytes comes from second-sqe.

And if we were doing pointer-based command submission, this "cmd"
would have pointed to user-space command (of whatever length). Just to
put the entire thought-process across; I understand that we are not
taking that route.
