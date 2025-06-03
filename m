Return-Path: <io-uring+bounces-8198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AE3ACCF0E
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 23:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE4073A4404
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 21:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C40225419;
	Tue,  3 Jun 2025 21:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0gcA2Mts"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E22221FBE
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748986417; cv=none; b=cgWJlTDs6loh1FOR8MT2o/DF+MpL3BS39dt2xDM9IwEqoChpp121dhqeTjX0PCHfmC0vsLvDKwxFcGisnwWmCLX06rKiUjX6ihqi0GaZJV/N0Oe/mE/kZKLmFNFSADO3rtfVgdsPuIZmfYbB3HbvqLwGubuZf7Csuk0JoRi4tJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748986417; c=relaxed/simple;
	bh=E3LImC9ZRPHumtO8/6aYxw1xJL6L5ekGh5AGH8vMRFg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=s4/pxfFm/c5rT9xiDbsCYOiz9RA6s9ABSbOfFP7lFIBnDTwUXajAZ96xTNCo5yajjXQyYP5K9Ocz9lmdSrGPq7jv9QIpS79n2kXzsG1qrC+Y2Yshkc+5qloXjlUl5MekW62BUG7uadFrIcAAfF+GaxM4KfOkTCn6FCjSOOiP89Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0gcA2Mts; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8647e143f28so479351539f.1
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 14:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748986413; x=1749591213; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFOyrP65C3TJ7VY07W4POWgT7PyM1x5S8R2W0sDm0TE=;
        b=0gcA2Mts0rhMaaWp0wT9Sh9WNSFSehwnRWguQ+WCEcoeOkILESp0vODy9NVO3lJlPK
         d8QbUa7yPDBsS7/GLjF3Q8VlVLRaKN1pTG5ZkSC5YU7lzGvPe7OR1w4yXEuJaqaiY5rM
         e79Z1PqJzb53EcvvWNL8HSSa4w9fw0pX/NIVqlKrqF/e2Vzb4UPI3X6layemxTUPKJeA
         CuHnJO4Zl2VBaO5gh32xn3R7FKqjTkErwYkpr4Khpb8vJdRAwhC8/arq5EORVdt3VMPH
         jOVoS2kUAlY8e61IwYz31EB71nF0WSEuM1EiOoJzsUnVHrNz9E5OLJIm16jfPP+d6Osv
         phWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748986413; x=1749591213;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bFOyrP65C3TJ7VY07W4POWgT7PyM1x5S8R2W0sDm0TE=;
        b=Tu8uAwh8apFmzTY9jpeli37RsOFwinQoXGccGLqRNh+vNGPSWNqGXmvBElYPKhE4hR
         gsQKnUkhTHrUVIAHWsjkDRFQHIEq2AdbJmkSkvXPOCKEE0OxCY9IeaNrDJIzX6UYvItv
         DaeiAvuBDkMsmE4Crdzmh7o2/eYuCkWD2aZ+es2KRglPWyb+KWL8jHAx33f+/k29+OmG
         RbPQfgE+xtUfKlmsb4veP2l+jZlM52lkXCi/30uTO7iZ8084hdgg27YE2384OaFp7cP7
         H+Obcs9Gmy+HuaJRq7OvCctNyckjU3pwTcl3XILwbFOt54B+zA/S5FjUHgQCwqCZsMD7
         1Tdg==
X-Gm-Message-State: AOJu0Yybq6670Wru87T80tJVZ0hwsNSmrAL3KNlPgiYAdlpqiGWFQEG8
	hxC1tl+uZYG2L5nD+sypC0c4JgflCHtHXbvVERo3R1GWbfznIT4oGU8hw2+uW2FrjetJTyR+RaL
	ZmYBr
X-Gm-Gg: ASbGncsTZTTjCg/zo3xSESh66ye0XoHsnz3W/rliDb6keucbu5pydgM6+d8sBfvJ8QR
	hPzH4gRhE8wXR+XvYaUsX1goi9d0MJ0u8T+T1X6Iu2Jyyzvg1UPCIglubtVCCcPRRG8uIg3EkOS
	ei8v1nBdTe2SAu5nrQHlOQ7QNKuIOb7bgGv8jDaglWc5Jm5igNZIEkEjJfY1oLIRPgNpzWGS4H1
	UWC6z3kb5KQLGLLF40m1WHpbJyEeRik44l1wABVhUvh6H4GHX+UNQklYZ/PSxhshxa3SNE93GV3
	mJd/0s2FUd1D44Lr7nEGmsFRImbdr1TP68UjNHE2Q/EYA+5EwaOFcMVJgAU=
X-Google-Smtp-Source: AGHT+IFIr6Ib/JcbXYMN596RYOrlPG1b61IP94Q9XOeYX3DBHoftQiC9aZPci3zd47ROQiSv5Nbx+w==
X-Received: by 2002:a05:6602:400b:b0:864:4890:51e4 with SMTP id ca18e2360f4ac-8731c60aa6bmr75320239f.14.1748986413322;
        Tue, 03 Jun 2025 14:33:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7dff196sm2447836173.4.2025.06.03.14.33.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 14:33:32 -0700 (PDT)
Message-ID: <6033108d-ad91-42d1-89f7-6fc5a4c89302@kernel.dk>
Date: Tue, 3 Jun 2025 15:33:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: PATCH v2] io_uring/kbuf: limit legacy provided buffer lists to
 USHRT_MAX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The buffer ID for a provided buffer is an unsigned short, and hence
there can only be 64k added to any given buffer list before having
duplicate BIDs. Cap the legacy provided buffers at 64k in the list.
This is mostly to prevent silly stall reports from syzbot, which
likes to dump tons of buffers into a list and then have kernels with
lockdep and kasan churning through them and hitting long wait times
for buffer pruning at ring exit time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Since v1:
- Actually use the added 'ret' variable io_add_buffers()

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8cce3ebd813f..2ea65f3cef72 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -108,6 +108,7 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
 	list_add(&buf->list, &bl->buf_list);
+	bl->nbufs++;
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -122,6 +123,7 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 
 		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&kbuf->list);
+		bl->nbufs--;
 		if (*len == 0 || *len > kbuf->len)
 			*len = kbuf->len;
 		if (list_empty(&bl->buf_list))
@@ -390,6 +392,7 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 	for (i = 0; i < nbufs && !list_empty(&bl->buf_list); i++) {
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&nxt->list);
+		bl->nbufs--;
 		kfree(nxt);
 		cond_resched();
 	}
@@ -491,14 +494,24 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 {
 	struct io_buffer *buf;
 	u64 addr = pbuf->addr;
-	int i, bid = pbuf->bid;
+	int ret = -ENOMEM, i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
+		/*
+		 * Nonsensical to have more than sizeof(bid) buffers in a
+		 * buffer list, as the application then has no way of knowing
+		 * which duplicate bid refers to what buffer.
+		 */
+		if (bl->nbufs == USHRT_MAX) {
+			ret = -EOVERFLOW;
+			break;
+		}
 		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 		if (!buf)
 			break;
 
 		list_add_tail(&buf->list, &bl->buf_list);
+		bl->nbufs++;
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
@@ -508,7 +521,7 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 		cond_resched();
 	}
 
-	return i ? 0 : -ENOMEM;
+	return i ? 0 : ret;
 }
 
 static int __io_manage_buffers_legacy(struct io_kiocb *req,
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 4d2c209d1a41..5d83c7adc739 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -21,6 +21,9 @@ struct io_buffer_list {
 		struct list_head buf_list;
 		struct io_uring_buf_ring *buf_ring;
 	};
+	/* count of classic/legacy buffers in buffer list */
+	int nbufs;
+
 	__u16 bgid;
 
 	/* below is for ring provided buffers */

-- 
Jens Axboe


