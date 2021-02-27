Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43938326DED
	for <lists+io-uring@lfdr.de>; Sat, 27 Feb 2021 17:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhB0QmY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Feb 2021 11:42:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhB0Qlw (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 27 Feb 2021 11:41:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 53FF564E56;
        Sat, 27 Feb 2021 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614444070;
        bh=BhZUFNJ9XBAYixO4anPX+0axkw4jkSGB+FVRzZcPWVw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZufxjKn7lDYmvJlOEpvzlfQkO2sACrGR3r09al/5iIEUDQyraOVmw5+gLF++W6DZP
         OUur5xyWBapFBrJ3jUojGBiWDLQC2LxtIXnhxQl5+6/7913miuY5zxDxwQivJ7FMt3
         SLjAsN9udQmOu4bQfpmmveQPyJGSqilp2IukVB6ASa+isYYBrYlsi8vd7BbzVyOmgI
         7vvIo4/LddyzSQu2t2/p3gNw26s6sdONPAyWe6KqpA3x/5gyrov9LIrBnArDDni0vg
         85cqjEKZH/0DVx0z6NA1aZd0X80wNOh8Dt4xh8wm9KiCpFCrh2NzMZrzhf9MhwP1o1
         SasTosUMHNs1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E55560A24;
        Sat, 27 Feb 2021 16:41:10 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring thread worker change
From:   pr-tracker-bot@kernel.org
In-Reply-To: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-worker.v3-2021-02-25
X-PR-Tracked-Commit-Id: d6ce7f6761bf6d669d9c74ec5d3bd1bfe92380c5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5695e51619745d4fe3ec2506a2f0cd982c5e27a4
Message-Id: <161444407019.31243.7693842716512080088.pr-tracker-bot@kernel.org>
Date:   Sat, 27 Feb 2021 16:41:10 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     torvalds@linux-foundation.org, io-uring@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 26 Feb 2021 15:04:20 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-worker.v3-2021-02-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5695e51619745d4fe3ec2506a2f0cd982c5e27a4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
