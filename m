Return-Path: <io-uring+bounces-617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D398594E7
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 06:55:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 697892822F7
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 05:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A115258;
	Sun, 18 Feb 2024 05:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NNPY32CF"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E8A5227
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 05:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708235746; cv=none; b=aUIjFVPuOF8k00EehtKnnPvh4YsT9zC3jujPdsTsZFTRDKFstEIk1eGxoM++5++qlCzhv3CcdOyAX7HRMAbCpqkE2/17vbJd8KHA6Rga0vznVDex2yt7AW0CCNVL0sRbd8gUd38akyUoOMn2CtvZV3eKZTrqIuDJOqzM2sSX3JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708235746; c=relaxed/simple;
	bh=hvGwEK+ZRHNPLzuC4motAkXTZqrorH8IZiiFu0cP8vE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=agFHht1mRLVrFGFmVVi55rJGMgEd+d43SHcEmL0Ncie7u/7DPeBc6frGZQR/prPlebPxrwItzkiVXH5gGbfcV3QvbcNPtcE2Lmvbz8yHVA2T/zBY+o+y1Q0YA2Xnw8hBs/mef3nTtchziNPbXwxqzMzHLCuSyyuXTnxifUnMJsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NNPY32CF; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240218055535epoutp034526034c61b5c9375b3849f83711c832~031mz-YQP3150731507epoutp03x
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 05:55:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240218055535epoutp034526034c61b5c9375b3849f83711c832~031mz-YQP3150731507epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1708235735;
	bh=e9A7xHwxnlbYsZFP0GoppyfR/Yd1BkvmSdezL22iEhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNPY32CF3SfbDTZ34iAt8H9sWwlBy0bSyGNkoEJl0ZyU5wesrZCRZxgH1v+5PtXmA
	 CqUsSImKYlG3+pNm7eEei1IthUJK78qv9lEjcSMt5KB0sba9Jgn5jk+BGId5f20lYj
	 w6SpqI7P5oAkQzQ/8Yhj85qqyet+jkluN5f8tzRY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240218055534epcas5p45bbdcb9851e6a62a4c7048edb3b91122~031mWub0Z3263732637epcas5p4f;
	Sun, 18 Feb 2024 05:55:34 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Tcvz86R2Hz4x9Pp; Sun, 18 Feb
	2024 05:55:32 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	33.09.19369.4DB91D56; Sun, 18 Feb 2024 14:55:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240218055523epcas5p390fe990f970cf2b9b1f96edd5d7bc9b5~031byeVs-2569625696epcas5p3n;
	Sun, 18 Feb 2024 05:55:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240218055523epsmtrp14a35f44646e82c579c687a265a211950~031bsrP-f0409304093epsmtrp1O;
	Sun, 18 Feb 2024 05:55:23 +0000 (GMT)
X-AuditID: b6c32a50-9e1ff70000004ba9-47-65d19bd419d1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B8.7F.08755.ACB91D56; Sun, 18 Feb 2024 14:55:22 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240218055519epsmtip10064f219037a2de51a73b513e05abfa2~031YZgwBw0349903499epsmtip1V;
	Sun, 18 Feb 2024 05:55:19 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: xiaobing.li@samsung.com
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com
Subject: Re: [PATCH v8] io_uring: Statistics of the true utilization of sq
 threads.
Date: Sun, 18 Feb 2024 13:55:13 +0800
Message-Id: <20240218055513.38601-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240206023910.11307-1-xiaobing.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmuu6V2RdTDboOG1jMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBTo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZ7z9uI61YJpoRfOnyUwNjKsEuxg5OSQETCQ6ep+xdjFy
	cQgJ7GGU6NtzlxHC+cQosezBLSjnG6PEgm0bWGFaTk3bxQSR2MsoMe3NYTYI5xejxJzHc8Cq
	2AS0Ja6v6wKzRQSkJa5v2QTWwSzwlVFiyu+rjCAJYYFQiQVX77OD2CwCqhL/l3SA2bwCNhL3
	1x1mhFgnL7H/4FlmEJtTwFZi8vYTLBA1ghInZz4Bs5mBapq3zmYGWSAh0Mgh0fNiNgtEs4vE
	9MeLmSFsYYlXx7ewQ9hSEi/726DsYokjPd9ZIZobGCWm374KlbCW+HdlD9AgDqANmhLrd+lD
	hGUlpp5axwSxmE+i9/cTJog4r8SOeTC2qsTqSw+hbpCWeN3wmwlkjISAh8Tsuc6Q0JrAKNG+
	4CHrBEaFWUj+mYXkn1kImxcwMq9ilEotKM5NT002LTDUzUsth0d0cn7uJkZwetUK2MG4esNf
	vUOMTByMhxglOJiVRHjdmy6kCvGmJFZWpRblxxeV5qQWH2I0BYb4RGYp0eR8YILPK4k3NLE0
	MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBqa1W5OcnpmuqC+/alpp4rZOa
	yXh/zgKbxZtWrVj3to77xdwFt9qXaB09slml8++hPxteXj765MI/95UcAZ88uxn28k/48u7i
	p+/5KaXT9kldv1r3v+Jjnrrqk2VGMj4bHia7yxy/4rPDc4LZmtZrfTrJCQJ9h35Kz701b1bz
	+cOP1t+vWW0x6ail/o7avfXHZGao3uFYutzleW3MheRymT3aW2Ym/bC+IXTmpIyNkkHQyeXC
	XlX/J5yuuXeK99XD9m9LKuYeOFYlErZ12zybIN/Tsou2LXR+fDSf7Y2DuoZzVeK6nNhpD8RZ
	75xZvF/ZPSJ3rbnLbJsJCoYWy30sf2yy0PDacWLXBQvm5R+v3eNTVGIpzkg01GIuKk4EAAx8
	euM4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO6p2RdTDY702ljMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy3n5cx1owTbSi+dNkpgbGVYJd
	jJwcEgImEqem7WLqYuTiEBLYzSgx891Gli5GDqCEtMSfP+UQNcISK/89Z4eo+cEo8f3aLSaQ
	BJuAtsT1dV2sILYIUP31LZvA4swCjUwSq9aFgNjCAsESN47+BathEVCV+L+kgx3E5hWwkbi/
	7jAjxAJ5if0HzzKD2JwCthKTt58Au0EIqGZ6rzFEuaDEyZlPWCDGy0s0b53NPIFRYBaS1Cwk
	qQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLDXktzB+P2VR/0DjEycTAeYpTg
	YFYS4XVvupAqxJuSWFmVWpQfX1Sak1p8iFGag0VJnFf8RW+KkEB6YklqdmpqQWoRTJaJg1Oq
	gemAdhUv38daRskPzPmrrc88VXQ3MQpeLTB9V3VHP2df7ebpQflX5mbo8y+0/Jrtkrb2VPHf
	ysXGv2t3ChennXfKW3nu6g/dpzN3PN6WN7v+r26G0W+XDWX78qcaSemxR3zZrDZx/u+Jpx+6
	J4SL9S/wnud81sTjkvT+Ix8d8sU6XnCmMX7mOHmjaU/sukBDhy7BipaVXr+z1967uUVwsrqZ
	bW5McEmq61Vplml+j5OsHKwm/G1cn950+ZqcM8fHMKOq4wssdS03Nbgf3MlxId97ZmEM5zHf
	lyXVxf5fbYTYql+fdOnhD74bu0za51BXf1vSS4V/Vv9f+mw+qnvDQbb0VafuimYBvfN+57L3
	KbEUZyQaajEXFScCAEvAF8XqAgAA
X-CMS-MailID: 20240218055523epcas5p390fe990f970cf2b9b1f96edd5d7bc9b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240218055523epcas5p390fe990f970cf2b9b1f96edd5d7bc9b5
References: <20240206023910.11307-1-xiaobing.li@samsung.com>
	<CGME20240218055523epcas5p390fe990f970cf2b9b1f96edd5d7bc9b5@epcas5p3.samsung.com>

On 2/6/24 10:39 AM, Xiaobing Li wrote:
> io_uring/fdinfo.c | 8 ++++++++
> io_uring/sqpoll.c | 8 ++++++++
> io_uring/sqpoll.h | 1 +
> 3 files changed, 17 insertions(+)
>
>diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>index 976e9500f651..18c6f4aa4a48 100644
>--- a/io_uring/fdinfo.c
>+++ b/io_uring/fdinfo.c
>@@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
> 	unsigned int sq_shift = 0;
> 	unsigned int sq_entries, cq_entries;
> 	int sq_pid = -1, sq_cpu = -1;
>+	u64 sq_total_time = 0, sq_work_time = 0;
> 	bool has_lock;
> 	unsigned int i;
> 
>@@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
> 
> 		sq_pid = sq->task_pid;
> 		sq_cpu = sq->sq_cpu;
>+		struct rusage r;
>+
>+		getrusage(sq->thread, RUSAGE_SELF, &r);
>+		sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
>+		sq_work_time = sq->work_time;
> 	}
> 
> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
> 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
>+	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
>+	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
> 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
> 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
> 		struct file *f = io_file_from_index(&ctx->file_table, i);
>diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>index 65b5dbe3c850..9155fc0b5eee 100644
>--- a/io_uring/sqpoll.c
>+++ b/io_uring/sqpoll.c
>@@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
> 		}
> 
> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>+		struct rusage start, end;
>+
>+		getrusage(current, RUSAGE_SELF, &start);
> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> 			int ret = __io_sq_thread(ctx, cap_entries);
> 
>@@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
> 		if (io_run_task_work())
> 			sqt_spin = true;
> 
>+		getrusage(current, RUSAGE_SELF, &end);
>+		if (sqt_spin == true)
>+			sqd->work_time += (end.ru_stime.tv_sec - start.ru_stime.tv_sec) *
>+					1000000 + (end.ru_stime.tv_usec - start.ru_stime.tv_usec);
>+
> 		if (sqt_spin || !time_after(jiffies, timeout)) {
> 			if (sqt_spin)
> 				timeout = jiffies + sqd->sq_thread_idle;
>diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>index 8df37e8c9149..e99f5423a3c3 100644
>--- a/io_uring/sqpoll.h
>+++ b/io_uring/sqpoll.h
>@@ -16,6 +16,7 @@ struct io_sq_data {
> 	pid_t			task_pid;
> 	pid_t			task_tgid;
> 
>+	u64					work_time;
> 	unsigned long		state;
> 	struct completion	exited;
> };
 
Hi, Jens and Pavel
This patch has been modified according to your previous opinions.
Do you have any other comments?

--
Xiaobing Li

