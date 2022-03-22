Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB94E359B
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 01:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiCVA1k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 20:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiCVA1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 20:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CE03268DF
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 17:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C731615AA
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 00:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2A9CC340E8;
        Tue, 22 Mar 2022 00:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647908750;
        bh=7CQlBpF2kNz4+lg0sq2bNdwz4EREhBkmOy12oGlFzI0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=EgvYGDGCqnoN05/jmUTKSqiAkx9rEe33rL8bigho1kQvVqidR0eHwc+KywheC0JuK
         t3xmu3cMR5UjfoJyK9OWGf25c+uZPEsQtfOsIxqSKlygvatWpVeWXIRm22VI0fKiUH
         LI2f3w8L7Sdaj/UPupDk0bywo0CljCqIopjJySrIJ6eTolPe4XjHrosO1aos5ALcnv
         oqJVOHSmqwPpBKb39zaHpeYAdl6GFGTAW2rDtbZKZ1hzLly6p5oJY5bVFWJJa0oXLJ
         oX32CmCChE+yhwGgronTm7tDKQORd0oRFTiyqn5tdzkn6a19VC8qz7nPAHpBlptIeL
         dPMWzSwmMlvGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D042FE6D44B;
        Tue, 22 Mar 2022 00:25:50 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-2022-03-18
X-PR-Tracked-Commit-Id: 5e929367468c8f97cd1ffb0417316cecfebef94b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af472a9efdf65cbb3398cb6478ec0e89fbc84109
Message-Id: <164790875084.30750.15302509756909285272.pr-tracker-bot@kernel.org>
Date:   Tue, 22 Mar 2022 00:25:50 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 18 Mar 2022 15:59:16 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-2022-03-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af472a9efdf65cbb3398cb6478ec0e89fbc84109

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
