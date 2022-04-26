Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFEA50EE44
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbiDZBwS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiDZBwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5068A12635B
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:08 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s14so28812059plk.8
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhvriZzq9o77c+E5bS0mFRKdAYHayior91c0YZy4YVA=;
        b=IpnoaAuzI7It5asUwhXridsErxd6FiIOjDrNVKvYG69yNhEioZKGi8D92p7Gm6BFIE
         uWCEB+al+uAiQcBwnQ7gfkVHEYJf+m7NLmRjygrV207uLPZ+MBs40pKaOjplpOnu77So
         xNQ5xTBsVHpIBsC+czLjiBqNtAo2tUOHycKBEeGSqoJRpnsXu/1BxyRnGgRFtzl3lYws
         P4EGWyV1dyV6kpq02QiBH0JqNPKa2DY5F68SAshHXreOQxd5ZeitKK7qActWSVHMZQDI
         dtcAu2L7g0XHH4jmm3IT3wE3XdfMUCINAdPdBp1P+hupEWsQfOpblELM322S/oP4vGUY
         brfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhvriZzq9o77c+E5bS0mFRKdAYHayior91c0YZy4YVA=;
        b=kdwLCKO6XAbsXky+4B5HJFwy7FIYlHoRoUf2ggmPnLeu4rRDYNNQJVMAlwt79SarBo
         6/fIxc6C+ZQ2Z4bPVPOFeqq6jt8aqJyGKKhrDbsUBehwgEYoogd5N2MEloYXWPFqbONq
         knDfu0Y6DChQu26G0Hfkx58lc+rAIuTO3BxZL5n6zbC+xcaoSaL/uJvgHCkgfuREgWJa
         u+btSzOOb8v3tnzOT4Gn/7TE0654olvC4jMvJvt7ip0qK7hl1a2fi7/x2sZSivKbzzpE
         8UXVUBV6rD+i/wNNK76AdXpNrXg3Lx6VUP7i//OQN9opWvaQqxIoRUGIP+ujL0fjpzAE
         EDUw==
X-Gm-Message-State: AOAM532J9EKrMk4Rxbl956EXdLKn2BEuVu0W6absK3AbM5VoIa4l8aqy
        Mf1FuqFpwwGN48P6rRQsIyQszIQrS6EeuFYk
X-Google-Smtp-Source: ABdhPJxLltE0ON88trK/S8zTACePeXzEMcVlcq/qVWFyIjFMLq3D1+3DE4ePPmG11Uuie3OmxGy6QA==
X-Received: by 2002:a17:90b:1bc9:b0:1d2:a0df:5ca5 with SMTP id oa9-20020a17090b1bc900b001d2a0df5ca5mr24258802pjb.3.1650937747422;
        Mon, 25 Apr 2022 18:49:07 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v4 next 0/5] Add support for non-IPI task_work
Date:   Mon, 25 Apr 2022 19:48:58 -0600
Message-Id: <20220426014904.60384-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Unless we're using SQPOLL, any task_work queue will result in an IPI
to the target task unless it's running in the kernel already. This isn't
always needed, particularly not for the common case of not sharing the
ring. In certain workloads, this can provide a 5-10% improvement. Some
of this is due the cost of the IPI, and some from needlessly
interrupting the target task when the work could just get run when
completions are being waited for.

Patches 1..4 are prep patches, patch 5 is the actual change, and patch 6
adds support for IORING_SQ_TASKRUN so that applications may use this
feature and still rely on io_uring_peek_cqe().

v4:
- Make SQPOLL incompatible with the IPI flags. It makes no sense for
  SQPOLL as no IPIs are ever used there anyway, so make that explicit
  and fail a request to setup a ring like that.


