Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E086EECC6
	for <lists+io-uring@lfdr.de>; Wed, 26 Apr 2023 05:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbjDZDil (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 23:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbjDZDik (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 23:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA92113
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 20:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682480271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9e4Q2Li5IZ50Rj4oBmdnCXeCh5Tdd7XrGPiRutYYVrU=;
        b=S1UHcwgroL3RNqQptKePlYrctRiEqZKj4QIIhYqbhIpnF4LzrZef82/gt7J6M1gceQMVRd
        NvHuvU7Go0YrzB9rpwyaeEJBFd873YCcE7Wl9fQZSBVvQICR/4BxbkkRte0zZBhlZS6mmY
        SU/whzPRcBRZa0I3o0T7oQyFlIUxPvg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-VcZ9W-ToMG-KnUY6WoVvxg-1; Tue, 25 Apr 2023 23:37:49 -0400
X-MC-Unique: VcZ9W-ToMG-KnUY6WoVvxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2172585A588;
        Wed, 26 Apr 2023 03:37:49 +0000 (UTC)
Received: from ovpn-8-28.pek2.redhat.com (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DD3C2166B44;
        Wed, 26 Apr 2023 03:37:45 +0000 (UTC)
Date:   Wed, 26 Apr 2023 11:37:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Message-ID: <ZEichRSjzZT7iKHh@ovpn-8-28.pek2.redhat.com>
References: <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
 <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
 <8d753778-1033-72ca-d810-141b7d6735a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d753778-1033-72ca-d810-141b7d6735a6@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 25, 2023 at 05:10:41PM +0100, Pavel Begunkov wrote:
> On 4/25/23 16:07, Ming Lei wrote:
> > On Tue, Apr 25, 2023 at 08:50:33AM -0600, Jens Axboe wrote:
> > > On 4/25/23 8:42?AM, Ming Lei wrote:
> > > > On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
> > > > > On 4/24/23 8:50?PM, Ming Lei wrote:
> > > > > > On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
> > > > > > > On 4/24/23 8:13?PM, Ming Lei wrote:
> > > > > > > > On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
> > > > > > > > > On 4/24/23 6:57?PM, Ming Lei wrote:
> > > > > > > > > > On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
> > > > > > > > > > > On 4/24/23 1:30?AM, Ming Lei wrote:
> > > > > > > > > > > > On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
> > > > > > > > > > > > > Add an opdef bit for them, and set it for the opcodes where we always
> > > > > > > > > > > > > need io-wq punt. With that done, exclude them from the file_can_poll()
> > > > > > > > > > > > > check in terms of whether or not we need to punt them if any of the
> > > > > > > > > > > > > NO_OFFLOAD flags are set.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >   io_uring/io_uring.c |  2 +-
> > > > > > > > > > > > >   io_uring/opdef.c    | 22 ++++++++++++++++++++--
> > > > > > > > > > > > >   io_uring/opdef.h    |  2 ++
> > > > > > > > > > > > >   3 files changed, 23 insertions(+), 3 deletions(-)
> > > > > > > > > > > > > 
> > > > > > > > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > > > > > > > > > > index fee3e461e149..420cfd35ebc6 100644
> > > > > > > > > > > > > --- a/io_uring/io_uring.c
> > > > > > > > > > > > > +++ b/io_uring/io_uring.c
> > > > > > > > > > > > > @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> > > > > > > > > > > > >   		return -EBADF;
> > > > > > > > > > > > >   	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
> > > > > > > > > > > > > -	    (!req->file || !file_can_poll(req->file)))
> > > > > > > > > > > > > +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
> > > > > > > > > > > > >   		issue_flags &= ~IO_URING_F_NONBLOCK;
> > > > > > > > > > > > 
> > > > > > > > > > > > I guess the check should be !def->always_iowq?
> > > > > > > > > > > 
> > > > > > > > > > > How so? Nobody that takes pollable files should/is setting
> > > > > > > > > > > ->always_iowq. If we can poll the file, we should not force inline
> > > > > > > > > > > submission. Basically the ones setting ->always_iowq always do -EAGAIN
> > > > > > > > > > > returns if nonblock == true.
> > > > > > > > > > 
> > > > > > > > > > I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
> > > > > > > > > > these OPs won't return -EAGAIN, then run in the current task context
> > > > > > > > > > directly.
> > > > > > > > > 
> > > > > > > > > Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
> > > > > > > > > it :-)
> > > > > > > > 
> > > > > > > > But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
> > > > > > > > not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
> > > > > > > > ->always_iowq is a bit confusing?
> > > > > > > 
> > > > > > > Yeah naming isn't that great, I can see how that's bit confusing. I'll
> > > > > > > be happy to take suggestions on what would make it clearer.
> > > > > > 
> > > > > > Except for the naming, I am also wondering why these ->always_iowq OPs
> > > > > > aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
> > > > > > shouldn't improve performance by doing so because these OPs are supposed
> > > > > > to be slow and always slept, not like others(buffered writes, ...),
> > > > > > can you provide one hint about not offloading these OPs? Or is it just that
> > > > > > NO_OFFLOAD needs to not offload every OPs?
> > > > > 
> > > > > The whole point of NO_OFFLOAD is that items that would normally be
> > > > > passed to io-wq are just run inline. This provides a way to reap the
> > > > > benefits of batched submissions and syscall reductions. Some opcodes
> > > > > will just never be async, and io-wq offloads are not very fast. Some of
> > > > 
> > > > Yeah, seems io-wq is much slower than inline issue, maybe it needs
> > > > to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
> > > 
> > > Indeed, depending on what is being linked, you may see io-wq activity
> > > which is not ideal.
> > 
> > That is why I prefer to fused command for ublk zero copy, because the
> > registering buffer approach suggested by Pavel and Ziyang has to link
> > register buffer OP with the actual IO OP, and it is observed that
> > IOPS drops to 1/2 in 4k random io test with registered buffer approach.
> 
> What's good about it is that you can use linked requests with it
> but you _don't have to_.

Can you explain it a bit?

The register buffer OP has to be done before using it since the buffer
register is done by calling ->uring_cmd().

> 
> Curiously, I just recently compared submitting 8 two-request links
> (16 reqs in total) vs submit(8)+submit(8), all that in a loop.
> The latter was faster. It wasn't a clean experiment, but shows
> that links are not super fast and would be nice to get them better.
> 
> For the register buf approach, I tried it out, looked good to me.
> It outperforms splice requests (with a hack that removes force
> iowq execution) by 5-10% with synthetic benchmark. Works better than
> splice(2) for QD>=2. Let me send it out, perhaps today, so we can
> figure out how it compares against ublk/fused and see the margin is.

Cool!

I will take a look and see if it can be used for ublk zero copy.


Thanks,
Ming

