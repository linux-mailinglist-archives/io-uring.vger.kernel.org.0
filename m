Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A709B5883A1
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 23:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiHBVaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 17:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiHBVaS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 17:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953B56542;
        Tue,  2 Aug 2022 14:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7014B820FF;
        Tue,  2 Aug 2022 21:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AC65C433B5;
        Tue,  2 Aug 2022 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659475813;
        bh=lMBcr00HXZRcXkAt8aiKrgXBTyvZlqembw7fnrV5zjw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LCM6w/EXIF443IZ/wSlOahpbS5oNRT7grTLp8Fsq6Ye1GMW02S32HefK2WZ9wdQJk
         KP0gyBuiJ2KlMxcHaFPFnj/3+Pd2DeBE+eWXWHAEOsNt16HebWRJ4zuDnGNacY8Cbn
         ZqUQS/JVNQYbYVhrJS6iuY9RGV5r93l4Ioy/fvTEowBTAZ2c+19UZhnCUN6UureD9r
         hEzdX7ykZaixnts6+PT78hPhFKPGPetxbdFQCN19wR0fmda1L1V2kw3iXQcw0UZIzi
         De+Hw1VRvK70WIh+rPrqoileJDyKnMIwUpkuWK47ONPh7Nn4GPVyVtt3Pp3GIQgCtx
         aPBYca2ToFL2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4222EC43142;
        Tue,  2 Aug 2022 21:30:13 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring support for buffered writes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c737af00-e879-fe01-380c-ba95b555f423@kernel.dk>
References: <c737af00-e879-fe01-380c-ba95b555f423@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <c737af00-e879-fe01-380c-ba95b555f423@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-buffered-writes-2022-07-29
X-PR-Tracked-Commit-Id: 0dd316ba8692c2374fbb82cce57c0b23144f2977
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 98e247464088a11ce2328a214fdb87d4c06f8db6
Message-Id: <165947581326.30731.9534686420470156376.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Aug 2022 21:30:13 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 31 Jul 2022 09:03:30 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-buffered-writes-2022-07-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/98e247464088a11ce2328a214fdb87d4c06f8db6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
