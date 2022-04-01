Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF83F4EFD3F
	for <lists+io-uring@lfdr.de>; Sat,  2 Apr 2022 01:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353575AbiDAXqq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 19:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353567AbiDAXqZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 19:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEF51FDFD6
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 16:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D93761BC2
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 23:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F743C2BBE4;
        Fri,  1 Apr 2022 23:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648856643;
        bh=cngFSLYhSBjSPoFC9ErNUI6quYG2RknzR7QSrp+Rck0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=A/tV/LpH3OAZAW5CDMrn1YDJNXcYpYJm18G5GLq3Cnam30dPseTckAN98oS2GyqjM
         RBRHdFdiZzn+eFHNObrS6jagqViLJPXYNo6tplbbt/iyu9HqvyYTpeC62L1emIOxBP
         CXJ4DO7Hb6KILbgbIJNr33JWsYtY6c2w0AIt59ghVJhsZPPh455T/Zy0Oo7wy8gT5I
         89VCdma3M8cVjzFkQ2lG90vriXnsW39DektKu+wyv0VtmnNeCLCd5RuPFIpXK2Bs4m
         +6Uot4bzGkR8GgeSUzgT2huzKeuSkqS0d9KpeePTvMNelPbDksniAYENge1AC6nwsa
         QNBdWnmkqc36A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B8ECE6BBCA;
        Fri,  1 Apr 2022 23:44:03 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.18-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2589afe7-d581-167b-b404-066bdcead097@kernel.dk>
References: <2589afe7-d581-167b-b404-066bdcead097@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2589afe7-d581-167b-b404-066bdcead097@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-2022-04-01
X-PR-Tracked-Commit-Id: 3f1d52abf098c85b177b8c6f5b310e8347d1bc42
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b1509f275ce13865c28ce254c36dc7c915808eb
Message-Id: <164885664350.32259.11970740459737530735.pr-tracker-bot@kernel.org>
Date:   Fri, 01 Apr 2022 23:44:03 +0000
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

The pull request you sent on Fri, 1 Apr 2022 13:31:48 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-2022-04-01

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b1509f275ce13865c28ce254c36dc7c915808eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
