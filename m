Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6668233768
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgG3RKF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 13:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgG3RKE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 30 Jul 2020 13:10:04 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.8-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596129004;
        bh=gvE5h8zht06L+i1mq4DL8H+us7Brwv5uOG4eCZFu1Ts=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1UaBTERbDtbqxEWmHHLB2ziQMcoZjBpGINVyPl7X8OCgjpdG1YaMFnGWBNKudn+DA
         3qwZ/BrHy5VTxUHDDrAD876dcTwK57umhU0zMSwWdQrm3+wlKe1IDRioltS1Mu9obs
         wGmQxBLKMRPHfwb+QWscKfB4nIuZi+vaPEV6oFsg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c3965487-1654-17e8-0d7e-9e8078d5dd6e@kernel.dk>
References: <c3965487-1654-17e8-0d7e-9e8078d5dd6e@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <c3965487-1654-17e8-0d7e-9e8078d5dd6e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-30
X-PR-Tracked-Commit-Id: 4ae6dbd683860b9edc254ea8acf5e04b5ae242e5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0513b9d75c07cbcdfda3778b636d3d131d679eb1
Message-Id: <159612900434.480.3513588991201494064.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Jul 2020 17:10:04 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 30 Jul 2020 09:19:01 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0513b9d75c07cbcdfda3778b636d3d131d679eb1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
