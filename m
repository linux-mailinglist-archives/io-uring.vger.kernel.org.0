Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13AC353597
	for <lists+io-uring@lfdr.de>; Sat,  3 Apr 2021 23:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhDCVdq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Apr 2021 17:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236744AbhDCVdq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 3 Apr 2021 17:33:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FE8361262;
        Sat,  3 Apr 2021 21:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617485622;
        bh=po+RZy7uBm/hmZkPnp7x7cq93IcbhH4/yEdxUenhtM4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=QjEo7EylQHq4rTEPoLO8Ge7qngnUyuONf4SB1oxu0+J4IAo+bH1+cOxLfnybWajx4
         bQx5KjocM5+sxjWpWeoKeXTp1md/q9PRy2DMn6rd3TpkZxPU3c3YADuA5iJ2wHuc1C
         /Qwrh1M9yfpB8n1gtamIvBq9PLHc1prv62iZdAdmQ0XiAZB/9KTmgY2sHURRzRhtdX
         XzCKxa/9BKTD4oecELcHnJr/UL6i+NSkvbPMpZZpEHN5kD8lOy02GuGOOq+7Xmvgpg
         piNMJ7wJwxgN5b0LjP4qlNyqHNN3/EhVw6XMB5/ZUwK+qkVu+20dGJaxFR6lmNfo5r
         YGuDbJ2mdSS6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8AC62600DF;
        Sat,  3 Apr 2021 21:33:42 +0000 (UTC)
Subject: Re: [GIT PULL] Single io_uring fix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <54a39886-5560-66fb-e6bc-d049010fe3dc@kernel.dk>
References: <54a39886-5560-66fb-e6bc-d049010fe3dc@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <54a39886-5560-66fb-e6bc-d049010fe3dc@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-03
X-PR-Tracked-Commit-Id: e82ad4853948382d37ac512b27a3e70b6f01c103
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d83e98f9d8c88cbae1b05fa5751bddfcf0e222b2
Message-Id: <161748562250.21553.4927405983437580195.pr-tracker-bot@kernel.org>
Date:   Sat, 03 Apr 2021 21:33:42 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 3 Apr 2021 14:03:36 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d83e98f9d8c88cbae1b05fa5751bddfcf0e222b2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
