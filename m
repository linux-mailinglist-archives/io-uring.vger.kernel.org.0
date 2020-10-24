Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF25297E43
	for <lists+io-uring@lfdr.de>; Sat, 24 Oct 2020 21:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764231AbgJXTzQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Oct 2020 15:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764227AbgJXTzP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 24 Oct 2020 15:55:15 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603569315;
        bh=WYneAiwXHxD8w+96w38EMxfYny21tdTPsS7HQ/mdeCw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HQ8afzcQsNSzsBEpvbwBw8SOumvJ8pqcqU5NATb0vx7b8Ta20zBESoLPsEr2hFhX9
         d4OX9Dxq+PqX6bwCfD7S/VmHVhusZITMMajwCeASOsI1IrwuL4WOarcytC8gERqBIu
         XgavpuOwTx/NP2F0+DZajGgQ6ffPcvYJkx2H8alQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1f4b24d8-e9f3-e74b-02be-e0483dc45b42@kernel.dk>
References: <1f4b24d8-e9f3-e74b-02be-e0483dc45b42@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1f4b24d8-e9f3-e74b-02be-e0483dc45b42@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-24
X-PR-Tracked-Commit-Id: ee6e00c868221f5f7d0b6eb4e8379a148e26bc20
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af0041875ce7f5a05362b884e90cf82c27876096
Message-Id: <160356931547.14356.550781125485724872.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Oct 2020 19:55:15 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 24 Oct 2020 09:13:33 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af0041875ce7f5a05362b884e90cf82c27876096

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
