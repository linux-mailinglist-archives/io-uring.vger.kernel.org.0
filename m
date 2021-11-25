Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243B145E0E3
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356616AbhKYTRT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 14:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhKYTPT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 25 Nov 2021 14:15:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F3A361027;
        Thu, 25 Nov 2021 19:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637867527;
        bh=sWI9QACVGWTRzvgct3YUQ+O1gnR4SjXRPQHNZzQxsZY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dlregnA2tp33WY3XUDHcLGWsfFefHQabvuYMvxGRs8bVCEdFKhXLjUpIGtOf43W1A
         exptpMotAiLiWD4754/UtQNJYxxOe95o1fjzo/X0xqhUx7BQMgO/KsyTkN6IApmy3p
         yer9EU/FuXfW8WO8+ANWsOAR75fAYkEEUw30sRCl4x9k76iaUsMN4RcmZoLXxzWL8l
         38ZNTprShPLp6ZynGuin/5HLFdUgy79p1ImuX+dbYU5YaWcCMQYvZJ3/VJxG9us37M
         ICeR2Dulg6XF3XkWWdko/mMF7WKfXi1/hr9/953uG02mP7TeQdS8vS47kw3QalSn4I
         4lnKNPDJgOZKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A2CE60A0A;
        Thu, 25 Nov 2021 19:12:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.16-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e3595b67-d7f5-895f-4cbf-0a6b1456e39d@kernel.dk>
References: <e3595b67-d7f5-895f-4cbf-0a6b1456e39d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e3595b67-d7f5-895f-4cbf-0a6b1456e39d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-25
X-PR-Tracked-Commit-Id: 674ee8e1b4a41d2fdffc885c55350c3fbb38c22a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: de4444f5964933225b365a503db9a595b6588616
Message-Id: <163786752762.29201.13037842753557391042.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Nov 2021 19:12:07 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 25 Nov 2021 09:42:29 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/de4444f5964933225b365a503db9a595b6588616

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
