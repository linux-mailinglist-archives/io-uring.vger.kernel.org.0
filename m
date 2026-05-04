Return-Path: <io-uring+bounces-13233-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMBPEHe9+Gnh0AIAu9opvQ
	(envelope-from <io-uring+bounces-13233-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:38:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7534C0C91
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80577301AB8B
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 15:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3BD3E0C78;
	Mon,  4 May 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJtKrQPi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFBE3E0C44
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 15:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909083; cv=none; b=F+uG7+Y8ouTvxpeB7SE5cMCQ8ecEoHz+c0fDl+6IuWB0Vkw+lpm/cM9NRrl8mkCh25QqyHrswVxMZsoIlQun9BDZdwuEAo7BMkNHj38f2NBvV13yB48NrKfw05j76g1VfYxKSqsRyb9XLlpqz7d/0q9Rjpx+x0GQFTRaZD+5P6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909083; c=relaxed/simple;
	bh=jO/ky83hpeaAgon9DQ5I41b1r9GxK7nleXrheD+rud0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NXbiUcXgQcnYg93ahJTYGr0fpzN9VbJPzfn8hofmeKjpUCihEJTI8t1lrtwbX6oYX6+lTC8CoPwkoi26oF3qJlg/i9JhV5M8rrqJVS8RvWFXwuOKsEPPdqfbWnsj4iwKuQoCD5xBo67rZOIG3Q3rQPvqBGKxA6m1+8VmK3kxwag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJtKrQPi; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso16908245ad.0
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 08:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777909082; x=1778513882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQgLbDmX+j3y6KiTh8+YyN+Fs0cvqV8hTtym1kOKLqc=;
        b=XJtKrQPiNHd0E8K4CZ0sW5qWsy/V9QkjsQvOXiGFWxDablrHShoso2KZjxugGnV17f
         Yu+H+iMkknTmWnB+/2i4o1hSZWj6WTCY2C+KE9jrfl3r305BujZumNqncSorND+A1za9
         pVzkksz5cSSt734rQH4eoiAqlz4S+PEYwJJ04RSWSgJOua5jNIU3mu5kNOyy3jCErkbA
         AefwVvypGlnSsCvQqgbN6sdz+LIEOIh+AhZdOONp3tAU33gc0HdluhKg4gcU6UNFXJ3W
         03SxIGIHLhjLM7V8DV9b5ASzfenZhguXok/M+Z2gr6X3JBJe3xCgiabhP7/+bMhbVvlj
         muZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777909082; x=1778513882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jQgLbDmX+j3y6KiTh8+YyN+Fs0cvqV8hTtym1kOKLqc=;
        b=DuJMZD4nqzzp/YP+hVo9vvktYgfijVgBFyrPeDX0h4Riyj/GzY+xp1d/mU/peZ0f9w
         n8bHeZ8S9z0N4j63DEzlhV3AIpBAVnpKfvVo4KFuO83eXQ6IqV8NF9RcQjQXHThuCAQj
         H9nDa4xuu/e3kZLWh6EHWI5pJB1ebFHEnTb2YywtrRCydW7Dj6PSq1bb3bgEX3T7XKHU
         IJdp46iKQuKiRMP7wivQ+meW7QkO9NvPPjyXoJ7iusYptkxqBJhJHLMD2PKpFVvHHsmi
         maCFUw9+2ly1O8lSLKZhJq7ltKYQZz4mnswmsF3wbcEPFEaaRcV4uTYpIqH7NWPmk68X
         znlg==
X-Forwarded-Encrypted: i=1; AFNElJ9zHSHOMlhLkHrvUkW2QRXu1S3XjsSmGEAfWgMh+s8E7tA6VJ09N5L5E8Q1H3L3tys2jiIm/x5ZLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwP5OTKx8lkuK2v+GBUyfQTvj7xEgQxfNTXnVaGRq2ouAaEfQ+r
	CptRkebrdc5zxBgPo/UjQZIwHLcEQ0mGupUvIQaeoCDLjXM2iWvmg4Hq
X-Gm-Gg: AeBDiese5/a9nphtvho4qTrj5UvNDDbisk5+3k89pSRfr5Lm1sHFDRftXbaRbLahCFd
	1ReBKi3Eqnsw5C01VDMSBkcVYGqOmhc9kxCKRcZoB9U/XUlhBobzDxOe6Yfra/vcidUqXUifc7b
	OCUkkOg/FUzKvTirrXU/6Z8ZhNihxXWQlqqcfAjic1D1+OIWehjIRhgpp2vGD5giy5fbPcbQ+sy
	uiGcah/FEB5qNwfdNFtap1JihezRFxqW89E5iI34vsTxluZbfAoXrKJUHL6Y5vpI14GJXjtlk4u
	MXFKrZLPS2LacGnB+ofTtRXXfImNKUC7MmbQPkIDYEXrXM4zvg5rqfAnHJVNG9wyWwiYiPOyDud
	tEjdJkwjD6whG8GNPbH6r5xO/2R0H5uGwfP1yLn9ePkYhsfvQecYOb1ydO8aw1zKHN7fYmRlvcE
	x7CKkwIgSFKWA3QWzkVDPic+YsLRSs1kEtXtTCK0QmjqMXG/Hbt5LuftVQT8k=
X-Received: by 2002:a17:903:13c8:b0:2ba:16be:cb6a with SMTP id d9443c01a7336-2ba16becf42mr55846145ad.9.1777909081476;
        Mon, 04 May 2026 08:38:01 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaaec82sm110364095ad.24.2026.05.04.08.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:38:00 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
X-Google-Original-From: Maoyi Xie <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring/timeout: honour caller's time namespace for IORING_TIMEOUT_ABS
Date: Mon,  4 May 2026 23:37:54 +0800
Message-Id: <20260504153755.1293932-2-maoyi.xie@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
References: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A7534C0C91
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13233-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyixietju@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ntu.edu.sg:mid,ntu.edu.sg:email,kernel.dk:email]

io_uring's IORING_OP_TIMEOUT and IORING_OP_LINK_TIMEOUT accept a
timespec from the caller via io_parse_user_time(). With
IORING_TIMEOUT_ABS, the timestamp is an absolute deadline on the
selected clock. The clock is CLOCK_MONOTONIC by default.
CLOCK_BOOTTIME and CLOCK_REALTIME are also selectable.

A submitter inside a CLONE_NEWTIME time namespace observes
CLOCK_MONOTONIC and CLOCK_BOOTTIME shifted by the namespace's
offsets relative to the host. Every other ABS timer interface in
the kernel converts the caller's absolute time to host view via
timens_ktime_to_host() before arming an hrtimer:

  kernel/time/posix-timers.c    -- timer_settime(TIMER_ABSTIME)
  kernel/time/posix-stubs.c     -- clock_nanosleep(TIMER_ABSTIME)
  kernel/time/alarmtimer.c      -- alarm_timer_nsleep(TIMER_ABSTIME)
  fs/timerfd.c                  -- timerfd_settime(TFD_TIMER_ABSTIME)

io_parse_user_time() does not. As a result, an absolute timeout
submitted from within a time namespace is interpreted in host
view. That is generally a different point in time. It may already
be in the past, causing the timer to fire immediately, or far in
the future, causing the timer not to fire when expected.

Reproducer: in unshare --user --time, with a -10s monotonic
offset, submit IORING_OP_TIMEOUT with IORING_TIMEOUT_ABS and
deadline = now + 1s. The CQE is delivered after <1ms instead of
the expected ~1s.

Apply timens_ktime_to_host() to the parsed time when
IORING_TIMEOUT_ABS is set. Split the existing clock id resolver
in io_timeout_get_clock() into a flags only helper
io_flags_to_clock(), so io_parse_user_time() can resolve the
clock without a struct io_timeout_data.

timens_ktime_to_host() is a no-op for clocks not affected by time
namespaces, e.g. CLOCK_REALTIME. It is also a no-op for callers
in the initial time namespace. The fast path is unchanged.

SQPOLL is also covered. The SQPOLL kernel thread is created via
create_io_thread() with CLONE_THREAD and no CLONE_NEW* flag.
copy_namespaces() therefore shares the submitter's nsproxy by
reference. Inside the SQPOLL kthread, current->nsproxy->time_ns
is the submitter's time_ns. timens_ktime_to_host() resolves
correctly.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
---
 io_uring/timeout.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4cfdfc519..e2595cae2 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/time_namespace.h>
 
 #include <trace/events/io_uring.h>
 
@@ -35,6 +36,22 @@ struct io_timeout_rem {
 	bool				ltimeout;
 };
 
+static clockid_t io_flags_to_clock(unsigned flags)
+{
+	switch (flags & IORING_TIMEOUT_CLOCK_MASK) {
+	case IORING_TIMEOUT_BOOTTIME:
+		return CLOCK_BOOTTIME;
+	case IORING_TIMEOUT_REALTIME:
+		return CLOCK_REALTIME;
+	default:
+		/* can't happen, vetted at prep time */
+		WARN_ON_ONCE(1);
+		fallthrough;
+	case 0:
+		return CLOCK_MONOTONIC;
+	}
+}
+
 static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
 {
 	struct timespec64 ts;
@@ -43,7 +60,7 @@ static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
 		*time = ns_to_ktime(arg);
 		if (*time < 0)
 			return -EINVAL;
-		return 0;
+		goto out;
 	}
 
 	if (get_timespec64(&ts, u64_to_user_ptr(arg)))
@@ -51,6 +68,9 @@ static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
 	if (ts.tv_sec < 0 || ts.tv_nsec < 0)
 		return -EINVAL;
 	*time = timespec64_to_ktime(ts);
+out:
+	if (flags & IORING_TIMEOUT_ABS)
+		*time = timens_ktime_to_host(io_flags_to_clock(flags), *time);
 	return 0;
 }
 
@@ -399,18 +419,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
 {
-	switch (data->flags & IORING_TIMEOUT_CLOCK_MASK) {
-	case IORING_TIMEOUT_BOOTTIME:
-		return CLOCK_BOOTTIME;
-	case IORING_TIMEOUT_REALTIME:
-		return CLOCK_REALTIME;
-	default:
-		/* can't happen, vetted at prep time */
-		WARN_ON_ONCE(1);
-		fallthrough;
-	case 0:
-		return CLOCK_MONOTONIC;
-	}
+	return io_flags_to_clock(data->flags);
 }
 
 static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
-- 
2.34.1


