Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1752C8A7
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 02:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiESAf1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 20:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiESAfZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 20:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03E8CE31
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 17:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0356171E
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 00:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4342C385A5;
        Thu, 19 May 2022 00:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652920523;
        bh=vxedWSOg9J8MwfCmTfLWGwtH7Sz0423nQEHPGLF06E8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qNuoh1CGP6NmyitmLvAoDmGvU5M1dobusrkbb9vKngPAGZ9vFusewwaeZPVJ8PE87
         WtWrSl+EyahuPKXHd4Y4QJ32WnPSie3NqS5m9X0rqK6C9ImpwdPGNHVBxepv4G30Rv
         4IJmOcdllM6hjaf3p6pR6wT2Wiv2NzBGXZvSybSWK/8DT/vzx+0cE813mzD/U4CZ40
         WKfpBFxkFM5LZTbwNYRtF54iLrk9PZUUptuqZIYWHBy/P+/CKEHXViwdaizDhv31ZU
         dP0mCIz2nMhtkr1o36Pc4rmWEOS+d5WbuWW9XNJJN/5Aq5SVhwTijnKSAlN59hEwT3
         7jrMBA8rdM17w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2C32F0392C;
        Thu, 19 May 2022 00:35:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.18-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4db3b8db-7fea-f366-0c55-a5a68c6cc0ec@kernel.dk>
References: <4db3b8db-7fea-f366-0c55-a5a68c6cc0ec@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4db3b8db-7fea-f366-0c55-a5a68c6cc0ec@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-05-18
X-PR-Tracked-Commit-Id: aa184e8671f0f911fc2fb3f68cd506e4d7838faa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 01464a73a6387b45aa4cf6ea522abd4f9e44dce5
Message-Id: <165292052372.29647.2255525474087813677.pr-tracker-bot@kernel.org>
Date:   Thu, 19 May 2022 00:35:23 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Wed, 18 May 2022 17:11:47 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-05-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/01464a73a6387b45aa4cf6ea522abd4f9e44dce5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
