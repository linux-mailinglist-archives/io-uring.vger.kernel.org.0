Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC5377D12B
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbjHORdi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238919AbjHORdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:20 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBE61BD1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b962c226ceso88323291fa.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120795; x=1692725595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=noy52bh3FDivgKiW5yBYn0/WUIRwRNwDfIfXYg8g2Q0=;
        b=M9wRg1MG693ydtkWWjMlFsPplp2Ti4jjlsQ0XXwPC8wS2XpRv14Id8y28RIK9eCUlN
         hndvFoAEU2BWdLC22abQ5WnrAQa46SKjI86vwGjnJMPIm4ho1jBOSAXe7zv9IqYzX0oz
         un+vdrcAjgJYn9Kz33QJHtetjYNR/iLUnlgIyHY9zLIIpJKBR+xd3//aUrAMccrpaHgf
         ELLePHmrn0bcftsmGTNt0ueylDcFnRlGnpPkkCyQ0SwFlbmQUQfer8QUAGc95fa8MSNO
         Q8Q0vMty8tqLijgvLMWc3g6/cJZQDWddNGNiCXBiPXlTjbUDPXMPYLQsTCPZyeiFciqc
         jh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120795; x=1692725595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=noy52bh3FDivgKiW5yBYn0/WUIRwRNwDfIfXYg8g2Q0=;
        b=Df1yy7MVrAClvkuDZqscQ0llblOU80213aOFZXP29uYwMk/srHrAvPLbsjiPUUjZmn
         JGV11BO/wA5xWMx5OHmG5WlE0O0hpHCQkhLRSzpcngM+dx8lo7pGsQKmldff7o1clQW+
         Eos2RhicFYW3ZBExKy62mW7VsEHxObxpPZbrVFqJv9GXCvI88If86rO+nL8yX9W+Erh3
         kqyu6hVb4pdN4hHvGcnQyvZMKJiek3NTyhpu2QV4CaHCroB5wPC8q0doKHstZ8TniNvY
         OyZMYE+JdEn5JPdQKDRCtukm1913UYdw9W69Mm7MZcUfvNAgaCovrs9iC09K5N8FOis0
         F8xQ==
X-Gm-Message-State: AOJu0Yz7cJE5SCfpHwm8fwynjuiDOBCs7AiDmv0HQGGe/SqmMgMkTGRF
        SluWsIgCSMjJKWzIE5Q81AS+ujy0vYg=
X-Google-Smtp-Source: AGHT+IFS/NnhJ1S+EX9ApKQZBuX3ho1rVXMrq1PcyOeesiOcm877xUksgDBYUFiNouVGAdwhqGuHIA==
X-Received: by 2002:a2e:80ce:0:b0:2b4:6bc2:a540 with SMTP id r14-20020a2e80ce000000b002b46bc2a540mr9171253ljg.15.1692120795222;
        Tue, 15 Aug 2023 10:33:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 00/16] caching and SQ/CQ optimisations
Date:   Tue, 15 Aug 2023 18:31:29 +0100
Message-ID: <cover.1692119257.git.asml.silence@gmail.com>
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

Patch 1-5 optimise io_fill_cqe_req

Patch 6-7 combine iopoll and normal completion paths

Patch 8 should improve CPU caching of SQ/CQ pointers

Patch 9 removes conditionally SQ indirection (->sq_array). Assuming we'll
make it a default in liburing, Patch 10 optimises it with static_key.

Patch 10-15 shuffle io_ring_ctx fields.

Patch 16 inlines io_fill_cqe_req.

Testing with t/io_uring nops only for now

                QD2     QD4     QD8     QD16    QD32
baseline:       17.3    26.6    36.4    43.7    49.4
Patches 1-15:   17.8    27.4    37.9    45.8    51.2
Patches 1-16:   17.9    28.2    39.3    47.8    54

L1 load misses decreased from 1.7% to 1.3%, I don't think it's
significant and it will be more interesting to see how it looks
when we do actual IO.

Pavel Begunkov (16):
  io_uring: improve cqe !tracing hot path
  io_uring: cqe init hardening
  io_uring: simplify big_cqe handling
  io_uring: refactor __io_get_cqe()
  io_uring: optimise extra io_get_cqe null check
  io_uring: reorder cqring_flush and wakeups
  io_uring: merge iopoll and normal completion paths
  io_uring: compact SQ/CQ heads/tails
  io_uring: add option to remove SQ indirection
  io_uring: static_key for !IORING_SETUP_NO_SQARRAY
  io_uring: move non aligned field to the end
  io_uring: banish non-hot data to end of io_ring_ctx
  io_uring: separate task_work/waiting cache line
  io_uring: move multishot cqe cache in ctx
  io_uring: move iopoll ctx fields around
  io_uring: force inline io_fill_cqe_req

 include/linux/io_uring_types.h | 129 ++++++++++++++++----------------
 include/uapi/linux/io_uring.h  |   5 ++
 io_uring/io_uring.c            | 130 ++++++++++++++++++---------------
 io_uring/io_uring.h            |  58 +++++++--------
 io_uring/rw.c                  |  24 ++----
 io_uring/uring_cmd.c           |   5 +-
 6 files changed, 173 insertions(+), 178 deletions(-)

-- 
2.41.0

