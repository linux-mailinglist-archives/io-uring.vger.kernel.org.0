Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70433417C07
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348266AbhIXT7P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344226AbhIXT7O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:59:14 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C821C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:57:41 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id q14so11690309ils.5
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cmmqjStBo0kla4JkfUGMM0gp7Ea9JpziSXM0loGa8Nk=;
        b=oTqciDPSMH0zWfnHAv7Zc31Wm+/lDSN0WTWnrCKavgi6PJYuYTV+URSF7xkqdZkdKk
         HftztLGZ0/3ET+3SVaKqqOAYV55KYclCIPNfSGhzyKopSrr94mEeZ/CrcCFI0WhpsKHJ
         PKSeLK3Bor5Gna6fFTk4ycvDHhQ2pQliUsoNAI+5GdzoTGjF3GikMF53rBky9S5IDFhr
         vPx+VHU/Zg7QRG98pWU10Up+A1O+JNHDDHzx4UfdT8aNiMoMCqXac2fJgm+5yulkgJFQ
         zZTIkmIuXuCrHIeUQ6YZpcpuzJPi3duLAovI/gQ4Xut4x+Nrt+1bYAPQH709vJZwj0l8
         P/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cmmqjStBo0kla4JkfUGMM0gp7Ea9JpziSXM0loGa8Nk=;
        b=jEIxNECtmN1tfrZeLOIoyzjML4hWM89NCjIJ9t2uNF61NnchtSOCGAxTNsoXV24oHp
         9poAHkmindwlwvxpNSveMWOFenXdvjLcoWaF0yR2T0yZjLWyEb7YzfdK6NSnJpQotOZI
         QNdP72YTinFWjxgb/1JuiTeQq6rravLwNDUHoOzKU4wO/yPUgsfc53efdvNdxq6XMhm3
         sgBR+Ket5jVl2zaxuVlnZsNFlbBHWSeWCbsnBRbUTDTI6zA2GasNJ4fziSWXo0yfXEx4
         udD1WNUl8sO4AdWL+bD6elOUenAou/wLF9LpndppB3hJ+0p/sMhXW1NJTwq7XIpqU/wn
         xTeQ==
X-Gm-Message-State: AOAM5302JS2hEVb+w12VNduYs0vr9lQphIJVNXmz5mEyYLtSXC3PQMMW
        JAWN9spTZvn2cun6xUKB6wQpF9MQ1AKQlU+SvB8=
X-Google-Smtp-Source: ABdhPJzcE4WINoGD6mjNGYpkrQGFof/kA6O3MpQnV7Q2avBsOUwLddvKCaQ4EG/huqw5cCxBzeT+MA==
X-Received: by 2002:a05:6e02:17ce:: with SMTP id z14mr9897645ilu.89.1632513459711;
        Fri, 24 Sep 2021 12:57:39 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z20sm4702157ill.2.2021.09.24.12.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 12:57:39 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
Date:   Fri, 24 Sep 2021 13:57:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 1:04 PM, Pavel Begunkov wrote:
> From recently open/accept are now able to manipulate fixed file table,
> but it's inconsistent that close can't. Close the gap, keep API same as
> with open/accept, i.e. via sqe->file_slot.

I really think we should do this for 5.15 to make the API a bit more
sane from the user point of view, folks definitely expect being able
to use IORING_OP_CLOSE with a fixed file that they got with IORING_OP_OPEN,
for example.

How about this small tweak, basically making it follow the same rules
as other commands that do fixed files:

1) Require IOSQE_FIXED_FILE to be set for a direct close. sqe->file_index
   will be the descriptor to close in that case. If sqe->fd is set, we
   -EINVAL the request.

2) If IOSQE_FIXED_FILE isn't set, it's a normal close. As before, if
   sqe->file_index is set and IOSQE_FIXED_FILE isn't, then we -EINVAL
   the request.

Basically this incremental on top of yours.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 82f867983bb3..dc6e3699779d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4596,12 +4596,12 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
-	if (req->flags & REQ_F_FIXED_FILE)
-		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
 	req->close.file_slot = READ_ONCE(sqe->file_index);
-	if (req->close.file_slot && req->close.fd)
+	if (!(req->flags & REQ_F_FIXED_FILE) && req->close.file_slot)
+		return -EINVAL;
+	else if (req->close.fd)
 		return -EINVAL;
 
 	return 0;
@@ -4615,7 +4615,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = NULL;
 	int ret = -EBADF;
 
-	if (req->close.file_slot) {
+	if (req->flags & REQ_F_FIXED_FILE) {
 		ret = io_close_fixed(req, issue_flags);
 		goto err;
 	}

-- 
Jens Axboe

