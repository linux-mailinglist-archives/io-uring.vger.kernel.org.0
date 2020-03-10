Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CD6180118
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgCJPEn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:43 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:46673 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgCJPEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:41 -0400
Received: by mail-il1-f194.google.com with SMTP id e8so12258149ilc.13
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHdDo0OvmfMXRs5la8a/G7V89jVhoTaAvfqIWj6qxic=;
        b=IGin7W8NAEM0PCBpONk4iDoMBZI2TV43WoXrZX75B1TBlLW8rQkoBe6sqgtwlVUWgW
         HpqZHZeZ/qeqvExK6++js02bqhkWsmaRyz38vDU+ZJ+lhkmNuua7DRp4M2hTCQlmrUFy
         LLqCUH3m2bCEb0hn4dm7F3AYPwMDZIvvtPWK3zptJEY37yBQsPSrkCh1h0jnwygo57bu
         3rj7I0uDt7b8eVOz5a2Koth+yH5/G5EIAmnTreCLRjhzl3w6gPyobxXHffoHiEIVMl4J
         +Fqkzi6UxWzHo9PdBTGLz6DsCZyfuL+3daCvbw1K7IoBt5VOtwtKG/VnEKPLFgE/Nc3e
         FwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHdDo0OvmfMXRs5la8a/G7V89jVhoTaAvfqIWj6qxic=;
        b=uaScBlGRAhqXIKwX4oK1mkx9VX8EB0l6D3+SBNN00cKeLBYNr2cfMeTgO7hd8fiWeU
         kjypl6CIunMZsEL5dEky/zwUk/WHmmCoOKyawysIsIcUPwT+vspXDvfhbpqnUpRBlzUA
         ZVUubiVhUfqO2mrl8QxVjlhsa1739g/OBCgMFDnAuEAp3peB+QGVYm62633SZoSToEHO
         yqXpnyy+D5PgenE+itZvTE1y0I748jZH6CinhQfW2doobs2i4QB/9zePTnAoiXOHiAHK
         h04j8Pj7jis5FY1TtFa/Itp5t2J3noLTZHcEhBW3tIqHbL08QFviFEUmOz0y4dLir4DR
         tl5w==
X-Gm-Message-State: ANhLgQ0zEvghM6xsC90oD9TAIdjjOKsKWJzk1M4mbwzPBWtD4N6p1xVm
        GAHYyoF9vHvv4oALtxlSqKi89yAbzI6fCg==
X-Google-Smtp-Source: ADFU+vtX7R36bFTJPdffaxsmyP1jmFXLV2UI8gt5dLD9uQLeOo3M3ARDfn8Dr/ZkOLz348VW1HHNZQ==
X-Received: by 2002:a92:760e:: with SMTP id r14mr19711019ilc.59.1583852680675;
        Tue, 10 Mar 2020 08:04:40 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring: add end-of-bits marker and build time verify it
Date:   Tue, 10 Mar 2020 09:04:25 -0600
Message-Id: <20200310150427.28489-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not easy to tell if we're going over the size of bits we can shove
in req->flags, so add an end-of-bits marker and a BUILD_BUG_ON()
check for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0760a0099760..f8a3f6843698 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -511,6 +511,9 @@ enum {
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+
+	/* not a real bit, just to check we're not overflowing the space */
+	__REQ_F_LAST_BIT,
 };
 
 enum {
@@ -8006,6 +8009,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
+	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
 	return 0;
 };
-- 
2.25.1

