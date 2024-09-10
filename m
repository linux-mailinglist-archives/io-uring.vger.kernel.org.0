Return-Path: <io-uring+bounces-3110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB81973A2B
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A03EE283585
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CEF719597F;
	Tue, 10 Sep 2024 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2eNUBtLg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D658B19412D
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725979325; cv=none; b=bg7HhyuBqzryX73NDXUFPhVDTjE16whqVIm307cqRazDR1pzh7LVUilSgT+QvXueZMSr3svc2mrn3vXRbfnl4XSRVmvJq1l3TiyTxUJS6nvWQzaZLYVqqVo8OYO8YIqRT0rAEQ8hgHGbhNKFeeWOCJNyV5JNDAHUcoU9PZKNnyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725979325; c=relaxed/simple;
	bh=HHHppCsJ1E+IzV1UoMVu0WzHEvqFTqbhdThpoc9f438=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=P1n1YYAo6cE1xx/reDI6iGvFgglN/otW1rqYMOEVAEqSuwF4DiWVtxtL8kvZdtSZ4AhU2HMwsT9xsTflUOX/NFwCUaspUMJXkrWbqQRzMgM/zhuQWgs3bVGnI1Zl468LS2Pu1kCL3a8X1J3sKxX3j/PucD1FxW7gqeeb+IvQGSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2eNUBtLg; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-710dead5d2aso446202a34.0
        for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 07:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725979321; x=1726584121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEcOw7GOnjnj4uw69UKHYvRPFBvmH1khMsiSUSnSnjE=;
        b=2eNUBtLgtqPHWjM15LNCHYR0LsaCe6DpYvyUm2KvkqAIHzHpoZWMSisjCNOmCNSt6I
         svJOqlWf5R74T0CHFwDpSuytIvHc2FliEManT4YVnNZo1QqQJhpkDF/SWh8Wya3jLrkh
         zGFPJCptyolIIt4dDJFbj1vTV+L77hWuY9SkbrYQITGQXFBIblgp/qina78p9lfPOm/t
         Eu6DfiqWH0Jp881eLe80vagu3/YCNxGQ9GsQfZN/uUIlPV3VOvFLVxqlcfinHX5jPXqy
         ca1lLKiv1ylJI4K2fIP/nCq+iQL7P5lr7K/zvzzbvcy67U/V7us+t/Gi0IVGJurVoRvw
         3VFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725979321; x=1726584121;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CEcOw7GOnjnj4uw69UKHYvRPFBvmH1khMsiSUSnSnjE=;
        b=fb9HVb5HhuNAm8GyWutSn54bJMmAcuWyuZo5rxBNJTLU1MaxjmzmSYVqYcdti4HI8T
         R+ey7skYXQiQoWH/b/Xt83fjPPgQ6W+/lcc0QKzBl02rPHkP6Bxzg25WcnrQEl5avNZn
         y7C/dPXo6JBCruEY2VmmFZCDRGut7MA1FxVUbP0aO418b25/mx0AkBtU/pCJ9DtC25gO
         6/o9tj/WrTvTQ9pHeI/tpfsYHoXlu+D9TZnwUNNr1TJpR4rxOz1XnNbsn/KkIxGAemmg
         jBDrKnsRNEmggJapgv9+vNmOaNuHC1R9WsLHZydZSLYuYMAkWOdAPvrAlkmG6GlKYofl
         Ynog==
X-Gm-Message-State: AOJu0Yyk/r9cPykP0NcXFQW/fW/ccyCo+WkqJZYwlHzYxwojKMVUUaFn
	EZWCmeQ4BRgYGyob7MeiKyJYOkdajkH6Z7593n0MIALNdroCyXeyjhZdb2bRBdBRd1ivPm0OEhJ
	U
X-Google-Smtp-Source: AGHT+IEdBLcPkPPOrKblLmNy4Szrv4lpf+GRNMwM+Rv8csmMJOyPNU2o9+EengdYuRStJQlp54xo6A==
X-Received: by 2002:a05:6830:7196:b0:704:4bb7:af8a with SMTP id 46e09a7af769-710d6e3e3dcmr9910050a34.20.1725979321161;
        Tue, 10 Sep 2024 07:42:01 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d094667f2bsm1616869173.178.2024.09.10.07.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 07:42:00 -0700 (PDT)
Message-ID: <8b7a8200-f616-46a8-bc44-5af7ce9b081a@kernel.dk>
Date: Tue, 10 Sep 2024 08:41:59 -0600
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
Subject: [PATCH] io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
Cc: Robert Sander <r.sander@heinlein-support.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Some file systems, ocfs2 in this case, will return -EOPNOTSUPP for
an IOCB_NOWAIT read/write attempt. While this can be argued to be
correct, the usual return value for something that requires blocking
issue is -EAGAIN.

A refactoring io_uring commit dropped calling kiocb_done() for
negative return values, which is otherwise where we already do that
transformation. To ensure we catch it in both spots, check it in
__io_read() itself as well.

Reported-by: Robert Sander <r.sander@heinlein-support.de>
Link: https://fosstodon.org/@gurubert@mastodon.gurubert.de/113112431889638440
Cc: stable@vger.kernel.org
Fixes: a08d195b586a ("io_uring/rw: split io_read() into a helper")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c004d21e2f12..d85e2d41a992 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -855,6 +855,14 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = io_iter_do_read(rw, &io->iter);
 
+	/*
+	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
+	 * issue, even though they should be returning -EAGAIN. To be safe,
+	 * retry from blocking context for either.
+	 */
+	if (ret == -EOPNOTSUPP && force_nonblock)
+		ret = -EAGAIN;
+
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		/* If we can poll, just do that. */

-- 
Jens Axboe


