Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49CC3B966C
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 21:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhGATW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 15:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhGATWz (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 1 Jul 2021 15:22:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01D8D6140D;
        Thu,  1 Jul 2021 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625167225;
        bh=YfhRs0wlunmCVzA9XLrR63brtR4ZSeV4WIHymBGSD+g=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bOKWMTrsxhp1BJJw+O2x9G4HPvJsNV8QL3vzEFYsaTPqum72ciSeMAXychwmkxlBu
         6BuDb/3B3QceKDdTwC+8PfahXiU9FNV5NhOnQpieEBYO1coxqXNmLelOTiLZrwTb4m
         ArXd1ydkCq+6Q4vWlQjYq+VXP/r1IWb4qlc6ZxBDK4rFio1m2WdgZZyN7LSLrZV8sS
         44XRDoZfcmaLMwQkqW6S3r+6ZQ/7D/q9hx3L7tr5CPluLqBj8bCtw/zpAgfxC3jhOS
         K8ZL+6uiuOEw8CwIs6zDmbwRu1GxWKRqR8tA+Qre+mw+LTKsqggrvMuaR40j2usv4u
         9I1Afq1P4UjSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F00076095D;
        Thu,  1 Jul 2021 19:20:24 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <54ce324e-ef03-4f00-ab95-95e3e047f4b0@kernel.dk>
References: <54ce324e-ef03-4f00-ab95-95e3e047f4b0@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <54ce324e-ef03-4f00-ab95-95e3e047f4b0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.14/io_uring-2021-06-30
X-PR-Tracked-Commit-Id: e149bd742b2db6a63fc078b1ea6843dc9b22678d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c288d9cd710433e5991d58a0764c4d08a933b871
Message-Id: <162516722497.9675.18018403629309837864.pr-tracker-bot@kernel.org>
Date:   Thu, 01 Jul 2021 19:20:24 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 1 Jul 2021 09:24:44 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.14/io_uring-2021-06-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c288d9cd710433e5991d58a0764c4d08a933b871

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
