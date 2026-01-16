Return-Path: <io-uring+bounces-11791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0A6D38A3E
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:33:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBB5E306EC0D
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB2832ABCC;
	Fri, 16 Jan 2026 23:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="modJAawU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A29532ABC1
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606307; cv=none; b=pNi0+M0y9Oo4wHfWXtTB33iZdosWj9K1OCmAHNB/BO2RNuHTEqU7EntV+yAtK1/PNn9kQX7dK5CMhXzbvPR9B/xFcFYsa+CFw/W4GM/lDqfIpsEpfgQhik5bJCgsnW+lIL78PrdON4qmUGnfGoNPjPS9n/2Te/pRn2RW+cALbSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606307; c=relaxed/simple;
	bh=56Fb7wzUTSl0oceb1oef2fxtQTLKsyxfarQ2lNZJJu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThomTScTgwLlo72XndYJvFvdi8K2RqJ/QGhTzUQ+ZaHtjams+qYjLSJpr5IW34wgTk43rHVoWqHOBQGnZQw5FmfWCIN4geAE53qiZ78U6ieBhMebsGlPq8qOeIQ9YUkdLSRpHqcxtpiy44/72ugu6lhA5/z+NQ4tRpqeAlHEik8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=modJAawU; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a07fac8aa1so18176435ad.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606305; x=1769211105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1uswQbwaALq1AcVwcuYPMRPVeMNvBx5ucL/SDcIxQA=;
        b=modJAawUQvrXgxvx+l3Cg9HIQMFXzwzyGIgjfNFR3N90QEQyMWsBb5gVJQW6zisMtJ
         jYkUmGOqrfnrNtj+y6+9apeOmnRI9CTmrF/b0f27Kff0U8MFUYieA0dHfn2kK0SxnUrc
         oYRKyKI5QmhLs6rlZsoRGkIRos54HWHZ8jL9rAmKo+VOIufNUzFgdu0AfuEnKhean7Rc
         mVk83syqrBGdPsU7pTD/Cn3V/ICoRKyIwWkxqAZQeDL0WXyulguFt4aTgwmSqmGeMtsY
         +oq2Ly/0kuTbL9xYnVHXG3NuamSi7Gl8+DE0Bhdb/zQ8zQwgXIRYbilTC3bKcpd1Nqr5
         7DtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606305; x=1769211105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A1uswQbwaALq1AcVwcuYPMRPVeMNvBx5ucL/SDcIxQA=;
        b=Ny6gsYYbu3HmDM7ZGIbpn6ZR4GXLF24eol6eDy12l96plypmLODGwH39j/WuTDO3la
         BCD16OYvfIP9j5tV3NXoBtPr1XFP8x14hJpvCZNwYcry59prv5fPAbq8aLQudgRuFDCi
         5lhql/IcW7HGf3TW3OCE0VMGW66cwhBDq/BEfykpwb/apCQww7pOeD2y5KXQPaRXM+S4
         XfaDcFMCQYkN63Zx2QLOz39mqwW2UvixDV+Tl4xcPsvaP+uyDMlDuxNrHdHJR3d3PdDn
         x/ebPR6J97t3Ktwkj2igpYkCa4zIXRq/B3HgzR2OgCar4t6uSPelE4n/QjEh8I+7XEbG
         x+0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVf6z1yDzStsfLSH+m5/5S5fjUIpcNFOGXtUTOjFKP+Vz2cOtl7U71qbx5MEgwid/rsBOvVDdo/2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YywKTcxtxW3mYs3G7NcCi79jDQ5oGQCRs7Rdif7rGpE39ba0+pB
	NpAMiSIWGpjsetoY2YD3kC7IRxTvVCVavdjfsECgUhnF3bDX94x9J2Lf
X-Gm-Gg: AY/fxX6PdoZv/2zyB4ARiRxmku709G7WfyFFW7wPUAenA1od+6E9N0iOpHiO+T0QE9S
	xcayyhw+COnkRVUtD1uYUAIIM0EtQz3gZFG17vABJHR5nqLLYuh3j5XyZgZAmDcLhGnwKUyzyJo
	4R/yxLmWq3l7ye2sZzpxh0xQdVx8K3OTrJE2/RmcD74R+99cBnvpdNbxTOqzG2dFxKs3KQsSGbm
	UO7bb2Ft7wZYB/YOor1zBj3e/tcIfKSXac1e7A0T7k1GBWQ61tlFSI+N/MvJYfsyiLsh5DkEw97
	W9dsiFTwQY6j1D/wL+xSFeJGiChM26R0CL0dXdl0co3YqFQtKzfPVIs6ZVfnPFoodYnG19NMlf+
	JSWQWS9f9VHWj5v1GIygmEKbrHFZKcqQfMtiZPXLDoSyAH+fI6LBuXCy+5j+/RKC3GI4Hle8oTG
	8C/jUY
X-Received: by 2002:a17:903:b84:b0:2a0:be5d:d53d with SMTP id d9443c01a7336-2a7177d1bddmr43945115ad.53.1768606304678;
        Fri, 16 Jan 2026 15:31:44 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd532sm30608055ad.66.2026.01.16.15.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:44 -0800 (PST)
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
Subject: [PATCH v4 23/25] io_uring/rsrc: add io_buffer_register_bvec()
Date: Fri, 16 Jan 2026 15:30:42 -0800
Message-ID: <20260116233044.1532965-24-joannelkoong@gmail.com>
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

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 12 ++++++++++++
 io_uring/rsrc.c              | 31 +++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 73f8ff9317d7..7dde6e2af05b 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -107,6 +107,9 @@ bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
 int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 			       void (*release)(void *), unsigned int index,
 			       unsigned int issue_flags);
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index, unsigned int issue_flags);
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags);
 #else
@@ -197,6 +200,15 @@ static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+					  const struct bio_vec *bvs,
+					  unsigned int nr_bvecs,
+					  unsigned int total_bytes, u8 dir,
+					  unsigned int index,
+					  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
 				       unsigned int index,
 				       unsigned int issue_flags)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index dc43aab0f019..b6350812255b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1019,6 +1019,37 @@ int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
+/*
+ * This internally makes a copy of the bio_vec array. The memory bvs points to
+ * can be freed as soon as this returns.
+ */
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec *bvec;
+	unsigned int i;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, dir, NULL,
+				    NULL, index);
+	if (IS_ERR(imu)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return PTR_ERR(imu);
+	}
+
+	bvec = imu->bvec;
+	for (i = 0; i < nr_bvecs; i++)
+		bvec[i] = bvs[i];
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags)
 {
-- 
2.47.3


