Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA17179962
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgCDT4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:56:45 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:57085 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgCDT4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 14:56:45 -0500
X-Originating-IP: 92.243.9.8
Received: from localhost (joshtriplett.org [92.243.9.8])
        (Authenticated sender: josh@joshtriplett.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id B46E21BF203;
        Wed,  4 Mar 2020 19:56:42 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:56:42 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
Subject: Re: [PATCHSET v2 0/6] Support selectable file descriptors
Message-ID: <20200304195642.GB16527@localhost>
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304190341.GB16251@localhost>
 <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 04, 2020 at 12:10:08PM -0700, Jens Axboe wrote:
> On 3/4/20 12:03 PM, Josh Triplett wrote:
> > On Wed, Mar 04, 2020 at 11:00:10AM -0700, Jens Axboe wrote:
> >> One of the fabled features with chains has long been the desire to
> >> support things like:
> >>
> >> <open fileX><read from fileX><close fileX>
> >>
> >> in a single chain. This currently doesn't work, since the read/close
> >> depends on what file descriptor we get on open.
> >>
> >> The original attempt at solving this provided a means to pass
> >> descriptors between chains in a link, this version takes a different
> >> route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
> >> what fd value we're going to get out of open (or accept). With that in
> >> place, we don't need to do any magic to make this work. The above chain
> >> then becomes:
> >>
> >> <open fileX with fd Y><read from fd Y><close fd Y>
> >>
> >> which is a lot more useful, and allows any sort of weird chains without
> >> needing to nest "last open" file descriptors.
> >>
> >> Updated the test program to use this approach:
> >>
> >> https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select
> >>
> >> which forces the use of fd==89 for the open, and then uses that for the
> >> read and close.
> >>
> >> Outside of this adaptation, fixed a few bugs and cleaned things up.
> > 
> > I posted one comment about an issue in patch 6.
> > 
> > Patches 2-5 look great; for those:
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > Thanks for picking this up and running with it!
> 
> Thanks for doing the prep work! I think it turned out that much better
> for it.
> 
> Are you going to post your series for general review? I just stole
> your 1 patch that was needed for me.

Since your patch series depends on mine, please feel free to run with
the series. Would you mind adding my patch 1 and 3 at the end of your
series? You need patch 1 to make this more usable for userspace, and
patch 3 would allow for an OP_PIPE which I'd love to have.

Do you plan to submit this during the next merge window?
