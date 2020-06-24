Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFD20798A
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405197AbgFXQvu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 12:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404870AbgFXQvu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 12:51:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E1C061573;
        Wed, 24 Jun 2020 09:51:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so2949568wrs.11;
        Wed, 24 Jun 2020 09:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nM2coQx7hoysPBegeDWFljq+2PbJajIfawopODzY7HY=;
        b=QDOefWcRSdTcVLuz57YrVXwp86RPEQjL9ojg7Dfb5qoAbejpNUE4RhStfS8SDTkEpe
         Vi465cUzgzTjsjL+LIt9nsqhDq1T7/A8XaMZjzrMQqqKTK+zvaU612ttIVxOa3NZUMlV
         tikYFlnVGX7QO1Tfj7KVqZSYPozYieOMthgYLJba9YkGdOXsH+jGpNb4pffhuFIceOzy
         1gpD2SZMqxB4cA4K5Wor6Aeh8e6fQ/ombzLYGUtZBAoaA9YxcdxNDjttM1UOFEv29RZQ
         qpUM2WDG6DH0u4hOAiMmyoIqduPXiRpzcAl8A2MAw+LP9pkqdcIy9gKAk6q7MNFwp8uw
         tYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nM2coQx7hoysPBegeDWFljq+2PbJajIfawopODzY7HY=;
        b=ZgFZiHFhB1e9IGhNZlY/cQ0Xs5BWv8OYzvSW+rkL5Wry8Ms0qwtx/zManpV+2Z/vfn
         1cAwHctL+FCkZHVlklGLj84I44BD4itGGhIjtVAugfvxQ5Qa/tap2sZkL5dnL2j/T68w
         4GiOpRrSQF+lfJI6iNmVcXAvndofzhDfixeIW0wVes/+H3CAcwdMMniRrSso0/0ob9X/
         CruQVpn7atTKi+aChZK2xE8HQ9sSiWaX32BV2nmtqLxQofSSGzynsyH7q8eiw7EnzuF9
         cu7EU9X753Dw/GzgT1qLRu86JT9pholoYOZFklBxoX1r2M56mWFtvbegMJUradzPOCo1
         Py4Q==
X-Gm-Message-State: AOAM533Nm8OsE3I2lBu0VYv3QAkUA74Zx2NiGttan+HQkjZNTC88gBXq
        hPWW5kO9x2dVoZ8nLKBF0X1F2Sx4
X-Google-Smtp-Source: ABdhPJyhQ6lSSJ5174IhjiBn/zN4r7Js4yfDcmKEZbGVPLkaGrI0M1b4bmY161qeoZ1KUvVyGEueag==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr30112920wru.310.1593017508365;
        Wed, 24 Jun 2020 09:51:48 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id z16sm18138182wrr.35.2020.06.24.09.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:51:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] iopoll fixes
Date:   Wed, 24 Jun 2020 19:50:06 +0300
Message-Id: <cover.1593016907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Did more comprehensive iopoll testing and found some more problems.

[1] is from the previous series. Actually, v2 for this one, addressing
the double-reissue bug found by Jens. It maybe not as efficient, but
simple and easy to backport.

[2,3] current->mm NULL deref

Pavel Begunkov (3):
  io_uring: fix hanging iopoll in case of -EAGAIN
  io_uring: fix current->mm NULL dereference on exit
  io_uring: fix NULL-mm for linked reqs

 fs/io_uring.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

-- 
2.24.0

