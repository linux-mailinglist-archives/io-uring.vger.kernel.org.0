Return-Path: <io-uring+bounces-7355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 501B0A782F5
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 21:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11DB4165364
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 19:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807001E7C3A;
	Tue,  1 Apr 2025 19:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="REycNlSO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116F31DBB2E
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 19:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743537241; cv=none; b=j4h3QPwMWqCiNCwGy1Vrbl4XG7WQA9Z3OL8oC6Ne/w74PRqyY4u7/HXJPDAYtuO3rV/eqKHiy6L/DS+dwewmYg6VrUoGMShkVtH4aDc0ixJ7jeHA8CTv06ufydZCbH0XMfqGBnhOv1tXmJka7yUuCSnp6KQsYMFGLyGWye5mxRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743537241; c=relaxed/simple;
	bh=uWpJ8lEBAZs8jD8GRNtIaL0g0KH8zRUyz2UF1gEzlUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HgjOiMuWZfpdfDchFe+AIhi87hn35Bh3GeYlOKrxTMPBkO/xhzfs+iWVl/PZ8pus6kraU3/XI62/EmCSv1YdEn9S8Y4pfK4/z6Boosx6oukF21vmkpirNC0WE3WWnenfncIpAUudoSuIxdhLS7OMLeD+syyJbj9zWFPdjjs/DaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=REycNlSO; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3014ae35534so8531800a91.0
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 12:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1743537239; x=1744142039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IC3Y8+faH5qtboRihIrTlUxp7xEVtyQ/x2KioLSEVR0=;
        b=REycNlSOxcJF0mK01+rrjxaeuFahhYqPrQMKpu2tmarRS089Kgg62TEbx/MXSQA2A+
         l28ctZshpi0M8AIQ+4dEEQPHs4iFO4SlajLUzeDE6HbE92kYUaWEdC1XSj5ErjpVLOl2
         1PQ/Abwep21eirbjZcv9/vNxu89vStok01r9KghVsuZ9awB6mxffva30JO9v2IEDGhup
         KcSKoAQGVKDKa2Cjy7KjSyqRZri55YHyPDk9ry/3sh+s+B819ANtHkWnzivhFdxpGvqX
         jsexjmbN+S5GXF2/eVBsS1QkZGltXOTOzqR+RfbZv1w3yfHEuLkePAiCG3qtjwxfgvGN
         7OYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743537239; x=1744142039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IC3Y8+faH5qtboRihIrTlUxp7xEVtyQ/x2KioLSEVR0=;
        b=We7hHIMT9H+/1BFKt6suVm7Xrmmvdp2rRamuTyPnwhQ8IIEf6h85h4tOC51fW3UJUt
         WFCSiYXk/4rHUKduES4S8/Ot+Zo/UgNpcv+1n33G01VQisCl/oHxUktLe1Y+H5A9vdC4
         +UBVtmBVslC5GpQaZX0VWjCDttDm76KZmzZLm5IYAI6RHKbKB2oXgjdOS6PkODBkcgQh
         ouQDZhUkv6v9+SkdiqpnEOifgr0MsVs/xdwKgPCqmI5FtIJTm70sxPxPqNN91etfU1M6
         cLnRxhKjh4D3Mk3xARtDt4PO4SLkE+t5miThmTkSG26CCJfGGM0FcQprlRZPwLsHu+Q0
         e13g==
X-Gm-Message-State: AOJu0YzJMQuPbkBpmQ+Mw8VbZRigcxOnYcMREot3JVimR3oHTpQMhG5C
	qsxORqKt6nxY2xEnXwZc73RFq/3ZmZH688IGo/3h7pL4bQEOBSAXNs6Gi2WojTOKDcgoGQVhsnz
	+
X-Gm-Gg: ASbGncuVcssVXjGmcfUQGFb5mrujzuP8gfQy6nzoUGp01r1g1f+9hX274E/st7RWhik
	KuhK7YCOFJom3fk3zGffBDXBZacQm0xhThiToJblZvSkHvGwiiIL6Aucxc+9EWvci1x6GMUKj+4
	G74+aH4P7nGQqHANffkaMKxkHgXNJAvK/lliXSwZaMCgZN8Vm8FvXbcYnl6Amu08UBin5DLhc5L
	ymlmO7OlgGY3nW39ImfbYSupV2PsbjpcAgjSOgJ62/9OHO7HjCdJf2juV/kxzntwbixqKTC+bMh
	O1mpr/9C+7BlnNIJSOrz5j/dstePtg==
X-Google-Smtp-Source: AGHT+IGOzcCBow8dPgStmtKtQv33Wjhc+yq2KXBm92pxkd2YE6+63FVCkCYrX9FQrwFab8r++iTyMg==
X-Received: by 2002:a17:90b:2650:b0:2fa:15ab:4df5 with SMTP id 98e67ed59e1d1-3053216de3amr18715330a91.34.1743537239326;
        Tue, 01 Apr 2025 12:53:59 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039dcf48fcsm12116829a91.0.2025.04.01.12.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:53:59 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2] io_uring/zcrx: return early from io_zcrx_recv_skb if readlen is 0
Date: Tue,  1 Apr 2025 12:53:55 -0700
Message-ID: <20250401195355.1613813-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When readlen is set for a recvzc request, tcp_read_sock() will call
io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
caused by the !desc->count check happening too late. The offset + 1 !=
skb->len happens earlier and causes the while loop to continue.

Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
if len is 0 i.e. the read is done.

Changes in v2:
--------------
* Add Fixes tag
* Return 0 directly
* Add comment explaining why the !len check is needed

Fixes: 6699ec9a23f8 ("io_uring/zcrx: add a read limit to recvzc requests")
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9c95b5b6ec4e..2c8b29c745c5 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -818,6 +818,13 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int ret = 0;
 
 	len = min_t(size_t, len, desc->count);
+	/* __tcp_read_sock() always calls io_zcrx_recv_skb one last time, even
+	 * if desc->count is already 0. This is caused by the if (offset + 1 !=
+	 * skb->len) check. Return early in this case to break out of
+	 * __tcp_read_sock().
+	 */
+	if (!len)
+		return 0;
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
-- 
2.47.1


