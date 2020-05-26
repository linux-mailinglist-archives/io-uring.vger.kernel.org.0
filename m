Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A541E29C3
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 20:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgEZSLB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 14:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgEZSLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 14:11:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7F1C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 11:11:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b91so18464445edf.3
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 11:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BN2z3wR6a6vj0boam0eiv2BdfvbKKftLZOU1BJ5qR+k=;
        b=E09e3UjI4HfXUlENNexLDtzWbevl1uWKVt7igTDmkWs2wESr/V9u93+BfYuIFHLiFg
         KmgHvZFErYFKDQh7Jc5Co+K6S2iHOgQ+96vdJMwZb1BFI2Q5Dwu/1i03XSm2PUkKvq4w
         sFRi+P4zwg1QS8MKTZfIlhZQ+LbLE2DLOOqEb258hol/xTNSmOkIgZp6icgm3Pda4lm4
         vPr0EutcTuyqG/lsPzARXj8SLGReCDglXRXofnh6xHAJtbr0wlba1zrx6Yg1xm5vTTSE
         h43TqMCXHAvCJOcNLw410UwguQjM9p7TzRXMc5705m8cNTuMbY4KDiu8/phWfTLCIhDl
         0vAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=BN2z3wR6a6vj0boam0eiv2BdfvbKKftLZOU1BJ5qR+k=;
        b=VfoPvnocOc3NcrcN3zGXAhC9YLqxOfh0De5AvgIkF+g1Wumex8AiI0FLVc7seUkU/x
         ktav/luQdDF8cdujWL99iVWrM6UD1fFvl4nMC1yxLT5gmcgUBYTqx8DP+yv2sJALo0JU
         CSm558bZKu8fzKUm0uk5IUNviodStkGZXEEJn3I2VYlmKVmNO+91xST/XzFS2OhCYhk0
         eg+4KmxvVcmY8NkArl8etFdImW+MIcunuEhEvtHsuWQeaxlDOQkIrGSGeVrq3VejdWV6
         /yYcVoT2BEr7RMx5X9uxkx3AGboQHTMp2ZgBgX9XNHjH0qxiwc5cqm07cxMwegGhvDf2
         jBfQ==
X-Gm-Message-State: AOAM530Z98UeiVM/KHLy+btzyWxKsxw4BMUCevfNBJHoBT9UZZdpn8KF
        6s59Tfu8GQG1rz6WkkiraWqKEBH1
X-Google-Smtp-Source: ABdhPJzTUDbz7yfRsOO2pcuN823jIHaZ4hEs314co8VEwh52UCsGg0J3h1nAEbLjdvFm5Bh8M1R/Fw==
X-Received: by 2002:aa7:d596:: with SMTP id r22mr21828664edq.379.1590516658685;
        Tue, 26 May 2020 11:10:58 -0700 (PDT)
Received: from [192.168.43.99] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 25sm492622ejy.32.2020.05.26.11.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 11:10:58 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [RFC] .flush and io_uring_cancel_files
Message-ID: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
Date:   Tue, 26 May 2020 21:09:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It looks like taking ->uring_lock should work like kind of grace
period for struct files_struct and io_uring_flush(), and that would
solve the race with "fcheck(ctx->ring_fd) == ctx->ring_file".

Can you take a look? If you like it, I'll send a proper patch
and a bunch of cleanups on top.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index a3dbd5f40391..012af200dc72 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5557,12 +5557,11 @@ static int io_grab_files(struct io_kiocb *req)
 	 * the fd has changed since we started down this path, and disallow
 	 * this operation if it has.
 	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		req->flags |= REQ_F_INFLIGHT;
-		req->work.files = current->files;
-		ret = 0;
-	}
+	list_add(&req->inflight_entry, &ctx->inflight_list);
+	req->flags |= REQ_F_INFLIGHT;
+	req->work.files = current->files;
+	ret = 0;
+
 	spin_unlock_irq(&ctx->inflight_lock);
 	rcu_read_unlock();

@@ -7479,6 +7478,10 @@ static int io_uring_release(struct inode *inode, struct
file *file)
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
+	/* wait all submitters that can race for @files */
+	mutex_lock(&ctx->uring_lock);
+	mutex_unlock(&ctx->uring_lock);
+
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);

-- 
Pavel Begunkov
