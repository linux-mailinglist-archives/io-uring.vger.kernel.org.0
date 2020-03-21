Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B618E3E1
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2020 20:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbgCUTPH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Mar 2020 15:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbgCUTPG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 21 Mar 2020 15:15:06 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584818106;
        bh=IO2i0/00/xFwOWpckKq9Z7PxZLEcx28qFa/jIX2OlKc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=oXUWLzGSwIA8ZOMZnHdKcuvmxQGuKQRI4cuANRw5MrNQG7u4owjoFWMy132Pb+hso
         cTtq7P31PB4+klA+2hSDIyvudCb9PDGYcZXrVf3LzYsOyFL62T/hvOaLMc7Eq7z0UD
         amtWlLhaYuKagPrShLwfzA+Fq5i2OXA8W27B5c8I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <51feabdd-c2e2-e24f-92af-edf4b2b0f54d@kernel.dk>
References: <51feabdd-c2e2-e24f-92af-edf4b2b0f54d@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <51feabdd-c2e2-e24f-92af-edf4b2b0f54d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.6-20200320
X-PR-Tracked-Commit-Id: 09952e3e7826119ddd4357c453d54bcc7ef25156
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1ab7ea1f83d16489142bcfa1b7670ac7ca86cd81
Message-Id: <158481810637.2095.13875868456940201136.pr-tracker-bot@kernel.org>
Date:   Sat, 21 Mar 2020 19:15:06 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 21 Mar 2020 12:38:34 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.6-20200320

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1ab7ea1f83d16489142bcfa1b7670ac7ca86cd81

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
