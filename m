Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E4256387
	for <lists+io-uring@lfdr.de>; Sat, 29 Aug 2020 01:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgH1XkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Aug 2020 19:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbgH1XkH (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 28 Aug 2020 19:40:07 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.9-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598658007;
        bh=50sguD7rtX5oLh4iB1xcVdOM30H+NSDOVPOM3b/GmOw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fGeH7q3qzhd+DNvs4+TXOl9AcUexIQu3vqZNwm2DxsxH2Mt00tzQal0qg8IQueSF7
         PSvqEw3Fsda1VuVoQWh5QZqAQuXA+YR51a7ee9yWPflkegoQtPeURnNAd+2jsjArN7
         0dYnE+tclxbtIuSyH88ocmRuCMgziEAfG7k96wFY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <654bd4f0-7d2b-a39c-46ab-e7d180246bdd@kernel.dk>
References: <654bd4f0-7d2b-a39c-46ab-e7d180246bdd@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <654bd4f0-7d2b-a39c-46ab-e7d180246bdd@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-08-28
X-PR-Tracked-Commit-Id: fdee946d0925f971f167d2606984426763355e4f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 24148d8648e37f8c15bedddfa50d14a31a0582c5
Message-Id: <159865800738.1894.11850755109467704404.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Aug 2020 23:40:07 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 28 Aug 2020 14:03:22 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-08-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/24148d8648e37f8c15bedddfa50d14a31a0582c5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
