Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3F03F3B20
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 17:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhHUPQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 11:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhHUPQy (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 21 Aug 2021 11:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D43361209;
        Sat, 21 Aug 2021 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629558975;
        bh=AgXg0rU/Dwq0LF9jfq54BewVU5cLCCZePScBkX1j3Og=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LomqB3nk++B2Cdoa0Hj7mMQjcCPCLI0bCHNJ7WMTJH1bZWYJSZGRWK0Qm2O20DWWa
         UB0UAvHBMbGGEGsTjueHhW+7H1Wi00bVvJQc1+cCKVgf0khGuBX6uEfLYhjhpvAsqE
         QFJeL/tS5qBg9XPIgjPpH0On7dK2WM+kvHRam9qNuDmvfAIHEa0mMRQNRxhSRIZMW5
         w2Fro9LNZE/1fcgFFplHPSlITbIvYrGN5ntpW9knoQnxBai7MimnGmcD6LI6WC3d8u
         DF7+ZxJUo9kC5Xsi0LVYqLZ03TsAjxB1CN9HHdlOI6+vI2x9p6eeiGj2pAEjYZJBvP
         1jiwcI3k1jhBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0807160A6B;
        Sat, 21 Aug 2021 15:16:15 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9029c179-a0cc-db86-e2e5-4aa234278ee2@kernel.dk>
References: <9029c179-a0cc-db86-e2e5-4aa234278ee2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9029c179-a0cc-db86-e2e5-4aa234278ee2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-20
X-PR-Tracked-Commit-Id: a30f895ad3239f45012e860d4f94c1a388b36d14
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1e6907d58cf03fc808009681b8ef178affbf96aa
Message-Id: <162955897502.29440.4606306023011693692.pr-tracker-bot@kernel.org>
Date:   Sat, 21 Aug 2021 15:16:15 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 20 Aug 2021 20:54:22 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1e6907d58cf03fc808009681b8ef178affbf96aa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
