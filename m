Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942BD7902B3
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 22:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244823AbjIAUBL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 16:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjIAUBK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 16:01:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D3510FB
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 13:01:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6874a386ec7so306483b3a.1
        for <io-uring@vger.kernel.org>; Fri, 01 Sep 2023 13:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1693598467; x=1694203267; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBz2an2I8OdGPvhS0d9juN9PWqLBnNhMGFqWjCDQMxI=;
        b=wtOx8gujRin0YpvDYUgwRYAI0POoGnc+B97gxOeAUrbHck99XrETp8CX4H+BGLDe6Q
         o/w9nR9VeppzGRXtcZyrv+dVYbUw5Mwtou/shmAE2wLmtw95YU1zH7/MSprrQMJOBhI5
         cq9J9ocbH086v7CXlzW6gEydRkp4n6UqN987aFqDeTcRXxHDJRa6F573nrFYh6cwvPpq
         YOI7fgRD9q9CXeRyQQyLwGByA2kGK3Jyf5b7Xx3Wcy1fOFeti7mlhaJFki+S4WwVhf/N
         hQajo9igtSiaK31mSpecq01eUaci/jxpXtB/39ZXbfVQFcTC6efmSfDt2Mir91wVEjRn
         lIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693598467; x=1694203267;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VBz2an2I8OdGPvhS0d9juN9PWqLBnNhMGFqWjCDQMxI=;
        b=beU4zApJFfzj14ZU405ABicOTs8ZqDY2NnE2UXvZeTizax8xRS89zsVGqi5tu67jo5
         vhNuvm3QrAHHY4eRYMrUpKbRKUpWQkOOc8tD3GkuE6znLwEkZvK0ygIbj2kdNT67E/lL
         BTB7mS0w3s8pMOATMc/dxkeepQdXeqE0QfxEDjG5jyUo6LZmNKczUnSg1aCC5IZPI0YK
         JuZpS2lMMeZNNThXwNNNS7d61bmqBGyp9MvzGRGF4p6vw0b9mxUkMROzljGuWsxhthh9
         KdKw2gZf/GzvhPI4cFB8t6kBaWzY9qKJxKNuTokaHruO8EkDkzrmbboa2V5lf+ITfga7
         U3Wg==
X-Gm-Message-State: AOJu0YwAHENivYhP72k8gapjpePE8U9Fl4XvJpBrt4vzuh8syQQnztWW
        RuTAvhojFUGQVKPFAogeoRLM0KeFIthOaYIqfmkxlQ==
X-Google-Smtp-Source: AGHT+IFEt4yvEqQPg/dzACnoz5X4vGkW+KujdIIvkha+0RMqSHUr8sp+8/5CBqjtx4cWfDg8q/HPLQ==
X-Received: by 2002:a05:6a00:3014:b0:68c:9c2:ab4e with SMTP id ay20-20020a056a00301400b0068c09c2ab4emr3977065pfb.1.1693598467222;
        Fri, 01 Sep 2023 13:01:07 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g24-20020aa78758000000b0068bc44dc40dsm3300382pfo.34.2023.09.01.13.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 13:01:06 -0700 (PDT)
Message-ID: <6a715702-69e6-48a0-b278-5624d0c5c58d@kernel.dk>
Date:   Fri, 1 Sep 2023 14:01:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/fdinfo: only print ->sq_array[] if it's there
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a ring is setup with IORING_SETUP_NO_SQARRAY, then we don't have
the SQ array. Don't try to dump info from it through fdinfo if that
is the case.

Reported-by: syzbot+216e2ea6e0bf4a0acdd7@syzkaller.appspotmail.com
Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 300455b4bc12..c53678875416 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -93,6 +93,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 		struct io_uring_sqe *sqe;
 		unsigned int sq_idx;
 
+		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
+			break;
 		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;

-- 
Jens Axboe

