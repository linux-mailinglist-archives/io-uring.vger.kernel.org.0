Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0384D301EBF
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 21:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbhAXUe3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 15:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbhAXUe2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 24 Jan 2021 15:34:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1D5AB22571;
        Sun, 24 Jan 2021 20:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611520428;
        bh=rwo5Ks1XoSD/UmSyanScwL9ayaC2RlqF/dAlpOhRMlw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mFr0SSz/utCeUYIe4SoyUBaSr8OkC0B3Y32cXipU8BbVkH8n7OUZR/ug/RQQcPYw9
         GaZSzSu1Ddhb1OpMmDmWwpGIjT1MPBQnZkg+XUERubRhJXsGoUULprsuN8+tJLShO0
         X/yyjY1sZ/WLkqewaLPslO+XusUL41+LvvfIuvqw2ZD8qIKAyu7UPPAkbkAFbTmtmT
         V/jDm9FhAOmaqw8ZVL3NPCuwxLFeciNW0aS796gz+T75dlhXIBKep8pg1Og4ubjy63
         m7JeJ4Kke8pmnZ4Ad6zc1FTvrB81lq/dLATc1HJlRDm0fxV/sH/eLXO6oI4axI0wda
         FVKDlUwzvZ/eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 030BF652E1;
        Sun, 24 Jan 2021 20:33:47 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.11-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b0a878ef-29bf-100d-018b-7462535a5745@kernel.dk>
References: <b0a878ef-29bf-100d-018b-7462535a5745@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b0a878ef-29bf-100d-018b-7462535a5745@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-24
X-PR-Tracked-Commit-Id: 02a13674fa0e8dd326de8b9f4514b41b03d99003
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef7b1a0ea857af076ea64d131e95b59166ab6163
Message-Id: <161152042792.12946.16510021397583085998.pr-tracker-bot@kernel.org>
Date:   Sun, 24 Jan 2021 20:33:47 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 24 Jan 2021 11:52:43 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef7b1a0ea857af076ea64d131e95b59166ab6163

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
