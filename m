Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573132AA82E
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 23:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgKGWIb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 17:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGWIa (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 7 Nov 2020 17:08:30 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604786910;
        bh=QgSIKOs3OqQKbZAG0GjVizhhzreMnrNH9gxKVrB15So=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=IJEE1EEfnppQMrT8OUV22seHxjn9bCrOn335HsefDn+x0ouOKJ/X10GoKlQYlOFAl
         0/goFwnI+OmtmKaHV50iG1wWuJtLC/ZDucMgcQ4UTAISfK4C18fgaTDJ9rvSAOfGJj
         I8ZYTMG2RNh3zYQtoBnCBInRE7BfIyOsEebGoFs8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <adf29460-8af3-b326-a372-2627a9097929@kernel.dk>
References: <adf29460-8af3-b326-a372-2627a9097929@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <adf29460-8af3-b326-a372-2627a9097929@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-07
X-PR-Tracked-Commit-Id: 9a472ef7a3690ac0b77ebfb04c88fa795de2adea
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e9c02d68cc26b28a9a12ebd1aeaed673ad0e73e2
Message-Id: <160478691054.18289.7107173394799017456.pr-tracker-bot@kernel.org>
Date:   Sat, 07 Nov 2020 22:08:30 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 7 Nov 2020 13:13:57 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e9c02d68cc26b28a9a12ebd1aeaed673ad0e73e2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
