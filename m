Return-Path: <io-uring+bounces-11261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F74CD7809
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E82E3301EFC7
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8971FAC34;
	Tue, 23 Dec 2025 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSWFAJae"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F932010EE
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450205; cv=none; b=QFJWAJn+fG3UdRrpJeauhoZuiehYYGeXQLvUscoktoTsuaaeIjH383Ne706U94eQAmE+OI+86Lp6jWpGXT9h2XilyEiRBaiYyW33z4QZR1hcZi4Cpj8QCv8cw+0oijSku/aHCqQ2xSfKU6f9xwYbLEhR3YlqNAW9cOIj15PZyAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450205; c=relaxed/simple;
	bh=uy7rz7ANJzS8g9YfvJ6y+5dneuYaD0+ZB1BzdAjhmn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4dk8jTjnkDVW4ZEAiKkz9xdRnzURKq45HV+VbuDps3fVQKcngwMrjnNZn49dYsfOrzw8Lnq16ME1RMXWA53QOsYAKtBoKK30ZCWLBgWgjbYs5TyD1VQmXB3A1V19KunVELj3ZpHo2SwKJUIYtT62C1OmfpuNeusFtw3eL1JaiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VSWFAJae; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so5474104b3a.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450202; x=1767055002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgmTpRFxpbRQ6LsaGcERk0vIYiGREY+h+hCEQsZPeiA=;
        b=VSWFAJae1THOsatfqEwxhLem40t6RFjVU3uQ55VUE1WGOhDe6AYHkUt37NrWc+mGFh
         CFhUiK71ciyVeWCM9EAnptbSXqEm3eolv2GZcNqxWlBdhPlIuqXVbDXoSaZnQokDW12Y
         gppJO/AIMugpHIA20DSA9q43ccQeegOTAkU00dZ58DBLjK1yATHrOQp5VYjuYt9VeB6E
         v3YWzKhNgS0qhtLvCjiaAzak7MCDKaTJ83sDfYawFgLJdbAywmxvr8T7t2xCQW4PF21O
         GEjzfQVbefHLBLkS0fF4Q+6lml72pTKqaFA5EuCXF6q5iPcq/zYS58g++96vjTFyJO6I
         VAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450202; x=1767055002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fgmTpRFxpbRQ6LsaGcERk0vIYiGREY+h+hCEQsZPeiA=;
        b=ii1GKGq/EQK/u+XSDAHrRKOQ8Ftr3X/eS0Y3ulH02fTO4dntScx19ZO856ivu8px6o
         gSausJk1LWiytmMmhBdnuH0ZfMc6Y99XPHAFMPCXuz2aumHBylfGVZ/ddGhTJB+yzUrD
         5T959e/J4mf7n2R92t4A5GTW22gzb8JB7wYX7qN1j9lpLsex1Jdq6SD1iOHSo/U5klOX
         XIGcnXxj6OFswWRkfiDcC+gcQe97IJ3Guq144tJKUWa5vNTSQWTSrdB8ipPJuUCcigox
         C5+LCc4GIweOrEhpvf1zhZ9JyFa7Y0pC/v2iJRHiksKokMfCMkmHrjfp5aLI1sbh8cet
         vCxA==
X-Forwarded-Encrypted: i=1; AJvYcCUoL6vRcEM1ZuCd6wxjynaAi+Ci8JzLNDaQKF+IEvP+3vWXyp8e0m1stt1sJ3MyAEfk4slLHivlwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKKgLBrZJHVOdLP8Z89x6ATx2CmhY5DmIF9NqO8AWYr71daZzt
	15C+wf726mxFw3vnhYPZBkGimRx2iZ4QY9hsa103F+yDS6ehb8XGMGBO
X-Gm-Gg: AY/fxX5V5hUMpvvE0qJxzBY8z7tJLKLrDKzEjttgQYiwoXO7Asan2l8jte9z1GRF1MR
	BDCS7wE/rgeIPCokfHQFYyPiRLjt2/ROoaLvwz3ufyhAu4aSXpx/TzHeWpd81+1/D3xeAIYEUXd
	XA7fq5z/Zfd9FLYP6Vv0brFPCqJVbYpJSrHL3dyTQog6V0ZhAjxpzyCLB1i+gafPSWCO5iJiUB3
	aMm3qmaQH2R70+FNoQYrINv3AgdPs2VYBOBjdrIRPj+/S1YN/i0IBLnxyZz1CaJU/dvuMRYhX6Z
	nqRNYUhOzFDHwUZquib1H2++0c3ZIqVBVpCs5LXkIQBtpIJMWY6BpStFrKhKPoKsxB5D/IuRw26
	C3A+6rqflGxkdduTFqg9QnlGN4jTRigVIFilFlTrvYewbfzbCL27AqsF0R+4Sb45pQLN8/zusDH
	UslPbKX5zhxXcW2phJBg==
X-Google-Smtp-Source: AGHT+IE3km850x6VB8Rw3kN8nyohSRgqkNwJM2WQb0FNQx9vgDMtz8EqwHbBVscLsGzUW9kN9y99gw==
X-Received: by 2002:a05:6a21:32a3:b0:366:14ac:e1e1 with SMTP id adf61e73a8af0-376ab2e706dmr12057880637.71.1766450202488;
        Mon, 22 Dec 2025 16:36:42 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d77359sm109251095ad.95.2025.12.22.16.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:42 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 10/25] io_uring/kbuf: export io_ring_buffer_select()
Date: Mon, 22 Dec 2025 16:35:07 -0800
Message-ID: <20251223003522.3055912-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export io_ring_buffer_select() so that it may be used by callers who
pass in a pinned bufring without needing to grab the io_uring mutex.

This is a preparatory patch that will be needed by fuse io-uring, which
will need to select a buffer from a kernel-managed bufring while the
uring mutex may already be held by in-progress commits, and may need to
select a buffer in atomic contexts.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 25 +++++++++++++++++++++++++
 io_uring/kbuf.c              |  8 +++++---
 2 files changed, 30 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/io_uring/buf.h

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
new file mode 100644
index 000000000000..3f7426ced3eb
--- /dev/null
+++ b/include/linux/io_uring/buf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_BUF_H
+#define _LINUX_IO_URING_BUF_H
+
+#include <linux/io_uring_types.h>
+
+#if defined(CONFIG_IO_URING)
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags);
+#else
+static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *req,
+						     size_t *len,
+						     struct io_buffer_list *bl,
+						     unsigned int issue_flags)
+{
+	struct io_br_sel sel = {
+		.val = -EOPNOTSUPP,
+	};
+
+	return sel;
+}
+#endif /* CONFIG_IO_URING */
+
+#endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 0524b22e60a5..3b9907f0a78e 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/buf.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -223,9 +224,9 @@ static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
 	return false;
 }
 
-static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					      struct io_buffer_list *bl,
-					      unsigned int issue_flags)
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
@@ -259,6 +260,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 	return sel;
 }
+EXPORT_SYMBOL_GPL(io_ring_buffer_select);
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
-- 
2.47.3


