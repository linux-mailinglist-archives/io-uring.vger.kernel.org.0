Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CEC7794ED
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 18:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbjHKQng (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbjHKQnf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 12:43:35 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3E62D78
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 09:43:35 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5657ca46a56so110370a12.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691772215; x=1692377015;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kGz/8jNhy+Ti+uFBVDNJa8dwph1KbT+1Ax53QB7NRzk=;
        b=yA3opShBJE33Ob54zMyQ5piSZEMv4orngW1mBsL9mw0S4d7JLj+cURRQIW6X5Iex0G
         67/m5QJr65MQEgqTq1N4QYxGMzcdCCIKvuTWFKX1+fQeB5mTI95/41BGGSMOp9jtz0RM
         bWgKs7g41B+ZI41dvnBwza9SUtclj1axq0wnQu/vd70chyosvzGC01z1jp9NAKWKbuV3
         mfeJdQ6hfdPJLYhYae3C8+fW2wrZ3vlDt0GxTIlAXK5xEan4wFUQ+htXQgtzzD1Ef9pL
         jhwqfRCT1iP0CzSxiGThPmWdo259+0GFPC294lGTN72v40+uTDfg6tVrfyk9uuSSmVDs
         q7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691772215; x=1692377015;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kGz/8jNhy+Ti+uFBVDNJa8dwph1KbT+1Ax53QB7NRzk=;
        b=e6ivNeFKxMVgQ71o7/pEqWPkMtUwNondeG64Pvj7wCL8TZnS1Tkv5PdIvUNxHxCH02
         lSUFufH4BiY42je7B27A6Pao1xvZKgqJHR5uLsAHmXxI3v3NFbcu/zSbt3VwkSARXUbh
         iCODSlAqcj9GyNffm5IdMKFMSqGlcOygfUO+5CFeO4HxAwpj9jSt3SdxPAQj2ijP/39Q
         kcQ0397NC6oBRbIKl/Eu8u8uLOkF9/0Pk/yC+Ff6+zdXJqe5sd5PLOWzVUFNjShHOxkI
         u4IHKkAge+JCw9LWcxNxXUW7mGbd/wzhv/h4SjsO2IqRu8VTUmlPZwnwBlkgtRBSMaUT
         NjRA==
X-Gm-Message-State: AOJu0YxHRjBJAEyEcbyvASddnxRbJgQ1d/sp5ZB691VONRSHq6dRCzP8
        F9Wt35psN9WaBdtjQleiZ7z9Zw==
X-Google-Smtp-Source: AGHT+IGiX0GB0rT/Y80+qMkPZ1S9+cLSiTAMiLXpn9McGjKFN2f/aW9XWIirXwNZJBIpDZs5MYwMng==
X-Received: by 2002:a17:902:d511:b0:1b8:a27d:f591 with SMTP id b17-20020a170902d51100b001b8a27df591mr2878801plg.5.1691772214727;
        Fri, 11 Aug 2023 09:43:34 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902e9cd00b001ac40488620sm4152899plk.92.2023.08.11.09.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 09:43:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/7] random fixes and cleanups
Message-Id: <169177221349.198433.4957723637013521811.b4-ty@kernel.dk>
Date:   Fri, 11 Aug 2023 10:43:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 11 Aug 2023 13:53:40 +0100, Pavel Begunkov wrote:
> Patch 1 and 2 don't allow multishot recv and accept to overflow
> cqes indefinitely, the concept we're always trying to stick to is
> that the request should complete, then userspace have to empty
> the CQ and reissue.
> 
> Note, it breaks test/recv-multishot, I consider the test being
> in the wrong, it should not rely on the overflow behaviour, and
> I'm going to fix it.
> 
> [...]

Applied, thanks!

[1/7] io_uring/net: don't overflow multishot accept
      commit: 1bfed23349716a7811645336a7ce42c4b8f250bc
[2/7] io_uring/net: don't overflow multishot recv
      commit: b2e74db55dd93d6db22a813c9a775b5dbf87c560
[3/7] io_uring: open code io_fill_cqe_req()
      commit: 00b0db562485fbb259cd4054346208ad0885d662
[4/7] io_uring: remove return from io_req_cqe_overflow()
      commit: 056695bffa4beed5668dd4aa11efb696eacb3ed9
[5/7] io_uring: never overflow io_aux_cqe
      commit: b6b2bb58a75407660f638a68e6e34a07036146d0
[6/7] io_uring/rsrc: keep one global dummy_ubuf
      commit: 19a63c4021702e389a559726b16fcbf07a8a05f9
[7/7] io_uring: simplify io_run_task_work_sig return
      commit: d246c759c47eafe4688613e89b337e48c39c5968

Best regards,
-- 
Jens Axboe



