Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6C97A6727
	for <lists+io-uring@lfdr.de>; Tue, 19 Sep 2023 16:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjISOpv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Sep 2023 10:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbjISOph (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Sep 2023 10:45:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38675E4E;
        Tue, 19 Sep 2023 07:45:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B3CC433C8;
        Tue, 19 Sep 2023 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695134725;
        bh=sW27fVmJQv9A5J1aPSwSdcvROXbYU9fU58xdEIsojsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H/xBvBGFmmkD0gEZW8PLKXQgFKwYDPqz+lMf71LRqBPloeMMnCbHFWe2ATVCQYCc+
         4GEumZ9ca6ntQvnkElvz69TWTlUY7Ssx5JryGkd45mTOZuyN09MiVmJsQtFm6c8GHS
         7hUsbJJEGavb/tuG703R7+CoI94XLQUQQxj4mRag77+BQ6PBwzGPOhAhn7JsmtiQuc
         +8HOFSmr9I919hEROm+fUiZ67XhWQ8ybu5pL6v9CK5UeG13eLg7TstbNY1sgrjGWYu
         pQPgZxX2JPoXKdhAp1Zs+/DFGmF637/KcqEiSlXlDqJarYugBuiLaPMOPYvhbdEb2i
         h/u2KIgcDjCVw==
Date:   Tue, 19 Sep 2023 16:45:21 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, asml.silence@gmail.com
Subject: Re: [PATCHSET v4 0/5] Add io_uring support for waitid
Message-ID: <20230919-beinen-fernab-dbc587acb08d@brauner>
References: <20230909151124.1229695-1-axboe@kernel.dk>
 <26ddc629-e685-49b9-9786-73c0f89854d8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26ddc629-e685-49b9-9786-73c0f89854d8@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 12, 2023 at 11:06:39AM -0600, Jens Axboe wrote:
> On 9/9/23 9:11 AM, Jens Axboe wrote:
> > Hi,
> > 
> > This adds support for IORING_OP_WAITID, which is an async variant of
> > the waitid(2) syscall. Rather than have a parent need to block waiting
> > on a child task state change, it can now simply get an async notication
> > when the requested state change has occured.
> > 
> > Patches 1..4 are purely prep patches, and should not have functional
> > changes. They split out parts of do_wait() into __do_wait(), so that
> > the prepare-to-wait and sleep parts are contained within do_wait().
> > 
> > Patch 5 adds io_uring support.
> > 
> > I wrote a few basic tests for this, which can be found in the
> > 'waitid' branch of liburing:
> > 
> > https://git.kernel.dk/cgit/liburing/log/?h=waitid
> > 
> > Also spun a custom kernel for someone to test it, and no issues reported
> > so far.
> 
> Forget to mention that I also ran all the ltp testcases for any wait*
> syscall test, and everything still passes just fine.

I think the struct that this ends up exposing to io_uring is pretty ugly
and it would warrant a larger cleanup. I wouldn't be surprised if you
get some people complain about this.

Other than that I don't have any complaints about the series.
