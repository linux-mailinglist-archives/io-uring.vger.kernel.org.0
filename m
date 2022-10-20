Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE960552F
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiJTBvG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJTBvE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:51:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFD115A94F
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:01 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id q9so44096599ejd.0
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/zyjPO8NHm2KLEkOBArsz2x7GqLvO9iVzTJq0MO9Zw=;
        b=j0YeXTMzhW4GqjEHq0bnQInPUrmjGqMrnL91NfbkILfeo65VZi2h+0b4WxhDCsasm5
         sSWh9Btr5wzi0X9iiayY7174T3FJyaspJC0i4CBwdth9roV24Zx8Yg8fHF7czqui3sdt
         uGEyA+ZeY6TwzcNA65h7y986nJSJDAbo9rouMokMfU92SxDISHcu4GmWautagDYXTjj/
         Bb8xT7gfd/qJQjUeZ/M7wKFWAMkmtiOlvQ0DZ0e3oz46QhhRqzhxZRtlfXZooA216eqS
         m1LQUIT05xwlLfZfZ5/8PSSGci9XRouhlQnXTkkLnSaNswtQr6jxwH9me1CsQ7C9dOQn
         fDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/zyjPO8NHm2KLEkOBArsz2x7GqLvO9iVzTJq0MO9Zw=;
        b=uYguGjfdnMlN9bevqHXKHfOL/bM9+z8qcmoQ1KGdQZq0+bw81GGguROYkZWdBqJQ+I
         FQTC87rGvcZjf9x01LMhzJNB2vYckcgbGKlGTLWPmI/dEp4O+SeWyUMfh/xSmL65ERvw
         zlLkepzqn9TjAkUtGXhy/PPAALGDxuSNYrVf3qCyjf5XLyW7hxArhKvSk1ZgLRDp6QTu
         sbMDgf8w9ZJRgrBtdYqzCUqFuI5qN8/nOypYcr0N2zWGUXOCIL/Gp1Rj2/UQ5FYq18a+
         PktEaIqONywASHUuy+O2aQJye20Ii4NrrsAsYzXRHHuAWmAtYewEImF1AlAUikktpSbv
         UcGA==
X-Gm-Message-State: ACrzQf3qz6NYPHt7GtuUbX1g9Q0+v7Ki8cQYW10VCD2/6YNrNosnXvcO
        EBQE2KczxpDyeNSNShl9ri+VxEm9Jvo=
X-Google-Smtp-Source: AMsMyM4CJCkNaMu8I/wYDC1IdLlOo4qlhawQtgt2jQbR4KMppVLWHtUxBrUjzgYfqVsShV8WIs14wQ==
X-Received: by 2002:a17:907:2c59:b0:78d:8e03:134 with SMTP id hf25-20020a1709072c5900b0078d8e030134mr8826988ejc.310.1666230660063;
        Wed, 19 Oct 2022 18:51:00 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a50ff0d000000b00451319a43dasm11318420edu.2.2022.10.19.18.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:50:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 0/5] expand send / zc tests
Date:   Thu, 20 Oct 2022 02:49:50 +0100
Message-Id: <cover.1666230529.git.asml.silence@gmail.com>
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

Patch 4 adds sendmsg testing with various iov lengths and configurations.
Patch 5 tests IORING_RECVSEND_POLL_FIRST. And patch 3 enables same testing
for non-zerocopy sends as we currently have poor coverage.

Pavel Begunkov (5):
  tests: improve zc cflags handling
  tests: pass params in a struct
  tests: add non-zc tests in send-zerocopy.c
  tests: add tests for retries with long iovec
  tests: test poll_first

 test/send-zerocopy.c | 188 ++++++++++++++++++++++++++++++-------------
 1 file changed, 133 insertions(+), 55 deletions(-)

-- 
2.38.0

