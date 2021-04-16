Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4835B362BE6
	for <lists+io-uring@lfdr.de>; Sat, 17 Apr 2021 01:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhDPX1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 19:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhDPX1j (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 16 Apr 2021 19:27:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7A6E7610E7;
        Fri, 16 Apr 2021 23:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618615634;
        bh=odL/+xIGr58anhfHh0sqBVMvpp6mdp/ggEfT5bRR8Fs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nQRCDUiowYO6g3mLawRwReHPm5mIRUAiWioO1MDibDE1MVmAORqdCNBJ1dpMbv67F
         i0h6VK7tPF32g7oT7CpNNEHt3xjzu05cQKN4dldoXH4QMbyjUWnfSx4eg5QEZjfEja
         RdOSUNC7cLJx0p9cGCCUeWNM+/BZ/SVgkBuzJJ0RrUvZpYvxDWNWTBK2LHgVDDPfYw
         wP57cTrXWcf+i+/WFM7rrz8KvoO6Y5Jo9jWmDkcvHk3J8cM6ajK5LtZrwTkacrQc8j
         C+hu3rl7mrW5+wxCpIZLp1KDUHqm8WzArgJFRJoTNyayHCf5yuxTEY87JG+AZlzCrc
         9vuswp5yUv8Vg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B9E860CD4;
        Fri, 16 Apr 2021 23:27:14 +0000 (UTC)
Subject: Re: [GIT PULL] Single io_uring fix for 5.12-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e1666240-bf3c-445f-880d-241299211fb5@kernel.dk>
References: <e1666240-bf3c-445f-880d-241299211fb5@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e1666240-bf3c-445f-880d-241299211fb5@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-16
X-PR-Tracked-Commit-Id: c7d95613c7d6e003969722a290397b8271bdad17
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9cdbf6467424045617cd6e79dcaad06bb8efa31c
Message-Id: <161861563438.13078.9859904762844491210.pr-tracker-bot@kernel.org>
Date:   Fri, 16 Apr 2021 23:27:14 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 16 Apr 2021 15:54:16 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9cdbf6467424045617cd6e79dcaad06bb8efa31c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
