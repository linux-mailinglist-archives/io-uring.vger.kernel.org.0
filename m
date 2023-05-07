Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37006F9ACF
	for <lists+io-uring@lfdr.de>; Sun,  7 May 2023 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjEGSMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 May 2023 14:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjEGSMN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 May 2023 14:12:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E2649ED
        for <io-uring@vger.kernel.org>; Sun,  7 May 2023 11:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA1AC616C9
        for <io-uring@vger.kernel.org>; Sun,  7 May 2023 18:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B2E2C433D2;
        Sun,  7 May 2023 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683483130;
        bh=obXxTYFmyJ49OWvmSxYblY1IMLihTuOA8oqHGQ1K/8I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UlXgFggURUF3x3l+POePt+/IXSHxzfBTfx4H5Kf83oY78QGPlTGXt26+izsAp+cte
         GgONffYcg4lOqozNZVNvprs2xgYwJB7SeU3umt7qi6RwA+sZ42Ua31Sxz3BF4Ssx7h
         WWMhPEayztBsrOkktvmPJvU8lNG5pYpaEv1vVie1Kwmn8Io3DCzG9eMBrzF8AwefGb
         M74CQ2ktCe8Ox3O4Zi1UOXxk+gmNDBKGNcX5YBz5SWJsKhLNLxH9n8WYJGOZKrVZik
         gY8EZ13ba+JXOSX4pqAH3+A9aQf27yfv2ss9DjcYrmA9Yzh/t8oOKv7Cijy5lH5D9w
         idcKGhK0WJ2bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49609E5FFCC;
        Sun,  7 May 2023 18:12:10 +0000 (UTC)
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07
X-PR-Tracked-Commit-Id: d2b7fa6174bc4260e496cbf84375c73636914641
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 03e5cb7b50feb687508946a702febaba24c77f0b
Message-Id: <168348313029.16669.12553935500330394745.pr-tracker-bot@kernel.org>
Date:   Sun, 07 May 2023 18:12:10 +0000
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

The pull request you sent on Sun, 7 May 2023 06:00:48 -0600:

> git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/03e5cb7b50feb687508946a702febaba24c77f0b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
