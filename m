Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363097D6F13
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 16:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjJYOj4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 10:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344790AbjJYOEA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 10:04:00 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DB8189
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 07:03:57 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7a6643ba679so40446139f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 07:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698242636; x=1698847436; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmmBJe4qx/Z0FecJmP2HKoWoGSGv5MNLqFmWTEvkhKI=;
        b=a/8qgnaEyPA2+d8L9scDYh0UYOxTJMS3BK0vc5+KINadxbd8jQdWq6+LEwx98nOVly
         QYPXB7WikXnW7AijKNEUhH3X3mNTwxws0+hr9itZeAWfE7zkEv+j0sQaEQyDGjTfPI5m
         Z63kUysNIdyjWSZS7XeBfu+j3muxPa0v1WQoll8aqn8y9vFZVyrvshAYBcKoxkC03yT9
         Jsl+Syxfw0fyhDGofGoSgoVI/H2VyOu0CF4ILccExRaYfztxPUiyBg3E20syJ87UiipT
         ubsIRvA5ZZO5cfEixyMI9Idhv53GILJcjwqxvJauCzg0yB9iWlMK+e/gRdweVnuXGgAv
         jqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698242636; x=1698847436;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xmmBJe4qx/Z0FecJmP2HKoWoGSGv5MNLqFmWTEvkhKI=;
        b=Rh3SdhFLb+6x4OMxzSn3+YcP9jHQ77xLazrBzdjgYclLH2F8FLkf3Y2tjExit9vJCG
         DWOTmmSO2WLUgwN9IxcbQTfI/HVKJNzNcyffJjMRbK1XHDURUflcuWTDYvEauJxJXye+
         4PiG65ceKafFDRCdjvs7o0z1gMN1C9tJS41GZFqQIgp29Ojspk4mRAGlXuJG7M/DeCsN
         ZuE3f9WkFkrGiav3xoJpx+2Lvi2Ec4BlrhWYbia/e9RoZ1ALvRM2n760WVF9GiDKjsi6
         boXEPDwC/qFdZkbrKNG6d/BXTjqtDzgTQEoyozjBSbLZfUxOsENQGQxfQG5VjJ7iV32e
         8qqw==
X-Gm-Message-State: AOJu0YwQSpEiQ7nesrQ3xU9zLyJQ9Uf2SFFUdhmry3Z92LH0VbGYL5QC
        42KxFqfftsEaDpn0gMZj8xnXFQ5FuQBac4hDW9SmZA==
X-Google-Smtp-Source: AGHT+IFYmFywKXAzWWhg4qfxKE9/pCPls+VDtDPHa5McGJtGQk0XUmWH7jSIpHWbdFzkwKTT1x9JWg==
X-Received: by 2002:a05:6e02:ec1:b0:357:a986:18ee with SMTP id i1-20020a056e020ec100b00357a98618eemr12760905ilk.1.1698242635601;
        Wed, 25 Oct 2023 07:03:55 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y13-20020a92090d000000b0034fccc27c11sm3735496ilg.76.2023.10.25.07.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 07:03:55 -0700 (PDT)
Message-ID: <48d0ea0b-af74-4a2e-9961-0286466050a9@kernel.dk>
Date:   Wed, 25 Oct 2023 08:03:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Andres Freund <andres@anarazel.de>,
        Dave Chinner <david@fromorbit.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: disable IOCB_DIO_CALLER_COMP
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

If an application does O_DIRECT writes with io_uring and the file system
supports IOCB_DIO_CALLER_COMP, then completions of the dio write side is
done from the task_work that will post the completion event for said
write as well.

Whenever a dio write is done against a file, the inode i_dio_count is
elevated. This enables other callers to use inode_dio_wait() to wait for
previous writes to complete. If we defer the full dio completion to
task_work, we are dependent on that task_work being run before the
inode i_dio_count can be decremented.

If the same task that issues io_uring dio writes with
IOCB_DIO_CALLER_COMP performs a synchronous system call that calls
inode_dio_wait(), then we can deadlock as we're blocked sleeping on
the event to become true, but not processing the completions that will
result in the inode i_dio_count being decremented.

Until we can guarantee that this is the case, then disable the deferred
caller completions.

Fixes: 099ada2c8726 ("io_uring/rw: add write support for IOCB_DIO_CALLER_COMP")
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c8c822fa7980..807d83ab756e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -913,15 +913,6 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_start_write(kiocb);
 	kiocb->ki_flags |= IOCB_WRITE;
 
-	/*
-	 * For non-polled IO, set IOCB_DIO_CALLER_COMP, stating that our handler
-	 * groks deferring the completion to task context. This isn't
-	 * necessary and useful for polled IO as that can always complete
-	 * directly.
-	 */
-	if (!(kiocb->ki_flags & IOCB_HIPRI))
-		kiocb->ki_flags |= IOCB_DIO_CALLER_COMP;
-
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)

-- 
Jens Axboe

