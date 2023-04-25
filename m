Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABEC6EDA5A
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 04:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDYCwB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 22:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDYCwA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 22:52:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5C4BBAC
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 19:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682391025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mdvySwsE9+S45zJowJUsgKvR2TzJdEKUz7YJJOlsaMI=;
        b=SFqRLh24EPz1R/MJtSukXfCjTx+Zrakmfma6xN2DEs53GpfyWIISfTluDBGNVF0jpyawgJ
        lIKwKEKpqK8RHNbVnOB0knHMjlUrD80QUfF32DAX1HHaSsOi/CM2yThu7EBGofG8+Cztwi
        Ue4wel0hQL/+i/fTkX5n7Ci+z5QYqKI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-KdG1EmP2OF6-OzTk5Mthaw-1; Mon, 24 Apr 2023 22:50:21 -0400
X-MC-Unique: KdG1EmP2OF6-OzTk5Mthaw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C5403C0ED64;
        Tue, 25 Apr 2023 02:50:21 +0000 (UTC)
Received: from ovpn-8-24.pek2.redhat.com (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3C88492B0F;
        Tue, 25 Apr 2023 02:50:18 +0000 (UTC)
Date:   Tue, 25 Apr 2023 10:50:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Message-ID: <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
> On 4/24/23 8:13?PM, Ming Lei wrote:
> > On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
> >> On 4/24/23 6:57?PM, Ming Lei wrote:
> >>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
> >>>> On 4/24/23 1:30?AM, Ming Lei wrote:
> >>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
> >>>>>> Add an opdef bit for them, and set it for the opcodes where we always
> >>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
> >>>>>> check in terms of whether or not we need to punt them if any of the
> >>>>>> NO_OFFLOAD flags are set.
> >>>>>>
> >>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>> ---
> >>>>>>  io_uring/io_uring.c |  2 +-
> >>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
> >>>>>>  io_uring/opdef.h    |  2 ++
> >>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>>>>> index fee3e461e149..420cfd35ebc6 100644
> >>>>>> --- a/io_uring/io_uring.c
> >>>>>> +++ b/io_uring/io_uring.c
> >>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >>>>>>  		return -EBADF;
> >>>>>>  
> >>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
> >>>>>> -	    (!req->file || !file_can_poll(req->file)))
> >>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
> >>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
> >>>>>
> >>>>> I guess the check should be !def->always_iowq?
> >>>>
> >>>> How so? Nobody that takes pollable files should/is setting
> >>>> ->always_iowq. If we can poll the file, we should not force inline
> >>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
> >>>> returns if nonblock == true.
> >>>
> >>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
> >>> these OPs won't return -EAGAIN, then run in the current task context
> >>> directly.
> >>
> >> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
> >> it :-)
> > 
> > But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
> > not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
> > ->always_iowq is a bit confusing?
> 
> Yeah naming isn't that great, I can see how that's bit confusing. I'll
> be happy to take suggestions on what would make it clearer.

Except for the naming, I am also wondering why these ->always_iowq OPs
aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
shouldn't improve performance by doing so because these OPs are supposed
to be slow and always slept, not like others(buffered writes, ...),
can you provide one hint about not offloading these OPs? Or is it just that
NO_OFFLOAD needs to not offload every OPs?

Or can we rename IORING_SETUP_NO_OFFLOAD as IORING_SETUP_SUBMIT_MAY_WAIT
and still punt ->always_iowq OPs to iowq?

Thanks,
Ming

