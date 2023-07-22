Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B032D75DE0B
	for <lists+io-uring@lfdr.de>; Sat, 22 Jul 2023 20:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjGVSQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Jul 2023 14:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjGVSQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Jul 2023 14:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12EB26B5
        for <io-uring@vger.kernel.org>; Sat, 22 Jul 2023 11:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F05360B96
        for <io-uring@vger.kernel.org>; Sat, 22 Jul 2023 18:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1162C433C7;
        Sat, 22 Jul 2023 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690049791;
        bh=7CaAZ6OSqNcoMJfTZ98PLfmmJZebge4VX90hmRyxMF0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ru+hrw+8FS5jNc2o0ztoXmDTo8Qc8AP7DWg7dTOXjNr8RM8EL8zcOLepmI+o6n8Al
         SjOURaa/Tsv1/nxpf16EJ6T8sxCK/G66mvfiC7adHsGzI6RLs37+q34GVf5LgShH40
         f4JK7SncufbJpvR0f9SShFhjjXI1yZCB8r1RZAMKw8LoVOQq8bqko0KGzHo5xCR6Bn
         yQPh0q7Vqml2ifR48PEvprt5T0bBVFSP6JMPYjtfInse7Uu72MFAqgVBgDdcWwvtiD
         oLQqByiE9wtHzNbYjbDTPule492sEgjWof8tpiHw2XXBxD4RKpGLfVvdAXvuFNSO9j
         u4P2e9VVFSypQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC1B3C595C0;
        Sat, 22 Jul 2023 18:16:31 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.5-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c8a325c8-d8af-4592-5a17-7f7c17ca6d57@kernel.dk>
References: <c8a325c8-d8af-4592-5a17-7f7c17ca6d57@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c8a325c8-d8af-4592-5a17-7f7c17ca6d57@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-21
X-PR-Tracked-Commit-Id: 07e981137f17e5275b6fa5fd0c28b0ddb4519702
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bdd1d82e7d02bd2764a68a5cc54533dfc2ba452a
Message-Id: <169004979169.7625.13745343761287869790.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Jul 2023 18:16:31 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 21 Jul 2023 13:34:11 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bdd1d82e7d02bd2764a68a5cc54533dfc2ba452a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
