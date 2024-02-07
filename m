Return-Path: <io-uring+bounces-580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 526D484CFA8
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1004B2216D
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66228823B8;
	Wed,  7 Feb 2024 17:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IUWkaF3w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051BD823C7
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326395; cv=none; b=o5GRlZzg7l0+jwaQrpkHoovY8Kz13DJL+8TM7APt3GWjg3Kq47i1IkM6D/TwXBduTL1o6nng5ZvflqcdxPaO+Vm0ZyIpBryyu+1+lEM7LGKSWsW+WyKzE7tS+59fr3BYpehTjY1mCO2LLdov18YbZFsJ67FwGboYlEf4gxhRJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326395; c=relaxed/simple;
	bh=iW+NquMWGt9Gqk/vv4bbPeGDI6UBStnYtNVupziAj8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKOJAzEOQJyK7DlL3dP/pGRkT/2s8yV8gy9jU/53O8Lw8iF4ZPQ9DtXUO5F07oqKeH+Htd/Xrhj/mcFNkgxeQw+nzogw5pMa4R8RNq2S3Kl3MyqPzdVjTj7SURwkvDX2Ei6iuW5RT4libPGXj65wGgfoV2UJOIieLqD5fVZ6wA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IUWkaF3w; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-363bf960762so259775ab.0
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326391; x=1707931191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdoaioIXngn6g/+xmxUBVqHGk8dPSTC8+pDTCg3h3uM=;
        b=IUWkaF3wkynlNdh304l+lgXsb9/nuN+dmPcwumsh19VDzeUjssehJXGqLPYiE28Lfj
         fjnNcsUTvTabKAznKz6UQhGGRsRAq7k4CXW2mJ2Thx3ISsJS/h6pfRyvG4meI8wSl3Fk
         5cpbQASrt95t/345IVeh1j5kCAto4DoDLgOvBYuXMGLGeJ+XLZBsi85rRJGA/lwEGZWA
         2fxA/8/D2cBUM4ToXDpGBGh+MHPGed9IfVoQThGDgAwwoeXjXQdVS13InXe9Yn84PkVk
         tPUEziMjuvLhEbyQQwZUadizEThNJPPUvguVOfJj9j5VL3KahWwSeKhtrjGc7ex3jT3A
         dCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326391; x=1707931191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdoaioIXngn6g/+xmxUBVqHGk8dPSTC8+pDTCg3h3uM=;
        b=C7Tq29vg4BV6h464sPWzMxkh5vDwP8NIXTbrxBNdrt258aIw0ndnACBIU7w8m7RX8W
         OfbiIPREnJDVTTyKZOxbTm6Z6ZjEtVMhFJ/Eja7ySg1d3YcteeHfF5Wos+mMPt9KFwez
         0eUZDSYDvMQSCKTyhf1lNVTpA/doY/B5392ENEI9puoZBJqb44KQ1K2yahc7qq0KMrDN
         NM0HV2X0VY7WmAU5rlyQyOUbVfF7lgDr8mrxU1xLG9rwVTYvUd62c00YAT+Rq+PbBMl8
         nExePJ+Z0z6wgDLRFolN81IBA3xkaYYd8Bqouii3Eg2+IwW9w0Cjqm2jLcHMPirWZbmX
         guaQ==
X-Gm-Message-State: AOJu0Yy9HZOS09Jm1dLpN4h0PYJH9vfLncwO3kBfTILrqMs5I72IOlFb
	6dwr0ZGR0UOp+1Ki+1J1w2GmqM4Jb5aUfTRh4yqio0lY/+icCAVfLKYTbZZ/TqrhC1Lf0ml+JR0
	RuaQ=
X-Google-Smtp-Source: AGHT+IFFC/UUpA08qMxhDve3FFc8a23sy2Ubvkj360wSkt5Hz5rJDLA76fijlM6UCT+aj3c/YWnoTA==
X-Received: by 2002:a05:6602:2410:b0:7c3:f2c1:e8aa with SMTP id s16-20020a056602241000b007c3f2c1e8aamr5896417ioa.0.1707326391654;
        Wed, 07 Feb 2024 09:19:51 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:50 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/rw: remove dead file == NULL check
Date: Wed,  7 Feb 2024 10:17:40 -0700
Message-ID: <20240207171941.1091453-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207171941.1091453-1-axboe@kernel.dk>
References: <20240207171941.1091453-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any read/write opcode has needs_file == true, which means that we
would've failed the request long before reaching the issue stage if we
didn't successfully assign a file. This check has been dead forever,
and is really a leftover from generic code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0fb7a045163a..8ba93fffc23a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -721,7 +721,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	struct file *file = req->file;
 	int ret;
 
-	if (unlikely(!file || !(file->f_mode & mode)))
+	if (unlikely(!(file->f_mode & mode)))
 		return -EBADF;
 
 	if (!(req->flags & REQ_F_FIXED_FILE))
-- 
2.43.0


