Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347A65100A3
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiDZOnK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345295AbiDZOnI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 10:43:08 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A55FCC
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 07:40:00 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id r12so20106386iod.6
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 07:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=XiA39nfCd8iHof+9p2RDPlzQzgnEYfU74wp9AV2yMdE=;
        b=gjtb+1fV4h/yNUnNITavENGrRNUBoIJ+Kuiy3CqdE5C6/QOzbIM/KySf5pfIBej+ID
         zClC8gt3Myi0egHujCU4YboCWAsYq32iGioPD2nXu1bHWueSnXo3Kfw3u/HWn6NFxiwJ
         HubrPAgNbWRWJwMO5xznyoWp4LSuU0iyXUtjk+ju80p4rcNgB6VqdxS5fbFoxEK8lXIZ
         o+qDNf8mtPhIZyNHnG0a6z90L6DgXMQ3GsJ23sZaJKamlqBMTonB1HFWsz8gBClecitC
         0bvbc8ymfXRUzHj/g89Qr7DYZelApjo2pPAUP3kODIIf2kN0jffIXagQYr6McBPFEcTT
         y+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=XiA39nfCd8iHof+9p2RDPlzQzgnEYfU74wp9AV2yMdE=;
        b=A9ju0b9PoHieNst0kJlX3vEp1duoSKgRieloQCAfmmFHD9f+dEnvo4grW8wtUdOy2e
         MNaqinT1RLM19ez/m7jr/4wz3X4F6MDUqZNs+ATJT3lZEApZoesrN/VCHx2kug1LpE5+
         IJ7Nb7FgbSvi3ug5wR8tYGdTIQTGaU5Unkf9Pry/MnssijBe0tA0KBk8H0sbtjvHxejn
         LMPuBxsFTKddH4oDoEhfeIU2PWHj+EOSnqBbOhA09vbj3wStrVeNXY3Jkdv3uRPKrqTk
         UN+xtkpz1m8yj4EbDofJ3ew79aXxz1s54LfkgJ1nF3djtY5byXRI0FV8+SQmzadiWfBA
         IZgw==
X-Gm-Message-State: AOAM533vk8KBL99n9stweChMp4NmFl9RlCo62j/SBO0bcwe481pHXa02
        KH2n5yVzloij0s3+CwMzXBRWnPUAG1PCgg==
X-Google-Smtp-Source: ABdhPJyeLrEG/qWQDaPHDoyX6JvhNcEBq43hM0ZhjXotI+Q79Qk2LAJQH395VGA1XGbxJBlqff8vGQ==
X-Received: by 2002:a05:6e02:1647:b0:2cd:9073:eb with SMTP id v7-20020a056e02164700b002cd907300ebmr4997779ilu.267.1650983999441;
        Tue, 26 Apr 2022 07:39:59 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h22-20020a056e021d9600b002cd79a5cfd4sm7417061ila.23.2022.04.26.07.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:39:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <20220426014904.60384-2-axboe@kernel.dk>
References: <20220426014904.60384-1-axboe@kernel.dk> <20220426014904.60384-2-axboe@kernel.dk>
Subject: Re: [PATCH 1/6] task_work: allow TWA_SIGNAL without a rescheduling IPI
Message-Id: <165098399823.32677.2200735205292292397.b4-ty@kernel.dk>
Date:   Tue, 26 Apr 2022 08:39:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 25 Apr 2022 19:48:59 -0600, Jens Axboe wrote:
> Some use cases don't always need an IPI when sending a TWA_SIGNAL
> notification. Add TWA_SIGNAL_NO_IPI, which is just like TWA_SIGNAL,
> except it doesn't send an IPI to the target task. It merely sets
> TIF_NOTIFY_SIGNAL and wakes up the task.
> 
> 

Applied, thanks!

[1/6] task_work: allow TWA_SIGNAL without a rescheduling IPI
      commit: c0c84594c0234aac5d09af8a595d25d822c6dcc8
[2/6] io_uring: serialize ctx->rings->sq_flags with atomic_or/and
      commit: 8018823e6987032d3d751263872b5385359c2819
[3/6] io-wq: use __set_notify_signal() to wake workers
      commit: 8a68648b353bb6e20a3dc8c0b914792ce0a0391f
[4/6] io_uring: set task_work notify method at init time
      commit: 35ac0da1d1346d182003db278c2d7b2ac32420a7
[5/6] io_uring: use TWA_SIGNAL_NO_IPI if IORING_SETUP_COOP_TASKRUN is used
      commit: a933a9031e40c972c24ce6406e7cea73657728a5
[6/6] io_uring: add IORING_SETUP_TASKRUN_FLAG
      commit: 6f07a54a90ee98ae13b37ac358624d7cc7e57850

Best regards,
-- 
Jens Axboe


