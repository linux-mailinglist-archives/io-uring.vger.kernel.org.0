Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501932242AD
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 20:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgGQSAE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 14:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgGQSAE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 17 Jul 2020 14:00:04 -0400
Subject: Re: [GIT PULL] io_uring fix for 5.8-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595008804;
        bh=hFQRPNeiQBtHlsChHNzeNPovjoCrJjzEEQFq0x8axDg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=a/Qm3FOqlq24Bgw7fFfhkvS+jjtQP3JWZQjyDeDGXRN6wLIE6C1UDp3ZMkwocR6QE
         lJ1Nyd9AXqPNm6qswX1vN5mKqOEo1kUIKOGDq0g6CEN0RJPoaktIOM4VcNxbcdu9VC
         udnGzOS6LYjrs1FvUM1X3vhJnZw3BoIYU+4+K824=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7dd248d7-330a-cc1b-9ddc-bac57c3581d0@kernel.dk>
References: <7dd248d7-330a-cc1b-9ddc-bac57c3581d0@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <7dd248d7-330a-cc1b-9ddc-bac57c3581d0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-17
X-PR-Tracked-Commit-Id: 681fda8d27a66f7e65ff7f2d200d7635e64a8d05
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4ebf8d7649cd86c41c41bf48da4b7761da2d5009
Message-Id: <159500880426.6814.14905434280974348100.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Jul 2020 18:00:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 17 Jul 2020 09:52:13 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4ebf8d7649cd86c41c41bf48da4b7761da2d5009

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
