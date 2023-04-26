Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7DA6EEC00
	for <lists+io-uring@lfdr.de>; Wed, 26 Apr 2023 03:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbjDZBoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 21:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbjDZBoh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 21:44:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B77B447
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 18:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682473429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zV6uJhSwFhVFaFkNUQ82Z1c0ehvVB7ApceysFQpwvZc=;
        b=EGjqfrT9sCcI9WfU4a+D8+n+IemYKZCfMcmoKaAdXYNhKTQ8RhOLo1dIOrJulY7sZdtIxr
        J+MO5jbiMs+L2Ge6HfAk54CQjjIWoPXKLZYiHZra5Kb0M1cq/Jg0X9kKm/9nQiFiVtoYdn
        ZfFr/33DSRnCqbXEY0hFz1H5WJYPaQE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-zULJhT-IPFyCOxze9tiUyw-1; Tue, 25 Apr 2023 21:43:42 -0400
X-MC-Unique: zULJhT-IPFyCOxze9tiUyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED0FA87A9E0;
        Wed, 26 Apr 2023 01:43:41 +0000 (UTC)
Received: from ovpn-8-28.pek2.redhat.com (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A6C540C6E67;
        Wed, 26 Apr 2023 01:43:38 +0000 (UTC)
Date:   Wed, 26 Apr 2023 09:43:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Message-ID: <ZEiBxgWnaXH8c5s3@ovpn-8-28.pek2.redhat.com>
References: <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
 <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
 <dd711c1b-8743-75ea-2368-a3f53316a030@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd711c1b-8743-75ea-2368-a3f53316a030@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 25, 2023 at 09:25:35AM -0600, Jens Axboe wrote:
> On 4/25/23 9:07?AM, Ming Lei wrote:
> > On Tue, Apr 25, 2023 at 08:50:33AM -0600, Jens Axboe wrote:
> >> On 4/25/23 8:42?AM, Ming Lei wrote:
> >>> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
> >>>> On 4/24/23 8:50?PM, Ming Lei wrote:
> >>>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
> >>>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
> >>>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
> >>>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
> >>>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
> >>>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
> >>>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
> >>>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
> >>>>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
> >>>>>>>>>>>> check in terms of whether or not we need to punt them if any of the
> >>>>>>>>>>>> NO_OFFLOAD flags are set.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>> ---
> >>>>>>>>>>>>  io_uring/io_uring.c |  2 +-
> >>>>>>>>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
> >>>>>>>>>>>>  io_uring/opdef.h    |  2 ++
> >>>>>>>>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
> >>>>>>>>>>>>
> >>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
> >>>>>>>>>>>> --- a/io_uring/io_uring.c
> >>>>>>>>>>>> +++ b/io_uring/io_uring.c
> >>>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >>>>>>>>>>>>  		return -EBADF;
> >>>>>>>>>>>>  
> >>>>>>>>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
> >>>>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
> >>>>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
> >>>>>>>>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
> >>>>>>>>>>>
> >>>>>>>>>>> I guess the check should be !def->always_iowq?
> >>>>>>>>>>
> >>>>>>>>>> How so? Nobody that takes pollable files should/is setting
> >>>>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
> >>>>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
> >>>>>>>>>> returns if nonblock == true.
> >>>>>>>>>
> >>>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
> >>>>>>>>> these OPs won't return -EAGAIN, then run in the current task context
> >>>>>>>>> directly.
> >>>>>>>>
> >>>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
> >>>>>>>> it :-)
> >>>>>>>
> >>>>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
> >>>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
> >>>>>>> ->always_iowq is a bit confusing?
> >>>>>>
> >>>>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
> >>>>>> be happy to take suggestions on what would make it clearer.
> >>>>>
> >>>>> Except for the naming, I am also wondering why these ->always_iowq OPs
> >>>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
> >>>>> shouldn't improve performance by doing so because these OPs are supposed
> >>>>> to be slow and always slept, not like others(buffered writes, ...),
> >>>>> can you provide one hint about not offloading these OPs? Or is it just that
> >>>>> NO_OFFLOAD needs to not offload every OPs?
> >>>>
> >>>> The whole point of NO_OFFLOAD is that items that would normally be
> >>>> passed to io-wq are just run inline. This provides a way to reap the
> >>>> benefits of batched submissions and syscall reductions. Some opcodes
> >>>> will just never be async, and io-wq offloads are not very fast. Some of
> >>>
> >>> Yeah, seems io-wq is much slower than inline issue, maybe it needs
> >>> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
> >>
> >> Indeed, depending on what is being linked, you may see io-wq activity
> >> which is not ideal.
> > 
> > That is why I prefer to fused command for ublk zero copy, because the
> > registering buffer approach suggested by Pavel and Ziyang has to link
> > register buffer OP with the actual IO OP, and it is observed that
> > IOPS drops to 1/2 in 4k random io test with registered buffer approach.
> 
> It'd be worth looking into if we can avoid io-wq for link execution, as
> that'd be a nice win overall too. IIRC, there's no reason why it can't
> be done like initial issue rather than just a lazy punt to io-wq.
> 
> That's not really related to fused command support or otherwise for
> that, it'd just be a generic improvement. But it may indeed make the
> linekd approach viable for that too.

Performance degrade with io-wq is just one reason, another thing is that
the current link model doesn't support 1:N dependency, such as, if one
buffer is registered, the following N OPs depend the registered
the buffer, but actually all the N OPs(requests) have to be run one by
one, that is one limit of current io_uring link model.

Fused command actually performs pretty good because:

1) no io-wq is involved

2) allow the following N OPs to be issued concurrently

3) avoid to register the buffer to per-context data(we can ignore
this part so far, cause the uring_lock should help us to avoid
the contention)

> 
> >>>> them can eventually be migrated to async support, if the underlying
> >>>> mechanics support it.
> >>>>
> >>>> You'll note that none of the ->always_iowq opcodes are pollable. If
> >>>
> >>> True, then looks the ->always_iowq flag doesn't make a difference here
> >>> because your patch clears IO_URING_F_NONBLOCK for !file_can_poll(req->file).
> 
> Actually not sure that's the case, as we have plenty of ops that are not
> pollable, yet are perfectly fine for a nonblocking issue. Things like
> any read/write on a regular file or block device.

But you mentioned "none of the ->always_iowq opcodes are pollable". If
that isn't true, it is fine to add ->always_iowq.

> 
> >> Yep, we may be able to just get rid of it. The important bit is really
> >> getting rid of the forced setting of REQ_F_FORCE_ASYNC which the
> >> previous reverts take care of. So we can probably just drop this one,
> >> let me give it a spin.
> >>
> >>> Also almost all these ->always_iowq OPs are slow and blocked, if they are
> >>> issued inline, the submission pipeline will be blocked.
> >>
> >> That is true, but that's very much the tradeoff you make by using
> >> NO_OFFLOAD. I would expect any users of this to have two rings, one for
> >> just batched submissions, and one for "normal" usage. Or maybe they only
> >> do the batched submissions and one is fine.
> > 
> > I guess that NO_OFFLOAD probably should be used for most of usecase,
> > cause it does avoid slow io-wq if io-wq perf won't be improved.
> >
> > Also there is other issue for two rings, such as sync/communication
> > between two rings, and single ring should be the easiest way.
> 
> I think some use cases may indeed just use that and be fine with it,
> also because it is probably not uncommon to bundle the issues and hence
> not really mix and match for issue. But this is a vastly different use
> case than fast IO cases, for storage and networking. Though those will
> bypass that anyway as they can do nonblocking issue just fine.
> 
> >>>> NO_OFFLOAD is setup, it's pointless NOT to issue them with NONBLOCK
> >>>> cleared, as you'd just get -EAGAIN and then need to call them again with
> >>>> NONBLOCK cleared from the same context.
> >>>
> >>> My point is that these OPs are slow and slept, so inline issue won't
> >>> improve performance actually for them, and punting to io-wq couldn't
> >>> be worse too. On the other side, inline issue may hurt perf because
> >>> submission pipeline is blocked when issuing these OPs.
> >>
> >> That is definitely not true, it really depends on which ops it is. For a
> >> lot of them, they don't generally block, but we have to be prepared for
> > 
> > OK, but fsync/fallocate does block.
> 
> They do, but statx, fadvise, madvise, rename, shutdown, etc (basically
> all the rest of them) do not for a lot of cases.

OK, but fsync/fallocate is often mixed with normal IOs.

Thanks,
Ming

