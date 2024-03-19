Return-Path: <io-uring+bounces-1136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E9A87F565
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 03:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 950CFB21774
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B4065194;
	Tue, 19 Mar 2024 02:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BTnRu9Sa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21264CE6
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 02:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710815105; cv=none; b=PMqZtSHsNTgRjwA87C/v0hUSiuVL59gzb1AAGIj9u8AUh61GEkK48k8/Xo5FxXcx/LQVVArs6qXJMmQEPjnAYEUsdfhf91NSUT5wWvFay8YIgc08f0otfhnzhdm8/o7b+VYAY0i6SochW6LJOcsf9fdHZUElxLj9gJL+WHtMJd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710815105; c=relaxed/simple;
	bh=usexpfUUaOdKoscCmMPOP+9q50kn1XiUNf4aRdRUXEA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SBbXvT1d5U9FakbY8XS94C34TxZcgoy5sYO/r8SYnKhOw+bTqParZSvkdWs/UbqkRjOu4SVvypiptLiN9x6Q7Gg6eceH0q01/gFDqpJ0B3KnjvaHU8h/BqhYXwNTGVby+/D8SPVnEsZwabkRb5+rPBjqr7NY3aeDBAisXWKm/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BTnRu9Sa; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e6c18e9635so1316851b3a.1
        for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 19:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710815102; x=1711419902; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKwbmHd9W/uIJVGtKNcEQVg+bZr0wfBME4hoGuVlY7s=;
        b=BTnRu9Sa5NAhiofi/kdi4tPrPQUGqFPhfFmBGtvo50nV6lYaEK/Xzfipan40KdbUAH
         E1YlWWM7r4gMZONzffbYW5rUO/3ex2695uyjHRjMTdN2BIshEAmrnsnwknPZHgdI3ToT
         JcB+T12FgEaPDyt4I7rDgThcqeQKbaPmA16RSq7eaw/D1ZMe4YzMUCnO7VijV+JbsssX
         05u79U2e2rLCefSivtyFpv8CBWdRFfAe1xBvT5gSmylNTKWfzI0IB55J7wGtcnThgHlm
         WVbLmZpCGT2LkD6Pp88PYHIgGP1agc1S/SUF+GygMlQNQBNXDJSXHArt332YHZez3akL
         F77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710815102; x=1711419902;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LKwbmHd9W/uIJVGtKNcEQVg+bZr0wfBME4hoGuVlY7s=;
        b=M9E5T8ETSasWuSvbFvRf8H5GsSy8BSd50q82kb5cWSWn+e5/+slyxgqG8IdlSiiK92
         MCcwpvPLdl1BNAodiqvhbgVHQzWMJGwMlZ6qaAYuW/ipqMBwkFl+LDnxtCmBQ+lFLQpB
         et2h3lkrWq7k+txYQgGc3OcKc4g326DfIhdD7nmC52zCblPkHFTRwjqjYdd7gtdFt03z
         qGd/rYrgP6wqhfYS5qm/y+zKM/+UNMF3EZn6HmfURxmsJ//vWH+CcXSFD5MWIoKpo/8S
         I3d0sjzIhMgUUm0BfqELC/ITCzd6KpzaQLnFz4wZyZsD+WQgra32QdPukKDWRpbXOf6o
         9fWA==
X-Gm-Message-State: AOJu0YyWigDNGemtOhM/SoMitVdkkICzC1lJdP73x0G7G2bGvDib38pc
	+5/JZQqhpO+Vf3hIXV/60c2VuxOEPZ9i26U3FsQ6j43sSQv75ivoDeNNfrnkfskgDqu7lvgbn8y
	O
X-Google-Smtp-Source: AGHT+IHSIiUVcEwxxBmcttFqZmq+0GVoC9dA9vekTV6PX/5+Mn0PdPEd7StWl0nbwOMJXMRL9LX8Ow==
X-Received: by 2002:a17:902:e84a:b0:1dd:b883:3398 with SMTP id t10-20020a170902e84a00b001ddb8833398mr923910plg.4.1710815101647;
        Mon, 18 Mar 2024 19:25:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id h14-20020a170902680e00b001dde403a060sm10130514plk.44.2024.03.18.19.25.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 19:25:01 -0700 (PDT)
Message-ID: <31233857-c545-4f02-af00-0eddf1e46cee@kernel.dk>
Date: Mon, 18 Mar 2024 20:25:00 -0600
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
Subject: [PATCH] io_uring/sqpoll: early exit thread if task_context wasn't
 allocated
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ideally we'd want to simply kill the task rather than wake it, but for
now let's just add a startup check that causes the thread to exit.
This can only happen if io_uring_alloc_task_context() fails, which
generally requires fault injection.

Reported-by: Ubisectech Sirius <bugreport@ubisectech.com>
Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 363052b4ea76..3983708cef5b 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -274,6 +274,10 @@ static int io_sq_thread(void *data)
 	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
 
+	/* offload context creation failed, just exit */
+	if (!current->io_uring)
+		goto err_out;
+
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
@@ -371,7 +375,7 @@ static int io_sq_thread(void *data)
 		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
-
+err_out:
 	complete(&sqd->exited);
 	do_exit(0);
 }

-- 
Jens Axboe


