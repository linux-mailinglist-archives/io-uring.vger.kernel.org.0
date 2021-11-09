Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3275E44B346
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 20:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbhKITep (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 14:34:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243305AbhKITel (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 9 Nov 2021 14:34:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 94B4361055;
        Tue,  9 Nov 2021 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636486315;
        bh=GngUjvLei63B/WcLQOWMFKoaIfjqgzuMtEO5ipAKIPY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KqkYQkfluYkJO8UJpfjuxpsV+xPQLqqFaU90kMNerSg60Mwk0N/gWGTlr6bY5YWIc
         V3uOVpG569eIZb5h1VvtnO7hc3f0c/L9Dkl4RPOAZRzZT/OmLORTJkSYDFPGz28SGL
         C9W0j0Xd2OVf8WPGUTaiWYBhkqTMBDseG/k/kl8yHRqsGgrDLkSVo8zkYMnRyOtBnP
         4Loglm5kKEdhXnA6O77WpJfx/w/Es6i5rSs0ZcaCp/ORfKIQyUALIKmeCDzNJWdwfJ
         0AXK5j4Z8XptvIWcaYKFTZ1q10+MNiIDZH4RRWHZRJodpUQEjSRPcAVth/6CoLyUr7
         gsB8l2lHSbhbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8E96960A3C;
        Tue,  9 Nov 2021 19:31:55 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9d956803-8a89-391d-30e3-89350249f697@kernel.dk>
References: <9d956803-8a89-391d-30e3-89350249f697@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9d956803-8a89-391d-30e3-89350249f697@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-09
X-PR-Tracked-Commit-Id: bad119b9a00019054f0c9e2045f312ed63ace4f4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 007301c472efd5c86e69e883dd889c555f131ab5
Message-Id: <163648631557.13393.18151270723012408510.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Nov 2021 19:31:55 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Tue, 9 Nov 2021 10:06:34 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/007301c472efd5c86e69e883dd889c555f131ab5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
