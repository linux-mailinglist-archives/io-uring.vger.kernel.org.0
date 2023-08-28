Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6EE78B2BA
	for <lists+io-uring@lfdr.de>; Mon, 28 Aug 2023 16:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjH1OMy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Aug 2023 10:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjH1OMc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Aug 2023 10:12:32 -0400
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624E8C7;
        Mon, 28 Aug 2023 07:11:54 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2bcbfb3705dso49558191fa.1;
        Mon, 28 Aug 2023 07:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693231873; x=1693836673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=equC6I2SNDjepCJuG/1BOECldsqNcb9Pj37RMfklZHo=;
        b=KJ2jpcGClE4Ti74bczyE5H5PqX9Ar2VkANIQ/g1FhXYKNCTZTEUs4mkhOvTHsE71xf
         EE3TiFkgM1kaFzF0dV237UGtgugs8RnvBcjmm9TLxSQoV+3BhmMx0DX23xDYajhnTOH+
         CGyNtpDPkNTYbecCQZRGhk2pS1yl8AjsNI2w+pN2re34kNReYVSdFQVAu4L5uN7g8P+2
         kjSmH5frrQKbSD+bHFqg3oxsfUfXZxQKxRo/xUYXV0zhl8GGY8+Ca65a0eplKKikD60x
         LIciUd/Rgfv8HaHUFEy1gw5uyYuGzsQAd2BdrTezO3dTj8PhNMxCmwXP7HVPkXc1J8qT
         uy1Q==
X-Gm-Message-State: AOJu0YxySIa+BMbpdKAdB0+kZ0FA3ijxhUl0tOjmK/uRBeP0YMXca7Zr
        CHSdz/cRCvX5R37DLi/zZsKY6t43IMk=
X-Google-Smtp-Source: AGHT+IE1kNuPRwLdWm1YbocXk/aiNmq5Ou+iMwFSQMaGqTCmZbFGLE7kH/u5+l1upjXf8tn6wfFHWQ==
X-Received: by 2002:a2e:8ec1:0:b0:2bb:b528:87b1 with SMTP id e1-20020a2e8ec1000000b002bbb52887b1mr17223407ljl.50.1693231872496;
        Mon, 28 Aug 2023 07:11:12 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-021.fbsv.net. [2a03:2880:31ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id us11-20020a170906bfcb00b00992b2c55c67sm4703127ejb.156.2023.08.28.07.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 07:11:11 -0700 (PDT)
Date:   Mon, 28 Aug 2023 07:11:10 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Nicholas Rosenberg <inori@vnlx.org>,
        Michael William Jonathan <moe@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH liburing v1 2/2] liburing-ffi.map: Move
 `io_uring_prep_sock_cmd()` to v2.5
Message-ID: <ZOyq/lqPoxi0o9Fd@gmail.com>
References: <20230826141734.1488852-1-ammarfaizi2@gnuweeb.org>
 <20230826141734.1488852-3-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230826141734.1488852-3-ammarfaizi2@gnuweeb.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Aug 26, 2023 at 09:17:34PM +0700, Ammar Faizi wrote:
> io_uring_prep_sock_cmd() comes after v2.4 is released, so it should go
> to v2.5.
> 
> Cc: Breno Leitao <leitao@debian.org>
> Fixes: 2459fef094113fc0e4928d9190315852bda3c03a ("io_uring_prep_cmd: Create a new helper for command ops")
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
