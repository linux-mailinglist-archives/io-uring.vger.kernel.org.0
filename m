Return-Path: <io-uring+bounces-89-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C607EBB3A
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 03:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CABB2813A0
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 02:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70C2395;
	Wed, 15 Nov 2023 02:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R1QvD+i0"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3564A644
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 02:36:28 +0000 (UTC)
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE0CA
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 18:36:25 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1d542f05b9aso791537fac.1
        for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 18:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700015784; x=1700620584; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUDc1vpikaFNAiIyxk/mFuQQAyr08NowZAD05BhrFLM=;
        b=R1QvD+i04/LrYCF5hsi0+cngPpIupHKdwa/liJaAI/Ev49k7lGalKiJfyJf6f+gnvM
         vutJHP4nk3nb/C89l0wfjhzzqlPH/K/sy2qCCHVAnmwxKqcJETa8ws9q/iwvEXzj6xeY
         nyxWvSxrEd8mt+fb8ZlYGkUvA00H4k3xNYwA+9S4ZIckUFjFJpTnzK/1PbbRS884nZ3u
         Y5A9D+NhMmowUneWrdcZ+v29Fe31mnX3G14J/47LhQRtKGhx3LPz0ylH3jPlEmcTLg69
         X9sijoo5hu07QL2p1ETUzQmH7fVboE/U2uf38eapReALIX3IiE8X/dl/r4NM9uXIXe3K
         zugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700015784; x=1700620584;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lUDc1vpikaFNAiIyxk/mFuQQAyr08NowZAD05BhrFLM=;
        b=cqFyi7mPd6b2xo52H6j6oUA66lk5RvoTIr7HVkVaPRzoH0OLPKQCB0CZjlNrXAu4Fn
         bzE2mMfDSsw4gM4fHt0+MR27nvUGZrDYauVXSCpl7U6ut7SmTygnMDVaKb+EuNshpeiY
         EzLDX9cOqUvG/67m/kZxeZWWdQPSeW6GBhOoVMcb79nDdNWhRYSz1svrJyLMGpPea+og
         gDq+s6rTg1BOpnF4kW2TwwThPf6Iz1RR8DsTUkPKxWThKN9Hp6b/fxlQKLTSN4RstjCX
         up1q9CzsN5Lx/W6nQ8GKrI2u+LxsL7QwBNo6/wbsik2592HJF4/vMFexy1830wASRlkO
         EVLg==
X-Gm-Message-State: AOJu0YzveSge2Smvr13K1yiWmYdqffR+TgAukXOpRySjlhMiewfKX+BN
	o7pvMKKetw5uSxSwqZM8Laj0TenhY7mJqGa8sPLb8A==
X-Google-Smtp-Source: AGHT+IGCGVoPUaOztGN3Mhtpl2eMXaD6UYJZV3XRtNF8JGhSxVasRwm+xzpF6KgKC4GyAf6Je/24zQ==
X-Received: by 2002:a05:6358:881:b0:16b:f554:ac74 with SMTP id m1-20020a056358088100b0016bf554ac74mr4087634rwj.1.1700015784396;
        Tue, 14 Nov 2023 18:36:24 -0800 (PST)
Received: from ?IPV6:2600:380:916a:612a:1723:80aa:a58a:abfa? ([2600:380:916a:612a:1723:80aa:a58a:abfa])
        by smtp.gmail.com with ESMTPSA id w19-20020ac843d3000000b0041991642c62sm3169212qtn.73.2023.11.14.18.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 18:36:23 -0800 (PST)
Message-ID: <ffbbe596-c6a9-42ed-9156-e6d5c21eca9b@kernel.dk>
Date: Tue, 14 Nov 2023 19:36:22 -0700
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
Subject: [PATCH v3] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit added a trylock for getting the SQPOLL thread info via
fdinfo, but this introduced a regression where we often fail to get it if
the thread is busy. For that case, we end up not printing the current CPU
and PID info.

Rather than rely on this lock, just print the pid we already stored in
the io_sq_data struct, and ensure we update the current CPU every time
we've slept or potentially rescheduled. The latter won't potentially be
100% accurate, but that wasn't the case before either as the task can
get migrated at any time unless it has been pinned at creation time.

We retain keeping the io_sq_data dereference inside the ctx->uring_lock,
as it has always been, as destruction of the thread and data happen below
that. We could make this RCU safe, but there's little point in doing that.

With this, we always print the last valid information we had, rather than
have spurious outputs with missing information.

Fixes: 7644b1a1c9a7 ("io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v3: just use raw_smp_processor_id(), no need to query the task as it's
    the current one. also update it whenever we've re-acquired the lock
    after schedule or preemption, as it's cheap enough now to do so.

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f04a43044d91..976e9500f651 100644
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
+		sq_pid = sq->task_pid;
+		sq_cpu = sq->sq_cpu;
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..a604cb6c5272 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -214,6 +214,7 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 			did_sig = get_signal(&ksig);
 		cond_resched();
 		mutex_lock(&sqd->lock);
+		sqd->sq_cpu = raw_smp_processor_id();
 	}
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
@@ -229,10 +230,12 @@ static int io_sq_thread(void *data)
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
-	if (sqd->sq_cpu != -1)
+	if (sqd->sq_cpu != -1) {
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
+	} else {
 		set_cpus_allowed_ptr(current, cpu_online_mask);
+		sqd->sq_cpu = raw_smp_processor_id();
+	}
 
 	mutex_lock(&sqd->lock);
 	while (1) {
@@ -261,6 +264,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				cond_resched();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			continue;
 		}
@@ -294,6 +298,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				schedule();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				atomic_andnot(IORING_SQ_NEED_WAKEUP,
-- 
Jens Axboe


