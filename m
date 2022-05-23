Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353ED53172F
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiEWUmP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 16:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiEWUmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 16:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D5AA76EB;
        Mon, 23 May 2022 13:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C8B614D7;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BB71C36AE7;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653338522;
        bh=JYoATB/ve1NQy/envTJY1JYre41R+XhDAt9dolOQe9Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mlJfkzwPxEbA9xE1flTWye5oKxYeaGnv0P0uJ0iNf20DjY6m5kssg48+uY9N92yG9
         b8VaZYRJYNs6tORZhcHzF66WM4kgWELB7j5JMiPygtRy3A5DitmgBxg8/cQY/PRAhO
         zrmnpTUR8g63FQly5QeC2U1Sov29ygUOGHi8M2+IAsNzjhCuFsda+oPeG0CsNs7lRV
         2PMZo8v53jUg1hLZepEpmt2wujpx3Sf+VjIveLUSkuqBg2zjO+I3usm1dsF9UNy3fM
         HQPdF+aZGIGK3sKhO84WsqSVDfGSd/ZY+0IYCTATo+DvmKEVYM+rYznBPoUXzrOg45
         pMZq73AdcDB2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 489FCF03935;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring passthrough support
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
References: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-passthrough-2022-05-22
X-PR-Tracked-Commit-Id: 3fe07bcd800d6e5e4e4263ca2564d69095c157bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9836e93c0a7e031ac6a71c56171c229de1eea7cf
Message-Id: <165333852229.17690.10519267879279637393.pr-tracker-bot@kernel.org>
Date:   Mon, 23 May 2022 20:42:02 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sun, 22 May 2022 15:26:23 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-passthrough-2022-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9836e93c0a7e031ac6a71c56171c229de1eea7cf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
