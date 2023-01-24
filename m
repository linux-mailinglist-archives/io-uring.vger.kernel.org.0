Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34595678E45
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 03:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjAXCcD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 21:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjAXCcC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 21:32:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E03B9EC2
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 18:32:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso12742914pjf.1
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 18:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHiFKcf5KDXNoARI5k7x6B6jD7IKSFCSfG+MFu5HrGI=;
        b=tQqGYLxA16pUOgjSrG2eWcwTl1wrGQ9S2DMqPZxmXKm1aziJN2sOwP1GsNxFSzzRvW
         puiNOhUPw6hmiVBBVFcGze8PIl4VtM5z7pFOQxZi8bUAyJCd/Do25W1LAhqfJJpcfedQ
         pBkLRys5DEpBY0M8iI15Juen/u0PuB3Vihuc8vqaY51kmp0vRCInVL7OO1BEDFJhKqPs
         M/Ym0P/30IA27oiBqvCNq4Rt6Nlp8EweRA5Lp7XGxZKDWZFUyVGET3mNhQ4JvCQM0WrN
         vnIswmNvshM6wr92l0tAaFk6rtoaKvW/ybwEPPgY8bctuaDebgzCQJWA1wm38Vqymsgp
         1DjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHiFKcf5KDXNoARI5k7x6B6jD7IKSFCSfG+MFu5HrGI=;
        b=qfQCz8sLhtA9Sb0Xd9buH45CPlN5FFIxkj1iLse4ujz7abmo+KAcshwjCmprDR0UEt
         tdrBiUWbGRgDLN9ZogU70C560GcsdxlpeC1mpqoVTexOCEBVhCsIrn8pKqOEasILTsT1
         nFteS3lD4/giTzy6Nh6+C/gZtXSDV13qsF9Xd3wjAhcvcaF8UpBNNQY7PWX/hksTU7eL
         H6u6iAI43y30UENTDBWlYjo04zDL1CEFuLxGZcr6bu2CZ8QxSBDQhBTQqaHP7FVxdigg
         nmDbgyZzn3fQUeiaWNEjV2ywPZpEeFDuN1HLfBpI8ZW26JcMknslgvfMSqnZEGJ+gieM
         Dw7g==
X-Gm-Message-State: AFqh2kpG/eHYbpYhG88189L/BVYy5ztP6METgWfLv2YoieVE7l2mrgUC
        GoMFgP3aHGjAwQAytGLfCwxustmnyvlqukRj
X-Google-Smtp-Source: AMrXdXvVNTuw9qKDr+2ssSR5ijQ/uK7O+89sj8vdc3xe4WDa680F1yV7UdX7TfF2cHs437M63hY1uw==
X-Received: by 2002:a17:902:e5cd:b0:192:c804:89db with SMTP id u13-20020a170902e5cd00b00192c80489dbmr6535607plf.1.1674527519765;
        Mon, 23 Jan 2023 18:31:59 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902bd4200b0019251e959b1sm373904plx.262.2023.01.23.18.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:31:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1674523156.git.asml.silence@gmail.com>
References: <cover.1674523156.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/5] deferred tw msg_ring tests
Message-Id: <167452751907.208914.10218550019179925906.b4-ty@kernel.dk>
Date:   Mon, 23 Jan 2023 19:31:59 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 24 Jan 2023 01:21:44 +0000, Pavel Begunkov wrote:
> Add a regression test for a recent null deref regression with
> disabled deferred ring and cover a couple more deferred tw cases.
> 
> Pavel Begunkov (5):
>   tests/msg_ring: use correct exit codes
>   tests/msg_ring: test msg_ring with deferred tw
>   test/msg_ring: test msg_ring to a disabled ring
>   tests/msg_ring: refactor test_remote
>   tests/msg_ring: remote submit to a deferred tw ring
> 
> [...]

Applied, thanks!

[1/5] tests/msg_ring: use correct exit codes
      commit: f4b49d6a04209799e7919abc10cca0a6fafff5f7
[2/5] tests/msg_ring: test msg_ring with deferred tw
      commit: 52ca1bf33fc80425755a8b0f79a8dd91b0833e6b
[3/5] test/msg_ring: test msg_ring to a disabled ring
      commit: 538a3a3357a10b9030b4bba0e39e4e14e3726ce8
[4/5] tests/msg_ring: refactor test_remote
      commit: b78d76aa18aed2dc6750f4185f6941ce74281779
[5/5] tests/msg_ring: remote submit to a deferred tw ring
      commit: 5e065b4d137a5da7d390402f854484e33bb20a5c

Best regards,
-- 
Jens Axboe



