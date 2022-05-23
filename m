Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4253166E
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiEWUmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 16:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiEWUmE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 16:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C47939C9;
        Mon, 23 May 2022 13:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBC32614D5;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C1EBC34115;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653338522;
        bh=7zFaWjYC0ctqxmrBjpT72XOD8+KjWpS9jZNIPGjBBIk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=avewAxHTjeKKiyuf9oqPcRrESC2Ylpgb+nOLFuM9IEJgG9AhiWrSR1C5juj9vO6Wd
         YOcRdC20PqqIVDIkdcbqiPF4QQfi0LtsbEk9BhgZoWYNClcW9ddTeJryCAeOw+3zVp
         HI6N0zPPtC1TzUl2EvCTYkPsyH1i0bCqmAQ4lx44qL5uAfF4U3I/KbmBHwjBK/sXLV
         9Gc9+5MpGyQxJkAnr7LsxnJJQmodzurDiDoatT12t/fjD8BXObt2j4KjiEh68T/ZTG
         JkIlVryQTnL73V6LqHKdOKGwG5OaU8XM16wggh/cYFkIeX4+x4am2UbKTo7PP5ccgi
         6I9Oy4afI5HUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2422BF03938;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring xattr support
From:   pr-tracker-bot@kernel.org
In-Reply-To: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
References: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-xattr-2022-05-22
X-PR-Tracked-Commit-Id: 4ffaa94b9c047fe0e82b1f271554f31f0e2e2867
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 09beaff75e4c4cee590b0e547c7587ff6cadb5db
Message-Id: <165333852214.17690.13386045452852413293.pr-tracker-bot@kernel.org>
Date:   Mon, 23 May 2022 20:42:02 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 22 May 2022 15:26:02 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-xattr-2022-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/09beaff75e4c4cee590b0e547c7587ff6cadb5db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
