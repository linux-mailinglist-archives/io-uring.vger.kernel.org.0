Return-Path: <io-uring+bounces-9722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E4DB524EE
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 02:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810E85821DE
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 00:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D231FB1;
	Thu, 11 Sep 2025 00:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z/bdisur"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F6D17555
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 00:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757549642; cv=none; b=PrwiypA0vXmWiM7k1BiCykftzTj3v9PKOsEjAnzWHytwVOdzTUOQDnV9BQKTqgZxnxjqvB6I0D05nmNL5Y5JuO3P7sIEi21mQmqxagoQMj7NeWjHHoF01wBj8E5Y8aeLLMU3WhxXlsIe6uUm/GetYNLGUYOaCyieSVkij5TmoOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757549642; c=relaxed/simple;
	bh=IA3HAdn+Ef0LEnjrWZmYeiN5A6gbIzUYiWaTQC7zTNU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=AlitWPtI8/x3y15bkOUgzpRNAr4p3hr1OMFNrdzTxudNoYQQrKCW2MEj8DFtM+8tGnvel2a67i+9FlQoxPlPLIu490RKNUx9b7AjsxOLqXmnn9nQxHRmmNgoeC9S/f6uSrVON8ZtCz0qHzEaVtXK+CO9cPbGevCNKwrjKhA6tSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z/bdisur; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-411498d92deso2093695ab.1
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 17:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757549638; x=1758154438; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyH3c8x1wH+glzanZ8imHfolHmW6Brc7SEtEw4Oh9as=;
        b=Z/bdisurlGe1Y71+WzqX04ZtRKtU+MhIrZvQFcvyxGMmORiDglOeO4BPprV6Zoeqkz
         3O+YBIdt0nUOgebkLLBMZdebQY1587aw9FyWweYnlLMpb5LKFdN9yv6NVw+fp6liEpM2
         z2eFcLs76bznNI8RN5hW+of9kewCEfPkdv+cgqMVb1GiTTCRO1QuaGCXRQWhNg7xnKIs
         cRG+YKymtnpGwxDI28QCVcuWSfWyFYkGx0tK8jsZ4sVXdiDzdcuZn5u1u4Kxlgcz9/TP
         HqGe2EXcSDBa/nWZJrgoglhQWRc/vNcuBLjWCmucewddJi4/MFACj10+q3LC4Czxnpow
         fASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757549638; x=1758154438;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yyH3c8x1wH+glzanZ8imHfolHmW6Brc7SEtEw4Oh9as=;
        b=Yp5zpywKxskY7MWDcyOaQRAR5LOsZg5OD8YYPSYfjPz8rN/ADexlcNp+iqOWXkYqsz
         SaiI4fbB20xWssj5vI7akOniyog/9KGwfzw5FrK5GZxWL6A3YIhRweAjd7SZ8QXtkBXz
         KC+pdYzWsWtdhzXz6AUozxLHwKcMcXkWipZkxYtCmGBfpBFSL4rju+CCqEHztYBd0Gsy
         8eauZVH60YRID7qYssLkK2rn4Te2UAM9swa55zbMOd1WQzR/Vnj87vrxaxqOQZHxG4co
         XchT/1cal7xluFKaBG9cFNFbdDUJW0I/qvs7RkzzG2skXzadz7SOifE2CMlPChL2gwg2
         PzYQ==
X-Gm-Message-State: AOJu0YzY2OrPG8nwhyA+nsKo9Jh5ca2BtqanleFOjvusyoxL4hq6zPGD
	86ZWeCG9i/yGFSIj7i+ial+QbrUOOBFHhF8M1zH326WRv3S83cZISeZHqTevMzdwqYyygdnx1Vz
	OMuPa
X-Gm-Gg: ASbGncuXo3TL1/XazK3nGhIuhAG49Zi9lsoDH/lqoMVHSpL5HGVx/toahZ+CadoZkH5
	wk4mhQIuyJ293fKxbt4VlOBFclvtdRDtDtMgW/sy7gpqGV8TmuGQdxfX6hvWXTfYLuzg/OBc562
	tvuOt87xqur4bUmtQc3uuDKIRpZ9PH3kJl/QURgGUxUf8hVs4z+DNQqwQ2ZlXjsQACt3avd+sRr
	6lb2iIyT8Jkv/tLy7PJziwl7a3qpBZUkgBiTVlnsDJTE4tkYfDUelHjQi+XCIovHUdIwK/6i0EY
	h2bmugSd48midlM+tFtxKGqZuZAmPXQptviz/82zprMpvm9T486vWmo+KfO1ltxf
X-Google-Smtp-Source: AGHT+IH4jMDSjdcV7vfDfmz0WqOqZ2iHu5YhTr63pgs9TKa/FUWUFvpPQPNwAUScLcZs48e2bnRg2Q==
X-Received: by 2002:a05:6e02:18ca:b0:3f6:6c03:18bc with SMTP id e9e14a558f8ab-3fd8e98d085mr274804555ab.9.1757549637626;
        Wed, 10 Sep 2025 17:13:57 -0700 (PDT)
Received: from [172.19.0.90] ([99.196.129.100])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-41c952de21esm3637885ab.26.2025.09.10.17.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 17:13:57 -0700 (PDT)
Message-ID: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
Date: Wed, 10 Sep 2025 18:13:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/query: check for loops in in_query()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_query() loops over query items that the application or liburing
passes in. But it has no checking for a max number of items, or if a
loop could be present. If someone were to do:

        struct io_uring_query_hdr hdr1, hdr2, hdr3;

        hdr3.next_entry = &hdr1;
        hdr2.next_entry = &hdr3;
        hdr1.next_entry = &hdr2;

        io_uring_register(fd, IORING_REGISTER_QUERY, &hdr1, 0);

then it'll happily loop forever and process hdr1 -> hdr2 -> hdr3 and
then loop back to hdr1.

Add a max cap for these kinds of cases, which is arbitrarily set to
1024 as well. Since there's now a cap, it seems that it would be saner
to have this interface return the number of items processed. Eg 0..N
for success, and < 0 for an error. Then if someone does need to query
more than the supported number of items, they can do so iteratively.

Fixes: c265ae75f900 ("io_uring: introduce io_uring querying")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This would obviously need liburing changes too, but not a big deal
since a) the changes aren't in liburing yet, and b) this is still
unreleased code.

diff --git a/io_uring/query.c b/io_uring/query.c
index 9eed0f371956..99402e8e0a4a 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -70,11 +70,14 @@ static int io_handle_query_entry(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+/*
+ * Returns number of items processed, or < 0 in case of error.
+ */
 int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	char entry_buffer[IO_MAX_QUERY_SIZE];
 	void __user *uhdr = arg;
-	int ret;
+	int ret, nr = 0;
 
 	memset(entry_buffer, 0, sizeof(entry_buffer));
 
@@ -86,8 +89,11 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 
 		ret = io_handle_query_entry(ctx, entry_buffer, uhdr, &next_hdr);
 		if (ret)
-			return ret;
+			break;
 		uhdr = u64_to_user_ptr(next_hdr);
+		/* Have some limit to avoid a potential loop */
+		if (++nr >= 1024)
+			break;
 	}
-	return 0;
+	return nr ?: ret;
 }

-- 
Jens Axboe


