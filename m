Return-Path: <io-uring+bounces-7957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CB0AB3C15
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 17:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27F041734D2
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 15:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117751C701C;
	Mon, 12 May 2025 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NFhpcZJ+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F622A1D4
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063723; cv=none; b=ZI5BZ8LJG0eJcRxjuxganvESXAhOl+viBpvMiEsycqq2X4Y7qJ2gbjS+MBcBqKzE+eGBm+gKVuAzTJLt/DMr0L30hsKapJhddlqVxDFjjaRKx00Ndg8/ioYpJHVNNQeIeurLRq/xBaaytn4nRKPWfCdwvYBusvsvLe3dZAlwIWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063723; c=relaxed/simple;
	bh=qKCU+7UCDjMl0dLPeICjK6GXo/Qb2btpvGDXh5B5CDE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XGzvTOaYMCW0Od/YY05v+XApPfMESHE+8O562xYnyqgkuHXq0Q51pu22bkFh9zKwu4Mimg1LivJ1j3nPevgjUdQ+z7Lv/Ao/Ho7e3ohIWbgwk46XA3ZaObQt4XMOAYUnzPRD1XMsxiCh7mM7GS8TPNrz6UjWYOx3Rv0SGaqFHo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NFhpcZJ+; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-861525e9b0aso456091939f.3
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 08:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747063719; x=1747668519; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/kejXVvA2MMgNmzBuN/sV4QfZ1J0vcmhkB8AvPwkX0=;
        b=NFhpcZJ+vncdto1FPDQRFQOGfsyDG8sK0ZIU4h7rbxVjMo0WeYYRBudGBT7XgF/1Er
         PHO2NsAO2/Uqinupj489l7T4K8lqpLRsTI3jZuvcFc/tDeaI/7tFQKRVACu5Dp/T5mYx
         Lz7uW5YVNeSQoVUiwrxSCeTETyT9nSnHvzTx6qSOF/kVLMUlxjBvHqKgdp9CkqE1sefL
         7P7sN+RnaL/9iTh/KM5KPByBwBez37WPxX3E4X4Cw7dBkazokZikpQXJeD5CiBtCpsKI
         dJJd9xhL0uJxyJhD5eWi6Ks+LsA8qXsDem4HOuTA/gle9ui+mzG/jl9r3F4t4PtXLFdr
         7WpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747063719; x=1747668519;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3/kejXVvA2MMgNmzBuN/sV4QfZ1J0vcmhkB8AvPwkX0=;
        b=euL8A6zbknFWm5H4bMWSvozbG2YXd1pK05XHeO/SVQZyTmIjL9tie9UN9Djl+kZ8eI
         K/YBXok8I8w3H23WmeoUbSX06sOwx29FxAG/Ta97tpfvVFKX739qSDW4AJG8+DpjYIf7
         Ev2BIPbkk0ns5SKnVWBPQ2Wag1CGxT9GFhMnSXeMyh9tFfAfYEFPFnxWAKCLNKygKYVd
         PnzImUajL8BdjhsgJUjf0pXlsGybYzcddlT+wSWcRJQ6P1eo4jopUvcnZ6nZqzk91Iqe
         kCYKxhZ4wKaVzPycGrWWCok/i/1eP+POZE0UHbS0ThNkLhGK82ujT4OJJ8A5vwInNh8z
         Jkmw==
X-Gm-Message-State: AOJu0Yzciq4pHtEb31duqQ9C4fksAKjK54ahta6ex7C6SoMqhjQw7MqF
	HILrilrN+XjV1IrC07xWKNCUXdN8XhNrTOCrefT0VU8bjsnKCbR1FJgT1WgOHYZCNcIMOsUuQ6/
	y
X-Gm-Gg: ASbGncuw89nMSq/tD7YgDi4tq8u9nZuG0XLXpZ+U7BhDONeYjfW0FHAWf4CwtLTOfyj
	SlKhI+I8fI0qcOpcoCCz6SS3VALQ5U2nx3RiPHvrPs+2LqY2EAibk0ZRA4rJL6lHyGftMlRy7cU
	RllcW7Pzhf4uvNLO4Jk0DIB8OMmqgMpjVqcPsXw5R/Xq1GPS7Lvdlhy40uqM+f6EVyOUbpI4zXL
	guLjUIeQhjN4W5F0GKiQc9iWkLvVrR+dfd+DIXNrkuCah5hqoTj/8PsZiFyCnpbS5kkHaDMSIO4
	AwT4TaNL7J+tsl2aqrYJM3/jAqzeXH6KkDiMVWgHehnutsc=
X-Google-Smtp-Source: AGHT+IEXkj8Zgy5q5654Fb0zJY2x4SYK3Syzd61wOjeUEhC8J+E4Rj5ubym98xr/0uHdC8kVZN9CGw==
X-Received: by 2002:a05:6e02:349a:b0:3d9:6cb5:3be4 with SMTP id e9e14a558f8ab-3da7e20d096mr174078115ab.15.1747063703741;
        Mon, 12 May 2025 08:28:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa22685366sm1624203173.142.2025.05.12.08.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 08:28:23 -0700 (PDT)
Message-ID: <438add4a-4bc3-4303-941f-e9470fed9b1c@kernel.dk>
Date: Mon, 12 May 2025 09:28:22 -0600
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
Subject: [PATCH] io_uring/memmap: don't use page_address() on a highmem page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For older/32-bit systems with highmem, don't assume that the pages in
a mapped region are always going to be mapped. If io_region_init_ptr()
finds that the pages are coalescable, also check if the first page is
a HighMem page or not. If it is, fall through to the usual vmap()
mapping rather than attempt to get the unmapped page address.

Cc: stable@vger.kernel.org
Fixes: c4d0ac1c1567 ("io_uring/memmap: optimise single folio regions")
Link: https://lore.kernel.org/all/681fe2fb.050a0220.f2294.001a.GAE@google.com/
Reported-by: syzbot+5b8c4abafcb1d791ccfc@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/681fed0a.050a0220.f2294.001c.GAE@google.com/
Reported-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
Tested-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 76fcc79656b0..07f8a5cbd37e 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -116,7 +116,7 @@ static int io_region_init_ptr(struct io_mapped_region *mr)
 	void *ptr;
 
 	if (io_check_coalesce_buffer(mr->pages, mr->nr_pages, &ifd)) {
-		if (ifd.nr_folios == 1) {
+		if (ifd.nr_folios == 1 && !PageHighMem(mr->pages[0])) {
 			mr->ptr = page_address(mr->pages[0]);
 			return 0;
 		}

-- 
Jens Axboe


