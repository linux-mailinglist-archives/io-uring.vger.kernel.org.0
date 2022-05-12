Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69630524C88
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 14:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353588AbiELMT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 08:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353592AbiELMTZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 08:19:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AFF246D81
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:19:24 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so4709244plh.1
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=jdzJsCOFB6EBjtys/TTJGlzRSTRAL3RbhKDD+8/aElU=;
        b=dBO+2l0B34+9JC9caXtj2twnrRhQYtbyKWxrLCLYmDutDIQD9JsW2Qc2Nsqputvojd
         7RSoYW8PH3vmvam4UFHWDAauWDWTSe8/1MxHZQvQzJmgx+RcWv9QtrBXfV8rHCj0cuOM
         dRnZkZt7kAJ2o+RnEVJWuPgatJZM5ep1ekNVRB4446kIyfQ6ll1wSLWRjygtXh/46omi
         Uq8k+lmYUsKTYERfKIgxer5mMN2oabUY+LcUxMtJTUsinstUx3oYiK2/dvfa3J8wSA9T
         qVAjCHiUYikAIarqOKxnKugNttrwVyyKpK5rI/PlVPf7tyRG6UD+85J385sSfZaFz60G
         Sq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=jdzJsCOFB6EBjtys/TTJGlzRSTRAL3RbhKDD+8/aElU=;
        b=QDUJwE4Uwkr4cVTNRuO6/sqZvWbj+2OmHtV+ufVAv0sUVqMZFmY9t6m0Fxu+ByO63t
         boTssYrd+KH4DepmQwK/oP31s627024Tor4RI0Qd5b24WigaCq8JyQswe9X2DltWyeCM
         sWxGHWb+eWPFhnUz/s5R8l2OtkDZg45ZoMsls0LqWUKsvGqzfcwTmCXtBjpJskRrkeCb
         UgZWFvbAek6GYHo7d52K5xhje+ECTVKOnprI+tL+Nbi1I5a5/1Q2JYqPLUljvqPODDOr
         xBFHYl8kElQAgyFOUJx0spQadT8dLxX5ayVXroCPQtpxgMOTxYeKGfMBOWuNeunC7uwK
         W6xw==
X-Gm-Message-State: AOAM530yo7hsKChpz1KKet/n40BkXnsJ8DYvYwcjmylG8LvsQb8JK+Kc
        qe8//GiOPz+U4TLNqQykTb3b3YK9GHLafQ==
X-Google-Smtp-Source: ABdhPJwEPHy7EDA3HFghoA2XGfvlJJhjZf//S+gJcDUfWHN7Icv0gdGWV395ArCmj6i0gEOILEdaKg==
X-Received: by 2002:a17:90b:1e4b:b0:1dc:7b66:55d6 with SMTP id pi11-20020a17090b1e4b00b001dc7b6655d6mr10886525pjb.80.1652357963849;
        Thu, 12 May 2022 05:19:23 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902e9cc00b0015e8d4eb29esm3786474plk.232.2022.05.12.05.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:19:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, dylany@fb.com
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220512091834.728610-1-dylany@fb.com>
References: <20220512091834.728610-1-dylany@fb.com>
Subject: Re: [PATCH 0/2] Fix poll bug
Message-Id: <165235796235.222381.4626747643796477057.b4-ty@kernel.dk>
Date:   Thu, 12 May 2022 06:19:22 -0600
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

On Thu, 12 May 2022 02:18:32 -0700, Dylan Yudaken wrote:
> This fixes a bug in poll wakeups, where it would wake up
> unnecessarily. This is most obvious with sockets, where the socket will
> wake both readers and writers when new read data is available, even if the
> socket is still not writable.
> 
> Patch 1 is a simple bug I noticed while debugging the poll problem
> Patch 2 is the poll fix
> 
> [...]

Applied, thanks!

[1/2] io_uring: fix ordering of args in io_uring_queue_async_work
      commit: 2d2d5cb6ca8424fa849ebb4edb8e8022c13860c7
[2/2] io_uring: only wake when the correct events are set
      commit: beed4eed5fc1fe18f2b78b214450e28d786c1e49

Best regards,
-- 
Jens Axboe


