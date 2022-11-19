Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34D16308BF
	for <lists+io-uring@lfdr.de>; Sat, 19 Nov 2022 02:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiKSBvB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 20:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKSBuo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 20:50:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A34BF58A
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 17:24:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E276B825BB
        for <io-uring@vger.kernel.org>; Sat, 19 Nov 2022 01:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 380B4C433C1;
        Sat, 19 Nov 2022 01:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668821090;
        bh=cb7l3N1xzVLXd6UmqJxyYjETIPBBt+zpzp0gb5H+NGA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rIYL22KCIN0faFnjweKvpU8bXvMQ9WnvbD101MR05AKalpjnEYymS5X3uZc1auXaf
         /rboOb5W9zyZ2bF+I9uaCxden/ZDHgkiCbi57+re1DtI+foGkr2cv4LB2jof/Rwazv
         lJXS4Ig0tvI4x2oj94VZr70CTM8b4fUkyO9YX7K245eW0Tq5WUm0QCg7onsvrtxxuC
         KrINkru3SvS9GvTSO9UxD+O9pduFQVdwaE9owUSMgv5DgpBpMHUo1xaFQDl33FsHms
         MWuQqBmdK/MZMxGeUssrTRMDpTLY3dh9PLngUGYJWlCBZZs3s3N/X5eTjr/C98kHRh
         eK/LyCi2JxNrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 256FFC395F3;
        Sat, 19 Nov 2022 01:24:50 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.1-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <8858bc05-6020-09e9-d17a-28655c738c78@kernel.dk>
References: <8858bc05-6020-09e9-d17a-28655c738c78@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8858bc05-6020-09e9-d17a-28655c738c78@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-18
X-PR-Tracked-Commit-Id: 7fdbc5f014c3f71bc44673a2d6c5bb2d12d45f25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a66e4cbf7a29fe555ebb995b130b2e059fc26d89
Message-Id: <166882109014.16429.10985285841508337419.pr-tracker-bot@kernel.org>
Date:   Sat, 19 Nov 2022 01:24:50 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 18 Nov 2022 15:43:24 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a66e4cbf7a29fe555ebb995b130b2e059fc26d89

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
