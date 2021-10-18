Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF01431020
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 08:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhJRGEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 02:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhJRGEo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 18 Oct 2021 02:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F51C60FDA;
        Mon, 18 Oct 2021 06:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634536954;
        bh=J3cZc53ueJHVUNVc7229gOW4HTCOWzhNAcW1CrD9qRw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uVybN9IQBQvdaY5sO52h7SUuHR0SBXjzvAoUsUAo4WI+URpakZcEsE7ZU6V9vi0+V
         tv7B/iMiYECiz2Xikpx/chZtvstNQ5bj1Su9FiRJJXku2UBgz/JZXDdX1VFiMcqpZZ
         Q6J4hUp/bOwdijXeOLJwBDJivOc/e4OaN+2rYQHUp7VLJQO2IVLDbbGl0LdYyUSLHy
         YtnifFsoR+mfEpSpU4vk0y3vKPLflhN8sFOfBQfBj/1H3bZV27tFA0R/K8DYpBaqbb
         ITwAiZW2wR1n46Y0ykIfqciRy4GgfIMPCqjowxesBPnR8QEbFYlvXT1FaBOHrwct6C
         OQ/93qGlpGCGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 49EA360971;
        Mon, 18 Oct 2021 06:02:34 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.15-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9d69d148-95be-c698-3394-f42cec90b49e@kernel.dk>
References: <9d69d148-95be-c698-3394-f42cec90b49e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9d69d148-95be-c698-3394-f42cec90b49e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-17
X-PR-Tracked-Commit-Id: 14cfbb7a7856f190035f8e53045bdbfa648fae41
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cc0af0a95172db52db2ab41b1e8a9c9ac0930b63
Message-Id: <163453695429.9773.6674292336294427357.pr-tracker-bot@kernel.org>
Date:   Mon, 18 Oct 2021 06:02:34 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 17 Oct 2021 07:16:53 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cc0af0a95172db52db2ab41b1e8a9c9ac0930b63

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
