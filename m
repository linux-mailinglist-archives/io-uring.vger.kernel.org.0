Return-Path: <io-uring+bounces-95-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2890D7EC897
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 17:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC145B20A83
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 16:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C35433BF;
	Wed, 15 Nov 2023 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0VWvJmhb"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5369B3BB57
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 16:30:59 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A5BD6A
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 08:30:56 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-420d2f40c69so1827651cf.1
        for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 08:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700065855; x=1700670655; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTezdbWkhfxCTLToejri+dX9aI7/Y/VQc6haWVH+GC0=;
        b=0VWvJmhbZ+CNw/gXaxgFq1GRGpEyanqO7hkEs9pGRMc0nibu4SJQS5AbR4IBxjl6qs
         QScugutHZqAUejlBlwhuXmDgLf70qll+I2wR+TC86DJe4XlFv0MFhkvc2TaE/UD2i0an
         Zpoc7TcPAyi7jK4oHP6SmpmU5C1ikIvf92c0ZxfiXufkLoUBfAQYbh3xeV0lbXkT9qSn
         9mqNrK9i/FCs3t6dNsxKaRxKyBgzwbij/RoSq1m5pmjJavEELYbeDEXw2JEFSJFH+9Im
         fT1IABT0nQ3WwZAIXJhjzjIIj7rPl9vVHvBfEofD8yTATfHXVYx7oNflf38VmOJZ4LeU
         snvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700065855; x=1700670655;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OTezdbWkhfxCTLToejri+dX9aI7/Y/VQc6haWVH+GC0=;
        b=PFCClGO+8iwpw2UJUZjUmV89sJukStjmR10VLQGsdmAXMnvPlGdl7i6hWN4Zq1buYy
         Mrrgzeb/31Erc4ZZnIGck7+/UZb03SrFddjiiaJFcri8qpDIQysZumyfXFCRMz5rVSh/
         2SRdbiONamR9GK+2p4rDEEJLqETVgSIsXmqyvnTI26jCoVXXxzK7i9TW+HXZLOun2G4T
         g6NP0EBLauIAw66JAJK6XawvGkEOzoQm0BO2JJPxe21/B78DFO+b/aDpB+bmqkx+1rjn
         l4px1gPq8EiiJRwSHxdftU8QuJOvyvF8LBGnfTcvyQuSjm0F7if1prPr48lXJxwCuz+p
         axAQ==
X-Gm-Message-State: AOJu0YwFignY9Vejjla9U9epg/uTTmc3wMxnFr7VzSNbeAyhRzMA18Rp
	gDRhwK+w74nd0THKx9N3azKsaoRJS3c2GU1ioojv9EbP
X-Google-Smtp-Source: AGHT+IHl8NA2G4eX1NUWXP5IJ5RVq5HMfxtV3pypfleIOBwngHf88GOCo55KOLvXY0eTNidN0YnGdg==
X-Received: by 2002:a0c:ed41:0:b0:65d:486:25c6 with SMTP id v1-20020a0ced41000000b0065d048625c6mr6105260qvq.3.1700065854839;
        Wed, 15 Nov 2023 08:30:54 -0800 (PST)
Received: from [172.25.84.204] ([12.186.190.1])
        by smtp.gmail.com with ESMTPSA id w3-20020a05620a444300b007788bb0ab8esm3577107qkp.19.2023.11.15.08.30.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 08:30:54 -0800 (PST)
Message-ID: <b71be7dc-70e4-423e-983c-6c1abaab2801@kernel.dk>
Date: Wed, 15 Nov 2023 09:30:52 -0700
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
Subject: [PATCH v4] io_uring/fdinfo: remove need for sqpoll lock for
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

v4: ensure task_pid is set appropriately at startup time

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
index bd6c2c7959a5..65b5dbe3c850 100644
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
@@ -229,10 +230,15 @@ static int io_sq_thread(void *data)
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
-	if (sqd->sq_cpu != -1)
+	/* reset to our pid after we've set task_comm, for fdinfo */
+	sqd->task_pid = current->pid;
+
+	if (sqd->sq_cpu != -1) {
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
+	} else {
 		set_cpus_allowed_ptr(current, cpu_online_mask);
+		sqd->sq_cpu = raw_smp_processor_id();
+	}
 
 	mutex_lock(&sqd->lock);
 	while (1) {
@@ -261,6 +267,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				cond_resched();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			continue;
 		}
@@ -294,6 +301,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				schedule();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				atomic_andnot(IORING_SQ_NEED_WAKEUP,

-- 
Jens Axboe


