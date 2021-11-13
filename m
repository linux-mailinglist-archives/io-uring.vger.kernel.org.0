Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7C044F558
	for <lists+io-uring@lfdr.de>; Sat, 13 Nov 2021 22:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhKMVG2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Nov 2021 16:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232203AbhKMVG1 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 13 Nov 2021 16:06:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1CDD160F6E;
        Sat, 13 Nov 2021 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636837415;
        bh=j9S4R5+Y109xhb9XimP5KatVqmdgZ6UaHUcrUmPH2iM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=B+Rk/sYZb7mm4hIpJM/w5z/0pgvSNWnThaqqpBHUcD2cjv6cMcwCvN1rI46JEWrSe
         ePs9gNf7w3/935VAJZ0xLYprBsg0dLcNFzkUJyviM+0TTx+tNe/noDyA0oLuer9yLc
         D8lR907UgZryl22p+UI6j5zckQszQlLApBO/A5/VIp5c9CJruL7YIrO7UMZCJ8YPGN
         wQttAkURfTV11B4S5R5ntjcsiODGIyQvm9fUvhT7SXvLkcu1igyzTfontHzbqIKfvq
         sEXiPnqNb0A1iwudv1561MYaS05/MjM6atEVjgC5fdhme2frPjWJ5DHxXljWRJopyg
         fXATJYTMTt/+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 132A460987;
        Sat, 13 Nov 2021 21:03:35 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6b7088c9-fe17-1d29-44d9-6920050241b2@kernel.dk>
References: <6b7088c9-fe17-1d29-44d9-6920050241b2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6b7088c9-fe17-1d29-44d9-6920050241b2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-13
X-PR-Tracked-Commit-Id: d3e3c102d107bb84251455a298cf475f24bab995
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b7196a219bf7c424b4308e712fc981887927c38
Message-Id: <163683741507.30883.2274373590841234519.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Nov 2021 21:03:35 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 13 Nov 2021 09:48:07 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b7196a219bf7c424b4308e712fc981887927c38

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
