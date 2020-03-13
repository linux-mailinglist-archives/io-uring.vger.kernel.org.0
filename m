Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB3A185042
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 21:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgCMUZK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 16:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbgCMUZI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Mar 2020 16:25:08 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584131107;
        bh=yw2xbkqTbrFUdbnm/fDG8SBpZza2OmlmA1/XmJJpIv0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=wcNCMZsdPSu5tV2HKBuPc2S+SPPenkepOO6HiWg02cK4yuCwUNLHNi323nJGzIVHS
         +AUbXJCXyIjuU4AVk5YXrlSZ6LCFWYmtjwaUbjHcIjQ+swMYVmslFf6Ylg8xEu3PN+
         9tY4KLRRFJJqommByyW3cDwPbi8BnKcjcOaWcCYw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
References: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.6-2020-03-13
X-PR-Tracked-Commit-Id: 805b13adde3964c78cba125a15527e88c19f87b3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5007928eaeb7681501e94ac7516f6c6200f993fa
Message-Id: <158413110762.9951.1156650354512528767.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Mar 2020 20:25:07 +0000
To:     Jens Axboe <axboe@fb.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 13 Mar 2020 11:50:42 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-03-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5007928eaeb7681501e94ac7516f6c6200f993fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
