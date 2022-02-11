Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4424B2E38
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353162AbiBKUFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 15:05:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353136AbiBKUFX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 15:05:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC2BCE5
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 12:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC0A261FD6
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 20:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17B21C340F7;
        Fri, 11 Feb 2022 20:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644609921;
        bh=Xr0eg1NAHeSvwS+nfJH/lC4d0NairnZQho+qCaHbAyw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ekIOBuqWWuGbFfAexzs92ccDNPWmpLNapiJFKh7oET/Xc0/V7U/aUwnqJ15GzEyWS
         O6uE2krVldnqGEuaVH0IM9xoPECdUUOoc6uJCezk3fVTTTIedGaF/AuUv2ptNrjgAy
         wAmPDYioJF6SUioe8pUSwqlY/GKMlxgYQCp4UyDh3eLVX9XDkz/kNpOTtP9LBw/46E
         8xNaV/j/IOjPDAm6IO6MOHOeP11dCFiTmha6C/mczDlP6KoWheRN+qo8ENbznylxZA
         JschXo9o9qNyGk02xQZm7Zlgn3LpAmbisa1zxmhqhVppEqKutWTItOBMNTXJEJCykG
         eEUIdKGqbXBlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 052F3E6BBD2;
        Fri, 11 Feb 2022 20:05:21 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.17-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <bdc1cfce-e78b-bf75-de0a-77e13116e710@kernel.dk>
References: <bdc1cfce-e78b-bf75-de0a-77e13116e710@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <bdc1cfce-e78b-bf75-de0a-77e13116e710@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-02-11
X-PR-Tracked-Commit-Id: 0a3f1e0beacf6cc8ae5f846b0641c1df476e83d6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 199b7f84c428d90e1858dafa583f7b1d587cbeb8
Message-Id: <164460992101.1412.12478648606269035084.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Feb 2022 20:05:21 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 11 Feb 2022 09:49:06 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-02-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/199b7f84c428d90e1858dafa583f7b1d587cbeb8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
