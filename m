Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C966C8768
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 22:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCXVVs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 17:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCXVVr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 17:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E5818155
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 14:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A7962CC2
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 21:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D497C433EF;
        Fri, 24 Mar 2023 21:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679692905;
        bh=54pmqBfmmXjOLHKPPy0/OM4QOXbGQ1YxCHa07FBPzvc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ccBri+VAGf6WFVbFx6kVQf2xEfOEwM21TgQXv92kJ85vB/DX4Pna24FxN+mr7umys
         nXJkOksp1IPRddDGXeH35tF83ViTNeu19poH1HZZqH1z0OJGuMb3ZzI47DsR+uy4qG
         8KtnyOBsztdq50N6Zf2/sEjMgergeCZc7rtd8BGQKuGgrQqpP439FAB3CO+G+ZDC2t
         r/NQ6P7OeitZZEMbPO0LSrllQEXGh3YBf7B8uTfTW/OI88nI3952rn03/UefShEB/r
         jeTGbx5ASMc/+ps7t2y7YjIlry2HX9zp9hvUE0rkt4TbceW8Su1Ke2VAENb56WxQ8m
         w+4FcPvLHHkGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BB1EC41612;
        Fri, 24 Mar 2023 21:21:45 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.3-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <07712171-44e0-5fae-c2c7-c4efd45d8f79@kernel.dk>
References: <07712171-44e0-5fae-c2c7-c4efd45d8f79@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <07712171-44e0-5fae-c2c7-c4efd45d8f79@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-24
X-PR-Tracked-Commit-Id: 02a4d923e4400a36d340ea12d8058f69ebf3a383
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e344eb7be2a25c66a8bac5d4388f1a4583450a72
Message-Id: <167969290517.24410.4462902595875074833.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Mar 2023 21:21:45 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 24 Mar 2023 10:28:40 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e344eb7be2a25c66a8bac5d4388f1a4583450a72

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
