Return-Path: <io-uring+bounces-5295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A729E8829
	for <lists+io-uring@lfdr.de>; Sun,  8 Dec 2024 22:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E56C31884CF3
	for <lists+io-uring@lfdr.de>; Sun,  8 Dec 2024 21:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5475E145B26;
	Sun,  8 Dec 2024 21:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zw4qA4D0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970651DA23
	for <io-uring@vger.kernel.org>; Sun,  8 Dec 2024 21:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733694161; cv=none; b=bwgxcD7R2jWJK22+4gbz8nKvwbwInA7jSeaEWmG40nfq9gYrO2xODvU1tQZCpRF3HeSOVmnSGWhIsbc1qnEv83XCdiljJc0qBuIkxoOrSzwcB7QT1LppCdOLRSnukJg21oxvDjKHk/B1lOchQM1QDY5a4i2LCCzEkGFP6/95UdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733694161; c=relaxed/simple;
	bh=zelIa09/AmTaYLQYAqE5vhuj3ieytpzShInYhhWU+k0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k6HNKg2Ai/RVCa90sWckhXLwAjd0Zy56X/i9dDtzoHg1DxgAqIq2Hz5omRtat0q4DzXg75p+gIW57/uN2u6jO7Hem7KwzmOtseZ1UHsnCg0ViN+09HugL4j6Ko0Bh0Crry/M7zugMrH+KEoMOaAaLkpixwVLnWw1i6a6vqN9HQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zw4qA4D0; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3862a921123so1813549f8f.3
        for <io-uring@vger.kernel.org>; Sun, 08 Dec 2024 13:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733694157; x=1734298957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7h3XoDfWWWCD2irjz1xNNCRG6JMTB21W0dA3iAtVFGw=;
        b=Zw4qA4D0rfqQQZuRCFq0+1uRvFq0Ndid6bpadQ+s+DP1Lx2V7dc7sNdwz08cBR+yni
         9WZZA90udI5WjQZsnp9JKzWxfs9+snJ0+6iC5ooEoXjmVwI1Ex36vF1i+YoYJXO/C+z5
         5Lj6Ljwf6P1U97kPjuGbY8J3noumpSAEtES6iDOfYZVlQ5dUKVYk8OFulNcVtUieX8D6
         zuRmcW3cJbrPXteSFZi6G+k9ZbSM3+SyXUbofsFgzvKsEracZ/hV9KAVI3/PwPyWVzzC
         oCdb+/4ykyUt4qEj5oPoRgnGNwOJOAjmpSPRrr+2kqFIb/NVg5j1RhR4jrlR/4vbrcu3
         6g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733694157; x=1734298957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7h3XoDfWWWCD2irjz1xNNCRG6JMTB21W0dA3iAtVFGw=;
        b=lyX9GaPwJxetOrBkxSI+C9kRTPpEdGyht6ERTG8QJmTLWnDYkToqcB3X/wHmal3QvQ
         fIZJM0C3ZCX0/qGlWPeForfVrMKSq6DDcqsTs2X5sjvIZtLFXqMMOSW0FTY1j3CLma4G
         0Khhk5OW3jIt0FZ6R1CfK4JXlKeJiOPfJHcnzjnfOFU4OURlHcuGPRjJJzwE5ZwfitVz
         dKfKarG2U/9N4ylZVbnwhSV8aNlkDU2ZYv0Nm2iZVWDoGFuTdDO3pX0mBIzfRw07bbNE
         ozDn2OUfyJfTYhEz2AjlO6ShD832f1m72FeOG22zYj9DNZ3W8sc/KUEM7C8BG2JMCwPK
         c9Bg==
X-Gm-Message-State: AOJu0YzXqbK6b7T6pOiEMRlsFR5oqv68pm/khmZP3GaQyhgOptOjKAin
	k3KIx1WH+7wA2LUHtMTeWqGFpxZjjgINoEZQwJT4h9jqvO/o2MxTepZOjQ==
X-Gm-Gg: ASbGncsedeKLoPHnfA4b/dNgob/IHKjgdxOV9juBSiBIIlRJuGeFEzW0il9tJ+vwuVE
	RPs1El8AaQcWDMVkTyTS/yQfRf2JYFXNMSgTsY68u6XkfIb4OkX7GnfN5fEkZxv++WcZDML0rvZ
	oJC3JFUABt2BS9Z7ie9Idg2XRNsMyWOnGytNeW8xwmbpwgdwdnU/LzOMTcEe9XIL5GJxwYAjLsZ
	br0PKQFBGutyHnEjL1Zh4zAE8uLpUEx/EdKbHvfgW2ATmRQX1o5c764zWV7STk=
X-Google-Smtp-Source: AGHT+IEUVImfJoveIwvcx2TQQjYuyyQNLlBcMs23kre+GMm7QZpqJczsQvBfI69BIVZzq3A7RpDwSw==
X-Received: by 2002:a5d:6d89:0:b0:385:f72a:a3b0 with SMTP id ffacd0b85a97d-3862b3ea28bmr6142160f8f.55.1733694157105;
        Sun, 08 Dec 2024 13:42:37 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-386220b07e1sm10976160f8f.102.2024.12.08.13.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2024 13:42:36 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	jannh@google.com
Subject: [PATCH v2 1/1] io_uring: prevent reg-wait speculations
Date: Sun,  8 Dec 2024 21:43:22 +0000
Message-ID: <1e3d9da7c43d619de7bcf41d1cd277ab2688c443.1733694126.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
for the waiting loop the user can specify an offset into a pre-mapped
region of memory, in which case the
[offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
argument.

As we address a kernel array using a user given index, it'd be a subject
to speculation type of exploits. Use array_index_nospec() to prevent
that. Make sure to pass not the full region size but truncate by the
maximum offset allowed considering the structure size.

Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: use array_index_nospec()

 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a32c5c19a79d..e209695c28e4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3213,6 +3213,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 		     end > ctx->cq_wait_size))
 		return ERR_PTR(-EFAULT);
 
+	offset = array_index_nospec(offset, ctx->cq_wait_size - size);
 	return ctx->cq_wait_arg + offset;
 }
 
-- 
2.47.1


