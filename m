Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3235955A147
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 20:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiFXSoO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 14:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiFXSoL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 14:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1557FD26
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 11:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F41062094
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 18:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5E67C3411C;
        Fri, 24 Jun 2022 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656096249;
        bh=39p9O5JTVM51uwfXZQm2b2HBSRYmcRYnB/xL4zfUcIw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=t0qf6B1AItTZlfptAr0BnAxX7G+eElDLvLO9UGerjKpiJV8SSw7F00PD9cAfsLAJu
         vTx/sr1s8vhINaqrIOFiPfBi9IKm85RR3QLYvauXqK8gXdXckNuPMwRthce/ht5xqW
         Zm6VyDz1QPMhOx1YCZ96zYJyWjmTv265u3xRprBxIc4Yjq3+flV17S0xklZWAxuSRd
         +7eSfaxbeT7pKYQdof3eeJFH9/g8kzqoXOdRXKSeJiEWrnKyrJxcHNOlH5TlWphShQ
         iNDaU9CLyY4DOntm//KlpKFHSxGrD1xxI7HJmTgJbZkGAoqo+5tlHz+q9Vdp77R/ti
         7x6PRLjEelo3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94B95E574DA;
        Fri, 24 Jun 2022 18:44:09 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.19-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7c74945d-1300-5e59-3afe-fad2cdabfe32@kernel.dk>
References: <7c74945d-1300-5e59-3afe-fad2cdabfe32@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7c74945d-1300-5e59-3afe-fad2cdabfe32@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-24
X-PR-Tracked-Commit-Id: 386e4fb6962b9f248a80f8870aea0870ca603e89
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 598f2404879336277a4320ac5000394b873e049a
Message-Id: <165609624960.26462.12599779645651632664.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Jun 2022 18:44:09 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 24 Jun 2022 11:42:19 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/598f2404879336277a4320ac5000394b873e049a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
