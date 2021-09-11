Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A04079E2
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhIKRb3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 13:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233130AbhIKRbX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 11 Sep 2021 13:31:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EB61E60FED;
        Sat, 11 Sep 2021 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631381411;
        bh=Rz90CldW3DVI0kZm4HYYqLywDh58mgpnnaJHRAPhxHo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=l1+sxorFo8WUeTEdq/X7JjyWmGxzDvkDg2xr6Gy6j3Pf5d/kbCZroLvi49h/qOs2P
         YnukVZTn619iNy5eeqBmT0g4Kv5pjsjyC2r2CtavzPcHRu0/o19YuWqeseCj8taB0W
         2H8VANJKdBCH6GvCrLKV4dr1oiGK9+vA1Yt/BPtcYXAEJezWRFmgix3TG9pHW0zssb
         05Ubs5dFZuQmf+DlmVgppZf6F0TLmr7rNr4RZEyEkNhRU5EmIgHN59vyxTq7+As8ol
         4KfW7rsDXdkzt+Mke8q0hqsARHxtv0XpgMV8TudXWs/WcibXidl1+Je+h0zCMOofdp
         O8CVE6H/VlRhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E522E609FF;
        Sat, 11 Sep 2021 17:30:10 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <575336ac-5915-a39d-7cb4-53df92c26bd9@kernel.dk>
References: <575336ac-5915-a39d-7cb4-53df92c26bd9@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <575336ac-5915-a39d-7cb4-53df92c26bd9@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-11
X-PR-Tracked-Commit-Id: 32c2d33e0b7c4ea53284d5d9435dd022b582c8cf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c605c39677b9842b0566013e0cf30bc13e90bdbc
Message-Id: <163138141093.31861.3175764168720875003.pr-tracker-bot@kernel.org>
Date:   Sat, 11 Sep 2021 17:30:10 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 11 Sep 2021 08:29:44 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c605c39677b9842b0566013e0cf30bc13e90bdbc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
