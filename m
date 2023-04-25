Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45366EDA32
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 04:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjDYCOv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 22:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjDYCOt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 22:14:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48283A249
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 19:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682388838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TFyWrr3R6ys1sgdx3nz0ygLjXEiKqmSjf8uqBCDkMjA=;
        b=bAEHDgyLhGPau720V45mGJNrfqzG8oiBRTDOGgApFLX7iAYmVDp4WlrXl0WuHVgyMkWz3T
        z/TsAOAFAOWbgN+MJM+KxM7AzmZxrr12ZHBjbz0AUUPbaE56LgHZPVeatelcTOaL0OHjSj
        KA7iuQbFYLEmOW8oUwuhTtWXZbqlFPo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-7ZZUEA6aOQKHVJRlv2WyXw-1; Mon, 24 Apr 2023 22:13:54 -0400
X-MC-Unique: 7ZZUEA6aOQKHVJRlv2WyXw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 180D6811E7C;
        Tue, 25 Apr 2023 02:13:54 +0000 (UTC)
Received: from ovpn-8-24.pek2.redhat.com (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7211B492C13;
        Tue, 25 Apr 2023 02:13:51 +0000 (UTC)
Date:   Tue, 25 Apr 2023 10:13:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Message-ID: <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
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

On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
> On 4/24/23 6:57?PM, Ming Lei wrote:
> > On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
> >> On 4/24/23 1:30?AM, Ming Lei wrote:
> >>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
> >>>> Add an opdef bit for them, and set it for the opcodes where we always
> >>>> need io-wq punt. With that done, exclude them from the file_can_poll()
> >>>> check in terms of whether or not we need to punt them if any of the
> >>>> NO_OFFLOAD flags are set.
> >>>>
> >>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>> ---
> >>>>  io_uring/io_uring.c |  2 +-
> >>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
> >>>>  io_uring/opdef.h    |  2 ++
> >>>>  3 files changed, 23 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>>> index fee3e461e149..420cfd35ebc6 100644
> >>>> --- a/io_uring/io_uring.c
> >>>> +++ b/io_uring/io_uring.c
> >>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >>>>  		return -EBADF;
> >>>>  
> >>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
> >>>> -	    (!req->file || !file_can_poll(req->file)))
> >>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
> >>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
> >>>
> >>> I guess the check should be !def->always_iowq?
> >>
> >> How so? Nobody that takes pollable files should/is setting
> >> ->always_iowq. If we can poll the file, we should not force inline
> >> submission. Basically the ones setting ->always_iowq always do -EAGAIN
> >> returns if nonblock == true.
> > 
> > I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
> > these OPs won't return -EAGAIN, then run in the current task context
> > directly.
> 
> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
> it :-)

But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
->always_iowq is a bit confusing?


Thanks,
Ming

