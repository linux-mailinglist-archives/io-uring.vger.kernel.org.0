Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC58C438198
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 05:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhJWDut (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 23:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhJWDus (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 22 Oct 2021 23:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EFE9060E95;
        Sat, 23 Oct 2021 03:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634960910;
        bh=tu8jpUsvRKRAq3iH8ogGIyoRXXBMuGdE/nOskv5tRhU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mFl7kWXr/4A2a8ef6I1vfKndOXC5sLnMMMhEKVuKrjYQc6ETpjORKNOoW4dFhkIzL
         SnJSnLkCabllJxvF98PLZr6TRDynoXmKsuYCLAzzYEtwLAHQKVwdZiCtzxBlnHc5km
         1aOmHWnnWXofnAQcOCnvVTH5a85F0Mxe88W4daZm9pFm0VG0avgBaLD9xOV2wKNT+J
         VDFPNPlhKq1j/cR7MM/z29OQLsUr0OGxVIIDTVHjx5x1KN1LO9u+oEZguXHEPwAyj8
         Hlu7FyD36awA9PVMiYXGRU03H5rDZatYbojhFPIA4G2rRb3IAZKHSHWUud4WWV/zAm
         p7xz0lnC9bQoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA90B609D9;
        Sat, 23 Oct 2021 03:48:29 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <722f22d3-11b0-454c-ec89-e684d13d269d@kernel.dk>
References: <722f22d3-11b0-454c-ec89-e684d13d269d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <722f22d3-11b0-454c-ec89-e684d13d269d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-22
X-PR-Tracked-Commit-Id: b22fa62a35d7f2029d757a518d78041822b7c7c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: da4d34b669723508601a4c29daa22cdc669ee005
Message-Id: <163496090983.3380.9694566056482247075.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Oct 2021 03:48:29 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 22 Oct 2021 21:25:55 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/da4d34b669723508601a4c29daa22cdc669ee005

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
