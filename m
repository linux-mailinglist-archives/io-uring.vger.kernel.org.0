Return-Path: <io-uring+bounces-954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD67387D04C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C29DB21D9F
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8639E3EA77;
	Fri, 15 Mar 2024 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iD+lYkd1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E11946C;
	Fri, 15 Mar 2024 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516675; cv=none; b=g7PGGuKUZhJekexpn2P0Naj/hfZXYoYEjbFwV/YReE0PzjdbNcbSCGhP5lvwx10+PBUg/uRwswYRkYXdV+Btwwco1qUjdJWWRybz8zJ1Wnpw2lkNDCTqgySGNWeizw6e8SyyQ+Mva4EqzGX/pVcfZNcOOxfuuB19qlSs5QqCeXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516675; c=relaxed/simple;
	bh=cC9SsXnrQzN+jeTDnCngPu75SO4LrcOOTxH+MZXD7fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlcjCAByahmRVELjHPWc0QIjJcLv92OlhWAquSAr2DqGdjRgVnDhW0B2iM8nm01seQNT9TC0IeaAxgBTMYDETRkJx5NQt0/BI20Sq973AoOsTeI3fc0q3q52PPPsub/YGNHmJRbVCU+c50f0HF2RtILQ178td7gJjrLFZ52W+ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iD+lYkd1; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33ec8aac149so1013829f8f.1;
        Fri, 15 Mar 2024 08:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516672; x=1711121472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8S+2Qr+5j+oXYUgnnJL29zNsQhxWk60nTT2RQa3fYOM=;
        b=iD+lYkd163gUJ/7v6TqwOzfp2AccRYIfmbBvMqwhUKI+vfV8RXRMqIeEIRtCAJHfED
         J9mAfwwFthx6B9XUaq2Vz7ezt52uUIS3B3Zxuv2/iWUOMQJ4S3/qBOtanXuYKTiqXcbX
         vGf8VAgy2rdtHXkhlZIiv25gLFrz4Tc21YGxC6EzKEyqKhbPdcSnrGWOHbUHjnTgQYHJ
         zU8dts8hv12WHHEMGmG+sYDjmY2eYQ3jjl+oigWG8E9VyMGqyJTeai12l7wiFWRqsL1Z
         RsjHwjbWbngz0rI3OHgNm693yGxYlEWp8+4Th5Fs6zNriWDezaPwUV2+hq+3kDprtCmt
         T7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516672; x=1711121472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8S+2Qr+5j+oXYUgnnJL29zNsQhxWk60nTT2RQa3fYOM=;
        b=l8WoRl7ybB/cdnbDwM1WWsnvQRVdn6hnhxzabdK+yZcAdpBuHw2NjKc8+UdtJAGd7j
         HeEEZR9jakggzgqueJ7VKC5Xf7uAf5S0Wf/x9H3Q4Md7M8ShhULXaKssH9bmNsVJtS6K
         xxkR/DngJSbzSvuLEPt193wScl3uK/cSNIaGyZasURje4Q4jak+1yrmHH7Dght8fkbJz
         3G+1Aau//I0xlbgNjSdpKbCQKhJLVT9LeZ8GVsd9jin4MYvn5pVRNakloTWoit0vPMUq
         VeL85ky7Y0gRQWWOICEaHcwOQJ3En3d3K/E4XpklMH3kOWOdXB1d3w4MTeXQSPEBOYTr
         CRbw==
X-Gm-Message-State: AOJu0Yylg4SP9YyG8qKAGQGjftqWIwcAUJUE9UUsoc5SXOcrYaZxIDV5
	nCWFGdzigGYAAdx8s47Rs/d5mFrbZn4EF1IW8+VdjBPQab+1yTbUrd6t84TZ
X-Google-Smtp-Source: AGHT+IFlDr1gsoKLBk+XeXsyhmacreCOtvMrxLLkiZMVEw9qddNM8m4PWMIAu1+gC9gJTcfUqS4e7Q==
X-Received: by 2002:adf:fe49:0:b0:33e:a0b1:e783 with SMTP id m9-20020adffe49000000b0033ea0b1e783mr3824574wrs.22.1710516671919;
        Fri, 15 Mar 2024 08:31:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 02/11] io_uring/cmd: kill one issue_flags to tw conversion
Date: Fri, 15 Mar 2024 15:29:52 +0000
Message-ID: <7f0d5ddfb5335d038bfd8db50656a1d69daed37f.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring cmd converts struct io_tw_state to issue_flags and later back
to io_tw_state, it's awfully ill-fated, not to mention that intermediate
issue_flags state is not correct.

Get rid of the last conversion, drag through tw everything that came
with IO_URING_F_UNLOCKED, and replace io_req_complete_defer() with a
direct call to io_req_complete_defer(), at least for the time being.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 42f63adfa54a..f197e8c22965 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -100,11 +100,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_req_complete_defer(req);
 	} else {
-		struct io_tw_state ts = {
-			.locked = !(issue_flags & IO_URING_F_UNLOCKED),
-		};
-		io_req_task_complete(req, &ts);
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
-- 
2.43.0


