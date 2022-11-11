Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC2A626442
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 23:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiKKWQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 17:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiKKWQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 17:16:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520FC4D5CE
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 14:16:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E416D6210D
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 22:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54DE6C433D7;
        Fri, 11 Nov 2022 22:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668204999;
        bh=Z2eQhxP3EQchVwf7nWrngm6spT6/PRTPGjeLPg/SM2M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=K7k/k4qJ0OY5nzxChtlqgFfCVF3D6k/s+JHM1OKBEKYCs71BixF6w2XBbiUjB1I0d
         YJIiHsEONxFM0lIrbAGdpMrTrEsNcLNCsGdyEm4WWXzDMUOmYOfc5a3Ouq3mrZxy5z
         xj3EpVng2CSolr7qsva05WUUylybH0gOU5RpFgiOdwxFEO/uF5HXX2Kk6puzyeCxd+
         iWGuvZkMC+bL5P6XkfHqUtR7DYkdmIjXz5Mm1ECQoXalIKpaE7q6EzlU4Qe0Km7bxr
         qSVK0BjDFAK2uXO0iQMl97QAX/y01kOD0Z01Tonpd+LfGLetHoGVmnJZn9yN7OBdFD
         IXPbQwwIf2mqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 448C8E270C3;
        Fri, 11 Nov 2022 22:16:39 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.1-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ac813279-8e83-deba-4f26-99523dd71fc2@kernel.dk>
References: <ac813279-8e83-deba-4f26-99523dd71fc2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ac813279-8e83-deba-4f26-99523dd71fc2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-11
X-PR-Tracked-Commit-Id: 5576035f15dfcc6cb1cec236db40c2c0733b0ba4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e6b2b2e4f30c29caf89ecfa9ed4d9f97d151102
Message-Id: <166820499927.19426.2802702979461059620.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Nov 2022 22:16:39 +0000
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

The pull request you sent on Fri, 11 Nov 2022 13:53:04 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e6b2b2e4f30c29caf89ecfa9ed4d9f97d151102

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
