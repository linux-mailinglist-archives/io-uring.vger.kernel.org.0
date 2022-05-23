Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459D8531ABF
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiEWUmJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 16:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiEWUmE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 16:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285B7A207E
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 13:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7FA0614CB
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 20:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BB9DC385A9;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653338522;
        bh=aoNoKh2KjHXg68r7AYDIRfzyxAg2gcESBVQ4LYsXIWo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=h5rdw6QqeZvC8Zx3cFUxxuLuVXAWRASNKB3IdD84nNKoLrIcKYywTF+svSH4Gff5y
         SM6RDG3OcTmCEeQLqoIDzBm9Wu8wljhcpX+wuhiNDbDPzjtcZNvN9Dp8RjndVmSQxs
         dT87AiioOLKefVJ80EsTXatPAToPiQwBUBrmdZeg0YO2kPUjvj8IoGn53i7uEaRIGc
         AZVAHp8n/pkANt/RpGT1socbQH5t0uECqkppwaa8h5iTUt+suqgs5TWkmoP8CLazFr
         Ug76eU1EjuKp46oKaWBacufQA8Ko8c1/ey//cf+eR/BP5bc5TV/p6EYsmwB6H7f9Er
         /B0ribGObD6RA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17BF8F03935;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring core updates for 5.19-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6003da99-86f6-df03-7e21-a80e82d52f66@kernel.dk>
References: <6003da99-86f6-df03-7e21-a80e82d52f66@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6003da99-86f6-df03-7e21-a80e82d52f66@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-2022-05-22
X-PR-Tracked-Commit-Id: 0e7579ca732a39cc377e17509dda9bfc4f6ba78e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a166bdbf3abc8ca2d7ffe7cffc5c7a65f260e62
Message-Id: <165333852209.17690.7224119202050224093.pr-tracker-bot@kernel.org>
Date:   Mon, 23 May 2022 20:42:02 +0000
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

The pull request you sent on Sun, 22 May 2022 15:25:56 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-2022-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a166bdbf3abc8ca2d7ffe7cffc5c7a65f260e62

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
