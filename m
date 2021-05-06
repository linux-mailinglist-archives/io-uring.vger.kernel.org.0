Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FBB375914
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbhEFRSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 13:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbhEFRSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 13:18:44 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9C4C061574;
        Thu,  6 May 2021 10:17:46 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lehcu-00Bw7k-NI; Thu, 06 May 2021 17:17:28 +0000
Date:   Thu, 6 May 2021 17:17:28 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, yangerkun <yangerkun@huawei.com>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
Message-ID: <YJQkqP19pj3C/75N@zeniv-ca.linux.org.uk>
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
 <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
 <d7641b3d-0203-d913-d6ac-57de5c7c9747@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7641b3d-0203-d913-d6ac-57de5c7c9747@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 06, 2021 at 05:57:02PM +0100, Pavel Begunkov wrote:
> On 4/30/21 3:35 PM, Al Viro wrote:
> > On Fri, Apr 30, 2021 at 01:57:22PM +0100, Pavel Begunkov wrote:
> >> On 4/28/21 7:16 AM, yangerkun wrote:
> >>> Hi,
> >>>
> >>> Should we pick this patch for 5.13?
> >>
> >> Looks ok to me
> > 
> > 	Looks sane.  BTW, Pavel, could you go over #untested.iov_iter
> > and give it some beating?  Ideally - with per-commit profiling to see
> > what speedups/slowdowns do they come with...
> 
> I've heard Jens already tested it out. Jens, is that right? Can you
> share? especially since you have much more fitting hardware.

FWIW, the current branch is #untested.iov_iter-3 and the code generated
by it at least _looks_ better than with mainline; how much of an improvement
does it make would have to be found by profiling...
