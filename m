Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2809E57CEAB
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiGUPLZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiGUPLZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:11:25 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AC9326CF
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:11:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id e69so1562950iof.5
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=jrQNbN0de3PVZmOOmHvCMy6UrChafhBhhbUqqDZzRwA=;
        b=ncgGW3AJIPG5zOEsCyUnrZqj1KsbX3siJTIVpKVK5gY5yQh8/Rd5JHspcXNQIm/ebE
         1wIgE9JMrqA1/lAPY36tFMk8wXyNZR1xv18KNxIXoTORbHieFrKEqJdmg41rE+ybQJqr
         0iYQ/UuYqV0jHWT33cvWGt9ogoTH9agJvkQN4fngkXQ4/x4lX/aOExqdTmsoEwaNc149
         P4YS4Af0TAOpXM15PwRcJm+hfnxXSY8ArtmdIvmfzpQXSrYtUPQjElKuOOcHIm2PIs8B
         5jxFu1WUrkTY+yAFFr/4W0r4c8kb7Gnt2vd4ouYRPcOf2Z4DJp47RgMmtg8/sp2HnqIm
         vhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=jrQNbN0de3PVZmOOmHvCMy6UrChafhBhhbUqqDZzRwA=;
        b=fRr207TQCNAvnoEsZ+l2AbMFHq/JiBjyQPxmlvMt1PISg43Bjx20Qgup8nyHUt873p
         C8y07gtsHtmYCkmoMlJVe2e5DkboiErSt8J+ps5BaDk9PxxtEQjnT5fTKoT3Ntz5U+6w
         IG2J+mccdyPk37mw9vJ2bVEflDPWpQlxMjdj+RXLQvsjtQgVTIIG6wUaPfYyTEzLtfLf
         5HiIogtX8qA3wFuEXeluSsuuWIPTpdoKD8R+uPmPaUP4aR3V70WJXFYvSsY1RzrbIede
         4aRQ7WepQQN9MPHy0Dh2bGe+CBm8MHii6l2JJzSzpbnOJMmhnlo7qSquGiDF20DsMm7f
         JYSg==
X-Gm-Message-State: AJIora9L7MU9iLOiJI3ggZOF+Y5naAc5sVIbMjIarecipZJnXzWyeTG+
        JmujQJ6L76A+NmCHjOwm9ityRKocr8Yi9A==
X-Google-Smtp-Source: AGRyM1u8nc6rVa0w8SznUnhc7MuU7M8EO9H8Yj1Gqs/Uea9ZUEbbJ3HfgNGoaLS3mmc82IXtoS+Zyg==
X-Received: by 2002:a6b:5d09:0:b0:67b:d670:8813 with SMTP id r9-20020a6b5d09000000b0067bd6708813mr15442283iob.10.1658416283157;
        Thu, 21 Jul 2022 08:11:23 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t22-20020a02b196000000b0033efc8857c0sm895350jah.50.2022.07.21.08.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 08:11:22 -0700 (PDT)
Message-ID: <a4c89aea-bc3c-b2f6-a1ae-2121e3353d79@kernel.dk>
Date:   Thu, 21 Jul 2022 09:11:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Yin Fengwei <fengwei.yin@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure REQ_F_ISREG is set async offload
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

If we're offloading requests directly to io-wq because IOSQE_ASYNC was
set in the sqe, we can miss hashing writes appropriately because we
haven't set REQ_F_ISREG yet. This can cause a performance regression
with buffered writes, as io-wq then no longer correctly serializes writes
to that file.

Ensure that we set the flags in io_prep_async_work(), which will cause
the io-wq work item to be hashed appropriately.

Fixes: 584b0180f0f4 ("io_uring: move read/write file prep state into actual opcode handler")
Link: https://lore.kernel.org/io-uring/20220608080054.GB22428@xsang-OptiPlex-9020/
Reported-and-tested-by: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Yin, this is the 5.20 version. Once this lands upstream, I'll get the
5.19/18 variant sent to stable as well. Thanks!

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 624535c62565..4b3fd645d023 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -406,6 +406,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
+	if (req->file && !io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 868f45d55543..5db0a60dc04e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -41,6 +41,11 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
+static inline bool io_req_ffs_set(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_FIXED_FILE;
+}
+
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_work_add(struct io_kiocb *req);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index ade3e235f277..c50a0d66d67a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -647,11 +647,6 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
-static inline bool io_req_ffs_set(struct io_kiocb *req)
-{
-	return req->flags & REQ_F_FIXED_FILE;
-}
-
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req);

-- 
Jens Axboe

