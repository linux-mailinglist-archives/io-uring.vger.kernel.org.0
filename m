Return-Path: <io-uring+bounces-605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5671855475
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 21:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D80341C20E80
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 20:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E1513DB88;
	Wed, 14 Feb 2024 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lNPW2uwE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA213DBA5
	for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 20:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707944381; cv=none; b=WKNm1z49xvvVQ0jvirKdydkHahKUQDJzazebz986LwSc66snOFDdaQjY0kQPDQ8uZdPNrFZ1em/Dcf5GoedVQCJ+QEbjl3fQQ6GuFldypkXnunppcpunwmFKLXkIzu1UrpWZjFNX3qnlFey07t3VtA8EydU42+Yt2rGVT934mcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707944381; c=relaxed/simple;
	bh=1BnANrw+V765UREieaQ1M0lAkb3AsTjN22+jS1za6SU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=r5udp/hxdPU/M3gO3iDk9hpYr3mbC2CE8Ptcw3+zZEf81hzyvxw2bOLgmAjOV/3dx/QR5aBAS2vJ+ZPtzlhLvg+bhdmBbEF7G65QGZzW5Ua7P81hxGhBnTqjLnT6xy/yjNoLDAyc64j3NN29zNi9fe4/qu6zD1LWbxiTTZcKI4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lNPW2uwE; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-35d374bebe3so334535ab.1
        for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 12:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707944378; x=1708549178; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oe0j5IRENQVH/1FbwamhUP3vxRDsEhcA+AIsRgixQuU=;
        b=lNPW2uwE5tZI5nMxOEQEQDi946TLpAk96BDgleb6R7CFcJ+GDUPwNvrkIgM7cyevJJ
         lHhIOVlvVMxKVyHte+sBHuHdNiaL9CjjRoGCn2VmQ7LKI6Gh3QLT3m8Ebtyq3yL1o/7E
         yZIUDgNmPKlr+12KFf9sir+07dMHPN+lPA4UigPpzTB7yu+pRTOZEeyxL5op+Xf+P340
         Qn6jTBIBYv0BbN03rk3FsorcdFghmhY4JzLKSWZbnrt5GdMjv7OoQ8hAQmKYZO0y1FZB
         yHEUt+Iq9Mwg9BZOoZi1sToV+wOeVQNZzzNO1S1VLQhtQsLYCx6Zl+K5ihsrCsbyDrWc
         2XiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707944378; x=1708549178;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oe0j5IRENQVH/1FbwamhUP3vxRDsEhcA+AIsRgixQuU=;
        b=iYYAlxdcMf5udMKrZrA8PM0EIltBpviW1h1JJYKF2upkqKrT9Cye8P5Xtx1aa4z0Xq
         pN3BURoq4S4DHn3AzKhiB0pS2ohFX2hZGLiZHL6NvR/wHwAxkJi0Nfp/XXKOFFPDpP2l
         vkkHHVpmDlB6Q0qpbRsn9lnOPHSI8rE6XoksBFz4XjqK3w1rECxwzi85VyrDm9FwyKl7
         /GzG4aJMXLp0ed0flkLJl/szCkLG3w7u8WRKoguNnouQyhUCKefS99xEcaDIQdeI8Nct
         vscYoqVXBc5762aJNqrru4vNpQJimAjBBaGXwqAAFaDzICJnFDLGW8YDjYWfKhIoirJ8
         06xw==
X-Gm-Message-State: AOJu0YzojQwp8oMYalxe1Eo20qsT1w4oQ3D/YiDZ0SKTweJG6GU8gpwh
	F/Hl22BtytcaNLjimB2S34Q5SYgHNhalhDIuWSQYD3gFWvNQmXT5r/bYhP/XhtukKj/IUXQ18Le
	Y
X-Google-Smtp-Source: AGHT+IGrqK/USqT4vgigXfiocHPTamPKONzsyuRRsOdME3ZYTxjA4Y4cL5SQroS/Geacfsjpx5qyYA==
X-Received: by 2002:a05:6e02:12c8:b0:363:c63a:7960 with SMTP id i8-20020a056e0212c800b00363c63a7960mr4325580ilm.3.1707944377901;
        Wed, 14 Feb 2024 12:59:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b17-20020a92db11000000b00364b66eb5e3sm358224iln.24.2024.02.14.12.59.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:59:37 -0800 (PST)
Message-ID: <36d7ef98-38d9-4f45-8bac-f0032e0df695@kernel.dk>
Date: Wed, 14 Feb 2024 13:59:37 -0700
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
Subject: [PATCH] io_uring/sqpoll: use the correct check for pending task_work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit moved to using just the private task_work list for
SQPOLL, but it neglected to update the check for whether we have
pending task_work. Normally this is fine as we'll attempt to run it
unconditionally, but if we race with going to sleep AND task_work
being added, then we certainly need the right check here.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index f3979cacda13..82672eaaee81 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -246,6 +246,13 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 	return count;
 }
 
+static bool io_sq_tw_pending(struct llist_node *retry_list)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	return retry_list || !llist_empty(&tctx->task_list);
+}
+
 static int io_sq_thread(void *data)
 {
 	struct llist_node *retry_list = NULL;
@@ -301,7 +308,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !task_work_pending(current)) {
+		if (!io_sqd_events_pending(sqd) && !io_sq_tw_pending(retry_list)) {
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {

-- 
Jens Axboe


