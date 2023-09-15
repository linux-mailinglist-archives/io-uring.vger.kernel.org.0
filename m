Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF27A2A4B
	for <lists+io-uring@lfdr.de>; Sat, 16 Sep 2023 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbjIOWQu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Sep 2023 18:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbjIOWQX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Sep 2023 18:16:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4F9268A
        for <io-uring@vger.kernel.org>; Fri, 15 Sep 2023 15:16:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D92ACC433BF;
        Fri, 15 Sep 2023 22:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694816177;
        bh=l0B0y9EAna6/0JAag09mfYeopJsKTFPVkFJzV1NWV1E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jr3m2mPpqZsBNTZpv4Zw/AYMao6WpGOwrzXBdnHGSzB+x6v6cYS6lq3UBhrKrZCL+
         HfIOdddG2whDUW/TXPtOG6yOeqRIeemFVegMNkauwkbJpVyd9SXDjjgbmdGUTxBRei
         v/ZtMdAo/gSqN6U6tiXcfr9kPmrkfI0/hwAKRgOR/IyR+zeJwYTx46f/LH8meAvjlb
         bRxPPgHRyfaWOTFh7jf+di5NHEaFwrbflZVny4v4biPrd1AkrGl0AbCvIFSIZxYSV8
         TGvjPtvMMy52a8D8ml3bSsTVsuYENzKpQDD8Cn0EJMwtO1totg3ICply7eU1VAILjy
         vSPc85vDfGVcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4936E26881;
        Fri, 15 Sep 2023 22:16:17 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.6-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <736453bc-ad55-422d-87de-39e1439a12e0@kernel.dk>
References: <736453bc-ad55-422d-87de-39e1439a12e0@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <736453bc-ad55-422d-87de-39e1439a12e0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-15
X-PR-Tracked-Commit-Id: c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 31d8fddb588bc7e3ba40bffa7573b7f7c7c73aa3
Message-Id: <169481617780.11838.12640537595694615829.pr-tracker-bot@kernel.org>
Date:   Fri, 15 Sep 2023 22:16:17 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 15 Sep 2023 09:46:09 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/31d8fddb588bc7e3ba40bffa7573b7f7c7c73aa3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
