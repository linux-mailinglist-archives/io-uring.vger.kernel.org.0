Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A247720883
	for <lists+io-uring@lfdr.de>; Fri,  2 Jun 2023 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjFBRlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Jun 2023 13:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbjFBRlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Jun 2023 13:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05438E43
        for <io-uring@vger.kernel.org>; Fri,  2 Jun 2023 10:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA9CF61003
        for <io-uring@vger.kernel.org>; Fri,  2 Jun 2023 17:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B6C4C433D2;
        Fri,  2 Jun 2023 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685727696;
        bh=TaIWQy40DhIaC6qZwkzq095uHb6r8X5nEXdquXVGZbI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ntnj+p9jAbE1HRVN4C+uaoRSc6TbgkcEM65glkr8c2MIjX47VGRlQxOWQTKdZ3qNz
         rg60SjXxnAt2LIXy2iw+bh33SQ5ZnLj0T5GSq3Mxkd1lkwcrgjgGtncQ7UjJhbSeIm
         jRSAUoOGDrXOT01I3YnivhtVqFckw5nrXcsLwgpKzQFp0B6/dBA7Uy1RRTB7rS131y
         G+eKieoZK7/B5PkKgsBAYJeree54A0/oH6N2nDc/L/4LlvZFF/iY0A2BG1cNA6zc0L
         sCq52UL8TPNEsC4CxJrFQ1BQvLfJJfaraZ3kdUDVwr6oQyUz5pakLPm4sK9FNSD+B0
         teBDVQhyG+ebA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39899C395E5;
        Fri,  2 Jun 2023 17:41:36 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.4-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ce81810d-3fc3-29c5-a6ff-246f080a880f@kernel.dk>
References: <ce81810d-3fc3-29c5-a6ff-246f080a880f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ce81810d-3fc3-29c5-a6ff-246f080a880f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-02
X-PR-Tracked-Commit-Id: 4ea0bf4b98d66a7a790abb285539f395596bae92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 26d147799001edfe479c0b015ba1cb038def5ae7
Message-Id: <168572769623.31437.13907204439442654458.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Jun 2023 17:41:36 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 2 Jun 2023 07:18:29 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/26d147799001edfe479c0b015ba1cb038def5ae7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
