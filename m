Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65442BBAD9
	for <lists+io-uring@lfdr.de>; Sat, 21 Nov 2020 01:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgKUA3L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 19:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgKUA3L (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 20 Nov 2020 19:29:11 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605918551;
        bh=PI8aY3HlQ8wc+5CuCo3FX3YVzgUqhNXIuqE7Etdr8e8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=yOC7zW3wcDhVt03c6emKExhK+4JUI0MMhpBS42zRDn6QHzBA5nmsj7Z4Qfx76WKn3
         vf22r2cNQwBqi8+Gga9HDnVtXAC/OaWhuI9BxhRftBbQ10+Przm054PAB8EXsK2ybi
         2KHNK27zaOJGILGFj5CDQ6LyFEL6atF4dBe6FTm0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-20
X-PR-Tracked-Commit-Id: e297822b20e7fe683e107aea46e6402adcf99c70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fa5fca78bb2fe7a58ae7297407dcda1914ea8353
Message-Id: <160591855116.19527.18285885721647504434.pr-tracker-bot@kernel.org>
Date:   Sat, 21 Nov 2020 00:29:11 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 20 Nov 2020 11:45:31 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fa5fca78bb2fe7a58ae7297407dcda1914ea8353

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
