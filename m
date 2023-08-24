Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3D0787BAF
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbjHXWzl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244008AbjHXWz0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:26 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DA91FD3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so86995066b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917718; x=1693522518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JzsDuSlR5DY0vdsNlGE1Yhv7A+WJadsQDhv7O7oletw=;
        b=dHlOMwMj1l+P8mBxmbhCHIG7A9y5ezYwxv9VnOjPyBGjTNur/51Np23V2L3H2q0plS
         bF7EZA35lA2Mc7cUVEvtCj5hWT4Is6cDCzPNcmErq4IJpBB8gbgExlg+VrI0QhVCHAzQ
         Bf/tCy8VP0WjWfGS+IkYO7RRKtbRr69UJJuylWXSucFJlyllcwyN3/9HRtvsJN7INCMk
         qpCmo81ELLduAlkR/B8FbRpM0B6woBRowiAMccUIvB2YDtXun2m8VatIVuNkMv9Mcu5f
         y31DQkcI1EJOJN7eAs2upS/4DAdhv1juetXD2x43moDVlBp1Er/2kfz3GF3eyBdmBs2B
         LGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917718; x=1693522518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzsDuSlR5DY0vdsNlGE1Yhv7A+WJadsQDhv7O7oletw=;
        b=FpH9NCQ43w/wc1dv4WABEAixNEOOH16HduWcZghH7s+kfwRKnjGrHMZ8IFZs0IWP3U
         ziXrYTgCH+OUKsHZLsk5ts2FoNMNXydlF1vBXtaVjRyyrv7bATYdOgVE8ybZFdj3PKaA
         xmabYVcfpXHPSMpZ8QUcdrJFwX7Xl8gfFdAyB94D4Nnc1/fcrJzOWUJkEtfysWkox4tF
         hwAsTWqlcm7diOEr6PTqR/6QIx0nLBxxEbamyCP3qH9X1mVpfAsMcFm8vKj1aQ6fuHIG
         HGQEF0VM3TMK5iDVZ12TmDl7kqQpiAqXz+4GdDexG+1H8q9W988MWkEJBZvN3FeBEWXA
         Lmrg==
X-Gm-Message-State: AOJu0YytuXXWY13ksjSF70M8tB5jaWCw+vrkeUydtmS15yDYKCYu2TuW
        5jeoF5iuOwlHq1X49aLexd6/V88L71I=
X-Google-Smtp-Source: AGHT+IF07Uc7LmgXfWn1SuIA2AMt5jYyO4sKzFokRT1AH8f+7X/mOnnb2KXQum/wSnJJ5GeZU3/GjA==
X-Received: by 2002:a17:907:7e8c:b0:978:8979:c66c with SMTP id qb12-20020a1709077e8c00b009788979c66cmr19837238ejc.18.1692917717901;
        Thu, 24 Aug 2023 15:55:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 00/15] caching and SQ/CQ optimisations
Date:   Thu, 24 Aug 2023 23:53:22 +0100
Message-ID: <cover.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Patch 1-5 optimise io_fill_cqe_req

Patch 6-7 combine iopoll and normal completion paths

Patch 8 inlines io_fill_cqe_req.

Patch 9 should improve CPU caching of SQ/CQ pointers

Patch 10 removes conditionally SQ indirection (->sq_array). Assuming we'll
make it a default in liburing, Patch 10 optimises it with static_key.

Patch 11-15 shuffle io_ring_ctx fields.

Testing with t/io_uring nops only for now

                QD2     QD4     QD8     QD16    QD32
baseline:       17.3    26.6    36.4    43.7    49.4
Patches 1-15:   17.8    27.4    37.9    45.8    51.2
Patches 1-16:   17.9    28.2    39.3    47.8    54

v2:
  removed static_key, it'll be submitted later after it rolls out well
  minor description changes

Pavel Begunkov (15):
  io_uring: improve cqe !tracing hot path
  io_uring: cqe init hardening
  io_uring: simplify big_cqe handling
  io_uring: refactor __io_get_cqe()
  io_uring: optimise extra io_get_cqe null check
  io_uring: reorder cqring_flush and wakeups
  io_uring: merge iopoll and normal completion paths
  io_uring: force inline io_fill_cqe_req
  io_uring: compact SQ/CQ heads/tails
  io_uring: add option to remove SQ indirection
  io_uring: move non aligned field to the end
  io_uring: banish non-hot data to end of io_ring_ctx
  io_uring: separate task_work/waiting cache line
  io_uring: move multishot cqe cache in ctx
  io_uring: move iopoll ctx fields around

 include/linux/io_uring_types.h | 129 +++++++++++++++++----------------
 include/uapi/linux/io_uring.h  |   5 ++
 io_uring/io_uring.c            | 120 +++++++++++++++---------------
 io_uring/io_uring.h            |  58 +++++++--------
 io_uring/rw.c                  |  24 ++----
 io_uring/uring_cmd.c           |   5 +-
 6 files changed, 163 insertions(+), 178 deletions(-)

-- 
2.41.0

