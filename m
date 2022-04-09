Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C804C4FA4D4
	for <lists+io-uring@lfdr.de>; Sat,  9 Apr 2022 07:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiDIFFy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Apr 2022 01:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242715AbiDIFDr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Apr 2022 01:03:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC711B4EB0
        for <io-uring@vger.kernel.org>; Fri,  8 Apr 2022 22:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 876C5B82356
        for <io-uring@vger.kernel.org>; Sat,  9 Apr 2022 05:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40965C385A8;
        Sat,  9 Apr 2022 05:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649480486;
        bh=a6MUSVQEN8cgYO0Ys8AeJDhazvWjh2j8ExQaDksa7Pk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oi2znlzOK5uD97dL5cN9XUSDW4b5cupaHnwcmLdJvfaKJfC9F9fmRAkdh1RSbprNq
         J43eLUzXp13Yv8P0eF8aJkwvJENTbK8+T6INFGuVSipR/v/NlPWiUlWEu5yLWO16ID
         a95c9nPDqlAAWeEUpoTuRJ5vobS60dEtM6RPppYqxf88W5ak+ZFlJMid+qnli2a7WC
         qQX+oJQc96l7JuyDnqfWgqK5Rx8CVzrgtbwz2HVegZx75b+uwmyOPV6mWDboeNmUvH
         5XJFSvSHtxvRh0FExuHHSSx1EK5afmgOOtwG8MMmiS/o6Ouz6WmMpfbdUs/LZS+vqv
         1ErFn/lrHXZ+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D902E85D15;
        Sat,  9 Apr 2022 05:01:26 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.18-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <3576e052-e303-1659-ceaa-91252cf667d4@kernel.dk>
References: <3576e052-e303-1659-ceaa-91252cf667d4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <3576e052-e303-1659-ceaa-91252cf667d4@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-08
X-PR-Tracked-Commit-Id: e677edbcabee849bfdd43f1602bccbecf736a646
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d6f9f2475f6f288b8b144bc263636c0b09cb4ef
Message-Id: <164948048618.21317.16886954100053027711.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Apr 2022 05:01:26 +0000
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

The pull request you sent on Fri, 8 Apr 2022 19:53:09 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d6f9f2475f6f288b8b144bc263636c0b09cb4ef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
