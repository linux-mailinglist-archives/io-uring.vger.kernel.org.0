Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A6E2F8F0E
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 21:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAPUCr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 15:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbhAPUCp (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 16 Jan 2021 15:02:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 60D7822C97;
        Sat, 16 Jan 2021 20:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610827325;
        bh=Evf6GRPQ+rBZnRbO8TrtIxESDqsNtEi/Ya+81rk6f2Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fLvFWprP+Lw+eO0iZTWp9Zio7L5c9gp0YQbE9ugxHI0/mjbdgEVOtaIEX5ESOy4hB
         LXZhs7pese6WP+koSC4Da3hC6JVJwWrpjjkOK2hbbxPJaJsjG9SGyNoVk1vTdF0y0Z
         RT1Wws1LfRDKvtYtoM2YhUjBhkAPU3mpUuiPt9wY9Gnv+lov9O+1Wf4EIoCQi2IJ0Q
         s/7Z2w84f2/qlFeNXhem7MR7lJuro63B6AwH7X37LY8jWcrSLqyjDZXu6Tr1/q6f34
         RNWmaA/rAMNdHdDL0ZlezllROKfFt873w9Udt17U+70VMPF9sUZqSpIt2Uz2ZnNj6q
         04rhF+/PD0LhQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5C844605AB;
        Sat, 16 Jan 2021 20:02:05 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.11-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <bbee0141-5923-161f-d8ca-92f5b5da99f5@kernel.dk>
References: <bbee0141-5923-161f-d8ca-92f5b5da99f5@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <bbee0141-5923-161f-d8ca-92f5b5da99f5@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-16
X-PR-Tracked-Commit-Id: a8d13dbccb137c46fead2ec1a4f1fbc8cfc9ea91
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 11c0239ae26450709d37e0d7f658aa0875047229
Message-Id: <161082732537.9271.7098054048092905785.pr-tracker-bot@kernel.org>
Date:   Sat, 16 Jan 2021 20:02:05 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 16 Jan 2021 11:02:58 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/11c0239ae26450709d37e0d7f658aa0875047229

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
