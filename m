Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B33120C2F0
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 18:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgF0QFM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 12:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgF0QFM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 27 Jun 2020 12:05:12 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.8-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593273911;
        bh=2QKX883OF21/fLrPWuxLSdE8UL/L7zjlOXs1eFCUbfM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=pv610Q5XZtxhX8xs6uyYECEnVmTLXNb68lP+8peSQ1wUXY7a9eyaTCyv5bdsP9SqP
         FWdq3yx7+9vNSNurgzP0QSpcEcgpekXKo5mDXqV/xm2CBzk3qxXFYb4HVeFgqysAWL
         sLVlbs8KFbQwvabmnL9sF9fKeq2rjEMH3i0uFK28=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cbae6931-9653-d051-fab5-08537e1dd1bc@kernel.dk>
References: <cbae6931-9653-d051-fab5-08537e1dd1bc@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cbae6931-9653-d051-fab5-08537e1dd1bc@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-06-26
X-PR-Tracked-Commit-Id: d60b5fbc1ce8210759b568da49d149b868e7c6d3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ab0f2473d374f0dc4e3cc3f386abfafd8cf08ed2
Message-Id: <159327391175.13835.16431968395056013532.pr-tracker-bot@kernel.org>
Date:   Sat, 27 Jun 2020 16:05:11 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 26 Jun 2020 13:42:18 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-06-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ab0f2473d374f0dc4e3cc3f386abfafd8cf08ed2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
