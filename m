Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D457B3B98
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 22:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjI2UsZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 16:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbjI2UsU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 16:48:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D181B4
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 13:48:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60C4DC433C8;
        Fri, 29 Sep 2023 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696020498;
        bh=mccyi4VaKPvw5uJuTeSxlmoWlgeizec79zVvuFW7yh0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=R6aYQ8Jj+MnYS0Q5/H1WAU3wi9ghzGj188F0cgqwHsQPM9asUxQPKNVqRtZ8Yv0/c
         UlmIVLZZUfbMH0YATOzv+5RIjbi3oPmIRCBpxvw7YA5ayWu7Wfskd7/7znvHMIiuZx
         SN8sh49REcFT3qaZpM4Xjiw8ekTAUW1Se1h+Ht/KK10zGyEH0aRJ21wwQnoTll75oI
         PqS8IwoeOeWYfmJ6JSA/szlOiw0OpZSVRsDSimxrKY9I2jkSYy5s0D4EBc1lwSHANX
         N5ja8M385i+Y029o9/jZTxXlkI4ul/BLFkJQ2WmxMk0q6Ppm60znkiJe9CIK1EYBQG
         QMIm7PmmSZLJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F89BC395C8;
        Fri, 29 Sep 2023 20:48:18 +0000 (UTC)
Subject: Re: Re: [GIT PULL] io_uring fix for 6.6-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <d3d75866-fdc9-425c-93ce-559b1a2e8212@kernel.dk>
References: <e997821f-7f68-4ca3-9689-b6e10ebd6978@kernel.dk> <d3d75866-fdc9-425c-93ce-559b1a2e8212@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d3d75866-fdc9-425c-93ce-559b1a2e8212@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-28
X-PR-Tracked-Commit-Id: a52d4f657568d6458e873f74a9602e022afe666f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a98b95959b98f0015ea159292f516f9e8cc9e4db
Message-Id: <169602049832.6106.14915627354242658907.pr-tracker-bot@kernel.org>
Date:   Fri, 29 Sep 2023 20:48:18 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 29 Sep 2023 03:10:02 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a98b95959b98f0015ea159292f516f9e8cc9e4db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
