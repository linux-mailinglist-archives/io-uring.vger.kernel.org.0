Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4474DBCD3
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358411AbiCQCGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358401AbiCQCGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CBF1E3F4
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:04:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id hw13so7778111ejc.9
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DAK6sXuuhqE2MqS0nlfhbvQrWfyjlmly2DW5++xDGs=;
        b=mXX/tDIEnHd6JxM7pVIHqKOhVb6EcZ0XFwYaWi6Dqasn3xeX/eLibGJLZ9vuvW6aoo
         dKofYuUOpkpIWl7eMsu16Ov3nNAxXc9A9NwRJq4VFhfU4jGLeDjAMk4+o9QjTnFHW1p3
         Uvx5e0fDR65wfN+JkFBGGSntxFlOmU1oRyXpxc5Pd6+Yp52OT2rU8hHk74B3AB6+/xbG
         05ATY3h4JuTVDZWjfFSLgxgf2vDHLKcoJIn81vskOQEOdQqeZEbQVSAECM3iTFUdWl7s
         VxktggWj5Lh9NNnJ3iGodrafqGHynS+slHp5aARKhaJhBrd180H1hvuVjwv2U1PXoSOx
         s9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DAK6sXuuhqE2MqS0nlfhbvQrWfyjlmly2DW5++xDGs=;
        b=2/ZXRK23FOa6zWuYfPxKUON5g9jlzCXWMrA+01r6x/DM4BIhykeNoHyemWmyf8rvbM
         qUdxJUNSN/HvgNaTlow1CjXFnVjqHmfdW9Afrst01cOVu58tO5HP6ZkuyMr5Ul5FXTps
         ky09fjcw7W65wFvps65NWyC+7/ga+Eco2sN+jU+GEXiYLi4MW5MTbMupULkYRgF7mlZI
         7YDfaqf3nagmiA3/pul7hi9yTIxjYXKdoJdFWhiYCwz8ZxBNek0HIGzRWwcODeD2VQ5C
         kpPj1/AukMid8e6THAZXmfATDWPyKRxVe1/0lCC4zXKu0dQ4oK5TdJcPMhdvZELP4Y7k
         MCfA==
X-Gm-Message-State: AOAM533fYQy8SfyybDhMyk9DpCW1rHp+RjAirnO8fLHvF25WtHTPj7HF
        nWAWL4iZ+AFGDcvQPRyBrurhLNUl/2/qIw==
X-Google-Smtp-Source: ABdhPJxnTQ1KJyK5mA8UjX/6MW0nNnIAtuUEMaIBZD38L3wnH+xy7lsoy+2WmJUn1kkCPwU6HNmUxA==
X-Received: by 2002:a17:906:a1d3:b0:6d0:80ea:2fde with SMTP id bx19-20020a170906a1d300b006d080ea2fdemr2230398ejb.344.1647482695913;
        Wed, 16 Mar 2022 19:04:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:04:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/7] completion path optimisations
Date:   Thu, 17 Mar 2022 02:03:35 +0000
Message-Id: <cover.1647481208.git.asml.silence@gmail.com>
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

A small series that for me prepares the code for further work but is
also adds some nice optimisations for completion path, including
removing an extra smp_mb() from the iopoll path.

Pavel Begunkov (7):
  io_uring: normilise naming for fill_cqe*
  io_uring: refactor timeout cancellation cqe posting
  io_uring: extend provided buf return to fails
  io_uring: remove extra barrier for non-sqpoll iopoll
  io_uring: shuffle io_eventfd_signal() bits around
  io_uring: thin down io_commit_cqring()
  io_uring: fold evfd signalling under a slower path

 fs/io_uring.c | 106 +++++++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 52 deletions(-)

-- 
2.35.1

