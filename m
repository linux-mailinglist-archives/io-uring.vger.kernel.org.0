Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1487D1D63FE
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2020 22:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgEPUaD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 May 2020 16:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgEPUaD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 16 May 2020 16:30:03 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589661002;
        bh=U3hncrWt1E/ZyWFFB49mot8Dp17jt0Et6Gqky3JhMmk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=uYltFdDhSx+JhkmH1cAH1aBq5xbqTz4asIenwatLqULTalOz4WO8tCyW4EwyxdUYu
         bzK8bxviqT9Ti7+pu7FV29+3jH3xGc1TJQxznb27NAOJk6vClklzJfjTvIoJef3QUG
         qnQvqt2NkBSCG30p/DbEXqtDkF57TNSp9HxpZxjc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <670c6caa-5c66-a172-f61c-b5398f4e1d4c@kernel.dk>
References: <670c6caa-5c66-a172-f61c-b5398f4e1d4c@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <670c6caa-5c66-a172-f61c-b5398f4e1d4c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.7-2020-05-15
X-PR-Tracked-Commit-Id: 9d9e88a24c1f20ebfc2f28b1762ce78c0b9e1cb3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 18e70f3a7651b420bf5d8ce0a3fd3d1cd9e5b689
Message-Id: <158966100281.3231.9700377369204908482.pr-tracker-bot@kernel.org>
Date:   Sat, 16 May 2020 20:30:02 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 15 May 2020 22:48:47 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/18e70f3a7651b420bf5d8ce0a3fd3d1cd9e5b689

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
