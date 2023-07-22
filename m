Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AAD75D882
	for <lists+io-uring@lfdr.de>; Sat, 22 Jul 2023 03:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjGVBDB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 21:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGVBDA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 21:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFCD30D7;
        Fri, 21 Jul 2023 18:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC71361DAE;
        Sat, 22 Jul 2023 01:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F74EC433C9;
        Sat, 22 Jul 2023 01:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689987779;
        bh=ts8Bj7SBG4Y1uYeL/gfMrwfqCsY3R2bqVBC+tdd4Irg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6cmndM0oC3eyio4YDk4ba7f6YyhWs4X/ONw5wn5OUrpx1YFv53S7GwHUC9PWiskV
         y0c95MhjlZsLtCbp514RWm/wGZJIGVq6vO3cGQZN3JFWJoj26nICyB2vDFrtgzFGMX
         FJOA83AusoaFPmC75fji/u+QBYJ6GWYcSUaS5oBZefmV/oioIoLTUWlSRfL8V9oSKB
         4IdCbBCMuUu2w4SQGHyw9FnkUlWL6E3F/888b+0CLl7uJswcDpoUrJRor21T9DrYI2
         Zz6xjs6ND4ArBcvPLs81CgEgLXB73150LP4rnAlwr3q9bBc1kELdGZJk+XQ9iGIHxG
         nGiwJMj8Vao2g==
Date:   Fri, 21 Jul 2023 18:02:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [GIT PULL] Improve iomap async dio performance
Message-ID: <20230722010258.GC11377@frogsfrogsfrogs>
References: <647e79f4-ddaa-7003-6e00-f31e11535082@kernel.dk>
 <ZLsB80ylEgs6fq13@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLsB80ylEgs6fq13@dread.disaster.area>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 22, 2023 at 08:08:51AM +1000, Dave Chinner wrote:
> On Fri, Jul 21, 2023 at 10:54:41AM -0600, Jens Axboe wrote:
> > Hi,
> > 
> > Here's the pull request for improving async dio performance with
> > iomap. Contains a few generic cleanups as well, but the meat of it
> > is described in the tagged commit message below.
> > 
> > Please pull for 6.6!
> 
> Ah, I just reviewed v4 (v5 came out while I was sleeping) and I
> think there are still problems with some of the logic...
> 
> So it might be worth holding off from pulling this until we work
> through that...

No worries, next week I'm starting the iomap merging process with
willy's large folios write (Monday) and then Ritesh's dirty tracking
(Tuesday if nothing blows up), so there's plenty of time for more
questions.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
