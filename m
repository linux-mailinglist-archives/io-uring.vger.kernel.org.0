Return-Path: <io-uring+bounces-424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A908831333
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 08:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 703381C226B0
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 07:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF761170F;
	Thu, 18 Jan 2024 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="m2U34Qs6"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99351BE6D
	for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 07:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705563555; cv=none; b=VwZERycYLCVbAZonlLz2Ngm8O5+/qg5jGylFjGr03q6tZVkgr/+l7qvB48kr4KxwlC3y8wImuHHP0leQ3jUPVmdr3C/euqIDydPrDlhk0EVmmPcBLKvvzzuCFH2ZcLvHXkbo7Sm3fG9KsUrbbatoDr/DQASlEiVKhNH/pf6NY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705563555; c=relaxed/simple;
	bh=8rLKbvIjhytgvKWpQ2dcIUxrSisdNmYXavdiyiQNYlU=;
	h=Received:DKIM-Filter:DKIM-Signature:Received:Received:Received:
	 Received:Received:X-AuditID:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Brightmail-Tracker:X-Brightmail-Tracker:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:DLP-Filter:
	 X-CFilter-Loop:X-CMS-RootMailID:References; b=BDr3vLKzYJJTv2H+6vdj64yUBwt1gEMvhYqrE3KhUvHELkHvNypo5GaxXKqKS6BtFrNlyEH7PdbQY4MagaAkhTSKVOAzpsf2dqTI1eRUhH9MOa+Oi2j7njr3VrE8HmLxdb5itxkNJjmx6hu6lC9V7RNGb3rguHWl/OVZmM8DePY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=m2U34Qs6; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240118073904epoutp016a29a57b94dbd0d63f6d4e10d7b8db59~rYQH2UWYZ2318423184epoutp01s
	for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 07:39:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240118073904epoutp016a29a57b94dbd0d63f6d4e10d7b8db59~rYQH2UWYZ2318423184epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705563544;
	bh=eV2whF228SHMo+lzSw1V3QwwLWzHs13wuOnq23fbEYg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=m2U34Qs6cOQq/M3gJs4vGJmUaL43qt3VIExm6I105S+Q7LURNYE/k57c+XsKfUQpo
	 Xskl48n3xAvK9lNH24iarPefHV5Hj9hRYJgunZ9tlDJRWq7qR+DmZVmsNbK+SmAbqc
	 N/JkOGlHhKJHeLZB/fGX+ZsdhM0pZalnofqWkvPY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240118073904epcas5p3ad021d24ff0998eb565b34f794c836d7~rYQHPwOim2549425494epcas5p3E;
	Thu, 18 Jan 2024 07:39:04 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TFvkt46lPz4x9QF; Thu, 18 Jan
	2024 07:39:02 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F9.57.19369.695D8A56; Thu, 18 Jan 2024 16:39:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240118073844epcas5p2f346bc8ef02a2f48eef0020a6ad5165d~rYP0Xpmj_1598715987epcas5p2w;
	Thu, 18 Jan 2024 07:38:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240118073844epsmtrp11582b8059ceebd9eeae1182d1066fbb4~rYP0W1Eg43076030760epsmtrp1P;
	Thu, 18 Jan 2024 07:38:44 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-a3-65a8d596ce22
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	84.7F.08755.385D8A56; Thu, 18 Jan 2024 16:38:43 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240118073842epsmtip1f7ebf614383f02f8c7f11e5467b42614~rYPy5q8YE0455804558epsmtip1W;
	Thu, 18 Jan 2024 07:38:42 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v7] io_uring: Statistics of the true utilization of sq
 threads.
Date: Thu, 18 Jan 2024 15:30:32 +0800
Message-Id: <20240118073032.15015-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmhu60qytSDVrWyVnMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEtUtk1GamJKapFCal5yfkpmXrqtkndw
	vHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0IlKCmWJOaVAoYDE4mIlfTubovzSklSFjPzi
	Elul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMee0/WAv2q1Q8m9nG2sC4UbaLkZND
	QsBE4uTtZ+wgtpDAHkaJTV9yuhi5gOxPjBJHHr9mgXC+MUpc3L+ABaaj+8dUZoiOvYwShz8n
	QRS9ZJT48WMWK0iCTUBb4vq6LjBbBMh+/Xgq2CRmgSVMElu/HWYCSQgLBEp07nkHVsQioCpx
	4fUZsKm8AjYSt6YvY4bYJi+x/+BZqLigxMmZT8CuYAaKN2+dzQwyVEJgIofEu70tQEM5gBwX
	iY5XTBC9whKvjm9hh7ClJF72t0HZxRJHer6zQvQ2MEpMv30VKmEt8e/KHhaQOcwCmhLrd+lD
	hGUlpp5axwSxl0+i9/cTqPm8EjvmwdiqEqsvPYSGkLTE64bfUHEPieNLdjCDjBQSiJXomRI8
	gVF+FpJvZiH5ZhbC4gWMzKsYpVILinPTU5NNCwx181LL4RGbnJ+7iRGcUrUCdjCu3vBX7xAj
	EwfjIUYJDmYlEV5/g2WpQrwpiZVVqUX58UWlOanFhxhNgWE8kVlKNDkfmNTzSuINTSwNTMzM
	zEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglGpg0nff9l2UqSrpaOs0Ky3jU6uXCzz9
	siB5wRSe+m2Hv0uliy6+kfvN8+X7TNWE6o8HTC9znxc1fVvpbm130fx3cZzo83vfTQOsa9pm
	Td/+qElj9kctphWtlpWbT2nz7kp9HHdy//FfoQdPu+074bFs3mkLs0tl0SX3VyWafCvdc9zd
	Q4ZNkuFYQ7JJ8OcLBebf4psn/N759Ka61LEcwxi+uO9Rq7TPPs6P3p6gMln/PmdSoVFMlI7b
	2zM7DNe6+ZxujH6jd3vFI+uQN4elGeSZ57w+zDvxpL9E+FrF25uWx/A0HE5221VRLCUyc33n
	pOhbDTvOht+r2Xky6zT3evY7hU/Tr8Z+vPXMwKe/uoOjSomlOCPRUIu5qDgRAO0LLdAyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnG7z1RWpBie3WljMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8a89h+sBftV
	Kp7NbGNtYNwo28XIySEhYCLR/WMqcxcjF4eQwG5GiR8H3jF1MXIAJaQl/vwph6gRllj57zk7
	RM1zRomFDx4wgSTYBLQlrq/rYgWpFxHQlWi8qwBSwyywgUli/9N5rCA1wgL+ErMXNDGD2CwC
	qhIXXp8Bs3kFbCRuTV/GDLFAXmL/wbNQcUGJkzOfsIDMZBZQl1g/TwgkzAxU0rx1NvMERv5Z
	SKpmIVTNQlK1gJF5FaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcCRoae5g3L7qg94h
	RiYOxkOMEhzMSiK8/gbLUoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzir/oTRESSE8sSc1OTS1I
	LYLJMnFwSjUwrUjMehd3MTxF1sPebtmTSBmWxXsWP368yPt41rTVx3jWpy/sC7/5b8a0nNyO
	h78+678VnLtdccVB46SYe8cOvdqYPyFrK09vqKTcb/XAyz5v5l1utz90/++hMp2jXp5Nzy+y
	X+8Jnns/IoPlx16xwMc3HtmfLe9pSBPR7gi0d73Uarn3wMNFE9PWm3OsW9R7XHpy/4TivjXc
	n97HH3r9l93TVPzv026D1ys6RWt37dzLZbchJu824yLB3rAHT+amr15fXyLAyMT+ienWI8/z
	Ojzmc2KWP3sX8GQSt510zzeR1Fkfrl9Zedvr+iGGl95PVAMDpn44OqlH9fKiGa8//DwdE1bB
	9Yj9gOmPcN503/1KLMUZiYZazEXFiQB3MjU48wIAAA==
X-CMS-MailID: 20240118073844epcas5p2f346bc8ef02a2f48eef0020a6ad5165d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240118073844epcas5p2f346bc8ef02a2f48eef0020a6ad5165d
References: <CGME20240118073844epcas5p2f346bc8ef02a2f48eef0020a6ad5165d@epcas5p2.samsung.com>

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
SqTotalTime:    18099614us
SqWorkTime:     16748316us

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
 io_uring/sqpoll.c | 7 +++++++
 io_uring/sqpoll.h | 1 +
 3 files changed, 16 insertions(+)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..24a7452ed98e 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	long long sq_total_time = 0, sq_work_time = 0;
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
+	seq_printf(m, "SqTotalTime:\t%lldus\n", sq_total_time);
+	seq_printf(m, "SqWorkTime:\t%lldus\n", sq_work_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 65b5dbe3c850..f3e9fda72400 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		ktime_t start, diff;
+
+		start = ktime_get();
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -260,6 +263,10 @@ static int io_sq_thread(void *data)
 		if (io_run_task_work())
 			sqt_spin = true;
 
+		diff = ktime_sub(ktime_get(), start);
+		if (sqt_spin == true)
+			sqd->work_time += ktime_to_us(diff);
+
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..c14c00240443 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,7 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	long long			work_time;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.34.1


