Return-Path: <io-uring+bounces-9918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 795E9BC196E
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 15:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6D9E14EE056
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 13:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B352E0B73;
	Tue,  7 Oct 2025 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b65H7hQm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD231E32D3
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845387; cv=none; b=DH3huziq04F5ME31sNSsRdEC3REgxhShlZf2g6HGhEPaab3G0BuUSr9y3i/dXVPYMjrZxmhuPOjPkL25tEV20/9NPRMY5srtW6NRySLQqFF/eeP15+GfNx+3P4LK11IVL936e63v1CY5f/N+gd8BEcjxgpcg5pxaXOJdf0NoXkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845387; c=relaxed/simple;
	bh=e7J7VMbD1BxLwEI9dUUhK8Id3kNmE4RumTc2gPbPsSU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=fClSDi4LRefwB4LqAYyp05h6x8+ZtZu0f4HiTOD8CMdUdFAoySauoBmArJ8l3PAmaYt/4rB4mHY7lshEGvGjID0hZdzGz2BtizmDGVNFtDBXsTQH/b5H4HEoH+4TFe1ZLwD8HnWlzk6b5bQbp9Z/e5KbclWvfj8FOliJKlfmPvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b65H7hQm; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-92cebee95a8so283773439f.0
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 06:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759845382; x=1760450182; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4RsIAyWhUUPwr8MUD5PsL/Ss0zoASV5UUCkcsnkAKM=;
        b=b65H7hQm1mYjIznIgfwxzpFxWfE8pIknD4W3DI4k9+rlFDOMPTUO2368PTQkPF2Pfd
         REqw0QXYOBasM0Jkvrf2GXlAEeOB8CVfjWkepgG5KAvU//DygQSaTdT1baYbIOam8Xdv
         dn3r9NirDxicqwy2CxctcuFylF0IuFswiBVhqpeH2yBRKE0tbWTwlaXddcRSGJNcuaJk
         BrwAJNqcOFIAVkeKy4h6pVEeIuJUL5gAVmwA/34f8GV4zZzguhrlJq4oZ50OEUK617b7
         Pj8/N32pp7IfLFKIEiMmzQKtcXPUkFhr9lghHZtZvzBTLNoFlyuOHVZbBV5kIxLlcp/r
         v1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845382; x=1760450182;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y4RsIAyWhUUPwr8MUD5PsL/Ss0zoASV5UUCkcsnkAKM=;
        b=MW9QEP5uixAU/5+Y9NarOB8z5bFRlyZE/d5Ro5PAiDin0YXADnohQCws18QdytO+nQ
         ReBgU2xEF/9NrwGq3hTQuEEMI/b8jQTtK1lnpZNtzSzgsQoDrJm3nRfuWS5e3neH+D9S
         rtlSCDP7F5Tb9YIefuDypDIvEWOWunu6Wipe7MzSvkMiEJRC9BOuLC12AlMTqsv//OiL
         2A/7/RKGeh+l81rfeU9A6lZsSq5A/a5RFsmE+McHcZEYo79f1E7mMXod7vxcZ+zrlY67
         wbUfYnKopIJbYNWQyc6woHBqGQDZXjoF7GhidJ7TTRNfJ8Kg+GERFTj8K5yqLs4IzCKh
         jAcw==
X-Gm-Message-State: AOJu0YybkFGNwsf8HSOvBE8/bU/FqQtn72GwLtkbnsJA+EmAu33lssz7
	HFehr2wVYCzC7/vK1v+yXJWLzrT9HJ4vluIcMSG54ulMoCSZebNVBrS18J7BGjjxLVDlGgV+azn
	+WTEQP58=
X-Gm-Gg: ASbGncumCufu6T938YiF4ybL8ErMmFVLZh1PTRUWfXFVzMI8BXdtmBfCUF1m5XVr9zi
	sanE/0cjCuqaO76NeeuMPRRv2aP6v9WxUuJKkItBJvAhn9+mtNws+z/GDFqJiS+P9RbrRXZcuJ0
	7R1N0zaeXzGHWQgc8smTINZvcZFqgXR9jdB73j4mHZ3lnNe0tlSHDD8QGhbRy2RCNWT59PFE3HX
	RyNxY8BgUWFfIb7ji8YPEjPqdZ68c/rw7gRxgmOxSBuZrkgwu8EREbSOCWatic5NzNQ+kkcZIYX
	n1Lt2sGd1lJmYVtfk7584VdSqYvtlbAGW/X4THWmINpS5jA6ANwb7uSG+rYAPUXAfXqRkAZTTk1
	bU6H7yQDFi63Lwk3h+o9ZSDwJ8BvB99VYMxhA/5Zw5f2R
X-Google-Smtp-Source: AGHT+IFQIn6iUF6buds8AGeBsJNnPFyXvkk1TE7quhiVEB9Hq0ZU24uS50hsoZayaBA9IK2kTO/J+g==
X-Received: by 2002:a05:6602:740f:b0:90e:3ea6:f77e with SMTP id ca18e2360f4ac-93b96939625mr2113580439f.4.1759845382312;
        Tue, 07 Oct 2025 06:56:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93a7d81c743sm570012139f.6.2025.10.07.06.56.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 06:56:21 -0700 (PDT)
Message-ID: <2fe8ec5e-596c-48cd-ba20-6d80530f3e85@kernel.dk>
Date: Tue, 7 Oct 2025 07:56:21 -0600
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
Subject: [PATCH] io_uring/waitid: always prune wait queue entry in
 io_waitid_wait()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For a successful return, always remove our entry from the wait queue
entry list. Previously this was skipped if a cancelation was in
progress, but this can race with another invocation of the wait queue
entry callback.

Cc: stable@vger.kernel.org
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Reported-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com
Tested-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/68e5195e.050a0220.256323.001f.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 26c118f3918d..f25110fb1b12 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -230,13 +230,14 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 	if (!pid_child_should_wake(wo, p))
 		return 0;
 
+	list_del_init(&wait->entry);
+
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return 1;
 
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
-	list_del_init(&wait->entry);
 	return 1;
 }
 
-- 
Jens Axboe


