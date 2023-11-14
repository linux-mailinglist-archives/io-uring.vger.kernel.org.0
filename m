Return-Path: <io-uring+bounces-85-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 569367EB52D
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 17:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 847AD1C20A73
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 16:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B145405D3;
	Tue, 14 Nov 2023 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2cxt/CG4"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5136405EB
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 16:59:35 +0000 (UTC)
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4F111D
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 08:59:32 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b2ef978011so229435b6e.1
        for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 08:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699981171; x=1700585971; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n4sXfTyg8Vd+fH28/bM1upjRiAGrdu4tuUb86E8h+EI=;
        b=2cxt/CG4+slY8rb/qZXZCayRNwI5N8411D0Ju2/JC7CZSRvk8AXx9e09LEGxaOkI93
         Ys/Omy03CWvddCRdUZ3B0TZqm50l9HF4GV3Eu3cmxTYypVfq2Zj5AA1/XQIlPq1qZCn2
         XJcqbHc9Y5ppmkhADZ/yqTmLSMRUeGvrgrt/eTbBeIdmupP+DI9ywpHaUl68dFlq34cA
         7zlzuwMB82likNaR31xJFEKUT3a67ZgqrnN/v1QbmblB2J8gBTM0DMbL/ghKa2OKIXh8
         ViJr1Zx2C4z3QSsDyDurgeUeR2Php5P3g0vsi3cfTter1/xOB5YQoP3tyKn3Sfn0dIoz
         uSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699981171; x=1700585971;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n4sXfTyg8Vd+fH28/bM1upjRiAGrdu4tuUb86E8h+EI=;
        b=Ekre+DbV7TxvA8jRc5KWNYotU7fiZ0qKNc0ucDxXtN0eDcrsWCxVPPIMjJz2L3m6qc
         1Z5GPhsxEDmp0oxtSqNJbEcR6TLGrR9mtjkKPXy8cfomXXbDSh4rG1qckmb4jA2Covae
         fahvtoUwuk9VUCqFBPU9GDTFHFqt+Q+3cZVDHTqW1RVM2MgxUtwbFk9MqZzZ1+a75czS
         ePbew0u47JpEMQ7ApDqAVgYB4c1X3RjvBr70EgJNmXAXRHhW+mX77U/jkr1xQMyrVzri
         +bSFrvj1qc1uQTQTVYqh7rHfMXAu68zo7PDosfnLNL5nilzXWE4uy+aqfXkbLc7OB6py
         pDXQ==
X-Gm-Message-State: AOJu0YyLwhi83FUwvj2CJkXfQPvfyLl94wrDteagBGNMXhAnEEKI/3B1
	8od8S7Coi/gO6MYgdkzePwbgdQRL0nDpe9Ypnn1N7w==
X-Google-Smtp-Source: AGHT+IEc8fXjx6pNCmGlh9v9jp8O/GR6EgQ6OyCWG1A8cNDbFzKgE0WvgH37SVw/bAVzdg+SNYhlnQ==
X-Received: by 2002:a05:6358:729:b0:16b:c3ef:3686 with SMTP id e41-20020a056358072900b0016bc3ef3686mr3264831rwj.0.1699981171135;
        Tue, 14 Nov 2023 08:59:31 -0800 (PST)
Received: from [172.25.84.204] ([12.186.190.1])
        by smtp.gmail.com with ESMTPSA id u16-20020ac87510000000b004033c3948f9sm2850712qtq.42.2023.11.14.08.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 08:59:30 -0800 (PST)
Message-ID: <17b0bb80-c6de-4d97-b770-c4a5f5d60b7c@kernel.dk>
Date: Tue, 14 Nov 2023 09:59:29 -0700
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
Subject: [PATCH] io_uring/fdinfo: remove need for sqpoll lock for thread/pid
 retrieval
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit added a trylock for getting the SQPOLL thread info via
fdinfo, but this introduced a regression where we often fail to get it if
the thread is busy. For that case, we end up not printing the current CPU
and PID info.

Rather than rely on this lock, just print the pid we already stored in
the io_sq_data struct, and ensure we update the current CPU every time we
are going to sleep. The latter won't potentially be 100% accurate, but
that wasn't the case before either as the task can get migrated at any
time unless it has been pinned at creation time.

We retain keeping the io_sq_data dereference inside the ctx->uring_lock,
as it has always been, as destruction of the thread and data happen below
that. We could make this RCU safe, but there's little point in doing that.

With this, we always print the last valid information we had, rather than
have spurious outputs with missing information.

Fixes: 7644b1a1c9a7 ("io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f04a43044d91..5a7bfeafa0a3 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -145,13 +145,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
 		struct io_sq_data *sq = ctx->sq_data;
 
-		if (mutex_trylock(&sq->lock)) {
-			if (sq->thread) {
-				sq_pid = task_pid_nr(sq->thread);
-				sq_cpu = task_cpu(sq->thread);
-			}
-			mutex_unlock(&sq->lock);
-		}
+		sq_pid = task_pid_nr(sq->thread);
+		sq_cpu = task_cpu(sq->thread);
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..4ffa1052261a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -291,6 +291,7 @@ static int io_sq_thread(void *data)
 			}
 
 			if (needs_sched) {
+				sqd->sq_cpu = task_cpu(current);
 				mutex_unlock(&sqd->lock);
 				schedule();
 				mutex_lock(&sqd->lock);

-- 
Jens Axboe


