Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD19591CCE
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 23:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbiHMVsb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Aug 2022 17:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiHMVsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Aug 2022 17:48:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F304326130
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 14:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BADD60F4A
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 21:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0E9FC43140;
        Sat, 13 Aug 2022 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660427294;
        bh=HUaKOyRl2Pcn6ACyWKDqC5Qm2pX+u0+FGmae/03MgXU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BKE5zTJboOhzZ/KHP4RIiJ8vVZdBkKlaxFe07wS6zZ1h4W4uJcZyu1BQfjKIh4cZT
         T3iLF3U33k95GgYpS8naF5jcVWjLefKxt4U/qgG/pGgao3CP49r4RCuYUSdJFIflJP
         0uOz6WwUHTIEXm4n4KwmreVyUUwhvRCdr7veZQxMjBPUKUvMHEGPoGwlBAVa+M/pH0
         PwU5HXxuG5/UDyPuJGCcLf30sRwWObI60NiRqcBmSAep3/C04ycge1tOGT2dHOP1ck
         CpOCkNJqDuK3rm5SVSvUSJahmabUMc+lssT4oLJZYfPfOHaTrfxZepv55Xe2FAZCMt
         AmYT9Ro+vXnkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0220C43143;
        Sat, 13 Aug 2022 21:48:13 +0000 (UTC)
Subject: Re: [GIT PULL v2] io_uring fixes for 6.0-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <12ca64e0-f78d-4da4-7103-17218ce8e20f@kernel.dk>
References: <12ca64e0-f78d-4da4-7103-17218ce8e20f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <12ca64e0-f78d-4da4-7103-17218ce8e20f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-13
X-PR-Tracked-Commit-Id: 9c71d39aa0f40d4e6bfe14958045a42c722bd327
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1da8cf961bb13f4c3ea11373696b5ac986a47cde
Message-Id: <166042729391.29926.3104125698192274202.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Aug 2022 21:48:13 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 13 Aug 2022 13:25:05 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1da8cf961bb13f4c3ea11373696b5ac986a47cde

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
