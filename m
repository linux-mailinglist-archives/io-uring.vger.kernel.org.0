Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010745758F0
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 03:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiGOBAV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 21:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiGOBAU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 21:00:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD9157E39;
        Thu, 14 Jul 2022 18:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NYgvPjfpETaXaFuTz3dmoG8Qh0QKnIF+2JiZK+rPjr8=; b=2wDFaCTxUcTUcGMYMT0P4L+Z5F
        UYI6Vg2ET6+Pa9uZNNJ8yEycgP5piNuhpAVq+9GVUNfyRmdYHtI8pHPv3KorPWlPajqDoB+zMFOu4
        YwK+2+4gTdePX0y9SFLYQeRryd+ofKQ1Nu/KzKdqn1PQqhgoULsE1m1KTPXurhzF62UI7sheOu7C/
        gIh8qGTAtCDQjP2tOU3nhs7AFA4Z2sASNA9/h4KCfnhmqsHZsREWc9oexCLAbg9Mim48yztJaoJ2G
        vrjF6S7u1ei7Q4Jg129fE+Vnd+kR2u1DfKdkGDRkNGjGXMPyBElCPfTKkuymq//EnRV1/iEhj+f9W
        /KnEJzKg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oC9gk-002wSc-Ro; Fri, 15 Jul 2022 01:00:14 +0000
Date:   Thu, 14 Jul 2022 18:00:14 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     axboe@kernel.dk, casey@schaufler-ca.com, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd
 file op
Message-ID: <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
> On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > add infrastructure for uring-cmd"), this extended the struct
> > file_operations to allow a new command which each subsystem can use
> > to enable command passthrough. Add an LSM specific for the command
> > passthrough which enables LSMs to inspect the command details.
> >
> > This was discussed long ago without no clear pointer for something
> > conclusive, so this enables LSMs to at least reject this new file
> > operation.
> >
> > [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> 
> [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
> v5.19-rcX releases, I'm going to be honest and say that I'm
> disappointed you didn't post the related LSM additions 

It does not mean I didn't ask for them too.

> until
> v5.19-rc6, especially given our earlier discussions.]

And hence since I don't see it either, it's on us now.

As important as I think LSMs are, I cannot convince everyone
to take them as serious as I do.

> While the earlier discussion may not have offered a detailed approach
> on how to solve this, I think it was rather conclusive in that the
> approach used then (and reproduced here) did not provide enough
> context to the LSMs to be able to make a decision.

Right...

> There were similar
> concerns when it came to auditing the command passthrough.  It appears
> that most of my concerns in the original thread still apply to this
> patch.
> 
> Given the LSM hook in this patch, it is very difficult (impossible?)
> to determine the requested operation as these command opcodes are
> device/subsystem specific.  The unfortunate result is that the LSMs
> are likely going to either allow all, or none, of the commands for a
> given device/subsystem, and I think we can all agree that is not a
> good idea.
> 
> That is the critical bit of feedback on this patch, but there is more
> feedback inline below.

Given a clear solution is not easily tangible at this point
I was hoping perhaps at least the abilility to enable LSMs to
reject uring-cmd would be better than nothing at this point.

> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  include/linux/lsm_hook_defs.h | 1 +
> >  include/linux/lsm_hooks.h     | 3 +++
> >  include/linux/security.h      | 5 +++++
> >  io_uring/uring_cmd.c          | 5 +++++
> >  security/security.c           | 4 ++++
> >  5 files changed, 18 insertions(+)
> 
> ...
> 
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 0a421ed51e7e..5e666aa7edb8 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -3,6 +3,7 @@
> >  #include <linux/errno.h>
> >  #include <linux/file.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/security.h>
> >
> >  #include <uapi/linux/io_uring.h>
> >
> > @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >         struct file *file = req->file;
> >         int ret;
> >
> > +       ret = security_uring_cmd(ioucmd);
> > +       if (ret)
> > +               return ret;
> > +
> >         if (!req->file->f_op->uring_cmd)
> >                 return -EOPNOTSUPP;
> >
> 
> In order to be consistent with most of the other LSM hooks, the
> 'req->file->f_op->uring_cmd' check should come before the LSM hook
> call. 

Sure.

> The general approach used in most places is to first validate
> the request and do any DAC based access checks before calling into the
> LSM.

OK.

Let me know how you'd like to proceed given our current status.

  Luis
