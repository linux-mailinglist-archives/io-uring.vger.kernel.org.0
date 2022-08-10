Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FBE58ECB7
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 15:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiHJNDq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 09:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiHJND3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 09:03:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8174D6CD25
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 06:03:28 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b133so13659354pfb.6
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 06:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=8ZVY3vqJaOknIHtjrvYyPFFYELYkd0zklixgN03Ylp0=;
        b=o33nKyqANzON6RcliH0U2/ZKnMVR89wYj7ffyTUXWKtjD7utvDofPfrhd8AkGKxBn2
         vKhD+ThjHE9wMpoGB5zc8o+d8YxwpW+HEy4XObFBX9B/3YxEEroKj1iepv4JI/Bu5S6o
         28sz7ZvzEFDjbZUVKnZt50K15/e+lzGqPaUG9D6OMLsgjeHGw3WmF38i5v4oRruJHkjr
         sRujBqq7dTAqVk6l4p2Ij81Ee7nOdD7Eg793TVpIIhaeROrYMfgD0vrglRdCum/KLy8T
         69dsm34/FiP8QkE9uQgUNW+glHtcKl3BzBs4yJ/CgW27bNfyrLXzXDiImskMQ3ZVPEpS
         zcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=8ZVY3vqJaOknIHtjrvYyPFFYELYkd0zklixgN03Ylp0=;
        b=We4h/rn749U3vs2dI9dUQy9w5xfsW5d1SadaBxCYNYvWTBV0AS3EV10doxpHepStnR
         Xq/vtu7fv12Eo7LwQcOs64j5hkjfbBeuPKPuumwnSYxAZcS/Ftp4YcV1/u8no/rsmfLy
         OlEvN0snV+nEUhZbtc4e/1CkC3m/8Sfa9/6q1TcjQbBOGaDSVJhpy7voyRKzXiz93Ec4
         RPDn1Iz5B2Bs6wGd2pNNRV3rTHZz9Y3lPX8C/kPLdtbk2uG6885FfisP6nfdlex3Ribx
         pUCAstwN/VUri/u6k32TY79nwe8sNOZR7xmYe68jelAdXoTZcS7JiNvKW6/XhGlR2YGP
         2s7Q==
X-Gm-Message-State: ACgBeo22fa2Rjt2symEPHWIuuCKTKfsr0GtoMrpG1+HooLNO52whvk30
        Y/mYOCzSr6v2slCllX3GQDtZEg==
X-Google-Smtp-Source: AA6agR5CPxkURBPr9JxamqOzDk4pwfi3LYkTs/dxpzl/IHgtJWcM1iGL2AixdxCs9pvVUfCHpXvhFg==
X-Received: by 2002:a63:2cc6:0:b0:41c:5f9c:e15c with SMTP id s189-20020a632cc6000000b0041c5f9ce15cmr22740824pgs.241.1660136607014;
        Wed, 10 Aug 2022 06:03:27 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h2-20020aa79f42000000b005281d926733sm1855589pfr.199.2022.08.10.06.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:03:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     knscarlet@gnuweeb.org, vt@altlinux.org, io-uring@vger.kernel.org,
        gwml@vger.gnuweeb.org, fernandafmr12@gnuweeb.org
In-Reply-To: <20220810002735.2260172-1-ammar.faizi@intel.com>
References: <20220810002735.2260172-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1 00/10] liburing test fixes
Message-Id: <166013660588.2208282.14986932103707512836.b4-ty@kernel.dk>
Date:   Wed, 10 Aug 2022 07:03:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 10 Aug 2022 07:31:49 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> All test fixes of "reading uninitialized memory" bug. Mostly just a
> one liner change.
> 
> [...]

Applied, thanks!

[01/10] test/cq-overflow: Don't call `io_uring_queue_exit()` if the ring is not initialized
        commit: f5c96cb63b6f412e08b41d6cb8188da1535e70cd
[02/10] test/eeed8b54e0df: Initialize the `malloc()`ed buffer before `write()`
        commit: 397f5444bc442e566dd826466048a428f066a1eb
[03/10] test/file-verify: Fix reading from uninitialized buffer
        commit: d8efaf3df0abbda513af142da3ee6ff41955bdda
[04/10] test/fixed-reuse: Fix reading from uninitialized array
        commit: e1b740d46b08766da9d1dfe9ce88f051a238724e
[05/10] test/fpos: Fix reading from uninitialized buffer
        commit: 5ce220568c07b34766b5410e4cfee7ccd672e33b
[06/10] test/statx: Fix reading from uninitialized buffer
        commit: 776ac6cb9e6320feaf3ce516ae2e64d49ed4de37
[07/10] test/submit-link-fail: Initialize the buffer before `write()`
        commit: a97696720c41e7602c3ae5715b826fa3b566034b
[08/10] test/232c93d07b74: Fix reading from uninitialized buffer
        commit: c340e89671933bb13f0add1e04c5a350a03c672b
[09/10] test/eventfd-disable: Fix reading uninitialized variable
        commit: d879fbf9134e04f1e34e56b3575f9fafe9949c2d
[10/10] test/file-register: Fix reading from uninitialized buffer
        commit: 3bfe26a0c6e400d15060c8331ebc4280f01da4ca

Best regards,
-- 
Jens Axboe


