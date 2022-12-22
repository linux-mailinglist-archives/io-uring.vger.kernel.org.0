Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89D653AE2
	for <lists+io-uring@lfdr.de>; Thu, 22 Dec 2022 04:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiLVDHu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Dec 2022 22:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiLVDHo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Dec 2022 22:07:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136EE248C6
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 19:07:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1AE8B81CD9
        for <io-uring@vger.kernel.org>; Thu, 22 Dec 2022 03:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DD28C433D2;
        Thu, 22 Dec 2022 03:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671678457;
        bh=ILkxGr60ZUJfVisgH7norSZmd+zkU48wprXZFM8cQTM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LtZQ5wqxPyI6UFI+4L2N2+Ee/kc5n0u3HZ23bQEzoGOQ7J1Seirp4LcvM/PA68Poa
         kAWMc5NBlKHm7gYTiLhpzppDzLIFG6k8av02Z9gOPrUExMKBylB1RfwmLy0m6/088B
         KL+F5f5gOrVQBzU/HreLZhq9TT4H3vBGCnIfdy34UuNHqISfXDJfYPEH/NA408SGb3
         dqeduq9ARb7b8EehhPT29ls4aOkEcdgYWq3im8CRUu2m+q1+RM+2Ca1HmCdxQuhjgh
         lTT4b8f2IrD6bIaHNBzU1KhCrQiXG+9KXjD4bmukImqfgMegWW3BlAWVCteYxWTrO9
         sel9SSAdErjDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AD92C395DF;
        Thu, 22 Dec 2022 03:07:37 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 6.2-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <859cfac9-d8e1-23cb-0ca7-d43964ca2f75@kernel.dk>
References: <859cfac9-d8e1-23cb-0ca7-d43964ca2f75@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <859cfac9-d8e1-23cb-0ca7-d43964ca2f75@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.2-2022-12-19
X-PR-Tracked-Commit-Id: 5ad70eb27d2b87ec722fedd23638354be37ea0b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5d4740fc787db767811c4ac625665493314b382c
Message-Id: <167167845736.12654.9852255825962910066.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Dec 2022 03:07:37 +0000
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

The pull request you sent on Tue, 20 Dec 2022 08:17:26 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.2-2022-12-19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5d4740fc787db767811c4ac625665493314b382c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
