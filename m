Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE3E7675A5
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 20:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjG1Sjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 14:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjG1Sjq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 14:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E5444A8
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 11:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14933621DD
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 18:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79952C433C7;
        Fri, 28 Jul 2023 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690569575;
        bh=KCmnI/Nfx/P6GrcgTuEpsN5vcRACpNozrNTkCNQe9w8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FgIv3sTYvdrdDQELoPHqo/B+6uvgFrTkfPeuDvMXmsWX6leMuouO/BK1Q9CCFbgur
         F0SaIsyVdavXhmPg9HtIUsDHxBUkEr4h+aJeQcZsXG2sR253rKfSXWNu34Fkw1kifT
         nEgAADmrebcyNbSEwP9+f/qpUxL/uP/e3WZFz4kfifCn7JRbyLnAC4KjU5GKkZSVrC
         3gEPN/Oa7wkiqXtTMFPm7zDX0iljZhgAlguUZetFFTPjgeRNXBT0SbU+MJZnjbaV28
         6oOlJfGkYk7q26A8DieHYfJEWJSCfpUcUL6qlc+CUop5W3eKI6V93h3P118DMVwP+9
         G2pFv+kzvuoFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65EBAC43169;
        Fri, 28 Jul 2023 18:39:35 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.5-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <624c12e5-2ce8-852b-c235-0835b97d199a@kernel.dk>
References: <624c12e5-2ce8-852b-c235-0835b97d199a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <624c12e5-2ce8-852b-c235-0835b97d199a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-28
X-PR-Tracked-Commit-Id: 7b72d661f1f2f950ab8c12de7e2bc48bdac8ed69
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c65505826395e1193495ad73087bcdaa4347813
Message-Id: <169056957541.21363.2872731213451519638.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Jul 2023 18:39:35 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 28 Jul 2023 09:07:36 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c65505826395e1193495ad73087bcdaa4347813

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
