Return-Path: <io-uring+bounces-7297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8D3A752D4
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55A217A6323
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C170D1F4167;
	Fri, 28 Mar 2025 23:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrQBL2Pz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D86484E1C
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203474; cv=none; b=tyJ/oD09u8FYGUIv8PGiVfipCsU60ufO2wZtA97zzqowh1Hh87XYm4HvKOi2J33rpXTOC/7gKuAv7r50W+RYM/asNo4Q1KaxJzXTDJVc29TF7N2BrNgQtIzSXzR5WRHW1ct6+lpzzk8YS008xD3ZS/v3nek5HsrdOG+YaQzxcaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203474; c=relaxed/simple;
	bh=6A391A2zVYhu14feL8eJ9B3PBE1N8dQf3MgJyL5MPBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq8L8t+iPIb1ntj1Q2FCwXCiMkpWFJxyFTQTnnLxwGWtxWR/mC3MqToSaz9iBATJNWB7vYMRhq7FT3t/QO65DT5VRPpkbm+BjQnUI7sAeTw1x0GUhy1sg1hWAQNNq5vgSiE/23ctJTvoQ6mwetfjokxTns0Alcy9Pl7k2CLm92o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrQBL2Pz; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac339f53df9so478887766b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203471; x=1743808271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ggMPyMt4mfMAXmAoFhBhwwVIiBMXB9TD7sYvt2+c8k=;
        b=jrQBL2PzNT8zpD4b5DBz2f9/gOSF401vnl8uOxXvKQjmx2f7taBCakSS/26Da59/LW
         QxgUNr9HDtwztIkPf+i/B8uln+FxxctA1Pa/T8m86QEkfgTs7RRZ8hPw5JeGTU1ZTtLe
         u4hziziihrt1Tpv9uQ8M4oYLLdY3VYLWuZh2Ye7dnE7Jlyj1fm1ecyqLmlRnMg4+JERW
         27VLMQMw8RLWpKBjYInX6psDWm1CtPTv7BIWadvR6p2oHeCje3jZ+JdJisIMimJJp5HW
         iXlAd1orvkh6V+EfgiXoBAXr8NB/fXWMzJGWgOfQwx8+6QJLkDAUprMz3/XLry4+ttGW
         sfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203471; x=1743808271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ggMPyMt4mfMAXmAoFhBhwwVIiBMXB9TD7sYvt2+c8k=;
        b=Y98lPWIMg4u555lS51SoOtsW6ft3+iCMx4lWdfqihtfE2lQTn+YC2ahzFWn3WCHeqP
         KFNIZ+Dc241bzIcopqpyn9h5zwHD4rdIEhzRXbj+eawvRG9zgkmwMAvgAML0uA7ieYor
         ODrd+L2lzSkZ7cTIiJup7zUcIfkxcfEbf3QfstPXEkgbF0jkN9u/tHIKVKh/RjMqN42b
         GP82A5rML50GklkOhjd/dE+cgiQh3w7/JXGsLvH8x1V8fBJBsNzHTOvnn5kiobEq5pC+
         6kDRUnJRdVKogFjRDsgfumxO/C9YyTlEVtHwuUheB0t+3FEUR6NLXH5Kv2G6b/Mdgej8
         xsdg==
X-Gm-Message-State: AOJu0YzsdnmXI5nMwAuzghj7/MRdsEs4CP6jexbBjbPVpL/32szqP7R0
	7O1NvZ/lIxGnJiYQNgwuoTsUunHtjv7hqrnMs7nCs0OP3N/lgkI4drmBJg==
X-Gm-Gg: ASbGnctA/HQAXQ0WzUmTWpp/QYqNgTc9JPSJyz+phYO95Pk0Fq/RnZcZ1vLVAfmMUcZ
	MRWXW956T3flW8m1I4znJndu1xTSqD6b9Nds7WKQyWc4VJFYMuu324OmALhEcZ9xlIIcVjmpdFm
	v3T7q19WwA9gQZ9+yf+SqcjgAHmQI4GsjiYdYgaYTib1FYhTPjd/YjiuGmH9q341wCFWNUyG49L
	clXB7wNTz5e7w0sem2+WFlCNtoSsAnJ6eZu/jyOW2WUQtpFfxU8Tny86g6hwWiQV4DkLabwi4iN
	LeChwCCwq5MoN0EJLTPKL+lkHsCK8JdDtGEqzWn1yZiRfQEjx/KKg80WRSM58w6lLGuIUA==
X-Google-Smtp-Source: AGHT+IHUcRWHvb55lloPkoOK1+UV/ptwkqtuzfEQfSGkjLdV7bUa8oDb1RjdWDO05VDRx4pnr/8Xow==
X-Received: by 2002:a17:906:7955:b0:ac3:b372:6d10 with SMTP id a640c23a62f3a-ac738975daamr103952466b.4.1743203470903;
        Fri, 28 Mar 2025 16:11:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71966df80sm222838166b.125.2025.03.28.16.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:11:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring/msg: initialise msg request opcode
Date: Fri, 28 Mar 2025 23:11:50 +0000
Message-ID: <9afe650fcb348414a4529d89f52eb8969ba06efd.1743190078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743190078.git.asml.silence@gmail.com>
References: <cover.1743190078.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's risky to have msg request opcode set to garbage, so at least
initialise it to nop. Later we might want to add a user inaccessible
opcode for such cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index bea5a96587b7..6c51b942d020 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -93,6 +93,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
+	req->opcode = IORING_OP_NOP;
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
-- 
2.48.1


