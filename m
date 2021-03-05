Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A676932F5A6
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 22:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCEV67 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 16:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhCEV6y (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 5 Mar 2021 16:58:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DF2EF64FF0;
        Fri,  5 Mar 2021 21:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614981533;
        bh=9zZX7omq37/gcdDnSTV9Vlm976hbLJXgWIaKqfCIMys=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FglvoMVx0Z8tMnVjXZrMIJi5W+VFTBctgaMaLInoMsbU2sjRtd07B2hKRORNPZXQM
         iU5lJczqd1EE62jY9CHPqqjLdXz1fUU2/FLqzgJHq3eUiD1z2MNFRaE+OiJvaPobdQ
         LhDeM+rGzrM/EPWUkCWxSac706L7XgUR5vvFJcC0IY0xX7CqoR/pY3ZOLaVA9fMpdu
         DzbbZpa8yIEw2EQflxWbMibTrKP5xq63KjNQRv9IZ+SqTIHGMmCO4/GHsTv7llkZRE
         1VfH6ncZpAUPIBAH6WETRoywau8rIrT83WAE5N9GiXOg9MivgrPqiDXaIPQdYfsx8O
         0UkOC6+ElwjmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA1F160A12;
        Fri,  5 Mar 2021 21:58:53 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-05
X-PR-Tracked-Commit-Id: e45cff58858883290c98f65d409839a7295c95f3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f292e8730a349577aaf13635399b39a50b8f5910
Message-Id: <161498153388.14373.258875910919451114.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Mar 2021 21:58:53 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 5 Mar 2021 11:09:09 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-05

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f292e8730a349577aaf13635399b39a50b8f5910

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
