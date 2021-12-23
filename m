Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D13047E9B1
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhLWXqW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:46:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244950AbhLWXqV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:46:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81207B82245
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 23:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C25AC36AE9;
        Thu, 23 Dec 2021 23:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640303179;
        bh=E1pvOeZl0anE92bcLv4UWBoh9K46NM8vrFO6bYLoF8E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=beCvFJGq1p+VC+U83W0pkM4SJC3OzHbIlQJEyKuWN2rHfsj4Rpr8SSRcKv7FrD0Ai
         j5gA4OCWVu73pDDneti67P88juBqjLLA1L33TQr2umy+OfjdnbU+B5vd+yvwlkTyx8
         BzFsx6H+yWXMjER8D3BqDys1yeMj7Qn9m7kaO9SsZgn5Xfnz3GXG/Iwnz+4HR55eKK
         1NqGICpdDhV1cSxLIOiMG5bURtki7xbFMicFbXNQxX80Rug1QqrURb/4iBv26/KQPd
         U+N8Gn3aTOlOo5VjgSvQWucqDY5TEnYwl10Oqi5WsIjYlV0CnK7Pqub8AOOBaVMVIa
         IHDg0qcTjWlcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 387EDEAC06D;
        Thu, 23 Dec 2021 23:46:19 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
References: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-23
X-PR-Tracked-Commit-Id: 7b9762a5e8837b92a027d58d396a9d27f6440c36
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a026fa5404316787c2104bec3f8ff506acf85b98
Message-Id: <164030317922.13743.9991321770049601430.pr-tracker-bot@kernel.org>
Date:   Thu, 23 Dec 2021 23:46:19 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 23 Dec 2021 14:11:26 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a026fa5404316787c2104bec3f8ff506acf85b98

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
