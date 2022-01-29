Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8532A4A2FB5
	for <lists+io-uring@lfdr.de>; Sat, 29 Jan 2022 14:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350625AbiA2NOq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Jan 2022 08:14:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47880 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350561AbiA2NOq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Jan 2022 08:14:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ACB660DBF
        for <io-uring@vger.kernel.org>; Sat, 29 Jan 2022 13:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F6D5C340E8;
        Sat, 29 Jan 2022 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643462085;
        bh=GMdR5cm6AKivWNWEhBXyh9vdKk/KWCsOB8HikKzZleA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KNbrJTEcfJEQ4k88Zvm0sIG1SNFWwJTqJG5zaJUjMcmUuubWtjWMxus+MzdwB28W4
         xdQScFLFUJ/ueZ4ohVaVHUezF+sFSU+N630ZyxUQmQbpu1EWCzVQ24aZ6sCWTLR4xy
         S+3HoFOoB46yghUJEaKoQAvKtJMrgXVg7Es5Q1zzxt9O4NQa7HfIHhOtB32PBDJfdA
         XWG3lZRg2n3gIapilKqJMXuPVtUpvI5bGfFbEEEz5gZvlj5Mf80UHIEpeX9fCdb9Rb
         Y3dmS+0rDvvg9o/L7ZpPfJk5j8MxifgT9xM1MqsBW72duO0IYRd0eX2bNqJd447IWM
         Z0gJKEYBgJsQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F07DE5D084;
        Sat, 29 Jan 2022 13:14:45 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.17-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <86d85ee1-3fea-bb62-b1b2-f0459f3d2371@kernel.dk>
References: <86d85ee1-3fea-bb62-b1b2-f0459f3d2371@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <86d85ee1-3fea-bb62-b1b2-f0459f3d2371@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-01-28
X-PR-Tracked-Commit-Id: f6133fbd373811066c8441737e65f384c8f31974
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b58e9f3a301e175d2de6f7fa1e834c4605e1c73
Message-Id: <164346208551.11910.4811966260472695265.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Jan 2022 13:14:45 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 28 Jan 2022 15:03:48 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-01-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b58e9f3a301e175d2de6f7fa1e834c4605e1c73

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
