Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310BD21CB1E
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgGLTaH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 15:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729235AbgGLTaF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 12 Jul 2020 15:30:05 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.8-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594582205;
        bh=ZOTkUzcLVScT992ZTR9i+S0t2YR5xZZgsyFxESPBKWc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=F/ZTLO5Q+YDYx3r642J+KOmsejIyp3Oe1YlwWfWPovjnao1q5fmhflJkGvZph1Q+Q
         QkO1qHz9Vd0B7Zp8yaQaC3DH6pN1FiLXtbau/2bbVn1Wj/e9ex5tIMxIELDO175lse
         FyTTFvCu1KvoTRdCpK+HhDQSm24cSTI4HGoIzQR0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4583056e-bec6-f26a-5194-1add6f2b619f@kernel.dk>
References: <4583056e-bec6-f26a-5194-1add6f2b619f@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <4583056e-bec6-f26a-5194-1add6f2b619f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-12
X-PR-Tracked-Commit-Id: 16d598030a37853a7a6b4384cad19c9c0af2f021
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4437dd6e8f71e8b4b5546924a6e48e7edaf4a8dc
Message-Id: <159458220499.16981.4084002522520617456.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Jul 2020 19:30:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 12 Jul 2020 10:30:40 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4437dd6e8f71e8b4b5546924a6e48e7edaf4a8dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
