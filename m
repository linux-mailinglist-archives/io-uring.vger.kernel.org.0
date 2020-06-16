Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E1F1FBF39
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgFPTnl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 15:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgFPTnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 15:43:39 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BAEC061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:43:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c3so21983488wru.12
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AY0DJWgiKPx/Z0p/v5D2N/6h8Cv60xsDyHV/5aVXg/E=;
        b=uB5Ec0B2dABPbIXbiwWXUEzhatdoNdqy2Lk4mW1O1CRCAcsPhALH+9Z4x4Toq6iai+
         ddjMHqDSJVZ30+nOS2y0bJYlmpXiv7Ap7UdvVmaShs/1jamEkBut7kTEW9IHB3dA/Nk/
         AGsF+kAgj5DWkJTxtFkwiZnhR2C3m5g5VeF3lQwAbOJxq6KvILjpuT/uwvqofwYozWri
         p0vj6qqFrVjLuihvkgWYHqRcgLLEk4HYQN58w7XcG/xvroinOjWrcptMCYQUtU/64hNa
         bFgrjfpjMNHeL2AVgP97tw3IpknScy5K4Jd9cvdx8xwUR2ZjhlzmcX0Po8fIUoC2OZZx
         npug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AY0DJWgiKPx/Z0p/v5D2N/6h8Cv60xsDyHV/5aVXg/E=;
        b=azNwN0DlkpI+Azosln28IC63vnFftGte2+m4XbSSzoFcr2rEYUOF+r446D9jvd3w66
         Ef3fswzHQByW7J5MAbKWugSXZB5mE8FL9S27fN8X39lYmZFJN3QGEHdJ402wJe8gesZK
         cFfPC7tIm8IAJY1jWbSf/Feg4mWX0oWsbNukuT6U0of+cXs58RKwDuzlV8PFQ6v+fAhi
         PrI/OoumOOGrBtJtdQ0JR/oJm8IromSc+p/a/0F+vHQC9R7tLzYz4Zd803YfILuaTgKc
         1CHmhDqiytMVntVeLTS71qENHsJKKVi9D+KZBnh7lZvKsI0H9gN5jwyz0hEmlu70Qo3N
         vWUg==
X-Gm-Message-State: AOAM532Jcjiv+0XL3W/BEXiZ24a0m9KpgYyqdhjsrzbBnsgVj1A9zhBq
        EKh4ILLlxos+9I1LtyKjqsrWM3A4
X-Google-Smtp-Source: ABdhPJzEPY+Rofr2WGjY4Fis2Bfi5ATZvmqtzS/BPc09Yz9mEBV/3d8PyVaMajqmfbp9FWK3FPtwsQ==
X-Received: by 2002:adf:f6ce:: with SMTP id y14mr4886927wrp.90.1592336616701;
        Tue, 16 Jun 2020 12:43:36 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id u130sm5518150wmg.32.2020.06.16.12.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 12:43:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test/stdout: fix strcmp non-\0 string
Date:   Tue, 16 Jun 2020 22:42:01 +0300
Message-Id: <ec5c66bd2bf8ae8c190ebf4894f58a039c131845.1592336391.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After copying len(str) bytes of a string, the copy won't necessary have
\0 terminator, that makes test_pipe_io_fixed() to fail. Use memcmp().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/stdout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/stdout.c b/test/stdout.c
index 440ea20..ddc9eec 100644
--- a/test/stdout.c
+++ b/test/stdout.c
@@ -84,7 +84,7 @@ static int test_pipe_io_fixed(struct io_uring *ring)
 					(unsigned long) cqe->user_data);
 			goto err;
 		}
-		if (cqe->user_data == 2 && strcmp(str, buffer)) {
+		if (cqe->user_data == 2 && memcmp(str, buffer, strlen(str))) {
 			fprintf(stderr, "read data mismatch\n");
 			goto err;
 		}
-- 
2.24.0

