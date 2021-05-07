Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DBF376A7B
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 21:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhEGTIn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 15:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhEGTIl (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 7 May 2021 15:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D21E661432;
        Fri,  7 May 2021 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620414461;
        bh=hFLqIR2NQS+ZBSPCGdrfwuno9kRRnT1a0H5mNy7y5M8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ET8ZhJT4A6AsOqhQyDD+ER1LxxSa3v1gvqpCeSgOJieDu2o2Lpu0nMfL2y55ovlYG
         /lh0AGCWTk0YSDXNqTRF6HP7mzVev6YQL405ea2EsMOiFAWLVwq+XyNo4NomcPAdQp
         ZJqfWXuwA+Hr8Wfoh8+c5B7jPfwAc3iEZ+Q8biejLJdefjnzf9BiARbxtG8mSUKzof
         ipXtaYn5IohmNveOZYFqwKLAKEGEhPryilFbO5RJxBKqvczoNn5ulLsB9HAxH2MjSN
         rXRlrnkZkSBSMSSFeLURBl8hR6JD1Yc0YUl6G7UetYXr++mtn9jgCjmvI3aaMl6Fca
         YE2kALKsYwHiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD02E60A0C;
        Fri,  7 May 2021 19:07:41 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.13-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <172809ab-c9c4-fc36-6bba-3ea0128f748b@kernel.dk>
References: <172809ab-c9c4-fc36-6bba-3ea0128f748b@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <172809ab-c9c4-fc36-6bba-3ea0128f748b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-07
X-PR-Tracked-Commit-Id: 50b7b6f29de3e18e9d6c09641256a0296361cfee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 28b4afeb59db1e78507a747fb872e3ce42cf6d38
Message-Id: <162041446183.12532.8691660378829028747.pr-tracker-bot@kernel.org>
Date:   Fri, 07 May 2021 19:07:41 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 7 May 2021 09:59:40 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/28b4afeb59db1e78507a747fb872e3ce42cf6d38

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
