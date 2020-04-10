Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67C11A48ED
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDJRa1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Apr 2020 13:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJRa0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 10 Apr 2020 13:30:26 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586539827;
        bh=sYlrR5tKskk3z6owago8EJjKBm6gIfyuH4y7PAxq+Ao=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nos2edcItdVeB+QYawdZ4mMsVL7l9HBa3p5AvhaMugYTfTlgC/zriYLJLcDmqCiCb
         rROldR7MvhBsLPd958GMQLZftWXnj5omcqDWv0+QZ9z3zMjJtkhyb0LCfD9cR9wbQ2
         J0P4eBYeQxTVG8878c0CNzC9WSYpMxyEUgNXrzEE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9739a06d-728e-1d6b-d511-ad4eefdd19b5@kernel.dk>
References: <9739a06d-728e-1d6b-d511-ad4eefdd19b5@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <9739a06d-728e-1d6b-d511-ad4eefdd19b5@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 io_uring-5.7-2020-04-09
X-PR-Tracked-Commit-Id: 85faa7b8346ebef0606d2d0df6d3f8c76acb3654
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 172edde9604941f61d75bb3b4f88068204f8c086
Message-Id: <158653982704.6431.2505342524339908158.pr-tracker-bot@kernel.org>
Date:   Fri, 10 Apr 2020 17:30:27 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 9 Apr 2020 18:07:06 -0700:

> git://git.kernel.dk/linux-block.git io_uring-5.7-2020-04-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/172edde9604941f61d75bb3b4f88068204f8c086

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
