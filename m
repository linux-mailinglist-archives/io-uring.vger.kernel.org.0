Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2DC5766E6
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 20:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiGOSqd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 14:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGOSqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 14:46:32 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F323C8ED
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 11:46:29 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a5so7912271wrx.12
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 11:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HgEvmkQJ8DtoN15myw3ivc8jTluNDOe94y/KIzzFT9M=;
        b=byEaUquOywUh4/sI3O3G5seHxneOlm644kl23aMyMln/dSMw+9cYnpM/LNL1/lM7wE
         8lDvBLEv47nOVylQKRUNRLVEu1nk7XBWsI2TlZk44qsX543geBtZ2WKGg1GPwz7mrgp6
         frhlEH5FCyH3tucdbbL+ILEYj4fzpPytsZRy0zL8U135ad8eLvL+8mK7yDm7ZGcuvINF
         0aX8gChK00UY3FTIx+e/cD3Odz7zNBiCoT0mSEO1XSWuntGXoxZoHua+Smk38hCNxFLR
         F9s8rEeQF42aeZs+/RlFhO4CLv4MP0HGruQ1YD3PjXngCO5IyECztMrbH0Kj2z9TMeng
         9R8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HgEvmkQJ8DtoN15myw3ivc8jTluNDOe94y/KIzzFT9M=;
        b=GV/Qd+hdHG/SXc/Wc2s6OW+j9COcxuOQPdLevGw6P8eLswTOQ7t0cqlwW2hK4ay/zW
         ohsT4/XbfJ8+rkJQ0/tYCrhqRvxUKMRbg8X5RCWAQqvHu4QidA4HiNOgkmbfdekZgpQe
         yi/ZW4JHXf/V7+Eixgprd7Q2iR66NFguUy1emTkHdY0WEV0NO4d/79Wp+0Pt2qMxcpLL
         HOJ/p1U+yv7Cv0yV0zCEpb+LUMq/AZe79s8LtLsq2Xwv7dTH0imFPnv/3L26teeIzmy9
         /F4xw2/ksH/ACKkcPKbVh7EMibiIBk9YYZVrG+tV5r446GDCLl/XCv30P5Pkg6ykVkyd
         Nd7w==
X-Gm-Message-State: AJIora9JGFb6FNfvlNGCSySHVkalBiCyizbJ4agB7Md09crYL5u11gL/
        HSd8hLSHFmSjn1fowpmSSDI81jVNZl3E+FMliXahVuM26PI+
X-Google-Smtp-Source: AGRyM1sMRQOGr4iboLKVVfr4M8h98/DvcanhVGhBrLtpBWNIjFHka5pgln3Ffjq4ZGfhCBUczGY4SyT7k+AEk6OM99o=
X-Received: by 2002:adf:d22f:0:b0:21d:6b26:8c6f with SMTP id
 k15-20020adfd22f000000b0021d6b268c6fmr14457397wrh.70.1657910788008; Fri, 15
 Jul 2022 11:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220714000536.2250531-1-mcgrof@kernel.org> <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
In-Reply-To: <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 15 Jul 2022 14:46:16 -0400
Message-ID: <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file op
To:     Luis Chamberlain <mcgrof@kernel.org>, casey@schaufler-ca.com
Cc:     axboe@kernel.dk, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
> > On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > > add infrastructure for uring-cmd"), this extended the struct
> > > file_operations to allow a new command which each subsystem can use
> > > to enable command passthrough. Add an LSM specific for the command
> > > passthrough which enables LSMs to inspect the command details.
> > >
> > > This was discussed long ago without no clear pointer for something
> > > conclusive, so this enables LSMs to at least reject this new file
> > > operation.
> > >
> > > [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> >
> > [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
> > v5.19-rcX releases, I'm going to be honest and say that I'm
> > disappointed you didn't post the related LSM additions
>
> It does not mean I didn't ask for them too.
>
> > until
> > v5.19-rc6, especially given our earlier discussions.]
>
> And hence since I don't see it either, it's on us now.

It looks like I owe you an apology, Luis.  While my frustration over
io_uring remains, along with my disappointment that the io_uring
developers continue to avoid discussing access controls with the LSM
community, you are not the author of the IORING_OP_URING_CMD.   You
are simply trying to do the right thing by adding the necessary LSM
controls and in my confusion I likely caused you a bit of frustration;
I'm sorry for that.

> As important as I think LSMs are, I cannot convince everyone
> to take them as serious as I do.

Yes, I think a lot of us are familiar with that feeling unfortunately :/

> > While the earlier discussion may not have offered a detailed approach
> > on how to solve this, I think it was rather conclusive in that the
> > approach used then (and reproduced here) did not provide enough
> > context to the LSMs to be able to make a decision.
>
> Right...
>
> > There were similar
> > concerns when it came to auditing the command passthrough.  It appears
> > that most of my concerns in the original thread still apply to this
> > patch.
> >
> > Given the LSM hook in this patch, it is very difficult (impossible?)
> > to determine the requested operation as these command opcodes are
> > device/subsystem specific.  The unfortunate result is that the LSMs
> > are likely going to either allow all, or none, of the commands for a
> > given device/subsystem, and I think we can all agree that is not a
> > good idea.
> >
> > That is the critical bit of feedback on this patch, but there is more
> > feedback inline below.
>
> Given a clear solution is not easily tangible at this point
> I was hoping perhaps at least the abilility to enable LSMs to
> reject uring-cmd would be better than nothing at this point.

Without any cooperation from the io_uring developers, that is likely
what we will have to do.  I know there was a lot of talk about this
functionality not being like another ioctl(), but from a LSM
perspective I think that is how we will need to treat it.

> > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > ---
> > >  include/linux/lsm_hook_defs.h | 1 +
> > >  include/linux/lsm_hooks.h     | 3 +++
> > >  include/linux/security.h      | 5 +++++
> > >  io_uring/uring_cmd.c          | 5 +++++
> > >  security/security.c           | 4 ++++
> > >  5 files changed, 18 insertions(+)
> >
> > ...
> >
> > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > index 0a421ed51e7e..5e666aa7edb8 100644
> > > --- a/io_uring/uring_cmd.c
> > > +++ b/io_uring/uring_cmd.c
> > > @@ -3,6 +3,7 @@
> > >  #include <linux/errno.h>
> > >  #include <linux/file.h>
> > >  #include <linux/io_uring.h>
> > > +#include <linux/security.h>
> > >
> > >  #include <uapi/linux/io_uring.h>
> > >
> > > @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> > >         struct file *file = req->file;
> > >         int ret;
> > >
> > > +       ret = security_uring_cmd(ioucmd);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > >         if (!req->file->f_op->uring_cmd)
> > >                 return -EOPNOTSUPP;
> > >
> >
> > In order to be consistent with most of the other LSM hooks, the
> > 'req->file->f_op->uring_cmd' check should come before the LSM hook
> > call.
>
> Sure.
>
> > The general approach used in most places is to first validate
> > the request and do any DAC based access checks before calling into the
> > LSM.
>
> OK.
>
> Let me know how you'd like to proceed given our current status.

Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
happening and it's unlikely the LSM folks are going to be able to
influence the design/implementation much at this point so we have to
do the best we can.  Given the existing constraints, I think your
patch is reasonable (although please do shift the hook call site down
a bit as discussed above), we just need to develop the LSM
implementations to go along with it.

Luis, can you respin and resend the patch with the requested changes?

Casey, it looks like Smack and SELinux are the only LSMs to implement
io_uring access controls.  Given the hook that Luis developed in this
patch, could you draft a patch for Smack to add the necessary checks?
I'll do the same for SELinux.  My initial thinking is that all we can
really do is check the access between the creds on the current task
(any overrides will have already taken place by the time the LSM hook
is called) with the io_uring_cmd:file label/creds; we won't be able to
provide much permission granularity for all the reasons previously
discussed, but I suspect that will be more of a SELinux problem than a
Smack problem (although I suspect Smack will need to treat this as
both a read and a write, which is likely less than ideal).

I think it's doubtful we will have all of this ready and tested in
time for v5.19, but I think we can have it ready shortly after that
and I'll mark all of the patches for -stable when I send them to
Linus.

I also think we should mark the patches with a 'Fixes:' line that
points at the IORING_OP_URING_CMD commit, ee692a21e9bf ("fs,io_uring:
add infrastructure for uring-cmd").

How does that sound to everyone?

-- 
paul-moore.com
