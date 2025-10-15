Return-Path: <io-uring+bounces-10022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DB1BE0831
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 21:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 569853AE392
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 19:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C5F30C341;
	Wed, 15 Oct 2025 19:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QxeJ1mJl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A720221FBD
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760557452; cv=none; b=M7CueqbsKglWj/qAiCACdLu4xYkXmAk2WOB1g8P0HSr1M+dTb6Rgvma0bsSTij4QUgd6DOS+Z60ChD+i9CuUThBW461/iJfnR288MXIJJiICLZEGWzqmpliYoOLUaDRi00gS9UHOFpO5AwKsT/fl4m/c0u4Eq0S5BWWO3LGiD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760557452; c=relaxed/simple;
	bh=wjNue8Qr+w2WVc/mnfeoOAU2ur/Q7z5ODzJw8uE36Ps=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=OonhQgK/EQ7oVJPZx/nMtJyu/llBxoQyVvYLis5ueNU9wu7IrqXtg+gJvWLawxQldVD4Z7EHUucFHhugnjQcOOL+BTX3SJSpVw5mvtWyElKZSHe0Mm/Ky1RN6+g5dqldg2gy/o0iqCnsRfiSGlbUNSk+NBI/UlqtRiVvAR6al0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QxeJ1mJl; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-92aee734485so254171339f.1
        for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 12:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760557447; x=1761162247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLwC6MPYnpkrf4ZaGxgZ773TPGvWmRhstTuVSLic0Go=;
        b=QxeJ1mJl5Q4ejPA4hOeJWLmMkJzlkhEEruaMww+zdACyl/MpCK9sjXO5j6rwJwKWVf
         facyXnIkLFTDdTKloNqAAvL7WfyJBpWhRMCPvMtTzn4dsbTVbUI04/ou+qs5FPXkmWGP
         OMiy0y9cL+37y8itlhvhvBV/SdPdpsZn2JRsM1pNpMHAE4BjETfcMWnV8tKbhTperuUb
         axdruJnMkJNUAKSDkU7BxqYTsrzLCcAybd2WzLGvBohAkq1sVqI2WahbwyW/tETTvDLc
         eRzV+cC5lDcFWZMezacq2TeI8w1nZgyt/2DqV+s1RFAsromACgSJQ5qCSfWobHcEIyMz
         qDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760557447; x=1761162247;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dLwC6MPYnpkrf4ZaGxgZ773TPGvWmRhstTuVSLic0Go=;
        b=BHYhjyB5SP0KtN4nHn/72X0Hjv29lyFLqGOi2tcxzNBLJZFq4iAEQThjU1/DaNjMht
         VVI9I1gtQi6kOlro9bJwtVyhd6zU6GZdG+Hqxs8DD5PcNGT+DgeidSAWZSGJHu9PuSgu
         QhQIacR3wMCcAoySNWKmfniCrny82+AWfFeFLU635fRH1fFDHwboLKmVUzRlE8U6ZisM
         c8gpcAttDbcktzM3ZGk7EkM6mt96FqwEf7eRCXdIwS2cXlJLabnvAmlyTZzBJ777Zo8H
         u+lgQmGP84SOgXAUux5CqH57Z3a5jdYV2d2OGOSPGiMoIkOoHxxxSVfAsPtg+HKFXgSs
         4jWw==
X-Gm-Message-State: AOJu0Yxd2Af9suB6P5HiMaDOivl+Pq2ArHlsaPXPZ3IMjHGKm8zERJry
	FJMxAixWSExhjKwRSbqBvPzpZhrnyK0fC39U7ZMJKCOpO0lGN1kSvuWuLQ1NJ1dHoe1tr9ihnRj
	VxIrggU4=
X-Gm-Gg: ASbGncsJjBhLznjLhHgGMcGB0C2MuNkWtNIlalRDLJpj5vNM5FJFQ3l0Wdmbvrh7vpY
	KCnivugunvQ+HnXhIpuMxtz8CTs1CZeW3TuQgi8EucWMYesI6h6KlkgfiHot2SM6Ism9laO1/NX
	Zofa16f4ZrAIS0/7dXYh+H9j8Wo6t09sH7G9DQVzY5ZR5tEYI007rZ7wBjVp/zh9dBQCJmAF/Zt
	5Q54U1Vh4BZrvnCaeqjhBKk5HqpHIUOhbIUn7YkrB7ZsmHqR7FDLmpsJSbjeYIXN+vMXHKFmw4z
	wFBKkImP84wIiRG9dWfN36cWdKBJcB2OLUZLumXVr0QGMHP8MtnqVq/wLfo0smxgqtGuop6W83v
	u+eXFIElKALY5dwGioRWXIM/XnSJQ0H5KGTJDxGFk2J5FLxY5tMHX3GqqF8SN0sarvPeM01HqTy
	BzmLk/3SU=
X-Google-Smtp-Source: AGHT+IH+5e+i8IB4fTYrXotsvKFdmdO9umTVXDcFSUpLElu0Fwp/EzRywFaLIuufxt9FyZW0z0p9WQ==
X-Received: by 2002:a05:6e02:156b:b0:42d:84b3:ac43 with SMTP id e9e14a558f8ab-42f873627a8mr334074985ab.2.1760557447389;
        Wed, 15 Oct 2025 12:44:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6c49b129sm5998402173.11.2025.10.15.12.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 12:44:06 -0700 (PDT)
Message-ID: <b8891d74-400c-45b2-802b-b282bd8549c6@kernel.dk>
Date: Wed, 15 Oct 2025 13:44:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: check for NULL io_br_sel when putting a buffer
Cc: David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Both the read and write side use kiocb_done() to finish a request, and
kiocb_done() will call io_put_kbuf() in case a provided buffer was used
for the request. Provided buffers are not supported for writes, hence
NULL is being passed in. This normally works fine, as io_put_kbuf()
won't actually use the value unless REQ_F_BUFFER_RING or
REQ_F_BUFFER_SELECTED is set in the request flags. But depending on
compiler (or whether or not CONFIG_CC_OPTIMIZE_FOR_SIZE is set), that
may be done even though the value is never used. This will then cause a
NULL pointer dereference.

Make it a bit more obvious and check for a NULL io_br_sel, and don't
even bother calling io_put_kbuf() for that case.

Fixes: 5fda51255439 ("io_uring/kbuf: switch to storing struct io_buffer_list locally")
Reported-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index a0f9d2021e3f..5b2241a5813c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -655,13 +655,17 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
+		u32 cflags = 0;
+
 		__io_complete_rw_common(req, ret);
 		/*
 		 * Safe to call io_end from here as we're inline
 		 * from the submission path.
 		 */
 		io_req_io_end(req);
-		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, sel->buf_list));
+		if (sel)
+			cflags = io_put_kbuf(req, ret, sel->buf_list);
+		io_req_set_res(req, final_ret, cflags);
 		io_req_rw_cleanup(req, issue_flags);
 		return IOU_COMPLETE;
 	} else {

-- 
Jens Axboe


