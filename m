Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CDC66A732
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 00:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjAMXoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 18:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjAMXoQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 18:44:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323008BF19
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 15:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C41EA62263
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 23:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35393C433EF;
        Fri, 13 Jan 2023 23:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673653453;
        bh=7Q777s64Qrqn5KbLKcJcIhT8InP+ER6bNZmuOLGuwy8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pbFYYM9uHqVxXCfUE0lzg+yID3JMkvnJJ0UsdFz66UwnyRU+27pmTtHt+17T4t+iY
         BjLIeCOGod+RdaO6pK0OPzKSr6BWmwJ3BPJ+AZ+v2F2H1Hp9ziOGYW14E6EjgMAetF
         tEDXI8/vF6oTODCNt5FwDPTU/KebXl2Pg2gVPJwKF1pz9DefViccvsPbe/4s22pYAQ
         lqjtQu9VNm9KhSVbouHS9GbEznBB4mmfSyuVylwtnGhaCUPow8hpsyLr6+sz3vdf5c
         KDFyKKh0lEVXM/Av5M34NUe8kK5QON37qFnupXCw4+mSU2yuzLOUKWXBsqaYAJjUqP
         kUIxqXg1rWoeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19C1DC395C7;
        Fri, 13 Jan 2023 23:44:13 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.2-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a9270ed5-05f5-2353-d5f6-f877b5ca7d60@kernel.dk>
References: <a9270ed5-05f5-2353-d5f6-f877b5ca7d60@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a9270ed5-05f5-2353-d5f6-f877b5ca7d60@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-13
X-PR-Tracked-Commit-Id: 544d163d659d45a206d8929370d5a2984e546cb7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2ce7592df99f7356cc8697ad10849987237abca4
Message-Id: <167365345310.26027.15013133087069103133.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Jan 2023 23:44:13 +0000
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

The pull request you sent on Fri, 13 Jan 2023 12:32:30 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2ce7592df99f7356cc8697ad10849987237abca4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
