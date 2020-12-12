Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297A02D8987
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407788AbgLLTBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Dec 2020 14:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407786AbgLLTBu (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 12 Dec 2020 14:01:50 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.10 final
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607799669;
        bh=hBe5RO/VWBe//VX6IUSJOihy5QUN/AV5EKV8gmCOx34=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=pOnd4mVsD1lgQXk4qCKkpPUoAugLqOe2ixilRiPeEDJ0qwjyPnS387wki4s98WzcN
         8fomOQgWzqynSl90gNbOd6FXkXX95FDCAiFKaFh/GLiYLppRMMejkoa6btL3mAclWo
         AWAju0MCLbxi+oL8F7Qa9Yl2rIGuMa6G1Y4l27Vu12pscQs+RndiBUC+ml25fMvpP8
         PBGEvARvp3MDt35dB+cYQCDWQ4R36Dd/QKICJSGoZ+M5E9eJw4o1Kleg33VXTt+Ltz
         L/IDKT4tlww2PNjWhnZwEFQSp8Gy55WRGgOWLIJKwjZeQtyvC0ghms7hNJQC7zbz46
         vl5pOnMVdwbfg==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <38c1cb1b-3d6f-037c-4596-5b8d94076654@kernel.dk>
References: <38c1cb1b-3d6f-037c-4596-5b8d94076654@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <38c1cb1b-3d6f-037c-4596-5b8d94076654@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-12-11
X-PR-Tracked-Commit-Id: f26c08b444df833b19c00838a530d93963ce9cd0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 31d00f6eb1f2b498a1d7af62cffeba3fbea8cf75
Message-Id: <160779966959.16081.15160810202897738352.pr-tracker-bot@kernel.org>
Date:   Sat, 12 Dec 2020 19:01:09 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 11 Dec 2020 19:56:46 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-12-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/31d00f6eb1f2b498a1d7af62cffeba3fbea8cf75

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
