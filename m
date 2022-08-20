Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C959AF50
	for <lists+io-uring@lfdr.de>; Sat, 20 Aug 2022 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiHTRzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Aug 2022 13:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiHTRzj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Aug 2022 13:55:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D755465D
        for <io-uring@vger.kernel.org>; Sat, 20 Aug 2022 10:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C332160DC7
        for <io-uring@vger.kernel.org>; Sat, 20 Aug 2022 17:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30D62C433D7;
        Sat, 20 Aug 2022 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661018138;
        bh=qXYGunvBr65iVNmJo5J67UevhiyGifIAXb8AhvSTDck=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=QtZnfNJCQ0FHtV2yrXhZ8An6+U9Wo/Znq8ITVsBztM/G5eskNd3cVFk/GlN07DqGL
         gjXQQ84VR4flHJloZDI8HMPFaE1UT99Q0JM5jJu9x4L7xNRI8ADQk5vMt2FVaYyEku
         LFlVFVg4er6DBQYeHuPtlAhSUaZ8Bxw4BgRnBtKce/x59sX+tyZiMgnmN/CEP/bKqD
         xhoDzRIvfFmde+CRANkPERjvERQLodpCN7ocl9owj4uVrP10iRlybCaG3Gx2ZPhPx5
         CC3AnS+hPX1INkM9DeQQOY0Fp+kb0MnsQpIkMEiulAqaJGD2NGAiMCZFor5LkviYfq
         RDoIuNtSSHkJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F87DC4166F;
        Sat, 20 Aug 2022 17:55:38 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <33577155-3f44-b9b7-e5df-97ae8c0163da@kernel.dk>
References: <33577155-3f44-b9b7-e5df-97ae8c0163da@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <33577155-3f44-b9b7-e5df-97ae8c0163da@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-19
X-PR-Tracked-Commit-Id: 3f743e9bbb8fe20f4c477e4bf6341c4187a4a264
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: beaf139709542d4ee7d22c2312b97c35587eb9db
Message-Id: <166101813812.10395.2090568171007686437.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Aug 2022 17:55:38 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 19 Aug 2022 11:22:47 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/beaf139709542d4ee7d22c2312b97c35587eb9db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
