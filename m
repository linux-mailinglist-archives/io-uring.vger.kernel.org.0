Return-Path: <io-uring+bounces-4853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C269D31FF
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 03:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D35FB23593
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 02:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD443D76;
	Wed, 20 Nov 2024 02:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xui+m+KU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2FA1B95B
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 02:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732068306; cv=none; b=sZDWku3wq85PA90Ya8LRvLFsMkAs1JlZfYlGcTFf9V070Lo/KkSEqEkgRORZzS5k8lE+Uq6tOiTHfPmWFKmv3e/T9pt9RFcjAmTUFP9BIrjktAU4RUHWPyxtlJAUY1r4nnYg5KOzmArHWp8cMhCSBDCBeoLkA2xeRidjldBVVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732068306; c=relaxed/simple;
	bh=0mbREAYeAzyXEqliHjgt/9CkIZjs9XkaZhBnFR68Ii4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=LITJWOdf8Pz3Ob1K+kyBCKvQE9Wx7AyOjrGWjLZWDopw7FQ8xLcKXJM6XMLSx1+lzmPjc+Qe4rPJwH/OgktvTqnjrom4YR35c6j74bDlmEoGuudpJIrLPp0c+vxCK2DtO/ruD7EBKFjhn8vvkxfObBuJvyRDgLugT6N+IVftBkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xui+m+KU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21210fe8775so3040795ad.1
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 18:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732068303; x=1732673103; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp1gu/xCHDO+McGdeXQtBg7OwBGC/gkLP9/1W9uRP3s=;
        b=xui+m+KUU6Sf+3FohOK2WyZ62BtyQGTvs0qEKB4L+C6BjsOQL29EztGQWHjtJYS3W4
         RYbALPrQS1Lu8HXuwCUSwkQsxtFck3dAQWD4YqfrFI3uE4b4dyE2SyraSrigbB+gOj2d
         AC6P8ELWEngYU7R9mQIrjc+U5Bhbt+yPCmKMliFE3egnebpl49M+u7HWSpsza83GwaKA
         W5X4wUim2bHmFr8JO+c4AuoTisVT6t74CCwD0/skAB2do9pT7xISIgdWy8iomQz6wfqo
         rfpS1nl1VhfIjGyYgwMq0q5RD3Prz+p+uCIo2PIT6ZHJ6X+uSWiD5yU+TKFp9fsYzKEQ
         j3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732068303; x=1732673103;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rp1gu/xCHDO+McGdeXQtBg7OwBGC/gkLP9/1W9uRP3s=;
        b=NXRm8CGBl0xWS5Uz+lIXWdd/E0XivaAuVQIzfvg/PcRHJvJl+PCGDrq5Sn9it72197
         wMBY9ksuW6of6X8UYEhTenqlv0dstXk6Z0ewV5AY6RXL54I4W4jmWsyzJLgvgd+75maP
         pf60aqFraVXPNM5sOFMtg4Jv2kC9m1prbLWz9kkL/Ez/3XxGNuxSCOseePXusQ1mroNi
         sVP0O3jcFfC6S+wNhniFb5jXPa64g8CGjwk3c18nxC8lY3zCd5ThoC7fhae9VtIzpeuG
         RQpc3uguw4VY4lJUCvb6P6BQDXWcok+m5yTmbzrIlERxvlo20M9Z2Ge+vJM8ESmPQwsJ
         j2Ww==
X-Gm-Message-State: AOJu0YyX7ZLFHFs3nM1Rq2cxuy12QqrNIt3sRobw9pzsQ4pkvWnT9VOp
	Qk4BnVj2dOXAcLxKoFj1J/cnk/9nYeCNoP62/Q2n9RaE7F0JAnbzdBm+c8No3vfk+oPiah9AjXh
	hkSY=
X-Google-Smtp-Source: AGHT+IGbkFkpMdrWc87vQN8wGWQmYZo9ZqX9i66dPsHKFGhh1lDU/3oHap6RgWOcgxB1VTngVwBKpw==
X-Received: by 2002:a17:903:32cf:b0:212:3f36:d983 with SMTP id d9443c01a7336-21269e95910mr16877955ad.27.1732068303178;
        Tue, 19 Nov 2024 18:05:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-212549e4b50sm19293645ad.147.2024.11.19.18.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 18:05:02 -0800 (PST)
Message-ID: <fe73d557-8c4f-4ad7-88c3-92a598efe4e5@kernel.dk>
Date: Tue, 19 Nov 2024 19:05:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add separate freeptr type for slab
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_uring: add separate freeptr type for slab

A previous commit used io_kiocb->work as the free pointer space. Which
is completely fine, but apparently m68k does odd alignment and the
struct ends up being 2-byte aligned rather than 4-byte aligned.

Add a union around io_kiocb->work, and add a specific freeptr_t type in
there to be used for slab. Mark it as needing sizeof(type) alignment, to
force m68k to do so. On anything normal, this won't change sizing or
alignment at all.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: aaa736b18623 ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index aa5f5ea98076..91efc7e6bf3f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -673,7 +673,16 @@ struct io_kiocb {
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
-	struct io_wq_work		work;
+
+	/*
+	 * Use separate freeptr for slab, but overlay it with work as that
+	 * part is long done by the time the request is freed. Due to an m68k
+	 * quirk, ensure it's aligned to at least the size of the type.
+	 */
+	union {
+		struct io_wq_work	work;
+		freeptr_t		freeptr __aligned(sizeof(freeptr_t));
+	};
 
 	struct {
 		u64			extra1;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da8fd460977b..4bf25b9e5105 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3813,7 +3813,7 @@ static int __init io_uring_init(void)
 	struct kmem_cache_args kmem_args = {
 		.useroffset = offsetof(struct io_kiocb, cmd.data),
 		.usersize = sizeof_field(struct io_kiocb, cmd.data),
-		.freeptr_offset = offsetof(struct io_kiocb, work),
+		.freeptr_offset = offsetof(struct io_kiocb, freeptr),
 		.use_freeptr_offset = true,
 	};
 
-- 
Jens Axboe


