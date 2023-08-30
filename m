Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D722978D2A1
	for <lists+io-uring@lfdr.de>; Wed, 30 Aug 2023 05:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241995AbjH3D7Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 23:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbjH3D6s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 23:58:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35936DB
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 20:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEE196226F
        for <io-uring@vger.kernel.org>; Wed, 30 Aug 2023 03:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34463C433C7;
        Wed, 30 Aug 2023 03:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693367925;
        bh=b3UU1DkylcVxUB7oBROG85Ui8SqopmVxU1uqJ+31ZVA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=QMQguPhWubb49bbDD3CxB+vHAnzOpYXglt21GW9gNXlMe5xDykZdba/XjGHg6Xar5
         HQYYsteaNWQnBUtrVADxNxMZjjKIrUwjWv8CaWmGkRgsSYn2MTUDtwH3eWNhQO6i/1
         PPBlN17BXHGI58G0S/V0IJWh56bmPixvxMV4tELvhVWt4j9OQM6DbxAHIaLGq9uYss
         MUKjH8K7Mx+CYf/LMpyTtAL5wQsVPUyDJVYjKYlvg6lWrOa8NBcgm8ud4axAAG2bl2
         zdJVeTJLgkd6DmVpPR2RrJ8bvn9RtkA9fLMxxbz4+wm5H2alOxnM0VviLmNhVW+88j
         NGSNWSAVlAlDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2469EE29F34;
        Wed, 30 Aug 2023 03:58:45 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.6-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <70336a64-9541-418c-8c71-9c9ee4f4961b@kernel.dk>
References: <70336a64-9541-418c-8c71-9c9ee4f4961b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <70336a64-9541-418c-8c71-9c9ee4f4961b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.6/io_uring-2023-08-28
X-PR-Tracked-Commit-Id: 644c4a7a721fb90356cdd42219c9928a3c386230
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c1b7fcf3f6d94c2c3528bf77054bf174a5ef63d7
Message-Id: <169336792514.6268.13083125627057170726.pr-tracker-bot@kernel.org>
Date:   Wed, 30 Aug 2023 03:58:45 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Mon, 28 Aug 2023 15:19:38 -0600:

> git://git.kernel.dk/linux.git tags/for-6.6/io_uring-2023-08-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c1b7fcf3f6d94c2c3528bf77054bf174a5ef63d7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
