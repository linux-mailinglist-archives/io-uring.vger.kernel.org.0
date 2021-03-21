Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4155A343477
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 21:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCUT7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 15:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhCUT7e (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 21 Mar 2021 15:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D7A8861582;
        Sun, 21 Mar 2021 19:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616356772;
        bh=3NOwnA/fUFhFxB0nqe5it7BxWwgo6ihyNSQkud3tYts=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=JNBLlrSTm8/nf04evYZdMddtRQba4KqkF5qxUIBX9XtJ0xjL3YuRF2BM2dnHIpURN
         4xUOA6WaRxmumbQ6LcjLRU+AVCwx1DL3jg4LGn7r0G0R9098PUUyW/sRKZgF+daB1T
         6RD7ZKkVM36J0TydH91bq1lpkb9Rj90GNlAcsntQjScuTroCoAx/DPqCugAWu+m7aB
         tRB5kQLtSuBo7tnf2aCFH1a6/CMHFNnvFvzwP76W5reGz7Ye+ahuYFyV3w5Xp5583B
         2wZaNogmfcEOZWllZRiYVIet8oGXe6WEiXVF76J36N3x0XzbUMVTbjRWT+m600QXHM
         dUrzZl+7HsnjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA25B60A0B;
        Sun, 21 Mar 2021 19:59:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring followup fixes for 5.12-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
References: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-21
X-PR-Tracked-Commit-Id: 0031275d119efe16711cd93519b595e6f9b4b330
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2c41fab1c60b02626c8153a1806a7a1e5d62aaf1
Message-Id: <161635677276.24712.13106573834898165116.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Mar 2021 19:59:32 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 21 Mar 2021 10:38:04 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2c41fab1c60b02626c8153a1806a7a1e5d62aaf1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
