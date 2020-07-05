Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CFE214E56
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 20:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgGESAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 14:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgGESAG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 5 Jul 2020 14:00:06 -0400
Subject: Re: [GIT PULL] io_uring fix for 5.8-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593972005;
        bh=+f2ClKeAxNLL30fnpJlYH1C7gmp4MaqQYvMKQCk+eIM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bH9sxW8/IqXlVVH3ko0DfwRD/MZJxny//rQz51cq5B5KjHg82LywG3vXPwiyQkFTf
         E477MQPD6nxkRL2qvLLWyEe3G///Y1Ofcglz1GuRFqYQWN8ZIiCFkfiWbD99sHIt87
         LRrKNWCxYouMnIbqItJfLWfAfOJORbF+eVD84jDY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <39012c6d-b53c-703f-218d-9d8fddd9871f@kernel.dk>
References: <39012c6d-b53c-703f-218d-9d8fddd9871f@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <39012c6d-b53c-703f-218d-9d8fddd9871f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-05
X-PR-Tracked-Commit-Id: b7db41c9e03b5189bc94993bd50e4506ac9e34c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9fbe565cb78d10ca2619ee23eac27262cff45629
Message-Id: <159397200568.8921.461305026355393362.pr-tracker-bot@kernel.org>
Date:   Sun, 05 Jul 2020 18:00:05 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 5 Jul 2020 07:05:49 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-05

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9fbe565cb78d10ca2619ee23eac27262cff45629

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
