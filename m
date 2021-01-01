Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766DD2E85B7
	for <lists+io-uring@lfdr.de>; Fri,  1 Jan 2021 22:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbhAAV0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jan 2021 16:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727284AbhAAV0S (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 1 Jan 2021 16:26:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A5B022203;
        Fri,  1 Jan 2021 21:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609536338;
        bh=cnjnFiaKtEx8yN4BjtJZvpgQh1OMesoRCQufY7FkRes=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ijCUifY5b2oeTElWc7dn9KAo58cjFHco7uoDxXNFZ1jPI++OoMaehCe7Rota9gYib
         hk+wF8flR5crO5fpvSSpqUXyxlLbXa1HKtsBKEbQ7cunion5E1a9Yr/rrQXMWTpDbt
         JBxmQQLb1KNCZLoi2fEpowGSooSa709298OGyJ1XUXMRyui483MzR1ODRAhH9fSBlS
         j/xygkOuC4nsbWnTcziL5mAgAuwvZV2tI3yCCfnJZhUzuklESoAHeKoldR4Lq7lK0b
         eQ2PmZydEmEvJI8fQibpXhQsh81spNTT279FCN8a8doRyjqv3DG2h5h4XGtyG41p4t
         62Ru0yMb9fe3Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 81B8760190;
        Fri,  1 Jan 2021 21:25:38 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.11-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <aa1cf4b6-a24a-94b8-3f5f-0bad553d01bf@kernel.dk>
References: <aa1cf4b6-a24a-94b8-3f5f-0bad553d01bf@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <aa1cf4b6-a24a-94b8-3f5f-0bad553d01bf@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-01
X-PR-Tracked-Commit-Id: b1b6b5a30dce872f500dc43f067cba8e7f86fc7d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dc3e24b214c50a2ac2dd3d2cc7fb88c9a1e842d4
Message-Id: <160953633852.8778.3662430664424278170.pr-tracker-bot@kernel.org>
Date:   Fri, 01 Jan 2021 21:25:38 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 1 Jan 2021 07:59:24 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-01

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dc3e24b214c50a2ac2dd3d2cc7fb88c9a1e842d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
