Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A075950CC85
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiDWROk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbiDWROi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD511AF3E
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A44B80CFD
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 17:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 831EEC385A0;
        Sat, 23 Apr 2022 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650733899;
        bh=R2L68KclIofRdV5wTSPnSzGG/4JtlmageUdqWmvdWGc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZAWxQPT0KObrVkmIa69uoPqra1bRB7+r6026ihi0uMIwtvbJiaNuf8bcAxZT46RHN
         7e65zWSlpD10udH9dvIzQUQro8VfoXpFh8GAbR1SQOptzXmJPEP8lbBwxV7rvHnpA2
         KQCK+Tl/GYgjKev1Mbbjuvp9lytdb8MnauNEZt0PHMt1l1OVRYa93chXbG0uEDY6cL
         NzRfG072rkT108ZzaMEu4JsUabL9ZwCXg6/HIuHT/o+27N8eceAtOCFqTluQelb0ol
         TDb9o4k7aYdKWH2uuROXskj24X10jrpbk4twjvp9+0wOKgJiw4SmS08TmdyT56PMnj
         7Qsm1gmQPkapQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E65DE8DBD4;
        Sat, 23 Apr 2022 17:11:39 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.18-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <db81323e-38e2-e0a9-08a5-6fb8f429e071@kernel.dk>
References: <db81323e-38e2-e0a9-08a5-6fb8f429e071@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <db81323e-38e2-e0a9-08a5-6fb8f429e071@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-22
X-PR-Tracked-Commit-Id: c0713540f6d55c53dca65baaead55a5a8b20552d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f5e98e723a0be814181524a7e6aaf87a805cdc9
Message-Id: <165073389944.30714.12444945592857209312.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Apr 2022 17:11:39 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 22 Apr 2022 20:18:04 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f5e98e723a0be814181524a7e6aaf87a805cdc9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
