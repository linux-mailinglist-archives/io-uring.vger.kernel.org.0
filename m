Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248DC5BAF29
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 16:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiIPOWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 10:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiIPOVt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 10:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE7FB2861
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 07:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0ECD62C17
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 14:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 657C7C433C1;
        Fri, 16 Sep 2022 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663338103;
        bh=hS3yzLWJHg/8EW6ZGraFoQFr+4GRt8N0CbKruyiEvb4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ku9CoEzTUWG7cJLkFcojkDh4PXn3lQzJ+qQRs0IALmu7WPhKQ6saBkg9Byl5rKhf3
         1V1CkMfrVwzabA8NxE/yqdxgzYTDs0009TMTkGc8Jpw+sQPbkqDguS3G8mn4TL+TW5
         RHdmdujMRvmUHQGVDtu517HFzY8lOmnMw0a+NYcQ7uu858K/S652LgiYfRbV/uSJBf
         BTuBUa5mrughQ5v1cX1xuxJ0suGXD2fD0T3TMSuZAc9u7CTyamFfdvM4Ar3E7K78Ie
         9gNQRL4Ts22wmEB27EEEXWWSrLi52bkJL/z8t27xtYLxUlWvL41nmqKjyPFWzai7jU
         RDhUopgQogTNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 547ABC73FE5;
        Fri, 16 Sep 2022 14:21:43 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <370dbf8d-3966-3626-20aa-1d70521fa9b7@kernel.dk>
References: <370dbf8d-3966-3626-20aa-1d70521fa9b7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <370dbf8d-3966-3626-20aa-1d70521fa9b7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-16
X-PR-Tracked-Commit-Id: fc7222c3a9f56271fba02aabbfbae999042f1679
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0158137d816f60115aae2d3b4acdc67383a05c01
Message-Id: <166333810333.10979.10899469460583818975.pr-tracker-bot@kernel.org>
Date:   Fri, 16 Sep 2022 14:21:43 +0000
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

The pull request you sent on Fri, 16 Sep 2022 03:06:51 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0158137d816f60115aae2d3b4acdc67383a05c01

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
