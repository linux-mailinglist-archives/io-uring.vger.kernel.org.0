Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5BC64BCA8
	for <lists+io-uring@lfdr.de>; Tue, 13 Dec 2022 20:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiLMTDh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Dec 2022 14:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiLMTDI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Dec 2022 14:03:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383416434
        for <io-uring@vger.kernel.org>; Tue, 13 Dec 2022 11:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C72C2616F4
        for <io-uring@vger.kernel.org>; Tue, 13 Dec 2022 19:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 356A9C433F0;
        Tue, 13 Dec 2022 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670958174;
        bh=04Z0M5m+/C1lh6vDUbV9V3LERMn0ysfnJOsP1WcStbQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KQWg1PKseaTqlf7BJwPomc13mZvpv3EVUwU885rw3aqXpxXF18YMWDga7RQi83OEA
         ZIK2frN7LS7GcbbW5D2avaH6cteFQxpvwsYCR25CN8iaQxgz8ofSqaPr2vbqwKji2L
         4q6gxa7lXj1UjzcvfZnAA+1ae8tHcHYzv7J9jJDcKSQxiDaBIxMUtzuRfOC/m1BQAO
         SPRHtW5/lokbumyJPAacpy4AxtWXrbPyOt7IsV/EVJ+7l6QYxVKA/rERJRonXGVpDh
         ck4z6d1WgMfNdUwW4Nn2SJ4Bu0ZcnBZA4Fkg2h0BysGqPwwQijwv9k9fgTOgzz3vC8
         dDXxOn5Bdmekw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 249F8C41612;
        Tue, 13 Dec 2022 19:02:54 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring followup updates for 6.2-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b5bd1613-6ae9-d6d0-84b5-22d0469d87b1@kernel.dk>
References: <b5bd1613-6ae9-d6d0-84b5-22d0469d87b1@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b5bd1613-6ae9-d6d0-84b5-22d0469d87b1@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.2/io_uring-next-2022-12-08
X-PR-Tracked-Commit-Id: 761c61c15903db41343532882b0443addb8c2faf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 96f7e448b9f4546ffd0356ffceb2b9586777f316
Message-Id: <167095817414.20557.3630067950836258937.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Dec 2022 19:02:54 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 10 Dec 2022 08:36:00 -0700:

> git://git.kernel.dk/linux.git tags/for-6.2/io_uring-next-2022-12-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/96f7e448b9f4546ffd0356ffceb2b9586777f316

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
