Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F61339951
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhCLVxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhCLVwh (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 12 Mar 2021 16:52:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CBA3764F86;
        Fri, 12 Mar 2021 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615585956;
        bh=x4ydKkcTfroWw5SHi3joA2gx1Zc0iUg8B/uVhfSSWBo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cSOQTLLrtgZyEQ4n4QgKMx/ABWlIQIiEVqECv8nciRLBrCQxO9p7dtKmP9Uzqr69w
         GZlsz0eVw5xRgg6Jn6y/LukgGGvOH2ZqpdMYNLzYSR+VXgb5VCt2t22WN3ZRRttAHC
         x1MLXCQwU2BqJDaeOYIRveH88TUJIb0yDxrpG7AHfRrSCwP1H+ghQLdWJ7dPSgl91g
         ej89nBD+UfCBS1evKEUDNc3g0iaNpygCVdhQ/A/4Fsgd6XwMPeB3wDUoFEhToxjkZF
         T1+UXmHwJXjEmNiHOljvj0Xfu+OuJ56LZlUlchUiQjKq91hVnQB/qBOvLF2C2ICz/a
         YdG1ycF5wkofA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5BC6609CC;
        Fri, 12 Mar 2021 21:52:36 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-12
X-PR-Tracked-Commit-Id: 58f99373834151e1ca7edc49bc5578d9d40db099
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9278be92f22979a026a68206e226722138c9443d
Message-Id: <161558595680.23578.8718427870968673760.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Mar 2021 21:52:36 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 12 Mar 2021 12:48:29 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9278be92f22979a026a68206e226722138c9443d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
