Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3D5E8DF5
	for <lists+io-uring@lfdr.de>; Sat, 24 Sep 2022 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIXPc5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Sep 2022 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiIXPc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Sep 2022 11:32:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A066E26108
        for <io-uring@vger.kernel.org>; Sat, 24 Sep 2022 08:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41F72B80DF5
        for <io-uring@vger.kernel.org>; Sat, 24 Sep 2022 15:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EED66C433C1;
        Sat, 24 Sep 2022 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664033573;
        bh=mV2UGl+7GmPpzBHCHyr6cw+JhQWjIjeWiD8/YKDte8k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kick2Hhr0sGE+ZQOrWP0YGWvHcrXdjNM8d4Txsiday6RByRNmqO6h5Rl8FkQnZjkR
         2dSCxC4lE07LKNcYdMptxaUNxveudXrvd5nMICcaBvtUr2ORq+87PtFbF/L9ZeovJH
         ptScQLa43iGXhzpKbdO9on6Oj7sY+MKw3eKRXCHwacis6geFAw2Ao7id528AzxYWXZ
         rC/mDmaliLYp6P3eKZztGVahMmmDnb4PA8RaWncLjwGkZ82tlwTFD7e5KVM5/GfYIf
         L4X8bUN7O3iHUTvwK5gfeSD3QpfN6grq4J9gglpZ07VOAU540Hi4cFRO32qrXe6Xuv
         A7mUiu5dua+Ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB7F5C072E7;
        Sat, 24 Sep 2022 15:32:52 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.0-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <42041d05-9106-686a-dd4b-f9cc03ede480@kernel.dk>
References: <42041d05-9106-686a-dd4b-f9cc03ede480@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <42041d05-9106-686a-dd4b-f9cc03ede480@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-23
X-PR-Tracked-Commit-Id: e775f93f2ab976a2cdb4a7b53063cbe890904f73
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3db61221f4e8f18d1dd6e45dbe9e3702ff2d67ab
Message-Id: <166403357289.24842.6065870785984609042.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Sep 2022 15:32:52 +0000
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

The pull request you sent on Sat, 24 Sep 2022 09:16:26 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3db61221f4e8f18d1dd6e45dbe9e3702ff2d67ab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
