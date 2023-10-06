Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67A37BC281
	for <lists+io-uring@lfdr.de>; Sat,  7 Oct 2023 00:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjJFWvU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Oct 2023 18:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjJFWvT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Oct 2023 18:51:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0788B93
        for <io-uring@vger.kernel.org>; Fri,  6 Oct 2023 15:51:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90D4CC433C7;
        Fri,  6 Oct 2023 22:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696632677;
        bh=ogpVEmYhLADXcOdXKC5QBo1NwQrJDoyvBRLjgPic/SE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cjmXep4Jsh4OMN83e0yA8PJcxFLs5yrzZYO17LQfOYnCmpRzDqIzFGosgvXzcaXvU
         uDOgerZm6yKd2BIT43lnWmrJ5kRGPHrX/CTus+OzNgxTFNuhQpgZc235docRuJOGi9
         7ti+RE7MAVuOb3+yQ95QiXz0nSl7lQskkEXew37DhJ58HhqAkYAIjmD+FM0+yBc4JH
         HTqVl8vwv4zOgiN8qywS3Cu0h/DHWRfDcXpETDNP6slI5e1ml+bofe7tRSfcEBvy8S
         11Qiq9j8T09zwWqHvTqH9IAkxxRxSQncMLTPcwbS60UpTafaD3PxolwM53e+55JhJY
         PxgpizhAFyLDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E7A3E632D2;
        Fri,  6 Oct 2023 22:51:17 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.6-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <18e5bd5d-9d70-4880-ba26-a72b0e5b6a57@kernel.dk>
References: <18e5bd5d-9d70-4880-ba26-a72b0e5b6a57@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <18e5bd5d-9d70-4880-ba26-a72b0e5b6a57@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-06
X-PR-Tracked-Commit-Id: 0f8baa3c9802fbfe313c901e1598397b61b91ada
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a88c38694714f70b2bc72f33ca125bf06c0f62f2
Message-Id: <169663267751.26682.8390297428612005824.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Oct 2023 22:51:17 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 6 Oct 2023 10:36:02 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a88c38694714f70b2bc72f33ca125bf06c0f62f2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
