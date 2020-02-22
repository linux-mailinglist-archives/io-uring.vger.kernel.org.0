Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B5E16919A
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 20:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgBVTpS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 14:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgBVTpS (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 22 Feb 2020 14:45:18 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582400718;
        bh=OJI01cW2DVtiGb0zc0cJkCyMaE/2xMkj4Li+jGtyv50=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=uuprSaRM6niLdZrLeYXcqY+XizVqJHJI1cq0zP/VE7a/At3/+ap1ofTXIJfZorgnN
         +7KvLvkw3dO3iY5eCumIBcZu5QwYCCM0uk5U/vlDJzVSB6hJ//D4ckEbWpl1Vb4HCr
         H+8YudhIlFsOtS/m3XTaLW6q8ULFAizgmChGKet4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <fdbadf53-2421-d0a7-8883-059c34608cd0@kernel.dk>
References: <fdbadf53-2421-d0a7-8883-059c34608cd0@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <fdbadf53-2421-d0a7-8883-059c34608cd0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.6-2020-02-22
X-PR-Tracked-Commit-Id: c7849be9cc2dd2754c48ddbaca27c2de6d80a95d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b88025ea47ec8aea47f0c283d182ab26bae2970d
Message-Id: <158240071802.14316.5323907012742571238.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Feb 2020 19:45:18 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 22 Feb 2020 09:05:30 -0800:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-02-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b88025ea47ec8aea47f0c283d182ab26bae2970d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
