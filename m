Return-Path: <io-uring+bounces-861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0CC875B9B
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 01:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8557DB21E15
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 00:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0E21D6AA;
	Fri,  8 Mar 2024 00:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cxNrUxp6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2B720B35
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 00:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709859070; cv=none; b=Rdl1a7UU2NLmgfwYgHvL7YvkIQBPBHxWEpp0l7K6aaIgCmdZrz9HpiBb2K0tHZUOVLvThpF52olgs6sbyHDFFe5hiOt+kT12GkJ+omQPcVBdViuiGE7pGDZoaK/1zioESmKq7ns9Lr2MA05MItbsm+aIRkmkBlaHKKA7vKlYSHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709859070; c=relaxed/simple;
	bh=m7w9nVL2r702ZuyLyZV70WsjmydmSo9nGXQyFbIg6nk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=joeAVwdu67gPde/cxo/KFJ0uSi7jLM6u+amNqU/ee/ELtwJSnEskwBdtpXRNJivQ6HOzjaGQrZRC1H+kOp2dtAoo3gXiwQeB65iZCA5Q+ljtb2I9vjv7eYHHLjRHPUEKiUle0aAPLMLi14HUVbGp8vbjiZ/5QsjH0XyWjxp8z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cxNrUxp6; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6e50ddbbf84so138799a34.0
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 16:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709859062; x=1710463862; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5N0WaS4sQw8EigAgCKdbTlTNznMhsraRWZyDzwQdo0U=;
        b=cxNrUxp6hlioym5rFd+ZBPOcaXbzfo43souEO1Xt0f5J0NXvvxzaOSuMwthZ+xYMN7
         HTKTQ5BMPeN5256h6tYjEz3o8sWb3pZ6a5BM07WTd/o0+5GDJ1RNgoOOpWOrtLvLasj/
         CF4Pmzj1Vfdxp/ju+QxLvCZKtcmQQ+C1sCrsL3HHphbVVyrPQ9S7i2yjP7vcc1iq1qnV
         oNeVtL0P+Tn9RzoNHP9AwNJ7IOmNkviQIgLkyJ51cjc5gmxOK11wVldg/A33ZY3bU0/s
         53DAk9FH9ErqsnQo+Y5eCKxppiUuF19wfSkoaZMj5jYHnZ2xT6HTn91QmJGDsWngwjl+
         T5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709859062; x=1710463862;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5N0WaS4sQw8EigAgCKdbTlTNznMhsraRWZyDzwQdo0U=;
        b=wHv9jGKolW3J22xq1L/U6NF7rI6fHnHPnh3DihiJao/t9A7U26qNEnsoN0+ZAsSPfs
         QXXd/dJfQ+y/06d8PKcLkP+ApjWucxis1fVkVXzqWypiEeL9SwVN/y0UFC/IidDcCjeG
         ZdvN1cH3XsQggb1AUfg18+Wuw/FOQxgWiAhLVHbiD0Ry3xsWxph8U9/Zv+qwEf1ukUAP
         Euu2HJns45zpmFNhieIZYekv6n+87TGFSw1ocMZrA12i2Lbt541xKYHxbNNiE6ERFFYW
         gNw94Dy6at65jaajoVVwD3wCuJgRhByCm6u3SOwYlSQyrMyjfwUdIFrbC2vXFa/vj9XX
         xERg==
X-Gm-Message-State: AOJu0YxGCR2/YLcHdgxjSCfH8jpTijlZM/oeXiyNUkMrJTqRT5YXMiRz
	pJuNSTChe4V0Jorf7CZlTsc+uaUEdy0AxASF58SQFhwXVBnBYsjcODe1y5ypNoL5sYUfHQokeZ+
	x
X-Google-Smtp-Source: AGHT+IHmJisqsX9dhdH20NrFvykVh65s4Nij2+9h0FSO2U5U73eRoDOCUD/1SY2nTQXC3ADX47WELg==
X-Received: by 2002:a05:6830:2b09:b0:6e4:e0e3:55d9 with SMTP id l9-20020a0568302b0900b006e4e0e355d9mr756640otv.2.1709859062629;
        Thu, 07 Mar 2024 16:51:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z24-20020a656658000000b005cfbf96c733sm11692618pgv.30.2024.03.07.16.51.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 16:51:02 -0800 (PST)
Message-ID: <2fcaf22c-6b1d-41d7-adf8-e8ca94a26073@kernel.dk>
Date: Thu, 7 Mar 2024 17:51:01 -0700
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
Subject: [PATCH] io_uring/net: clear REQ_F_BL_EMPTY in the multishot retry
 handler
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This flag should not be persistent across retries, so ensure we clear
it before potentially attemting a retry.

Fixes: c3f9109dbc9e ("io_uring/kbuf: flag request if buffer pool is empty after buffer pick")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 1640e985cd08..e50947e7cd57 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -676,6 +676,7 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
 	req->buf_index = sr->buf_group;

-- 
Jens Axboe


