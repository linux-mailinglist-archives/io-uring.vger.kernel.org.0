Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1031DEFA6
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgEVTFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 15:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbgEVTFD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 22 May 2020 15:05:03 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590174303;
        bh=nctvkNR0q8oOHi3g8MVv7QBdrox+PkH3tC/gIkx0DzY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=UohL01btv8q15v4f47WoZNdIPaGR2YO6nzCokrdREUJ40sGWu30faGECnleiEg/Lu
         ROKDejoCDHI1vkDeYtzE+zNrwg6jOrcDox2wNphyrtIvPMluK9MQ+HQEhqVejdKXA8
         dh83dyrfhSrXrn91st2gbgXeNJBzn9jbpIQaEyBc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <89dab0b5-a43d-fd21-e22d-8d5d4c2ae510@kernel.dk>
References: <89dab0b5-a43d-fd21-e22d-8d5d4c2ae510@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <89dab0b5-a43d-fd21-e22d-8d5d4c2ae510@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.7-2020-05-22
X-PR-Tracked-Commit-Id: d4ae271dfaae2a5f41c015f2f20d62a1deeec734
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 444565650a5fe9c63ddf153e6198e31705dedeb2
Message-Id: <159017430346.18534.11150149570914168415.pr-tracker-bot@kernel.org>
Date:   Fri, 22 May 2020 19:05:03 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 22 May 2020 11:12:07 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/444565650a5fe9c63ddf153e6198e31705dedeb2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
