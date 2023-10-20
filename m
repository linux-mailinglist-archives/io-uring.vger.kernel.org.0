Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103C57D1512
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 19:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377964AbjJTRnE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 13:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377946AbjJTRnD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 13:43:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE72A13E
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 10:43:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56151C433C9;
        Fri, 20 Oct 2023 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697823780;
        bh=w3j1UpVUUVIBslkc/WnzWj4pZVLISgqTKyMdNwbGwes=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hC39ckdDbJF3FKOdk4yeXRNbaRczY3SBMAaxwbrthP0KWAyuK6cRCKREqfW6zFzjH
         g+cL5xCXESV7gOJggSq444pKu+ekZF2ICHbWOIZvXPcsB+qjrxUdZNreFrRqnV7nds
         uTm0dbIBEUp4lvhuI+V2A0mSpJguDVJ8rdCPYliRBOpXM8Jj5bFF+REEwQyLp7XHMc
         /xkDKYgouDmf0fq+y+WCq1us2djfSva3plrIDQ0UWRdiC0VgHMmxcmSEKFByfTP+MW
         lZyglKmFFNVx4M3+qGEM/n5MsxwuHNJe3rCpzgW3XPkSXfs0CK7XE5siSG+7OYhj2s
         oxnD0Z9ruCY1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43246C595CE;
        Fri, 20 Oct 2023 17:43:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.6-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9ca5fb73-74c5-40f4-9107-0d3b406fd9c7@kernel.dk>
References: <9ca5fb73-74c5-40f4-9107-0d3b406fd9c7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9ca5fb73-74c5-40f4-9107-0d3b406fd9c7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-20
X-PR-Tracked-Commit-Id: 8b51a3956d44ea6ade962874ade14de9a7d16556
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 747b7628ca66de3806e6988d3a6e0c9c48d33694
Message-Id: <169782378026.18812.13727262251565699913.pr-tracker-bot@kernel.org>
Date:   Fri, 20 Oct 2023 17:43:00 +0000
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

The pull request you sent on Fri, 20 Oct 2023 05:22:04 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/747b7628ca66de3806e6988d3a6e0c9c48d33694

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
