Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF36ED972
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 02:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjDYA6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 20:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDYA6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 20:58:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05093E6
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 17:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682384273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fR7OsMrhKov3Kce1YlO7Tc3HawKkASrAR6VhDB0G/pk=;
        b=PWC27QFwH7Jg3pWkb4jCs/7+QhwgyVOXlxrINDDy648fbhFOvO9On+ZIKW2JioCBDeiB/5
        VRHCzpSpBcDsmwcGxDudbYcrYmzQ4L2JquagSmoOhODXq1EOlATeHsleiD0zIVHcknhPbn
        jGvM8LcSJDnyLFMWz+vP97D7O9lSiVc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-3SunIJsBPaeObY-ijPPnzQ-1; Mon, 24 Apr 2023 20:57:49 -0400
X-MC-Unique: 3SunIJsBPaeObY-ijPPnzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D23DC101A54F;
        Tue, 25 Apr 2023 00:57:48 +0000 (UTC)
Received: from ovpn-8-24.pek2.redhat.com (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FD472027043;
        Tue, 25 Apr 2023 00:57:45 +0000 (UTC)
Date:   Tue, 25 Apr 2023 08:57:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Message-ID: <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
> On 4/24/23 1:30?AM, Ming Lei wrote:
> > On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
> >> Add an opdef bit for them, and set it for the opcodes where we always
> >> need io-wq punt. With that done, exclude them from the file_can_poll()
> >> check in terms of whether or not we need to punt them if any of the
> >> NO_OFFLOAD flags are set.
> >>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >>  io_uring/io_uring.c |  2 +-
> >>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
> >>  io_uring/opdef.h    |  2 ++
> >>  3 files changed, 23 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >> index fee3e461e149..420cfd35ebc6 100644
> >> --- a/io_uring/io_uring.c
> >> +++ b/io_uring/io_uring.c
> >> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >>  		return -EBADF;
> >>  
> >>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
> >> -	    (!req->file || !file_can_poll(req->file)))
> >> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
> >>  		issue_flags &= ~IO_URING_F_NONBLOCK;
> > 
> > I guess the check should be !def->always_iowq?
> 
> How so? Nobody that takes pollable files should/is setting
> ->always_iowq. If we can poll the file, we should not force inline
> submission. Basically the ones setting ->always_iowq always do -EAGAIN
> returns if nonblock == true.

I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
these OPs won't return -EAGAIN, then run in the current task context
directly.


Thanks,
Ming

