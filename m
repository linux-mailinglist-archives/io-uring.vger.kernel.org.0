Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFA567153
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiGEOjj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiGEOja (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:39:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017E2638B
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 07:39:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso6708004pjc.1
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 07:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=6k8uqKlUIuUIeNqOJu1FdYyV4HyvJqSgzw2oaiGqpnU=;
        b=b8ZoimV+wrQre/MrVIgVYmp9cN9PSx6nsWecMGY0EWj5V1QHQTkweN/D/BG9m+/z0V
         V4ifBRwVPzECNkIGRSxlpoBT8tQs8UtwbTI4I5XixCh1borMq3o2zYCOWPQTJWo1mF0F
         9wQZIgLyvr1r4V/vdy0l81l/YZy4DpM6yLzyq2ejK8PHO5wPWrhDceK3rB6LiTQPC5Vz
         FiH/H2Rk1B1n5goU9QlfYwiFCqLm6uWl/fZC/DNgCMLVUeR7qKBre8DzzjhOp0eAmuhQ
         cmFW+7rE7/YMbHbv6k1eSMf0J0T1a1CLiCsNyCXxYkE4mU5Lq9o8KM7ucY+csHkb7o7u
         XHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=6k8uqKlUIuUIeNqOJu1FdYyV4HyvJqSgzw2oaiGqpnU=;
        b=kjH5AdtWtcTFzBTUHrByGYU/maOMEVyq119u5V2SuM25iPnyS4RHYLgdT+LQCXMFFo
         81XL4TQT3U/JRDz7yBmdtikMTXTzXuj8EUSEY1nItWEcRzzVZxmWOszmQHQwBuzfRKXR
         +P+EL9zAZaqgaDWE9YiFS4f55zikeM5mW8ectM+6/yrbq8qgfiU44jMmUTARWZ2efYta
         RwO54BBI9rWaUV2YPoxXnIItR4kmAwNQNShBKiq9FQcZpRMXrkhYlZ/eSHiU+mLJ+FmX
         8AW2QlY83wHHDUwM64i1WK6jO/t+zAzMSAVc86FRrAB807AmGQQMjRTy2vonvwdGoRAy
         a/Aw==
X-Gm-Message-State: AJIora+92ixkbRd5KBEE16Cfi/K+3oi9yquNv5GIHoBasfG6tlIwl2HN
        mYrFAwUuyPCAz9MRz8vgv/1sb1/L0Qo8iQ==
X-Google-Smtp-Source: AGRyM1v+muQ8mgSRFrnaWoIzFQ/kk7nh7J/WwumrxFcpAtBwLBkoLMtuk9Q2h3wavL9G9m0VB8LixA==
X-Received: by 2002:a17:90b:3a90:b0:1ed:27b7:5458 with SMTP id om16-20020a17090b3a9000b001ed27b75458mr42115302pjb.208.1657031968019;
        Tue, 05 Jul 2022 07:39:28 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s6-20020a17090a948600b001ef8264bc1fsm5804138pjo.14.2022.07.05.07.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 07:39:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dirk@dmllr.de, io-uring@vger.kernel.org
In-Reply-To: <20220705132939.7744-1-dirk@dmllr.de>
References: <20220705132939.7744-1-dirk@dmllr.de>
Subject: Re: [PATCH] Handle EINTR in tests
Message-Id: <165703196727.1923464.15505442909574224327.b4-ty@kernel.dk>
Date:   Tue, 05 Jul 2022 08:39:27 -0600
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

On Tue, 5 Jul 2022 15:29:39 +0200, Dirk Müller wrote:
> On an otherwise busy machine the test suite is quite flaky. Restart
> the syscalls that are aborted with EINTR.
> 
> 

Applied, thanks!

[1/1] Handle EINTR in tests
      commit: fa67f6aedcfdaffc14cbf0b631253477b2565ef0

Best regards,
-- 
Jens Axboe


