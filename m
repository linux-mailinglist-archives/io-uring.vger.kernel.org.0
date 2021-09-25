Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB72418520
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 01:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhIYXHa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Sep 2021 19:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhIYXH3 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 25 Sep 2021 19:07:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F86360F11;
        Sat, 25 Sep 2021 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632611154;
        bh=VxHlQPPHEU1kjys0b5JnKEdZAWdSkUisugbYgK1MeME=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=GZUyIeo4pOurqFdmvl7jAM0gjFM8KUha0+A6wW4W+Kd+VnvNyIfVn5XHQOjF3J88Y
         rAcq/lWc6E6gFnWFav2MLIX0byBGkWWnb+cT8VG9ygMS/Nz337PreM+/q4vOODgSFG
         1bNZuAL1cko0zlREr63edHUa4AT0F0dpv8VcJpWPh5a6O7ZWQyYVaL2+VgkhijbXI5
         /E0Emmxg1OPpJeqxsuTcH+hewMNumLO0T18e/DGH/N+V67MsBwDR//4m8hIRuCDfgn
         woEL6hJDSNDskBSZt5D8iJdw6CyayiAXF4TXDs4zA5zXxzBsxIiFASMPbNPk4ORKJQ
         yaLujV2G4Wf8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 594EB600E8;
        Sat, 25 Sep 2021 23:05:54 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-25
X-PR-Tracked-Commit-Id: 7df778be2f61e1a23002d1f2f5d6aaf702771eb8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f6f360aef0e70a45cbf43db1dd9df5a5e96d9836
Message-Id: <163261115436.2532.14248014235040398359.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Sep 2021 23:05:54 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 25 Sep 2021 14:32:38 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f6f360aef0e70a45cbf43db1dd9df5a5e96d9836

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
