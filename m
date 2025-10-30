Return-Path: <io-uring+bounces-10301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1987FC22AA0
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15D7B40765C
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163792FD7B2;
	Thu, 30 Oct 2025 23:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o5+H7qfZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161E33B6E4
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761865844; cv=none; b=fd7pUYFvCowXDIIuarF5G9PxUANEWqW5M55SOxxxnDiDRUuLz8BNGw4s6RMjT1YEn7E2mF0zhmfMSvG3DGOUGIalhY/tZTca9tUH43nCDS5iRSutSa6FNd1Gaj5XkZ7SlBbrJxRUxvsikPVn/DytbaT6iEj/+noj4jSsSMkXfd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761865844; c=relaxed/simple;
	bh=B+rKBAF6vHS7S1uy1glEkrp5R1lzJmRK90rXQjcUVaM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Z9sAIi4A+/1NA+7Z29/7R2zP8MFDgVmMYiakfYAAI6K2owoeE1W/2v79pVtTQcYHigNhZ3yDO5ybRMyv9Qesnz1+gLn/4wpqAXCYErFczy3AAhbs8rq/FxekmUjym0ZzIUJKOEBdKyP6I0M/XDeNqZS2wiaVC4qFl590k0eUfXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o5+H7qfZ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-940d327df21so65675739f.1
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761865841; x=1762470641; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pb+h4CiTAtJtxOvHVm9+cgdoVXICW9Lw+7/p1l9SXBM=;
        b=o5+H7qfZ7wcliaKoknrWHv9SX2MO2bMjXFUby5SPFpZhO2dPonz8/IjmYZGlckjLxm
         9tvDtmCTqZ85EZLf/JL6x+qmEKQDYkv1AC0WgGC4JvTIHnU+b1epgMpGGp6MYyoY8ZGn
         hnu3u85M0mGScoKL8Z9l33cFs0zRBn1jkinkoG8JfK0HPMnIqn4J11AGQs6k2a03KLfa
         X/uo1mywLyKS9HHT1Ui6rRMWaRDNb6zdWbK1HBOhMeTpMDteqzk6aoZw7em15CsbPXty
         JwjkVZ1d9mrG38VrqCClJNvPfVVM7+ib9k44baJsFIHKMK7grOhFekgdxOyTnaOnHS2K
         467w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761865841; x=1762470641;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pb+h4CiTAtJtxOvHVm9+cgdoVXICW9Lw+7/p1l9SXBM=;
        b=fGLSz5SZYi1gLV9G2F8AgxONOhJOQFau+g+qql1a7od7/+1znz/THALYQdp9y9pwXa
         bXA13orjKhuHOl4sk7OpQqxZ3CBTXnWZ4w67y6wHed8AE0J4WmOcB2bO1dme5jEe7o5X
         0Is7/JNd1Kb7MAP+BrgrW14pKAPDD54HYKkiNr2H4xO3Bjjja480ONtFrdQwmEjxaBF2
         ZM9kc6O4XAoWlh80ry3xXCG0XUsPdmUus+Tfm1FC7Z0mzXhWbFykEhMhj0LucVdhmLe0
         x+L/bukFyPxfN/87Sx7imNGRbkzmTpNUZmGY2VTCC1GM2mN7pzIicUvZHuxTdzCHYQU1
         bXhw==
X-Gm-Message-State: AOJu0Yy6Dyi7+NIyTq2Yu9cWdCTMHPWe8LUpC2nkob66g3TmJp1Al0ru
	6+/66O5kPsCLMbS3jSAPRVeqUSobANv1cBHJ8a9WHlv5mfHjU+P3wWckHrhIoqFc48bmrIX7UOa
	2rt7r
X-Gm-Gg: ASbGnctDDRVftJZccAlzTG61bSAL4K3Jub+YufpJyP2X/8TDoXjUlQMkjYjtxQiDFkW
	FFcVM3CEPN2UIidaVUnMVTNXaUSHJD66pnj9UZMCVWOF2c0yrHYfEivFDt21lrneAcc98k2zMO4
	y9m8yeDji88zr9KentnspHAoRVwEBirvYIJtvcB0H+4HJean5QHQ3cUUU3E7tGce7Ww3fbxW8gy
	ZgCPXXbdR+Hu15v2msM1dvfs0rgo899yhHrgToUqwfD0eWRVux1u/4yhCY26aawOoUWypGzlNet
	drnHou8Z4K0rYfBdcIaR7dSqewOzIxD+lXKUcVZlqYWVLlVXustw98651GD08xVhYcpxQcHvgqo
	ngyIsK8LPiA2N1aaamaoknXO7q0lGgzuHd3CRuYtvyLzljptLs5Al+EowWcYIdUs034D/Kr+VgA
	==
X-Google-Smtp-Source: AGHT+IFypBfMPw7aQOVC01YNUpRB/K1rktgrnw+nq7zNxbfFDoELZ8t32pxD7N61iAWT7gPaoy+ySQ==
X-Received: by 2002:a05:6e02:1a2f:b0:42f:9399:ce93 with SMTP id e9e14a558f8ab-4330d1c9ed9mr23233145ab.20.1761865840686;
        Thu, 30 Oct 2025 16:10:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b6a34b6287sm52718173.15.2025.10.30.16.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 16:10:39 -0700 (PDT)
Message-ID: <ca540a2d-a01e-4bd8-8f22-991f5554190b@kernel.dk>
Date: Thu, 30 Oct 2025 17:10:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/fdinfo: validate opcode before checking if it's an
 128b one
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The mixed SQE support assumes that userspace always passes valid data,
that is not the case. Validate the opcode properly before indexing
the io_issue_defs[] array, and pass it through the nospec indexing
as well as it's a user valid indexing a kernel array.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Reported-by: syzbot+b883b008a0b1067d5833@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 248006424cab..ac6e7edc7027 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -5,6 +5,7 @@
 #include <linux/file.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/nospec.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -107,6 +108,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 
 		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
 		opcode = READ_ONCE(sqe->opcode);
+		if (opcode >= IORING_OP_LAST)
+			continue;
+		opcode = array_index_nospec(opcode, IORING_OP_LAST);
 		if (sq_shift) {
 			sqe128 = true;
 		} else if (io_issue_defs[opcode].is_128) {

-- 
Jens Axboe


