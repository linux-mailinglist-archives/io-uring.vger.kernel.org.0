Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32555F7BEB
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJGRAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 13:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiJGRAO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 13:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294746110E
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 10:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C452361DC4
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 352EAC433D7;
        Fri,  7 Oct 2022 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665162011;
        bh=QQQU7VBkIE+GdlvOwNFN+HOmT0XhjZWZeWp2aVNDfJM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FWGtFcu/RaCy3OuZbhyywBORvy4XRD3QwFlG2FSzVGQZqVIjlNZMAljOAoUyp2bxs
         qx9pigedvjagV5C3UNNNeRtCAtgCG6dMhM//bHECTMRRsgBZFc692Ix7pvC1CMHbXI
         ZBuCtXscpAclnVvPnI5UhFk9NzC2LY9S6L+HSHJmfyZBp1XHFD8DmaAEOVJYKooseF
         LLEYfF662fWRD+2n9eTXPtkVDD8IVKvl2MSOb9qebJbOnC3DRrr7R62tiDHFrhpkhP
         I2joLHM3UAs2gGzm94Jc24ZUqjBKOv0FBhT83096eddVALyB9ITXzhT7ItnwPBM27x
         QNeZiXxDbsVJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22AE1E21ED6;
        Fri,  7 Oct 2022 17:00:11 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
References: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.1/io_uring-2022-10-03
X-PR-Tracked-Commit-Id: 108893ddcc4d3aa0a4a02aeb02d478e997001227
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5853a7b5512c3017f64ca26494bd7361a12d6992
Message-Id: <166516201113.22254.6001976797862386525.pr-tracker-bot@kernel.org>
Date:   Fri, 07 Oct 2022 17:00:11 +0000
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

The pull request you sent on Mon, 3 Oct 2022 08:18:29 -0600:

> git://git.kernel.dk/linux.git tags/for-6.1/io_uring-2022-10-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5853a7b5512c3017f64ca26494bd7361a12d6992

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
