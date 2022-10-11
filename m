Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DC65FB6D9
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 17:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiJKPUt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Oct 2022 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiJKPUV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Oct 2022 11:20:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D82DB3B0E
        for <io-uring@vger.kernel.org>; Tue, 11 Oct 2022 08:11:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so16303190pjs.4
        for <io-uring@vger.kernel.org>; Tue, 11 Oct 2022 08:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKoNdZmaWxiwcZvOg9M2QS4FTy6hGWtfZE7fNcJYTDw=;
        b=cMz7VYnnmjh4CwEUYBK8eBrqRawelDkHjBHbN7r6EKpF46Wu+5tunaEUBHmj4rNbTd
         qcsVToyUr9lsG85ghy/4qiqzKvdPBGQ9MIUHFNrZdIN49QgzCbkgVSXwg6JCLB1ZVmrn
         ngeXM8LjwDE7StBs2aPJ00jUdCajMhtiSNzDwM3fl8qbDi9xaAiDKAewjxmnqY8K8IAQ
         PguzvVf+nq7muiSaiRZMQsb47tjh6Eebb3IFEMd19VUjvo0SmShn8ok0XH1SE2S4FDe+
         EJ0JQgpAlPrx1mKWg8P0Pi3JoPTIhFYlJ2qn3B5faNowSEErPeUqLO9KUQoZRWpOvZcy
         20Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yKoNdZmaWxiwcZvOg9M2QS4FTy6hGWtfZE7fNcJYTDw=;
        b=1hBSbOzXVY11lAuZ8uu9AFLXiBHKxXQlljcmizEAxLP2LDgFn2/cXT9GwZcGDDtkjz
         EL/Ip64UzYRaCNiCNLznGvZFeyhB561VAm504KIdDrQzjjNPQllQjt+j3O20CfSAe5eZ
         ruj43KGIlA7v+ss1IG0Mc4o+OOUIp9aDeY3MAgFBmgkFLLNI6hqY8QSgBRglE8mqDsJv
         B0wN2oIy+JMpiOeZi5qVyVMzwxI6twat5xSKJxJwJPHo/zQOS0F19W3kYRBsUoAGrTXc
         b7D5PthKp/qv7R08FRaBMhl1i66pZLgEYDJEdzPkTeqanB1S7UESDYondORXjSX5Zp1j
         HcDg==
X-Gm-Message-State: ACrzQf2FOdIBZM9N8FFIxtQeZHuao/uTTYh8F+5PMR2IslugixFT8jY8
        GkDHBtI8sUKnwz+xzgpE4Z+DEKp7JRdJX4q7
X-Google-Smtp-Source: AMsMyM4r9WlPTcVIW1J8Ki7IMSFDt/ePEkOajJuCog0sAxwizKYkb3vNqJog986bwOBjfT7fL6jTpA==
X-Received: by 2002:a17:90b:1c06:b0:20a:f070:9f3c with SMTP id oc6-20020a17090b1c0600b0020af0709f3cmr27956071pjb.151.1665501021642;
        Tue, 11 Oct 2022 08:10:21 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i29-20020aa796fd000000b005624ce0beb5sm9177258pfq.43.2022.10.11.08.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 08:10:21 -0700 (PDT)
Message-ID: <c150e763-2cc9-96bc-4886-52aad17fd559@kernel.dk>
Date:   Tue, 11 Oct 2022 09:10:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: ensure kiocb_end_write() is always called
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit moved the notifications and end-write handling, but
it is now missing a few spots where we also want to call both of those.
Without that, we can potentially be missing file notifications, and
more importantly, have an imbalance in the super_block writers sem
accounting.

Fixes: b000145e9907 ("io_uring/rw: defer fsnotify calls to task context")
Reported-by: Dave Chinner <david@fromorbit.com>
Link: https://lore.kernel.org/all/20221010050319.GC2703033@dread.disaster.area/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 453e0ae92160..100de2626e47 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -234,11 +234,34 @@ static void kiocb_end_write(struct io_kiocb *req)
 	}
 }
 
+/*
+ * Trigger the notifications after having done some IO, and finish the write
+ * accounting, if any.
+ */
+static void io_req_io_end(struct io_kiocb *req)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	WARN_ON(!in_task());
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+}
+
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
+			/*
+			 * Reissue will start accounting again, finish the
+			 * current cycle.
+			 */
+			io_req_io_end(req);
 			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return true;
 		}
@@ -264,15 +287,7 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
-
+	io_req_io_end(req);
 	io_req_task_complete(req, locked);
 }
 
@@ -317,6 +332,11 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
+			/*
+			 * Safe to call io_end from here as we're inline
+			 * from the submission path.
+			 */
+			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;

-- 
Jens Axboe
