Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156BB647A67
	for <lists+io-uring@lfdr.de>; Fri,  9 Dec 2022 00:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiLHX56 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Dec 2022 18:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiLHX54 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Dec 2022 18:57:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A0580A18
        for <io-uring@vger.kernel.org>; Thu,  8 Dec 2022 15:57:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDE42B825A6
        for <io-uring@vger.kernel.org>; Thu,  8 Dec 2022 23:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99331C433D2;
        Thu,  8 Dec 2022 23:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670543872;
        bh=sS7sB82YRU45luKFVcbzyWpbcGaPX8ONZCgpeZqm0Ts=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Z6TizOKINrn4otONe/5kVWMV0w8yy/Me5gYaGvN7N4/9a5SvgVy3/Bq95hRqxeZwo
         yrVb6ROKoX/hrwVM/yy1z7PowLfD6f0zyudm55aMMmFrC264l5rRRI/oLplDBsh/JU
         dYLxlRNM1zmiPz+28wlNwahyyO3Wsb0Z0RUUzkpUbIBHRktl9zbKtNbqpLEFvAhlI5
         9WzneyhkTsLXeGIg4sqc40aE4a2fw1ffT/sD75IAa/7MweD1chefZmHumR6lnlcETc
         f15SjqCcu6Lnglg+MQ07h3QASifUI0NGbPb0k6gDFMPWjTsgB1JRW4irSQ2W4J6mrZ
         mGC79g6SI+D1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 882C3C433D7;
        Thu,  8 Dec 2022 23:57:52 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.1-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a1f469a9-5272-ffa6-892d-21014efb3312@kernel.dk>
References: <a1f469a9-5272-ffa6-892d-21014efb3312@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a1f469a9-5272-ffa6-892d-21014efb3312@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-12-08
X-PR-Tracked-Commit-Id: 998b30c3948e4d0b1097e639918c5cff332acac5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af145500afa53fce55c9ee98e405fd0d65f018d0
Message-Id: <167054387255.21053.13742084072805322503.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Dec 2022 23:57:52 +0000
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

The pull request you sent on Thu, 8 Dec 2022 14:01:30 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-12-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af145500afa53fce55c9ee98e405fd0d65f018d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
