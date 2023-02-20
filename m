Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D169D6E5
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 00:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjBTXA0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 18:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjBTXAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 18:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED75227AC
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 15:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAC9560F58
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 776F4C433A7;
        Mon, 20 Feb 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676934018;
        bh=7TTv41mkJRrtsWyLqn9xsqTkOj75RPioxj2ts3Oh3lY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FXyoo/sTp7UQOyPEPEIX/9Gabc9ATlWCH5CjQ7xGkijSJDnJzgrwtC4iOlnF1QDpY
         7AIlDuyas8SEgDfIkQ+dKp8mCHAdwRxTaP5s88Y4mJ8k0SkMRXuOsQg7RVr9/KyjlP
         OWiEGFdeiJC9GdTEpvc4xoJnw1ZLNXAa9ly4Z1+2w13mNEH8prJTmSMD+SMN1Mvpua
         bIIReVt6qNvUaDgQyUJCYyHy5NuW7a+gbsjQR4uiDeh2b4d7kDZ4aYW8IAERuItFdl
         tYsfm5ImI3+Hd9bdNyO/TzH2W27UpHBATvYhoWXMJW6usJEBuKSxxDC73qro8kjjo4
         Y2zAwGAwTx6gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65BDDC43161;
        Mon, 20 Feb 2023 23:00:18 +0000 (UTC)
Subject: Re: [GIT PULL for-6.3] io_uring updates for 6.3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c4dcf46e-43c6-debf-ea74-a2de91d846de@kernel.dk>
References: <c4dcf46e-43c6-debf-ea74-a2de91d846de@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c4dcf46e-43c6-debf-ea74-a2de91d846de@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.3/io_uring-2023-02-16
X-PR-Tracked-Commit-Id: 7d3fd88d61a41016da01889f076fd1c60c7298fc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cce5fe5eda0581363a9c585dabf8a5923f15a708
Message-Id: <167693401841.6080.10105253578855403353.pr-tracker-bot@kernel.org>
Date:   Mon, 20 Feb 2023 23:00:18 +0000
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

The pull request you sent on Thu, 16 Feb 2023 19:53:56 -0700:

> git://git.kernel.dk/linux.git tags/for-6.3/io_uring-2023-02-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cce5fe5eda0581363a9c585dabf8a5923f15a708

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
