Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00A3819D7
	for <lists+io-uring@lfdr.de>; Sat, 15 May 2021 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhEOQaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 May 2021 12:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233419AbhEOQaL (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 15 May 2021 12:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B87CC613CE;
        Sat, 15 May 2021 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621096138;
        bh=wsgsupLhktEzQSE340w1jc0xoOI3ggaiXNSFmJeIxmk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MKLjWokJcy1dRLwOtz37UfOlwQ+afjk/8xlwdg1E0y+xAG4S8CWGdCULEN9ztIYd9
         EB7Iw9oaQKvT6y0DWD0bBxssk0sgN/dVfFep5rAygKDw3c9Esfpu9LNt2RarGqfA36
         fwq15oBsUJDRLjDCLYAThIGuyiDZjF04rKhbaeR3zOOgmOivMeMqgsOWPMfACY+INv
         /ciMPH005qnfpH92H3XJwFMG1f+t4qudq7Vj32jfyYtg/vsXwzoUZMXk5FrxbWxbyf
         EkE60l86byY6p1q4mmx7kHrgO4ooouv0Cmo7JgUpIQFt+ZACNhL+j86DY8aqTTZVrJ
         enJZSLj7m6YaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B347560727;
        Sat, 15 May 2021 16:28:58 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.13-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b2514806-2c8d-eb6c-51d9-2214fa5c573f@kernel.dk>
References: <b2514806-2c8d-eb6c-51d9-2214fa5c573f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b2514806-2c8d-eb6c-51d9-2214fa5c573f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-14
X-PR-Tracked-Commit-Id: 489809e2e22b3dedc0737163d97eb2b574137b42
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56015910355992f040f6163dcec96642021d2737
Message-Id: <162109613872.13678.3621471929445417992.pr-tracker-bot@kernel.org>
Date:   Sat, 15 May 2021 16:28:58 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 14 May 2021 21:05:55 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56015910355992f040f6163dcec96642021d2737

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
