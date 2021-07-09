Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5403C297A
	for <lists+io-uring@lfdr.de>; Fri,  9 Jul 2021 21:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhGITXQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jul 2021 15:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGITXQ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 9 Jul 2021 15:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A077613C5;
        Fri,  9 Jul 2021 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625858432;
        bh=opNFjLLo+fYeFf7m8ZRALpNWIFbeGgwYgnItF9afL3o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Uvswj29dbT//DKbjzvx8bC99bfCazHFv04HmZFlN/pkkGVXEaPcLV9tThs7xSjC3H
         HlFFeevJD4iitBjGFQomNOyMXUd7oQReVt1u8ZMnDP+/W+95JL7YWmKTzG+O9gfXVU
         tfDxZgON4M0vYgSwjB7/loJqTIh2R9UAPmvL36s+jIx1Joww+vfvYjwaqVzRIQKEbL
         JxJPMCELzHGPGTBgdxztMhpDqKot/3d7q87Q3QKk4X2oRtG+p9/8RZ8eue5Xs3ytxQ
         eg2l9ZB+qhgn0FJBm4aujJbmB0VDN3Gk9yvFpjhf7RP9D8jGxHRiNdTLGkD+qQibgA
         GUDaWpjmhg8vw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AA5A609AD;
        Fri,  9 Jul 2021 19:20:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <118a849b-d742-ff20-9815-6c226b8518e7@kernel.dk>
References: <118a849b-d742-ff20-9815-6c226b8518e7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <118a849b-d742-ff20-9815-6c226b8518e7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-09
X-PR-Tracked-Commit-Id: 9ce85ef2cb5c738754837a6937e120694cde33c9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50be9417e23af5a8ac860d998e1e3f06b8fd79d7
Message-Id: <162585843218.13664.5811580817538487178.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Jul 2021 19:20:32 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 9 Jul 2021 10:57:30 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50be9417e23af5a8ac860d998e1e3f06b8fd79d7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
