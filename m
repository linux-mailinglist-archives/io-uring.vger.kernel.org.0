Return-Path: <io-uring+bounces-6868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9F9A4A6C3
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 00:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA6E3167E12
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 23:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963661DF99D;
	Fri, 28 Feb 2025 23:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Bb3+dpIj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C001DF965
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 23:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740787170; cv=none; b=AuTU/JMMz1bg1uZu+2ts8Q+fQwONd8aZC197SDgKRKT3TLTyU4Ay+/pUXPv+RLgx5kL6HjKuFmwq65JD/mLgJ3qoNhPQx7sU+5HxUPR0uhZpsYiFxvUug35WvJlscZStBrDR3RrC+TOyBSPW79ym/28Cdkm3uys54f7HwVXC2fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740787170; c=relaxed/simple;
	bh=/ShPFdmtDi5zFWZPDuX4uvqo7DJ/+xJn2xPk55ZuQbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+O5zXtYFk4NnPRzzVtZW+lJvYhYk0o8Cu8ti6mbFcd0uRdmnhg6sGL2D9dSWjAhCis4flo4lZHvLJYqL58XWJi05nv4pFVblBpQK7TRzcTDvFo2jqpN3w5yyIHZ8m/Ug7G5q7DfycLk+ZBCEPas6jqkt9giLtpld4K+BVUK9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Bb3+dpIj; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2234a03cfa4so6273645ad.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 15:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740787168; x=1741391968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG/WzviAKa26P9kIv9dajWRH9oVJW/MjIO0ud3obPZI=;
        b=Bb3+dpIjNzolqpvPRpJTdPDkx/FQNie4AbcF1y+slnYdzPXF0sf5PxMSCmr3d7DZm0
         385BqwwE9IUtlAbGNOtcIeBXlc7mK1uc1EfkMKZLRmLQAR7nkfvkc+/gUavjRyW3LUin
         PDBz67WofuHZTS3nCWHwLXdAo+6/1IHSstmluuwcaBfXZKe7fQsWuU1ZYe6vs8Uo054d
         Kzua77Z+HwN7rNSgzy0Oeau1YH601ptEpvshJpoBs/VuzlTUgWTmE0IFtDOwcpCyoWrB
         U+lrIMFch4Zb5jnuAUEqFwJwO7yKN05RV6Wbc7BAtAYC703T1eP83TYjMOAIYlRqX2/i
         yD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740787168; x=1741391968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG/WzviAKa26P9kIv9dajWRH9oVJW/MjIO0ud3obPZI=;
        b=MV/x1bt48WjD2pMwuLkoijlWdrTV71LtwMPHzO9U8GEvBt8yWuL5eyej7AELESlxHE
         BzSXmKU4EcjhNr/aSVn1g1sPAa12Ekz9HSqJNnN80vAzZ9J3PBvNRPnopRWrLwaForgn
         3Apvq4eGiHt027hsvPwaMJ1u19g7NJhst8NV4dnybdU80/BH4/l6otdpsnap1sewfjRR
         g/rg5VYKAAosNJmxfkMPjZISHKNEdbaJooo72G3A3pVOaZP/8GqDY78tJTM5apQtDHXr
         1mbA6KxEHrOp4GWN2Y1Y/R4Jf8ELthO2bB/cdL4lYsiPOLrgKawkc7nxAzsxIZOXM9e7
         44Og==
X-Forwarded-Encrypted: i=1; AJvYcCUjyr81or8VOQ90xa0VHTsJNgekZSiKAZEBq4wYIiPLpU9ReoqJnCQMYaBsBWmYBb7Auvz1tFaQVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLo8uzGE0HivudVsQ+DLn4QLPYOmx2cFTA/GsVoum6+sLFED/N
	duF9KpMqVvM8drOI1dRXJzk/O9yjXNzEiMkjsDasOmsVlc93ShGUftHVti8d16PL9BBXC+9RWLb
	+zC0Jtsetodl8nN7x5ZAliOMdvhZ8KsaXP09uzKdngUhGJzdd
X-Gm-Gg: ASbGncvr4+Ix9Kc4Loq1uamxLwTpZAzMFPXlaMI8i75WV3k5SOepm0JvSls+X/5lxkd
	oc08MXFXDpi/n+NRt6cvFtLx5RnaXcH1RXmZqe7I5mvqf2AjU8qSHJfQ1jTbfPLkduJJEAN+M4i
	iAQKMuBd+tNiyO3DsEAlAUSD+RMyKnuqhKXb11eaTnscW5TQD1e9105m10L2Ulmc/S1t7XVAeu/
	C/p2pmAUCSwPac4A9gX4YdEOwE3FCiJGhgQoHWDpWQd+BpAo6ML1CHNqYpqwnvTDp1ZCzNgKtpn
	2L2wLr0MnhfTflXc5ZytxArNBJw/fZr26Q==
X-Google-Smtp-Source: AGHT+IFHsPC6/EgweKrZsOqRp/ximYusBvGZYTTJpG1c/+bUJfy0qECQNUKeO9TX9U6nuPa28QKEjcpBKwxD
X-Received: by 2002:a17:902:d541:b0:223:5525:622f with SMTP id d9443c01a7336-22368f6c10amr31026015ad.1.1740787167809;
        Fri, 28 Feb 2025 15:59:27 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-223501f9de3sm2367515ad.32.2025.02.28.15.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 15:59:27 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 0807434028F;
	Fri, 28 Feb 2025 16:59:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 008E0E41AF2; Fri, 28 Feb 2025 16:59:26 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring/rsrc: skip NULL file/buffer checks in io_free_rsrc_node()
Date: Fri, 28 Feb 2025 16:59:14 -0700
Message-ID: <20250228235916.670437-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250228235916.670437-1-csander@purestorage.com>
References: <20250228235916.670437-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_rsrc_node's of type IORING_RSRC_FILE always have a file attached
immediately after they are allocated. IORING_RSRC_BUFFER nodes won't be
returned from io_sqe_buffer_register()/io_buffer_register_bvec() until
they have a io_mapped_ubuf attached.

So remove the checks for a NULL file/buffer in io_free_rsrc_node().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 95def9e5f3a7..c8b79ebcff68 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -498,16 +498,14 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 	if (node->tag)
 		io_post_aux_cqe(ctx, node->tag, 0, 0);
 
 	switch (node->type) {
 	case IORING_RSRC_FILE:
-		if (io_slot_file(node))
-			fput(io_slot_file(node));
+		fput(io_slot_file(node));
 		break;
 	case IORING_RSRC_BUFFER:
-		if (node->buf)
-			io_buffer_unmap(ctx, node->buf);
+		io_buffer_unmap(ctx, node->buf);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
 	}
-- 
2.45.2


