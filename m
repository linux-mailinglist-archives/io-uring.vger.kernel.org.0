Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64ECE4E3599
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 01:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiCVA1j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 20:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiCVA1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 20:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4346421A8A2;
        Mon, 21 Mar 2022 17:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C92615A8;
        Tue, 22 Mar 2022 00:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0490CC340EE;
        Tue, 22 Mar 2022 00:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647908751;
        bh=xGSoF6R/cshfFJHkQ8WUXz7d7rBPUYhUTZ0lws2wLCE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iat5i9ap6Nsyy00nRdHxdSC0Kysp6Vfq1N3QCJEwJu0GMipo+lmv6Aee0YnwsWKWS
         SZjMVrvZA+LAHUAT7++b8YTiKXPPCbG4+AICilIcSneUwQ5ptIhtMm5ER2TxjZYNNv
         GKf9pUwyo9RTtGec7CWgL7XijorEXi+magibn+nDLRMjfY3gA9YLswS8TDD1IAe+0w
         dqdn2q4MALJ2bErQCI5GLKxrs3nb8zZZKolTUO6nkIicoBUTJrvvomm/S0Z0kMyV/K
         lxWcMjQ24Bnb8ml5D4zX31C+BKBupTdJeqPI7WWmGGkf6VXD9hp7myTs2AatjJ1TdA
         q6YlVfsV4h5Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7B4BE7BB0B;
        Tue, 22 Mar 2022 00:25:50 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring statx fix for 5.18-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1fbbd612-79bd-8a7b-8021-b8d46c3b8ac7@kernel.dk>
References: <1fbbd612-79bd-8a7b-8021-b8d46c3b8ac7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1fbbd612-79bd-8a7b-8021-b8d46c3b8ac7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-statx-2022-03-18
X-PR-Tracked-Commit-Id: 1b6fe6e0dfecf8c82a64fb87148ad9333fa2f62e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b080cee72ef355669cbc52ff55dc513d37433600
Message-Id: <164790875094.30750.9054052876159323786.pr-tracker-bot@kernel.org>
Date:   Tue, 22 Mar 2022 00:25:50 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 18 Mar 2022 15:59:21 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-statx-2022-03-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b080cee72ef355669cbc52ff55dc513d37433600

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
