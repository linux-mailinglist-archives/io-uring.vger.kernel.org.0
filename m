Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A623269F4
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBZWYi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 17:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhBZWYg (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 26 Feb 2021 17:24:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5D3AC64DBD;
        Fri, 26 Feb 2021 22:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614378235;
        bh=jfueO9rfbJ0ZDSoh32lFqwyn9pB/7dQx4Ph0R+HC/pI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cODZBN8jhA9ltRb+3I7m4HipyWQms8Ik3IWunA9pXsqqET0v4anjGHCTj/ZC4t+Ya
         KvOtbFqnkqb5twSmI71T3TzGkrgthME0ZTc6fx+0Bl8/9ksvA8iToVtycYKDSt6pN5
         4C4kulSkJa0LVzFkOakoBZemmmqvs7JVrZpMikJ4LxYJzxOK4N9lt2eC7p9fAnSNG4
         +8lFWx2lmB8hfo2J+Be/Kypk6dxowGh1ty6isQcHIh8z6PEU3IZhjfaTQzDKY6Tfes
         dzB1fROlE+tvedJb6RasblEYCTjo1nK4FEmf5AK9GUD/vYRw76y2bDf7DGcW9e3zrl
         1D2ysdSYvITYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4571B609D0;
        Fri, 26 Feb 2021 22:23:55 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 5.12-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
References: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.12/io_uring-2021-02-25
X-PR-Tracked-Commit-Id: cb5e1b81304e089ee3ca948db4d29f71902eb575
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: efba6d3a7c4bb59f0750609fae0f9644d82304b6
Message-Id: <161437823522.23821.12612103510699132436.pr-tracker-bot@kernel.org>
Date:   Fri, 26 Feb 2021 22:23:55 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     torvalds@linux-foundation.org, io-uring@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 25 Feb 2021 15:27:00 -0700:

> git://git.kernel.dk/linux-block.git tags/for-5.12/io_uring-2021-02-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/efba6d3a7c4bb59f0750609fae0f9644d82304b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
