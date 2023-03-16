Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3536BC536
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 05:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCPE3Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 00:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPE3O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 00:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31FE8482F;
        Wed, 15 Mar 2023 21:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67F6961EF3;
        Thu, 16 Mar 2023 04:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DAEC433EF;
        Thu, 16 Mar 2023 04:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678940952;
        bh=+T9aqUWgzw93xLlr4h6ndyw8syrS4rwUT1cg6agYBJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ex8wLcqFcqWD3ZkZ0FwlAucsWhGLjfvMeR3Ip0B7deKHkVLfNMp6/cO377e7PUSwW
         PfOkaMdVdvKh2aTs857Ddxhyy7L2JxXkjPldxxAPGimo72uLXT/VUZs9+oxwJk2vQv
         HQQFbU/Pfw/2QRhs1sIOhfOq8lcoEhvRVY416rgqVGzn55MM5CZeHPM+SmqKeTnkw0
         OXAmhM1W7RbWbWsWUgdwoAuPiowJtUgIzaf3OtouuluqAwje2satCjS01VaklLKhrG
         sxb3NbZsThD6D/h1Xr9UsJg7naT0CR9epO9bs/ElVw1HiFe3HadRMCY3McouPVanPI
         uxcfelXYlq8Ig==
Date:   Wed, 15 Mar 2023 21:29:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCHSET for-next 0/2] Flag file systems as supporting parallel
 dio writes
Message-ID: <20230316042912.GI11376@frogsfrogsfrogs>
References: <20230307172015.54911-1-axboe@kernel.dk>
 <b11d27d5-8e83-7144-cdc8-3966abf42db5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b11d27d5-8e83-7144-cdc8-3966abf42db5@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 15, 2023 at 11:40:02AM -0600, Jens Axboe wrote:
> On 3/7/23 10:20 AM, Jens Axboe wrote:
> > Hi,
> > 
> > This has been on my TODO list for a while, and now that ext4 supports
> > parallel dio writes as well, time to dust it off and send it out... This
> > adds an FMODE flag to inform users that a given file supports parallel
> > dio writes. io_uring can use this to avoid serializing dio writes
> > upfront, in case it isn't needed. A few details in patch #2, patch 1 does
> > nothing by itself.
> 
> I'm assuming silence is consent here and folks are fine with this
> change?

Oh, yeah, this one fell off my radar.

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -- 
> Jens Axboe
> 
> 
