Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878E261DB9D
	for <lists+io-uring@lfdr.de>; Sat,  5 Nov 2022 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKEPUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Nov 2022 11:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiKEPUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Nov 2022 11:20:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2692205C2
        for <io-uring@vger.kernel.org>; Sat,  5 Nov 2022 08:20:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so10779955pjk.2
        for <io-uring@vger.kernel.org>; Sat, 05 Nov 2022 08:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vRwuNxiZzTw2d4cl5jfJTbuhxlA1jPC13SrC5ZfzCCE=;
        b=wKp9rXkzjkCEkYLiWs28fAfeqV3MkKqXlE83r28IX5arQc/E4OvtUb29gavHS2eHHQ
         I9GQ/E4Lscq7WOLPCjhOm5To0m75QJNmfEa3TqLvzlJz9IrQAR5dCe0T4+nmafqHu7wJ
         /pHvV2wofdugYmMRLz+Z2gCgLFnxI5G2KF77324QRiVb2wJi/bYQSeaB3/8mvzWH+OTz
         uk+w/o42iidbr1J4JjqTWns9h5PxcfQap0NreFBfQd0mnxidswWRzjJ180XRQH0X5sD2
         aKtDVfE9+J4Toj5eIc5L+PphNN4eSgrj8TqEXrT7sTFLzr38gjyFbScrpD8282re7wqR
         SE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRwuNxiZzTw2d4cl5jfJTbuhxlA1jPC13SrC5ZfzCCE=;
        b=Hmjy3lVybAdKueydzldks7TS2dDBoA0+Vyw7rsOYZhPycSP/Vf0qdYt4qpmKiyzyF3
         w0YmEgmg6IHTLEcxVm6H83n+y4i+nBdO1DNUbjju02iHi/AQD1ALNnLPq5v/66YHy9wn
         milBWu1l15toDJNN3QsQBQBfnBZj8E6yNOdz+NuVn1e5xDpsh2TZf1+kI3eUHllYYdHA
         +02pR8sONtQa4YgN8CSUXyJcg7ALr5HoJfhxGq8sHZjWj8J92cXwn18wGfnhVsUSnIjJ
         eXD0rYrvnkwL8L5dcG3wPHQ2VgHsyak2Zuwd1rRqYeXR/GCHrjAJSM8FyYhVCaM+XYhv
         w+Hg==
X-Gm-Message-State: ACrzQf35JfyIdBixYDUNsWrWSMWW1cgkxS2L4fNE+LBgTx2zIZGqZO4L
        woY8eINQg1gbnb2wSnaFn0KxLaABaSCzw2AE
X-Google-Smtp-Source: AMsMyM5zc5mT5iZdXajnfH+RmefkTZdH3IiGBdL/Pt97K1Vf7WSyuyXIO7oq2gSHBZ74ge6nHkG6jw==
X-Received: by 2002:a17:90b:11d5:b0:213:ce33:4a4a with SMTP id gv21-20020a17090b11d500b00213ce334a4amr34915645pjb.206.1667661636187;
        Sat, 05 Nov 2022 08:20:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j7-20020a170902758700b0017f7e0f4a4esm1829017pll.35.2022.11.05.08.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 08:20:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1667559818.git.asml.silence@gmail.com>
References: <cover.1667559818.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/3] some extra zc tests
Message-Id: <166766163525.10617.13749271893100715014.b4-ty@kernel.dk>
Date:   Sat, 05 Nov 2022 09:20:35 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 4 Nov 2022 11:05:50 +0000, Pavel Begunkov wrote:
> Pavel Begunkov (3):
>   tests/zc: create a new ring for test_send_faults()
>   tests/zc: add control flags tests
>   tests/zc: extra verification for notif completions
> 
> test/send-zerocopy.c | 55 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 42 insertions(+), 13 deletions(-)
> 
> [...]

Applied, thanks!

[1/3] tests/zc: create a new ring for test_send_faults()
      commit: 799d6e0ed8103ac296135e8670c25cbd5c074a73
[2/3] tests/zc: add control flags tests
      commit: 81ab5f3831fe8dccb3e51b3be093791ef8ad2df8
[3/3] tests/zc: extra verification for notif completions
      commit: 3e3f71a6eb8356c129706cb88d150fe4e01fa19e

Best regards,
-- 
Jens Axboe


