Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410646081D3
	for <lists+io-uring@lfdr.de>; Sat, 22 Oct 2022 00:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJUWu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 18:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJUWu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 18:50:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEA315A8C3
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 15:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98296B82CF8
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 22:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D1FCC433D6;
        Fri, 21 Oct 2022 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666392649;
        bh=tRSdl1nk2zZUDSbFNvkPmyBraoWBLbguQj2NGaZDrHE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=emXCfwxE4qtGeRdIE7JTBlvGoJeB6KxTdxdDfRm1P7anvI0hXSOO781d264b7gRQT
         dQvzXD+P/f5EjEkRR1lGGUzcPcEg9a8JKO8hxLf1osuodBhsfF1Y23yrw+6665frYu
         w6gAA87hFdPNLqso7+HlG09W5plrkXQVnkRS3glekYiRznKHFq0yK+Fj0+vDN+WYJR
         i/k0VQZYjHEaOhFEdtOXgsOpm8k2GVTGbP1Ht6FE1uz3WZ8683TdVltppDuZSomZLD
         8FPD6yB2fDfJpmDJ1hPJco4k+VKMHyhwZjkAQaMk9e/Uodypa/mFh1ZgynUsTm2Evf
         ByZUlG9AMPIMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49565E270E0;
        Fri, 21 Oct 2022 22:50:49 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.1-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <57da23c7-63bc-6986-8c16-7bdd53c971ef@kernel.dk>
References: <57da23c7-63bc-6986-8c16-7bdd53c971ef@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <57da23c7-63bc-6986-8c16-7bdd53c971ef@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-20
X-PR-Tracked-Commit-Id: 996d3efeb091c503afd3ee6b5e20eabf446fd955
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 294e73ffb0efac4c8bac2d9e6a896225098bd419
Message-Id: <166639264928.28861.16885715090700508841.pr-tracker-bot@kernel.org>
Date:   Fri, 21 Oct 2022 22:50:49 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 21 Oct 2022 05:02:35 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/294e73ffb0efac4c8bac2d9e6a896225098bd419

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
