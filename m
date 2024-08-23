Return-Path: <io-uring+bounces-2920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2739A95D070
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE8D8B261F1
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 14:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80F71885BA;
	Fri, 23 Aug 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ldSnaXXy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F641885B8
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424702; cv=none; b=SKix73CN3kwdGf5rUz+Ar5MJtBHzr375NgAKLZn7vikJmNZ4M/R9Lzwp0s5FKm7zNfPrsyyvF0wPiVgq/2HmPe5FeMevxZ5pL0yg255nQ3swlWv17h502fUROvbGTjqEPHwNY/OU4PzL31kul1hXniWWpJM+amFWTjaaah8MK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424702; c=relaxed/simple;
	bh=KXPj+kZBXG1dO6CLdYIpHcHjS2SRQAmcFJ/DgdurXyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rROCmLvQh/uk5TdNCffCdnZ4YDY+LHW2HRziy1Au6fzoBZO1wHav/w7Wa9gQoohBZEvyxV4ArWC4dXLSiA/XiwVdwrB8M+GqBZTgExiT/jUJi12zqmrdXMBGwgIUdLRVcYKWdU5wm6lmUPBxKEUp84NuhxDMNIWq1Wz19RuA3cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ldSnaXXy; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-824ee14f7bfso77393539f.1
        for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 07:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724424699; x=1725029499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wvXDh5L3eiqv8tqKDHyLL5odKM2oXMTdWSnm0GrmR2c=;
        b=ldSnaXXyEcpglPcOZFVcuiXKeIXNzNjy7TccHXstAn0IwcD6kbt24iWnQvmggDEQaf
         kqyN+1McT3Afs4HPDRAsoUBJL9MLx+1G+hQD/v4s7ePDzi2VSICuOh56Uee+EFdaY1rw
         eMwen+v782nCO7Hgpk1S+VdVJ8cFG7tOvOClJ81x/a2jp0GkBsLst3NnoC3ksCqqKBfe
         /8UcNoykRNkM17D4Nw/CwVdaU4cnGylvzhok9zbEGPgucN6tX6g5F3w4EDEs8iGRtN5U
         uOvbWWalF5B/WQfCqzDPXx5T8zZ8FUuiTOGvkBkYb/xylyQIT376gVBOy7LXOXEqoik0
         NlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724424699; x=1725029499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wvXDh5L3eiqv8tqKDHyLL5odKM2oXMTdWSnm0GrmR2c=;
        b=JGhUyvo6Wx29zvPammMiNyN4zMKHR6VbfdJsOSJpHb9xN4UDCvoP62dcuzdr57K5Dl
         3vdudgZqnHuHS+BxgXdPgGzsm4Fb7AEM318mTF+Oa14Se10ps/GXoe7y02vNzo9QO1SW
         /QT6Sv7P5b1BGjUlKqy5kigGfLZyNZTrtPW0G8SUsmVAtconEnnsuacyv1d9XRUUVGsH
         cnsmmcs3mk+IMKxNgb2MeBJbOYn8G4Qr1NfkrVLRaEpj4ys4bg4LlMozv9uV9pGwr03S
         2CaPjSm8FjkHZewx2zNQEFC4Q+n1NN5oP3QlBfdkm7jddN6QCJZSjLwUvoJAkb9WMGvH
         xaeg==
X-Gm-Message-State: AOJu0YxvQN7NdUlLCiZLNjf7X+77urfQB+9NCRP0Yt5H2PTKUdr26/Dk
	WW8ZrZIVEFbb1yM+lmkXieuMUJyQXc2dSk+OHydlMy6o5pSL33f2WH02gyEoqZ5Zd7toijyfR83
	R
X-Google-Smtp-Source: AGHT+IH5DbaBUJLkwfCU7bmSTxvuX6C9wwbSiD+8p/X10lMJ01NE2A/ZeHctKe5abtXQJDII2Txqig==
X-Received: by 2002:a05:6602:3f82:b0:81f:9f79:2b37 with SMTP id ca18e2360f4ac-827873779a8mr281077939f.16.1724424699268;
        Fri, 23 Aug 2024 07:51:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8253d5aa137sm115039939f.11.2024.08.23.07.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 07:51:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/kbuf: move io_ring_head_to_buf() to kbuf.h
Date: Fri, 23 Aug 2024 08:42:35 -0600
Message-ID: <20240823145104.20600-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823145104.20600-2-axboe@kernel.dk>
References: <20240823145104.20600-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using this helper in kbuf.h as well, move it there and
turn it into a macro.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 6 ------
 io_uring/kbuf.h | 3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e43f761fa073..0aa12703bac7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -132,12 +132,6 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 0;
 }
 
-static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,
-						__u16 head, __u16 mask)
-{
-	return &br->bufs[head & mask];
-}
-
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  struct io_buffer_list *bl,
 					  unsigned int issue_flags)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c9798663cd9f..b7da3ce880bf 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,6 +121,9 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
+/* Mapped buffer ring, return io_uring_buf from head */
+#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+
 static inline void io_kbuf_commit(struct io_kiocb *req,
 				  struct io_buffer_list *bl, int nr)
 {
-- 
2.43.0


