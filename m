Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D91556D031
	for <lists+io-uring@lfdr.de>; Sun, 10 Jul 2022 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiGJQq4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 12:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiGJQqe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 12:46:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDFF15709
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 09:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83C30B80B66
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 16:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25934C341CD;
        Sun, 10 Jul 2022 16:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657471540;
        bh=48vcA+pK+dmv/4M4KEMlPNTGXfIAxt/whuEMFzYUKjU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=e9ZJG1GU11fOVwUhI5UNvu68QCdR+01NmbFxZPPGOjLV9hQ/jcTsHsLFYhgk9+6yX
         9DUt+Au8dJTmrOh5hQh47SeP7PEh1sZq8DXPNCuFm1OxRIE64tp3bikBSrAOjziRAe
         EkxucNsnzK1tPoBoeJ+ojTsN8wd+1YxSn/zMM89EyHhKc9am4vBWvUMIIBMwCUCVwu
         uEJK4ed8ij++ZfhG3AsgXVKGCHsmlZ1mJ4jtB0qdBkBKUe7HNlFiT+jt1qbc+rtlJK
         IOLyq/iICPO1do0eewszTuYMtz6w8SXVzwwtEDBNyDjkvUeT9s1GqUSyP0e5cPjLlg
         PqL6m57Uc5kBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1269EE45BD9;
        Sun, 10 Jul 2022 16:45:40 +0000 (UTC)
Subject: Re: [GIT PULL] Follow up pull for 5.19-rc6 io_uring
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ee0e6d42-3726-22c0-bfc9-7e7384f5e4ff@kernel.dk>
References: <ee0e6d42-3726-22c0-bfc9-7e7384f5e4ff@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ee0e6d42-3726-22c0-bfc9-7e7384f5e4ff@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-09
X-PR-Tracked-Commit-Id: d785a773bed966a75ca1f11d108ae1897189975b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d9919d43cbf6790d2bc0c0a2743c51fc25f26919
Message-Id: <165747154006.25707.17508846688905051116.pr-tracker-bot@kernel.org>
Date:   Sun, 10 Jul 2022 16:45:40 +0000
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

The pull request you sent on Sun, 10 Jul 2022 06:38:01 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d9919d43cbf6790d2bc0c0a2743c51fc25f26919

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
