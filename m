Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32192C6CE9
	for <lists+io-uring@lfdr.de>; Fri, 27 Nov 2020 22:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbgK0VdC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Nov 2020 16:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbgK0VWC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 27 Nov 2020 16:22:02 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606512119;
        bh=OaPqdQKFA63Y1EoUjPvmm2gKTAfLJWRu8cCh4z12ik4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Vms88IxKKDTOPW7FFgc3AlPLv/JFzSeYtgMMZLdp/zi3ch/X4zus6LfZplLqAqIhM
         i7oE5hAD5JnZCiKNMNFuyyQ8Ekqbrr46gQB24aMg5c38dtyVoh70ie7tC6P3uzdId2
         rbDvOlAkpcN8jYnmsfhFbcwwiWGV2bpRT90p6Bl0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <f4f5ae6e-8442-74de-73a1-71bc56e62fd8@kernel.dk>
References: <f4f5ae6e-8442-74de-73a1-71bc56e62fd8@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f4f5ae6e-8442-74de-73a1-71bc56e62fd8@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-27
X-PR-Tracked-Commit-Id: af60470347de6ac2b9f0cc3703975a543a3de075
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9223e74f9960778bd3edd39e15edd5532708b7fb
Message-Id: <160651211964.4351.9878234550083051800.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Nov 2020 21:21:59 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 27 Nov 2020 13:47:10 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9223e74f9960778bd3edd39e15edd5532708b7fb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
