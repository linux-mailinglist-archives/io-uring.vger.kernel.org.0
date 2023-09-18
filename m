Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A37A4EAC
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 18:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjIRQVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 12:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIRQVC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 12:21:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16F1B8
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 09:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695052986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hy0ReXQZiegSjwpmyZH2qjKRhSINulN3U3E7DKyqaHs=;
        b=fYUMwXIr1FcXA56XChsEd+L2iNFygX1+0ssIbtF0BKSOwgOrlR6rGPnB77cLZ1quyTi2t8
        Vewa8YnCiaFPltSPeDNLDyQOrJPyeStTmMKrdIAm7SP1JLgtlHTyRm/NPZYk5JRTJk7KVl
        pjbLpN77tx607sZS5egrTiYZAvFDutE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-HD6phgFBND-pWVVk7hfZWw-1; Mon, 18 Sep 2023 12:02:56 -0400
X-MC-Unique: HD6phgFBND-pWVVk7hfZWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86AFE803470;
        Mon, 18 Sep 2023 16:02:55 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5B9A2904;
        Mon, 18 Sep 2023 16:02:52 +0000 (UTC)
Date:   Tue, 19 Sep 2023 00:02:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH 00/10] io_uring/ublk: exit notifier support
Message-ID: <ZQh0p+ovm1sd3Vau@fedora>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
 <fae0bbc9-efdd-4b56-a5c8-53428facbe5b@kernel.dk>
 <ZQhPhFwgSLvR/zDM@fedora>
 <5706fa76-a071-4081-8bb0-b1089e86a77f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5706fa76-a071-4081-8bb0-b1089e86a77f@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 18, 2023 at 08:15:07AM -0600, Jens Axboe wrote:
> On 9/18/23 7:24 AM, Ming Lei wrote:
> > On Mon, Sep 18, 2023 at 06:54:33AM -0600, Jens Axboe wrote:
> >> On 9/17/23 10:10 PM, Ming Lei wrote:
> >>> Hello,
> >>>
> >>> In do_exit(), io_uring needs to wait pending requests.
> >>>
> >>> ublk is one uring_cmd driver, and its usage is a bit special by submitting
> >>> command for waiting incoming block IO request in advance, so if there
> >>> isn't any IO request coming, the command can't be completed. So far ublk
> >>> driver has to bind its queue with one ublk daemon server, meantime
> >>> starts one monitor work to check if this daemon is live periodically.
> >>> This way requires ublk queue to be bound one single daemon pthread, and
> >>> not flexible, meantime the monitor work is run in 3rd context, and the
> >>> implementation is a bit tricky.
> >>>
> >>> The 1st 3 patches adds io_uring task exit notifier, and the other
> >>> patches converts ublk into this exit notifier, and the implementation
> >>> becomes more robust & readable, meantime it becomes easier to relax
> >>> the ublk queue/daemon limit in future, such as not require to bind
> >>> ublk queue with single daemon.
> >>
> >> The normal approach for this is to ensure that each request is
> >> cancelable, which we need for other things too (like actual cancel
> >> support) Why can't we just do the same for ublk?
> > 
> > I guess you meant IORING_OP_ASYNC_CANCEL, which needs userspace to
> > submit this command, but here the userspace(ublk server) may be just panic
> > or killed, and there isn't chance to send IORING_OP_ASYNC_CANCEL.
> 
> Either that, or cancel done because of task exit.
> 
> > And driver doesn't have any knowledge if the io_uring ctx or io task
> > is exiting, so can't complete issued commands, then hang in
> > io_uring_cancel_generic() when the io task/ctx is exiting.
> 
> If you hooked into the normal cancel paths, you very much would get
> notified when the task is exiting. That's how the other cancelations
> work, eg if a task has pending poll requests and exits, they get
> canceled and reaped.

Ok, got the idea, thanks for the point!

Turns out it is cancelable uring_cmd, and I will try to work towards
this direction, and has got something in mind about the implementation.


Thanks, 
Ming

