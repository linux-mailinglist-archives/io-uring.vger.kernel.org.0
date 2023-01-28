Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837D167F31E
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 01:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjA1AZt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 19:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjA1AZt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 19:25:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E465BC
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 16:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B691CB8222C
        for <io-uring@vger.kernel.org>; Sat, 28 Jan 2023 00:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C728C433EF;
        Sat, 28 Jan 2023 00:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674865240;
        bh=U1Czo/HcZSCIl2IicTYF03BsGE8GuBPB1EtFkE7FJaA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=vN7WidNJ8Ma2RiOdsWvxz1lXFjnblGB32gfIhJgqwILSKoaIhBJBzbtI6CxHY/9t6
         VpRxh0JlUK9UNWlx6/jrACU+3BWPilXF+1+3nk98cRT5GD3YkZoWafJWmG0WvVZZWL
         Xk9szJJDEaMzLfCBlU9N3emaqoeXYYlSdz2nleF1GoYMvatcxRz52VMXkFX5UlPdm5
         X13Sej6wllW9U4A+4ag5tseIqr6+x8kRHi5t5idWaR7OTdS76TdGh3zrBAsi+lpdj7
         L6qFGlNLIFVYsHEn23GWZTXk5PV6ox7nuxOPAbkDkq8PVnvKL0zLHMCqzi9KI7l4x2
         z1p6ZWjt05jBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BE03C39564;
        Sat, 28 Jan 2023 00:20:40 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.2-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <55d9c30b-6a67-3126-d7a3-b844e00324d6@kernel.dk>
References: <55d9c30b-6a67-3126-d7a3-b844e00324d6@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <55d9c30b-6a67-3126-d7a3-b844e00324d6@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-27
X-PR-Tracked-Commit-Id: ef5c600adb1d985513d2b612cc90403a148ff287
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f851453bf19554a42eb480b65436b9500c3cf392
Message-Id: <167486524030.6770.3003126411278706481.pr-tracker-bot@kernel.org>
Date:   Sat, 28 Jan 2023 00:20:40 +0000
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

The pull request you sent on Fri, 27 Jan 2023 13:01:26 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f851453bf19554a42eb480b65436b9500c3cf392

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
