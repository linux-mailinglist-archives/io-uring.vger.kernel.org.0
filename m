Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2F6EE478
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbjDYPIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 11:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbjDYPIM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 11:08:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E044EC5
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682435245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iUE++JIBxLNwm9kSYkbee4sj1j5DxDD3ZdU12gH9ZNo=;
        b=is73/Ivistc8HMdtbqSVdm2VveDAaKV4zlMyyDDl103hejE7bAn5N3vtzlQagElCo4F3gP
        po8pGtrWxcl4hAzUbYsfyWqYZCMV0LfQbCmJkXa8qmJsNFQKTZ2ma2k1rWqMHfHJm6xrpd
        Y71Wt0EnYBkQlLHW/0+JgnIl6nYfmb4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-OTR0r0AvNN6-fMu3Zgm_1g-1; Tue, 25 Apr 2023 11:07:23 -0400
X-MC-Unique: OTR0r0AvNN6-fMu3Zgm_1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D61885CE6E;
        Tue, 25 Apr 2023 15:07:23 +0000 (UTC)
Received: from ovpn-8-24.pek2.redhat.com (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55BCA492C13;
        Tue, 25 Apr 2023 15:07:19 +0000 (UTC)
Date:   Tue, 25 Apr 2023 23:07:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Message-ID: <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
References: <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 25, 2023 at 08:50:33AM -0600, Jens Axboe wrote:
> On 4/25/23 8:42?AM, Ming Lei wrote:
> > On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
> >> On 4/24/23 8:50?PM, Ming Lei wrote:
> >>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
> >>>> On 4/24/23 8:13?PM, Ming Lei wrote:
> >>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
> >>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
> >>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
> >>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
> >>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
> >>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
> >>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
> >>>>>>>>>> check in terms of whether or not we need to punt them if any of the
> >>>>>>>>>> NO_OFFLOAD flags are set.
> >>>>>>>>>>
> >>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>> ---
> >>>>>>>>>>  io_uring/io_uring.c |  2 +-
> >>>>>>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
> >>>>>>>>>>  io_uring/opdef.h    |  2 ++
> >>>>>>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
> >>>>>>>>>> --- a/io_uring/io_uring.c
> >>>>>>>>>> +++ b/io_uring/io_uring.c
> >>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >>>>>>>>>>  		return -EBADF;
> >>>>>>>>>>  
> >>>>>>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
> >>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
> >>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
> >>>>>>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
> >>>>>>>>>
> >>>>>>>>> I guess the check should be !def->always_iowq?
> >>>>>>>>
> >>>>>>>> How so? Nobody that takes pollable files should/is setting
> >>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
> >>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
> >>>>>>>> returns if nonblock == true.
> >>>>>>>
> >>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
> >>>>>>> these OPs won't return -EAGAIN, then run in the current task context
> >>>>>>> directly.
> >>>>>>
> >>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
> >>>>>> it :-)
> >>>>>
> >>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
> >>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
> >>>>> ->always_iowq is a bit confusing?
> >>>>
> >>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
> >>>> be happy to take suggestions on what would make it clearer.
> >>>
> >>> Except for the naming, I am also wondering why these ->always_iowq OPs
> >>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
> >>> shouldn't improve performance by doing so because these OPs are supposed
> >>> to be slow and always slept, not like others(buffered writes, ...),
> >>> can you provide one hint about not offloading these OPs? Or is it just that
> >>> NO_OFFLOAD needs to not offload every OPs?
> >>
> >> The whole point of NO_OFFLOAD is that items that would normally be
> >> passed to io-wq are just run inline. This provides a way to reap the
> >> benefits of batched submissions and syscall reductions. Some opcodes
> >> will just never be async, and io-wq offloads are not very fast. Some of
> > 
> > Yeah, seems io-wq is much slower than inline issue, maybe it needs
> > to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
> 
> Indeed, depending on what is being linked, you may see io-wq activity
> which is not ideal.

That is why I prefer to fused command for ublk zero copy, because the
registering buffer approach suggested by Pavel and Ziyang has to link
register buffer OP with the actual IO OP, and it is observed that
IOPS drops to 1/2 in 4k random io test with registered buffer approach.

> 
> >> them can eventually be migrated to async support, if the underlying
> >> mechanics support it.
> >>
> >> You'll note that none of the ->always_iowq opcodes are pollable. If
> > 
> > True, then looks the ->always_iowq flag doesn't make a difference here
> > because your patch clears IO_URING_F_NONBLOCK for !file_can_poll(req->file).
> 
> Yep, we may be able to just get rid of it. The important bit is really
> getting rid of the forced setting of REQ_F_FORCE_ASYNC which the
> previous reverts take care of. So we can probably just drop this one,
> let me give it a spin.
> 
> > Also almost all these ->always_iowq OPs are slow and blocked, if they are
> > issued inline, the submission pipeline will be blocked.
> 
> That is true, but that's very much the tradeoff you make by using
> NO_OFFLOAD. I would expect any users of this to have two rings, one for
> just batched submissions, and one for "normal" usage. Or maybe they only
> do the batched submissions and one is fine.

I guess that NO_OFFLOAD probably should be used for most of usecase,
cause it does avoid slow io-wq if io-wq perf won't be improved.

Also there is other issue for two rings, such as sync/communication
between two rings, and single ring should be the easiest way.

> 
> >> NO_OFFLOAD is setup, it's pointless NOT to issue them with NONBLOCK
> >> cleared, as you'd just get -EAGAIN and then need to call them again with
> >> NONBLOCK cleared from the same context.
> > 
> > My point is that these OPs are slow and slept, so inline issue won't
> > improve performance actually for them, and punting to io-wq couldn't
> > be worse too. On the other side, inline issue may hurt perf because
> > submission pipeline is blocked when issuing these OPs.
> 
> That is definitely not true, it really depends on which ops it is. For a
> lot of them, they don't generally block, but we have to be prepared for

OK, but fsync/fallocate does block.

> them blocking. This is why they are offloaded. If they don't block and

Got it.

> execute fast, then the io-wq offload is easily a 2-3x slowdown, while
> the batched submission can make it more efficient than simply doing the
> normal syscalls as you avoid quite a few syscalls.
> 
> But you should not mix and match issue of these slower ops with "normal"
> issues, you should separate them.

OK, I will keep it in mind when writing io_uring applications.


thanks,
Ming

