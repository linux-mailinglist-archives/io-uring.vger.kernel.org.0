Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8F964BCA1
	for <lists+io-uring@lfdr.de>; Tue, 13 Dec 2022 20:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbiLMTD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Dec 2022 14:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbiLMTDJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Dec 2022 14:03:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692163F7
        for <io-uring@vger.kernel.org>; Tue, 13 Dec 2022 11:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 032A3B815AE
        for <io-uring@vger.kernel.org>; Tue, 13 Dec 2022 19:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1A03C433EF;
        Tue, 13 Dec 2022 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670958173;
        bh=JHYQsm952xs6CVLmvFg7g3UEOwJaceTl27toMW8Kip4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ON/dsD4qR63WzlPyGyrZf5ZX45FqKxPF0Tfd+uvjDU3kGA+BxDKzUaDwBqaGdK+sm
         UtCalLpb+XW6DChSi8t0jaShYzCem0Q5As478NH3Ee6zfMXhmCRc5GPla+6BwSO53u
         QqmHASp1vZtW3FF8KFoNHg2FQP0GgjUmPjJdvyXiUS4miigsiGdtkNjLGVEV+rIEy4
         HmmZt6765dOAL9l2lbl8KgYLFW79dXPyGCox1ry24rOVPaY2WODzXgeOwHPjJn5nAf
         3Oil4luAe3hDlMfd8fNR3hD4rDfqYJZHVieaSMnfvocY+6fjnfpwhxv7/PkVrzsKMZ
         AdCtJ75mVha7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0DDEC00445;
        Tue, 13 Dec 2022 19:02:53 +0000 (UTC)
Subject: Re: [GIT PULL] First round io_uring updates for 6.2-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a4a56cca-be7c-84de-40f7-69cdd1e96a1d@kernel.dk>
References: <a4a56cca-be7c-84de-40f7-69cdd1e96a1d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a4a56cca-be7c-84de-40f7-69cdd1e96a1d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.2/io_uring-2022-12-08
X-PR-Tracked-Commit-Id: 5d772916855f593672de55c437925daccc8ecd73
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b2cf789f6cb6d449f2b457ee3fb055b7f431481f
Message-Id: <167095817371.20557.16316227971305721192.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Dec 2022 19:02:53 +0000
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

The pull request you sent on Sat, 10 Dec 2022 08:35:55 -0700:

> git://git.kernel.dk/linux.git tags/for-6.2/io_uring-2022-12-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b2cf789f6cb6d449f2b457ee3fb055b7f431481f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
