Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1787B324F
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 14:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjI2MTb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 08:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjI2MTb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 08:19:31 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15917BE
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 05:19:29 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9936b3d0286so1886525566b.0
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 05:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695989967; x=1696594767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=duqqzoSmQpSO45g4CJ7xTleI0G4bXedDcmtvhVAa8CM=;
        b=jCM8TtWi1D5d/z5bGv5EBcCb5TES7C4otUnNepsiltTrtQcssvSdYWaByuokW6ICoN
         6KMO2tN9pM2Zi/4dvnQv27l4PL3pMOwre0BQCOQRFMxEi9gfBQ07p/MqcsgjwF28ZivO
         8E/tV6dv3ev2RjWXhkhgOWCxhwxb5qetNa+CuXeyt/iIfUsfJ5KFr1CIxuZlls08XuMo
         +19tfD70/dkX/Jh50qXwyO5VUEPq4wZAAQN8AEa0nRP5Tk4gGWqA5gPdTuECuPk6cLFZ
         qDmO/yhiznEtCYNTuZkrlls4kaG6ibt4x16OFtXqpVlkRNFVvfwl0OosCP1seC4CNQhT
         m3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695989967; x=1696594767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=duqqzoSmQpSO45g4CJ7xTleI0G4bXedDcmtvhVAa8CM=;
        b=AWG4+GEgz9njlLTlSxIbx1e7SndxryldNbsfYbyopOB8KH2X1tuzwQCgqfc0dbZ1Hl
         ErjC5bMRwODiDCn4DtrWAMTfpbeDn3x18K6qORZYgoePZPQoUEjalrrU7mh4nQzc8gNM
         b/JozX/UmRweN/iY4v2oSl794aHIJX1ownXmpcryv2tX6M2Yzdba9aeYKip5o0N0jr48
         pcpxVBHAP1eVrFf0JAz6hsixQsh+yx1LoOj0eCJ1mBBKctQ7pWOJYvsjY6jqS4gFA6bm
         o+yNN4lobrl4pe0MtL1eZjgmpnu/PaYfY4KesqjGO+LYEU0Re1a7eI9NaR3vqKbwVV8x
         FgQg==
X-Gm-Message-State: AOJu0YzLrYfPQb45ZhDo3EIlZTk1o6WFS9LP0p50sm8e/guowzL8vdUU
        uHyLY5IqYs5gtfzualGwDtZwxU+G8A6+YQ==
X-Google-Smtp-Source: AGHT+IH1StnN1ZczMirfqYsdTWqq/YhyYvEOsG0LvnIpj3eF4BubfmYEnUQM0XExFTVZCsITCSn8Ww==
X-Received: by 2002:a17:906:3299:b0:9ae:5ba3:9d8f with SMTP id 25-20020a170906329900b009ae5ba39d8fmr3749925ejw.17.1695989966925;
        Fri, 29 Sep 2023 05:19:26 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-229-128.dab.02.net. [82.132.229.128])
        by smtp.gmail.com with ESMTPSA id jx10-20020a170906ca4a00b009ad87d1be17sm12211878ejb.22.2023.09.29.05.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 05:19:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/2] liburing IORING_SETUP_NO_SQARRAY support
Date:   Fri, 29 Sep 2023 13:09:39 +0100
Message-ID: <cover.1695988793.git.asml.silence@gmail.com>
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

Patch 1 adds support for IORING_SETUP_NO_SQARRAY, i.e. not using and
mmaping the first SQ indirection level sq_array.

Patch 2 defaults liburing to using IORING_SETUP_NO_SQARRAY. If it's
not supported by the kernel we'll fallback to a setup without the
flag. If the user specifically asks for IORING_SETUP_NO_SQARRAY,
it'll also fail if the feature is unsupported.

Note: two tests need sqarray, and so there is a new helper
__io_uring_queue_init_params(), which is not static but not
exported by the library. Further, we don't declare it in
liburing.h but only under tests to prevent misuse.

Pavel Begunkov (2):
  setup: add IORING_SETUP_NO_SQARRAY support
  setup: default to IORING_SETUP_NO_SQARRAY

 src/include/liburing/io_uring.h |  5 ++++
 src/setup.c                     | 42 +++++++++++++++++++++++++--------
 test/accept-reuse.c             |  2 +-
 test/helpers.h                  | 13 ++++++++++
 test/io_uring_enter.c           |  7 ++++--
 5 files changed, 56 insertions(+), 13 deletions(-)

-- 
2.41.0

