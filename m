Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63560950E
	for <lists+io-uring@lfdr.de>; Sun, 23 Oct 2022 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiJWRSn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Oct 2022 13:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiJWRSm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Oct 2022 13:18:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975F773926
        for <io-uring@vger.kernel.org>; Sun, 23 Oct 2022 10:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9170C60F22
        for <io-uring@vger.kernel.org>; Sun, 23 Oct 2022 17:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1540C433C1;
        Sun, 23 Oct 2022 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545519;
        bh=LCTjw0iMc/KcGJcQTfZUgYcabUQ3Zin+xx+94KwwjAo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bAU88aj0wvR3RiEF4UYHlayznike7OsjQCwpZRG2SKfKIvWSgl2fszM3WfhFR9smE
         Uxpqusz/2pyxt/8HEoi3bbpk3QeXh06yIRVPM5olGtDOvXOVdFa5z7nblUmJ6Bz8Mk
         xn9/q5CpbIJ6N/l4yQtPIvOjLdcLvXMmkDnnrE3ZdHeBt4bwGnhshhJgDm1Ys05eCY
         mOceHIhKYrtBNHi6JycJTY1No/u1NxB3l5D0d9K82NRKzQJVFI3/Wi5RSzoktSvzcD
         DGHQVTl8nL1BI4O9zZHMQwak2accutVLHDHc4jYHpPpaQD3FhqMCvVi1ghfabcjnYB
         BD2Y4wfw5FjQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DEF46E270DF;
        Sun, 23 Oct 2022 17:18:38 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring pull for 6.1-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b9bc8682-1d86-ad68-68da-8b6b275e756b@kernel.dk>
References: <b9bc8682-1d86-ad68-68da-8b6b275e756b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b9bc8682-1d86-ad68-68da-8b6b275e756b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-22
X-PR-Tracked-Commit-Id: cc767e7c6913f770741d9fad1efa4957c2623744
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 942e01ab90151a16b79b5c0cb8e77530d1ee3dbb
Message-Id: <166654551890.1521.821072375072677301.pr-tracker-bot@kernel.org>
Date:   Sun, 23 Oct 2022 17:18:38 +0000
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

The pull request you sent on Sat, 22 Oct 2022 10:32:00 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/942e01ab90151a16b79b5c0cb8e77530d1ee3dbb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
