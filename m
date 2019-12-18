Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2F9125252
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 20:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLRTwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 14:52:16 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41892 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbfLRTwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 14:52:16 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so3256588ioo.8
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 11:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hfF++5wHAjz7dBEMrCK31vXL3StNz1uJoOjsEETbLhQ=;
        b=GlUAKbEgdvy0NS5CeGyaQm5gs6kv0ZKSG5dpjM3fRIq//O3cFmowKqD86NajXglUf7
         p0QruwUOdP1mJqMN2nsxCX6UYppdw34dlrIaj4xdUBjtvLWcKqrI7w3TaS3jSKo0N7cG
         lXwvbrXXr0CDNkRf1kSdHeT72esvZoLhfYSWYQ8Xp2ZgLGzmjzjYrg+mSf8lo2qz19Oy
         B3271bQtJs7XKtOCIxkSkeLKFslppWeJDqZ2Qc9zaBXtHVoXi2oBNAHZY7r2aOAtkZWk
         hA3YgDZuR7DGZqM83MEXX0L0OJYdRXkt7De3E3DpkA6RzFSHc5JpnH/N98Olj475me0C
         jZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hfF++5wHAjz7dBEMrCK31vXL3StNz1uJoOjsEETbLhQ=;
        b=q4cZk481p8StDPkSj68bafMVgQZWtKOshUTUaaNh4XNm/bon3j/Rr2xKkFOHlQB0fP
         2Pv/xb5qK/Z8cMzTyGffmJcaPrJPbidlsuWmx9PlaqZcIcYn9jkW03quKnjrK5sbLlN7
         Kv67ft/WPZE2PQuZCxS9O54vdaVaRsSLMcejUCp+u9ReDzEe1vt+po00UwUGTMxVzg0t
         Ws45uECwT+NTaPveWusZihxy/GOkr0SOG0eVLRw/xDjUlwlzbeTf3lnx3hy7LVynGffO
         PekCCefFIVBhAOienG1lQlfSi632A4sgU88EEuNAU26caMHdihKO/KlgpXqOwVnlP4Oz
         zpOA==
X-Gm-Message-State: APjAAAVrPVX3rWtN7AxiA3ZGk/QoHW5SnAkxB8sw3KMhutazTq6ofJ09
        F6PakC1S7b2lzSnA/k7noHAXu/mLyC6LFw==
X-Google-Smtp-Source: APXvYqwW+qTDd8ZyDqRddi9ueqNPuMbrkxjH+QLaBs6ke3DfiNFyCHTBOKxBGrwNkReRrigoMSzpxQ==
X-Received: by 2002:a6b:d912:: with SMTP id r18mr2927342ioc.306.1576698735433;
        Wed, 18 Dec 2019 11:52:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j69sm965465ilg.67.2019.12.18.11.52.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 11:52:14 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: io_wq_submit_work() should not touch req->rw
Message-ID: <e56cffbd-595e-b484-4307-697068c2fd91@kernel.dk>
Date:   Wed, 18 Dec 2019 12:52:13 -0700
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

I've been chasing a weird and obscure crash that was userspace stack
corruption, and finally narrowed it down to a bit flip that made a
stack address invalid. io_wq_submit_work() unconditionally flips
the req->rw.ki_flags IOCB_NOWAIT bit, but since it's a generic work
handler, this isn't valid. Normal read/write operations own that
part of the request, on other types it could be something else.

Move the IOCB_NOWAIT clear to the read/write handlers where it belongs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This one was fun to find, random flip of a bit in an unrelated
struct...

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7800def3090..b632bd9222d9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1817,6 +1817,10 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 			return ret;
 	}
 
+	/* Ensure we clear previously set non-block flag */
+	if (!force_nonblock)
+		req->rw.ki_flags &= ~IOCB_NOWAIT;
+
 	file = req->file;
 	io_size = ret;
 	if (req->flags & REQ_F_LINK)
@@ -1906,6 +1910,10 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 			return ret;
 	}
 
+	/* Ensure we clear previously set non-block flag */
+	if (!force_nonblock)
+		req->rw.ki_flags &= ~IOCB_NOWAIT;
+
 	file = kiocb->ki_filp;
 	io_size = ret;
 	if (req->flags & REQ_F_LINK)
@@ -3272,9 +3280,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	struct io_kiocb *nxt = NULL;
 	int ret = 0;
 
-	/* Ensure we clear previously set non-block flag */
-	req->rw.ki_flags &= ~IOCB_NOWAIT;
-
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
-- 
Jens Axboe

