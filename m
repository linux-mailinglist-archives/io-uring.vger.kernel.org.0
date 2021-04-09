Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7355835A8BB
	for <lists+io-uring@lfdr.de>; Sat, 10 Apr 2021 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhDIWee (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 18:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234602AbhDIWee (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 9 Apr 2021 18:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07DA0610F9;
        Fri,  9 Apr 2021 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618007661;
        bh=3HKi6E4Q2IaiPmHvhcyQT6mVvlidEOn3KsDTqFlRMa8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aKW+gAHxMHojWw7LaLidTgyPuXnK5eoPCWfML0Nb7KFlSBMS50mx/UEAuLYXgwidQ
         kx+E9RpULHVQ/2UnwmeVJqjbg8n15brMZl1VYZcb93FjrDu3/TvHuj+B0g6GVKxx/z
         TR0VJ1tItfRdRgc5qXu3U/fEgrMd2t8fXLe76ScBwyC91OB4zcwkAGFnTK3sm1wAGJ
         oLL6xWgfk9tVuBrWlykC5raDX9c9AYdbkxpsYYQi2UvdIv4OHlrRoYUtJjzjfMyiQZ
         uKe4TeH37IMIoQxwe9M8A0x69TsUCO6y6GN8ATBaOzYxjMsyoixRDvaSbgFhHPbPAl
         yU95Vi3VLGqMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA3DE609B6;
        Fri,  9 Apr 2021 22:34:20 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e782a5ec-f2c1-4980-6428-8b0067df213a@kernel.dk>
References: <e782a5ec-f2c1-4980-6428-8b0067df213a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e782a5ec-f2c1-4980-6428-8b0067df213a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-09
X-PR-Tracked-Commit-Id: c60eb049f4a19ddddcd3ee97a9c79ab8066a6a03
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b9784350f990d8fe2ca08978dc25cd5180d5c21
Message-Id: <161800766089.9164.4674075082872791153.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Apr 2021 22:34:20 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 9 Apr 2021 14:53:06 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b9784350f990d8fe2ca08978dc25cd5180d5c21

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
