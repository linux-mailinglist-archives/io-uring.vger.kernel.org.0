Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3978054F85D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 15:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiFQNfF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 09:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiFQNfF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 09:35:05 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D0230F59
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:35:04 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q140so4079540pgq.6
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=AbTiaGhvCVWwlAMzrQGnRcsNokrRvYHudIOmu+DM4NU=;
        b=Jh2Q9Yc06n6YIcFpEkFrPqUBF1zmjIsFdDgF+S8WOMjc9fXb/i21ixkPOL3LJtgVA/
         /jn62Xn8xrbkf34D8V0r+/KQGRhMmjaZKUS4BfmNfVDEyH+tKk0NIVH3URoZdOa2m7Pk
         j2iztGXO6AAmyREtVV1NFkqfV0Oh+s7TqgYsf1jav/q3pZDK3xgGILMbfUqsk7zGIaJ9
         Qt8Fm1d7N4lKqurkvDxRthGhrmD5KA/8UcBMZ3eVKDPMR/2OqMXhHOuxOE1P8s24XNUB
         y/RXUhve+BshPz4vDEEdlB9A66tODhkFkGuKmvuE3nZ6p4dbhKOcGI2lL71EHFQxG6j8
         pXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=AbTiaGhvCVWwlAMzrQGnRcsNokrRvYHudIOmu+DM4NU=;
        b=N8EzeDzwT9lDr7LlYXarUk86FiV1lMXn+356h5WZPgrHA6wZ1/79eaHwWOTXL+mZpQ
         FDocEjRDMII7irbgNNLYh2eFd1KEFOpfFd33qC3rNhxIDQSIlU6FxZ5P+mSZd7Yin/qp
         uGVoiQ4L1hpJ2sXedFyViJD+ncljYzREHNAqxh6K5Nuhr1ToDJKVOXvcjyJ1oxLgIfC8
         6kVUR6SI3dGn7xdSGmCQ7l/cXCqoP+RfwQvaT9SEbgcXRsmLp4f/5OrHD4XGGHVbOMkk
         lKiyWxMIEmw1YuAnTtdpeWWz268qpNnEnCa4HB26NTU8TWMRst1MyK+2k6Uy7TBAuTGm
         T8TA==
X-Gm-Message-State: AJIora8WVhGuweeFiNrkYjR3g46tKkhWeCwVImqgOtoo2R2TI20jw0p2
        FlRQjJoVgh2Zy2QwEKmXnffMt4viKIoGzA==
X-Google-Smtp-Source: AGRyM1vGbOGT7wBo4h/qXGP9CZDdgnRL+3chq6Jdu34QhmMCrFNThcM21XAC9xWbNb/fM0G0INSIwQ==
X-Received: by 2002:a63:140d:0:b0:406:2777:70f9 with SMTP id u13-20020a63140d000000b00406277770f9mr9225854pgl.170.1655472903704;
        Fri, 17 Jun 2022 06:35:03 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v21-20020aa78095000000b0050dc7628171sm3704424pff.75.2022.06.17.06.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 06:35:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655384063.git.asml.silence@gmail.com>
References: <cover.1655384063.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/3] io_uring trace events clean up
Message-Id: <165547290280.360912.6391813246027488784.b4-ty@kernel.dk>
Date:   Fri, 17 Jun 2022 07:35:02 -0600
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

On Thu, 16 Jun 2022 13:57:17 +0100, Pavel Begunkov wrote:
> Make io_uring_types.h public and teach tracing how to derive
> opcode, user_data, etc. from io_kiocb.
> 
> note: rebased on top of the hashing patches
> 
> Pavel Begunkov (3):
>   io_uring: kill extra io_uring_types.h includes
>   io_uring: make io_uring_types.h public
>   io_uring: clean up tracing events
> 
> [...]

Applied, thanks!

[1/3] io_uring: kill extra io_uring_types.h includes
      (no commit info)
[2/3] io_uring: make io_uring_types.h public
      (no commit info)
[3/3] io_uring: clean up tracing events
      (no commit info)

Best regards,
-- 
Jens Axboe


