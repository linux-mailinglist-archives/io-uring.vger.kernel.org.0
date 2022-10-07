Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373525F7BEA
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJGRA3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 13:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiJGRAO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 13:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292995FAF2;
        Fri,  7 Oct 2022 10:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B0A61D85;
        Fri,  7 Oct 2022 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C99DC43145;
        Fri,  7 Oct 2022 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665162011;
        bh=ciVOqPo7yUML94fDtW3ArAF+XZoFWKwMgLaCfC4myns=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PMG7B7kp9iabWC2HV8vLkkq/Hzry/Mwlt6A/SzhFSQqLGcDFq81CzmqUo+hfnJWSD
         RA7Dn0BTjdd4VJA/M1zVmt9ZQWe/89AtkDsymSrRhzz1JDrYOSz70kQk5Eo5UOLZn4
         rIa1/FvPKkFaLs53kDJJzPBVbJV39GRzijb1jP2EJr4N2t4b6g6Kno6b0CAOuw5rj4
         HrUDjLblAbg5Qvq09yJHt6odME8D0nEPXxB4+/3XQmF36ksX1N+jZj+oj+7Y2fxZny
         P0fJw1/jYha4KENwzqu3mkyjRE0gGaDcwDoZl1RK1ivinXlAjV3VNcC5aVNkCE4LlE
         rcfGoY1mm8HfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77000E43EFD;
        Fri,  7 Oct 2022 17:00:11 +0000 (UTC)
Subject: Re: [GIT PULL] v2 Passthrough updates for 6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <8bbcb3e9-118c-ea25-a906-24aa28a6c48c@kernel.dk>
References: <8bbcb3e9-118c-ea25-a906-24aa28a6c48c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8bbcb3e9-118c-ea25-a906-24aa28a6c48c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.1/passthrough-2022-10-04
X-PR-Tracked-Commit-Id: 0e0abad2a71bcd7ba0f30e7975f5b4199ade4e60
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c989b1da3946e40bf71be00a0b401015235605a
Message-Id: <166516201148.22254.1226689172112782715.pr-tracker-bot@kernel.org>
Date:   Fri, 07 Oct 2022 17:00:11 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Tue, 4 Oct 2022 16:12:09 -0600:

> git://git.kernel.dk/linux.git tags/for-6.1/passthrough-2022-10-04

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c989b1da3946e40bf71be00a0b401015235605a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
