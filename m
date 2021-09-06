Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49B9401F18
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243884AbhIFRQ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 13:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238271AbhIFRQ2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 6 Sep 2021 13:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 33D8560FBF;
        Mon,  6 Sep 2021 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630948523;
        bh=TIMNer2SmsDSdQ1zdOLW0dHbJQ/gMPENzX0/OsMnm1k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Wt22ZHjiUZE6zXAYfqwWe+LIvnfo7w4AyAfdeM5SapCRNb/JuhVkBXf2APyiFwz/x
         lvMLlCK7nCAKsM9S47f4YdRJST5ngP7mslFqoDtWwfk8oWCUuKftrQEb5Ls87XnMct
         IwFDdYEjfmYUvDmywKxcJfKkuvslXk4QEogz3dyV64D+lDTv80xOTBQ+wWIrbnB1lq
         awLmjkiM4scSDmE4EiwJtuOv00NOdJtqhkfxuJxqtqhgJ4nMgRDp1icXadqGb14Uw7
         e9EZOQB+3hWUpTmZgkbkVFx7IHyD8fBd4yJZVExAHvzvjIm5PAgIBnVlIZdtYGP+FY
         LZ6KXsLNueKAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D5DB609B9;
        Mon,  6 Sep 2021 17:15:23 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 5.15-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <625ed118-a5f0-781b-fb98-b555899f2732@kernel.dk>
References: <625ed118-a5f0-781b-fb98-b555899f2732@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <625ed118-a5f0-781b-fb98-b555899f2732@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.15/io_uring-2021-09-04
X-PR-Tracked-Commit-Id: 2fc2a7a62eb58650e71b4550cf6fa6cc0a75b2d2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 60f8fbaa954452104a1914e21c5cc109f7bf276a
Message-Id: <163094852317.9377.9525996405421913198.pr-tracker-bot@kernel.org>
Date:   Mon, 06 Sep 2021 17:15:23 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 5 Sep 2021 12:51:12 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.15/io_uring-2021-09-04

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/60f8fbaa954452104a1914e21c5cc109f7bf276a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
