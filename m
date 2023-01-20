Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFD8675F30
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 21:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjATU73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 15:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjATU73 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 15:59:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7561486ED7
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 12:59:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10B4362096
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 20:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74894C433D2;
        Fri, 20 Jan 2023 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674248367;
        bh=0QWccGTeGEUckSI7C4C800RC1zFGeZFnsRUQMjTd0yI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LEbyarKmzsmCcn9+KN0crzzrYsCIKFy03whLKiGlJrEj1ru3OB1Z8u9fZK8QDmRxA
         Px3klZhYZlxge9cHEM4t0Ak29/hTdLf71uhjIyNqvbRAfl55ZXQAzfJAo5Gb8GhCrO
         lFvF+bzqvm/pM2RJyFhLqVNcB0wc4iFCM8wThs/D3ieLGKRuSOz9Li1Oqrach28PAF
         Z1jtAkM7Q2IsRBHJ/DYxZ21gxvZy/RZZPzwZYsbKqtOAFKhRpzCKc3LobyylLsDWy+
         J91L/bwLXQRxJdNxud6PlU9Bdoj8Y8HgRz6dV6wv1qFlMadQBInudMK+obASw1bPvQ
         zbuoUK4nSbixQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6220EE54D2B;
        Fri, 20 Jan 2023 20:59:27 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.2-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <0fc64186-588b-76b8-0683-b03df9be9ee5@kernel.dk>
References: <0fc64186-588b-76b8-0683-b03df9be9ee5@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <0fc64186-588b-76b8-0683-b03df9be9ee5@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-20
X-PR-Tracked-Commit-Id: 8579538c89e33ce78be2feb41e07489c8cbf8f31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c38747f0cdb20516de3d708f39720762786750a
Message-Id: <167424836739.22595.13006442371448687914.pr-tracker-bot@kernel.org>
Date:   Fri, 20 Jan 2023 20:59:27 +0000
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

The pull request you sent on Fri, 20 Jan 2023 13:02:04 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c38747f0cdb20516de3d708f39720762786750a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
