Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC24F34294F
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCTAJj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhCTAJ0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 19 Mar 2021 20:09:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C71E61982;
        Sat, 20 Mar 2021 00:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616198966;
        bh=TGs+78fuPwLN+/v7933UGOO9dCigBeBg2fdFwBMPHQw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pUfMR+FOsdJbMpBJlkxa34VdSWnujGibePhIUpHhMxgxg4t8Txk/er5L47tcqHqW+
         MPUUejPzwDVLkT+2ENuGfBmlBz2zFgzvx7dlRx9WNFMr3iSA6tCf2UG1UuhDie5DjN
         oLCteMgVR2xQLWb8Wcw+TF6Wd/2nTPmly30ON1TCFQPcHK0C8QmbNsSRuoylYW6/FA
         QEMxxYAAquugT2qm2AvFEs7WXpyCuBs2Zc6VuRM9+rQ+dvuozcUgsn/0/p3uCIVVfp
         dR1Ln+v6MmOkXHkINW3YYKxWf8ieKg6T1L0+o2pqD75XD8DmznhHmlG0tVoX4+EJVz
         1KW8M4pNqJzMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08019626EB;
        Sat, 20 Mar 2021 00:09:26 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <24fa8b65-1771-f35e-fcc9-75974a92bea7@kernel.dk>
References: <24fa8b65-1771-f35e-fcc9-75974a92bea7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <24fa8b65-1771-f35e-fcc9-75974a92bea7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-19
X-PR-Tracked-Commit-Id: de75a3d3f5a14c9ab3c4883de3471d3c92a8ee78
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ada2dad8bf39857f25e6ecbf68bb1664ca1ee5b
Message-Id: <161619896602.24257.1599199338138818123.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Mar 2021 00:09:26 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 19 Mar 2021 16:30:55 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ada2dad8bf39857f25e6ecbf68bb1664ca1ee5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
