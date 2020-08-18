Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B5248860
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 16:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgHRO5I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 10:57:08 -0400
Received: from latitanza.investici.org ([82.94.249.234]:43185 "EHLO
        latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgHRO5G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 10:57:06 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2020 10:57:04 EDT
Received: from mx3.investici.org (unknown [127.0.0.1])
        by latitanza.investici.org (Postfix) with ESMTP id 4BWDMy6Qpsz8sfj;
        Tue, 18 Aug 2020 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cryptolab.net;
        s=stigmate; t=1597762190;
        bh=QAdyDHrgLRpOZ6stfFZ/Glz7TgqfzahArQPIrrUkI8E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J3VzCRhioqpvnKhh6Bk7Kdcd7f+f16XLeI4gGKRQzphAKescNS9C/PS9INMYdSkfV
         rx5loA1/glp1UMUDOyLSdpNmGijoqUyoFVQWcaGA7Zu//hccarcpuUdftjgsxe2nqO
         1P1fsAgQQJhuAG2Nj0o4Zwptt5c4Wu4WX2M8KR90=
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234]) (Authenticated sender: anoopcs@autistici.org) by localhost (Postfix) with ESMTPSA id 4BWDMw1J01z8sfL;
        Tue, 18 Aug 2020 14:49:47 +0000 (UTC)
Message-ID: <631dbeff8926dbef4fec5a12281843c8a66565e5.camel@cryptolab.net>
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
From:   Anoop C S <anoopcs@cryptolab.net>
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
Date:   Tue, 18 Aug 2020 20:19:36 +0530
In-Reply-To: <db051fac-da0f-9546-2c32-1756d9e74529@kernel.dk>
References: <20200814195449.533153-1-axboe@kernel.dk>
         <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
         <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
         <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
         <e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk>
         <5f6d3f16-cd0c-9598-4484-6003101eb47a@samba.org>
         <db051fac-da0f-9546-2c32-1756d9e74529@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2020-08-18 at 07:44 -0700, Jens Axboe wrote:
> On 8/18/20 12:40 AM, Stefan Metzmacher wrote:
> > Hi Jens,
> > 
> > > > > > Will this be backported?
> > > > > 
> > > > > I can, but not really in an efficient manner. It depends on
> > > > > the async
> > > > > buffered work to make progress, and the task_work handling
> > > > > retry. The
> > > > > latter means it's 5.7+, while the former is only in 5.9+...
> > > > > 
> > > > > We can make it work for earlier kernels by just using the
> > > > > thread offload
> > > > > for that, and that may be worth doing. That would enable it
> > > > > in
> > > > > 5.7-stable and 5.8-stable. For that, you just need these two
> > > > > patches.
> > > > > Patch 1 would work as-is, while patch 2 would need a small
> > > > > bit of
> > > > > massaging since io_read() doesn't have the retry parts.
> > > > > 
> > > > > I'll give it a whirl just out of curiosity, then we can
> > > > > debate it after
> > > > > that.
> > > > 
> > > > Here are the two patches against latest 5.7-stable (the rc
> > > > branch, as
> > > > we had quite a few queued up after 5.9-rc1). Totally untested,
> > > > just
> > > > wanted to see if it was doable.
> > > > 
> > > > First patch is mostly just applied, with various bits removed
> > > > that we
> > > > don't have in 5.7. The second patch just does -EAGAIN punt for
> > > > the
> > > > short read case, which will queue the remainder with io-wq for
> > > > async execution.
> > > > 
> > > > Obviously needs quite a bit of testing before it can go
> > > > anywhere else,
> > > > but wanted to throw this out there in case you were interested
> > > > in
> > > > giving it a go...
> > > 
> > > Actually passes basic testing, and doesn't return short reads. So
> > > at
> > > least it's not half bad, and it should be safe for you to test.
> > > 
> > > I quickly looked at 5.8 as well, and the good news is that the
> > > same
> > > patches will apply there without changes.
> > 
> > Thanks, but I was just curios and I currently don't have the
> > environment to test, sorry.
> > 
> > Anoop: you helped a lot reproducing the problem with 5.6, would you
> > be able to
> > test the kernel patches against 5.7 or 5.8, while reverting the
> > samba patches?
> > See 
> > https://lore.kernel.org/io-uring/e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk/T/#t
> > for the
> > whole discussion?
> 
> I'm actually not too worried about the short reads not working, it'll
> naturally fall out correctly if the rest of the path is sane. The
> latter
> is what I'd be worried about! I ran some synthetic testing and
> haven't
> seen any issues so far, so maybe (just maybe) it's actually good.
> 
> I can setup two branches with the 5.7-stable + patches and 5.8-stable 
> +
> patches if that helps facilitate testing?

That would be great.

I took those two patches and tried to apply on top of 5.7.y. I had to
manually resolve very few conflicts. I am not sure whether it is OK or
not to test such a patched version(because of conflicts).

Thanks,
Anoop C S.

