Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2907640ED9
	for <lists+io-uring@lfdr.de>; Fri,  2 Dec 2022 21:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiLBUDb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Dec 2022 15:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiLBUDa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Dec 2022 15:03:30 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3814AEF8B5
        for <io-uring@vger.kernel.org>; Fri,  2 Dec 2022 12:03:28 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so6123219pjb.0
        for <io-uring@vger.kernel.org>; Fri, 02 Dec 2022 12:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txQclJb9oi0Me7DZzzvwz2AlJuouPl2NgQYw/V4geF4=;
        b=6USiv9udBCaNfbXTx+MsfBHRsysaZ09pWTLfPzU4ioge1spLru/xygHHxrFtHOc6Zn
         V2Xhqwz1pUQwW/CQoT+7cPr4zC6TgviAQ6oPz9hkDm7FO2IT9zvuyEq5bfY+RbLe6+xq
         z/WOZi+srl0k25FaeI4cDvo0+oOKRiBeqOjUFWY10zAJgOw/NAtXV9D8A9F7Q7u8jMkn
         qe1VtBUk+NdDwUj3T0PoNMFzeyAOIL58d18x93vMYo4AmUObuphoRGVNq+sbe24iM9lV
         kVzWH5sf+1bIOp1FYPvtYYY+MMHttM6UOQrVZQJ9vkzl72cx/FLKnvJxVoiezrZddAKC
         6T2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txQclJb9oi0Me7DZzzvwz2AlJuouPl2NgQYw/V4geF4=;
        b=PhI0ua6oIsVMrNkSyJo0lRvZzMRyCBDPFSYUgRAYPXmUEQMu7+YeoeNJxtwNR9m0h4
         xOZXAiWR3P/iThl0P+oaJ9YbTcaQ6hpEc98Pmm9lWP+HlPkFTcmz2WqWCn8Ix9PcbLC5
         CUgR+2lDZEX1qUDSNgl81J9+g/6gCfqUVTeMJdJSrzOsxjWYXyvRCLBpA76aW/jR9P0C
         5QALJ7xBO3IzEOB3d3IatuhGd+MqDT3uXup/RVVQwwJcpYM/k/hmBRGXlgHDbvVjSbwe
         nUN85gbxJkCXkciAwsPZbFPMOofrD6WZP4q01I2u3RVJkQZB/tYUEwNOnBSb15YDNu9l
         aCJQ==
X-Gm-Message-State: ANoB5pl394dftPx8dL9uJStl84evAbkHbFl6vDOFvPIVSr0FfQLx2lFB
        rNOjKgCmEZ46SIJXbybargYEQA==
X-Google-Smtp-Source: AA0mqf621e2Gg8OCNnvaaHdscvIsWMWBqvVYvVbK35rt7J6NLlXMALlXkP+5GtfyxBEolRm/6FD5Ug==
X-Received: by 2002:a17:903:291:b0:186:994b:5b55 with SMTP id j17-20020a170903029100b00186994b5b55mr16706735plr.100.1670011407618;
        Fri, 02 Dec 2022 12:03:27 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ij22-20020a170902ab5600b001893a002107sm5978685plb.0.2022.12.02.12.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 12:03:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1670002973.git.asml.silence@gmail.com>
References: <cover.1670002973.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/4] some 6.2 cleanups
Message-Id: <167001140694.936996.12312748109578334067.b4-ty@kernel.dk>
Date:   Fri, 02 Dec 2022 13:03:26 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 02 Dec 2022 17:47:21 +0000, Pavel Begunkov wrote:
> Random cleanups, mostly around locking and timeouts. Even though 1/4 is
> makred for stable it shouldn't be too important.
> 
> Pavel Begunkov (4):
>   io_uring: protect cq_timeouts with timeout_lock
>   io_uring: revise completion_lock locking
>   io_uring: ease timeout flush locking requirements
>   io_uring: rename __io_fill_cqe_req
> 
> [...]

Applied, thanks!

[1/4] io_uring: protect cq_timeouts with timeout_lock
      commit: f9df7554e30aa244a860a09ba8f68d9d25f5d1fb
[2/4] io_uring: revise completion_lock locking
      commit: f12da342ec9c81fd109dfbafa05f3b17ddd88b2a
[3/4] io_uring: ease timeout flush locking requirements
      commit: 4124d26a5930e5e259ea5452866749dc385b5144
[4/4] io_uring: rename __io_fill_cqe_req
      commit: 03d5549e3cb7b7f26147fd27f9627c1b4851807b

Best regards,
-- 
Jens Axboe


