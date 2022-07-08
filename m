Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7756C100
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbiGHSfo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbiGHSfo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:35:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453B51CFDD
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDD0B825BD
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 18:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CEDFC341C0;
        Fri,  8 Jul 2022 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657305340;
        bh=oC2a8TQPjq6MkJQpj+jqG33OlxEAIF0KHapFeXlnbNs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ocsQBvZl6hswdIspPem1IZ9nIoSF1BLTZQV8YXjxg3b8yApF8WTh2V6RuF9hA4gYW
         69K9N79xZwsu66reYzqUl/LObl6L60NYCUcQ+EnXIOz9lIjlTBLoL38YusBCHwRFxz
         Vs45d0TdXjTKJJG/LFb21AsjQ+FJZWHi+vUwgpl7CApc2CyXjf+4LWvsCDSVKx0saC
         wpqD5krdJsPK83gxWci8R9HWxRhVK3HmdfhpomCrhjaXSYobME+gNlsE7dl108MZP4
         PhVTIY/xLySf4iVrKcrH4TlHGe7yh+tXaOQjVDl4yc/R5mPrQvRbkoPEz404VgSRbr
         6ZNC+vitQt2KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8BA77E45BDB;
        Fri,  8 Jul 2022 18:35:40 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring tweak for 5.19-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <bcefaf51-69bc-ac57-972e-9419ef3d6f8a@kernel.dk>
References: <bcefaf51-69bc-ac57-972e-9419ef3d6f8a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <bcefaf51-69bc-ac57-972e-9419ef3d6f8a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-08
X-PR-Tracked-Commit-Id: bdb2c48e4b38e6dbe82533b437468999ba3ae498
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 29837019d5ebb80a5f180af3107a0645c731a770
Message-Id: <165730534056.9073.9155727923233750436.pr-tracker-bot@kernel.org>
Date:   Fri, 08 Jul 2022 18:35:40 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 8 Jul 2022 06:47:35 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/29837019d5ebb80a5f180af3107a0645c731a770

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
