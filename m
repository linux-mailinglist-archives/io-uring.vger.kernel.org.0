Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012DB54FCE2
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiFQS0f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 14:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbiFQS0e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 14:26:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FA52F027
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 11:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BEA1CE2CE0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 18:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 694E4C341C0;
        Fri, 17 Jun 2022 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655490390;
        bh=p7BTn2jnKXZrvYfEa75zfWNPXud97YwKrCu6AbwsydE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bSI3Omiz4T+pRKL5kmZgHRbeC/KOoR9ISaRUBX+4woqdhnWDEV0tOzLGSPTXeCCkW
         AO+1hCdiHXlIAViYQO27hKviT1rhA2PLBruWouTynHTAUp+2CMLCfIEwBgihaPjtKR
         O5/G62PGFFX/7+CJCotoyJYoJKRm3GDGRYMZx41bEInfew4H3+g50oYi/qKMdq2yXw
         laviVJlL0CcAFnt71i9dw3YwCARgL8UWolghnM8YjTqAvZTGIqBJjQ0ncRss3ECGY0
         Euo8AI4gsprVtGJWqjBTecboSrHUIBYoHQCL+1lyj73ZS+qx+U30srYIEW2BBMmdG7
         cN+E8wGuasatw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55694E73877;
        Fri, 17 Jun 2022 18:26:30 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.19-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c8201cac-5f91-27ca-a530-f9356a520c28@kernel.dk>
References: <c8201cac-5f91-27ca-a530-f9356a520c28@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c8201cac-5f91-27ca-a530-f9356a520c28@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-16
X-PR-Tracked-Commit-Id: 6436c770f120a9ffeb4e791650467f30f1d062d1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f8e174c3071dc7614b2a6aa41494b2756d0cd93d
Message-Id: <165549039034.23060.1649691400503088211.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Jun 2022 18:26:30 +0000
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

The pull request you sent on Fri, 17 Jun 2022 11:08:24 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f8e174c3071dc7614b2a6aa41494b2756d0cd93d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
