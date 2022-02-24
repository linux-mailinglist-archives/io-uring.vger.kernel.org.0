Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965DB4C35A1
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 20:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiBXTS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 14:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiBXTSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 14:18:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C63748893
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 11:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D9E61676
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 19:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67A4AC340E9;
        Thu, 24 Feb 2022 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645730303;
        bh=iu+2iai0ZtF4jaEx2fuM8JZNAyWznaKW/j8b3iKD/JM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rgvuAhPsrLcVhE/z986cAaXV7sfFzLdekC34nxNCFfhburaUntJpb14LhQOmDtrdN
         KGXNZlL0t50GRp1gN7a7RNftDBbXPVOrKFrES0Lyrs+/xHGBmD6zlL8VjfL4lDOmij
         sY0r74rMTCJGf19+ZB2gzmXdanls78tcRcLe+M2UPqfQp2xtehqaWgg2IDK3fvV4zN
         51XdHuwshqQEpJgxm91y7VrDWWkEVLpfytO05BA10rhM0x1L3ScupZTtt9ApeFWLvn
         HVmqBd90l/TLirrWYvaZOlHks/1U7HgWaEIFKPYj4AXIpI1vW+Fz1QyNX161R7+2JX
         +DGEx6+FLMz3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54E9EEAC081;
        Thu, 24 Feb 2022 19:18:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.17-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <16541e0b-e3ce-9e7f-4baa-20cd6e37db1b@kernel.dk>
References: <16541e0b-e3ce-9e7f-4baa-20cd6e37db1b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <16541e0b-e3ce-9e7f-4baa-20cd6e37db1b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-02-23
X-PR-Tracked-Commit-Id: 80912cef18f16f8fe59d1fb9548d4364342be360
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a5f59b17f9dec448976626663a73841460d7ab4
Message-Id: <164573030334.2860.11157351218433560673.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Feb 2022 19:18:23 +0000
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

The pull request you sent on Thu, 24 Feb 2022 10:30:19 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-02-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a5f59b17f9dec448976626663a73841460d7ab4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
