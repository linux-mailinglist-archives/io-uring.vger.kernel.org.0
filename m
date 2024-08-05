Return-Path: <io-uring+bounces-2657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4C3948291
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 21:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DB502834A3
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 19:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12B316C69A;
	Mon,  5 Aug 2024 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZImGATju"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA28166307;
	Mon,  5 Aug 2024 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722887284; cv=none; b=Kieyz7hk55gsVZ0ATNKMUeFcmE6OyGz7Xhcpi/CALunyDDuL6d7Q8ll+HcYZiLhgDMzLzy1zFow5nEkxhqd088hNM0c+cfAJI9bera1DPUzoBbYcO8GMvXtc8AYuQU4Q/4kFDr99ufXcdPj56n2QtKuL3F8GiQZSG18Wia+OwZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722887284; c=relaxed/simple;
	bh=gkgIZP6fBWDwUAH0K0yuPdRvWvEbBVnAozZ+S1nGW/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jzp2Yq6zi+9YHOJlf8tp6wYADrb535jvfbvO12oSx2T3/9jppYqlg/Azbh4cT/FTv1ZrwHblx4Q5UJGLdLyfjA5f7KO5F0lxlUIRy2W1cu/emxueYMNH76703TJ12oSDP4tXE0uAzh1/KblbSAohgDzK/pdYN4tttg02ByuiHfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZImGATju; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fda7fa60a9so100642385ad.3;
        Mon, 05 Aug 2024 12:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722887282; x=1723492082; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mtQZE0bROS8UEZPvM20hoqj5TusWjzQnd1NBq/PztJw=;
        b=ZImGATjuMwxZY9DtTGHAD75IXtYnNjnGJ4uAhvnxuvjMFMqD2PcMg1opsA41cFUkbN
         pnthTDmVy7tNch/zrWr63Cq97CN9BnfN0mc1v9Ec01wbcEtlU3bZKCFzu0S92iCA1Wkq
         /muuTS9jJFvohfLoxVcjYEqJeaRJDrFb3d/w11YivcR4sI3QPrsUfK4IyXiRupG4xx3w
         wfy9wbVuZ/vX2KI6wUPEEye/eHqyjo+WRqQhU4KzSTsgzwZkPSfVWYzT2sziofX8gnAQ
         D1+ktz5vzO71E0gsSI7t3CdixCp02LniKhCq9+mnCQ594eIfqg/BqN0eatA/PluI3fLF
         q9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722887282; x=1723492082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtQZE0bROS8UEZPvM20hoqj5TusWjzQnd1NBq/PztJw=;
        b=EMVQFwsdXSqEqIXtnzMTnZTZlT6p1/6FJ72QLbhWJT5wZTW24OWgls4C4oC5EV4pE0
         yh11MBdcgvQY2QCJDaaEMlGG8K/bhm/JRjQcnf6Lx1OIWG3AW/NC1XrnIZWGkCP4RJw6
         5wD+RJCWCAhnvm+1nI6NxvQ9fl62ffKIOgXg2TsfXnEh8IF5nwKfp/YEmFIA/4onh/7N
         uH+KhYZSEQK0ogg/IovtWhkybN7ukpbr3fa6HUM9CZhe74/K3KSzBdOAyK584+Z+lDfG
         4ay/Y5HeNXqjG+2bizuLpijiQ+Byh97fAVxr1JgxHR7jNwvE48N2Nhqkj6kqnXWBQ06Y
         8Zig==
X-Forwarded-Encrypted: i=1; AJvYcCWw2WbLkU7Mo9W6upKqUfxEM5Gg/x77498ZJieY4WGVL3gVaS5W3/2U6vyjMfkJ/+Mhe08Bh6AXQQ==@vger.kernel.org, AJvYcCXRqnDHS3UElzbkjOeXLheKEiDSiavgWCQ6Lo4szjj9Ksye9c14POYLh6P2O6XzT6xGEN1y6zSFPVv7toYv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1KdQAfcj8r/CgB+C6BoAzZ4N93EX24vKoIXyfZcgs+Yj+WWBv
	wsRkAE+G8FZlBgx9xbBAkk6WfFjjX/AHszDawSPWORx3lHDdEQAUEU3GLg==
X-Google-Smtp-Source: AGHT+IGoJBly2rb0+/rWatMjqOlw2VEIqxv01Oa9uEYSjPWnocWXSaDJW+T69Lx3p0JzpyQ7/H8dtA==
X-Received: by 2002:a17:902:f693:b0:1fd:82ac:7c2e with SMTP id d9443c01a7336-1ff57297afamr174902155ad.25.1722887282221;
        Mon, 05 Aug 2024 12:48:02 -0700 (PDT)
Received: from localhost (dhcp-72-235-129-167.hawaiiantel.net. [72.235.129.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5917496fsm72278125ad.182.2024.08.05.12.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 12:48:01 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 5 Aug 2024 09:48:00 -1000
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Lai Jiangshan <jiangshanlai@gmail.com>
Subject: [PATCH wq/for-6.11-fixes] workqueue: Fix spruious data race in
 __flush_work()
Message-ID: <ZrEscJJjqAOpyWUY@slm.duckdns.org>
References: <000000000000ae429e061eea2157@google.com>
 <8ada52ac-48e9-48cd-afa0-c738cf25fe4f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ada52ac-48e9-48cd-afa0-c738cf25fe4f@kernel.dk>

From c5eac4d10384f1ddd728e143ede35eaa6081c61e Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 5 Aug 2024 09:37:25 -1000

When flushing a work item for cancellation, __flush_work() knows that it
exclusively owns the work item through its PENDING bit. 134874e2eee9
("workqueue: Allow cancel_work_sync() and disable_work() from atomic
contexts on BH work items") added a read of @work->data to determine whether
to use busy wait for BH work items that are being canceled. While the read
is safe when @from_cancel, @work->data was read before testing @from_cancel
to simplify code structure:

	data = *work_data_bits(work);
	if (from_cancel &&
	    !WARN_ON_ONCE(data & WORK_STRUCT_PWQ) && (data & WORK_OFFQ_BH)) {

While the read data was never used if !@from_cancel, this could trigger
KCSAN data race detection spuriously:

  ==================================================================
  BUG: KCSAN: data-race in __flush_work / __flush_work

  write to 0xffff8881223aa3e8 of 8 bytes by task 3998 on cpu 0:
   instrument_write include/linux/instrumented.h:41 [inline]
   ___set_bit include/asm-generic/bitops/instrumented-non-atomic.h:28 [inline]
   insert_wq_barrier kernel/workqueue.c:3790 [inline]
   start_flush_work kernel/workqueue.c:4142 [inline]
   __flush_work+0x30b/0x570 kernel/workqueue.c:4178
   flush_work kernel/workqueue.c:4229 [inline]
   ...

  read to 0xffff8881223aa3e8 of 8 bytes by task 50 on cpu 1:
   __flush_work+0x42a/0x570 kernel/workqueue.c:4188
   flush_work kernel/workqueue.c:4229 [inline]
   flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
   ...

  value changed: 0x0000000000400000 -> 0xffff88810006c00d

Reorganize the code so that @from_cancel is tested before @work->data is
accessed. The only problem is triggering KCSAN detection spuriously. This
shouldn't need READ_ONCE() or other access qualifiers.

No functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com
Fixes: 134874e2eee9 ("workqueue: Allow cancel_work_sync() and disable_work() from atomic contexts on BH work items")
Link: http://lkml.kernel.org/r/000000000000ae429e061eea2157@google.com
Cc: Jens Axboe <axboe@kernel.dk>
---
Applied to wq/for-6.11-fixes.

Thanks.

 kernel/workqueue.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d56bd2277e58..ef174d8c1f63 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4166,7 +4166,6 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 static bool __flush_work(struct work_struct *work, bool from_cancel)
 {
 	struct wq_barrier barr;
-	unsigned long data;
 
 	if (WARN_ON(!wq_online))
 		return false;
@@ -4184,29 +4183,35 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	 * was queued on a BH workqueue, we also know that it was running in the
 	 * BH context and thus can be busy-waited.
 	 */
-	data = *work_data_bits(work);
-	if (from_cancel &&
-	    !WARN_ON_ONCE(data & WORK_STRUCT_PWQ) && (data & WORK_OFFQ_BH)) {
-		/*
-		 * On RT, prevent a live lock when %current preempted soft
-		 * interrupt processing or prevents ksoftirqd from running by
-		 * keeping flipping BH. If the BH work item runs on a different
-		 * CPU then this has no effect other than doing the BH
-		 * disable/enable dance for nothing. This is copied from
-		 * kernel/softirq.c::tasklet_unlock_spin_wait().
-		 */
-		while (!try_wait_for_completion(&barr.done)) {
-			if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-				local_bh_disable();
-				local_bh_enable();
-			} else {
-				cpu_relax();
+	if (from_cancel) {
+		unsigned long data = *work_data_bits(work);
+
+		if (!WARN_ON_ONCE(data & WORK_STRUCT_PWQ) &&
+		    (data & WORK_OFFQ_BH)) {
+			/*
+			 * On RT, prevent a live lock when %current preempted
+			 * soft interrupt processing or prevents ksoftirqd from
+			 * running by keeping flipping BH. If the BH work item
+			 * runs on a different CPU then this has no effect other
+			 * than doing the BH disable/enable dance for nothing.
+			 * This is copied from
+			 * kernel/softirq.c::tasklet_unlock_spin_wait().
+			 */
+			while (!try_wait_for_completion(&barr.done)) {
+				if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+					local_bh_disable();
+					local_bh_enable();
+				} else {
+					cpu_relax();
+				}
 			}
+			goto out_destroy;
 		}
-	} else {
-		wait_for_completion(&barr.done);
 	}
 
+	wait_for_completion(&barr.done);
+
+out_destroy:
 	destroy_work_on_stack(&barr.work);
 	return true;
 }
-- 
2.46.0


