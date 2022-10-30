Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91A06126CF
	for <lists+io-uring@lfdr.de>; Sun, 30 Oct 2022 02:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJ3B3w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Oct 2022 21:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiJ3B3p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Oct 2022 21:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6973E6584
        for <io-uring@vger.kernel.org>; Sat, 29 Oct 2022 18:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0055460CEF
        for <io-uring@vger.kernel.org>; Sun, 30 Oct 2022 01:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6229DC433C1;
        Sun, 30 Oct 2022 01:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667093383;
        bh=OZjOAZ4HFxp8M18xFUc7A8y+zt60zNdMGPsBukdpnys=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ltNkbOTOJ8r77pabkUrRnvPQHGi3VnE+EwkzYQp2cxhfVGfgt0RAUfKnhj5Lds+Ya
         NkFSdZkIUKM/Jju4xWLYWspRwGR6Q4QC3KcmkirTdDBiWTyX7LJWSKCI4EiuO3CBDm
         OzTDiesh8GZmt1IVRSeLGDvM1MvlaWCMgU6y7sfm/ZarMc+HHP5XXgh+9uuLOTgY5w
         KBnBdrvG0h3aGC4BahsFzSYWXmkKesrXQwpDZ1pzafytxXCp09YAuxh51cKwPuH1l1
         oa2tnzlSHevy63R/5suwFi6lOgC2SfsGD95roBfJXspVdG4J3zDmDS3YVkkJsOBMwM
         IU58x6/K/a0eQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B8C9C41672;
        Sun, 30 Oct 2022 01:29:43 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.1-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <0644eeea-0e0a-d09c-2b65-365b7ab823ba@kernel.dk>
References: <0644eeea-0e0a-d09c-2b65-365b7ab823ba@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <0644eeea-0e0a-d09c-2b65-365b7ab823ba@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-28
X-PR-Tracked-Commit-Id: b3026767e15b488860d4bbf1649d69612bab2c25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d244327dd1bab94a78fa2ab40a33d13ca18326b
Message-Id: <166709338330.23656.16632924882338962412.pr-tracker-bot@kernel.org>
Date:   Sun, 30 Oct 2022 01:29:43 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 28 Oct 2022 15:12:00 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d244327dd1bab94a78fa2ab40a33d13ca18326b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
