Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5938525F00E
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 21:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgIFTOb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 15:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgIFTOa (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 6 Sep 2020 15:14:30 -0400
Subject: Re: [GIT PULL] Followup io_uring fixes for 5.9-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599419670;
        bh=/iSfk6+Er1sRKpQotTb4CU56frZtjy+BK63FIrDn6HI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fpiMyD29CZdiJWJbdO4GH+PG8B2el1pdvpG2giWWmeELz227HKozl3hJVrau9wXoi
         PZjhqs4ifgUYG1zxLcox3Z6KPHFGmCb9MimM9Dia/psQOGtx2F9gbtYaBHHttCtFeH
         TZbH85D576NkBPgz7UKnRn8cYAu4F4AqoW8zhVro=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7b093a7c-4230-c7b7-8f39-15bb4f18d5a7@kernel.dk>
References: <7b093a7c-4230-c7b7-8f39-15bb4f18d5a7@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <7b093a7c-4230-c7b7-8f39-15bb4f18d5a7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-06
X-PR-Tracked-Commit-Id: c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8205e310011f09cc73cd577d7b0074c57b9bb54
Message-Id: <159941967004.19439.8233943946829104444.pr-tracker-bot@kernel.org>
Date:   Sun, 06 Sep 2020 19:14:30 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 6 Sep 2020 09:17:58 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8205e310011f09cc73cd577d7b0074c57b9bb54

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
