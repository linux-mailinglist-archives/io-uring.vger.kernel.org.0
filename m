Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FCC5158F7
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 01:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381791AbiD2Xc5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 19:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381789AbiD2Xc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 19:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F881663
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 16:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E0AA623C2
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 23:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B41A4C385A4;
        Fri, 29 Apr 2022 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651274975;
        bh=yDxGxmYF+oblbjuP/GDIwU1H+BlMuxsRIstRXtHXHJw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ag0cXa6nBa+7u5q90hnaVy5xcu4/NnKlVmJBuwP310guH6x4ZyU+FLO7KbuPHTBpA
         zRN8Gd9vPtHUQRonYKy5/syV1Vsii/NxMJjeoPIYOsKr3oLEi7b7mdsZPHQMFtix8N
         VaRl2h9flvaO06n/eVezeGVtqS6vSB4PyD5ZUiXNR2hOxSIFzRztStc1/YHXMoKhRn
         CAGzwY0gQSp9K4AO2juDrzWxptPMDcnWg3/hLFINmhzb6S/hP1hvQDUMMtbiTelXPL
         tkp57zGst21hgvA36SZE5JFR68UsP/ot8mIcPn4IzRm5gFBnR38eaeyKx6VY5igkq6
         nMot52hhTa42A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0C97F67CA0;
        Fri, 29 Apr 2022 23:29:35 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.18-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <af70231e-157b-1a74-f6e8-81282c5fce28@kernel.dk>
References: <af70231e-157b-1a74-f6e8-81282c5fce28@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <af70231e-157b-1a74-f6e8-81282c5fce28@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-29
X-PR-Tracked-Commit-Id: 303cc749c8659d5f1ccf97973591313ec0bdacd3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63b7b3ea9442f1342299ddc58f7366e7ecd7e29f
Message-Id: <165127497565.20495.16641912276294457921.pr-tracker-bot@kernel.org>
Date:   Fri, 29 Apr 2022 23:29:35 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 29 Apr 2022 12:40:37 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63b7b3ea9442f1342299ddc58f7366e7ecd7e29f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
