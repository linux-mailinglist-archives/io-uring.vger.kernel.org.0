Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6C6B5083
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCJTFj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 14:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjCJTFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 14:05:38 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12B812FD19;
        Fri, 10 Mar 2023 11:05:36 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso6823893wmq.1;
        Fri, 10 Mar 2023 11:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678475135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qnZxvF0PZgGlXBT9bGeH/QAOxzjxQU6JzB9LYz2gJVk=;
        b=PUttA2bjLPcDH65tgzhUIuvEYDybgDx+kyslxZWTTtiV/hrTXNXsGk4n6wTOSI3o9H
         5qr0iItzMnwkXOezBXD0z51uIUHFtAWnDkVbP/yuMN7DPd5KtMfDNmYHZsgP7/cCnBw6
         DhqDxfFM6YpCZKkwhAV5rHl5botPIEF+bO7xtQgrLcUMQhnqRUSPGwF2WOGSjLdjt3mi
         qdXqL8GgG/5j7tsEKoJsD/EM77vEXO2VV5zpqj1JA3pl70MeEAiDrf5pivMJHQMsPmOQ
         e/y7vkKl+2+uCOg0XQRYRweb3Fi9tfGhBiu6VDYUUYsdQMGR5JH90AtA8Qrc56zWXFDn
         k7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678475135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qnZxvF0PZgGlXBT9bGeH/QAOxzjxQU6JzB9LYz2gJVk=;
        b=u9SeDEIP+68+MwL5s1cUj/og/fOcABo73wNhIf7iXF2evOUPGzNCejgHbyE2wkK/rr
         aOyKX0AEh3go5Wwl2uw/+yELgb6h+OkYBRP3FS8Lly7hc6ISocsHQzwhMSPD2ADWrqPn
         APPnPUCIx5jj82HIr4a0NixbF/BS3P5C6sykdIchlJEf1UIxhuN5+SQ0n+5jAB26JsRT
         A2kBmu8gxVdLnN0hY3qYky5chbh0rqqGqWE3bXmXrdcjrLuYpipRcVxthCQOpYjq7lKq
         f+IoPTbvEcN9VcPbTLQFzfxa2526hK54c17sfQxMny7tS4g8eiXzVOEFMdaf43+5g+mb
         r78w==
X-Gm-Message-State: AO0yUKUIBUxwzIvT1CBMK+ytj0nGG54TcoU+ncA/Oga2oIiBbC0reB0N
        3LACgx3SlN6aFaQ+4th6SSosaOPK8SA=
X-Google-Smtp-Source: AK7set+FKuq+ViYU6I2WhDmAedbgUiGWyYMiGNFUNAATOjt9IvMyREaDfBITj35Tg+XBFsnT3NXbkw==
X-Received: by 2002:a05:600c:3b11:b0:3eb:38b0:e757 with SMTP id m17-20020a05600c3b1100b003eb38b0e757mr2812376wms.10.1678475135057;
        Fri, 10 Mar 2023 11:05:35 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id z19-20020a1c4c13000000b003e20cf0408esm647882wmf.40.2023.03.10.11.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 11:05:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] optimise local-tw task resheduling
Date:   Fri, 10 Mar 2023 19:04:14 +0000
Message-Id: <cover.1678474375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

io_uring extensively uses task_work, but when a task is waiting
for multiple CQEs it causes lots of rescheduling. This series
is an attempt to optimise it and be a base for future improvements.

For some zc network tests eventually waiting for a portion of 
buffers I've got 10x descrease in the number of context switches,
which reduced the CPU consumption more than twice (17% -> 8%).
It also helps storage cases, while running fio/t/io_uring against
a low performant drive it got 2x descrease of the number of context
switches for QD8 and ~4 times for QD32.

Not for inclusion yet, I want to add an optimisation for when
waiting for 1 CQE.

Pavel Begunkov (2):
  io_uring: add tw add flags
  io_uring: reduce sheduling due to tw

 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 48 ++++++++++++++++++++--------------
 io_uring/io_uring.h            | 10 +++++--
 io_uring/notif.h               |  2 +-
 io_uring/rw.c                  |  2 +-
 5 files changed, 40 insertions(+), 24 deletions(-)

-- 
2.39.1

