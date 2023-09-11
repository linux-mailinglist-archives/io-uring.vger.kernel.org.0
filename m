Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11DE79BCE1
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbjIKWKO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244544AbjIKUkc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 16:40:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1580127
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68cb5278e3fso1012292b3a.1
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694464827; x=1695069627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9V9a5OK9Iy8QE1Mjd/+uWyQONY2gF9HS1th7ayJRu5A=;
        b=u+I3ujcGd9pHknxpojvCzK00d7zeHXEPYDdcFn75gMaRDT94xJjHV3k0qArsWnh3NG
         uePOq92RHFVaFgyN28e4LnzMGJkmhT33kK4Gw68iX9xD3/Cy+m5V1dB0C14caxVhvJhM
         Z9A6vm/GrBwm7DZz5pjLq2jZ7uycyXzqJvx+vu7YxLDTAvMdisHa25eGmQth9j0J92a+
         rx5sv9HnZkb4pWytTVtwR81QJuPDtZYSY+iGgDLcbUU0Yp20eLkxw9cklv9dHQC/f28b
         O0tk/NvPujw1xAaVfXMN3UUtj44JPKAKYvt06IBQf+UT0x6xt5ZVH67L/WeTJA88a3Xz
         WoSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694464827; x=1695069627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9V9a5OK9Iy8QE1Mjd/+uWyQONY2gF9HS1th7ayJRu5A=;
        b=jpo1KRoMmlgdJnol7jmG1vQtz7OpjArOxQx554aKuZJso04yQ4nuBlicKzTkVKRtZK
         FeUB94AbhVAm8kOEh8xyW971r8Bu8oqcw4E9IEgoioq5ahaZ0IOsdpL01EpLfT9T64oA
         x3VBx4XznPtfWsTh1jux4FHxU+kJ6jdz7/RNMeDhlZXvKF0XIkr72lT/eiIYdikT8wXl
         dHaZ9qvtOUDkB7qZnRuLjS9AKJverRQj3TiTaHatpJow4f+wTe+oEgEiHDp+27+6HckJ
         zLyWYhkaBQdoWEWJVGUlW50QjvXsLMe1aFeCzkY2G4wh3oPHgtDllkKsDthgClt6rDpx
         df7Q==
X-Gm-Message-State: AOJu0YwepW3WRIosFqaV1paeHAYXPBa/thStEi+X/RTahDp2wDqBPrSb
        opakdKXrqcMtlLC9BI97QydPpnPxr8MrzYQu8tYdmQ==
X-Google-Smtp-Source: AGHT+IFtildw1ndsq0i+1vRvVH+SEaumkQPQWRSZSvmYf1GvCwT/EwEWSm2WzzSOnL7pDJKmRC3WpA==
X-Received: by 2002:a05:6a00:1d08:b0:68a:6cbe:35a7 with SMTP id a8-20020a056a001d0800b0068a6cbe35a7mr10934526pfx.2.1694464826821;
        Mon, 11 Sep 2023 13:40:26 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ef22-20020a056a002c9600b0068fe5a5a566sm100544pfb.142.2023.09.11.13.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 13:40:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/rw: split io_read() into a helper
Date:   Mon, 11 Sep 2023 14:40:19 -0600
Message-Id: <20230911204021.1479172-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911204021.1479172-1-axboe@kernel.dk>
References: <20230911204021.1479172-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add __io_read() which does the grunt of the work, leaving the completion
side to the new io_read(). No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c8c822fa7980..402e8bf002d6 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -708,7 +708,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	return 0;
 }
 
-int io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_rw_state __s, *s = &__s;
@@ -853,6 +853,17 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
 		kfree(iovec);
+	return ret;
+}
+
+int io_read(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret = __io_read(req, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return kiocb_done(req, ret, issue_flags);
 }
 
-- 
2.40.1

