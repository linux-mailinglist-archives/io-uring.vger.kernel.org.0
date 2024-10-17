Return-Path: <io-uring+bounces-3782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CCC9A253E
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02F6728381A
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 14:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C937A10F2;
	Thu, 17 Oct 2024 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aqBfrUiP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFF21DDC1D
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175930; cv=none; b=NP74nMtXwA+QSOKLBRoByJdczjsSpxsbKK+r93G/FjKpru9Emit6N5MnWnbrzPRQUtRYqJ3r9oSRKEK1wRSGCarlxpKCYQTwWkNRkv7JARn5HG0XJydF87FA0y/blys9mI+OVjMsL/A7iQM413EXhoYqIwxChCVob/blyjwai9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175930; c=relaxed/simple;
	bh=r6Mj+gY9DOkoZkKXNY6+kUt9ol3ioqcuLnqLOC9+NP4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=nDPXEZUnlRKT74+gm1NiAbcaD0dPWNJazsRSLPt7e6e/Rfsj3BgLCXzamt0xcFETLOeQnRfncZtgOUUA5HazBQ5uX6A4yow5vnwcLof9R/0DQVMggp8jzpj7S0cpO1ZNn7F3dJ95/XVmvZrlfZofke1/YUOHGY5kBtq6E2I2Wow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aqBfrUiP; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20bb39d97d1so9464635ad.2
        for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 07:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729175923; x=1729780723; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQJ+Lg/67sSdbNa2He7cPLH9yD46cjhQ0xhg+VaGhL8=;
        b=aqBfrUiPkzoTFknBT95DboDrppqK9o/pqNU7u3sMW8JwYQPpSi6blKtE+Ip7xQi/3r
         sqKCN5+SnHFK+hmBoDf6JFb9cljdOyHnOSy8N3FfqNgvVO/PDbJgGNYspLyAZFHke6me
         JXCUBY30ySJBGs/wcHGvCYMMHdZTOtZ5jgOemjml/+DLoMHf/1YCdPP8FEB/UWlnffhY
         SdL5F3AYnmCQULLa5CHw5CWKRejkFNCOerWkU8m6E3O47Xc/3d1vIe+0NlqoXSg3OB9u
         muBh1qrW0pWGv6CsttInv3SXPKMWiCH7/9Vlt177i7bQ1FTdvrQssa7+9QURqe6/eEdF
         7gpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729175923; x=1729780723;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wQJ+Lg/67sSdbNa2He7cPLH9yD46cjhQ0xhg+VaGhL8=;
        b=NgfaluD5vE8syUtA7YotZq5AnYr5HxkpT6dYzOXXL1EYGTujt7jZCR5eiywmiu0CcA
         53ap2okNG0BHrdl0KNqeKbqke+h7zSCoPa+rHl+HKm+fjsucjXb5Pg98tr2c4nQs/2lJ
         DfcEOqjIfui4bo88tnTgx/gUSKpDQEG/gbf+vykXuD0zkTdHcPKt0W+WDJvK2eardFuC
         40FLMwnfksXbQDFMtAee8ZsI2z3f2mKYeEb4gUlSgEkFBM7nPpJ33UPXJxZ2GxDePYxp
         qgP8FQzUxvZj2v7+FV5XgMER+vN/gJuyfQ1fI3Fu5i1qwjdLRvuGa/0Q79MctJP3WvM9
         s7Dw==
X-Gm-Message-State: AOJu0YwXb9nIDEixbpqJ/rFHsdCf9/FsfStaRfhF4UgJajtOwXYDPibu
	topuebwPJH1LJN4ciR0ZMruQ0e7vOHhYvdp6NzjyE64rbmNN5yIEHtXTTW9m6ICaX7e3G/jODdv
	E
X-Google-Smtp-Source: AGHT+IHoZTFSe83TBHllgkGIxGizkzhE7yiycTjiR11DNPDeIny3Mhdso1twB3y4Z6h/LfJFy+zzuQ==
X-Received: by 2002:a17:903:2c7:b0:20c:c880:c3b0 with SMTP id d9443c01a7336-20cc880c9c7mr231018905ad.21.1729175923446;
        Thu, 17 Oct 2024 07:38:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1804c6easm44848765ad.230.2024.10.17.07.38.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 07:38:42 -0700 (PDT)
Message-ID: <0e178150-2eeb-4205-a2c3-3f026fc8e81c@kernel.dk>
Date: Thu, 17 Oct 2024 08:38:41 -0600
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
Subject: [PATCH] io_uring/sqpoll: ensure task state is TASK_RUNNING when
 running task_work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When the sqpoll is exiting and cancels pending work items, it may need
to run task_work. If this happens from within io_uring_cancel_generic(),
then it may be under waiting for the io_uring_task waitqueue. This
results in the below splat from the scheduler, as the ring mutex may be
attempted grabbed while in a TASK_INTERRUPTIBLE state.

Ensure that the task state is set appropriately for that, just like what
is done for the other cases in io_run_task_work().

do not call blocking ops when !TASK_RUNNING; state=1 set at [<0000000029387fd2>] prepare_to_wait+0x88/0x2fc
WARNING: CPU: 6 PID: 59939 at kernel/sched/core.c:8561 __might_sleep+0xf4/0x140
Modules linked in:
CPU: 6 UID: 0 PID: 59939 Comm: iou-sqp-59938 Not tainted 6.12.0-rc3-00113-g8d020023b155 #7456
Hardware name: linux,dummy-virt (DT)
pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : __might_sleep+0xf4/0x140
lr : __might_sleep+0xf4/0x140
sp : ffff80008c5e7830
x29: ffff80008c5e7830 x28: ffff0000d93088c0 x27: ffff60001c2d7230
x26: dfff800000000000 x25: ffff0000e16b9180 x24: ffff80008c5e7a50
x23: 1ffff000118bcf4a x22: ffff0000e16b9180 x21: ffff0000e16b9180
x20: 000000000000011b x19: ffff80008310fac0 x18: 1ffff000118bcd90
x17: 30303c5b20746120 x16: 74657320313d6574 x15: 0720072007200720
x14: 0720072007200720 x13: 0720072007200720 x12: ffff600036c64f0b
x11: 1fffe00036c64f0a x10: ffff600036c64f0a x9 : dfff800000000000
x8 : 00009fffc939b0f6 x7 : ffff0001b6327853 x6 : 0000000000000001
x5 : ffff0001b6327850 x4 : ffff600036c64f0b x3 : ffff8000803c35bc
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000e16b9180
Call trace:
 __might_sleep+0xf4/0x140
 mutex_lock+0x84/0x124
 io_handle_tw_list+0xf4/0x260
 tctx_task_work_run+0x94/0x340
 io_run_task_work+0x1ec/0x3c0
 io_uring_cancel_generic+0x364/0x524
 io_sq_thread+0x820/0x124c
 ret_from_fork+0x10/0x20

Cc: stable@vger.kernel.org
Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 913dbcebe5c9..70b6675941ff 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -327,6 +327,7 @@ static inline int io_run_task_work(void)
 		if (current->io_uring) {
 			unsigned int count = 0;
 
+			__set_current_state(TASK_RUNNING);
 			tctx_task_work_run(current->io_uring, UINT_MAX, &count);
 			if (count)
 				ret = true;
-- 
Jens Axboe


