Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5CE73EB89
	for <lists+io-uring@lfdr.de>; Mon, 26 Jun 2023 22:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjFZUGM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jun 2023 16:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjFZUF6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jun 2023 16:05:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926301729
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 13:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7B2060F7F
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 20:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BCEDC433C0;
        Mon, 26 Jun 2023 20:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687809758;
        bh=gBl4Wuz9Apdgirmdk+PTJWtAoiLAhqdm4fufYdJu4Pk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DY0izu9dk9WO2IE99ydQ0iRf4YpPNpu/88pAZMyRmSOiVkLqZalFgBIT4kfIponGU
         0OI8lw4Bk9thP4TOSGIrMDtlYg0ynqPYOO0IE1OMZRWGUdKVla4wxj3hu2U98SzfwA
         oKZyArr+gqheV6bpFwn/eyjeLpsioq1mN/RXzL2ZEMr6I+9BwRVCY4t3CnGXB5KAe6
         WUxV1Dy0Tzj5Sar+2NlAuWA+lQ2emS8lS2qIWslRgFkJdlEQNN2NQInDDcNpZTDeUW
         tS6Ho7ARF281bpztbcUnzv7JLHwjH/03iisU2yjKTG62KNDfrhAjd367xDxQPcDQnG
         hci1OafqeBlrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B322C43170;
        Mon, 26 Jun 2023 20:02:38 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
References: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.5/io_uring-2023-06-23
X-PR-Tracked-Commit-Id: c98c81a4ac37b651be7eb9d16f562fc4acc5f867
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0aa69d53ac7c30f6184f88f2e310d808b32b35a5
Message-Id: <168780975817.7651.12257101561021088888.pr-tracker-bot@kernel.org>
Date:   Mon, 26 Jun 2023 20:02:38 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 25 Jun 2023 20:39:02 -0600:

> git://git.kernel.dk/linux.git tags/for-6.5/io_uring-2023-06-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0aa69d53ac7c30f6184f88f2e310d808b32b35a5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
