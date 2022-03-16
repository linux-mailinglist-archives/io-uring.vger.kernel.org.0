Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A354DAF13
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 12:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347821AbiCPLq5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 07:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345565AbiCPLq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 07:46:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8282C62A33
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 04:45:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m22so1978161pja.0
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 04:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=qGkXPPBR/DlCDotgMxD4QyGmjkzTnAmDuzNs/zU32Kg=;
        b=IvH6VwM9zx8954ZBTZYu8Lh6hXOsz/G0NPTppqQ5en6+nKOq7GJ1RhCrLAM/sJ4U+4
         tXFC6p+CYvrIQNfjh427GKAVW+sdb63ISO4breGvijb5Z6G11hMr6gS9miRANP+UxD9v
         U6IQXftrRRUTzJmdWZSrXEq+Pyp9DLzj4sOU+7KKQobfgjJn6NpxQsi19cY1rvYRvcUW
         qmeUeNjduSKfaMhJPRrlcQ1+h4igdNE8qYUAarxNK8Y9dZxLeFGLjwRDyfRwfKE1U0DD
         K+yqEguesLmUgzSUbi7mMlSdvsLmHDIHRcy43AaAXiK9iZIxcDn2J5p2xpkcBDIo1/Qk
         pUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=qGkXPPBR/DlCDotgMxD4QyGmjkzTnAmDuzNs/zU32Kg=;
        b=W9wN09MUwwgHOgi1sAtw2STPUJUIsze1xNLVa7znY0UEaTxR7EEXFtzoUL26HaZdF4
         LlnPCREBZwXeetMAPH0KzO+S7q9vjsWR94jqTT4Bcf6URGUns5SPCZGkUiwAs950h1cj
         2J06Yoqx6dLvriKcS/LsVL0b2YTrhSo4kBxdZZm48WUvKnwEqrRDb6RMfgNkPC5OPVw1
         xEl5AWaLTfVGfuMnD1mYpBxj+Oc9Dud8/jainKEVJC/8/9uLnbphFYBEUOZsh4y/tYsc
         wEbmJeGW7omU6qgA5W9Ewsa81YTiY2GAmMf8Uvj8hnS7ImS2Ztrlpy9bTUeerMtd1Ey0
         jTkA==
X-Gm-Message-State: AOAM531eiD672ePY5myBSLcTSGHl+VDktCjWcrNZnwY/UqRsgVeCCywv
        RLWO52jOusZZbikhAPH2Kl9U0LpmVzyIr4XV
X-Google-Smtp-Source: ABdhPJy2OpCD2b41tWscqbgl3mFVFUyb7Qtus8StHUJaf2KkbHp57qg2ogURS1QjD2Q+Af4vmdSPWA==
X-Received: by 2002:a17:90a:1197:b0:1bf:65ff:f542 with SMTP id e23-20020a17090a119700b001bf65fff542mr9603742pja.5.1647431142782;
        Wed, 16 Mar 2022 04:45:42 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o7-20020a63f147000000b00373facf1083sm2420371pgk.57.2022.03.16.04.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 04:45:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Cc:     kernel-team@fb.com
In-Reply-To: <20220316095204.2191498-1-dylany@fb.com>
References: <20220316095204.2191498-1-dylany@fb.com>
Subject: Re: [PATCH v2] io_uring: make tracing format consistent
Message-Id: <164743114198.8782.12003428294877327457.b4-ty@kernel.dk>
Date:   Wed, 16 Mar 2022 05:45:41 -0600
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

On Wed, 16 Mar 2022 02:52:04 -0700, Dylan Yudaken wrote:
> Make the tracing formatting for user_data and flags consistent.
> 
> Having consistent formatting allows one for example to grep for a specific
> user_data/flags and be able to trace a single sqe through easily.
> 
> Change user_data to 0x%llx and flags to 0x%x everywhere. The '0x' is
> useful to disambiguate for example "user_data 100".
> 
> [...]

Applied, thanks!

[1/1] io_uring: make tracing format consistent
      commit: 052ebf1fbb1cab86b145a68d80219c8c57321cbd

Best regards,
-- 
Jens Axboe


