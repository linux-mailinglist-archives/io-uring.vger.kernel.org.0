Return-Path: <io-uring+bounces-12569-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPkGKeYgqmn2LgEAu9opvQ
	(envelope-from <io-uring+bounces-12569-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5110C219D8E
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B4F3304E0E3
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 00:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A6F2405E1;
	Fri,  6 Mar 2026 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NE/ueNpi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6062D63E5
	for <io-uring@vger.kernel.org>; Fri,  6 Mar 2026 00:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772757196; cv=none; b=uJa7wtJabfnCKvK4PcrXSQj647un9XXfAfzML3Gx++HIr+HFe4yKZ71A2O1d+WdfZU83UG9bHIoYC5F1oCbx414fevSG4XKHV4LcaVjzc8UVmIUQKN8pi+caN8O55x/NR0czfjHEkh0qU2qX3rB0MprFQDfLRGNuPcQbGWDk7ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772757196; c=relaxed/simple;
	bh=gYl/EgPLgpRLJ70W17x5fC4GYre1xgh+fhjLlQ2KiVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u82uIm14umB4h+idToPkM4dw2uDPJGhYx6SbGcSKQxDAaWLj06n6Ah8ALCQpo9gweJGqOnpWRPzK+Gd4UKCrM1u9ETIB0HP6IUtV/bbmd2ltuth83i8F5RXw05QA5dMp8ZtZuklZfojdrY86bI49qdbBHsxSyWAo6wyNZO8iJWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NE/ueNpi; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-829781b2b01so1470129b3a.2
        for <io-uring@vger.kernel.org>; Thu, 05 Mar 2026 16:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772757192; x=1773361992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hh6d1b/FD+K/ax8zRmQDjv0XKlqoqIbuLbK4qEFzOTw=;
        b=NE/ueNpiKY7hK+wzVJJX2Ju4/rZEOKD7HVBXapqFATiB+e2nOtohVtzIGM7eXIb51Y
         Qx7Ykv4ej6gWeFERDVvHkM4Yk8bY06uFYkZVZTrPauC2LD+jeciMqguNCtwuzpmocuYW
         e3DRMJanzw9/VZIVC5kzST5IslA21TK9d7pKiCf7RmyEBeh/F9H88cjEK91mDqAIEvjB
         ABOyqy9Sc8cl6sRAZWvJW3QsNn3LU6qkmu06RxRIJfv2I/KhBgKPBuI4gLa5f72SHauv
         czkXvQchJHeqhNwzSnWWP0uwyj7/Wl0hmLRajfVDsXEWAO2PYgCA+hri4zLs1uGH8wzk
         4KjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772757192; x=1773361992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hh6d1b/FD+K/ax8zRmQDjv0XKlqoqIbuLbK4qEFzOTw=;
        b=oUDyULeo6eIswLFt9c/bce+vc1WchfSYpH8hByLGiaj54lcS8ZVxxqmgr/o3JxVV3g
         VpsbWx1Z/QpoLHYsm0L5BNtSRJVjfra3nFxFtivT1rD/Kx+yGUZvO63KW3CpGcuWuVdd
         YmSDMH3wHycRFyHq0sJz4cZ+4oDkjeubzOVMFbIXhrjD0MqqTCiW41qLaL3HW7PQu660
         OCtvAE6gOhdseLJGl9dWu2SEYhJ0C/kq5TctwI2fUroco6vzuwNzzFIuz/Gt+Nhma4TE
         Ggo4r6lXQBDXNjI9VCDk4NmeAQnGXrhD47Ve0S3RPbrgI6hpnPmI2t11NB/APE/eNMFW
         bATQ==
X-Forwarded-Encrypted: i=1; AJvYcCXATF4GKiztxH6UDAoM2wzRSbIUGQVa7gA0WZ3m553fVcGLQc0gTKSKxohM6xCJskqSg6C67HXsVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YymjlITxkc9yAM/3LcbekQ+8LHMeTZ2rLyb6y9cVkKC+Di6s5ZV
	8ijFZb0YQz6M3EiswengVVm5e9lzbNFOck8n+9j/XH/Q524f0a+K5gj1
X-Gm-Gg: ATEYQzyIzDUs4jYMd8QbmVeXSdKpn4Z+DM4i0NyZm3133Y69MC1tLmjqeTZl1WKI+fr
	iqTIR4Z7BdlIfg0F5HYRqzn+NrQn9bGDCqhM7KR6T8BkF32liMa7BnW+xhNpI+7vLRVEmu7yfA6
	Yi/YlGme+/y2UoptoinE7jK63KLQqbu9tmY/cmjrKuw1uEjaEkewGIn0ga9jW381sjgTiqCBmw8
	5D8V6lmvHxxTUryr6rj+b9YSvJpC7UMd+JHf8dq4fms9EVSx0hb39WAJIp1RoBmb59cjFS3NBJu
	DJlXRXMVz4p2OLeK9RbVjgJbMfFfgU6ihYLcEnZ3fzOwQD0x37a/NAE6cr2eGE6ootuZPaxv8AJ
	YEiPF/KsUz8BJiNoFO0hlaoQqEVcs141DlXeBk0yuOveQQJYQlVuNH+n+f6ivyh3mySieifNDd9
	6XuZG0OyqxmdrnxndpuePDD0eJZuzk
X-Received: by 2002:a05:6a21:513:b0:395:9bfc:d5fd with SMTP id adf61e73a8af0-398590b6409mr423618637.54.1772757192461;
        Thu, 05 Mar 2026 16:33:12 -0800 (PST)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa82dd09sm20664692a12.28.2026.03.05.16.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 16:33:12 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: hch@infradead.org,
	asml.silence@gmail.com,
	bernd@bsbernd.com,
	csander@purestorage.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH v3 4/8] io_uring/kbuf: return buffer id in buffer selection
Date: Thu,  5 Mar 2026 16:32:20 -0800
Message-ID: <20260306003224.3620942-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306003224.3620942-1-joannelkoong@gmail.com>
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5110C219D8E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12569-lists,io-uring=lfdr.de];
	TO_DN_NONE(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Return the id of the selected buffer in io_buffer_select(). This is
needed for kernel-managed buffer rings to later recycle the selected
buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h   | 2 +-
 include/linux/io_uring_types.h | 2 ++
 io_uring/kbuf.c                | 7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 7ce36e143285..505a5b13e57c 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -78,7 +78,7 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
 /*
  * Select a buffer from the provided buffer group for multishot uring_cmd.
- * Returns the selected buffer address and size.
+ * Returns the selected buffer address, size, and id.
  */
 struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 					    unsigned buf_group, size_t *len,
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 36cc2e0346d9..5a56bb341337 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -100,6 +100,8 @@ struct io_br_sel {
 		void *kaddr;
 	};
 	ssize_t val;
+	/* id of the selected buffer */
+	unsigned buf_id;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index cb2d3bbdca67..9a681241c8b3 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -206,6 +206,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
+	sel.buf_id = req->buf_index;
 	if (bl->flags & IOBL_KERNEL_MANAGED)
 		sel.kaddr = (void *)(uintptr_t)READ_ONCE(buf->addr);
 	else
@@ -229,10 +230,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
-		if (bl->flags & IOBL_BUF_RING)
+		if (bl->flags & IOBL_BUF_RING) {
 			sel = io_ring_buffer_select(req, len, bl, issue_flags);
-		else
+		} else {
 			sel.addr = io_provided_buffer_select(req, len, bl);
+			sel.buf_id = req->buf_index;
+		}
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
 	return sel;
-- 
2.47.3


