Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199866B34FA
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 04:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCJDr4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 22:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCJDrx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 22:47:53 -0500
X-Greylist: delayed 341 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Mar 2023 19:47:51 PST
Received: from shells.gnugeneration.com (shells.gnugeneration.com [66.240.222.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C75EE772
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 19:47:51 -0800 (PST)
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 7FF32C00828; Thu,  9 Mar 2023 19:42:10 -0800 (PST)
Date:   Thu, 9 Mar 2023 19:42:10 -0800
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <20230310034210.jlcystieqx2yrqjg@shells.gnugeneration.com>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 09, 2023 at 07:58:31PM -0700, Jens Axboe wrote:
> On 3/9/23 6:38?PM, Ming Lei wrote:
> > On Thu, Mar 09, 2023 at 08:48:08AM -0500, Stefan Hajnoczi wrote:
> >> Hi,
> >> For block I/O an application can queue excess SQEs in userspace when the
> >> SQ ring becomes full. For network and IPC operations that is not
> >> possible because deadlocks can occur when socket, pipe, and eventfd SQEs
> >> cannot be submitted.
> > 
> > Can you explain a bit the deadlock in case of network application? io_uring
> > does support to queue many network SQEs via IOSQE_IO_LINK, at least for
> > send.
> > 
> >>
> >> Sometimes the application does not know how many SQEs/CQEs are needed upfront
> >> and that's when we face this challenge.
> > 
> > When running out of SQEs,  the application can call io_uring_enter() to submit
> > queued SQEs immediately without waiting for get events, then once
> > io_uring_enter() returns, you get free SQEs for moving one.
> > 
> >>
> >> A simple solution is to call io_uring_setup(2) with a higher entries
> >> value than you'll ever need. However, if that value is exceeded then
> >> we're back to the deadlock scenario and that worries me.
> > 
> > Can you please explain the deadlock scenario?
> 
> I'm also curious of what these deadlocks are. As Ming says, you
> generally never run out of SQEs as you can always just submit what you
> have pending and now you have a full queue size worth of them available
> again.
> 

In my limited io_uring experiments it was convenient to know I could
*always* get+prepare N number of concurrent SQEs before having to
submit.

I was working with a set of files I needed to first discover the
quantity of, so I would start with a bootstrap ring size sufficient for
the discovery process.  Then once known, I'd resize the ring to
accomodate the maximum width of SEQs N files could produce for the given
operation.

The convenience was it made the dispatch functions logically atomic
units.  In the sense that they didn't need to be able to handle running
out of SQEs, submitting, and resuming in a continuation style.  They
could just be coded simply in a single loop iterating across the N files
getting+preparing SQEs, confident they wouldn't "deadlock" from
exhaustion.

Perhaps that's a similar "deadlock" scenario to Ming's.

But I should note that in my experiments I was always operating under
the assumption that I'd never have N so large it couldn't possibly
exceed the maximum SQ size I could allocate.  And that probably isn't a
safe assumption for a real production program, I was just experimenting
after all.

Also I was able to "resize" by just quiescing the ring, destroying it,
and recreating it with the new size.  It wasn't a perf sensitive thing,
just startup rigamarole.  I do recall being a little surprised I had to
ad-hoc implement the resize at the time though...

Regards,
Vito Caputo
