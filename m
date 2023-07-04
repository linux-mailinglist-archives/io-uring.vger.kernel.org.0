Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF51B746725
	for <lists+io-uring@lfdr.de>; Tue,  4 Jul 2023 04:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjGDCHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jul 2023 22:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjGDCHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jul 2023 22:07:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FCBE59
        for <io-uring@vger.kernel.org>; Mon,  3 Jul 2023 19:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E5DC61119
        for <io-uring@vger.kernel.org>; Tue,  4 Jul 2023 02:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E01E2C433C8;
        Tue,  4 Jul 2023 02:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688436427;
        bh=whf/ferz+gzRmIhOe6XGpv47YoVWT60I4xkmtcUOQcY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=c8aOtZ/az4CeDj/tIEXWb5ZZXPKtI/sXlT581mQZzDkGyRjj3LbEw4Y0aZnjqXELc
         xggLGxzv2vyfQ1h6RguQtuabBtNLdAUxccT365Rkuq5JHHpE/zPkgWfPASLcxXdpzP
         hGhAsh8KSfmrCQ9bVn7Fh+Zl84FaXKXD6RDE9kX0zBqVn05mvrbFeUUloQ9ci8pGdp
         iVBWfIl4WAcdZQN6NWLybIoCLcsdxpIBA8ZLl7wjqRrkYXdzrevSgzp1oI2ZZPv5ZA
         +5YGzWUmwqyc/w4JC/yiQQWMFBf2t95mqrngI61LYpmSItE0oiFe3LGjgmC5x/aLXY
         h1JJHKwdV0FuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE005C561EE;
        Tue,  4 Jul 2023 02:07:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.5-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <f866804b-759f-b2b1-a47e-7183de80da7b@kernel.dk>
References: <f866804b-759f-b2b1-a47e-7183de80da7b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f866804b-759f-b2b1-a47e-7183de80da7b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-03
X-PR-Tracked-Commit-Id: dfbe5561ae9339516a3742a3fbd678609ad59fd0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f52875366bfbd6ddc19c1045b603d853e0a889c
Message-Id: <168843642783.21068.10030350164994288949.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Jul 2023 02:07:07 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Mon, 3 Jul 2023 14:13:00 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f52875366bfbd6ddc19c1045b603d853e0a889c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
