Return-Path: <io-uring+bounces-8068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E56AC01B0
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 03:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E3FB1BC1ECE
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 01:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2FA139D;
	Thu, 22 May 2025 01:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1ft3ugCm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C19645
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747877268; cv=none; b=tvIySVcU/ZKIy8/wdyHcIytzQ5aFBzhL4e5639mutWHOry+46FFCb/iYPmCXSc65zrDwPY69RySZ4u6fhNv1nCYspIeHlLb6xJ3MIB35/Ufl/Jsf4yk4PVzEHsfNB/LIOJ5jHICu1sLner7ycQMi9DKB1TwLc5c3/kBHHx1QV8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747877268; c=relaxed/simple;
	bh=D3zJD+KLL7ZHguxCl87L/poRm43WeYeQGexox7qWgLo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bdGhfGoTGlcPLV0Zt3O87VKNDpltpKqSQhD/lST8EFpVhlMtWBP769gHN+hzFEdNVheLhDUFpRLMbfzNM3zZjbiiCMSUA0KFU88sRNLVdoRJf3WMZMqD+4VeGSe0FJ2Vjv2xaVUAwqmM+Jdo+bJnGvSpUsIyl8oVeqEUUxrukBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1ft3ugCm; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso23928035ab.2
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 18:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747877260; x=1748482060; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGGDOAQmPuqJ4rr+nKt+9v211OIRpmvYUxj2AxYoOT4=;
        b=1ft3ugCmLMT7Adbu7Er683k2wfaTgZnnGMvnDLLgWIDOXiunnWRPOdIvzqQ5y/jRny
         5emVeYzvvTUFP03dddHTgmM3f6rRxaohlej/0MowgDD6UCsL8N3CoOkICBfJ1A+/UzlI
         ixJqzxlbnO4tgoWd7puQaEbg3fj6fY06t6CVCwSS/eF3itYpo1A/3n0s3qHGuvcuQNKb
         A5ef3n6rLNwhUMErMejKB5mi3NjGqGJmAubJnlgTfjwXYlZn/njTJVvLWAe/NhHLwRmg
         CiHDSNrwlswIrrIxwo4S3ZY/SUJJGT9pMz9sgtzxVP2ZydgIKvJW1mRDRXZtolFhhXIo
         jhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747877260; x=1748482060;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eGGDOAQmPuqJ4rr+nKt+9v211OIRpmvYUxj2AxYoOT4=;
        b=OCFTMyvdF7zf1vFwxH8aS30e/yHPAC47q+dDtQ+Jq60BZDstvIAhbuL3CMTuS6CQXV
         jvPPemIaZUG9d7tDzlgVQxvkixsJgX3h6taWpSfR7L089UmxzUDNGXwN2hSUc558SkUa
         Arcwozt0+94s8JD4jJjV5vbd61EaePFyr4Q7ksesMEghkWqbU/uXuAUrxH9X3ZMJYuDh
         HXOBpxRj5zJ+OfVEO2OJuczzp+IgZ9zCtpwuIJKRQ+BzM+pRKsbdQtYPOS5AN2AR5dIb
         fG8qWFyO1m55SrcHawbcR2qt8JxTSNnacJ66Y2RZBx20/BAt3bhhZ2UC8lburU0RtLHQ
         WZbg==
X-Gm-Message-State: AOJu0YwqncDemb2BYD/t+wTN9j820BoNKMQ6UV06rYP1eIzgpKpGbTFu
	3BPHoLKCpQsW/N3/IIJhU3uwsFUHDJtLmOy77t09Rx7vaiESkzCeHbq1er/51CCDMop1l6oe4MB
	PTiqC
X-Gm-Gg: ASbGncuyCh7cfWCjzpJlc2JCKyiOLniMFIPIXkH3HmkBQIhtBTILUtTPCQNuf0HDXy4
	Exi32Jg2n14ZJJ6J7bwRwWpHOxxWNTEusmIVqb42sVzDeX/fSyUMhLwfKLdFYVpRV5KJYgoS4tB
	6FBHYKFW+gZWjF/CwXI172FD0QBqiH+TKAzJYxbDFe49Hrdcdc7ZbzrUX9x1WK/CoqCvVedESMT
	WMwrWy8cWkPR9cZtfo3+2iCx0zD84Ukp9wSz7F4fl6HGBacJjK4oqB8IGporOP0IJazl4blhjkJ
	hDZi3sLEYAMQHayv/bQRGbWFqqgTiAs7l3NzMSxAppE42fA6
X-Google-Smtp-Source: AGHT+IGajj/JMy3rVV0lpPc2ftHq9C4aNY1XuuH3NMav0K2Ut0Vp9ZMGEfzIRBcR/UpyRBx4rgByng==
X-Received: by 2002:a05:6e02:1a6c:b0:3dc:8273:8c81 with SMTP id e9e14a558f8ab-3dc82738eadmr66864095ab.22.1747877260467;
        Wed, 21 May 2025 18:27:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc8590cc6csm5329735ab.51.2025.05.21.18.27.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 18:27:39 -0700 (PDT)
Message-ID: <079c6776-a9a9-4d19-9975-c8cf46febe98@kernel.dk>
Date: Wed, 21 May 2025 19:27:38 -0600
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
Subject: [PATCH] io_uring/net: only retry recv bundle for a full transfer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If a shorter than assumed transfer was seen, a partial buffer will have
been filled. For that case it isn't sane to attempt to fill more into
the bundle before posting a completion, as that will cause a gap in
the received data.

Check if the iterator has hit zero and only allow to continue a bundle
operation if that is the case.

Also ensure that for putting finished buffers, only the current transfer
is accounted. Otherwise too many buffers may be put for a short transfer.

Link: https://github.com/axboe/liburing/issues/1409
Cc: stable@vger.kernel.org
Fixes: 7c71a0af81ba ("io_uring/net: improve recv bundles")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 24040bc3916a..27f37fa2ef79 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -827,18 +827,24 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
+		size_t this_ret = *ret - sr->done_io;
+
+		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
 		if (sr->retry)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
-		/* if more is available, retry and append to this one */
-		if (!sr->retry && kmsg->msg.msg_inq > 0 && *ret > 0) {
+		/*
+		 * If more is available AND it was a full transfer, retry and
+		 * append to this one
+		 */
+		if (!sr->retry && kmsg->msg.msg_inq > 0 && this_ret > 0 &&
+		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
-			sr->done_io += *ret;
+			sr->done_io += this_ret;
 			sr->retry = true;
 			return false;
 		}

-- 
Jens Axboe


