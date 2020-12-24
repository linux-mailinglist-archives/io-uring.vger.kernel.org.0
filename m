Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495C92E28F6
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 23:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgLXWAt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Dec 2020 17:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgLXWAl (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 24 Dec 2020 17:00:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EA4C23130;
        Thu, 24 Dec 2020 21:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608847193;
        bh=tSt7wpdJePfyXQne7X2cGHXv28L7LefkiozktsrRLzk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kth6M5wL0albxHyqUJTQkMBIE/lVVddbXToGwLDuSwZCkmoh+0mkhRohfezD6dhYA
         zpDEx8U7Z2k1YkWFVMZ234nrPyMiAx1u+cXqGnAdPt8nHwWExAuR/NWcJ+TDxGWi3n
         E2UWrodmDXoUsAbFKFhJIjNqC6Ck7+OmEA34kT4fDyjpjYU/BjXZGuzt/B8UrAK5GB
         x6V+Wixz/iWCQbXSh+6R5f/9UPU8BnKL77acu9kXaccV5hSHp54r6CPp1Lu6JqlbDX
         QzSknwlGFwdVQ7f3Pn2lCwxt+IYXX8XULztcDh+OMODCjJEjGJpG0mnzfQIiD+YUn2
         kqhm0+wwXnbuw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8A199604E9;
        Thu, 24 Dec 2020 21:59:53 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.11-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <fa99db76-1b26-d6e1-3e73-0765a5fb54d3@kernel.dk>
References: <fa99db76-1b26-d6e1-3e73-0765a5fb54d3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <fa99db76-1b26-d6e1-3e73-0765a5fb54d3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2020-12-23
X-PR-Tracked-Commit-Id: c07e6719511e77c4b289f62bfe96423eb6ea061d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 60e8edd2513abffdb6d4a9b5affca7f9dd5ec73d
Message-Id: <160884719355.31605.12782442724431239797.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Dec 2020 21:59:53 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Wed, 23 Dec 2020 22:07:49 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2020-12-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/60e8edd2513abffdb6d4a9b5affca7f9dd5ec73d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
