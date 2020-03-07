Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6E517CFFA
	for <lists+io-uring@lfdr.de>; Sat,  7 Mar 2020 21:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgCGUZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Mar 2020 15:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgCGUZF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 7 Mar 2020 15:25:05 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583612704;
        bh=LqZikUIGjrG49YBGy3wYSV0PklxJB5J09FO9REe4fZM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=pTYVIOKrcklVcbJrqYpx0BCvWD5U/4d5UKmYPIThhZO7e8yZHKDNtZaehADDDEFkc
         xVuDb3qVYEhaF1tuovvBWqjjX4Y2e7KbzsUQpe4FGvhh+pGPJKfI1t+TXMkmk+whc4
         ug02imbUgdfJGxcPWXeVrvPF9sApcfNsHf2Q3eF0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b8c32cfe-9bf8-ee8c-a91b-565583a44a8c@kernel.dk>
References: <b8c32cfe-9bf8-ee8c-a91b-565583a44a8c@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b8c32cfe-9bf8-ee8c-a91b-565583a44a8c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.6-2020-03-07
X-PR-Tracked-Commit-Id: f0e20b8943509d81200cef5e30af2adfddba0f5c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c20037652700024cffeb6b0f74306ce9b391248f
Message-Id: <158361270490.17903.10576399726265115993.pr-tracker-bot@kernel.org>
Date:   Sat, 07 Mar 2020 20:25:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 7 Mar 2020 12:16:34 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-03-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c20037652700024cffeb6b0f74306ce9b391248f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
