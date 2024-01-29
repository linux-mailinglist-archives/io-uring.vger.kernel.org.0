Return-Path: <io-uring+bounces-495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D9E841458
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 21:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC0BD2820FD
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 20:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FC653AA;
	Mon, 29 Jan 2024 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L39Um0l5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8135EA21
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 20:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706560234; cv=none; b=RWHty3znyYkAlt83cMH4+Z1PXNy96iPQIJpcDeCOCkfZpZjSY5bCdzF/PtxZ3NbSUpFotclKpXDHfjzHmREPl+XSALUxmCbD+mdXIhzsjBT854F03oRGBvpvDUTQGrhHgWnO39tsrCtwzJuuBDTCxkeIvpDK4P/zImqDwcCf2pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706560234; c=relaxed/simple;
	bh=YS03xbG0odVO0lGQxdTvwAnf2ZC5giEb8iXYWz4CaWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyyRZYSYUoh2aetmi1A8I5E9bd/DlflaVrQGZq9kVvgigCDr7c6HxQQY/+rWQAbwCrABBx4ksRGBfAWkWy6sA8aG0t+cfVCA+HGwAUlfff6yX0T8AaXqZkxsMrVDVwCRDN+GJ39qA+YooTOXWjxuvblRCEfL1ACVGSUE5PcBiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L39Um0l5; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso7654839f.1
        for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 12:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706560231; x=1707165031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCfxKu0+1vsIk+M+VwSWxtuM8+I3PGc7NT21G792nOk=;
        b=L39Um0l5DY5Xe/QCGabNwq/RZy4Meefm7himAioeb2XvI+LnvAFogM+3Qolwnjxede
         yRPPCjEtgtORo0fcj0Q0ndCoYk2jc90RdOcHl6hNNuYE+Lb04dhe40jJYbW0di6kuW7k
         p8oSCOypW8IV5u/T8gqlsmI/CnPuMJw8zcWOUQgiMw3uBqMoDUs/WMlNcO4XgU+YC7hR
         1w1UHEYXNkeZykoDBKdh9cn4t98CmxBE2q3r8PAXRKLbLXL7cKHZbuxTSXPsuE8bHbs/
         eszWhJLlSD2u1ne//ItJ15aBVHc9CzD5P4PgL/I1Npd4u6eAzLdV3p0pVdkugcQUVJ9Q
         0uPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706560231; x=1707165031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCfxKu0+1vsIk+M+VwSWxtuM8+I3PGc7NT21G792nOk=;
        b=kLcVY98Nv1Dm5WzqbKXv55UFH5AJY06yYGaTs3lPXhBPZ3HSBmDriOQGWVjO0wGNmc
         qunmDNJnm48vg7PHzhOalS+a4mGwqWPvXYfm+UcvFizqUDYKVXPdhW8Ohmv9ReOhnuR8
         lYbNBCuZ5D3Uv9ndnKdFvZGUuCwxk/uVGGFOEaFFDqHtMNgnenBEQqP8vLrg+IOdGqRk
         yUDNkdlyoUM7FcbQFQ3etMz0D2ky0JSoFU2uRJ7I6+cpj03AWtdlljXyYszAzGwm/G3t
         +d7UTjaUO7X3GVyxDBpMbumxu+hss6aQGsbBBfU11lOYfT0f0Krdl+4bgUBX6V0fRqNO
         lYvw==
X-Gm-Message-State: AOJu0YzpzZwaqVJZiGkaj+IipwNUTXzzlXlKZWTSxqOH/0kvEJ/IEGIm
	fj+Cz/GbrUkEo4Or62jOsZFCqB8Daqj70uIGN3E+sMJuV6PTRWYdODDBp6ulrE6Igq7Aquizslz
	94LA=
X-Google-Smtp-Source: AGHT+IF/HlY95NUt4TUcWUUQBtX11tZ0PFBDQQPfijzg3eii4ZqIk8kVnv26alW9QM/qF7Uv14WofQ==
X-Received: by 2002:a05:6602:2352:b0:7bf:dfac:316d with SMTP id r18-20020a056602235200b007bfdfac316dmr6628565iot.1.1706560231208;
        Mon, 29 Jan 2024 12:30:31 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i8-20020a05663815c800b0046e6a6482d2sm1952510jat.97.2024.01.29.12.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 12:30:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/net: un-indent mshot retry path in io_recv_finish()
Date: Mon, 29 Jan 2024 13:23:45 -0700
Message-ID: <20240129203025.3214152-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129203025.3214152-1-axboe@kernel.dk>
References: <20240129203025.3214152-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for putting some retry logic in there, have the done
path just skip straight to the end rather than have too much nesting
in here.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 75d494dad7e2..740c6bfa5b59 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -645,23 +645,27 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		return true;
 	}
 
-	if (!mshot_finished) {
-		if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-					*ret, cflags | IORING_CQE_F_MORE)) {
-			io_recv_prep_retry(req);
-			/* Known not-empty or unknown state, retry */
-			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-			    msg->msg_inq == -1)
-				return false;
-			if (issue_flags & IO_URING_F_MULTISHOT)
-				*ret = IOU_ISSUE_SKIP_COMPLETE;
-			else
-				*ret = -EAGAIN;
-			return true;
-		}
-		/* Otherwise stop multishot but use the current result. */
-	}
+	if (mshot_finished)
+		goto finish;
 
+	/*
+	 * Fill CQE for this receive and see if we should keep trying to
+	 * receive from this socket.
+	 */
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				*ret, cflags | IORING_CQE_F_MORE)) {
+		io_recv_prep_retry(req);
+		/* Known not-empty or unknown state, retry */
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1)
+			return false;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			*ret = IOU_ISSUE_SKIP_COMPLETE;
+		else
+			*ret = -EAGAIN;
+		return true;
+	}
+	/* Otherwise stop multishot but use the current result. */
+finish:
 	io_req_set_res(req, *ret, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)
-- 
2.43.0


