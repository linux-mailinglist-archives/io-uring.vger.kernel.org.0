Return-Path: <io-uring+bounces-3139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADB3975880
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A258B1C23636
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474441AE852;
	Wed, 11 Sep 2024 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kvfx9mF3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88E1AB6FE;
	Wed, 11 Sep 2024 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072467; cv=none; b=jBhluybBEa4qSX47eul7R3aXoFaktWmhhhS+YO7ZvFx64TmNCTMdRpX4agSHZsSIcQV/BAQsA0t+fOrUlH6HISh/z2cybnzOXJa7Hr6Hks8nGzLoFHHQxAy9iLHr6QuWIBxjE/UlZmRlWIowM1/op0PleJfAgTLsok4K1HlscM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072467; c=relaxed/simple;
	bh=xgZK/jw8ZlQXj8cIxR0W7ybGVnlcP1lJNS+9Q/l9a0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B51+nyUZFg+aO8px768aLfBA0no0hGKQN4XzHTeBRRdYuMXDJMe3jSeBn87HlIqjRq8QksamF4ShsdWQQapPUIJWrwNOFGGuu3p1seL1n+u9Kr2M5wuD58TXQKHenpp20FK3Qbg4afyn139swG9ZDRJSwAo2LfAdUbJ5bTrOnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kvfx9mF3; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8d4093722bso5583766b.0;
        Wed, 11 Sep 2024 09:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072463; x=1726677263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=Kvfx9mF3sJfmfjZZ+a2nYDQK9YPTkyOvQS5Z39s63fTyatNtNsuWfl43ujvpj0CSjc
         RAlFe0z7yyOOda2YRPkty7WWvMZbg3TJkHikkljF2lCqPiH4Ssyt/n+kNKvv84W8IfjL
         RCBpKHUM6QNmKCVuyh4xq/mygh02F21dG6tjB8ApQGgbliZyscTNIzVgxyo0mhBzK/Dl
         7+1fsYJ33FFYVjRlmCT8O3GuJkYPj6+aNKCTE56BLiiXUrBgHhRJQCSG6S5VKhRoTyil
         kxCy01XRGEO77B/occxn/aRZc21jk0Sc4ADETUl0BKo8HffoEVd7EREj9fPjnAnxDaAK
         UpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072463; x=1726677263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=J6hy3G7TTfzHCuebD79n8UWsS8YW5VLszbFKZNeBuwdmiRVHWbBH1yyyQxBHAJunPw
         wOeXzp4uZr7AdF0v6DkmXRWPf9FlEzMlIFDLT5r1Kv4ydujG0j2MUNW8vS825w/JlHwI
         CAtG8uiuDS8cStEkTqf2Gex/h1SjHqbQEPU7wIQqKY/0sWQ5Wxzm35z44e0TAJBzI29k
         bGbzUGsFjP4iUpWjQ+bUNU9r/u8+3FsxQvFVxjt3iYWQEvGx7Vh0aspKhmFzZmdVvsU/
         afYjBwkrBFp6vTupXQIBshMkqlADCKNlBTVQdZU+ROlT+JKyWaxDdxw64SkMmCddrpFg
         Iyew==
X-Forwarded-Encrypted: i=1; AJvYcCVAcV3pCWZ8rDYqdFR/vBgfMdW1AclsG5TYNrwUlaBxDXLMLDxZFKIR6fsMoT+4Jl32JIoCUOvlwPqvfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfEqOIsDvSb1JxU4aZTnEKV4AJqOnlUsi3Zt+I4qYvOQOpTJXA
	b6y8t9La/VhzdOKI1IHZyveXYFqXj4oYZW3nRJaFmNQuyXYOubQno6ZFedPO
X-Google-Smtp-Source: AGHT+IELcXHRTUSdLyLG5jnLYvW4/fqCNo1EAgwvWA0FaGjFDUj4/njuzwhpx/wmLaysANwmyDI4Hw==
X-Received: by 2002:a17:907:2da3:b0:a7d:9f92:9107 with SMTP id a640c23a62f3a-a9029690793mr5422666b.58.1726072463487;
        Wed, 11 Sep 2024 09:34:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 2/8] io_uring/cmd: give inline space in request to cmds
Date: Wed, 11 Sep 2024 17:34:38 +0100
Message-ID: <7ca779a61ee5e166e535d70df9c7f07b15d8a0ce.1726072086.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1726072086.git.asml.silence@gmail.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
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


