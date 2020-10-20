Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE12944DC
	for <lists+io-uring@lfdr.de>; Wed, 21 Oct 2020 00:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392681AbgJTWBD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 18:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392670AbgJTWBC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 20 Oct 2020 18:01:02 -0400
Subject: Re: [GIT PULL] io_uring updates for 5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603231262;
        bh=B+hPgNk/8OCysXbHF9T+Wieve90kXLR5bDgiBXmTX3s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=tiy3y62clykjV1J1lUeMxjU8JFZNXurpg4qIyq+1CyzdSRB/RqnC6jjBEXcSXJZ7a
         EOYmiAUpOcEdKpvBH9Z1mBDluGXKsNqjzwJlBCA126PIizQl+Ni3TmxRdAYz8hZ8nk
         3jozj0nuvspW9heVc9sRZGcAIub4I9Ds6rG/dZ4k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a4cf582e-1f2f-4567-a32d-87736453b0fb@kernel.dk>
References: <a4cf582e-1f2f-4567-a32d-87736453b0fb@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a4cf582e-1f2f-4567-a32d-87736453b0fb@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-20
X-PR-Tracked-Commit-Id: 9ba0d0c81284f4ec0b24529bdba2fc68b9d6a09a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4962a85696f9439970bfd84f7ce23b2721f13549
Message-Id: <160323126242.2890.17773638816118136765.pr-tracker-bot@kernel.org>
Date:   Tue, 20 Oct 2020 22:01:02 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Tue, 20 Oct 2020 08:40:46 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4962a85696f9439970bfd84f7ce23b2721f13549

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
