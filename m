Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3873063935B
	for <lists+io-uring@lfdr.de>; Sat, 26 Nov 2022 03:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiKZCZv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 21:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKZCZs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 21:25:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D562FC31
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 18:25:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F4CC61170
        for <io-uring@vger.kernel.org>; Sat, 26 Nov 2022 02:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E45C2C433C1;
        Sat, 26 Nov 2022 02:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669429542;
        bh=tfeuRzCmUkA+BCYyEcnreZZq+qVdhosGTYqZ/d8fgLM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oTVIoHvdUVcAIkcYICIcm5IDPd8ji6ff49wkCzLd2401DpvnQD1b4ne2ceQ16IHcP
         OrXxz6j3y0eIrezPaNK/5YTCG8i5FlyaCasMvr5Gj0GyCdq0S5yNrUcOK9rppxQlve
         U1jkf3IRYEYBVJI9xhIwDkrKLO+MA5Uoir5ItWrEmRXGxiJg+p1DAWyrSCkE6oapr2
         Do0OhPhdAhkDcDqsUjDx4azXe1wXnm8odjzY9smBj3EpNvetb2FQ9ALimvZknB3wkV
         cJBucSOoaD5OAlElcSj6/GiSpaZ5R9b+ZmYav6HRQY/U8IadQDVjVel3Bgy194SGGt
         kO9DWBgd32v8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3593C395EC;
        Sat, 26 Nov 2022 02:25:42 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.1-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <63d6db5e-208a-6437-3b4a-b3637f84bfc8@kernel.dk>
References: <63d6db5e-208a-6437-3b4a-b3637f84bfc8@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <63d6db5e-208a-6437-3b4a-b3637f84bfc8@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-25
X-PR-Tracked-Commit-Id: 7cfe7a09489c1cefee7181e07b5f2bcbaebd9f41
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 364eb618348c1aaebe6ccc102ca15d92c2bf6033
Message-Id: <166942954286.27056.13491251816585076074.pr-tracker-bot@kernel.org>
Date:   Sat, 26 Nov 2022 02:25:42 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 25 Nov 2022 17:19:01 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/364eb618348c1aaebe6ccc102ca15d92c2bf6033

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
