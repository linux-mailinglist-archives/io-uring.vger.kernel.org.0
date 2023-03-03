Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB8D6A9F6F
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 19:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjCCSpg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Mar 2023 13:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjCCSpe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Mar 2023 13:45:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6A060D5B
        for <io-uring@vger.kernel.org>; Fri,  3 Mar 2023 10:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0DAEB819F1
        for <io-uring@vger.kernel.org>; Fri,  3 Mar 2023 18:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1BF2C4339B;
        Fri,  3 Mar 2023 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677869086;
        bh=H/UNkJoQ1zvuRjdx+szhZhj2puZ06c04Wmscvx/Oz1s=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Kbm16jNS1WFPHG3ajeqnpDGluDqtbND5XrdkVFt2txpp1FQHfPsvFmjpMAJHdojHl
         Q0Jn7jImQvZtBKc1LEXoBHhyEkSWpF9PhWPcA2ymxUTpOnE3DpLQs1M+2FW7+I9uRS
         c04XBKtf1h/6RTblnxF9stzinDK5YNdbQWqKEp7m+JRcVDxTQh67xYB3ookflhhNEf
         SrNLXmejddR0uTCNMT+gyzGnEeTf3dEzCHcRoi0uwc29z2hDuRXXu1dfAV/BQ1zufg
         9q3juNv83LvpWM0uSKkNpo40YjLBKW2lq9Y/2vK1UXg9flS0K6H38gCzECZ3UIBSWw
         lvAgb3SJsB78A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91D2CC41679;
        Fri,  3 Mar 2023 18:44:46 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 6.3-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <f3997846-ea56-917c-b8b0-fd8db730f20c@kernel.dk>
References: <f3997846-ea56-917c-b8b0-fd8db730f20c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f3997846-ea56-917c-b8b0-fd8db730f20c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-03
X-PR-Tracked-Commit-Id: 1947ddf9b3d5b886ba227bbfd3d6f501af08b5b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 53ae7e117637ff201fdf038b68e76a7202112dea
Message-Id: <167786908659.30023.12721604088183108386.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Mar 2023 18:44:46 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 3 Mar 2023 05:45:22 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/53ae7e117637ff201fdf038b68e76a7202112dea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
