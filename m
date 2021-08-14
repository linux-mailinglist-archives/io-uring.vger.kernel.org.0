Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56AF3EBF41
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 03:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhHNBMv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 21:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236119AbhHNBMv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Aug 2021 21:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 90C366109D;
        Sat, 14 Aug 2021 01:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628903543;
        bh=oJaHjewK/VhKAF3/9hG7MqWWj4nhRAZBLyagcP8nHnw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=O+7zwg1bamSC8BNA+HaShh1W2Lz66B8CiTJWx3aCu0z3b2prK3xVdT1/lMDLb63ZH
         ezdLXQrH55H1WHAuA+5coSn2TJw37BKGz19ym2WCAtRAhl7zgNX55IWsVUi8sunEeP
         Hx4s21QnKWGlbWLcxbGtbn332VnpeHRRRuvThlIcrnUxLW5l+0/GVWb4sOmaKDKU/0
         6RaZcytsKYto3OLYyJOqwedDhRGD+ruM0jetyGtRP/8FS0nrv8qcXpJQ4jSRs6GZtz
         lw9IrK+nwnehzRGUX247QiAyM6l9ZyC7WegJfIWJjDF6e8T3Vfy8zzAUTMi4R+tK49
         ZToQlRqPyB3Yw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7CB7D609AF;
        Sat, 14 Aug 2021 01:12:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.14-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9eecad5d-8432-d9c3-770f-b4ae7aac13ec@kernel.dk>
References: <9eecad5d-8432-d9c3-770f-b4ae7aac13ec@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9eecad5d-8432-d9c3-770f-b4ae7aac13ec@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-13
X-PR-Tracked-Commit-Id: 8f40d0370795313b6f1b1782035919cfc76b159f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 42995cee61f842c4e275e4902459f8a951fe4607
Message-Id: <162890354344.25277.17545724858125935500.pr-tracker-bot@kernel.org>
Date:   Sat, 14 Aug 2021 01:12:23 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 13 Aug 2021 13:02:29 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/42995cee61f842c4e275e4902459f8a951fe4607

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
