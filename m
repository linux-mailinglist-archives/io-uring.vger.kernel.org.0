Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891D8676A76
	for <lists+io-uring@lfdr.de>; Sun, 22 Jan 2023 01:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjAVAfa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Jan 2023 19:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAVAf3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Jan 2023 19:35:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B861B1F487
        for <io-uring@vger.kernel.org>; Sat, 21 Jan 2023 16:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4B81B80885
        for <io-uring@vger.kernel.org>; Sun, 22 Jan 2023 00:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81195C433D2;
        Sun, 22 Jan 2023 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674347725;
        bh=agpueb82/V/9VqxsUYVN+Rkcl8yBDCfUi1KdS2L14Lk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SpSlcNJ5Z1XzjIlepqR1Qcv2n2dde5xpKKf+mfkIAi6hkfoZM1IEtI80pv4cH6+9Q
         drBWcOjjdiSoBNKrL541GP561TJWD0rpFXe7kgONSGW89HjX1VtHM1rPh45Soj5Z8U
         JF5Yeo1FMaZdyZqFHTPFtwxL9N5INX4P9ChmT1hv5OtaPrtbE6U85pfcdbjWu6Qz1f
         Y/i7H86eD1S1thPQO4ujUa7G9fDtv1WRylqXylcHA2cnJ9ez0tZnk5cBsMUrKBbX04
         4vXPSmL255C1vw/CrpWGmzYkysbo0MmN73ulyHrGlAZB0Wq5I/vsni2FS5LvPFULCA
         T/Rozl14Ot/Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67841C4167B;
        Sun, 22 Jan 2023 00:35:25 +0000 (UTC)
Subject: Re: [GIT PULL] Followup pull request for io_uring for 6.2-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <116e2c78-4fe8-928c-636d-b514ce1299e3@kernel.dk>
References: <116e2c78-4fe8-928c-636d-b514ce1299e3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <116e2c78-4fe8-928c-636d-b514ce1299e3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-21
X-PR-Tracked-Commit-Id: 8caa03f10bf92cb8657408a6ece6a8a73f96ce13
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95f184d0e1e14e6fd4368a804db5f870e5f841d2
Message-Id: <167434772538.4715.14633542728800312572.pr-tracker-bot@kernel.org>
Date:   Sun, 22 Jan 2023 00:35:25 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 21 Jan 2023 13:56:42 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95f184d0e1e14e6fd4368a804db5f870e5f841d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
