Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD956BF110
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 19:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCQSwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 14:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQSwn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 14:52:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DD7C796C
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 11:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89E02CE216A
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 18:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87F08C433EF;
        Fri, 17 Mar 2023 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679079158;
        bh=MgYjCzkwNRmxxHATD3r0isV6SO3LY4ypIEsIVFnj5B0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=EjzSmCfy6t0hzLyz9ok8IjD4elGLbK0K5B3J9DntfoN4RG4TtqTLhPN8vx5B+Anak
         wdegEX6KHDxbVsjfS2SmhIXp6CnFon5ZRMc1RGz7Eufi9JqlHg/paqw/xF1xjwpwjb
         VONg4WTQg6QarHC5bnh5ajySzesQPurChYrwufrKWTO+ePl9gEG9421GO1FovYxTiP
         pB3kqeXDzRw4Dxd52lRVnVN9Ucse2PjqKkG6rlgEAqek5Ibo/8ar7u/k5CdobcMIR/
         1dADoaXujFxwr6lZ+9pLerUXiLSuPuuilO68OGSvYewbCqNl91ebYQJL6BxOUQ+KIs
         YIeXQUF5p4nxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76C8EE66CBF;
        Fri, 17 Mar 2023 18:52:38 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2be663d0-1b55-5c4d-a66e-a612c1177b69@kernel.dk>
References: <2be663d0-1b55-5c4d-a66e-a612c1177b69@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2be663d0-1b55-5c4d-a66e-a612c1177b69@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-16
X-PR-Tracked-Commit-Id: d2acf789088bb562cea342b6a24e646df4d47839
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b7966a5a5cd009a682ccb0823e89f1e9fb719f27
Message-Id: <167907915848.16534.6504005580773216748.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Mar 2023 18:52:38 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 17 Mar 2023 10:52:05 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b7966a5a5cd009a682ccb0823e89f1e9fb719f27

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
