Return-Path: <io-uring+bounces-7044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F732A5A45B
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 21:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA6AC18906A0
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 20:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C4D1D516F;
	Mon, 10 Mar 2025 20:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="X5cyNkP9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE11CAA6E
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 20:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637126; cv=none; b=UH37yvOSp5Fs+ULm5hZ/hpt8szr1nZW6l1uYpes7IPeERjcyTZsSc4ATYQU9RIPZahINiJ7vQKr+/m828BL2Cg7HRucoxPawktNdJHIW4DdLGiUKhk9HbRuiz4yh+h5ubo8KuhVhJ06yZXKqKdTmIDZoj9ve9uJbbOXDvzph0gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637126; c=relaxed/simple;
	bh=v1HBclBEBISrWL2Z3pM/F0n+3v3jsiTA0XLUfOTB4YY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Vai5KJeyifAG3UUU2kFBGCgyhDJOyatyUy8LWSYokUJZle/0FOKtTvrs9TiC102pvydocdXBtpbVqIy4Vd42xN1sGAu8xcrOuDBncT85VnK8zg2GVGt53FTt+LUtyf4yE6pI0AWjPAqBsSUv9M3KiIuOi1TZ0nmKQMIeWJsTdIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=X5cyNkP9; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d43bb5727fso12535495ab.1
        for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 13:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741637123; x=1742241923; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5jXE+EfgC2NQwlhQ5BhRsFPXk03BSSkw0E6bWQipqs=;
        b=X5cyNkP99BnU406iF81jP+kjCe/VNMAX81Lm6xEn1Qw0QEwulNqIQjYmf0Tr5s+RPv
         J/5fUiZyBALsQ7O9DPKMy0/mgHkIG3RGcy/RKOsETZFaZl3rN3AFsNzn2T2vXZhTmdjh
         Ebk4tpgtRN46i83OMxC687FQGGXU/YIYKG/X1SrLyI7wXn1IiiaREEY+cZzPVztL+zYd
         dt/G1JPIQ3KMzrl/rhVFjUxM2BL9FyTK9gihHFVn5kUpIqwFR9uIETfmQTaM+jYN7c3C
         VyDFFZE8Nusv8az9+iHlaWP6G0pLnqZ5U+/qNLNaSZ7xui55nDmS6LuEF+pNiX4MjTkB
         GkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741637123; x=1742241923;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5jXE+EfgC2NQwlhQ5BhRsFPXk03BSSkw0E6bWQipqs=;
        b=xE1Pgia5xuXyxHg1GFsY5U/1EKWioTaOSsHA/ngw2DBDEtiJZW+q9r8unZUvAXTLjg
         Z2gOMY8hKFPl5yA6xUuNw5H0xOE75+QqlbsYM8b249L2H4vs6yWVfOpT/LfY7B2VZliE
         FSqmpoN3tSYTuhYPI3eRyNZuLSczR97wIpLCAFpCnW6EyyBxCGddzd96Dhd5z7cm4/MR
         8J5lxcS5k/FUUg0MiPebOdH1hcXIQi6cV4+EKXhWIQCeTdgbWH6Mf3R3wTx6ylBGIi6Y
         RNwFMcfqFKac/mXYavWa4oLdRJ7BQlqSjrlJPMTVnfEBlQuVXMTV6u5fUPzSFsHZUVzG
         nsyQ==
X-Gm-Message-State: AOJu0YzEBXvX0JtgL5c3gAzP8Kocl5kN2pBaVqEIEXJmt91WEktwtgP/
	C36M7K+zwjCSMyj++/9YV97WTT4JQqitQowLv2E6xVdzTnycnQqz4QNaVIWHm+MbAmUWtS0pfVX
	q
X-Gm-Gg: ASbGnctzZWrhgLtDY8niuWsboHM5k8K33X2SdtZiCOV1Vk0J4eKx2m6Pfi16Tyha516
	YOfm73a8eMXjKtlCPYqCIOyQJM3gPBRQplSdBjDxy5HxnBmnU5bwKM9FhNpYWCcGU3XFHLfARIa
	E6A9CPV+EAGuhro0qkdGP+nOgSKw7xAjNJtMisRYVTAOyRjKVab7naqRB3ixpk+acHDQ9/b4lBd
	q3HzIT7Gxcs8UM3chAEi+6E8ez0QBCuzZaFZHhw8AZN99kqF6uce0uBdb732Cj0wO8mKOBnfIde
	9ATuj9vRlh/ukf4GkdnjCGFHsrQeWblitW6e3VJCBT9IM+wmsT8=
X-Google-Smtp-Source: AGHT+IEUryGoxB1K+wwtE+zdaqDWQ6alw8JJ75FNq7SdwrVepRckt7fEHSH2KnsWjBP5R7D8CkymKQ==
X-Received: by 2002:a05:6e02:17cc:b0:3d4:3ac3:4ca2 with SMTP id e9e14a558f8ab-3d44196ea56mr158548185ab.16.1741637122876;
        Mon, 10 Mar 2025 13:05:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f22f1eabffsm1097193173.127.2025.03.10.13.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 13:05:22 -0700 (PDT)
Message-ID: <04a240e1-a3ca-4140-8600-6271b8bbefa8@kernel.dk>
Date: Mon, 10 Mar 2025 14:05:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Norman Maurer <norman_maurer@apple.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: enable bundles for incrementally consumed
 buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The original support for incrementally consumed buffers didn't allow it
to be used with bundles, with the assumption being that incremental
buffers are generally larger, and hence there's less of a nedd to
support it.

But that assumption may not be correct - it's perfectly viable to use
smaller buffers with incremental consumption, and there may be valid
reasons for an application or framework to do so.

As there's really no need to explicitly disable bundles with
incrementally consumed buffers, allow it. This actually makes the peek
side cheaper and simpler, with the completion side basically the same,
just needing to iterate for the consumed length.

Reported-by: Norman Maurer <norman_maurer@apple.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3478be6d02ab..098109259671 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -32,6 +32,25 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
+static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
+{
+	while (len) {
+		struct io_uring_buf *buf;
+		u32 this_len;
+
+		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
+		this_len = min_t(int, len, buf->len);
+		buf->len -= this_len;
+		if (buf->len) {
+			buf->addr += this_len;
+			return false;
+		}
+		bl->head++;
+		len -= this_len;
+	}
+	return true;
+}
+
 bool io_kbuf_commit(struct io_kiocb *req,
 		    struct io_buffer_list *bl, int len, int nr)
 {
@@ -42,20 +61,8 @@ bool io_kbuf_commit(struct io_kiocb *req,
 
 	if (unlikely(len < 0))
 		return true;
-
-	if (bl->flags & IOBL_INC) {
-		struct io_uring_buf *buf;
-
-		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		if (WARN_ON_ONCE(len > buf->len))
-			len = buf->len;
-		buf->len -= len;
-		if (buf->len) {
-			buf->addr += len;
-			return false;
-		}
-	}
-
+	if (bl->flags & IOBL_INC)
+		return io_kbuf_inc_commit(bl, len);
 	bl->head += nr;
 	return true;
 }
@@ -226,25 +233,14 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	buf = io_ring_head_to_buf(br, head, bl->mask);
 	if (arg->max_len) {
 		u32 len = READ_ONCE(buf->len);
+		size_t needed;
 
 		if (unlikely(!len))
 			return -ENOBUFS;
-		/*
-		 * Limit incremental buffers to 1 segment. No point trying
-		 * to peek ahead and map more than we need, when the buffers
-		 * themselves should be large when setup with
-		 * IOU_PBUF_RING_INC.
-		 */
-		if (bl->flags & IOBL_INC) {
-			nr_avail = 1;
-		} else {
-			size_t needed;
-
-			needed = (arg->max_len + len - 1) / len;
-			needed = min_not_zero(needed, (size_t) PEEK_MAX_IMPORT);
-			if (nr_avail > needed)
-				nr_avail = needed;
-		}
+		needed = (arg->max_len + len - 1) / len;
+		needed = min_not_zero(needed, (size_t) PEEK_MAX_IMPORT);
+		if (nr_avail > needed)
+			nr_avail = needed;
 	}
 
 	/*

-- 
Jens Axboe


