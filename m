Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92D23E369C
	for <lists+io-uring@lfdr.de>; Sat,  7 Aug 2021 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhHGSWM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 14:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229919AbhHGSWL (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 7 Aug 2021 14:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B8F961057;
        Sat,  7 Aug 2021 18:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628360513;
        bh=0DsxnxPGvAJrJ4fdoSaK/VWJy99qy3WColH3lkxSaxA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=X64HZnsDneLNh023yh3StoN3+egsNH11v5J3zpY/r6EaSHI8cJNRqDn1sCNgrGRI/
         yFvH9/hTgVhHszdZxlJwfO+xDReRljYbvXqECtoddNpEN1tq1GytF/m5enwIPqzjkZ
         2DHigtaKDrzjpKQ3cwKCLnjS8XvawgrE7m8334IEuhlsNlfGKaZT+WMfCzNuymDYRc
         y5bMpSopuvZ2tQd9D2Woz04qDquNFnWYnBPgzgfRZnUdqhslCh+7Mtc/zfH/PphQFS
         h8aBQQ75cS1Bn0Ql/jWqev8Vg05FPDtOlRTi2J7kgF8ecsgNruLNBljDMyXxIzQW+q
         e/KciFYRoZ/eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8629E60A38;
        Sat,  7 Aug 2021 18:21:53 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <5559f44d-e2b7-cb98-8007-aec9d3075645@kernel.dk>
References: <5559f44d-e2b7-cb98-8007-aec9d3075645@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5559f44d-e2b7-cb98-8007-aec9d3075645@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-07
X-PR-Tracked-Commit-Id: 21698274da5b6fc724b005bc7ec3e6b9fbcfaa06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 85a90500f9a1717c4e142ce92e6c1cb1a339ec78
Message-Id: <162836051354.5679.660838337774735788.pr-tracker-bot@kernel.org>
Date:   Sat, 07 Aug 2021 18:21:53 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 7 Aug 2021 10:51:30 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/85a90500f9a1717c4e142ce92e6c1cb1a339ec78

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
