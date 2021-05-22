Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4305938D6E9
	for <lists+io-uring@lfdr.de>; Sat, 22 May 2021 20:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhEVSSX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 May 2021 14:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhEVSSV (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 22 May 2021 14:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E70836105A;
        Sat, 22 May 2021 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621707416;
        bh=y4aX4G06FZCmPAdVNUQ/BklMI9FS2p/wnG7CNuVRwo0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Tam2PHs7E0vazgk2Ifh24qXQU2pyVAvM3mkjWtzAch5DwrRGsgNqUEojU3o5qcwyA
         raMabiYqJPmPwHlqTFyq1VF8kJ6OaW+sJw6XKviJX5SVDQepaTaAmHps+S0IADEMhx
         XoxJS9A5U91J6SD21rHhpCZ61dFtIu+dsSPO3tucxJFa/T6x819tJAk5pTarsREfvC
         ZpNOO34GfLPu8EdoAHJYSSxy6Xhi1tpOgOhafwwLQTcThHgN1t62DOy1Qpjg3L2x6v
         99lgBjjZOaSRXzKYtfX9WVM0H8kgvuL2u1CqHJmFK1bzG+q+yTcl58uus1MfIIAgPA
         PcEvtkqjplUDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E180A609FE;
        Sat, 22 May 2021 18:16:56 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.13-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1d266b00-9506-df9e-bf58-10148eb821ee@kernel.dk>
References: <1d266b00-9506-df9e-bf58-10148eb821ee@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1d266b00-9506-df9e-bf58-10148eb821ee@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-22
X-PR-Tracked-Commit-Id: ba5ef6dc8a827a904794210a227cdb94828e8ae7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b9231dfbcbc0034cf333fee33c190853daee48c0
Message-Id: <162170741691.21100.2302332985368599897.pr-tracker-bot@kernel.org>
Date:   Sat, 22 May 2021 18:16:56 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 22 May 2021 11:20:18 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b9231dfbcbc0034cf333fee33c190853daee48c0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
