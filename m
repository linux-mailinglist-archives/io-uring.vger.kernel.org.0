Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB14C4D8C8D
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbiCNTll (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 15:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiCNTlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 15:41:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8BA3C728;
        Mon, 14 Mar 2022 12:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O8I9kM4lxKMvuadKy1n5LOwyKrbfUd0UbFzdS6hmdGQ=; b=t14eqSPghCpEa63fkKSiCmKVvh
        xNqelezraUVxrr7EMDFugofWwnMPP2DALVEmjQh7tj2VcK2JiiuHmF/tTpumxt4a600Z5ne0Scc5k
        JLmXqSwKOKQPtbReGWF//fSdwSdfgTJlaExh/A5Ev0LmMkuWensTWiEV+topIIuV2p+100Xwv+YkF
        02akJzDTl/RTxQhr/0XbwWO9t1wnPX1DHJL/27unLYhrjr+LMkeUFIaTQEztQiFo/ioLW/G64y9dC
        sLbmwW8R2Gp9iaZ4VFQtJgRh52Sr3XrC2tPutEda9JQPllr6WFliWXWaRGo32Ri5JmLl5dPTh3Ce1
        7C1gYjmQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nTqY8-006c4l-MY; Mon, 14 Mar 2022 19:40:12 +0000
Date:   Mon, 14 Mar 2022 12:40:12 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>,
        Kanchan Joshi <joshi.k@samsung.com>, jmorris@namei.org,
        serge@hallyn.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-security-module@vger.kernel.org, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        a.manzanares@samsung.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 03/17] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <Yi+aHJHelflSjRMF@bombadil.infradead.org>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5@epcas5p3.samsung.com>
 <20220308152105.309618-4-joshi.k@samsung.com>
 <YiqrE4K5TWeB7aLd@bombadil.infradead.org>
 <e3bfd028-ece7-d969-f47c-1181b17ac919@kernel.dk>
 <YiuC1fhEiRdo5bPd@bombadil.infradead.org>
 <92938b01-1746-af70-b325-e098488d8cdf@schaufler-ca.com>
 <Yi9uIqu4MMJzglqC@bombadil.infradead.org>
 <8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com>
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

On Mon, Mar 14, 2022 at 11:05:41AM -0700, Casey Schaufler wrote:
> On 3/14/2022 9:32 AM, Luis Chamberlain wrote:
> > On Mon, Mar 14, 2022 at 09:25:35AM -0700, Casey Schaufler wrote:
> > > On 3/11/2022 9:11 AM, Luis Chamberlain wrote:
> > > > On Thu, Mar 10, 2022 at 07:43:04PM -0700, Jens Axboe wrote:
> > > > > On 3/10/22 6:51 PM, Luis Chamberlain wrote:
> > > > > > On Tue, Mar 08, 2022 at 08:50:51PM +0530, Kanchan Joshi wrote:
> > > > > > > From: Jens Axboe <axboe@kernel.dk>
> > > > > > > 
> > > > > > > This is a file private kind of request. io_uring doesn't know what's
> > > > > > > in this command type, it's for the file_operations->async_cmd()
> > > > > > > handler to deal with.
> > > > > > > 
> > > > > > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > > > > > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > > > > > > ---
> > > > > > <-- snip -->
> > > > > > 
> > > > > > > +static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> > > > > > > +{
> > > > > > > +	struct file *file = req->file;
> > > > > > > +	int ret;
> > > > > > > +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> > > > > > > +
> > > > > > > +	ioucmd->flags |= issue_flags;
> > > > > > > +	ret = file->f_op->async_cmd(ioucmd);
> > > > > > I think we're going to have to add a security_file_async_cmd() check
> > > > > > before this call here. Because otherwise we're enabling to, for
> > > > > > example, bypass security_file_ioctl() for example using the new
> > > > > > iouring-cmd interface.
> > > > > > 
> > > > > > Or is this already thought out with the existing security_uring_*() stuff?
> > > > > Unless the request sets .audit_skip, it'll be included already in terms
> > > > > of logging.
> > > > Neat.
> > > > 
> > > > > But I'd prefer not to lodge this in with ioctls, unless
> > > > > we're going to be doing actual ioctls.
> > > > Oh sure, I have been an advocate to ensure folks don't conflate async_cmd
> > > > with ioctl. However it *can* enable subsystems to enable ioctl
> > > > passthrough, but each of those subsystems need to vet for this on their
> > > > own terms. I'd hate to see / hear some LSM surprises later.
> > > > 
> > > > > But definitely something to keep in mind and make sure that we're under
> > > > > the right umbrella in terms of auditing and security.
> > > > Paul, how about something like this for starters (and probably should
> > > > be squashed into this series so its not a separate commit) ?
> > > > 
> > > > >From f3ddbe822374cc1c7002bd795c1ae486d370cbd1 Mon Sep 17 00:00:00 2001
> > > > From: Luis Chamberlain <mcgrof@kernel.org>
> > > > Date: Fri, 11 Mar 2022 08:55:50 -0800
> > > > Subject: [PATCH] lsm,io_uring: add LSM hooks to for the new async_cmd file op
> > > > 
> > > > io-uring is extending the struct file_operations to allow a new
> > > > command which each subsystem can use to enable command passthrough.
> > > > Add an LSM specific for the command passthrough which enables LSMs
> > > > to inspect the command details.
> > > > 
> > > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > > ---
> > > >    fs/io_uring.c                 | 5 +++++
> > > >    include/linux/lsm_hook_defs.h | 1 +
> > > >    include/linux/lsm_hooks.h     | 3 +++
> > > >    include/linux/security.h      | 5 +++++
> > > >    security/security.c           | 4 ++++
> > > >    5 files changed, 18 insertions(+)
> > > > 
> > > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > > index 3f6eacc98e31..1c4e6b2cb61a 100644
> > > > --- a/fs/io_uring.c
> > > > +++ b/fs/io_uring.c
> > > > @@ -4190,6 +4190,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
> > > >    	struct io_ring_ctx *ctx = req->ctx;
> > > >    	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> > > >    	u32 ucmd_flags = READ_ONCE(sqe->uring_cmd_flags);
> > > > +	int ret;
> > > > +
> > > > +	ret = security_uring_async_cmd(ioucmd);
> > > > +	if (ret)
> > > > +		return ret;
> > > >    	if (!req->file->f_op->async_cmd)
> > > >    		return -EOPNOTSUPP;
> > > > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> > > > index 819ec92dc2a8..4a20f8e6b295 100644
> > > > --- a/include/linux/lsm_hook_defs.h
> > > > +++ b/include/linux/lsm_hook_defs.h
> > > > @@ -404,4 +404,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
> > > >    #ifdef CONFIG_IO_URING
> > > >    LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
> > > >    LSM_HOOK(int, 0, uring_sqpoll, void)
> > > > +LSM_HOOK(int, 0, uring_async_cmd, struct io_uring_cmd *ioucmd)
> > > >    #endif /* CONFIG_IO_URING */
> > > > diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> > > > index 3bf5c658bc44..21b18cf138c2 100644
> > > > --- a/include/linux/lsm_hooks.h
> > > > +++ b/include/linux/lsm_hooks.h
> > > > @@ -1569,6 +1569,9 @@
> > > >     *      Check whether the current task is allowed to spawn a io_uring polling
> > > >     *      thread (IORING_SETUP_SQPOLL).
> > > >     *
> > > > + * @uring_async_cmd:
> > > > + *      Check whether the file_operations async_cmd is allowed to run.
> > > > + *
> > > >     */
> > > >    union security_list_options {
> > > >    	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
> > > > diff --git a/include/linux/security.h b/include/linux/security.h
> > > > index 6d72772182c8..4d7f72813d75 100644
> > > > --- a/include/linux/security.h
> > > > +++ b/include/linux/security.h
> > > > @@ -2041,6 +2041,7 @@ static inline int security_perf_event_write(struct perf_event *event)
> > > >    #ifdef CONFIG_SECURITY
> > > >    extern int security_uring_override_creds(const struct cred *new);
> > > >    extern int security_uring_sqpoll(void);
> > > > +extern int security_uring_async_cmd(struct io_uring_cmd *ioucmd);
> > > >    #else
> > > >    static inline int security_uring_override_creds(const struct cred *new)
> > > >    {
> > > > @@ -2050,6 +2051,10 @@ static inline int security_uring_sqpoll(void)
> > > >    {
> > > >    	return 0;
> > > >    }
> > > > +static inline int security_uring_async_cmd(struct io_uring_cmd *ioucmd)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > >    #endif /* CONFIG_SECURITY */
> > > >    #endif /* CONFIG_IO_URING */
> > > > diff --git a/security/security.c b/security/security.c
> > > > index 22261d79f333..ef96be2f953a 100644
> > > > --- a/security/security.c
> > > > +++ b/security/security.c
> > > > @@ -2640,4 +2640,8 @@ int security_uring_sqpoll(void)
> > > >    {
> > > >    	return call_int_hook(uring_sqpoll, 0);
> > > >    }
> > > > +int security_uring_async_cmd(struct io_uring_cmd *ioucmd)
> > > > +{
> > > > +	return call_int_hook(uring_async_cmd, 0, ioucmd);
> > > I don't have a good understanding of what information is in ioucmd.
> > > I am afraid that there may not be enough for a security module to
> > > make appropriate decisions in all cases. I am especially concerned
> > > about the modules that use path hooks, but based on the issues we've
> > > always had with ioctl and the like I fear for all cases.
> > As Paul pointed out, this particular LSM hook would not be needed if we can
> > somehow ensure users of the cmd path use their respective LSMs there. It
> > is not easy to force users to have the LSM hook to be used, one idea
> > might be to have a registration mechanism which allows users to also
> > specify the LSM hook, but these can vary in arguments, so perhaps then
> > what is needed is the LSM type in enum form, and internally we have a
> > mapping of these. That way we slowly itemize which cmds we *do* allow
> > for, thus vetting at the same time a respective LSM hook. Thoughts?
> 
> tl;dr - Yuck.
> 
> I don't see how your registration mechanism would be easier than
> getting "users of the cmd path" to use the LSM mechanism the way
> everyone else does. What it would do is pass responsibility for
> dealing with LSM to the io_uring core team.

Agreed, I was just trying to be proactive to help with the LSM stuff.
But indeed, that path would be complicated and I agree probably not
the most practical one.

> Experience has shown
> that dealing with the security issues after the fact is much
> harder than doing it up front, even when developers wail about
> the burden. Sure, LSM is an unpleasant interface/mechanism, but
> so is locking, and no one gets away without addressing that.
> My $0.02.

So putting the onus on those file_operations which embrace async_cmd to
take into account LSMs seems to be the way to go then, which seems to
align with what Paul was suggesting.

  Luis
