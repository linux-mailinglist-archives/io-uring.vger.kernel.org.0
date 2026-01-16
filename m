Return-Path: <io-uring+bounces-11778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00EB6D38A24
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E32B30591F5
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A7B235063;
	Fri, 16 Jan 2026 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOt0Y56y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006D2315760
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606283; cv=none; b=J26VS59jHpd1t0KR4/4UIv9CSLnQ84yV37mA0SqhpXrleQGUOyTWC3jVwlCJgNpRPNWoRby86zE8IFa/IEbkcXEPqNBEQsamMKct2R1wsT8CTbPsjnrL4OoF3JSMDJ1qN/QPXaX/fFPCmIkWQFL0Ci5Lyr6S37bUPDRdyC8kNO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606283; c=relaxed/simple;
	bh=TKymJnPfMIR/G0xXXwk3m5+hMmX8AvFkik33yvt0VJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL2cfJjnMc6C+ljOTZloaiRI2SWPSx4aGPM8X/I+ccF8Tj7SI+t95VzdwK+0bTEigQuSNv+8NYFB+2A1AA1vkJrMen43JYliyImYShyw5v42cSto+nvulb/VHA1209wZ/UEYlPb0q3WiK28j1pSab0Cmidw+M2WZ49TH8gIH5mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOt0Y56y; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81f4e36512aso2510702b3a.3
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606281; x=1769211081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9e2WVnVPW0ep3D7NpjEyNSzUNgZ0U1FMNXtsOycPaU=;
        b=gOt0Y56yUBw4cw5pGVvgq9Kv4lXiMI/oX4VFcCBkK1z5XY8XAomtPY1aMuqI9PqA7d
         TLmIXapyo5idmK9X6iCAONchau+titsoCsiu84uNvbF2DLLVL3zi3gnvDHfsIGjMvjk5
         ugJ5xHv6pwJP/u1uwt/F+kl00Nb15fq2fLsc2NDLiDwDpZQjn7q/hRFHYcUILV82H5AI
         mQkL9Gw2fgEfpiYJ145F4Osyo5JbZ+CtJ9LxdRjajb3Yai0Itq4dzI/jJF5sx/mYqaKf
         F2CEhJ5v95RAipjf7yZyxixWOpv8SE/PcKlWoTc2CEb9B7UhRqWg6E/21uS7CjDeEQ2L
         jUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606281; x=1769211081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n9e2WVnVPW0ep3D7NpjEyNSzUNgZ0U1FMNXtsOycPaU=;
        b=l+YiRdkNOZt3DeWlEOuIr+KsaxCI4GmUyHKJewX4W4k0Lo+7nlfEIk3vuiJwyQuoBI
         jXSXnzZ8QZI//LuPm6j95okuBTJpdyivpnUr3JJPmnJTIChBomCMgQ9/Kl/ea6+8g9RF
         3+DR5H6uLiFSMr8gzzT0OKOxpB7bkW8cZv1YQKUy7B5QbAIxXyrE/IyPpolsDbimV8p8
         pSbxAkKfzRaB5yJs2Za2wkCcWexuHravcAzOfXKU5mEA8H6ay2/TUXbtZn02q+08xbsa
         BS07xn8XzJJ6M1lzkQGZ/guFFXBKcPy0J4+tOZ+8Z8yi8gfA3FvDB6TvlyManQhwakn+
         mm6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUWDuhzHIhtx4lqv2kt7qK1EWHB1iuIHQLKswk1v0/fEb+qFVfTj+LtQvpPzxb6gCztiNp+aEueA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOIgD0jVtWlRFaie4jDHoheHEAQNhSWAgMW3W9sB+JmI40QV0a
	n9qyux/FWC8HvftFEljLVYVV6pXTlb1ug8mnF3ls15SooZxb9AUth34E
X-Gm-Gg: AY/fxX7kvagA67PW8Oee868TZFdrSzVxwW8qkaFSKVYav3onlw5UXOMi6gDW0EYvSV9
	Fw08AN35pAUPU27czrkbqyyvDIpRab5h5CZaKzI9mafbbiiP9Pc3UjfYzTzk6QL227awQ/V6q3J
	A3daghKjSqLIdyvz3kOPhMEIUmg47BWwkwKHP2N2SuocmN18pJiJXgZwXkPRbGKAH5h3bd7L1hW
	N5A7c8iBR4IBpS8uoeWhDg/KgKEu/I701/IWA1E+MApyHVLnRilfLxnevf9s0cHVLgx88kjyub5
	dqVHL3wmoibb1Orr7APESewvqP/Jg634xE3LFmP9Mogmxxnajf1Oy5XQXTZh70BeQ7FYXHExEXY
	OGje5/le3cAEfbBRTU+pYVSsO036CAC3A7lEaGkLSzYC43y9sClbXnxxTVJACJG1i2V7HWxjZ0p
	7vRK90Dw==
X-Received: by 2002:a05:6a00:4aca:b0:81e:a228:f0cb with SMTP id d2e1a72fcca58-81fa1821d3dmr4183164b3a.36.1768606281325;
        Fri, 16 Jan 2026 15:31:21 -0800 (PST)
Received: from localhost ([2a03:2880:ff:19::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10c19dasm2942467b3a.16.2026.01.16.15.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:21 -0800 (PST)
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
Subject: [PATCH v4 10/25] io_uring/kbuf: export io_ring_buffer_select()
Date: Fri, 16 Jan 2026 15:30:29 -0800
Message-ID: <20260116233044.1532965-11-joannelkoong@gmail.com>
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
index d86199ac3377..d2a660ecc7ac 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/buf.h>
 #include <linux/io_uring/cmd.h>
 
 #include <uapi/linux/io_uring.h>
@@ -226,9 +227,9 @@ static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
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
@@ -261,6 +262,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 	return sel;
 }
+EXPORT_SYMBOL_GPL(io_ring_buffer_select);
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
-- 
2.47.3


