Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B92F09DB
	for <lists+io-uring@lfdr.de>; Sun, 10 Jan 2021 22:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbhAJVWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 16:22:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbhAJVWF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 10 Jan 2021 16:22:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D8A2822AAB;
        Sun, 10 Jan 2021 21:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610313684;
        bh=7MDzyd1a9asIwH2w2caf5HuV3WYLtD6uj0qmjyNAhSw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=RLcuLLY5vZjsZi3RYT0kQrGadrqHaLYSsiTr5HNsDFL2SxaGzpGKUpq4MsDCOu6lW
         3OGFQcgyifrFMH0FTeDpgJ7Ffw9rdlUpAdCxotYb5I8GoBrQLkwt8EvEErP+Zr75Il
         VLry2nkVQP1ILyxLACCM1PdFtPqGQQu4+SPpkmsMcsull59m5nfFyMyb4kvnJxeUaX
         a26QG8gXG+3e4XDq+4cOm9vv3CLeBWXIDKpHeDEKDcW/vVUfclBczmfBc/gHpAlGDA
         yTo+/i9qafo6fK4qLpy2nIHLvDBeW5OXI5yrsOl4pQkHfxy5KIOr5TmXGMpJiXGz3L
         /tPCqE8TCQ8GA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D440F60140;
        Sun, 10 Jan 2021 21:21:24 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.11-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c394c8fa-f1e2-38a6-4227-4336273cf80d@kernel.dk>
References: <c394c8fa-f1e2-38a6-4227-4336273cf80d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c394c8fa-f1e2-38a6-4227-4336273cf80d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-10
X-PR-Tracked-Commit-Id: d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d430adfea8d2c5baa186cabb130235f72fecbd5b
Message-Id: <161031368486.28318.13499570826430259192.pr-tracker-bot@kernel.org>
Date:   Sun, 10 Jan 2021 21:21:24 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 10 Jan 2021 09:23:46 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d430adfea8d2c5baa186cabb130235f72fecbd5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
