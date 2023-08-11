Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC85A7797B1
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 21:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbjHKTYz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 15:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbjHKTYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 15:24:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A31130DA
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 12:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6536794E
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 19:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4234BC433C7;
        Fri, 11 Aug 2023 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691781894;
        bh=TFogfEYqjG4lCzcg1pEk29h1rphXZVY9RVAjRLDSE+0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gCNoCMIGYznMJPSNly4X+M6RD3psrUlcbKgew1tYD/NQEwFRU/pouOD75dYq4y3Gj
         VlMTDZr3i/eCwH6VsvMEaXQiSL7jwLwxCFPb/3KfywmpwIonDZMR1cTnWTQIKgve2U
         tIGO6btNKhI+2OxPtZyUUSxphjLxlulRYFWanhbfdAbYufOFs3GHkSeg1VJ8vuHNaB
         NnvZ5elzRr9wjRmq8ElosOZ7SIXdObh6SJSFSSSkKDwN8aLLHWWtPRizzXTOYe1gxu
         7VYkUfhdzc4wlorY9n564QtPLSmmKKp8UVzcjrb6M9L4k0DQgPU3F6bQFKkl6+zI41
         tjI948DGB1BLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30264C395C5;
        Fri, 11 Aug 2023 19:24:54 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.5-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <3f5e6dc7-0391-47e0-a430-e544c42c86f4@kernel.dk>
References: <3f5e6dc7-0391-47e0-a430-e544c42c86f4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <3f5e6dc7-0391-47e0-a430-e544c42c86f4@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-08-11
X-PR-Tracked-Commit-Id: 56675f8b9f9b15b024b8e3145fa289b004916ab7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e40ed24e1696e47e94e804d09ef88ecb6617201
Message-Id: <169178189418.32415.17941689908597441171.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Aug 2023 19:24:54 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 11 Aug 2023 12:34:33 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-08-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e40ed24e1696e47e94e804d09ef88ecb6617201

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
