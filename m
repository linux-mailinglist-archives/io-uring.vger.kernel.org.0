Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF2591CD4
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 23:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiHMVsh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Aug 2022 17:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbiHMVsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Aug 2022 17:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC28252B5
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 14:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F15DB80ACF
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 21:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D10A9C433C1;
        Sat, 13 Aug 2022 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660427293;
        bh=O64tZKkEgJQY+nrgFjCzwqlk5VH4OVWqJEYzGXVO/Hg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cGbTNonc6+/5NtFYFhSdWJs+NkG73gAAThPZTYwOeDcCuAMFBTJB1CVBSW0V5pzHN
         mEkRkUtvjZnvNoyoqz8a6+Y0tS2s68Ek3yvw2pe5bt59UjVNLiAOGcEL1ryZAqtxZQ
         mkRpXQgveUwYIUhXRPenUXRVXRIWGAWJugSXNaMvCZhI9yD0mawk2w3oMBFBQV/Zls
         DaBdtC5q/R6d/qxdc/xmjqON95IoJ3qbvaKBLneK8fGZuVXg1SpMtc0svdTvHAZI1M
         58SyAOdKgqFgu3Hx55cZpSAAn9f0AhmXG/3Ul96MzJkf6MejjUKDxDMmLRC2VHaigc
         qyxlNEYkwIcjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFFA9C43141;
        Sat, 13 Aug 2022 21:48:13 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6e669626-3920-47c0-8a9b-a94c229f1120@kernel.dk>
References: <6e669626-3920-47c0-8a9b-a94c229f1120@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6e669626-3920-47c0-8a9b-a94c229f1120@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-10
X-PR-Tracked-Commit-Id: d1f6222c4978817712e0f2825ce9e830763f0695
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ed159c984079baedff740505d609badb8538e0d
Message-Id: <166042729378.29926.1278736036077561949.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Aug 2022 21:48:13 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Wed, 10 Aug 2022 19:01:18 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ed159c984079baedff740505d609badb8538e0d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
