Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8839F21BBC8
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGJRFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 13:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgGJRFE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 10 Jul 2020 13:05:04 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.8-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594400704;
        bh=5qk4lbCXTJ1+sI5jDBT9aszICNQGniZbECfvOfW1fcA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=TuwaZPZfYO35mLTV3sSPvwS0dSsvVNafPZE9XvU9xw8KF3h1NEr+J6WuMFGCWcPEM
         ccqTp/AwjOaowfBUPl7S1JZrmesra+FGohRdBsgjyw5X98/tkd3O4PbSFTMAvbVSMH
         F2U78i1LDntfLIXYgj9fjSvLncUiDRrJyDPAygnM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2a7f5f56-a1be-46fc-7b5f-4cc35ca4b33d@kernel.dk>
References: <2a7f5f56-a1be-46fc-7b5f-4cc35ca4b33d@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <2a7f5f56-a1be-46fc-7b5f-4cc35ca4b33d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-10
X-PR-Tracked-Commit-Id: 309fc03a3284af62eb6082fb60327045a1dabf57
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a581387e415bbb0085e7e67906c8f4a99746590e
Message-Id: <159440070462.31334.6909062027623387711.pr-tracker-bot@kernel.org>
Date:   Fri, 10 Jul 2020 17:05:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 10 Jul 2020 10:01:20 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a581387e415bbb0085e7e67906c8f4a99746590e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
