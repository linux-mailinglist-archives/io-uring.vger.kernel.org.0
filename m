Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53C15768FC
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 23:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiGOVhZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 17:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiGOVhZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 17:37:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793E2868BF;
        Fri, 15 Jul 2022 14:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aLK1t9GhAjMei60rnYyortl9gHs4JAWuHopIYIhRu+g=; b=SbRxlZS9GJxZiAGRHooaWTHhNY
        t9N/w1sx1YPzgawH+7Lh9RH2FZVBgXuEISY4DI7LUcqvXSgL571d490626suoLNtowmfRXjYhvbSN
        O5zjyMJM2PZNzB2RkYJVO5KIs8oh6YGNTc1Ma+BhY7prd2lBiLyaVJL1oO+etXLubYWLpIi/FVCB+
        5hkkumrcoxZKD41+X7gEDOQMc7mLqOGPS0WkJxuHAy1JaL5tnh/MTypVugLb8gV5cboyTB6veKbLS
        jgBc4xf0rK7CTr28qWC4mEZBPHsHZ0lpsZawx82zwh6y3jvRR4Ez0SQXZCDH1vfVetZc7pTKAzCnP
        lLfDNIwg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oCSzt-00AU7v-Mw; Fri, 15 Jul 2022 21:37:17 +0000
Date:   Fri, 15 Jul 2022 14:37:17 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Paul Moore <paul@paul-moore.com>, casey@schaufler-ca.com,
        joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd
 file op
Message-ID: <YtHeDa+rqXCFsd97@bombadil.infradead.org>
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <a91fdbe3-fe01-c534-29ee-f05056ffd74f@kernel.dk>
 <CAHC9VhRCW4PFwmwyAYxYmLUDuY-agHm1CejBZJUpHTVbZE8L1Q@mail.gmail.com>
 <711b10ab-4ac7-e82f-e125-658460acda89@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <711b10ab-4ac7-e82f-e125-658460acda89@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 15, 2022 at 02:00:36PM -0600, Jens Axboe wrote:
> I did author the basic framework of it, but Kanchan took over driving it
> to completion and was the one doing the posting of it at that point.

And credit where due, that was a significant undertaking, and great
collaboration.

> It's not like I merge code I'm not aware of, we even discussed it at
> LSFMM this year and nobody brought up the LSM oversight. Luis was there
> too I believe.

I brought it up as a priority to Kanchan then. I cringed at not seeing it
addressed, but as with a lot of development, some things get punted for
'eventually'. What I think we need is more awareness of the importance of
addressing LSMs and making this a real top priority, not just, 'sure',
or 'eventually'. Without that wide awareness even those aware of its
importance cannot help make LSM considerations a tangible priority.

We can do this with ksummit, or whatever that's called these days,
because just doing this at security conferences is just getting people
preaching to the choir.

We can also do this through sessions at different companies.

  Luis
