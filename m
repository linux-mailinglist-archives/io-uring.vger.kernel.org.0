Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB72839AAB4
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 21:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFCTLc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 15:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFCTLb (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 3 Jun 2021 15:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C2B47613F8;
        Thu,  3 Jun 2021 19:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622747386;
        bh=2TgE7FDx8ljPbYbeuKrDIkkB1ryJrQFLYht/UhbAjAM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=GZleejCsxmnZdVjXfU06TDpHSvQw5LMKNu3zodZIsNbtzpcU3k9uFuCycD97RqK//
         UIu/aiDfNE0ZRa9tR8z+MO8WRO19RF6t0ozEnp+3RLBSBtBolNp1FyRpOUIgfKZyZx
         RzVi6Q47gU+jCQWjgfxUupcU5gkAJDw5s4GFnLOCo0vynVzSorhyiTyQkou40Ybf1i
         3hwY1S4ba6OxTowdx7fIB42/FCN7Lsze1mRSZ+iRjnmawPweNS3Zmd5m5yte1W3UD8
         iZgoK5zVXPU+cLuQx3KPE8PptSuer+9DbLFoS/r6/R+sfeFCjCRxxQ0B+YQgR6PIaC
         k5GGgWzHp0KnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA05560A6F;
        Thu,  3 Jun 2021 19:09:46 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.13-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <5a3c06eb-eb89-bc0a-7d89-b6c8420bffce@kernel.dk>
References: <5a3c06eb-eb89-bc0a-7d89-b6c8420bffce@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5a3c06eb-eb89-bc0a-7d89-b6c8420bffce@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-06-03
X-PR-Tracked-Commit-Id: 216e5835966a709bb87a4d94a7343dd90ab0bd64
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ec955023967cf9d8669c0bf62fc13aeea002ef9e
Message-Id: <162274738675.14300.985502301022224880.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Jun 2021 19:09:46 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 3 Jun 2021 10:45:00 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-06-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ec955023967cf9d8669c0bf62fc13aeea002ef9e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
