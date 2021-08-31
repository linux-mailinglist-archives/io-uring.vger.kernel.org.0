Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83953FC0F0
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 04:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhHaC72 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 22:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239317AbhHaC71 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 30 Aug 2021 22:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AF55A60FED;
        Tue, 31 Aug 2021 02:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630378712;
        bh=q5Xe73qB9ShXTXAbyfmXe/hq0zO0S8Fk4FhZgW0o2Is=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=JEs701GmetC4Oy8NbX5iAU2nTpF8UfbnBu0LJyZtXNalaWnEVhLQfCIDxilPiVvnd
         rvF710v+klCJU7sOp0q1KFPF3LLycqQwQ6imUzs8D5NNCddh3dsaRX+rPqxHKtA0VV
         aPFmJTBManb3+EMvMENSEmQw70Ncn1B5QJqCkPdJLvBj+kteVgdFrxHO0XUahP6OAn
         zGCcS/GJQouxKnaUrETQdKcRNr73/J6USH8gd/pNl6eG17fjgzpZDoTrCEEVTIC80z
         kLA4Qz8bZDv1CQ/pOp/pulk5qJpD2xkhkF5hXgHdv6+hbYjdgjLWq7L99OlbFQtYgF
         kJet9XaJcxc6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABBC660A5A;
        Tue, 31 Aug 2021 02:58:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 5.15-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9ef2a5e9-7380-7e56-7959-b65859ed8f05@kernel.dk>
References: <9ef2a5e9-7380-7e56-7959-b65859ed8f05@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9ef2a5e9-7380-7e56-7959-b65859ed8f05@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.15/io_uring-2021-08-30
X-PR-Tracked-Commit-Id: 87df7fb922d18e96992aa5e824aa34b2065fef59
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c547d89a9a445f6bb757b93247de43d312e722da
Message-Id: <163037871269.18446.11084387754660654532.pr-tracker-bot@kernel.org>
Date:   Tue, 31 Aug 2021 02:58:32 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Mon, 30 Aug 2021 08:53:09 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.15/io_uring-2021-08-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c547d89a9a445f6bb757b93247de43d312e722da

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
