Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7376668ADB5
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 01:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBEA4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Feb 2023 19:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEA4t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Feb 2023 19:56:49 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7822A1D
        for <io-uring@vger.kernel.org>; Sat,  4 Feb 2023 16:56:48 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id EA65C83002;
        Sun,  5 Feb 2023 00:56:46 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675558608;
        bh=3JogzhmrwYuQO9ZEOJRlojOaZGokM6qq4w1PVToYJyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhFN+/KUTzTqNBaAanV9APp/JHgjIXQYKW43nkciL4oT4dqyqstbKs/bTvv0W1N6G
         WDVxfvgZLie2UbgwVUmxjaIDJS+waz0YfNfye18SUuP9ep7seoDoII7ArtXJYUvuHW
         eAIyILDGO795+QD88O/tWrRP+Taqv7ofcrPozPi495njAZm+bXwwWDZPMgvWL5Q0ND
         6i7Z8fMi3JwnNUB3Mg9n6UXTkKxuYJisnF3BSKMMLghG+c01Qnhj9T6kqGn5JRaVW3
         I8YO92n8z8SQjpLfbtKB5ucaCcv3WvK3+52xnhW/irr4AR7jeTLRbJcadvX5P+i6vD
         qMVSD/L5z2+/Q==
Date:   Sun, 5 Feb 2023 07:56:43 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 2/4] liburing: add documentation for new napi busy
 polling
Message-ID: <Y97+ywg/Icyw9fLH@biznet-home.integral.gnuweeb.org>
References: <20230205002424.102422-1-shr@devkernel.io>
 <20230205002424.102422-3-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205002424.102422-3-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 04, 2023 at 04:24:22PM -0800, Stefan Roesch wrote:
> +The
> +.BR io_uring_register_napi (3)
> +function registers the NAPI settings for subsequent operations. The NAPI
> +settings are specified in the structure that is passed in the
> +.I napi
> +parameter. The structure consists of the napi timeout
> +.I busy_poll_to
> +(napi busy poll timeout in us) and
> +.I prefer_busy_poll.

nit: That "period" after "prefer_busy_poll" will be underlined if you
write it that way. It would be better if you write:

   .IR prefer_busy_poll .

so that the dot is not underlined when you open that manpage from a
terminal. But not a big deal..

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

