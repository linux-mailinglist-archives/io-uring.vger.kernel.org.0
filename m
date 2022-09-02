Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3A5ABB64
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIBXsR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiIBXsQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2F0106DAC
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B0AE61FF0
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 23:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3465C433D7;
        Fri,  2 Sep 2022 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662162490;
        bh=C0bkPx6GF4Agi1lgut8dDVjAmTQfqRRquCjlTPv8T8Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KGG7ta+WFXK8+OnMj7p4uJadsZHxob5mKXM6KisWKJwoSfYmmzGUQXQYtfdAFLCZi
         r6jpbDp22Q4hb4kDoZ86KCmL3TmG1fz83GnXUXJA4Y3vNSybjaW7UMwANUBbTpjO2p
         KAcnyw9bIkgx4pT0EVTVeH0baI726NkrfR07i/AzmUwszlTJVnJaIussNvyZX62XuD
         1mzEQb7gmYyuqCrKetjhwkzWP5lHePMZ1OcS2dfx1q6TKg7KLqrwKPOx5LNI3asb/8
         sVPbE1KGNAic36fxwPlmiFby2eTbMzv3Lr2kjwzdM3cM9hfUpSyTaF7ZWf8xD+hCm/
         9w/P35nYGCSJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9241FE924E0;
        Fri,  2 Sep 2022 23:48:10 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2f02c7b9-4b7a-61fc-d8d6-4de76a15fc9f@kernel.dk>
References: <2f02c7b9-4b7a-61fc-d8d6-4de76a15fc9f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2f02c7b9-4b7a-61fc-d8d6-4de76a15fc9f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-02
X-PR-Tracked-Commit-Id: 916d72c10a4ca80ea51f1421e774cb765b53f28f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cec53f4c8df0b3f45796127a31c10b86ec125f55
Message-Id: <166216249059.12135.8399171908013822003.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Sep 2022 23:48:10 +0000
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

The pull request you sent on Fri, 2 Sep 2022 10:37:32 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cec53f4c8df0b3f45796127a31c10b86ec125f55

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
