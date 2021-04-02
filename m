Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B335316F
	for <lists+io-uring@lfdr.de>; Sat,  3 Apr 2021 01:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhDBXS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 19:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235256AbhDBXSz (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 2 Apr 2021 19:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EA0D61178;
        Fri,  2 Apr 2021 23:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617405528;
        bh=KgBVMuLZ2abXCWjCG82d0MYYuImRq+k/pk+RhmvYzRY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=u1e7m8ap3L6g6Nu5dPvs1+Jk+u2pt2QgPZL80MwAvv9CW/+MsHyfGhnYWU8FxdLOP
         +/PnX0JMuYQt4NHneAmI3RmOU60wZALg4nceP6MNugnN3447PluUJQdk9WHuc2ka5h
         D819sYsRUYeCDv7ORPwQiFiN6HXOmH8hgi75n8bLBW7tJdaIozF/OSOPxlDkoyLMeO
         ZSUPXufpxq6A6ssQzQjUMFQE2be1aJrm5doxoRPUycAJYlSnH50oy/wOABq7OHZW/X
         AY/9SHOx4L5hizHbR0rPpI6LuVbdiW88QqqfTyllYQtwEV1gjXtyaAGJUNXTdF10QA
         EARa05NyGhMfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09B7C609CC;
        Fri,  2 Apr 2021 23:18:48 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <3c05aa2a-3f31-4039-caac-b6c07ddd290a@kernel.dk>
References: <3c05aa2a-3f31-4039-caac-b6c07ddd290a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <3c05aa2a-3f31-4039-caac-b6c07ddd290a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-02
X-PR-Tracked-Commit-Id: 230d50d448acb6639991440913299e50cacf1daf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1faccb63949988e4cfdfba2e9d2c3476c6d690e5
Message-Id: <161740552803.12783.12627995377280810272.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Apr 2021 23:18:48 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 2 Apr 2021 15:15:54 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1faccb63949988e4cfdfba2e9d2c3476c6d690e5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
