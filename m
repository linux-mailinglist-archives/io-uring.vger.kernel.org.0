Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08E46B4B32
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 16:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjCJPeS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 10:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbjCJPdo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 10:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F7F127109
        for <io-uring@vger.kernel.org>; Fri, 10 Mar 2023 07:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678461663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ij7fnX9+36tdQ1u2upYNUC+qzUvZd+853Gvd/z1Ya+U=;
        b=Ga/eTtWtKK6K6lhwoerP8WZ6zghYPIsRXD81SKm/paKeSRoBB8pXyKJ9DgezDUNTRNVXhk
        mqkGVMD/V88FlbTsbL0BSpPh4rvrsAeVx0R1PHfzEUVi+972/W3MwcXoRZ5Yjb/CjWYJrn
        YrWXBgrP291fy7/DlxYeYXs4dGMTpbc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-cNG2xR7CMDKyVApvS6WmrA-1; Fri, 10 Mar 2023 10:14:19 -0500
X-MC-Unique: cNG2xR7CMDKyVApvS6WmrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 470F4811E6E;
        Fri, 10 Mar 2023 15:14:12 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D77EC15BA0;
        Fri, 10 Mar 2023 15:14:08 +0000 (UTC)
Date:   Fri, 10 Mar 2023 23:14:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310134400.GB464073@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 10, 2023 at 08:44:00AM -0500, Stefan Hajnoczi wrote:
> On Thu, Mar 09, 2023 at 07:58:31PM -0700, Jens Axboe wrote:
> > On 3/9/23 6:38?PM, Ming Lei wrote:
> > > On Thu, Mar 09, 2023 at 08:48:08AM -0500, Stefan Hajnoczi wrote:
> > >> Hi,
> > >> For block I/O an application can queue excess SQEs in userspace when the
> > >> SQ ring becomes full. For network and IPC operations that is not
> > >> possible because deadlocks can occur when socket, pipe, and eventfd SQEs
> > >> cannot be submitted.
> > > 
> > > Can you explain a bit the deadlock in case of network application? io_uring
> > > does support to queue many network SQEs via IOSQE_IO_LINK, at least for
> > > send.
> > > 
> > >>
> > >> Sometimes the application does not know how many SQEs/CQEs are needed upfront
> > >> and that's when we face this challenge.
> > > 
> > > When running out of SQEs,  the application can call io_uring_enter() to submit
> > > queued SQEs immediately without waiting for get events, then once
> > > io_uring_enter() returns, you get free SQEs for moving one.
> > > 
> > >>
> > >> A simple solution is to call io_uring_setup(2) with a higher entries
> > >> value than you'll ever need. However, if that value is exceeded then
> > >> we're back to the deadlock scenario and that worries me.
> > > 
> > > Can you please explain the deadlock scenario?
> > 
> > I'm also curious of what these deadlocks are. As Ming says, you
> > generally never run out of SQEs as you can always just submit what you
> > have pending and now you have a full queue size worth of them available
> > again.
> > 
> > I do think resizing the CQ ring may have some merit, as for networking
> > you may want to start smaller and resize it if you run into overflows as
> > those will be less efficient. But I'm somewhat curious on the reasonings
> > for wanting to resize the SQ ring?
> 
> Hi Ming and Jens,
> Thanks for the response. I'll try to explain why I worry about
> deadlocks.
> 
> Imagine an application has an I/O operation that must complete in order
> to make progress. If io_uring_enter(2) fails then the application is
> unable to submit that critical I/O.
> 
> The io_uring_enter(2) man page says:
> 
>   EBUSY  If  the IORING_FEAT_NODROP feature flag is set, then EBUSY will
> 	 be returned if there were overflow entries,
> 	 IORING_ENTER_GETEVENTS flag is set and not all of the overflow
> 	 entries were able to be flushed to the CQ ring.
> 
> 	 Without IORING_FEAT_NODROP the application is attempting to
> 	 overcommit the number of requests it can have pending. The
> 	 application should wait for some completions and try again. May
> 	 occur if the application tries to queue more requests than we
> 	 have room for in the CQ ring, or if the application attempts to
> 	 wait for more events without having reaped the ones already
> 	 present in the CQ ring.
> 
> Some I/O operations can take forever (e.g. reading an eventfd), so there
> is no guarantee that the I/Os already in flight will complete. If in
> flight I/O operations accumulate to the point where io_uring_enter(2)
> returns with EBUSY then the application is starved and unable to submit

The man page said clearly that EBUSY will be returned if there were overflow
CQE entries. But here, no in-flight IOs are completed and no CQEs actually in
CQ ring, so how can the -EBUSY be triggered?

Also I don't see any words about the following description:

	-EBUSY will be returned if many enough in-flight IOs are accumulated,

So care to explain it a bit?

> more I/O.
> 
> Starvation turns into a deadlock when the completion of the already in
> flight I/O depends on the yet-to-be-submitted I/O. For example, the
> application is supposed to write to a socket and another process will
> then signal the eventfd that the application is reading, but we're
> unable to submit the write.

OK, looks it is IO dependency issue, I understand it should be solved
by application. I remember I saw sort of problem when I write ublk/nbd,
but just forget the details now.

> 
> I asked about resizing the rings because if we can size them
> appropriately, then we can ensure there are sufficient resources for all
> I/Os that will be in flight. This prevents EBUSY, starvation, and
> deadlock.

But how can this issue be related with resizing rings and IORING_FEAT_NODROP?

In above description, both SQ and CQ ring are supposed to be empty.



Thanks,
Ming

