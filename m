Return-Path: <io-uring+bounces-2059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BB78D7184
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 20:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCD2A281DD0
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 18:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A86727711;
	Sat,  1 Jun 2024 18:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rtDC4a75"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4940C14267
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717266638; cv=none; b=E649Ix90PTC7zidx3ghv2oncTQfbY1MdZKypNEOnkbFbl4byZiiJd0z/96Z/dCf/vkfrZ9dsNs1XTtpmnJHCxCR7PiMrggL9gx1HDL0wSXnc3ap3BJHDvhkecgAnLuEQjybtysBuBr8aEb7uAQrqCDkgw0cxzAafcXa5C9LUMVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717266638; c=relaxed/simple;
	bh=Vs7kJvC9IMnmv4E4YhgrhS/FzkzmPqXq5Ytm+zp8NYc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=RQf21p2Ia4MJKMJZ1ujCjOucVTNZ0YvwSyxmRNNEgncwT58qETw0XhuRZ4xZDGNAtKsIYSiWSCpEn+UqeZ8SjDNrT7kqrKRLLY07bo3CEeZOiYZSPlPG272zHIoNWyBfonJGbMwcrBw2v/WwhsiTnF5ApMyJyRGi6qZbun67t5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rtDC4a75; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f64b60a937so210005ad.3
        for <io-uring@vger.kernel.org>; Sat, 01 Jun 2024 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717266634; x=1717871434; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgVxrWRj8eyWjfJK85Ymv4mdOX8ZYQM5HBUnBETONXI=;
        b=rtDC4a75cOhOHbsnfLzGdxyE3j8s7cNUMQyjpNvxA2CoOXSIImv1nRizInbyKo/H4A
         9DbMcKtY93DDEEAir6OND6O5f83SfpagapBThjccrXtOuzg0Je9HfUo3KPIG4Wlm/PXx
         2MkJqvbTcGSN9Nw2a8q2Doai6tAAbimW8AWSvq7D3eLhFt0KYwPXD00qDEMn1fX4vHc2
         OEA5r0hux9WmBqP7W/VEaw/G4rKWu4ete8iipZMP2beY4Pe9vtclJL+udXlocJ8tO7Lt
         Gb7lZSwjcZUYofEmfUWBoU7nlr55rXKw/0iDoA3S9aW+UJYSlPrgaDr21VpiZl0Zm3lw
         4dDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717266634; x=1717871434;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AgVxrWRj8eyWjfJK85Ymv4mdOX8ZYQM5HBUnBETONXI=;
        b=lq/Reu2e2LRfUvfy6XbQLklmQAKJAT5/M4vY5/s1w7jzkr72fVsBc6fbRthxv+Fcl2
         uj34st4Hzg2Y9Xzd2L0C8YokF2QwFdMcJxBPffhWQ9PURNXzFuIsT1IbX/jQe93+K1o0
         iI2lZBIV7PQKpbW3qb9Lp7eS3vBgRgZNxQDfEp4l9Enr6QXtWNDEI6DsdkfO+EKp+6Y/
         2tnBKfxDQlSFh2tUDvd8q4e97j2eDPrcTKZx20znxpUEn7NHm9lNsXb+k8SXie4eC2jN
         JfDuvcNM9dfo9dmwzHoKBXrp2WSVTbyq9kCowMiSKtOO96aY80qOMJayL9aNZi/sGc9B
         +7Bg==
X-Gm-Message-State: AOJu0Yw0WmkCYwNIZA2J1Moa7Y/R18IEiQlGjlshaJO1A2ZMdkykRanA
	y268yXnbYNNFMO6lA8wNaLz8lPjt7I2L7zZEIVkBtWc3YLnFe1aTM9iyOohkw1RScOzraLPjxY6
	I
X-Google-Smtp-Source: AGHT+IHorK18aNf+eusGWoCfmdIBwwHl9nCNXoIAdnJRr2xpp6+DVANqTfGjEXL/LZiYsh4PTY8saQ==
X-Received: by 2002:a17:902:db08:b0:1f2:efdf:a400 with SMTP id d9443c01a7336-1f6371d193fmr57375765ad.5.1717266633431;
        Sat, 01 Jun 2024 11:30:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63235f88dsm36352675ad.88.2024.06.01.11.30.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jun 2024 11:30:32 -0700 (PDT)
Message-ID: <d79f05cf-af34-43a3-a922-63a523050216@kernel.dk>
Date: Sat, 1 Jun 2024 12:30:31 -0600
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
Subject: [PATCH] io_uring: check for non-NULL file pointer in
 io_file_can_poll()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In earlier kernels, it was possible to trigger a NULL pointer
dereference off the forced async preparation path, if no file had
been assigned. The trace leading to that looks as follows:

BUG: kernel NULL pointer dereference, address: 00000000000000b0
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 67 PID: 1633 Comm: buf-ring-invali Not tainted 6.8.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 2/2/2022
RIP: 0010:io_buffer_select+0xc3/0x210
Code: 00 00 48 39 d1 0f 82 ae 00 00 00 48 81 4b 48 00 00 01 00 48 89 73 70 0f b7 50 0c 66 89 53 42 85 ed 0f 85 d2 00 00 00 48 8b 13 <48> 8b 92 b0 00 00 00 48 83 7a 40 00 0f 84 21 01 00 00 4c 8b 20 5b
RSP: 0018:ffffb7bec38c7d88 EFLAGS: 00010246
RAX: ffff97af2be61000 RBX: ffff97af234f1700 RCX: 0000000000000040
RDX: 0000000000000000 RSI: ffff97aecfb04820 RDI: ffff97af234f1700
RBP: 0000000000000000 R08: 0000000000200030 R09: 0000000000000020
R10: ffffb7bec38c7dc8 R11: 000000000000c000 R12: ffffb7bec38c7db8
R13: ffff97aecfb05800 R14: ffff97aecfb05800 R15: ffff97af2be5e000
FS:  00007f852f74b740(0000) GS:ffff97b1eeec0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000b0 CR3: 000000016deab005 CR4: 0000000000370ef0
Call Trace:
 <TASK>
 ? __die+0x1f/0x60
 ? page_fault_oops+0x14d/0x420
 ? do_user_addr_fault+0x61/0x6a0
 ? exc_page_fault+0x6c/0x150
 ? asm_exc_page_fault+0x22/0x30
 ? io_buffer_select+0xc3/0x210
 __io_import_iovec+0xb5/0x120
 io_readv_prep_async+0x36/0x70
 io_queue_sqe_fallback+0x20/0x260
 io_submit_sqes+0x314/0x630
 __do_sys_io_uring_enter+0x339/0xbc0
 ? __do_sys_io_uring_register+0x11b/0xc50
 ? vm_mmap_pgoff+0xce/0x160
 do_syscall_64+0x5f/0x180
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
RIP: 0033:0x55e0a110a67e
Code: ba cc 00 00 00 45 31 c0 44 0f b6 92 d0 00 00 00 31 d2 41 b9 08 00 00 00 41 83 e2 01 41 c1 e2 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> 90 89 30 eb a9 0f 1f 40 00 48 8b 42 20 8b 00 a8 06 75 af 85 f6

because the request is marked forced ASYNC and has a bad file fd, and
hence takes the forced async prep path.

Current kernels with the request async prep cleaned up can no longer hit
this issue, but for ease of backporting, let's add this safety check in
here too as it really doesn't hurt. For both cases, this will inevitably
end with a CQE posted with -EBADF.

Cc: stable@vger.kernel.org
Fixes: a76c0b31eef5 ("io_uring: commit non-pollable provided mapped buffers upfront")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 624ca9076a50..726e6367af4d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -433,7 +433,7 @@ static inline bool io_file_can_poll(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_CAN_POLL)
 		return true;
-	if (file_can_poll(req->file)) {
+	if (req->file && file_can_poll(req->file)) {
 		req->flags |= REQ_F_CAN_POLL;
 		return true;
 	}

-- 
Jens Axboe


