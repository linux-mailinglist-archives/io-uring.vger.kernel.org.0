Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B0E31A5D7
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhBLUNW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhBLUNV (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 12 Feb 2021 15:13:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0861B64E8E;
        Fri, 12 Feb 2021 20:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613160761;
        bh=1meBkAjUpTIKe9Ut5jLbMe5BY3tav7peJiapFWHeoh0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SjeVcolqdt/BDcq/Co37gQoUnGHKkEi2Fz88uvWCxRw+q9NN/qO/APNifvOdt7gWy
         SGW7DSTdN66rBr19IHnJsDNedz/I2hwsRDaKzVjFFgysrcxi8SLw88Ntu8O12rcRDB
         P1j9nSAVAbnH67FzhypAJ85BlLr0Y+gkpo7b2iV9ygRHE2IfZLX1zSHBTMvcAKUr2H
         y/uTD1ltm9Rez57T7o9AD0nb0faRglrhk/Tr38xiYMCozq5rwjxW5FUVHzBtTEIdWh
         aLgrjJiVIW9IfaQMym3p1fh6FDOvAFwUuK02zfmUs8DW73BtiOVWyxPyn44aF4HL1h
         3ba+fxEua0ugg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0489060971;
        Fri, 12 Feb 2021 20:12:41 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-02-12
X-PR-Tracked-Commit-Id: 92c75f7594d5060a4cb240f0e987a802f8486b11
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c6d8570e4d642a0c0bfbe7362ffa1b1433c72db1
Message-Id: <161316076101.13717.18357698910284341425.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Feb 2021 20:12:41 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 12 Feb 2021 07:08:31 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-02-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c6d8570e4d642a0c0bfbe7362ffa1b1433c72db1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
