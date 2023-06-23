Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9663773AE27
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 03:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjFWBDn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 21:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjFWBDm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 21:03:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C64E7D
        for <io-uring@vger.kernel.org>; Thu, 22 Jun 2023 18:03:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC8F9618CD
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 01:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D988C433C9;
        Fri, 23 Jun 2023 01:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687482220;
        bh=dke4wmHsf+oevsBbNKYwDVbB+Ld7k9LVKYiLwfevcp0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kwB5MAAby8O/58hADt1ceIkuymzsQi8psE+VnC1XInRNG0F7DQh5+h8e1J39y9+qV
         rWiw98laic0f3vppNIsTQLilujbgql1n+nSvrPRQB/rc9uaGeF7Q6BbyFREkNAQu9n
         41rxXvJMWLVqIJT+l15b+UPDavwskw3IYWvE7qdF8L5bRGSpXQvQ4ngRSyHh++/OW+
         yiWkaFvBH3AkJhzMPLwGmMRsP6TAxmb82UeRyMNxdbOf8r7Uqy8zEO6J+Y+eDtqHzT
         9OlqVLPNvhoFh7B4EhbahNAEPRUFsBbO3V2k+iHqXCny/diY2iFo/heLoXPym7WT69
         qVldrJQgveq4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B3E3C395F1;
        Fri, 23 Jun 2023 01:03:40 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.4-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <5076b757-3858-ed2d-4855-f2d59e4fc76a@kernel.dk>
References: <5076b757-3858-ed2d-4855-f2d59e4fc76a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5076b757-3858-ed2d-4855-f2d59e4fc76a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-21
X-PR-Tracked-Commit-Id: 26fed83653d0154704cadb7afc418f315c7ac1f0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c213de632f7ae293409051733d24c7c6afc15292
Message-Id: <168748222023.12146.5314333601332107646.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Jun 2023 01:03:40 +0000
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

The pull request you sent on Wed, 21 Jun 2023 20:19:04 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c213de632f7ae293409051733d24c7c6afc15292

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
