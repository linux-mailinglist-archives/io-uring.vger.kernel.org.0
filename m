Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2F53D49C5
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 22:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhGXTgM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 15:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhGXTgL (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 24 Jul 2021 15:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A81B60E96;
        Sat, 24 Jul 2021 20:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627157802;
        bh=Sq6F1C3al9FYXrBvC3Rswh1vuHi9eCcYBnsvuQRsJ9I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jBtuZhrnu7VF6tF4LNxSpSr8vq6TNJOJ4bKReu4u+zhffPY4vFssaMwT3qkv+4Wp7
         3zScD/kuWpWSq1cXzDd+/PDv2hvleuDdPLiVbAQeVOJPLDAMzl8/Q7RGb7Z9SWye3N
         EwNdNaRbGJf26NaqmXVY0EpabPdRJc8PFgp3kr2Ov3IbmPpW8a56X3FuEy1zGsKU/A
         6HOwx0Dnjh9aEpgMU/EbIBrZQ8qREmytgRLsMRcfb+mda4qDLBIkYVh/wuQvGQP0zJ
         j+haIeYTPaf/xAypQ20aHfWEI/IgL6KxpFA8lYhrXEKySgsU3BCjMGoORaHbiomubz
         hcAQRoVrf1sTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 851B660A08;
        Sat, 24 Jul 2021 20:16:42 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <06134f44-1dc8-e5c3-4697-84401b9d7c8f@kernel.dk>
References: <06134f44-1dc8-e5c3-4697-84401b9d7c8f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <06134f44-1dc8-e5c3-4697-84401b9d7c8f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-24
X-PR-Tracked-Commit-Id: 991468dcf198bb87f24da330676724a704912b47
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ee818c393dce98340bff2b08573d4d2d8650eb7
Message-Id: <162715780253.1145.1685693956428003093.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Jul 2021 20:16:42 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 24 Jul 2021 09:53:15 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ee818c393dce98340bff2b08573d4d2d8650eb7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
