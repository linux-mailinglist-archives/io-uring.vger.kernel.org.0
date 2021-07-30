Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF73DBE1F
	for <lists+io-uring@lfdr.de>; Fri, 30 Jul 2021 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhG3SL2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jul 2021 14:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhG3SL0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 30 Jul 2021 14:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1E42E60F01;
        Fri, 30 Jul 2021 18:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627668681;
        bh=gn2YZxOk5iTO2nAleV/Ndp1XqD0Pa6/sINUMODJhmnE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HbNVMobxm/iZN6xVKJiMBjbKykm8ikk53/trrVPzNGklezmehj3JzPXv+080sO3cI
         k266zWLSj8dxboicGf59KPBEH2axII4ZACNtJWe1MkW2VzRzbu7LzLnbjXR3tJjxAL
         xftzpNZgNNJTDZodOgqViOH4n1slS6w+aqoJq5Hd9aCZxAkJHt28ICY2iK/4GhXYo9
         3HovyZ4IIa7EIbi4mPy1zcpB1u1lVtus6bDhSWFMxdRUWkj8UMwwEUI1dimg0I4goa
         MwocCScFaTBbEDcVYA4riSsWoew541zus4tEM+rzvAAbDYAhoidI8tZ7jIFQjvK9/j
         UVrunCaWC6V6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18DE6609F6;
        Fri, 30 Jul 2021 18:11:21 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <8f298e55-c978-a5b4-82fe-084ea2246fe3@kernel.dk>
References: <8f298e55-c978-a5b4-82fe-084ea2246fe3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8f298e55-c978-a5b4-82fe-084ea2246fe3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-30
X-PR-Tracked-Commit-Id: a890d01e4ee016978776e45340e521b3bbbdf41f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27eb687bcdb987d978da842ede944bee335b3524
Message-Id: <162766868109.11392.14645449878164712180.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Jul 2021 18:11:21 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 30 Jul 2021 09:16:33 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27eb687bcdb987d978da842ede944bee335b3524

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
