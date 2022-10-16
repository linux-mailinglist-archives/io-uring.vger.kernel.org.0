Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4172600344
	for <lists+io-uring@lfdr.de>; Sun, 16 Oct 2022 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJPUdG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 16:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJPUdF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 16:33:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EC83057D
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bj12so20785080ejb.13
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wuLcgGyI2Cwif1n5q2WessTYFf2UlAmRlRWqvkFWk+k=;
        b=fONm6xLym4iW+//EWFKIyb69AZFUo322o7iB/LJFSqriLUrl2a/gGscZGDzV4VLX2v
         xQM0wg6jP8ACnwgFErDgg/wa8c3Ba0+rgTXBZyk+hSQqbE89wEj/XW9H0U4YFVxQ02z2
         TypWlsZM0LPOkdBMo18ofvofPq8owEoM5BTyejR2vAkgSE1Hi7gst9bV/0pWUUFF8t2U
         97PkiaEYqUfBlfJYeykhhDSLQaSXtrlVaz29wt0+CUCKD8FXIxadmuLsMGQFKWuh67ME
         qTmYfvVuc5FanxAwuO87r+zv3g5Kx9CC550XEJjhVC306H84tV2ph800h7p9uDAlRx2Q
         +iVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuLcgGyI2Cwif1n5q2WessTYFf2UlAmRlRWqvkFWk+k=;
        b=FowLbrIvnTYgIeRvqnR1BaMYG6gBqkGjm9UEiEDV4dXAVjnKyewR2gCnHao7JSdglL
         zFau7rToP+pU0ceb57ohDmbQsugYOw0UGQhmKOyiDATUMSNf9I2swINgGtgTiDJu1kBe
         FsWwyqV1XMacpYjd3yM+97wOt+zu67xQT7KhVSq4lIuMR+daAkJP6E8DejU9xgUqv1I2
         ml6Dn60J71FlfGdPYliuqcIFJwqYztXJViAX/rL459WMnG35ZdR4qPLgBdWct2YB6XCD
         gtsTPXG/3aNj4JxNGGa36y9vFPRjBrtGo1miud7VmIS4Zyx71Ely35Bpm33HVAQTUEae
         0dxQ==
X-Gm-Message-State: ACrzQf3clQ8XAOdfFKNjMxMifQ9vlrtiupqnh+G1oSukQjRi4AQLv0gq
        vNc+xRy1aLdQStvgQ6TX2ksSdZHGKLc=
X-Google-Smtp-Source: AMsMyM53zaSQE0vqdmu6OY97eINbl6ebRZq+f/5v+LABUJ+8Q7FCljrTOzK9JhWlczTSgpgklmXiJA==
X-Received: by 2002:a17:907:980e:b0:78d:b6d5:661e with SMTP id ji14-20020a170907980e00b0078db6d5661emr6295186ejc.46.1665952382344;
        Sun, 16 Oct 2022 13:33:02 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709060a8b00b00788c622fa2csm5069345ejf.135.2022.10.16.13.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:33:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/4] random io_uring cleanups
Date:   Sun, 16 Oct 2022 21:30:47 +0100
Message-Id: <cover.1665891182.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

A small cleanup series partly following up after recent fixes.

Pavel Begunkov (4):
  io_uring: remove FFS_SCM
  io_uring: kill hot path fixed file bitmap debug checks
  io_uring: reuse io_alloc_req()
  io_uring: don't iopoll from io_ring_ctx_wait_and_kill()

 io_uring/filetable.h | 16 ++--------------
 io_uring/io_uring.c  | 24 +++++++-----------------
 io_uring/rsrc.c      |  7 ++-----
 io_uring/rsrc.h      |  4 ----
 4 files changed, 11 insertions(+), 40 deletions(-)

-- 
2.38.0

