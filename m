Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2960E6608B9
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 22:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbjAFVTN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 16:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbjAFVTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 16:19:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA63081C2E
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 13:19:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DD4EB81E44
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 21:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EED1C433D2;
        Fri,  6 Jan 2023 21:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673039947;
        bh=wznMqMErTEeYUKyi/2S0j1YOSv0Voxuj3FPotFgxP6U=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AC5vqBvF0igmsJDW8FKaRNpnJyB6Eo0pOuhJqoF/0zms7yxJXqLo72ruEDYGngojD
         uESaH8vM1FzRoXO36/B+JOZBYcmt4ZpXMC9Xog9bq+Hqrz4PBbzbeSmapvNRE0m39r
         8Z3RdwaG9gWLR0F1DmI4v7zM+BnaTZgf2JNik133THmakY1PFTwNiWQLJIh+xub6xF
         iZz8k6VeBR/aaM+kRTs4HOUDr8zrOcTpiaFunYwJMV3A3DKTVuD27yV7/Alb+wjaTc
         pC0pQvdL/Cta4TAxq/kLz2vT+GnvSfw8dqwsY6vi+bcv08//9asIi8xDdpJUsHGHPM
         WQFTCwG9Sfcrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1474E57254;
        Fri,  6 Jan 2023 21:19:06 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.2-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2caed411-58e8-2286-2c4d-c0eaf91f26e1@kernel.dk>
References: <2caed411-58e8-2286-2c4d-c0eaf91f26e1@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2caed411-58e8-2286-2c4d-c0eaf91f26e1@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-2023-01-06
X-PR-Tracked-Commit-Id: 12521a5d5cb7ff0ad43eadfc9c135d86e1131fa8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef1a4a770994b97a86988fd86f5a2784b87449f7
Message-Id: <167303994698.10294.10738259781786695288.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Jan 2023 21:19:06 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 6 Jan 2023 09:25:13 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-2023-01-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef1a4a770994b97a86988fd86f5a2784b87449f7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
