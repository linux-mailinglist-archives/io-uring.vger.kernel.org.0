Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB7274BE9
	for <lists+io-uring@lfdr.de>; Wed, 23 Sep 2020 00:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgIVWPY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Sep 2020 18:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIVWPY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 22 Sep 2020 18:15:24 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.9-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600812924;
        bh=UVJzguGCm44sfbkoHo41EuT7SFHdka4Xy+rfnaiGpOA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=frTxDX0JEbe2wEYp3edRiiErA3OqcQ4gxCQzP+Vs/6zHp/XKmVgPirUtrBeVynBTj
         t5cuD+v5yvS2aylJk7xE9tklQwpNuoBwO2h88qGmCuIWreUK1PcnMDRBY26wPrDRFk
         1XodOs7QFkg9psHZM2y3FoogKYSVsn7uVsiEuuKk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <14cc3fb9-2f6e-ef49-c98b-994048c0b4d3@kernel.dk>
References: <14cc3fb9-2f6e-ef49-c98b-994048c0b4d3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <14cc3fb9-2f6e-ef49-c98b-994048c0b4d3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-22
X-PR-Tracked-Commit-Id: 4eb8dded6b82e184c09bb963bea0335fa3f30b55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0baca070068c58b95e342881d9da4840d5cf3bd1
Message-Id: <160081292404.1950.8126323357580620009.pr-tracker-bot@kernel.org>
Date:   Tue, 22 Sep 2020 22:15:24 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Tue, 22 Sep 2020 11:07:18 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0baca070068c58b95e342881d9da4840d5cf3bd1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
