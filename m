Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFA6342DD4
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 16:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhCTPiv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhCTPik (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 11:38:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748D5C061762
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 08:38:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so6348790pjb.0
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 08:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t1wyaEbIk1qk0jXhKLmoLck1wU+dWQUF616kERbYpQs=;
        b=Eb9qXvJiuYFJhsn0CTFvgkOQVuNoyVsIG538Q+8gMLiJ12uX5nJSUWQ2OFIF407UME
         /KVwPO9MlD2aflU7Kh/H02L5ac5K/OaT/xP0h7ko3o5GRT56BR4ybSOJmYrrvmH9/K3o
         Mgckj36yYUHcpfx5W9kF8MAQXeQsTkNY4nxwzKk44yA4TL++Mbquciw/RrRUoXuiFxO4
         uWp+96cfDvFG9bvCKgwQeoG48ZJUePE0G1Z0KIWjpPRsdMjM/P9Jq9FDzxmeXF7wmUeg
         tbPQh2FLBUUy+Dkfp1ZrOBxDNt3/yPWT/haq82NM7DtbFw+fS6arRXgtwfpViTjehJVz
         fK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t1wyaEbIk1qk0jXhKLmoLck1wU+dWQUF616kERbYpQs=;
        b=Sw1qLAZm+pSwkSFc6VoxLtmYcJeyUTKbSfo9whhjedW6NxATYyijS2Hcv44kznPLwd
         ze/W86erD+Y+EHpkEe3Co7fSpYyKR2cqwAkl2DrRi7S46p7uOWPOiTmdywR2OEy2M0EB
         sd+zB9a/NtOkz6rdoQM1Lusy5EnogWeuTMnGrBpC8YBLY53or/tBK+KUHy/kxmT0hg8+
         dBobcsBS+UVP1kKb8fntmY1P4xMWh6NRVATa7MJ6/uNGwqgOFk3Tkx0nzLEKyv+eI6ae
         lPwjznyY/gWu8lMfbt0diNifHM/awWK1vtb3tEdIabigmInc7V05yS0mb+CTAYcafycU
         X2JA==
X-Gm-Message-State: AOAM5313zcDIdssk44SJiE+ff3TufLmbE8H2ZMXiNiFDSJt8g044YpM+
        5mMrGof0mchPkPKwIoqilm5aXxyhaAZVRw==
X-Google-Smtp-Source: ABdhPJw3yAkRnonh4M7gT2S3CvQnqFk9tfVHpJ6jpCxpSgAsRyUL5S5j960lxdLtr05B62T2NOqntQ==
X-Received: by 2002:a17:90a:7061:: with SMTP id f88mr4165196pjk.56.1616254719515;
        Sat, 20 Mar 2021 08:38:39 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 2sm8658753pfi.116.2021.03.20.08.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:38:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
Date:   Sat, 20 Mar 2021 09:38:30 -0600
Message-Id: <20210320153832.1033687-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Been trying to ensure that we do the right thing wrt signals and
PF_IO_WORKER threads, and I think there are two cases we need to handle
explicitly:

1) Just don't allow signals to them in general. We do mask everything
   as blocked, outside of SIGKILL, so things like wants_signal() will
   never return true for them. But it's still possible to send them a
   signal via (ultimately) group_send_sig_info(). This will then deliver
   the signal to the original io_uring owning task, and that seems a bit
   unexpected. So just don't allow them in general.

2) STOP is done a bit differently, and we should not allow that either.

Outside of that, I've been looking at same_thread_group(). This will
currently return true for an io_uring task and it's IO workers, since
they do share ->signal. From looking at the kernel users of this, that
actually seems OK for the cases I checked. One is accounting related,
which we obviously want, and others are related to permissions between
tasks. FWIW, I ran with the below and didn't observe any ill effects,
but I'd like someone to actually think about and verify that PF_IO_WORKER
same_thread_group() usage is sane.

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 3f6a0fcaa10c..a580bc0f8aa3 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -667,10 +667,17 @@ static inline bool thread_group_leader(struct task_struct *p)
 	return p->exit_signal >= 0;
 }
 
+static inline
+bool same_thread_group_account(struct task_struct *p1, struct task_struct *p2)
+{
+	return p1->signal == p2->signal
+}
+
 static inline
 bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
-	return p1->signal == p2->signal;
+	return same_thread_group_account(p1, p2) &&
+			!((p1->flags | p2->flags) & PF_IO_WORKER);
 }
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5f611658eeab..625110cacc2a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -307,7 +307,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	 * those pending times and rely only on values updated on tick or
 	 * other scheduler action.
 	 */
-	if (same_thread_group(current, tsk))
+	if (same_thread_group_account(current, tsk))
 		(void) task_sched_runtime(current);
 
 	rcu_read_lock();


