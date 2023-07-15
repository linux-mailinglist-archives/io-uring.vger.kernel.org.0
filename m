Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48C675466F
	for <lists+io-uring@lfdr.de>; Sat, 15 Jul 2023 05:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjGODIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 23:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjGODIW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 23:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998FE3A81
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 20:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F84961152
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 03:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 996E4C433C8;
        Sat, 15 Jul 2023 03:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689390500;
        bh=FhDiR4FXMX9VFHPqZatVsAri85cXcJy7f5UYrd38XeM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=WeLaoL3Nq83x046T1iYHhqBNj52+4lRSsAp0Wy5sRjg3kfVbZgdLbR27gfjep5C34
         xg6Yv0Ygz3dUaxHycb8ptuMWSqGhwCIodH8huSbeRPs9YARpLWag30ULKJcY1fCWOJ
         XFvjU4o0tznKDCtVkXnDG17B/p8u4LSfzaYnkbUyQsra//LNIYFXrpSgxnFRcXhD5J
         4wJDEhBtGw/SbgzaNxYbnxtKGgMExt9M2+vBG9CVNWHZQs5NZk3zvk8qYXVbNyWa2y
         Rj+S9J4woCS9/DPynGxzwk7L2+Nk6mRd1D0/8dGtzG2p6dJwymnxAkXDBNnriMALBD
         SAj1he2OFiuvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86AC0E1B4D6;
        Sat, 15 Jul 2023 03:08:20 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.5-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b4ba0b17-cf57-58b8-14c1-fda1b209c2bd@kernel.dk>
References: <b4ba0b17-cf57-58b8-14c1-fda1b209c2bd@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b4ba0b17-cf57-58b8-14c1-fda1b209c2bd@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-14
X-PR-Tracked-Commit-Id: 8a796565cec3601071cbbd27d6304e202019d014
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ec17f16432058e1406c763a81acfc1394578bc8c
Message-Id: <168939050054.3346.14538548132868610861.pr-tracker-bot@kernel.org>
Date:   Sat, 15 Jul 2023 03:08:20 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 14 Jul 2023 13:39:26 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ec17f16432058e1406c763a81acfc1394578bc8c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
