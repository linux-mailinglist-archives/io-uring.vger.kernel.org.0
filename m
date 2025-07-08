Return-Path: <io-uring+bounces-8614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE23AFCDE0
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 16:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F26093BB840
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 14:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A222DFA24;
	Tue,  8 Jul 2025 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tJ86WTpi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDABB2D8DA8
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985554; cv=none; b=ZO9D+b3eRAa4BW+nPhPw2kR9nZXMAIkl1IlBQwk6yNtMSa3aAR+Qygof6PLmiQRDTeWLtstCJeEhIjKwofJN0d7PvYRTAx2QjpPTGEQyIcmhBgF9Mr06qdR6iPNy3CoNd5/0Xv8xJcNXmgz7X2ShCZb1MUXcx9ZPBxhrhMcJTwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985554; c=relaxed/simple;
	bh=hK0x8tCd38wd1AcTPvD6hJnSew5C4/9y2Me6qtX6cPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2WxkorFmlHdIAfYomzqJsARr8lbfQVmfkR751uwcHr92BZH+a2JAU6Om2RlzlGdgl2HnUdlWF4imp0mhBrlpb3z6uNHQAi/URTY1h5Rdk6nias2oR64yMVUUnGl6x3F6sEuPwotmqT/Ii3yrVIsxLGTResQbZHO8a2ZXsSnmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tJ86WTpi; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-8723a232750so443624539f.1
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 07:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751985550; x=1752590350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGM1E3DYMEASkYf+b3zNDldK0JLh3lOR67oalgyg/HI=;
        b=tJ86WTpiOXxjsszhIBlGO35+5QK6XLtW9eFDeDU1GEVUTzJIycSoarzHnPC067ID/p
         wNRXH5GWYNt8z7atLpX/oU8LLEnkJXrYBg1kES64AEqHmYwtbLx2Ta/9My/yrGXCmg1i
         HqPDn/7pRwmaVckvZRrHgdVq6OPczdAHQZL+mZ5SOy7FMay719hx8B8CHtuGmo9MkSd4
         hGoKj4NSaLbEws8uPhV5Uoucc51Ifofs3qmJHEwI0zs3HEB3zRq3yB1XUzR8ZJ8Ph/vF
         U/eHaHHlGejfZuR4pAlnjKx0s6bK5sNgQtfedCs11Ha9x9rZlNQcEaY6xiIGfvGqPTZp
         qZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985550; x=1752590350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGM1E3DYMEASkYf+b3zNDldK0JLh3lOR67oalgyg/HI=;
        b=MBdDDhFIc70CKOZKcQNrGrpp1THW3ADmphqo3HIjzPgIsmjHJYZpAkn3jgbrkYI9Sm
         W6qu1R4NzAfHulht2txnmSF2MOy1YTkvmsLc512bM6TJALT8cIAwkgpd7umlt+kyqAqV
         brZjtOaEYV4BHzjAWJHnu0/2l2rhfD33dwEsNyFaxOZCEqkZNVnkscZMv8XDA8hW9DNf
         7q8kILk2t/ULha+bZiUl1fB3v5buh9USYKYH8tGt4GzIzXcLp+UGc9dIbQq2fS/C4bts
         rOr6HLE+9rxOfN8Hcb7WKYKhyoqN6NI7uSKUb0LGCa/97hJMizxWByjfYGTn7u/3zdZI
         t0GQ==
X-Gm-Message-State: AOJu0YyMKXJUyLChDv05zS8tvy2tj0dBTkwxFwuYKjfPIOyvCNE+56gG
	4m+YW2kSjQUb5qD3z5MHNynbIiLPqJgpiBlgJRhcidUr4bTwkk8iwJjCWYBpccadLfL3MNwoubW
	t3zdC
X-Gm-Gg: ASbGnctKrKLQk24pH9iUcDyfUwq2T7KUbNN45kLgC9nSFsAfZlp5ko0pGx9lvJERp+6
	xhsmJ7Gisb+2PXBq48GsaN85p9iUPDWyknXl3An+eZagK+rHtdcgRy3t3dVPuXDjfR15kthF4p/
	WHsrkG6HdWANBkG+pRruEh4e2WcQJPjs00kFU9fSmYxBPUx6iZtuNmVRTNr1bdXXmmT0ZLBsJuf
	n0TibYeBUi4TAgn1Kzt7tnnjUTq8gYcpYoJh4x3K15tjkfl3mRTCblMsO/EVDXrlPPlphmaKsDM
	zw+mrMCB6t9zJJm31DuoJpWWnUKiYCcc+niOPr7du0UJ9w==
X-Google-Smtp-Source: AGHT+IH8RuHrEu01D6vtSFKy+cX6JkvKk1xzQbJ5MZ4RW97nNscHq1+OCHiXWF8/UyrAW34tfgDEkQ==
X-Received: by 2002:a05:6602:b97:b0:873:1cc3:29d6 with SMTP id ca18e2360f4ac-876e15dfbd5mr1705273339f.8.1751985550141;
        Tue, 08 Jul 2025 07:39:10 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5053aa4e546sm166739173.134.2025.07.08.07.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 07:39:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: use passed in 'len' in io_recv_buf_select()
Date: Tue,  8 Jul 2025 08:26:54 -0600
Message-ID: <20250708143905.1114743-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708143905.1114743-1-axboe@kernel.dk>
References: <20250708143905.1114743-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

len is a pointer to the desired len, use that rather than grab it from
sr->len again. No functional changes as of this patch, but it does
prepare io_recv_buf_select() for getting passed in a value that differs
from sr->len.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 328301dc9a43..72276339e9e6 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1084,7 +1084,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 
 		if (kmsg->msg.msg_inq > 1)
-			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
+			arg.max_len = min_not_zero(*len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);
 		if (unlikely(ret < 0))
-- 
2.50.0


