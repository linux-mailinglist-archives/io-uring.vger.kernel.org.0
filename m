Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CB84F7F48
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 14:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245337AbiDGMmy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 08:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbiDGMmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 08:42:42 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF56E55228
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 05:40:42 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d3so7660772wrb.7
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 05:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcKlYTTeFKhFbeXvFpR4rY1eQ91Gsuc64svmAmIZN4Q=;
        b=dKnVpfDUZGYphwtBraRnaxhkf/WucWfcouKJxrkWaQ9LQSadFoBZgH/oc/xVbb0D6L
         6/aupry9vrKjG+twvyIrAPRZoJbB9GOREFLQtdzhf7IYhF599WWUPYosvr6X7oc7N7sK
         eIICtMhX8Mv6MPeI/fR7gIsy+mx0KufjYwHwDVAXN8ScDmJ312wHPBcwbK6AKF0Qe6rm
         0WafobYsOPagNpQIGBKADBl89r3xywwyc600pG3YXSUkm5pZczuxo8wzDhCbUHrnYR29
         ppcbXYtvvv1iu4R/+fxexVZsS76l38JAFiKtFhtshCyDk7xwobgd0+qqYk+kT33EngU8
         gNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcKlYTTeFKhFbeXvFpR4rY1eQ91Gsuc64svmAmIZN4Q=;
        b=aGeKEZrh/IrAfxrY78inCTOQY7HIkBcejdrf9l3HUwxmvXZtpJGSA0xVMXd+LIMSOR
         +xTt5TaddfRkvZZGYwfQMhDIcUcJUCNr4dz4Bh9cqh2Y1Uzq8QLLLaIFkH3ElbLxw5oo
         9B1pNdfkaUdllxbXuTAgaV60UXp8AgVyRvAgIolwj+s8ZFhjkbWcnb0Emg1ET0gpegL0
         1mVElnJbE3XfOmBmUc/iGpSjYhAg22VdMvIhtMbyvQWMniZ4WJ25pX0Frv/ORSAzkGLD
         gZPjtRsY1EuoMktmbKG066RrWoIGXCxjqeOHts6ocB3hRICw6y6LM0gr4jUvpNjv0kZc
         zOiA==
X-Gm-Message-State: AOAM532Wuyi0oWTD0z8zw02fTv9iJJoWXaHa4/6C6xl2kkDWSaNZHjcz
        snvBNi/TvO5WaAEIyn+45Spkyi/XXPA=
X-Google-Smtp-Source: ABdhPJzrQkFWJVzIyrKhRc5cnBK7+B4M0uYTzW3v1FqhMvwrHSwQ6z+Tg5vOGD7x/cPP1gqvsm9AOg==
X-Received: by 2002:adf:ef10:0:b0:205:ce51:743e with SMTP id e16-20020adfef10000000b00205ce51743emr10834074wro.522.1649335241239;
        Thu, 07 Apr 2022 05:40:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm9354781wmq.40.2022.04.07.05.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:40:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH next 0/5] simplify SCM accounting
Date:   Thu,  7 Apr 2022 13:40:00 +0100
Message-Id: <cover.1649334991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a refactoring series killing some lines of the SCM registration
side and making it simpler overall.

Pavel Begunkov (5):
  io_uring: uniform SCM accounting
  io_uring: refactor __io_sqe_files_scm
  io_uring: don't pass around fixed index for scm
  io_uring: deduplicate SCM accounting
  io_uring: rename io_sqe_file_register

 fs/io_uring.c | 227 ++++++++++++++------------------------------------
 1 file changed, 63 insertions(+), 164 deletions(-)

-- 
2.35.1

