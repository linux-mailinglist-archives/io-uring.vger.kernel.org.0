Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D247336E1AD
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 01:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhD1WZm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 18:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231607AbhD1WZl (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 28 Apr 2021 18:25:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6119161423;
        Wed, 28 Apr 2021 22:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619648696;
        bh=zNZTDNHSjnhB6B4k7YWMAc5UOQWjbhkKTz2wpI+yhGg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ksLfyQCdXPW/Em/TWGYW6yYk4XUs7S50adC2fGeNyaxYJ4DbgQOPEpF+PN3f+8lYU
         /HmwRMOcjBUAFjoreRbgAP76v+2J4UR97UeHLtZF8MiQbsRlx5j6N0a6H/39zIYQTR
         fjLMr2LDkT6XP+0zNBpgoxeH+Z4Av6sQEQW6erOmlDk7EwLcZh9HBpVCk0LfeAsfx5
         lLb+K6h+QfwbVLSZwvMq7ct23fouTPYl9ElWBuFhDh9ji+0So+o+Se0/+wvD60uEDS
         JDCZIOgxaUrfRHdg7xTfiQ/32Gg0jwGi0S8ZpHjkhF5TMEo0pz8C68tTTKxVb9SO+z
         U79o5pLs9eH+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A6D2609B3;
        Wed, 28 Apr 2021 22:24:56 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring changes for 5.13-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2f9d2015-5897-1b6e-1d23-c210fef4ff77@kernel.dk>
References: <2f9d2015-5897-1b6e-1d23-c210fef4ff77@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2f9d2015-5897-1b6e-1d23-c210fef4ff77@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.13/io_uring-2021-04-27
X-PR-Tracked-Commit-Id: 7b289c38335ec7bebe45ed31137d596c808e23ac
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 625434dafdd97372d15de21972be4b682709e854
Message-Id: <161964869636.18647.4009671773834357516.pr-tracker-bot@kernel.org>
Date:   Wed, 28 Apr 2021 22:24:56 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Tue, 27 Apr 2021 12:25:51 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.13/io_uring-2021-04-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/625434dafdd97372d15de21972be4b682709e854

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
