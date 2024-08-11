Return-Path: <io-uring+bounces-2690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2DA94DF78
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 03:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28794281A07
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 01:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414A4848D;
	Sun, 11 Aug 2024 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bcxoVWJ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6495258
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 01:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723340048; cv=none; b=XeBiPZtatYlvDlWvC2soBlScPwJjoWQj5s1q7uM2kRjBvLfbhNhbENoIEuCYA1fYeAbkt0GEFTJ13qMfQPHJP5A7tJ7pQj7cub8mtEAnCGJwHignsdAIPcSmS3z2DS8+sRmvwsyNOPV6AJhQtV6yejRwp5jag2aK1ttMd1YBnUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723340048; c=relaxed/simple;
	bh=Bt6xWmVu39ZCeTvjnurPU6irJ0gf6M1OOEkCiY7LqCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBw3LdYw9UlFj6egLPZhpsvQ9Ka2zTKKVw8y7MuGbxrZxogowdaeajePKNYexNErGx1A1zq8JKDnoOOWbqD2Qusr2nVmW/ESTMo8Yw1sDmeBcefI41LlU+enTvLbdibGYNpkttUKEho2Dr2D+xt6SeviFazZL9H2hlPskkCGtbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bcxoVWJ2; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7b5aacae4f0so528256a12.2
        for <io-uring@vger.kernel.org>; Sat, 10 Aug 2024 18:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723340045; x=1723944845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XDGJjNq0hyZ+jl9rhhjpJ3oKZktbmgJwY8CyKY4eBM=;
        b=bcxoVWJ2HcTiq837AWA37HgRuG+eG6yep0VnswYSLqkwjAmvgB9EekjyZ9YvXUYyLe
         nr/V/poMZ7pCBRroYTecwgliglHEYEu/Lhut6peRb1ta99x1/97CuiTkyH9Z6xEVXQ++
         GTpe4Mnns+YYLJqp3KKJ/c6gBHSAcUcQx7yc+ds8f6nKVX51OlhdaG6RPc6JNUwJV4GG
         4keqZTZTqTz00fJklJBZGzjllk/3Qs7wRv4Dz9FEEXxwJNhlzB3Z6XDByzAnAFzB3PlR
         LHgLDrEAd1yiOWIpIwaDu4uLN5agZYUj5Ofd1LuDaNGe7R2jo06Bjq5lu45d2/+gqWk9
         irKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723340045; x=1723944845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9XDGJjNq0hyZ+jl9rhhjpJ3oKZktbmgJwY8CyKY4eBM=;
        b=UTGzb39wNZjvD+AqE1Kpd5HILTBzyzO8cmk0iCUyf37KWkjg7KZLEu8FvNyYJFYXOn
         6oLZsrbAM65BaKle/fgiORQ1Br4dluDfFT9VzPOiFahPTeOKsKso8zG9zzzvlvHZROrZ
         yFHPBvpaOxbF1KmPn5RfLeSkoCEb0Sa1EZkF/XV6U0CjIbrGAfWrzWv0PCm6VWC10gYk
         re8WtMzNKZsmnF7whtMYo9V73FYRX1JVvFOyT9fpciwNhn4yuuPPjpMuP59/JZx1xNPT
         t8CRdSe79gtaXMn3E4pKsqnrm4YJaNNWsPvXt4YII4ZJwIxOdAE31u5jRVmUyagtKXSk
         cuwA==
X-Gm-Message-State: AOJu0YysSfxLmpaeGhMwP88VGGfym1DAC/Eg5GSWg/RPikPvQpdKcYiC
	zqq6gczl8IxwF1W5NSKT4qPTBD8jsuOtXNN1CwpqJSQPlRD/iXo53UCfJ3lLf8VkZ2bNTBGx5zK
	8
X-Google-Smtp-Source: AGHT+IG94BjhywnVa1nziFBwZArbQ2u+JqDXE7Vl88GCa5Sp/+4MM0jPdK08aw013sd3YjPHP4VPMQ==
X-Received: by 2002:a05:6a20:8407:b0:1c6:ecf5:4418 with SMTP id adf61e73a8af0-1c89feeae76mr5010394637.4.1723340045040;
        Sat, 10 Aug 2024 18:34:05 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c3dbea4389sm1852477a12.84.2024.08.10.18.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 18:34:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: use ITER_UBUF for single segment send maps
Date: Sat, 10 Aug 2024 19:32:59 -0600
Message-ID: <20240811013359.7112-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240811013359.7112-1-axboe@kernel.dk>
References: <20240811013359.7112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just like what is being done on the recv side, if we only map a single
segment, then use ITER_UBUF for mapping it. That's more efficient than
using an ITER_IOVEC.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 594490a1389b..668e2fda95cc 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -617,13 +617,22 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 
-		sr->len = arg.out_len;
-		iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE, arg.iovs, ret,
-				arg.out_len);
 		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
 			kmsg->free_iov_nr = ret;
 			kmsg->free_iov = arg.iovs;
 		}
+		sr->len = arg.out_len;
+
+		if (ret == 1) {
+			sr->buf = arg.iovs[0].iov_base;
+			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+						&kmsg->msg.msg_iter);
+			if (unlikely(ret))
+				return ret;
+		} else {
+			iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE,
+					arg.iovs, ret, arg.out_len);
+		}
 	}
 
 	/*
-- 
2.43.0


