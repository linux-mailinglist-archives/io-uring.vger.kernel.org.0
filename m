Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6D943B50A
	for <lists+io-uring@lfdr.de>; Tue, 26 Oct 2021 17:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhJZPG5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Oct 2021 11:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhJZPG4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Oct 2021 11:06:56 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7795C061745
        for <io-uring@vger.kernel.org>; Tue, 26 Oct 2021 08:04:32 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id h2so17574826ili.11
        for <io-uring@vger.kernel.org>; Tue, 26 Oct 2021 08:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5ZIwPfxEgMcjibHWZLrfkewRJtmF5q4NR5dOpAueEHc=;
        b=Ruz4vhLCGLhNKBxZKV53vawt+6aEInNWHKEiHsG77oAej0B0a05syiQGsHB6K0L8Pe
         qGbGR3I6+qnIipXo9yrig5Nk76u6BbqVSzS3R3koglRL7GudzG9Nee+eEJiotGXvfC9p
         R4RHtO9cikrUL/8dUsAvNa5D/IbL7/L1FDUGOU3CYebuGrnttWfMCRCZWD5xaxd1IRDU
         B3blnnuTy34JLrXb9JqCa717ew/czLxLkJAk5eOmYhL6LrsO/Ms8fzQuIQvskE38F6GY
         yJ7dKaYmSaN4AwW5HXtaQKVGEH0qCcONsjog2B1Nfg9QFxlHNcfGLT+n2jo8kV6LCqJ/
         WQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5ZIwPfxEgMcjibHWZLrfkewRJtmF5q4NR5dOpAueEHc=;
        b=5amYKqedl5twrSmMKNsc26QTIt7MtucfqsB4okK+nWrfbVUZtK4oGu5wJuSQMagNGZ
         4AWfl64jaj5UZkbOIp02nG1jCyuig8aBsPa4eh590pZ33rebtSkFABj7otGOx3mCH4MO
         zD5V8JydyR713sWvIjhraPkLFu2FHRQl3PwsYt3aeKePdnRg+XmonXK914zBL0zIqznH
         KX5Onaw2VpbtFDoAR+hU4cajftz+5bA4KoQLinwLv5CRcvnOqG3toN5y8XI+7QtM5e8X
         +uBn6GGFQ4w5EZ2dVNwqAN+X5VvoV6CutMA431Xr+Glg+tIj07xClZVHzE1nFzd8+God
         6WHw==
X-Gm-Message-State: AOAM533HlLzxNdnFLMTCZbdRXIKBwQXJp2Ttj1r1PuyML+nUTKtl9tsT
        vBo6P22sRNp6tyiHGRP/0P54442c94eetQ==
X-Google-Smtp-Source: ABdhPJwoXKr2GxT2JQQzwDdu2K4rRUrntAzSYJ6RRUw2UjJGyGKCzbbbkpy8g6+QPLKoD2dEf9VaPA==
X-Received: by 2002:a05:6e02:1a86:: with SMTP id k6mr15204482ilv.192.1635260672030;
        Tue, 26 Oct 2021 08:04:32 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z26sm10086644ioe.9.2021.10.26.08.04.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 08:04:31 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't assign write hint in the read path
Message-ID: <b65d4d82-22e0-7735-8499-4ce33afc88cb@kernel.dk>
Date:   Tue, 26 Oct 2021 09:04:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move this out of the generic read/write prep path, and place it in the
write specific kiocb setup instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6faffcde7a2b..3d8a54f5afa0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2825,7 +2825,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->flags |= REQ_F_CUR_POS;
 		kiocb->ki_pos = file->f_pos;
 	}
-	kiocb->ki_hint = ki_hint_validate(file_write_hint(file));
 	kiocb->ki_flags = iocb_flags(file);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
 	if (unlikely(ret))
@@ -3568,6 +3567,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
+	req->rw.kiocb.ki_hint = ki_hint_validate(file_write_hint(req->file));
 	return io_prep_rw(req, sqe);
 }
 
-- 
Jens Axboe

