Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBFF16B6D1
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 01:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBYAkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 19:40:00 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45826 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYAj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 19:39:59 -0500
Received: by mail-wr1-f66.google.com with SMTP id g3so12584349wrs.12
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 16:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=M6b+yUjkrxpk2X0AVYMdHP/LxGDwuHV9SwPNp0wPrL8=;
        b=JD72/O4Uc7zX8/XF6iad8fSjs91PrAy3Bu0AynBEIKNAqd7VMmBVYbTIbpg7qM8WXG
         BMO7ODG9tqz0UhLlcS+HbN0pr2r/XqdsDrMQm/7f50bAm17PCm+3go/9Y78+GP5q3J+G
         YWDW3iFhThru6zOoQY3yoJNM/+zmSZV533r5h2dDcPgzPB+IH/9yklSbUmnWa4dJ6+BT
         IIWQ0wtQjdsLaDbaEU7XyD6+V6ypR25efzRjf3N/AFlVK5DzgJ9dOJ88idoc4hZmTZhZ
         H2YABaz/Fjf8a1nX9f+8LVqIo+bd3ALpG5VszfnikMT8bqoZTIRgAWUM0UJ7PzdrhFST
         pg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=M6b+yUjkrxpk2X0AVYMdHP/LxGDwuHV9SwPNp0wPrL8=;
        b=Rq5z421FhIM1d2WxruXgNNiDh3D2Tn6Hv0fwH1z0pDzll2Bf7ROLxzvltFMkMZZUkA
         iE+lY/bcPNe08lz3ER4HrW2/KYhrk76F2jM16k5u7KToyftY6aQZfSChXu69YhMOMoSQ
         4IqdKmQGmlZfmvxwhTG0fiXZVuFZH9YMt6s6JfTBgl25PBmJFw935dxiuWb8hOVm4pbL
         Gvh+MRB3MXWVsSY9E6G9T7c2ocSfcPIkguD8d8PnvCYoR3b+B4HLQW7rcqcqJKe1Vf12
         VOKyerQRIVOmZWiKMFqX0D5YE1X7tJmGUOnCEdnGqgiYIRCHP6HC+t9ifLSrl5aRIhxs
         73jA==
X-Gm-Message-State: APjAAAUskYDrhR3hBXMWkGWuv9euUzHV9NeaKWWghnvGBrc0+O5Of7r7
        BmPzw6SKGAMiekPu/JJudge8YL4V
X-Google-Smtp-Source: APXvYqyuVXyJhaP4fMV6veIi0xM5zTdgYyz/fN0RLp3lTbNPVxLLSNduNtX7tZQPvObGzHK8DAlnVg==
X-Received: by 2002:a5d:5188:: with SMTP id k8mr69402462wrv.151.1582591197089;
        Mon, 24 Feb 2020 16:39:57 -0800 (PST)
Received: from [192.168.43.206] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id c26sm1264447wmb.8.2020.02.24.16.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 16:39:56 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [RFC] single cqe per link
Message-ID: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
Date:   Tue, 25 Feb 2020 03:39:11 +0300
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

I've got curious about performance of the idea of having only 1 CQE per link
(for the failed or last one). Tested it with a quick dirty patch doing
submit-and-reap of a nops-link (patched for inline execution).

1) link size: 100
old: 206 ns per nop
new: 144 ns per nop

2) link size: 10
old: 234 ns per nop
new: 181 ns per nop

3) link size: 10, FORCE_ASYNC
old: 667 ns per nop
new: 569 ns per nop


The patch below breaks sequences, linked_timeout and who knows what else.
The first one requires synchronisation/atomic, so it's a bit in the way. I've
been wondering, whether IOSQE_IO_DRAIN is popular and how much it's used. We can
try to find tradeoff or even disable it with this feature.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65a61b8b37c4..9ec29f01cfda 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1164,7 +1164,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx
*ctx, bool force)
 	return cqe != NULL;
 }

-static void io_cqring_fill_event(struct io_kiocb *req, long res)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
@@ -1196,13 +1196,31 @@ static void io_cqring_fill_event(struct io_kiocb *req,
long res)
 	}
 }

+static inline bool io_ignore_cqe(struct io_kiocb *req)
+{
+	if (!(req->ctx->flags & IORING_SETUP_BOXED_CQE))
+		return false;
+
+	return (req->flags & (REQ_F_LINK|REQ_F_FAIL_LINK)) == REQ_F_LINK;
+}
+
+static void io_cqring_fill_event(struct io_kiocb *req, long res)
+{
+	if (io_ignore_cqe(req))
+		return;
+	__io_cqring_fill_event(req, res);
+}
+
 static void io_cqring_add_event(struct io_kiocb *req, long res)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;

+	if (io_ignore_cqe(req))
+		return;
+
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	io_cqring_fill_event(req, res);
+	__io_cqring_fill_event(req, res);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);

@@ -7084,7 +7102,8 @@ static long io_uring_setup(u32 entries, struct
io_uring_params __user *params)

 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_BOXED_CQE))
 		return -EINVAL;

 	ret = io_uring_create(entries, &p);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 08891cc1c1e7..3d69369e252c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -86,6 +86,7 @@ enum {
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
+#define IORING_SETUP_BOXED_CQE	(1U << 6)	/* single sqe per link */

 enum {
 	IORING_OP_NOP,


-- 
Pavel Begunkov
