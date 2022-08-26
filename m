Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F23E5A2E03
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbiHZSK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 14:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344930AbiHZSK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 14:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2FF9F742
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29DCCB8321A
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 18:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA5D2C433D6;
        Fri, 26 Aug 2022 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661537423;
        bh=TcoojfsaZr+fM3dVJi/evZ8BwRbwliYMt1Z1V9vxCrs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NxQQtT9FY8rwwFUXS7Prwjg0NH2Rj1PzvOL/YUZOlTTQH3Z055fGFquyTVhdSSDqm
         Ah8wOUh71FGkTReVw6fbwq4C6Uhn/JUGF01vi6hhM+h2W1vjTEqOP2YjDgcI9vFFaB
         NbuJOQnvMkqhB7f0kPk+aiVr3nz1t7wQmy3dA30d6Ii3/Qjeg2BJCtvv+ZeR6EGPc4
         nfW0Ur1cJ9qVVfdErsQCofTTpbWCeJagclMeS8EGpROuW5wZqBZl6gxoBM73TaULm4
         y+xUPQsBf60/4s0vtrw7czfjItBGEz7y3YDrEFrB3YZKGlzy3/LmwiNbhLcYuqeBY+
         qtAfQoiSWglwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7BF5E2A03B;
        Fri, 26 Aug 2022 18:10:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ac58b020-5e09-0bbb-0a63-423faf9bcf5d@kernel.dk>
References: <ac58b020-5e09-0bbb-0a63-423faf9bcf5d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ac58b020-5e09-0bbb-0a63-423faf9bcf5d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-26
X-PR-Tracked-Commit-Id: 581711c46612c1fd7f98960f9ad53f04fdb89853
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b0861eb91cbfdd04d6df5a031152914c1114c18
Message-Id: <166153742374.10059.11371233170314541025.pr-tracker-bot@kernel.org>
Date:   Fri, 26 Aug 2022 18:10:23 +0000
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

The pull request you sent on Fri, 26 Aug 2022 10:36:35 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b0861eb91cbfdd04d6df5a031152914c1114c18

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
