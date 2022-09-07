Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03E65B0A43
	for <lists+io-uring@lfdr.de>; Wed,  7 Sep 2022 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiIGQjz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 12:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiIGQjt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 12:39:49 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D1511802
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 09:39:47 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b142so11920419iof.10
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 09:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=hZktgSY0egM6vL0qZk0XfPUaGt6lucw629q2fVIn44g=;
        b=CHr2PncRR3tDhV+YhMHwo8lCGGB0VW2HHmWvyomXRcWBsSQObpTYeS3vd/NQmfzqUK
         z1MYi8y1AqiYjWYyYn7nlzsd7FXVsep3SYae7Ni+wNcHcywwg7yfBnnLG3QkeilCRBAL
         66r+Re4xgDmHFtrFiZ5qPPuJW2ZuEdTu5U3WWOT0D3aWQJcCNudiaSsdvtjRl9JTRVIT
         FhqrapafnTuAFm96zyu7X+EiCCu38DMJ0+O0hziwwDQKo8n5zxpJwEzrNMJf3YsV93gP
         xd7WQyyM0AlDMZX5wcQ2JgfLlV/tRGzO43bJB3kQCsmtN7Q33XzakqaOBz5HzKbKHGtH
         pppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hZktgSY0egM6vL0qZk0XfPUaGt6lucw629q2fVIn44g=;
        b=k4t2ySu9PhfN0Z4cPywgt7rpDlJMlBQAMPq6DPeItM3/9cfXyqapUN1FFUMWj/4yOP
         /+l6IKjNXtL68evNtF/GoZQv4G3a9mlFrCdG32oDTVaroCFoZv8XZkY2oTzsO0h5bJ52
         lR9ZAJcw2+DsS4wYl3eh8RTIZL9o4Ua4MKuq0zWVD3wozZl/OS5QUKN7EEM+5Mkip+Oc
         g74qdUvLjCEndMwfpcs2SX0rYWE4pE/hpicwNvbv2QJNIeqzGGOFa3jdzJHevrRCH3tF
         aeyTcQ3ta8hVGu7HYswEtxGQBHEC/QBgtRYgxKEltvxt4EN55AU7G+6Iw4AgeIxyg3/D
         x5Rg==
X-Gm-Message-State: ACgBeo39oaSS5pWhibxroGdcPILKP6JsJEloavf9oOWpmq00vp3yd1cN
        uJA+hai/7kUbh3nweHKFuXy3e/p/7tpS3Q==
X-Google-Smtp-Source: AA6agR7AC2EpqOlvB/FIj33+1ZoOwO9dDiteZNEIdkpV4+FTwrGo2cu/AF1wj3AlRFHju3tpU9HvvQ==
X-Received: by 2002:a02:b60d:0:b0:343:5ddd:66b3 with SMTP id h13-20020a02b60d000000b003435ddd66b3mr2564924jam.8.1662568786299;
        Wed, 07 Sep 2022 09:39:46 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cx7-20020a056638490700b00350682ba05csm6088718jab.30.2022.09.07.09.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:39:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1662480490.git.asml.silence@gmail.com>
References: <cover.1662480490.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] ring buffer fixes
Message-Id: <166256878559.1926513.18099691040812283690.b4-ty@kernel.dk>
Date:   Wed, 07 Sep 2022 10:39:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 6 Sep 2022 17:11:15 +0100, Pavel Begunkov wrote:
> Pavel Begunkov (2):
>   io_uring/kbuf: fix not advancing READV kbuf ring
>   io_uring: recycle kbuf recycle on tw requeue
> 
> io_uring/io_uring.c | 1 +
>  io_uring/kbuf.h     | 8 ++++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] io_uring/kbuf: fix not advancing READV kbuf ring
      commit: df6d3422d3eed27afa23df092b3ce147c558d1a8
[2/2] io_uring: recycle kbuf recycle on tw requeue
      commit: 336d28a8f38013a069f2d46e73aaa1880ef17a47

Best regards,
-- 
Jens Axboe


