Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9EB40FDEC
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244238AbhIQQbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 12:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244137AbhIQQbI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 17 Sep 2021 12:31:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF11461100;
        Fri, 17 Sep 2021 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631896185;
        bh=xpms3YIC/uOKuXdQWMERMVraqR3RVNEi+MGWTKLx1YA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Lq4aWoGq0wdgWJj+/3sfoS+mzHdBZYAAWBJGXKW4xVtI2foDqv3cHGcc9UObMFDt4
         hlaM6GOA7Pfxc7wyFesG+NGOfgsCUVm1IQwBvpqxbY15PCF9CYrEmvTJZvyzkAtKKD
         CENP0EKINOAXOf0GYawS/zie8mq9KoTzY2P2ynTMtPzJT9+S1RFa/bLDIlwfuKqMXe
         kRV5bKZ5zllRJUYOeOBbIrz+8Dx+tr3015LMT3hjx/IGuhr3zrVzdJWq2YTY6/6Pbn
         lgR5rkgdYcqb5JKG3J1soWA9Xv00HLiUOzPV4BB0demtliAz/zvWDShG4Qojlt0+bj
         InODDzOkKKtBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9DDD60965;
        Fri, 17 Sep 2021 16:29:45 +0000 (UTC)
Subject: Re: [GIT PULL] iov_iter retry fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
References: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/iov_iter.3-5.15-2021-09-17
X-PR-Tracked-Commit-Id: b66ceaf324b394428bb47054140ddf03d8172e64
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ddf21bd8ab984ccaa924f090fc7f515bb6d51414
Message-Id: <163189618588.30150.10458839833679862710.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Sep 2021 16:29:45 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 17 Sep 2021 08:44:32 -0600:

> git://git.kernel.dk/linux-block.git tags/iov_iter.3-5.15-2021-09-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ddf21bd8ab984ccaa924f090fc7f515bb6d51414

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
