Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA983949B1
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 02:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhE2Awk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 May 2021 20:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhE2Awj (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 28 May 2021 20:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC24261358;
        Sat, 29 May 2021 00:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622249463;
        bh=OIEmjIv1CgJgFs7V2FoRh3UmQz6xyiyycv+xL2jIEGM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tuXcOfKEd8aydUMZ6LYjeBcqxVBgHOuFZPbmUu5+aK+q38+K8FrXiD1DVB78qkhu9
         pD/aQ2EAfsTEDD5nxm0zUKA/B4vYSytN0RTfR9t83577tmOUoX2LVXA8/Wl/YYhsvb
         uY/tmfsUoXnLm2fz/DamRwhCW8kJYECcpk43CSYRTSpCidQ9wTioPT6lkdmCimwl4b
         G3/AZDJmfGvc7wjeOYwgJgLw85moSkLWMYevqUnJrhAK5iSVdwYq5X7X4d/LtlKx7U
         8h8np+C0e5+4r3B1y/XZDlxbbHFAFdYEvviz1EVRP3ldZQoIDECayRGwB2i9Gf6RVo
         xUb3oHQPaRukg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D67C0609EA;
        Sat, 29 May 2021 00:51:03 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.13-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e57bc7de-54fa-3f76-c94f-e9321414a90e@kernel.dk>
References: <e57bc7de-54fa-3f76-c94f-e9321414a90e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e57bc7de-54fa-3f76-c94f-e9321414a90e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-28
X-PR-Tracked-Commit-Id: b16ef427adf31fb4f6522458d37b3fe21d6d03b8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b3dbbae60993365ab4a7ba3f9f6f6eca722b57c1
Message-Id: <162224946387.17808.17188090109869072552.pr-tracker-bot@kernel.org>
Date:   Sat, 29 May 2021 00:51:03 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 28 May 2021 15:57:28 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b3dbbae60993365ab4a7ba3f9f6f6eca722b57c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
