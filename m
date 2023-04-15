Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E36E330D
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 20:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjDOSLg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 14:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjDOSLe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 14:11:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A657130E2
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 11:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02D760B8B
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 18:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50E67C433EF;
        Sat, 15 Apr 2023 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681582292;
        bh=Wo26VD1QqjaWg/7vF5nfuFkReYrWQlUHec5bGx2dKkU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hC77u09YfSdhz5pCKYad9CbiA4gAAJCrl0pSrYwsloPDypadHACONbEOJ9Enth4IN
         NzUqAcW2YEZqew/aeebvpUdeMcSHw7wFhNJrUk3MnTYRwFE2gSMhtF6YZMt+y2UwDP
         l7qEQhTYzkvOElHlADk+hL0SwPymWCIOk2mkOtSTvQTTZTEMETg7fGUjJOb1oeX6MT
         37fsmqEH5nRcfkidbq7H8S/fRYiBgXiUqbyGnBwAKsbzIuk3UYe44sNc3CP88P2dnr
         04nOzDjFmkvJIqpUHyXEL2xMpSJqWYqdCOF3HOTHCe6oGR+WXdRRiM8kuJttm5maYD
         9gw5oLyTMaInQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3FC17E52446;
        Sat, 15 Apr 2023 18:11:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.3-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b2b5b5dc-d849-d4ba-4f18-08d6869db9c2@kernel.dk>
References: <b2b5b5dc-d849-d4ba-4f18-08d6869db9c2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b2b5b5dc-d849-d4ba-4f18-08d6869db9c2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-04-14
X-PR-Tracked-Commit-Id: 860e1c7f8b0b43fbf91b4d689adfaa13adb89452
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1c6492d64646246834414964cfba9f826e7330b4
Message-Id: <168158229225.18559.371495607260436744.pr-tracker-bot@kernel.org>
Date:   Sat, 15 Apr 2023 18:11:32 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 14 Apr 2023 21:42:57 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-04-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1c6492d64646246834414964cfba9f826e7330b4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
