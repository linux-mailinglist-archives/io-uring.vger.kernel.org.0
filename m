Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C22460144
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 20:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbhK0Twf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 14:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbhK0Tue (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 14:50:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF46C06173E
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 11:47:19 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBB960AC9
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 19:47:19 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id B0DD660230;
        Sat, 27 Nov 2021 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638042438;
        bh=1dH6sceJXfozBIDkkunhBO7P+GkxyuBRhFaO8LN+CNg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pLcBANfucHTAxDbnXOKjT5Qh8UtTfz43PUNhxRhtEcR/M5/3xCXml4LefVFgxex6k
         XqgfloLld4GoYDDVUFF+wRfYKOK4mgVEaOQ4bMAh+6JgMi9m8aQlNV/CCUvf9IKug5
         T+0Y5iF4CRKKoeIQm3RNcYKt9AjN1OuxyCTFIk6l2uK1nvjzU7xMfsouHuwVejKnEU
         PKq2ysrk5N1ASM+FwJV6MXNM2hMf/ZA+kr4s1E39TqoRyPe2fh4Ndcs0T/+eN+2XQZ
         /vx6VuNDG69TECuWbuZ11MDRgqV+ltQD2V/nkYH83ndBQBYRzi2ZIFC+uHIYAW5FFA
         DyqOFGhxSNE3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB6C6608AF;
        Sat, 27 Nov 2021 19:47:18 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 5.16-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <45a2054b-0b02-c0c8-1c62-89e204144701@kernel.dk>
References: <45a2054b-0b02-c0c8-1c62-89e204144701@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <45a2054b-0b02-c0c8-1c62-89e204144701@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-27
X-PR-Tracked-Commit-Id: f6223ff799666235a80d05f8137b73e5580077b9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 86799cdfbcd2308cbad6c1dc983b81595b77b639
Message-Id: <163804243869.4525.9074465469540248199.pr-tracker-bot@kernel.org>
Date:   Sat, 27 Nov 2021 19:47:18 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 27 Nov 2021 09:04:37 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/86799cdfbcd2308cbad6c1dc983b81595b77b639

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
