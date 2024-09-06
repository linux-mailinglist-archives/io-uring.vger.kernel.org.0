Return-Path: <io-uring+bounces-3076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B2796FE30
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4C0D287BA0
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0ABD15B12A;
	Fri,  6 Sep 2024 22:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZnYdF5d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A61B15B0F2;
	Fri,  6 Sep 2024 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663421; cv=none; b=lRMs5w/dr8aD0RxadU6Nt7AFgvrM7WCebWzmuLEgMF+/3ysKPnyn6Ly3NKeG7yLT42ANubMc3V7N7gI29bTwnnG+JuM86dtKdaMgWiWxfLw3Y0PjLiAahFoUP6IQQz001L5eCpQwJjQ3vsyY6zGj4pbawtLdjJL2dd85o6rbIXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663421; c=relaxed/simple;
	bh=xgZK/jw8ZlQXj8cIxR0W7ybGVnlcP1lJNS+9Q/l9a0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsJDqgB9nUXxpXTWynxhKmUA6tv/8A5wepdf4eEFUQ+J6wU/BMVbTLooqa+BuW7SpG5IcoWtsNdeWZjS9u1V70QJlLGT3mzv3qGrtTNNjc6uCvrWNN+jp+ggknD/0kjXDoDt/kNY+FeOR17hscpEydEn1GdbN/IGCPiKNdaIqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eZnYdF5d; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f4f2868621so28672331fa.0;
        Fri, 06 Sep 2024 15:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663418; x=1726268218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=eZnYdF5ddEmpuMKLoK+QH0VpgqshABqPTCaD5pt9rBQxBCd7QqekXcXHY4dAeS5FhT
         b18YnkUQvzZwPO+uvzVybr1ErE4z8hrSIVFZQ2AAbhehC6/D6X3QwwtsXB0bBjt+Dtr4
         Z/OtJystuUTLXRRPhocoISHQ0c2uTYb8d9sSmLqeHpRrtoGi3LKlfTwhXlucoc0Gvxo5
         dd9+9wexEKgd/WNpJQvLoMEhcvZHpylixUHpwT11iArm+VvZiHx85DexsWgm/WXyhWl1
         f72lyLbYaXx2+rR6WGCLSEpmmYd1ar1gt8FNH48PYgblK01XY+uauP+sN9dn2pLels3F
         xx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663418; x=1726268218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=qfk9PyCie5RHvHd16UHWjNWnQnbu57fVmAjLTpJ33LRMSGXPmL60mnVGpYbNGju23/
         FlYKCZ/ffCNFUOFXtyBad01MMSPn6VWIFWMnGHihcvvGBiDEkn1gygBzbG3Jq9yyeEcZ
         2BLXz/NAdMU0rF00fJqnOz7BNW0DuXHVPeBU/YHgzztWMYgaImaR8oVZoM9MpuzFSgJz
         Vq0WKqTgy/BtWMtl+lii4NvPZ+r4xBZ4bRLv1buv5wdKlMzEpMCecw8A8iFldp6Xgh4y
         DKYsL5uZhitVh6KFThjZA63jNudUA7Q+omFP0BBEfJd9aEx7+s9WRaiv41WAKPYk9EWl
         hHFA==
X-Forwarded-Encrypted: i=1; AJvYcCUNvOeE9rRWGwbz+XLjWgxxZVoNVf5BeZuv3AXYVgRkwv8UiNhovoW0eVGRMNLX6XOFwdobJ1UjqFeQHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YymCq9q05oH5u9mPCBzib+B6qWptTVPhnLE8GAjc/VLnBNhNDFd
	peHkNY9Z3p++P5wZE5pzwrQwMmdiiCgfhGTa9u9dKpR5CyXnm847oPNbOvQ4
X-Google-Smtp-Source: AGHT+IHXnXfbkaF7u3VX1p6hb15jHuT8Sz6pGMKxR+NPrjTVAbIbg44Z7wW3wwKJC6QGwAd3IjyH4Q==
X-Received: by 2002:a05:6512:e88:b0:52e:7542:f471 with SMTP id 2adb3069b0e04-536587b8ec7mr3170548e87.29.1725663416985;
        Fri, 06 Sep 2024 15:56:56 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:56:56 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 2/8] io_uring/cmd: give inline space in request to cmds
Date: Fri,  6 Sep 2024 23:57:19 +0100
Message-ID: <7ca779a61ee5e166e535d70df9c7f07b15d8a0ce.1725621577.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
References: <cover.1725621577.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some io_uring commands can use some inline space in io_kiocb. We have 32
bytes in struct io_uring_cmd, expose it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 86ceb3383e49..c189d36ad55e 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -23,6 +23,15 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 	return sqe->cmd;
 }
 
+static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
+{
+	BUILD_BUG_ON(cmd_sz > sizeof_field(struct io_uring_cmd, pdu));
+}
+#define io_uring_cmd_to_pdu(cmd, pdu_type) ( \
+	io_uring_cmd_private_sz_check(sizeof(pdu_type)), \
+	((pdu_type *)&(cmd)->pdu) \
+)
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
-- 
2.45.2


