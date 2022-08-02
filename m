Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A150E588399
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiHBVaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiHBVaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 17:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CF862E6
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 14:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 109E861547
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 21:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4E7CC43146;
        Tue,  2 Aug 2022 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659475814;
        bh=18XanIdGEcQ2pd/eArwKAYBdt2b5k98RAkDKJg+SH10=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ceo7WxkqEpIqHRXLuH6OdBPpD9Y2GWzaZC+GLNNVTLbBowdFYzeigFkyoXc7N6DIe
         LmO09xCKUTvkhx3Hq3FgoY4roRwe59TeZbtetMycdUQ79KmciagInUXy2z5wW4yFor
         /cXnuNmlJJ/h2Eb3agpugupJogzLoLcjJILadFDQk+XkJi5IKsctRyc+DuVit032+W
         tTeSW1MibjkVnYap9544eD7r6p1Yf07iOicvcruTj0JQINcnxnV2UnyX/dK5x6gYBR
         yN0r+ThR6ynqUgA77SW+GpJQmlf9XWLhGNfOM4J0hLjSOYOXphWAkkPjpgJLu8Cg5V
         ANeczieBHnR8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C202DC43140;
        Tue,  2 Aug 2022 21:30:14 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 5.20-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <0d0db348-ef5f-e293-5837-321e7e57ad72@kernel.dk>
References: <0d0db348-ef5f-e293-5837-321e7e57ad72@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <0d0db348-ef5f-e293-5837-321e7e57ad72@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-2022-07-29
X-PR-Tracked-Commit-Id: f6b543fd03d347e8bf245cee4f2d54eb6ffd8fcb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ea6813be07dcdc072aa9ad18099115a74cecb5e1
Message-Id: <165947581479.30731.3349750420836376071.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Aug 2022 21:30:14 +0000
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

The pull request you sent on Sun, 31 Jul 2022 09:03:23 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-2022-07-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ea6813be07dcdc072aa9ad18099115a74cecb5e1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
