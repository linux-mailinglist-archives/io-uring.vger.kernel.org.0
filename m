Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A4C7A4EEF
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 18:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjIRQbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 12:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjIRQa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 12:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB8F2522F
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 09:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695054444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QQaMEbOn/KFTezm+zv5lfXwhkcUZOolA0VIHDm6tkW0=;
        b=OBOSRKHbV0yPR2GpW4VVN7AO2+AP7kaSAi3cF/6TBh4OGe5pzO6UfikLuI8fxZ0OesWdJB
        cXYpJgbZaCTBs7Vq+sPRylDCwJdtETYsax+ebtCfBI4JK1HSwUp8C4rNlU5f7fMR0Ud2jr
        uIJ21xU4VXC+vUBOdYTfqYx5XCLfWFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-679-Beo7iZaiMKql4xGZ1CfhOw-1; Mon, 18 Sep 2023 09:24:29 -0400
X-MC-Unique: Beo7iZaiMKql4xGZ1CfhOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C42E8185A79B;
        Mon, 18 Sep 2023 13:24:28 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B50C1492C37;
        Mon, 18 Sep 2023 13:24:25 +0000 (UTC)
Date:   Mon, 18 Sep 2023 21:24:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH 00/10] io_uring/ublk: exit notifier support
Message-ID: <ZQhPhFwgSLvR/zDM@fedora>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
 <fae0bbc9-efdd-4b56-a5c8-53428facbe5b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fae0bbc9-efdd-4b56-a5c8-53428facbe5b@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 18, 2023 at 06:54:33AM -0600, Jens Axboe wrote:
> On 9/17/23 10:10 PM, Ming Lei wrote:
> > Hello,
> > 
> > In do_exit(), io_uring needs to wait pending requests.
> > 
> > ublk is one uring_cmd driver, and its usage is a bit special by submitting
> > command for waiting incoming block IO request in advance, so if there
> > isn't any IO request coming, the command can't be completed. So far ublk
> > driver has to bind its queue with one ublk daemon server, meantime
> > starts one monitor work to check if this daemon is live periodically.
> > This way requires ublk queue to be bound one single daemon pthread, and
> > not flexible, meantime the monitor work is run in 3rd context, and the
> > implementation is a bit tricky.
> > 
> > The 1st 3 patches adds io_uring task exit notifier, and the other
> > patches converts ublk into this exit notifier, and the implementation
> > becomes more robust & readable, meantime it becomes easier to relax
> > the ublk queue/daemon limit in future, such as not require to bind
> > ublk queue with single daemon.
> 
> The normal approach for this is to ensure that each request is
> cancelable, which we need for other things too (like actual cancel
> support) Why can't we just do the same for ublk?

I guess you meant IORING_OP_ASYNC_CANCEL, which needs userspace to
submit this command, but here the userspace(ublk server) may be just panic
or killed, and there isn't chance to send IORING_OP_ASYNC_CANCEL.

And driver doesn't have any knowledge if the io_uring ctx or io task
is exiting, so can't complete issued commands, then hang in
io_uring_cancel_generic() when the io task/ctx is exiting.


Thanks,
Ming

