Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F9A4714EF
	for <lists+io-uring@lfdr.de>; Sat, 11 Dec 2021 18:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhLKR2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Dec 2021 12:28:51 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59498 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhLKR2u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Dec 2021 12:28:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23982CE09E9
        for <io-uring@vger.kernel.org>; Sat, 11 Dec 2021 17:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5418FC004DD;
        Sat, 11 Dec 2021 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639243727;
        bh=M3GYjKDGspXKMYc6oC2BAM+bgBSGpvDNSg+2GiEGj0c=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sBa8G7Jb8Bk8WvHo8yjPqCpy2WiEZcwhG5IkROPFx2+/us+beXzWBPceH/eWVVK7j
         p8BDg4G1ITLdg6jJfFsfj9D7FsUIYUqUMwI/xKw9WjIosR6BgnyNuoUPs9ji1C0vGJ
         ++7CfrD6wzIsjrlKmCT4dLU9YuCbzEgAn/Cia9xKUWtUTd6pk5L23H6yLmCZJu6NWZ
         oCfKAD919h7wagnbcLaQglUJ+E8moqzxiUWNmd1JY2UpRLVGLZ/iw8a4a5c3Z0Gmpy
         VmzUSSfSfLvnAOH036ZVUjPgbTcXFJW7yugmK1v//7GiGYMYY6BTEHL6KCVXOwRE4f
         Sk0NOF1wpyaLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41A0960A4D;
        Sat, 11 Dec 2021 17:28:47 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.16-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a32963b8-3453-1af5-3544-3d533aa30c3e@kernel.dk>
References: <a32963b8-3453-1af5-3544-3d533aa30c3e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a32963b8-3453-1af5-3544-3d533aa30c3e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-10
X-PR-Tracked-Commit-Id: 71a85387546e50b1a37b0fa45dadcae3bfb35cf6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f152165ada75e1efc7bffbea8a188652bcd04f32
Message-Id: <163924372726.9148.11549407893063403350.pr-tracker-bot@kernel.org>
Date:   Sat, 11 Dec 2021 17:28:47 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 10 Dec 2021 23:09:46 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f152165ada75e1efc7bffbea8a188652bcd04f32

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
