Return-Path: <io-uring+bounces-9585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9E7B45273
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2030584C38
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 09:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3212857E0;
	Fri,  5 Sep 2025 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XQQ8LwjK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A428469C
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 09:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062984; cv=none; b=iCutdj6VENNCCW/rffVrDxhJDYWcAw81hoMfsQaaV+nD/r/+2HgcQEwh8HAXsEFn6k/LiqhkMYn3qfnp7+Yof2WwBHmQQsw4K0Aat2WECzfqL5hLsiRtUqz8kta9N7If0BOLVpGMCfV2E3WzrJC53uk+3KBJGLsjqQaj0Y4zRQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062984; c=relaxed/simple;
	bh=PqS+1LjKbOZFfXeOLZ4D+nEV7+N2cBwmDrpXGJ9QeaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lJqiYrvHhzL3iH6GPQXMlN+n6XVM312Nx1vDan7mM9RhPi6WR/xCZCntBw3yVaPkoE6IOXF/9A6uf4YLP7BtEG6SRwdaWh+39ylEdh6DrcdmyO1Lo0oo2D9BvYp1o3g4ItA1qKkxzlH04Vl0gJ5QTBJQL5gviCgVEqrSsK53frA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XQQ8LwjK; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45dda7d87faso1882485e9.2
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 02:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062980; x=1757667780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QLmNojkhKQr+ZfpCW6o90Nh9aVEoHIgPx0cWvx9O/2o=;
        b=XQQ8LwjKQazzFndC+TSyFmLYU4SCzB4fJsTlIsV3ut9io8OwqseWGWtZXDyCL52ytd
         XmACSVSVb3DW9cLqLNEWg7ou7f2kydf4o2O0d0Fs7TxG/Vhk7HiqPLb4LwQf9AvFnUEg
         C4+jger+9czKmvlc/XhwU62nNWIKlGbt+9bpQdi6sXpIJto3N0Utuqan5jU1Pvc4Xes+
         XzMnIfwNP9C9bARZyB9itOOHU0cz0fvNHK5xglhZDlAqvAggnYEJw6WQeVombT04Vwlf
         QDFPfw2Ej3pLZX1I7Q4taD4v9AOQLGBaSWOkJ7mWI5t7iF5uwtFC+ZlnUtf8b3NrW07C
         CnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062980; x=1757667780;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLmNojkhKQr+ZfpCW6o90Nh9aVEoHIgPx0cWvx9O/2o=;
        b=O7w5dN5RFnkVjWjcJnL16JfwO+VX1MPZ5fp23/ZjFcMyA/2HHc4a6gbD9+9dJbYmxj
         kRKD3C6siM5Nqhy+vKT8OPw8WrFW1noYTj0sbzIec21Ol17iLFbh+DflAHtjzDYqNmtZ
         U0OpqdPZJZ17pT4coiQApWTouLAUwKHhWXz4r5TAQNFgrw5hZMmILd1BxnA+XVnv+VSd
         HIWQIJNPuCF4Ql5NilvxfUvGa6IMf8KXWzMID3oJVcb1rVw/Ryya9CGqSZILjdHpUpNJ
         +YU/gO7t44chYqR68KQKojW5rerwJqInDd3hgtWrSXWdkFNQLwamkkP3KLrfT1JbV3cB
         gMRw==
X-Forwarded-Encrypted: i=1; AJvYcCUA+Y+NGlQf2w8a8IHePEYYEBLhEBpMYur9sxtpcb1dC80zaDAC/h+JVF/jnn4/lT/o/lUr2ihBYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHODsKDSuaKdpCw9W32hGCJ3zjM3p5H/EteNdFwvgUmTB6L35o
	olqlzJV8ScUyXA9934aZ5RSuPLUM/5+oh2kOBZETksXiS7juFxIpuKTO9Jfcrsous+Q=
X-Gm-Gg: ASbGncuWB+WeDpa+sCCRidsMrv8zIH/bT0n74wigKetx7sEHd6pbF84rsziJPJ9VExL
	0P6FHY06h3TV5havq5D5+93auS2CXyZzpBpb2J72P4ukOkLzWbKFEZ8y3yAISlMeOk8AX+z9XjU
	1QH8GEp8lVcufUZwBUKQIBLMx70bqBNzBa+Iz3wjHtHKTP22fdKMktgP9J0gEfhojXoF1IchEMX
	4pWBxWVgFtwh5cOwwXaqZQIa+6PyRjLGfCwOC2TapozwzXBW8AW+xaW1CCXKvU4RY01pEaU7U+K
	Asi47T+yJLzmiQ7TmIvXnrWJE3Be4wk0Lu9gZa8x2Mh4AVeRhN3GrpW7MZgtWAPxKQ6Q0LDqo4I
	Kn/aT8J4xtmyhXy4Ep/PdGVfOmD9rMSbwx3T+PqgSOFue+sY=
X-Google-Smtp-Source: AGHT+IFJDeW/8tfML5qSKSXOQzK9oSLt5fWvP4818XXNHL6v4h7OHzowEX79FOVh/ifKvJcru8KA/A==
X-Received: by 2002:a05:600c:c4ac:b0:450:6b55:cf91 with SMTP id 5b1f17b1804b1-45b85525d98mr188143075e9.6.1757062980009;
        Fri, 05 Sep 2025 02:03:00 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d66b013b7dsm19653105f8f.28.2025.09.05.02.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:02:59 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/2] io_uring: replace wq users and add WQ_PERCPU to alloc_workqueue() users
Date: Fri,  5 Sep 2025 11:02:38 +0200
Message-ID: <20250905090240.102790-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi!

Below is a summary of a discussion about the Workqueue API and cpu isolation
considerations. Details and more information are available here:

        "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
        https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/

=== Current situation: problems ===

Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an isolated
CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

=== Plan and future plans ===

This patchset is the first stone on a refactoring needed in order to
address the points aforementioned; it will have a positive impact also
on the cpu isolation, in the long term, moving away percpu workqueue in
favor to an unbound model.

These are the main steps:
1)  API refactoring (that this patch is introducing)
    -   Make more clear and uniform the system wq names, both per-cpu and
        unbound. This to avoid any possible confusion on what should be
        used.

    -   Introduction of WQ_PERCPU: this flag is the complement of WQ_UNBOUND,
        introduced in this patchset and used on all the callers that are not
        currently using WQ_UNBOUND.

        WQ_UNBOUND will be removed in a future release cycle.

        Most users don't need to be per-cpu, because they don't have
        locality requirements, because of that, a next future step will be
        make "unbound" the default behavior.

2)  Check who really needs to be per-cpu
    -   Remove the WQ_PERCPU flag when is not strictly required.

3)  Add a new API (prefer local cpu)
    -   There are users that don't require a local execution, like mentioned
        above; despite that, local execution yeld to performance gain.

        This new API will prefer the local execution, without requiring it.

=== Introduced Changes by this series ===

1) [P 1-2] Replace use of system_wq and system_unbound_wq

        system_wq is a per-CPU workqueue, but his name is not clear.
        system_unbound_wq is to be used when locality is not required.

        Because of that, system_wq has been renamed in system_percpu_wq, and
        system_unbound_wq has been renamed in system_dfl_wq.

=== For Maintainers ===

There are prerequisites for this series, already merged in the master branch.
The commits are:

128ea9f6ccfb6960293ae4212f4f97165e42222d ("workqueue: Add system_percpu_wq and
system_dfl_wq")

930c2ea566aff59e962c50b2421d5fcc3b98b8be ("workqueue: Add new WQ_PERCPU flag")


Thanks!

Marco Crivellari (2):
  io_uring: replace use of system_wq with system_percpu_wq
  io_uring: replace use of system_unbound_wq with system_dfl_wq

 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.51.0


