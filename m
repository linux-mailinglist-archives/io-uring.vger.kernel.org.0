Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23AD4D69C8
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 21:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiCKU7B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 15:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiCKU67 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 15:58:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC7E1768DA;
        Fri, 11 Mar 2022 12:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eMQHTaULL4DYk//ji2yCOo0Dmn4myt1H30g/N/roRy4=; b=U25RVHWnNCFaEL1Ln9Wozt7+d/
        RPI294B2un79E/20bRCIiRF3U/75J7nPDqT4DChC9XZjkFNCVd6SGczeyUeujIRTcu8dQZ037uPWv
        tk+IZh+PuVUXBSRUnSJuVjPBz0XIq36vSvBWc76uudEQFl4scHaSLSpQWcj9yz/e0PviNG6foGn51
        E3O2r2awjzz8oZuXsWh57vC2YEc1HyhBWwsS9AjHZusQRRRtmg+hvJOwhdI7yC7j4ZUlgUEXaRICV
        1npV3y2xRwmUIEuwql7kxZZx32u5bi5e+uYVk0xLhlhcfp60dZlXww9OdIT4se4D55aq1WGOeJkPd
        q9k75Fyg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSmKV-000GNc-65; Fri, 11 Mar 2022 20:57:43 +0000
Date:   Fri, 11 Mar 2022 12:57:43 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kanchan Joshi <joshi.k@samsung.com>, jmorris@namei.org,
        serge@hallyn.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com, selinux@vger.kernel.org
Subject: Re: [PATCH 03/17] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <Yiu3x/Fxt/b5rNWB@bombadil.infradead.org>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5@epcas5p3.samsung.com>
 <20220308152105.309618-4-joshi.k@samsung.com>
 <YiqrE4K5TWeB7aLd@bombadil.infradead.org>
 <e3bfd028-ece7-d969-f47c-1181b17ac919@kernel.dk>
 <YiuC1fhEiRdo5bPd@bombadil.infradead.org>
 <CAHC9VhSNMH8XAKa43kCR8fZj-B1ucCd3R6WXOo3B4z80Bw2Kkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSNMH8XAKa43kCR8fZj-B1ucCd3R6WXOo3B4z80Bw2Kkw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 11, 2022 at 01:47:51PM -0500, Paul Moore wrote:
> On Fri, Mar 11, 2022 at 12:11 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > On Thu, Mar 10, 2022 at 07:43:04PM -0700, Jens Axboe wrote:
> > > On 3/10/22 6:51 PM, Luis Chamberlain wrote:
> > > > On Tue, Mar 08, 2022 at 08:50:51PM +0530, Kanchan Joshi wrote:
> > > >> From: Jens Axboe <axboe@kernel.dk>
> > > >>
> > > >> This is a file private kind of request. io_uring doesn't know what's
> > > >> in this command type, it's for the file_operations->async_cmd()
> > > >> handler to deal with.
> > > >>
> > > >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > >> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > > >> ---
> > > >
> > > > <-- snip -->
> > > >
> > > >> +static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> > > >> +{
> > > >> +  struct file *file = req->file;
> > > >> +  int ret;
> > > >> +  struct io_uring_cmd *ioucmd = &req->uring_cmd;
> > > >> +
> > > >> +  ioucmd->flags |= issue_flags;
> > > >> +  ret = file->f_op->async_cmd(ioucmd);
> > > >
> > > > I think we're going to have to add a security_file_async_cmd() check
> > > > before this call here. Because otherwise we're enabling to, for
> > > > example, bypass security_file_ioctl() for example using the new
> > > > iouring-cmd interface.
> > > >
> > > > Or is this already thought out with the existing security_uring_*() stuff?
> > >
> > > Unless the request sets .audit_skip, it'll be included already in terms
> > > of logging.
> >
> > Neat.
> 
> [NOTE: added the audit and SELinux lists to the To/CC line]
> 
> Neat, but I think we will need to augment things to support this new
> passthrough mechanism.

That's what my spidey instincts told me.

> The issue is that folks who look at audit logs need to be able to
> piece together what happened on the system using just what they have
> in the logs themselves.  As things currently stand with this patchset,
> the only bit of information they would have to go on would be
> "uring_op=<IORING_OP_URING_CMD>" which isn't very informative :)
> 
> You'll see a similar issue in the newly proposed LSM hook below, we
> need to be able to record information about not only the passthrough
> command, e.g. io_uring_cmd::cmd_op, but also the underlying
> device/handler so that we can put the passthrough command in the right
> context (as far as I can tell io_uring_cmd::cmd_op is specific to the
> device).  We might be able to leverage file_operations::owner::name
> for this, e.g. "uring_passthru_dev=nvme
> uring_passthru_op=<NVME_IOCTL_IO64_CMD>".

OK...

> > > But I'd prefer not to lodge this in with ioctls, unless
> > > we're going to be doing actual ioctls.
> >
> > Oh sure, I have been an advocate to ensure folks don't conflate async_cmd
> > with ioctl. However it *can* enable subsystems to enable ioctl
> > passthrough, but each of those subsystems need to vet for this on their
> > own terms. I'd hate to see / hear some LSM surprises later.
> 
> Same :)  Thanks for bringing this up with us while the patches are
> still in-progress/under-review, I think it makes for a much more
> pleasant experience for everyone.

Sure thing.

> > > But definitely something to keep in mind and make sure that we're under
> > > the right umbrella in terms of auditing and security.
> >
> > Paul, how about something like this for starters (and probably should
> > be squashed into this series so its not a separate commit) ?
> >
> > From f3ddbe822374cc1c7002bd795c1ae486d370cbd1 Mon Sep 17 00:00:00 2001
> > From: Luis Chamberlain <mcgrof@kernel.org>
> > Date: Fri, 11 Mar 2022 08:55:50 -0800
> > Subject: [PATCH] lsm,io_uring: add LSM hooks to for the new async_cmd file op
> >
> > io-uring is extending the struct file_operations to allow a new
> > command which each subsystem can use to enable command passthrough.
> > Add an LSM specific for the command passthrough which enables LSMs
> > to inspect the command details.
> >
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  fs/io_uring.c                 | 5 +++++
> >  include/linux/lsm_hook_defs.h | 1 +
> >  include/linux/lsm_hooks.h     | 3 +++
> >  include/linux/security.h      | 5 +++++
> >  security/security.c           | 4 ++++
> >  5 files changed, 18 insertions(+)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 3f6eacc98e31..1c4e6b2cb61a 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -4190,6 +4190,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
> >         struct io_ring_ctx *ctx = req->ctx;
> >         struct io_uring_cmd *ioucmd = &req->uring_cmd;
> >         u32 ucmd_flags = READ_ONCE(sqe->uring_cmd_flags);
> > +       int ret;
> > +
> > +       ret = security_uring_async_cmd(ioucmd);
> > +       if (ret)
> > +               return ret;
> 
> As a quick aside, for the LSM/audit folks the lore link for the full
> patchset is here:
> https://lore.kernel.org/io-uring/CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com/T/#m605e2fb7caf33e8880683fe6b57ade4093ed0643
> 
> Similar to what was discussed above with respect to auditing, I think
> we need to do some extra work here to make it easier for a LSM to put
> the IO request in the proper context.  We have io_uring_cmd::cmd_op
> via the @ioucmd parameter, which is good, but we need to be able to
> associate that with a driver to make sense of it.

It may not always be a driver, it can be built-in stuff.

> In the case of
> audit we could simply use the module name string, which is probably
> ideal as we would want a string anyway, but LSMs will likely want
> something more machine friendly.  That isn't to say we couldn't do a
> strcmp() on the module name string, but for something that aims to
> push performance as much as possible, doing a strcmp() on each
> operation seems a little less than optimal ;)

Yes this is a super hot path...

  Luis
