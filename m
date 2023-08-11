Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC344778FF0
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbjHKMzO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjHKMzO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7193109
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso267907866b.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758511; x=1692363311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o0KETvhQhnlsYfFQlBR3Yhtztn8alSApxba9PTcoSyY=;
        b=IJJYtWC38OtfEXrxGAdhR8+1CeopYWpO67fTzT1wTxZTEsjYQuyJyxJy2WlciVKDum
         FlYZ1zAXAic3PngBD0SpQCW5ACQesVn2Y+670eCNPaubJOAGfSFyzLEasgFToz7trRS+
         1yVxqdzB3kPE0TkJcyeTtKmQ/GbHA/e+nwSgbocNpd1S3IDveb5BCnm7JVEhWT+PVCfH
         IkU1tTpDSahNc2Yn6iv+sqeBKxgd0cfNiC9PzeC4Vlz4jA58fWxKw1DlPcWxemmr9Ncd
         jIfF6/ChvJfWYIpqD8YHC+oWnExpPaWyRfdDjwO3fsKwohuWYTpC6DTTfzHeuAWuvYH3
         1w3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758511; x=1692363311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0KETvhQhnlsYfFQlBR3Yhtztn8alSApxba9PTcoSyY=;
        b=lFH++dDCA6Z6I5k/kz/5Qpnh4TOZBeweeMrmfoRyKNDPldadsOwESSPlV5EgK7BGsr
         1bl+G77Ti7dG/EOTnxOUeeb11+zMRTTbjJxs1BbBHRDA8/hOFYVC7PSKWJVzU1PPhxnA
         OrKxx216iGITDvfhLfnJwsb04boavNm3AkEDSjMvqcYEAKzPjEKAhXLSbomC3ihtUgQd
         FJHCU7xfDW3I6C80fwYUUlTtOtbrqzvo92Jf2lDlSsUfNRGKFHP2oweTk/xSDLtajP2P
         4c+sZjQaIyTsrRffXDI1DnRrkLLKCgwWaC1V7pXTudQ1+CI2KrNqP9gmD0opTrna6/FW
         ZF4A==
X-Gm-Message-State: AOJu0YzX8sp8WREs3+fvIzpgZOuatImKN3p5PWRh8LaC7qGEC2zHLJ/u
        VNXvM58iw+pOzZw5HvItIkCwR+4M1s0=
X-Google-Smtp-Source: AGHT+IFufEGaGuoVB0vj6WZnWOb4xzr7U/Hj6ca3JbNSi1b5QOUiKDev5WV134qE5qAnKIRvviQHlQ==
X-Received: by 2002:a17:906:19b:b0:99b:cf7a:c8d4 with SMTP id 27-20020a170906019b00b0099bcf7ac8d4mr1578903ejb.18.1691758510756;
        Fri, 11 Aug 2023 05:55:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/7] random fixes and cleanups
Date:   Fri, 11 Aug 2023 13:53:40 +0100
Message-ID: <cover.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Patch 1 and 2 don't allow multishot recv and accept to overflow
cqes indefinitely, the concept we're always trying to stick to is
that the request should complete, then userspace have to empty
the CQ and reissue.

Note, it breaks test/recv-multishot, I consider the test being
in the wrong, it should not rely on the overflow behaviour, and
I'm going to fix it.

Patch 3-7 are simple intermediate cleanups on top.

Pavel Begunkov (7):
  io_uring/net: don't overflow multishot accept
  io_uring/net: don't overflow multishot recv
  io_uring: open code io_fill_cqe_req()
  io_uring: remove return from io_req_cqe_overflow()
  io_uring: never overflow io_aux_cqe
  io_uring/rsrc: keep one global dummy_ubuf
  io_uring: simplify io_run_task_work_sig return

 io_uring/io_uring.c | 40 ++++++++++++++++++----------------------
 io_uring/io_uring.h | 16 +++-------------
 io_uring/net.c      |  8 ++++----
 io_uring/poll.c     |  4 ++--
 io_uring/rsrc.c     | 14 ++++++++++----
 io_uring/rw.c       |  2 +-
 io_uring/timeout.c  |  4 ++--
 7 files changed, 40 insertions(+), 48 deletions(-)

-- 
2.41.0

