Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF892B29AB
	for <lists+io-uring@lfdr.de>; Sat, 14 Nov 2020 01:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKNAPJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Nov 2020 19:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgKNAPI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Nov 2020 19:15:08 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605312908;
        bh=jEvkd08xbOOcCtcxIDSCtHx1Yfu6xT6ZEr7yaxPo99U=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ElTLevEn9NmS0EFVeCtDPwSZ8Z60h0yrmRyjizbzmPVyldHtqGmuYNtCH6nNv6Ckx
         iOL+avZvw2o/k3DJSgTKOh0kC2PwQeHconzDJyTdUVyO5f7fK0LqSDKNIhBIFrf28T
         iypmNdHM8M0YubvlWxLcaM/wSmI+eyK4t3+fFx9Y=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <f3788725-f153-93d9-8d05-d48a8526ecd1@kernel.dk>
References: <f3788725-f153-93d9-8d05-d48a8526ecd1@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f3788725-f153-93d9-8d05-d48a8526ecd1@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-13
X-PR-Tracked-Commit-Id: 88ec3211e46344a7d10cf6cb5045f839f7785f8e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1b1e9262ca644b5b7f1d12b2f8c2edfff420c5f3
Message-Id: <160531290798.27270.17901398063951968105.pr-tracker-bot@kernel.org>
Date:   Sat, 14 Nov 2020 00:15:07 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 13 Nov 2020 14:18:58 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1b1e9262ca644b5b7f1d12b2f8c2edfff420c5f3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
