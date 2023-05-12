Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C5C701215
	for <lists+io-uring@lfdr.de>; Sat, 13 May 2023 00:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbjELWOW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 May 2023 18:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240017AbjELWOS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 May 2023 18:14:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6DA198B
        for <io-uring@vger.kernel.org>; Fri, 12 May 2023 15:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3980634FA
        for <io-uring@vger.kernel.org>; Fri, 12 May 2023 22:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65ABDC433EF;
        Fri, 12 May 2023 22:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683929656;
        bh=+k/kmD4S1n6MEei7747m+HVT2UNFF6iiE9AXAzmCPpo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=chLXbq6f9nzWECl/uYfoIhyjNlxJ/hnKvu4BgQaFab+av08J7vgRQVnwxYgVeum0L
         v3VzlJanxDxhiW+bGz57rhh1oH8xQsWKlpk0vcOKumBKqRw3hGGCZj9tTo4TOP/ioV
         QdLNUjND/CYhCnn/EUhpZfUHePeWWTXJ2SA7kRxCvgUdnZ54Rah8Ra3Pi1/G3s0+Kl
         OEgWU8oaZ/ve7Xwxj/v9em6i9ZDSAKiDD06zyRQE42jvDuMKOOIBXS0qcITnTirNaU
         Dt+Nq5HLHYjSeJ3hsISW42GmXtnHjvVDfFwQ5SF61EuOzBKTep5UDGxeQEDBE165zb
         PsshbP0A6OvOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 518ECE26D2A;
        Fri, 12 May 2023 22:14:16 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.4-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ddd808a0-f4a6-b002-f978-d6f04ccae10c@kernel.dk>
References: <ddd808a0-f4a6-b002-f978-d6f04ccae10c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ddd808a0-f4a6-b002-f978-d6f04ccae10c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-05-12
X-PR-Tracked-Commit-Id: 293007b033418c8c9d1b35d68dec49a500750fde
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 584dc5dbcbcca71cc7ccce9077a1456842c26179
Message-Id: <168392965632.28473.2025620387427218738.pr-tracker-bot@kernel.org>
Date:   Fri, 12 May 2023 22:14:16 +0000
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

The pull request you sent on Fri, 12 May 2023 11:52:20 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-05-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/584dc5dbcbcca71cc7ccce9077a1456842c26179

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
