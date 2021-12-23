Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EDB47DE1C
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 04:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346218AbhLWDga (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 22:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346196AbhLWDga (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 22:36:30 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23C7C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 19:36:29 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id d14so3277334ila.1
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 19:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=w9TcSG0XvHV5vrn2K2FBw6x9HoR3khNodeW+jDMDs5s=;
        b=X1kw6lr81Id8pDLjAryD0pMZi4T1eivuUkK2ohFSd6YPHRDjzDOYfcioaBqq/eetkB
         8XKSxvYalRasFH+Gmvdamz7aA2QwVw5DcXcDpNX/jksfqQncJRSXhd40Nyqu3lTKcDDK
         6asUMKjJhbSR47F1Ko+S1MWkWA92BnivlCcK81fkav6UP2afIAEVbvPEwSsbsc8h2nup
         VH5LeSAk259z0tGKB/pyX0xVJImkuXtRserwKHLujcJJxJXjigv2Hl0137rhQ3EcLk83
         CKMHLFCGxnars4kqyxj20vdNhthO6oc9ioBpPLchAPTWAGdbli+aCygN0GhPBaCO0ENS
         KzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=w9TcSG0XvHV5vrn2K2FBw6x9HoR3khNodeW+jDMDs5s=;
        b=znm5exbTacj5qbnuKRswcxS8DmRlwokyh/hUvqFmN1n1hHf0FPtXdKze3z+D+Alld3
         wnSbfKvfLd44KvKI/2mEuk2QYAUskB5X0HcNHCH9xisegFjZ5YkE/wq1iL4ZZX6L7kI7
         asfsy2j8lvPmX5xpVUKLAdBtRQWBjQl7/RIWBCBa3SVFu/KQq7wLex5k6QQV1cEmdV7Y
         5tEkLdoP5VE9awjeoISHSTLAXii1EcBDAW0HoKdjFWVTKZ2lOGpv+6l4YeAjZgvASATs
         7xLl6VymrDMV8TSYHQB1Z/N1fBm2coeXOqxe9Hh5JdFb0xmnxS/wB2WXHJL704RfOnVz
         MU8Q==
X-Gm-Message-State: AOAM532BGz6w9r+IgbpSS3FfmdP1jVLIPNvgvnI2rTJuitJJxUvLiUzF
        4oIGOgFh4lC9kkyUy372yemVkDBmv1OKNg==
X-Google-Smtp-Source: ABdhPJxevGY+O3nwW3jVPZ1T3aW8QtWKqCvSDP58hKwa/jpJedvRBUs4tkkDRAr7Wgeh+fqh4TkbMg==
X-Received: by 2002:a05:6e02:20e3:: with SMTP id q3mr201542ilv.301.1640230589044;
        Wed, 22 Dec 2021 19:36:29 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z19sm2122972ill.47.2021.12.22.19.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 19:36:28 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Samuel Williams <samuel.williams@oriontransfer.co.nz>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: zero iocb->ki_pos for stream file types
Message-ID: <cac6976c-7b2a-621a-27d3-175506103222@kernel.dk>
Date:   Wed, 22 Dec 2021 20:36:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring supports using offset == -1 for using the current file position,
and we read that in as part of read/write command setup. For the non-iter
read/write types we pass in NULL for the position pointer, but for the
iter types we should not be passing any anything but 0 for the position
for a stream.

Clear kiocb->ki_pos if the file is a stream, don't leave it as -1. If we
do, then the request will error with -ESPIPE.

Fixes: ba04291eb66e ("io_uring: allow use of offset == -1 to mean file position")
Link: https://github.com/axboe/liburing/discussions/501
Reported-by: Samuel Williams <samuel.williams@oriontransfer.co.nz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5ab0e9a3f29..fb2a0cb4aaf8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2891,9 +2891,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1 && !(file->f_mode & FMODE_STREAM)) {
-		req->flags |= REQ_F_CUR_POS;
-		kiocb->ki_pos = file->f_pos;
+	if (kiocb->ki_pos == -1) {
+		if (!(file->f_mode & FMODE_STREAM)) {
+			req->flags |= REQ_F_CUR_POS;
+			kiocb->ki_pos = file->f_pos;
+		} else {
+			kiocb->ki_pos = 0;
+		}
 	}
 	kiocb->ki_flags = iocb_flags(file);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));

-- 
Jens Axboe

