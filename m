Return-Path: <io-uring+bounces-529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F415984ADDF
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 06:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB23B286500
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 05:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3BC07F461;
	Tue,  6 Feb 2024 05:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e8XGelKa"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A817E782
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 05:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707196685; cv=none; b=qCQB7UChK2QKr46LE+h+6M9pQQb50djEw5Swl+in324hC58S9ZPwAMwhaO5QqQ/DSVP6tYzBHLp0MFHoudkCULs9d78uDD7Pcd1IY752rVv/3RaEZ+3juDaHjnw+3jZStpWUKEnf074R3Yfv1LS7tUJHU/oJTfN5r5YndusGqoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707196685; c=relaxed/simple;
	bh=nNeiNiP3tjJmb4yvijRt/0TWZlIQomBFXUF7FCgmof4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=hfd7gP56SYbzcb26VJuDtxHC6GVtRucBwkGx1r8CKamGT1OyiaoyYmWCT+6LgNlXUe8Azkj8tdAjQ8j1gLR0ONWOmcro/bvtfT7Cu3Ihx7fTOt6wGqWK/n0JHsopJB+Jf2U2+iNaCzIL7LlBxxntYdHnzFIYjyNbsRDImsztpiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e8XGelKa; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240206051800epoutp01ec52c3c8edda0bc01dd48f8caa266dde~xLlYFYKJE0827308273epoutp011
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 05:18:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240206051800epoutp01ec52c3c8edda0bc01dd48f8caa266dde~xLlYFYKJE0827308273epoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707196680;
	bh=+DSJZHkbi32erCjMa1jaWBnuwhUiT1XuJLtRXHt6IiQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=e8XGelKa+dw9T3590DAUDh0Yj7WSMTQVcjwBhw5mNlJfycNCOtkZl50gmAk/CjI9+
	 ttJ0Z+tT4z+Yav/pVkiVf9QO1/BhlpJ4RAyzcM35s3FQdrYhZ57oucrFGLJxwVlMJk
	 EnWP0IiAG/Ym0mcwit0ctYkOwExlpaSXFIKw9A2A=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240206051800epcas5p337e223055ed64ff864b42bcb43f86a2b~xLlXt_A231300413004epcas5p3F;
	Tue,  6 Feb 2024 05:18:00 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TTWjL3sbWz4x9Q1; Tue,  6 Feb
	2024 05:17:58 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BB.C2.09634.601C1C56; Tue,  6 Feb 2024 14:17:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240206024726epcas5p1d90e29244e62ede67813da5fcd582151~xJh58usjF0334403344epcas5p1U;
	Tue,  6 Feb 2024 02:47:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240206024726epsmtrp17d46a5a1e85430ea5ab68bbc878b11e5~xJh575G0n3103231032epsmtrp1I;
	Tue,  6 Feb 2024 02:47:26 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-7d-65c1c10649ad
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.33.08755.DBD91C56; Tue,  6 Feb 2024 11:47:25 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240206024724epsmtip121b035f45530fd4aca5b365d1ab2558e~xJh4dEj062086820868epsmtip1Q;
	Tue,  6 Feb 2024 02:47:24 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v8] io_uring: Statistics of the true utilization of sq
 threads.
Date: Tue,  6 Feb 2024 10:39:10 +0800
Message-Id: <20240206023910.11307-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmpi7bwYOpBtc7JS3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5x
	ia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGm46zzAWvVSve9mxhbWDcJ9fFyMkh
	IWAiMWX9UtYuRi4OIYHdjBJPPl9nh3A+MUpcO3ccyvnGKLF/02kmmJaVk6dBtexllOi7vo8d
	JCEk8JJR4mFXCojNJqAtcX1dFyuILQJkv348lQWkgVlgCZPE1m+HwSYJCwRK3Dl8Dcjm4GAR
	UJV4dVIKJMwrYCPx+O9Jdohl8hL7D55lhogLSpyc+YQFxGYGijdvnc0MMlNCoJdD4tDG71DX
	uUgc2/iUEcIWlnh1fAvUICmJl/1tUHaxxJGe76wQzQ2MEtNvX4VKWEv8u7KHBeQgZgFNifW7
	9CHCshJTT61jgljMJ9H7+wnULl6JHfNgbFWJ1ZceskDY0hKvG35DxT0kDj3pZIUEUKzEyvt/
	2SYwys9C8s8sJP/MQti8gJF5FaNkakFxbnpqsWmBYV5qOTxmk/NzNzGCk6qW5w7Guw8+6B1i
	ZOJgPMQowcGsJMJrtuNAqhBvSmJlVWpRfnxRaU5q8SFGU2AYT2SWEk3OB6b1vJJ4QxNLAxMz
	MzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamDi7V9z/fmHFlT/nwg2Db16b+zpX
	i+XvUvX8K9bnlk3TTf0f+9LqbR3Xmt6tpUwzulWFAljkuFVzlt3sXdzYZLvuQt0FZ+OszMWb
	lzzp6Tma9fLCTKl8NrlT39sWlMlalBc4bHPcdceo9+5t3W0nTsq7PbWpPSwSNPWD1pH/H9b8
	suFx/8ostivHetfcmm97uY/ueLZZIGPf0Z3bHtz7PjFywo6ZnPyP+3fXhr6efvFdU+JK+V8p
	00JNs3b85V/+/q+48YpWdr3zc1v69q36ureNv+tZ78fV+yKKzCZudXshOfmV4p2T3449/vOk
	5GFbfLvQ+jlbpLzUvp/Se3jP3Kh8c/WXHx8Yblq+DHVhLm52VmIpzkg01GIuKk4EAAb8ZsYz
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSnO7euQdTDVr2WlnMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8abjrPMBa9V
	K972bGFtYNwn18XIySEhYCKxcvI01i5GLg4hgd2MErtOdjN2MXIAJaQl/vwph6gRllj57zk7
	RM1zRonJ3/6xgiTYBLQlrq/rYgWpFxHQlWi8qwBSwyywgUli/9N5YHFhAX+Jm/NsQUwWAVWJ
	VyelQDp5BWwkHv89yQ4xXl5i/8GzzBBxQYmTM5+wgJQzC6hLrJ8nBBJmBipp3jqbeQIj/ywk
	VbMQqmYhqVrAyLyKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4CrQ0dzBuX/VB7xAj
	EwfjIUYJDmYlEV6zHQdShXhTEiurUovy44tKc1KLDzFKc7AoifOKv+hNERJITyxJzU5NLUgt
	gskycXBKNTB5Pzp1Zt3SvZVbW5LL1j7J0dkTcMRlUsjv9asM9Oz4veZEmZWUx6hstwhOaW2Z
	+nyj8sXbwtF58ecF9uhzfi+/nvU1xvr63AXLI65LTX/k9eSLmLqbxjmpmaZrJ8/4tOSGaqh+
	73HW2Fq+xa+Dui7l2u1WN724b8U5TdE5KQLeoT/+L5LL3NT2/HnDNtPVLHdvzU9a584yIXO1
	x77LxzbZGMst+f3JI36ORr18Yd8S7+2a9/2MNZrNXtwxPXRxv9Bh/jkqFgkHzv5O3s+u/r7l
	ZbTTMseb6QLs3Wei2xeYBJxhyHpQ4PlCPILFXDeh5PSn+F9Ln6Z9lJsomLQjWlb1jJxl1bHd
	klYLEzzXnTiqxFKckWioxVxUnAgAFtbL3/ECAAA=
X-CMS-MailID: 20240206024726epcas5p1d90e29244e62ede67813da5fcd582151
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240206024726epcas5p1d90e29244e62ede67813da5fcd582151
References: <CGME20240206024726epcas5p1d90e29244e62ede67813da5fcd582151@epcas5p1.samsung.com>

Count the running time and actual IO processing time of the sqpoll
thread, and output the statistical data to fdinfo.

Variable description:
"work_time" in the code represents the sum of the jiffies of the sq
thread actually processing IO, that is, how many milliseconds it
actually takes to process IO. "total_time" represents the total time
that the sq thread has elapsed from the beginning of the loop to the
current time point, that is, how many milliseconds it has spent in
total.

The test tool is fio, and its parameters are as follows:
[global]
ioengine=io_uring
direct=1
group_reporting
bs=128k
norandommap=1
randrepeat=0
refill_buffers
ramp_time=30s
time_based
runtime=1m
clocksource=clock_gettime
overwrite=1
log_avg_msec=1000
numjobs=1

[disk0]
filename=/dev/nvme0n1
rw=read
iodepth=16
hipri
sqthread_poll=1

---
The test results are as follows:
Every 2.0s: cat /proc/9230/fdinfo/6 | grep -E Sq
SqMask: 0x3
SqHead: 3197153
SqTail: 3197153
CachedSqHead:   3197153
SqThread:       9231
SqThreadCpu:    11
SqTotalTime:    18099614
SqWorkTime:     16748316

---
The test results corresponding to different iodepths are as follows:
|-----------|-------|-------|-------|------|-------|
|   iodepth |   1   |   4   |   8   |  16  |  64   |
|-----------|-------|-------|-------|------|-------|
|utilization| 2.9%  | 8.8%  | 10.9% | 92.9%| 84.4% |
|-----------|-------|-------|-------|------|-------|
|    idle   | 97.1% | 91.2% | 89.1% | 7.1% | 15.6% |
|-----------|-------|-------|-------|------|-------|

changes：
v8:
 - Get the work time of the sqpoll thread through getrusage

v7:
 - Get the total time of the sqpoll thread through getrusage
 - The working time of the sqpoll thread is obtained through ktime_get()

v6:
 - Replace the percentages in the fdinfo output with the actual running
time and the time actually processing IO

v5：
 - list the changes in each iteration.

v4：
 - Resubmit the patch based on removing sq->lock

v3：
 - output actual working time as a percentage of total time
 - detailed description of the meaning of each variable
 - added test results

v2：
 - output the total statistical time and work time to fdinfo

v1：
 - initial version
 - Statistics of total time and work time

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 io_uring/fdinfo.c | 8 ++++++++
 io_uring/sqpoll.c | 8 ++++++++
 io_uring/sqpoll.h | 1 +
 3 files changed, 17 insertions(+)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..18c6f4aa4a48 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	u64 sq_total_time = 0, sq_work_time = 0;
 	bool has_lock;
 	unsigned int i;
 
@@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
 		sq_pid = sq->task_pid;
 		sq_cpu = sq->sq_cpu;
+		struct rusage r;
+
+		getrusage(sq->thread, RUSAGE_SELF, &r);
+		sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
+		sq_work_time = sq->work_time;
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
+	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
+	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 65b5dbe3c850..9155fc0b5eee 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		struct rusage start, end;
+
+		getrusage(current, RUSAGE_SELF, &start);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
 		if (io_run_task_work())
 			sqt_spin = true;
 
+		getrusage(current, RUSAGE_SELF, &end);
+		if (sqt_spin == true)
+			sqd->work_time += (end.ru_stime.tv_sec - start.ru_stime.tv_sec) *
+					1000000 + (end.ru_stime.tv_usec - start.ru_stime.tv_usec);
+
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..e99f5423a3c3 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,7 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	u64					work_time;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.34.1


