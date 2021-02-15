Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E51E31B584
	for <lists+io-uring@lfdr.de>; Mon, 15 Feb 2021 08:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhBOHEx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Feb 2021 02:04:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:53588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhBOHEw (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 15 Feb 2021 02:04:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 92CE6AEBF;
        Mon, 15 Feb 2021 07:04:11 +0000 (UTC)
Date:   Mon, 15 Feb 2021 08:04:09 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>,
        Martin Doucha <mdoucha@suse.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ltp@lists.linux.it, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: CVE-2020-29373 reproducer fails on v5.11
Message-ID: <YCoc6Yj2ha7/k/5C@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YCQvL8/DMNVLLuuf@pevik>
 <b74d54ed-85ba-df4c-c114-fe11d50a3bce@gmail.com>
 <270c474f-476a-65d2-1f5b-57d3330efb04@kernel.dk>
 <YCZ5ZS5Sr2tPiUvP@pevik>
 <8e7ad2f3-eb35-71fe-5989-b5f09476eb24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e7ad2f3-eb35-71fe-5989-b5f09476eb24@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

> On 12/02/2021 12:49, Petr Vorel wrote:
> > Hi all,

> >> On 2/10/21 12:32 PM, Pavel Begunkov wrote:
> >>> On 10/02/2021 19:08, Petr Vorel wrote:
> >>>> Hi all,

> >>>> I found that the reproducer for CVE-2020-29373 from Nicolai Stange (source attached),
> >>>> which was backported to LTP as io_uring02 by Martin Doucha [1] is failing since
> >>>> 10cad2c40dcb ("io_uring: don't take fs for recvmsg/sendmsg") from v5.11-rc1.

> >>> Thanks for letting us know, we need to revert it

> >> I'll queue up a revert. Would also be nice to turn that into
> >> a liburing regression test.

> > Jens (or others), could you please have look that the other commit 907d1df30a51
> > ("io_uring: fix wqe->lock/completion_lock deadlock") from v5.11-rc6 didn't cause
> > any regression? Changed behavior causing io_uring02 test [1] and the original
> > reproducer [2] to fail is probably a test bug, but better double check that.

> Thanks for keeping an eye on it. That's on the test because DRAIN doesn't
> punt to worker threads anymore, and DRAIN is used for those prepended
> requests.

> Can we just use IOSQE_ASYNC instead and fallback to DRAIN for older kernels
> as you mentioned? It would be much more reliable. Or replace IOSQE_IO_DRAIN
> with IOSQE_IO_LINK, but there are nuances to that... 

Thanks for your tips!

Kind regards,
Petr

> > Kind regards,
> > Petr

> > [1] https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/syscalls/io_uring/io_uring02.c
> > [2] https://lore.kernel.org/io-uring/YCQvL8%2FDMNVLLuuf@pevik/
