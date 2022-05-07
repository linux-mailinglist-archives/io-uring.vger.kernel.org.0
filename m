Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8521351E917
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 20:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446776AbiEGSPm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 14:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446773AbiEGSPm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 14:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8D32ED67
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 11:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECFB861384
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 18:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58ECBC385A6;
        Sat,  7 May 2022 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651947114;
        bh=gFK3csdGl2V8fOX5arqjCZyKx67LOPc28F0wC1t8gls=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MqZHM3AbFffowoRfA5V7kF0gRJluhDds889/nhBAwLwwIzyDDwwCdqCe0hVvhqEoB
         68cQyrBNdlnECDEDNDod08ksrFagQ8inbdFOhthqK6SPfN7se7vILBFycRRET9H4Li
         kKDPK+ONRtYy99JC/KXZdmSkM98XNUqpawGHv4ydzFtwN9kCA0qRb7+qvO7Mlgx402
         Xvn4FCp3y7N+8mGi48YbpcyCr2ZCT9IRlp97o2NzpdggyLH61kqZbZsMJNwKwWaxOi
         kaDttS1jpTaM93HtLNR9lwL2BPzWk8tdzCybt/S/b17c+kk/k4Vkb6cDWIN+I5vuyr
         6aIRgkT3L6MVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44374E8DBBF;
        Sat,  7 May 2022 18:11:54 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.18-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <f492cd49-43e6-b66d-d7bb-958eb717e569@kernel.dk>
References: <f492cd49-43e6-b66d-d7bb-958eb717e569@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f492cd49-43e6-b66d-d7bb-958eb717e569@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-05-06
X-PR-Tracked-Commit-Id: a196c78b5443fc61af2c0490213b9d125482cbd1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b366bd7d9613971e666cdbfe7a08c653d329bf15
Message-Id: <165194711427.12019.376486894132979784.pr-tracker-bot@kernel.org>
Date:   Sat, 07 May 2022 18:11:54 +0000
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

The pull request you sent on Fri, 6 May 2022 20:10:52 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-05-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b366bd7d9613971e666cdbfe7a08c653d329bf15

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
