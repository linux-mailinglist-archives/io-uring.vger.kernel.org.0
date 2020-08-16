Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7733D2458EC
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgHPSCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 14:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbgHPSCH (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 16 Aug 2020 14:02:07 -0400
Subject: Re: [GIT PULL] Final io_uring changes for 5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597600927;
        bh=oDHpnhiCVU4fwXJGrQozV6xTg5w0F66Ducy5HkCWjPo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dix51MOkZD62plMejkN8nxE7naT7N/QdEuexG0l/8PAEHf9ySsz3F7noZiTI76sSp
         bfKNd3IhIigvr1IsPWVXJKiUt3TtxP0hzkw3ysuxR3ydc/HsmBYMGj9U+XTJcoo90t
         a+uOgCCMeeruXFmwRu94LkDldOGjPmnX3auEXK4s=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <32d4a5ea-514f-cb79-94ff-83b0c4e1d47b@kernel.dk>
References: <32d4a5ea-514f-cb79-94ff-83b0c4e1d47b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <32d4a5ea-514f-cb79-94ff-83b0c4e1d47b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-08-15
X-PR-Tracked-Commit-Id: f91daf565b0e272a33bd3fcd19eaebd331c5cffd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2cc3c4b3c2e9c99e90aaf19cd801ff2c160f283c
Message-Id: <159760092747.23276.15418199202357287216.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Aug 2020 18:02:07 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 16 Aug 2020 05:22:09 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-08-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2cc3c4b3c2e9c99e90aaf19cd801ff2c160f283c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
