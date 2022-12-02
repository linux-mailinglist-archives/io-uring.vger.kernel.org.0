Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFF6640C8A
	for <lists+io-uring@lfdr.de>; Fri,  2 Dec 2022 18:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiLBRss (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Dec 2022 12:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiLBRsr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Dec 2022 12:48:47 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EE3C1BD2
        for <io-uring@vger.kernel.org>; Fri,  2 Dec 2022 09:48:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h12so8868920wrv.10
        for <io-uring@vger.kernel.org>; Fri, 02 Dec 2022 09:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fLpVPalB2KMlujjK+fEMuD36lVi8Li6Vp/yKNLArXGk=;
        b=TJDcjOte4sIRXKKeru9UzzFaFr2/8oQpO1YvMKq0ohxQS5tMQK1aesavsoUuaU59Gz
         bUid8FAcAP+bi9Q/B/BdddwSOZFbQ9f++8cj37HXir3uROazKCVPBUtKdPJqUnJjsR0F
         MrVo/Y58ioDfvk0uX7WOp4huj/g/LX/QNHmnSdW0ROcdOzwe3odiMNID+kLH7FH2Fwu+
         mw0/I2UVVf6ixetvPBBPypyIMTQJxWsYtxbSlGEGR58lwluy4SUf100mfkA+3k0eqk50
         yiFHQd9X4eW4ahb+LY+WBLaOiNeFSqbiXNRGCsvAvsJUB820sAoQjJ0UCD0LeGHH78H/
         3Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fLpVPalB2KMlujjK+fEMuD36lVi8Li6Vp/yKNLArXGk=;
        b=hCtOujmZ0wN0rvO6Fl+qcMd2x/3tBQAPTWLVkdGUq/CMKxQ9+7KNIj3FPfzE8O/X6f
         7BZz0ZuuSzO9T6pkEzBWj7PnXNu9oN3qtAldZmoon4xAu0MxaSGVJWbvkmp5UNJoECzA
         rcqPwxo95QPB18gC5B1MyfJWe/b0BMI5Ag2lQEpwzi6FTWiSSQAiBoKZcmUT6Ob0h/iF
         vHGkcGU57KXiP1zR5xPqnDAjM7LHSA2o6QQpqhMXmWRogVpQXaV8XGjO0hUKvyu7hiqs
         ta+bbs5lQTVWT8s6MVvZalud9nU1QmpC+Yjplxd4EfzuVV2vBBz0jdlT1TSXB0xjfQVK
         d9AA==
X-Gm-Message-State: ANoB5pkbYc/4WrFZ8MRUHDqegnNVFrA2aVfy5lN04L4aJu+rXCWMVF3H
        hOJK9hHU8QOeT+LDCMfAj7J7MdjiR/g=
X-Google-Smtp-Source: AA0mqf4fRHh6ZYTMnHh2c/FTZe0IuKpopdqki01nS/NpoHx1Thf3I9zoWSVZxYw0TMLO7olWdObxSw==
X-Received: by 2002:adf:d215:0:b0:242:2fd8:ac with SMTP id j21-20020adfd215000000b002422fd800acmr7810932wrh.162.1670003325331;
        Fri, 02 Dec 2022 09:48:45 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm9368585wrc.72.2022.12.02.09.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:48:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/4] some 6.2 cleanups
Date:   Fri,  2 Dec 2022 17:47:21 +0000
Message-Id: <cover.1670002973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Random cleanups, mostly around locking and timeouts. Even though 1/4 is
makred for stable it shouldn't be too important.

Pavel Begunkov (4):
  io_uring: protect cq_timeouts with timeout_lock
  io_uring: revise completion_lock locking
  io_uring: ease timeout flush locking requirements
  io_uring: rename __io_fill_cqe_req

 io_uring/io_uring.c | 29 ++++++++++++++++++++---------
 io_uring/io_uring.h | 13 +------------
 io_uring/rw.c       |  2 +-
 io_uring/timeout.c  | 14 +++++++++-----
 4 files changed, 31 insertions(+), 27 deletions(-)

-- 
2.38.1

