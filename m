Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE552D42CA
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 14:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732188AbgLINIU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 08:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732178AbgLINIL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 08:08:11 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39598C0613D6;
        Wed,  9 Dec 2020 05:07:31 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmzBj-0003sZ-21; Wed, 09 Dec 2020 13:07:23 +0000
Date:   Wed, 9 Dec 2020 13:07:23 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <20201209130723.GL3579531@ZenIV.linux.org.uk>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209083645.GB21968@infradead.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 09, 2020 at 08:36:45AM +0000, Christoph Hellwig wrote:
> 
> This is making the iter type even more of a mess than it already is.
> I think we at least need placeholders for 0/1 here and an explicit
> flags namespace, preferably after the types.
> 
> Then again I'd much prefer if we didn't even add the flag or at best
> just add it for a short-term transition and move everyone over to the
> new scheme.  Otherwise the amount of different interfaces and supporting
> code keeps exploding.

Yes.  The only problem I see is how to describe the rules - "bdev-backed
iterators need the bvec array to stay allocated until IO completes"?
And one way or another, that needs to be documented - D/f/porting with
"mandatory" for priority.
