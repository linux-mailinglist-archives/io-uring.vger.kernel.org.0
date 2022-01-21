Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF14960B6
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 15:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381064AbiAUO1a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 09:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381097AbiAUO1X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jan 2022 09:27:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E49C061768
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 06:27:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 593D4CE23A9
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 14:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3F60C340E1;
        Fri, 21 Jan 2022 14:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642775235;
        bh=ZTAofQ8nr/rC8lTjLAj6rZiTFxC60HWuL/3P3a9eLMo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=B0HhhV7queaxp99Sww9iRFdjjA2kpaEimJfuKl5uIB59++7bouQw8dPEoGqJzrq8C
         7jvnV25vHRsnG8qLRWIYkmfWLO0krv9uEMXZE4LLfg0e4lwZ9CNMSxuk+rOZ6snAQJ
         vss0kMW2gOBNHRyRNf5VvNzCZRGe7c4Amkt5FFyhYib6xW7OaLaUBTxy7iVSTaKIci
         5LBDkEtIZH3CDDfAvu/JpU1KeKFc6pUmcmLj/J3sfx/Q5HyKZIrQghN6YpR5RVHePU
         JJg0cqMJxJwDnNBBqLyI8M6jm/ebIZ2paNKprFahF+iyffjXU8CFxqqoZBBG2lZrEp
         4CeLgXFxcSm4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92884F60795;
        Fri, 21 Jan 2022 14:27:15 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.17-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <8d84c26c-cee8-64c7-1b86-16638a68e977@kernel.dk>
References: <8d84c26c-cee8-64c7-1b86-16638a68e977@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8d84c26c-cee8-64c7-1b86-16638a68e977@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-01-21
X-PR-Tracked-Commit-Id: 73031f761cb7c2397d73957d14d041c31fe58c34
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f3a78227eef20c0ba13bbf9401f0a340bca3ad16
Message-Id: <164277523558.13796.2562021968040015798.pr-tracker-bot@kernel.org>
Date:   Fri, 21 Jan 2022 14:27:15 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 21 Jan 2022 06:40:56 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-01-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f3a78227eef20c0ba13bbf9401f0a340bca3ad16

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
