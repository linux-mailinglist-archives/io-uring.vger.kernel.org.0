Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA2341FD91
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhJBSJd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 14:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233679AbhJBSJd (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 2 Oct 2021 14:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4287C61B3C;
        Sat,  2 Oct 2021 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633198067;
        bh=L1JEVViEHpRB5H91CfnaIy27JwH/9FMpskxfq4oftxA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UIsosljTF8QxDipjVxwSra/8Ak5H/c5r4bKQFqcrhdRzRwkQzTP2hl2O2JE41DAOs
         JLGlPuRAB5ZlI6vxBWGKy/gDxG+nti7IEp+ZtKIT2n3DELpzB72jeOD081HtvBShe/
         MCPqSsEGwouVhnURQwRw9rUFDopu4W/+ChuKV+HcoRj7l2maCQNpOUiGHpw9AEN5CH
         3fxG0wQVyFITIzKivNP/22H1Wnp4fzzhFzsE2fc7C/5c/0+Ub6q+Lpvl0zw7v34rfF
         k1ISnMJNEufvMdXB7y+LnY4tuST9Tl7BhpHoyHZ7OrN7Si+IJbCKRXeyC7J1IIBYrC
         PBT1YZFVzgbbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D533609D6;
        Sat,  2 Oct 2021 18:07:47 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4aecbb63-a279-0fcc-3c8f-418c32b52810@kernel.dk>
References: <4aecbb63-a279-0fcc-3c8f-418c32b52810@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4aecbb63-a279-0fcc-3c8f-418c32b52810@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-01
X-PR-Tracked-Commit-Id: 3f008385d46d3cea4a097d2615cd485f2184ba26
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 65893b49d868bd2de5fbac41744d1eaecc739629
Message-Id: <163319806724.17549.7085228262576825782.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Oct 2021 18:07:47 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 1 Oct 2021 20:06:01 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-01

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/65893b49d868bd2de5fbac41744d1eaecc739629

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
