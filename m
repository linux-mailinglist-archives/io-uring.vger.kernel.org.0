Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8A2A10B3
	for <lists+io-uring@lfdr.de>; Fri, 30 Oct 2020 23:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgJ3WKy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 18:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgJ3WKy (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 30 Oct 2020 18:10:54 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604095854;
        bh=7eoPqVn9ky43cERCPXoP59JYbhQ9ePlxXz+pTiO6nzg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=BLIpuEkkayD5NUq323bdA6RrApKfutPwhiygh7gHCW8wz4UnJaFknxb0Cwlq8nAwb
         pBh2G8LLVPpJtKXHijDXpdl1HIUwCVvxgA/CyD1Yf942oG6VdsAT3Geskw2N+9yV2y
         xzLD123VZAt42y4/xU0GYS0N0k97wB70l2EjbAp0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <394acda8-6cce-3cc9-5b5e-6b6f13851ef6@kernel.dk>
References: <394acda8-6cce-3cc9-5b5e-6b6f13851ef6@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <394acda8-6cce-3cc9-5b5e-6b6f13851ef6@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-30
X-PR-Tracked-Commit-Id: c8b5e2600a2cfa1cdfbecf151afd67aee227381d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cf9446cc8e6d85355642209538dde619f53770dc
Message-Id: <160409585409.7779.10897843910551282266.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Oct 2020 22:10:54 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 30 Oct 2020 11:09:13 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cf9446cc8e6d85355642209538dde619f53770dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
