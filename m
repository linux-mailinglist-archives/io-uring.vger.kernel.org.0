Return-Path: <io-uring+bounces-7423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1F5A7E047
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 16:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C24C3B240F
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 13:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9723D1B0402;
	Mon,  7 Apr 2025 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EDlcb6VN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2397188596
	for <io-uring@vger.kernel.org>; Mon,  7 Apr 2025 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744034003; cv=none; b=ZKUL85DR2ePDbSf3Lyc3J6JNF2rW8vi8fiQKUeXdePX2dBM8+ONS1gqLwgvCZDuzWtdMeWtqMPTcd/A6pz8jap+GvsVWTh7XZYbFLtDq+mRUTF6ZnZahvk7Yud0GA4EsVAG7fOZhqiCNO4rv7v0wVGyA/01/toeQza95tKAOLIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744034003; c=relaxed/simple;
	bh=emsIPZZBBahm13QoNTCXgKIR0aR7RWZq8nSo2pkFS54=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Tj88v/x7eJoSotzvbA5rFFhbLqkkieYeCnu5F6EI1A01jx7WUIgBH7BuvZVQdrEtpAXKDlXEgiNeYZfFGgyAxHXCOw3zVoqqO1vCZrh7EZgoaQF/OaoXZvtWdbMlFr1pNeQqrALiNKxjOa0rdrHYOKaBneKSZUCNY/B31FxUhrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EDlcb6VN; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3cfc8772469so21408555ab.3
        for <io-uring@vger.kernel.org>; Mon, 07 Apr 2025 06:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744033997; x=1744638797; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gU+x7/nKSWGOLt0S2KAlowXm0109BPvZ/42AcN2dHys=;
        b=EDlcb6VNBuLDIZ0piMsyjl+5yPcirCsUkJFLV/pJdQLHubFZ+8cdUOGU02FlBRo06m
         KrDGw2hNSC2N0YK3wvbIoRcn2bp05CrXXottH6rQkO6Mroin3rDR5Ym3ugQ+hkDrJl/j
         +oiQ42Hu/LgozYppPDp1/iEGEsaa3Hh21tg0JBarQ6+CC3rGSulEvkPFbYGv3laxVTje
         4S5hGmgwTiiJvBkuaBmSv44pEhY4sAfKtd7cc+fftEG/nIrz8MefC3ZIdUuWs/C1Zuud
         uFrOQEFnE+aHMZQylACnyspEgmXDSS6aqxFD+wdGEHFYe9YopgotugigyaDQrFgn3UNZ
         2xXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744033997; x=1744638797;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gU+x7/nKSWGOLt0S2KAlowXm0109BPvZ/42AcN2dHys=;
        b=uIGNQz0sVK4+m+y7Ztm+82P+UvPy/OUC4Wnn9uFeIisKF1seMh5L0vuv1lVVyTPAZD
         LkxZ2JN+25xVI7+0+MXZqB+QUjThvIRKY8wG/M6D7oxNb4/qrDjI+W0UqWaOcB3In/Sc
         yK1mIuKcZeF0FZ8cFds55w+Itd8d02HCbxSNUa8S/6xstATDh/UsEphbRH7cVNYIEE11
         pZZ8AcvEy8K2T6uiZ2SvYPqWp/xqBRYOXS93V44zByTw/LVA50FRGAcZYC7Mf1hm5hmc
         QFZ4jAQL4caudCUwSI0nFu35MQXYwCsEVLSAeE98il5Oq/dg9u7YF8k3PDoIIMObeGmf
         YZZw==
X-Gm-Message-State: AOJu0YzAo+irCX5VKJN7aG3iGE+XWjK0bN0Vtkul6lIkDrF24z8UQW2i
	1pnkQ3zRB6nkF6eXpseIt6QFszWtzGC4h8EtAneV6YOw6DhLe0jj28LC6Ov6oB1NK1v1pVgnJR/
	6
X-Gm-Gg: ASbGnct36kQxzRbyOIlhn0KtcYsoijZ9kXBJeocupmdPlu5zxypm7a5RtQPmcOFhkUZ
	IljydcWHADYp/SYbc68Wrdkar6F65iXCi7pRWZnaqy4L+Dq55QfYawKW5fVZ5C9tSjKw2ucBBqD
	c71K6A4yQ+QLD9NTV6/j5vbluIQyw1Cq+ie8Y5UXWDn94dipcM+BG5W6saxa++TU2AZ4dQm3Sp5
	5ioB/4j4eSO5Pww0hejoc7zP0zkFJhUjN6XY3jh6EXJZweZim/T+2TShXElNYgRh/20+xSGyTzS
	rQRSEFgN5WUMh/7dcVIgpm/wFzf9e+JCMqbwo+bV
X-Google-Smtp-Source: AGHT+IHRTAaUijugHBqD6/vWWBLEdHLvBMjsLCqf7TbH+NPnWeCM+JJ+uhAj9Tc4xmnn5J84RCQY8w==
X-Received: by 2002:a05:6e02:2161:b0:3d6:cbed:3305 with SMTP id e9e14a558f8ab-3d6e5347ddbmr103840215ab.10.1744033996995;
        Mon, 07 Apr 2025 06:53:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5d54a8csm2302681173.143.2025.04.07.06.53.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 06:53:16 -0700 (PDT)
Message-ID: <d04e49ee-13c0-4581-b056-e6b1ea7c31d2@kernel.dk>
Date: Mon, 7 Apr 2025 07:53:15 -0600
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
Subject: [PATCH] io_uring/kbuf: reject zero sized provided buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This isn't fixing a real issue, but there's also zero point in going
through group and buffer setup, when the buffers are going to be
rejected once attempted to get used.

Cc: stable@vger.kernel.org
Reported-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 098109259671..953d5e742569 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -504,6 +504,8 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	p->nbufs = tmp;
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
+	if (!p->len)
+		return -EINVAL;
 
 	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
 				&size))
-- 
Jens Axboe


