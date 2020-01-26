Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41B1149CE0
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2020 21:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgAZUpE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jan 2020 15:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgAZUpE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 26 Jan 2020 15:45:04 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.5-final
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580071504;
        bh=e5whKQo48EZzSeDWtoewc73WrrEoPDPKZ4wqprbir9I=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=vTnvFR4rYfikTzAo+4tv7qhHZS6w8MW6W0kiF7pRWMSNS6J5Jf1S+WDYdDy+a4L0D
         iord24zGDnNCd/lAseMuWVP1rtapH5PhD+frYoZIglBSbPdnmrr1Uui1hH+MTm5wyC
         6WnugUON0prkwhQRA0gusrhrKMDSrew2QrCuFBDI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <97fc142a-5f87-57f5-67fd-a146996a7ff1@kernel.dk>
References: <97fc142a-5f87-57f5-67fd-a146996a7ff1@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <97fc142a-5f87-57f5-67fd-a146996a7ff1@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.5-2020-01-26
X-PR-Tracked-Commit-Id: ebe10026210f9ea740b9a050ee84a166690fddde
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5cf9ad0e6b164a90581a59609dbf5bda3f5a089c
Message-Id: <158007150415.2238.15200000410316601662.pr-tracker-bot@kernel.org>
Date:   Sun, 26 Jan 2020 20:45:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 26 Jan 2020 13:02:16 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.5-2020-01-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5cf9ad0e6b164a90581a59609dbf5bda3f5a089c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
