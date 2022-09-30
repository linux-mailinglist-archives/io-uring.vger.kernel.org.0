Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186915F1025
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 18:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiI3Qi2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 12:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiI3QiZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 12:38:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28579176AF9
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 09:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C16623A8
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 16:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29836C433C1;
        Fri, 30 Sep 2022 16:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555904;
        bh=/DvJ53wa6abgTkZmeHY4u1MWg6oPwprO/qg0EVWpjeQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=q+SB2lZCf8Q0h3tRyhezLhhPcFrt+18Hw5F2WQIqkQSRgDZhG6h6350CcUg139laT
         5ne24utsJtHJ7phJ7lEwgd+8hCiFyAwQnz6CsYKZzukWFqFovsJGkMmY4C/iaviR05
         9Q0gm+hb8cHN2aM0/q4+KJGm6oqcJT6QOoYOL5HJRvNCA/4ECrxfPlvVrPCyY2qYXr
         b2MMFpUWFf0tfQYrdY8R4uyKnsdd99b8Hlw3/9ZNv1/OkEqg35QzN84TXp+Jex6XeP
         MUD7voZrpYd8T9sDIuZRjqVRvSEXvm3M1VEyI+hMLlG1IvEBmfPuekyDa5Gd5jcktA
         GRecOU+nne3Eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15FA8C4167A;
        Fri, 30 Sep 2022 16:38:24 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <5c6d5c40-8ec8-a54e-97f8-d2377515656b@kernel.dk>
References: <5c6d5c40-8ec8-a54e-97f8-d2377515656b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5c6d5c40-8ec8-a54e-97f8-d2377515656b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-29
X-PR-Tracked-Commit-Id: d59bd748db0a97a5d6a33b284b6c58b7f6f4f768
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a0debc4c7a7e1a4adf0866b105e9e4f29002c2ca
Message-Id: <166455590408.13600.430957730413208142.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Sep 2022 16:38:24 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 30 Sep 2022 07:43:00 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a0debc4c7a7e1a4adf0866b105e9e4f29002c2ca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
