Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0096EFB8A
	for <lists+io-uring@lfdr.de>; Wed, 26 Apr 2023 22:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbjDZUJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 16:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239359AbjDZUJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 16:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE1B186
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 13:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A33363012
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 20:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E375C433EF;
        Wed, 26 Apr 2023 20:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682539797;
        bh=sF4Ra/EG6wlWOsqAuHQvIXS5ZEqeLXFQioyQX1abBrQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Tt8xj//flvvEX98qApQeBpWOT870CXKEk5Cbxh276/JlIQLYfA3KepXOKWBx1/sec
         OCprtvUsawhb8/XRD6HzlkYzoyUaRF6jztNxR9Akd7GZmbMyUXe32ZtF4TtR8+Xacw
         s4cckniisG0LSv+WOophoqZJk+UbUkaPw688wsMTLNvqdibSj9vLYeeHd2yja0CmEm
         xNz4W5t7UaFAbt/4T9y6NOxdrNwwcRXCCcbdxGWU32QxaS4NqdadHJnqS1kiKvbFV9
         gXTC0imwFoBUJgVJ6shchv1KNCt1CPyUVonvOyzzNP1LIVrwZK6sVtwDQaSrCd3uct
         8dc98z4zOCnfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B33BC43158;
        Wed, 26 Apr 2023 20:09:57 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.4-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c674cf90-e193-3fb7-a59f-b427ad6f3f99@kernel.dk>
References: <c674cf90-e193-3fb7-a59f-b427ad6f3f99@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c674cf90-e193-3fb7-a59f-b427ad6f3f99@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-04-21
X-PR-Tracked-Commit-Id: 3c85cc43c8e7855d202da184baf00c7b8eeacf71
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5b9a7bb72fddbc5247f56ede55d485fab7abdf92
Message-Id: <168253979736.23673.12369653342058648154.pr-tracker-bot@kernel.org>
Date:   Wed, 26 Apr 2023 20:09:57 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 21 Apr 2023 11:06:41 -0600:

> git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-04-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5b9a7bb72fddbc5247f56ede55d485fab7abdf92

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
