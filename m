Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA28733A00
	for <lists+io-uring@lfdr.de>; Fri, 16 Jun 2023 21:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345886AbjFPTfn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jun 2023 15:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346270AbjFPTfj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Jun 2023 15:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586383A87
        for <io-uring@vger.kernel.org>; Fri, 16 Jun 2023 12:35:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 773CA62A85
        for <io-uring@vger.kernel.org>; Fri, 16 Jun 2023 19:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9583C433B8;
        Fri, 16 Jun 2023 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686944131;
        bh=Uiq0+s2YiqdDxdAuWIQHfCP0JUpc/RZMKQWE4fV8u4k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Dvukh69UhpsBgBTKgYwyzsXcrHQSJldjypjuuBbmquH6doLf50FDeIBQBsEgO8wbS
         uEk5U3lU1n47OlYWOZ7NQSGqHh8zVxtuJaGxWBShUh56KKfsu9U1AWjSok0ydw8o/p
         3d84Ze340BziJSd2cH81ziMJixuyFnfgtiwKr3TMy0SeqirCxb2nX39rMyp4iHsvxo
         yrqypQuEr2pa74lwzpPLlruqrOi4815KBk+UVbsjyhd67/c2crdVIQtDV6AOiz0aOy
         ZGyI3tFayL7JvGQtbswuVI/f3ET38sdrzIf20+mkYiJvxyAIDfuVgP8N4yuhJhOH1f
         0/h1XE+WqNg7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6F82C395E0;
        Fri, 16 Jun 2023 19:35:31 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.4-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <d2d1c92b-e682-9fbb-120b-23a8726c142d@kernel.dk>
References: <d2d1c92b-e682-9fbb-120b-23a8726c142d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d2d1c92b-e682-9fbb-120b-23a8726c142d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-15
X-PR-Tracked-Commit-Id: adeaa3f290ecf7f6a6a5c53219a4686cbdff5fbd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a12faba95f99d166a18588fa9b2b2df99eb1146
Message-Id: <168694413181.25417.1732936709260947123.pr-tracker-bot@kernel.org>
Date:   Fri, 16 Jun 2023 19:35:31 +0000
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

The pull request you sent on Fri, 16 Jun 2023 10:12:03 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a12faba95f99d166a18588fa9b2b2df99eb1146

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
