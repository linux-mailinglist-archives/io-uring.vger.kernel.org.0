Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81053D1C0
	for <lists+io-uring@lfdr.de>; Fri,  3 Jun 2022 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346145AbiFCSuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jun 2022 14:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349237AbiFCSuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jun 2022 14:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26EC286E4
        for <io-uring@vger.kernel.org>; Fri,  3 Jun 2022 11:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2886CB8214F
        for <io-uring@vger.kernel.org>; Fri,  3 Jun 2022 18:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8A74C385A9;
        Fri,  3 Jun 2022 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654282216;
        bh=Jw+uGeNBANUuI7VaBkOor+ddwPUmIlBTvba+2hL03nw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gqScl9yyLTl8I0sAB56DERknZkVl7IkeUv2z3Rb+u/+ipeOprnsVYezfSTiIpra1O
         EZRBJbjiPwC2BPczn9kn4WU/+hXMDZaLhWsXrT82sWXpQax8nXOkgth0FNWsgEjeQR
         80D4RX47/b4a4UipJHt75xo/Cd73kAIV6JoFak/bfZnXa1dVGvlFywkTFODYcVn3G+
         nKUpqR6Olmpff+QLjDDKeK03StSEluSEy9eFqVLnmQK0BY3rje9qKvr172ow0Zv9xW
         7gdEXszgnk5zoBKFE6/jambmbw23HFeDbjEAyC9dC1bIg0o82ziwywDj0JEadrcyXu
         NLieGCbmKzTTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C57C1F0394E;
        Fri,  3 Jun 2022 18:50:16 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring changes and fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <bd16e13c-8260-c1c9-88b4-8756e0142f46@kernel.dk>
References: <bd16e13c-8260-c1c9-88b4-8756e0142f46@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <bd16e13c-8260-c1c9-88b4-8756e0142f46@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-02
X-PR-Tracked-Commit-Id: 9cae36a094e7e9d6e5fe8b6dcd4642138b3eb0c7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ac8bdb9ad47334a9590e29daf7e4149b0a34729
Message-Id: <165428221680.10974.7840052472336559942.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Jun 2022 18:50:16 +0000
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

The pull request you sent on Thu, 2 Jun 2022 23:26:12 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ac8bdb9ad47334a9590e29daf7e4149b0a34729

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
