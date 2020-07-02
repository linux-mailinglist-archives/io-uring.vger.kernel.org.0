Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E725D212F82
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgGBWaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jul 2020 18:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgGBWaJ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 2 Jul 2020 18:30:09 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.8-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593729009;
        bh=dHi/JrPC/i519XuIhXSN/safkKhUtZvNI2PrmXYl3a0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ih/GLsZzod23CvI3PAId5zyqF/jypU9LlhrVO2MfAy8cic12OVtSezcw6JuoufJH2
         OMKXE0o0YvklQDecHJik8rCNGsEpCy/30vxDBYcZHQN7/oiQdwDOnag2GnV3RZywUg
         x0/4Bb+e1C1qh8mp2jv+NpGkXWYfkc71AfYSs3B8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ac36babd-3eb7-8f91-7ba1-e722def24b67@kernel.dk>
References: <ac36babd-3eb7-8f91-7ba1-e722def24b67@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ac36babd-3eb7-8f91-7ba1-e722def24b67@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-01
X-PR-Tracked-Commit-Id: ce593a6c480a22acba08795be313c0c6d49dd35d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c93493b7cd40c20708e3373a7cc8e8049460d7ce
Message-Id: <159372900951.6563.11460097877938436278.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Jul 2020 22:30:09 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Wed, 1 Jul 2020 22:30:24 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-01

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c93493b7cd40c20708e3373a7cc8e8049460d7ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
