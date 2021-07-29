Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D9D3DA71B
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhG2PGk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhG2PGk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C26C0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q3so7414997wrx.0
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yjwrP1S10568AYbSqJZ/+jtdTCly/B80QgvudqI3kVk=;
        b=Yvzly+QPoV/SJxuLFvCAcxnamr3IOU5jp/6d9SSmbrNZxaGHYNBI4IWiS0AlWcsai/
         uEPvMRFR8yFFF1oKw9J5eQ3S3iIYq8pJPLICgRF2HYWHM+lR87WSSj21EqTzIDe03M7O
         6+JLsKOf3ugT+o4SRk9uYfBTm4h1s/TIu0ZY5LCFTID1K8kyGK3E0owIugOl1+yPQKBU
         RRSlF3Ql2lNNqEkm9jhSRncPorSKMn3xU1DPVSHMnmYBkk2L9ZKx+z7lCnuKGvRn8QO2
         WMnPiix3xZtCfhVBnfsiO+fqa1GebRWe6yof0jMOS6jkjVLjZHRSTGyh7VkAgU+9wcPg
         eQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjwrP1S10568AYbSqJZ/+jtdTCly/B80QgvudqI3kVk=;
        b=J+eVcIDtZ7tV8PezVgaRmehrhNhvxl03650wz6/FxY7qFuHn/p8g8W4WU3T5Mfi51V
         5GW2IAG3061mo3ky5Vuh1F8pWt1vqMvjEe9Yp3RKTROgE7lrSqNi/S+zioFVmmiEDjz2
         mRfjpUMK9njgZTfqQdo0j8AdNw+gppOBLjgoKQFchF3AXBng/gIheWgs6iT6EefyX7tD
         PAh2d9Etp/eFahT7+rJfX0BuqtJR819MO5AlCRyWHJ68FH7hz7KSYL85hXoOW6ppXMck
         K12a1OF/XPWR6Ya65mcabOHNQrB7JT7DXu9bpm605EzEuYn0nTkva9nCQ2w2B8Jx1Rfe
         l0bQ==
X-Gm-Message-State: AOAM530bPyRFdFSqOPLUL6GuJCPW2ZxwGuhQkoS3798rnZjReXVZykGL
        SpvoxXsJGMhgbovjYePlb0Q=
X-Google-Smtp-Source: ABdhPJz+5afG5apm5YU0fwiTd2Z37kY4kltY7tZOyjOA9KwuKj+dnuiYgbFXZ8DcN1D5yHErjHp/0A==
X-Received: by 2002:a5d:59ab:: with SMTP id p11mr4281067wrr.238.1627571194588;
        Thu, 29 Jul 2021 08:06:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/23] io_uring: kill unused IO_IOPOLL_BATCH
Date:   Thu, 29 Jul 2021 16:05:40 +0100
Message-Id: <84898bbf4f8678f45d1390add280b750cc256aba.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO_IOPOLL_BATCH is not used, delete it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce56b2952042..7066b5f84091 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -300,7 +300,6 @@ struct io_sq_data {
 	struct completion	exited;
 };
 
-#define IO_IOPOLL_BATCH			8
 #define IO_COMPL_BATCH			32
 #define IO_REQ_CACHE_SIZE		32
 #define IO_REQ_ALLOC_BATCH		8
-- 
2.32.0

