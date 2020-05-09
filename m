Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123701CC48E
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgEIUZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 May 2020 16:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgEIUZF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 9 May 2020 16:25:05 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589055904;
        bh=d40vE5YHjV8cq2Tbu7iN4MRiNJoI6JVnXkhtzcw0dX8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=RV3fKHchS3VVDRIKu48eMKiHDwgsNlh/8nDedmIektBH1HSwL/uOUoRkwzpXOv3rf
         YxMXnfwja1Dx1Jg65Zgt6MV3AjuiJwi6pqzs3v4uKFXC4rYbD0sNZscwy1Idx6pGXg
         AK9hLtaEcarxY7CYpAeVWiBKsmdSNO6f72JzIRXk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cf931801-dc26-e86b-57aa-d7730baccdc1@kernel.dk>
References: <cf931801-dc26-e86b-57aa-d7730baccdc1@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cf931801-dc26-e86b-57aa-d7730baccdc1@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.7-2020-05-08
X-PR-Tracked-Commit-Id: 63ff822358b276137059520cf16e587e8073e80f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1d3962ae3b3d3a945f7fd5c651cf170a27521a35
Message-Id: <158905590492.29076.1791242764984106931.pr-tracker-bot@kernel.org>
Date:   Sat, 09 May 2020 20:25:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 8 May 2020 21:12:49 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1d3962ae3b3d3a945f7fd5c651cf170a27521a35

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
