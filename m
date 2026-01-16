Return-Path: <io-uring+bounces-11780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 017FDD38A27
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B2C0A30954F8
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42252325498;
	Fri, 16 Jan 2026 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcIUq5k3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023A6315775
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606287; cv=none; b=NjwBHVmQQZYGrAmt6VCLNjWlC3kvQ0lHdZlRJvNRAVr/Epp6SWkGrMxG7hnLXegrJ3yfZg0/cVrbWH3ssS9tozjsKCB3xXm0Bso9WVeN6n3NU8zkNfaFGTg4/f13OtJEuEzC/ZQWtUGgIFwEOcQcuBfT1W4tmkyqGBRieLskmIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606287; c=relaxed/simple;
	bh=GD1NmkO9aHCzuWcuPVG5FvbcnOb3CTOFaXwrWf1dVoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD0S+CNku9UymfC33Kzr+6fFSdsSe7v9GjXprsEsr8L88nYifFMv1Uk7M6BavdiyAh/UzK0j2ajDa2tsyoX94FX/TwjA03baXSFXJxJtsuCz0mYApFfgsiVv+sNvF3eHMikG7/N5efVSPRkT1RnkfhLLJQeXwzr0fPUiWUJ0wZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcIUq5k3; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso16585335ad.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606285; x=1769211085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ADA4qsOfE/Betp6Q2noLvGrlEIPGsl/nrHF+qqwaMQ=;
        b=mcIUq5k3SadkLjdYfRzCWzcubRMSr8TyYsykyra9QN8jP2wG+FPsVncxM7FVfwbLAj
         5aDb7BriiJ4d1u3fIx/hOso0v+gQD+XJSq54VRwiHV48sNEDbmsf7dzcVCPshr+A0hlc
         BfHmLC8Cr5mCq5WpfWp+15neWwQDX1olN7Pf/HIpAQurk9yuXpvei3jzflB6Y7Pb4JO6
         WzoUt8+cDT8DiXrZyxziUvPyypbbwXuMqr2Bnpi0cHH3Tx67enhvhVl6YSmrDwwfkMWy
         6UeHFfpzxufnFmcuqfNkPjXdwwlicZBL9SYanCYC8aCcnUTbPnaiesD6PBXNUSElJpKi
         L1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606285; x=1769211085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6ADA4qsOfE/Betp6Q2noLvGrlEIPGsl/nrHF+qqwaMQ=;
        b=tfecCM+OtF3Pccxqzmygs0fkhlGHJWYrQjLyAfNfizvykirk2DqX1OlW/qR8ERv3Yj
         l8PkR6NuefCpEQQDzy3vnHJI2UXzLdABmYIJTttpVccZtY50L47e0VrOzVs1Q+waivfm
         KSunb3RaIO3r/Y9ZIJ3XnTmFeQRyan4iH32nlMdIoQBbEXex9zyy0UkdyGSujD6Vvlx/
         JDNh8OTkoWK/pDFlb2N2NmA2piogpFC6kWXw5OQjtMaY1beb5kVQ1DB10oM1BW5gAYlt
         ULeFZFCkx/QmDcdxAucFf6RtpAVH4RFxxzrpvSsyNPq3OovaXu8oNoP+DF2iU7q+W0Mp
         4e9g==
X-Forwarded-Encrypted: i=1; AJvYcCUjUMoMZ9qgSiXIvFko6loJCP3ly9edZ/vv91k2ScJbqXqx0BBHi3uQfzWuFh3MGn6mu+pnvF8uIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwP6XX9V4VLRpulf/dPoPGWlyIniSIhIIhhi/gmieFDzEDw5bc8
	ba87cGxfoZwwMwTMjLi/F0z7s3nLk3h5sSHOaPeVSy5hKxZ5vO0GLRKX
X-Gm-Gg: AY/fxX5euNBx0M7N5Mm24FB3XbzDhMDcZ1tf66x62fWIf1kkSvrs5C8xfNITjU0Kptt
	weskUAWJi1scrCKTL2MFsAR4n9BmozvjVWJ5jFWud/gsRufuSqk003AFe79v8gjdkaQm35er0nE
	9pLYq5OwsrTvLUs7WHM8x7RIq1J5kuuCXJkWi009d6FLGBhAf8AG0wpsdhuQZ8OY2HfSdl6QhMd
	9cgWXdX8qa/I3gyO/hF+QExC5+CNaKM6qToh4/XAFL8TcZtV1mTFn2+iZmwOkw6jqanizIb+B0J
	9pN5AhzNL27uRLCMogrDmmyS7i2KnoJmDe6x3H+zry1MAYu+r+QzZn79wuN1owT/OQmB1edbYc/
	Zc1GFp4GG2vjiXnZ53g66iPKPngOokONYDN7wY6ezSchiD5XP9qvsyU3vsVXjwvWeoqnQq8gToS
	0wAzaS8A==
X-Received: by 2002:a17:903:3bc8:b0:298:4ee3:c21a with SMTP id d9443c01a7336-2a71752aab2mr51276715ad.2.1768606285341;
        Fri, 16 Jan 2026 15:31:25 -0800 (PST)
Received: from localhost ([2a03:2880:ff:54::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941e3cdsm30129075ad.100.2026.01.16.15.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:25 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 12/25] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
Date: Fri, 16 Jan 2026 15:30:31 -0800
Message-ID: <20260116233044.1532965-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When uring_cmd operations select a buffer, the completion queue entry
should indicate which buffer was selected.

Set IORING_CQE_F_BUFFER on the completed entry and encode the buffer
index if a buffer was selected.

This will be needed for fuse, which needs to relay to userspace which
selected buffer contains the data.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/uring_cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 197474911f04..8eaea40231ff 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -142,6 +142,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		       unsigned issue_flags, bool is_cqe32)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	u32 cflags = 0;
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
@@ -151,7 +152,10 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	if (ret < 0)
 		req_set_fail(req);
 
-	io_req_set_res(req, ret, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_BUFFER_RING))
+		cflags |= IORING_CQE_F_BUFFER |
+			(req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	io_req_set_res(req, ret, cflags);
 	if (is_cqe32) {
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
-- 
2.47.3


