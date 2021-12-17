Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9091479673
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 22:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhLQVna (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 16:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhLQVn3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 16:43:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3858C061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 13:43:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 824CDB82AD9
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 21:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53626C36AE5;
        Fri, 17 Dec 2021 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639777406;
        bh=RSM9PVtUSPkubVb+f6uJCnWzczi+pq7mbURtL16w354=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=h9TBMgUo7X8huJU77H2ApuI4QZ4l0wp2IzvPtZiT/Mk+cPxR8owLcJozfJLAwim1D
         t1iIeYiD19mC5Di77rR35XAcPu5YesPg683rB2pj6WSDLnlD2+8/luo86jPLVb1uUb
         rG18KnwxW30BxdY9VYQzmHAAOwH3aRnMZcLI9Qb9nGh3MtZqWhpP19qLYjJXrbgmOB
         6atOLoa/P6JegFmJpnpfTE3fqtE+14wA6dE4GAa1a9Lali+0aSmb4bkCLW1eNhxTKA
         oVdksLpfDLF+NmYYkg6AbmTWUDJPS15pLEvDn60WticZ7Lflq2LBP5yNWlEChJdxTl
         MtWKYRRFoNfTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4085C60A27;
        Fri, 17 Dec 2021 21:43:26 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
References: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-17
X-PR-Tracked-Commit-Id: d800c65c2d4eccebb27ffb7808e842d5b533823c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cb29eee3b28c79f26aff9e396a55bf2cb831e1d9
Message-Id: <163977740625.30898.9399892661523808579.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Dec 2021 21:43:26 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 17 Dec 2021 10:00:21 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cb29eee3b28c79f26aff9e396a55bf2cb831e1d9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
