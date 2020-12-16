Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F3A2DC83A
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 22:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgLPVSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 16:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgLPVSv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 16 Dec 2020 16:18:51 -0500
Subject: Re: [GIT PULL] io_uring changes for 5.11-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608153491;
        bh=zsrlPyIJ9y08hm3zwBVSCWparXVs9qztJPCS6ZiuCyA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Q8eIw2o/Lo7mhAHbU8Z8FWU7A5YRhQM6KEuyJKGW7aZTTcmFtkGpGEXENvKz62eMV
         JK8P8giz2jKMfK2PlGxSNTFAKAu9S7/i8n3/mYExud1qWtgDh13n2tLlXZ1lvkk2RU
         HUKf/wCLs/w89bcbGQbz14r2W8FkhrcDpMpWLtj/tYpdzcJwp0/bR7zaskjnLYDO66
         6YKCf+AYbOaoplJaOImQ3ST5zmY1TR+BuHifEbBiQai/hr9U8vOLTrD0DNAFM6lRwn
         xNv1e4wvIFy+011fZmRvvXfuVVXzP+NAOFhn0pbzPFHB9kTz7K/j3tMFDodMNK3ArZ
         W0FiDQCndHl7Q==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <917fc381-ae7d-bd35-1b4e-fc65f338b84c@kernel.dk>
References: <917fc381-ae7d-bd35-1b4e-fc65f338b84c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <917fc381-ae7d-bd35-1b4e-fc65f338b84c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.11/io_uring-2020-12-14
X-PR-Tracked-Commit-Id: 59850d226e4907a6f37c1d2fe5ba97546a8691a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 48aba79bcf6ea05148dc82ad9c40713960b00396
Message-Id: <160815349126.27795.16794386967767714116.pr-tracker-bot@kernel.org>
Date:   Wed, 16 Dec 2020 21:18:11 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Mon, 14 Dec 2020 07:41:51 -0700:

> git://git.kernel.dk/linux-block.git tags/for-5.11/io_uring-2020-12-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/48aba79bcf6ea05148dc82ad9c40713960b00396

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
