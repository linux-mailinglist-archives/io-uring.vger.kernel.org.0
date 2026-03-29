Return-Path: <io-uring+bounces-12886-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDxCCmlYyWkuxgUAu9opvQ
	(envelope-from <io-uring+bounces-12886-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 18:50:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 773AB353243
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 18:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D490F3005759
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 16:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65265377039;
	Sun, 29 Mar 2026 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jk9RcH3b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341002E6CC0
	for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774802985; cv=none; b=F4tum53S/xLgBmsw7GE8tKr1INfkdAVoFvF6lmV5ZWghdNamXyMfi3Qdc9LZGChICqpxAzM6FCpl17OapMSK9lFDpuSk5klpZaeOVWEjZ8e7f7pwVJ9fWLipd+RNAbWDRdsuT2wrQtRpmB5nLIbuRNYd20lvTYDepp7XJfY+gjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774802985; c=relaxed/simple;
	bh=FegCePrRgmlQ4BFtsYObKp5mK24ZIcDy6Qpqk9+d6wg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ha2FQiyAq95TZzLG9eS2cC6zaTpOApXV3NMHdiu8GH9SF3LXQ9UjKyPw0XFhDQXtFAWE5Reyl70xj0+68aGQFDt7l2Rdp1UQje7RVomfd8GQbtRvW3P7BekGdMYjrxRjEWOSxpYc4taq9AJiegiuDPIG6V8qtONvUGuDauUNfDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jk9RcH3b; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35c124d2613so2428567a91.2
        for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 09:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774802983; x=1775407783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cD2gxKgayIiCaDoFwClB5W0CmSi8WMV/LcL4kFdAEFU=;
        b=Jk9RcH3boaiC5lLNW+lpnd3hs9mmZ2PFaYhXeymxIW+gKmqe634LQswpT+erR6TW3o
         uIw6iC3u+HbjtcCV2hK4d/IcR7SzpQ4aT93/WjyKgTcFnzFwv7Cdn7SVqW7AVpORwl8H
         wzTX/NeyWE9kOrHmtTCjEK9gLjE3dfyx2dZA4qmuwyEWjRfnDIZfF8+4LdJAErCHvbci
         7Yb/KQlh1NbIoSRVEMoZyPmGlSoGPJwRcJ3bSdF2jvJQB1wbWbNt6k4dPIKlP20LqHS9
         jGjez1Jsr3JnAflKy9YK/sScxZyr18U60PMkU701NmXBUrTWxliNE1RfT3dadTAScGbk
         OGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774802983; x=1775407783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cD2gxKgayIiCaDoFwClB5W0CmSi8WMV/LcL4kFdAEFU=;
        b=EbVor3SdhlGZeOGMy9n2umzfH65yOFM/TmaMmJ2bNkNVxZDzAL8FnblYXwaFByuq2P
         vNo5YMt7L3evX2fY0vBmSDpjchDdtd5CUXROJlmppSYLdFv7dg3Ql7K0RDXVH/Xzy0kO
         q+LAstmzOpIq32a2zwZfSUwn+Qxoo5feXvg+sK+y3qAxXbrjOcu25YmYMXC0HlRKUWuZ
         ZfWxXMs2u5XFQfgAzjjpCBzZboJJXcSeF2o+QST6YBUPvRGmLf52UM3mls4pkyZpR95X
         GgUt/ZnNH6ef1wZESRilkT4PByqwBVdT/ROWkp+dm+FYUN1zOC4q9Y6NIqqvPeSzkLQ4
         bOfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpDfzuPL66cVwpkJQBu8R9PHLlBlrHFVZZPJWhEqszFkqGN5cDvE6AwKaqcdB/CkSKoDIy/+k+EQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2f77wDbOKf9c70r6bXRf2lYFbjm7I28Z4P1WAUIFYtCLVVRfx
	5/1SJmVB1qL4MWcqLuUd6IZbigYTBcgkJjzUj46RxHkfoGAk/UBwVkATRKXlF5I9
X-Gm-Gg: ATEYQzwLT/r19qHRB/46sFLxtmmzhmWsTugOADJeFnUwPAMQt7cjePw5vMCt2wr4APC
	N1/e6s0yi4J0+d60j/lEfSeuuRayHbi3VNcfYgA31sf35EN3RzK6ILklP7A1ifV0LXGD/mVQ60/
	9W2xk7Wuq6CPQG7fjh0YNPbItr7Gg4iXNf6b8DF5zPgtbnPh3/b1Lrr3zPdFKJYuHlVWwvHoCst
	7MPB07cPN2tlnRn77UDFVGBcEeRB2sgpe0fpLhDEnkKI6LwBDk2C5nAeqaF/NyNOExPtEswFYU1
	yH1H07IHg8p0ufloyBR+AUgEmC5ISegH3TmTaW5if8pMdhsrVY+ypxW5PeJZ1It2M1OyOAr+GPx
	AkpA///7XEpaNfVZncxZgCITfB+Ly0JwimKhgDKLW2DgEUbGI4luYSXPQyyBJQadkwn5QWQruxQ
	yiMqzj/KG8ASc0H2+Zf6QnITk6kU+u37xz62U=
X-Received: by 2002:a17:90b:3fcb:b0:359:f6f8:57b8 with SMTP id 98e67ed59e1d1-35c2ffafed9mr9455628a91.1.1774802983393;
        Sun, 29 Mar 2026 09:49:43 -0700 (PDT)
Received: from localhost.localdomain ([47.236.127.140])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c2f398df9sm4023623a91.1.2026.03.29.09.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 09:49:42 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH] io_uring/rsrc: reject zero-length fixed buffer import
Date: Mon, 30 Mar 2026 00:49:36 +0800
Message-ID: <20260329164936.240871-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[redhat.com,purestorage.com,vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12886-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tpluszz77@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 773AB353243
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

validate_fixed_range() admits buf_addr at the exact end of the
registered region when len is zero, because the check uses strict
greater-than (buf_end > imu->ubuf + imu->len).  io_import_fixed()
then computes offset == imu->len, which causes the bvec skip logic
to advance past the last bio_vec entry and read bv_offset from
out-of-bounds slab memory.

Return early from io_import_fixed() when len is zero.  A zero-length
import has no data to transfer and should not walk the bvec array
at all.

  BUG: KASAN: slab-out-of-bounds in io_import_reg_buf+0x697/0x7f0
  Read of size 4 at addr ffff888002bcc254 by task poc/103
  Call Trace:
   io_import_reg_buf+0x697/0x7f0
   io_write_fixed+0xd9/0x250
   __io_issue_sqe+0xad/0x710
   io_issue_sqe+0x7d/0x1100
   io_submit_sqes+0x86a/0x23c0
   __do_sys_io_uring_enter+0xa98/0x1590
  Allocated by task 103:
  The buggy address is located 12 bytes to the right of
   allocated 584-byte region [ffff888002bcc000, ffff888002bcc248)

Fixes: 8622b20f23ed ("io_uring: add validate_fixed_range() for validate fixed buffer")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---
 io_uring/rsrc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4fa59bf89bba..1b96ab5e98c9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1061,6 +1061,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		return ret;
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
+	if (unlikely(!len)) {
+		iov_iter_bvec(iter, ddir, NULL, 0, 0);
+		return 0;
+	}
 
 	offset = buf_addr - imu->ubuf;
 
-- 
2.43.0


