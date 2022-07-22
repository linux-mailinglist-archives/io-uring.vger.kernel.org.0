Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D957A57E01F
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 12:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiGVKiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 06:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGVKiN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 06:38:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88939BA24E
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 03:38:12 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z13so5905086wro.13
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 03:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RF4r1/BP4SDcsNkq6DLEWpwkqSj6Us0K8eDJKS9E/2E=;
        b=k/e3CUc9QtcOuJdbI+It719PkXLaVP0PUUlaMlaQ50Z3myMMITTVujfuzidQF60iOU
         9Fp3e6ReR44R5pcuY9pM+3qF/gMD/cvq7D9W5kZqfgYGeWG2rjyWHQZgQdIaPhpLDEXK
         3ry8EqoFw1OwOzogkH/sUPjFH4rs0aDhd+EAyP6xzquyoWkfAmdL2sHd4EMhhLVKcfng
         CeeywkNXJ8mOpQXIlxFewLrUNrZdc/7I6R5BDGka8ZhLHcmWH93N/t6ch7Qf/8vJIIaa
         sz755kOdfagwOABOH4uh1se9c/rybve6DK47ZHyWA50kPoqlTtvhBBgSGxTOfPSdlHLf
         LL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RF4r1/BP4SDcsNkq6DLEWpwkqSj6Us0K8eDJKS9E/2E=;
        b=GLgsR8sPEqvIU6X7BbhQ+qz7mQaxtxC7pnDjcHLvdYN/vf2sID3RbeNV562trR/Yd6
         OFtW1axH1YDQVT/HLGIH9L+mG+FpKjrSiB4UUIuuoRkzt4umhW8ls0i+GBladthJ3vu9
         rjjQ5TGWcU2DCCj2juGWkpTIEFhIMnvrI0864GM0d81uLtB/s88macB3wKd/XftDE2mm
         kwnrRUkTDTHb5XzEkpBjNimNEsdxy5sHVhWYtWBblA3IwIGn2iIBU25gGToZY5o3Z3GS
         sTTiYZhjXgXFRNLlXZZvfqCPh3kNg6oUBWVfCOe9AAJtEtHV60Uae1xPCIK2xwuB+alr
         wTGA==
X-Gm-Message-State: AJIora/Ovh42+L7VT/yMEv+JRw5LTQC/9l6YMpLsdrBXx63YGOuSFD5F
        MQO2zA8gue0r4qsAqP6SL5w8DnyNNNigWw==
X-Google-Smtp-Source: AGRyM1sC6C/D3r8HMP1krEjpZphrOQu0jmZFWmPDi3wGyjUEY4K5fpOwXIQxxJuenQKftNdZLFuSOA==
X-Received: by 2002:a5d:5250:0:b0:21e:526c:d4ad with SMTP id k16-20020a5d5250000000b0021e526cd4admr1898963wrc.103.1658486290636;
        Fri, 22 Jul 2022 03:38:10 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3d])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c205500b003a2eacc8179sm4572832wmg.27.2022.07.22.03.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 03:38:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 0/2] single issuer tests and poll bench
Date:   Fri, 22 Jul 2022 11:37:04 +0100
Message-Id: <cover.1658484803.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Add some IORING_SETUP_SINGLE_ISSUER testing and poll benchmark.

Pavel Begunkov (2):
  examples: add a simple single-shot poll benchmark
  tests: test IORING_SETUP_SINGLE_ISSUER

 examples/Makefile     |   3 +-
 examples/poll-bench.c | 101 ++++++++++++++++++++++++++++
 test/Makefile         |   1 +
 test/single-issuer.c  | 153 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 257 insertions(+), 1 deletion(-)
 create mode 100644 examples/poll-bench.c
 create mode 100644 test/single-issuer.c

-- 
2.37.0

