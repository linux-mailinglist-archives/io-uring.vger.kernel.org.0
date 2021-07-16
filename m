Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A533CBCBE
	for <lists+io-uring@lfdr.de>; Fri, 16 Jul 2021 21:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhGPTl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jul 2021 15:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhGPTl1 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 16 Jul 2021 15:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B2B8C613EB;
        Fri, 16 Jul 2021 19:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626464312;
        bh=581m2/xdtWzQfht6IsIZuBswr0SLgrnaApQtzsbTewg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=vKZ1J1m8LFAdhY3EDkDP1Agsfr+I2cGXRrxKCgbbFJyQVf+PgzQSMZELT/WIJpv2p
         w2pdl5apj0LuyZbcruq+v7T6KfOVcnB+TR828daQdvBAtR5t8hOKm+zFZ97EVguZ3x
         wDqumtvqEMkHXVFdyTO4vlHtGHhI08z1yKftGMy6JRrfF131tpkeDWZXitumRoxmln
         FUMIXJZC8MiCsU+bWq/iAcFvH3kdabtvlunJ4lk8tQUO1L+N2OoCbX7nXQBWfT6XjN
         4q8n6hQKaVb8nRH+dbAzwXZVE4w7x7JsWGqZ6qQaTc+k0BsVgxzdWPxptWYHNuRPjk
         QHRND3Vm4BfoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC6CA60963;
        Fri, 16 Jul 2021 19:38:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a74e6303-202e-20b5-2e0d-5cea2f33f95a@kernel.dk>
References: <a74e6303-202e-20b5-2e0d-5cea2f33f95a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a74e6303-202e-20b5-2e0d-5cea2f33f95a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-16
X-PR-Tracked-Commit-Id: 1b48773f9fd09f311d1166ce1dd50652ebe05218
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13fdaf041067a7827b8c3cae095b661aabbc6b65
Message-Id: <162646431269.9691.10870843594165634153.pr-tracker-bot@kernel.org>
Date:   Fri, 16 Jul 2021 19:38:32 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 16 Jul 2021 08:22:13 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13fdaf041067a7827b8c3cae095b661aabbc6b65

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
