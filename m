Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1DF68ADAB
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 01:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBEArJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Feb 2023 19:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBEArJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Feb 2023 19:47:09 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACEA20D1A
        for <io-uring@vger.kernel.org>; Sat,  4 Feb 2023 16:47:07 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 4BA4781F44;
        Sun,  5 Feb 2023 00:47:05 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675558027;
        bh=pG6fAnfOXPg98lUhX6WB+bvKXxgZ0gNfxnX5hkOnqh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahJsnLuiYYp81wgt72RWt9ophqRdEaom1qQjicgmcLoudE2Gxh9jzNkXxkCD0eEoC
         t++8QL6of8ATKCpIi23ZwIoMPw1XA/tmlHNZou5AL2JE4SPIz72J7r5slFk3XM55Fi
         /M7h6sQ2bvo9mBycGqp3rS0E8zZ0xdynpXFAzoJ2BfobrUJX/rIGWK+xo4d1/bObTD
         B9Mw2YDJ9RB5ZQEn/gxGU19YrCgBiD2F8ZVWSh+DTsviMjLAuNTfDITWO1BvJ1mFLe
         EHaArR3Nc3A7i/SDjF9K4UgQBepSMmNlfzgUsTTLgP0tkwVcrej0eqEOo+8KOp44tP
         Mg+O2OVtx1Lxw==
Date:   Sun, 5 Feb 2023 07:47:01 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 1/4] liburing: add api to set napi busy poll settings
Message-ID: <Y978hWpvNEgsC2+p@biznet-home.integral.gnuweeb.org>
References: <20230205002424.102422-1-shr@devkernel.io>
 <20230205002424.102422-2-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205002424.102422-2-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 04, 2023 at 04:24:21PM -0800, Stefan Roesch wrote:
> diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
> index cebf882..000546c 100644
> --- a/src/liburing-ffi.map
> +++ b/src/liburing-ffi.map
> @@ -166,6 +166,8 @@ LIBURING_2.4 {
>  		io_uring_prep_recv;
>  		io_uring_prep_msg_ring_cqe_flags;
>  		io_uring_prep_msg_ring_fd;
> +        io_uring_register_napi;
> +        io_uring_unregister_napi;
>  	local:
>  		*;
>  };

Use tab for indentation. Not spaces. With that fixed:

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

