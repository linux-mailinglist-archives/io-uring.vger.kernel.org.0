Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0146436FC84
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhD3Og4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 10:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhD3Ogz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 10:36:55 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A38C06174A;
        Fri, 30 Apr 2021 07:36:06 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lcUFJ-009cvD-7B; Fri, 30 Apr 2021 14:35:57 +0000
Date:   Fri, 30 Apr 2021 14:35:57 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
Message-ID: <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 30, 2021 at 01:57:22PM +0100, Pavel Begunkov wrote:
> On 4/28/21 7:16 AM, yangerkun wrote:
> > Hi,
> > 
> > Should we pick this patch for 5.13?
> 
> Looks ok to me

	Looks sane.  BTW, Pavel, could you go over #untested.iov_iter
and give it some beating?  Ideally - with per-commit profiling to see
what speedups/slowdowns do they come with...

	It's not in the final state (if nothing else, it needs to be
rebased on top of xarray stuff, and there will be followup cleanups
as well), but I'd appreciate testing and profiling data...

	It does survive xfstests + LTP syscall tests, but that's about
it.
