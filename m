Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC465799669
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 07:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbjIIFGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Sep 2023 01:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241261AbjIIFGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Sep 2023 01:06:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799501FDB
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 22:05:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AB14C433C8;
        Sat,  9 Sep 2023 05:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694235958;
        bh=CBe9MiMeJy4YR9pXRDP6usynnoswrvGH56MjLQJHzMs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fOB2d4qfeiSWShndUjt1KalkKl7JRTKsEggeOyk/7GwPX2GX6wrDpUNP3qmuZ9TVQ
         6v1X/uZWQOpYx6OJFfbrhmtsTxdu8VG2Mt43f5UiBAX/d6kA7MaUXsr7IqFbVdBPso
         ApopIxuoJaud9cbu84SlHPUL8+DeAt6VOu4RdE9wWp+Vledrsu1/SET01BW/dseDZZ
         rtlVW9b6xl329olBhiv0u6RvrEN61BjUTnLwmXqnZgmUMvFa/MWQEHUXo7MJLbHrfY
         3DsH5OOzh7UkkvSGm/FuHFh+wqvcpw7nB0m8Z+6m0xW7Qq6FbhEnX8LfY5TbJ3LNxd
         WVv3hTh2+ohIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AD69E505B7;
        Sat,  9 Sep 2023 05:05:58 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.6-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7828a377-ed0c-4d22-8e36-8cf2eaa4f4b8@kernel.dk>
References: <7828a377-ed0c-4d22-8e36-8cf2eaa4f4b8@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7828a377-ed0c-4d22-8e36-8cf2eaa4f4b8@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-08
X-PR-Tracked-Commit-Id: 023464fe33a53d7e3fa0a1967a2adcb17e5e40e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ccc3ebf0c575728bff2d3cb4719ccd84aa186ab
Message-Id: <169423595804.31372.10578451168264685190.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Sep 2023 05:05:58 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 8 Sep 2023 09:02:25 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ccc3ebf0c575728bff2d3cb4719ccd84aa186ab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
