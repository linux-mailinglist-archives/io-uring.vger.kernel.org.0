Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D097F25E307
	for <lists+io-uring@lfdr.de>; Fri,  4 Sep 2020 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgIDUt3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Sep 2020 16:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbgIDUtO (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 4 Sep 2020 16:49:14 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.9-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599252554;
        bh=2xnkVTRAJH7WPP8mrrRiCAQ6w9+g+OvEXz2Fsic1YNo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jt4jzJNnJ2S3OX0b9J4Rs7vvZhbPQIpW/FkR41pQMpcHAp/4Jm1SUgzGE646KGN6c
         cGdUVFTbY7/KbKZSzmTMenB6suvu273v8kDB3IE3uHmy4LvuQ+vObYOSQ6SSMMm+GL
         8PQMARsm+TYtiRLhdLdwfPG0OukxIsU/3AuOGEnI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b380d9cf-2558-b354-981c-e9e868f9587b@kernel.dk>
References: <b380d9cf-2558-b354-981c-e9e868f9587b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b380d9cf-2558-b354-981c-e9e868f9587b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-04
X-PR-Tracked-Commit-Id: 355afaeb578abac907217c256a844cfafb0337b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d849ca483dba7546ad176da83bf66d1c013725f6
Message-Id: <159925255407.25529.8029905792568894265.pr-tracker-bot@kernel.org>
Date:   Fri, 04 Sep 2020 20:49:14 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 4 Sep 2020 09:11:37 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-04

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d849ca483dba7546ad176da83bf66d1c013725f6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
