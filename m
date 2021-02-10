Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000B7317281
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 22:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhBJVkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 16:40:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:58914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232585AbhBJVkI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 10 Feb 2021 16:40:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D429AC88;
        Wed, 10 Feb 2021 21:39:27 +0000 (UTC)
Date:   Wed, 10 Feb 2021 22:39:25 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>,
        Martin Doucha <mdoucha@suse.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ltp@lists.linux.it
Subject: Re: CVE-2020-29373 reproducer fails on v5.11
Message-ID: <YCRSjQal+HFnzHs6@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YCQvL8/DMNVLLuuf@pevik>
 <b74d54ed-85ba-df4c-c114-fe11d50a3bce@gmail.com>
 <270c474f-476a-65d2-1f5b-57d3330efb04@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <270c474f-476a-65d2-1f5b-57d3330efb04@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens, Pavel,

> On 2/10/21 12:32 PM, Pavel Begunkov wrote:
> > On 10/02/2021 19:08, Petr Vorel wrote:
> >> Hi all,

> >> I found that the reproducer for CVE-2020-29373 from Nicolai Stange (source attached),
> >> which was backported to LTP as io_uring02 by Martin Doucha [1] is failing since
> >> 10cad2c40dcb ("io_uring: don't take fs for recvmsg/sendmsg") from v5.11-rc1.

> > Thanks for letting us know, we need to revert it

> I'll queue up a revert. Would also be nice to turn that into
> a liburing regression test.
Thanks a lot for a quick feedback and fix!

Kind regards,
Petr
