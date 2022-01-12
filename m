Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F748CBAB
	for <lists+io-uring@lfdr.de>; Wed, 12 Jan 2022 20:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356876AbiALTNv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jan 2022 14:13:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59522 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356933AbiALTMK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jan 2022 14:12:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D96161ABA
        for <io-uring@vger.kernel.org>; Wed, 12 Jan 2022 19:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B49ACC36AEB;
        Wed, 12 Jan 2022 19:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642014729;
        bh=sGLhn3wYn+khc/4rAdy650S4GwIswMdZtZUsoecWC40=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MCBPIwr+A4/SpzwSY1ClnHdOrf655t7zi8g/puf98z6ywpeJFuptGKx8OddgO0Seh
         mUlQ9WrMoZTgWR8A4QKka7aO61KS44fTBh3HX2HOCx71Ky/HCXDbzFZPloO9YiR4nb
         2AQNPBCl4wSltJ/PD98gQotqi6pRFT20aTeXKaeUWCmRSR454QepTA+wkKrtNIm56q
         FCr/FU9TeQSYkBPtjGLHfZqxWK4Oe9NrDGg4HkWOaN/i1XQDbytfjIj6SjgIG+QDD4
         fCIml83jj4YtOACXHm5TdqjMrhynHnaufbuCzligBoAB3LuH+xRLGMB0+Cg6WckCrw
         UyoRC++4eF+yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A38E9F60796;
        Wed, 12 Jan 2022 19:12:09 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 5.17-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b5dc115b-b549-aa6d-6845-3244660ee680@kernel.dk>
References: <b5dc115b-b549-aa6d-6845-3244660ee680@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b5dc115b-b549-aa6d-6845-3244660ee680@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.17/io_uring-2022-01-11
X-PR-Tracked-Commit-Id: 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 42a7b4ed45e7667836fae4fb0e1ac6340588b1b0
Message-Id: <164201472966.2601.13722928287048336858.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Jan 2022 19:12:09 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Tue, 11 Jan 2022 14:47:01 -0700:

> git://git.kernel.dk/linux-block.git tags/for-5.17/io_uring-2022-01-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/42a7b4ed45e7667836fae4fb0e1ac6340588b1b0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
