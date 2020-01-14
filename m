Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3C0139F7F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2020 03:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgANC1M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jan 2020 21:27:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45467 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbgANC1M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jan 2020 21:27:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so4585138pls.12
        for <io-uring@vger.kernel.org>; Mon, 13 Jan 2020 18:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+K/La58kC85jpfpX/n6TjjWqnBMBGpRAxh0gLlO9oMk=;
        b=rQFdutATrCLeZMtLozx/sT0HWmhWdXCXIdNJfruiyOI6BBklEzss4srZ1qyMph0gL7
         Vgj15hp559E+W788kHIBWMzP0OOMgvgfxhs/xWVt8w/BuHya9cZJh5L4g6HhWJSToIzL
         xBQ/KlW5lPEVnX7skRdj5jKHa98qU+o+puuK0DbQkfFL6vdZF83igtmJUgmjy+bo7yiI
         2qqsKgR6UARrgiYzEYmQpJqCIc96YoZ91ShtH3PsaQQsZVWZ+5iUzMiTs6Azyibea4Dm
         X4YTxM9oiP25zCg6BZ4HXitnyr2l0ViZoeQxr96wW6BXOsFlRzQZgPi0xgPxGLqETilA
         6r+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+K/La58kC85jpfpX/n6TjjWqnBMBGpRAxh0gLlO9oMk=;
        b=LQtBR+G2akN3O2YzN1fYZvmHxFt7oeZ3M2suEtCiLumfdFiUX6VmtooT/TpwBPod/k
         zbohCxVOuixpFyKNVOdD3XUu/zOJ02yhqqua1OFsN1kyz1l1XLrfpzYLA5skjP760VHd
         1TecS0z3tsAWDwKu1CvDDlo83qzpYRukTaLjzgx2WnfXyqHWpedhZon0drsuYnI5RYc3
         ej8GRtGA6lCq0BXk2hZwORHpVUZUBeJSLVH/byThMIRSIKs6n4pycDSWkJ4svMKNwQ2P
         vznFtPtwZF2rumI2NMmim2t3TXvFwnznscHIuvdQJVDYid6ZTwhVxsvE5ggUxp6BBv1w
         OKOA==
X-Gm-Message-State: APjAAAUlGYnw0pFHn/aJi1m2WD862Ud9+G7yhILlZ2R2zSCqLCaOloRs
        Ju/3sVs0J1lj3t1mtKDJ77v62N3aPoI=
X-Google-Smtp-Source: APXvYqxNoapJ1Ii2xIdB0i098z+rPl6IUajEVDO92mEv6eNNF0gCPdvgKSgIeCgTna8VD065RahGbg==
X-Received: by 2002:a17:902:426:: with SMTP id 35mr17266938ple.302.1578968831417;
        Mon, 13 Jan 2020 18:27:11 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11b3? ([2620:10d:c090:180::cc0b])
        by smtp.gmail.com with ESMTPSA id p23sm15104873pgh.83.2020.01.13.18.27.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 18:27:10 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't setup async context for read/write fixed
Message-ID: <1973dbe2-50e3-8f4c-72dc-8928161b1adb@kernel.dk>
Date:   Mon, 13 Jan 2020 19:27:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need it, and if we have it, then the retry handler will attempt
to copy the non-existent iovec with the inline iovec, with a segment
count that doesn't make sense.

Fixes: f67676d160c6 ("io_uring: ensure async punted read/write requests copy iovec")
Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38b54051facd..8321c2f5589b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1786,6 +1786,9 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 			     struct iovec *iovec, struct iovec *fast_iov,
 			     struct iov_iter *iter)
 {
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED)
+		return 0;
 	if (!req->io && io_alloc_async_ctx(req))
 		return -ENOMEM;
 
-- 
Jens Axboe

