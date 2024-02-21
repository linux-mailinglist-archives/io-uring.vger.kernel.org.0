Return-Path: <io-uring+bounces-668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CDC85CDD6
	for <lists+io-uring@lfdr.de>; Wed, 21 Feb 2024 03:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FBB11F24BBC
	for <lists+io-uring@lfdr.de>; Wed, 21 Feb 2024 02:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DE2F9F6;
	Wed, 21 Feb 2024 02:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TjMhvpDx"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5B7846F
	for <io-uring@vger.kernel.org>; Wed, 21 Feb 2024 02:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481899; cv=none; b=Il1wiGsax3091qZ7l2dnPlg2yyiu/Pm3Q1QCXmv5ZDXUTlxGJcBDGkj+rGz11VmR2o1IIKL6r/BoY4mg7Stl+yzbFrZjiFN6G7pEgb+ad530DWN8loDZgVkGlGUUBvL2+ixR/ztG2rqCctoijWHmOFSaUFuXY3E02kpOnW8P8EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481899; c=relaxed/simple;
	bh=Bz65JJzzK7nAF9fUJ/FgIyuYBpMGBYPrCxeT5tLXx4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RZM5eR5AJspPh9JbEtBN2PUD56eGISUEjzcHVpwc9HFdbS5h6lEg6PPDTPliJbh8oe5b8qFi5Mx10m4ZzYHuwoeUgeJQpwVQBCmhNJTn9+seMM8//QluVr+En8V/LmwpXQy7GmlTzCmZvwqWN48DOCrNxgAHX9sdFXqKkY3TCA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TjMhvpDx; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240221021814epoutp033de6c9d752ef93b5b5e75b3c675b00cc~1vzsbtm9n1985319853epoutp03v
	for <io-uring@vger.kernel.org>; Wed, 21 Feb 2024 02:18:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240221021814epoutp033de6c9d752ef93b5b5e75b3c675b00cc~1vzsbtm9n1985319853epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1708481894;
	bh=gIB0arhLN49n5nk6aQN47dB7qr96cHagBOiYA3JmIms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjMhvpDxPuVIX7+9pHGBMQqjmFqg+yfzDqTIEzvb4YIJKzxb1F3eH2yMKZtpM8qW7
	 RN7M/VTB2YNOq1RbQIltyT+HBjhk26teuIs/7vKNtaREQI2H/H00X5AYIX2kdTGulM
	 8JftoHWtFPKzq0bt4wwdBDQy90I2cZ8pgwrpwGq8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240221021813epcas5p2c56f1e5f4150b7a07dddf4af3a73696c~1vzsDJk6q2581825818epcas5p2v;
	Wed, 21 Feb 2024 02:18:13 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Tfg0z532Fz4x9QL; Wed, 21 Feb
	2024 02:18:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7D.A9.10009.36D55D56; Wed, 21 Feb 2024 11:18:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240221020432epcas5p4d3f6dcf44a4c2be392e94889786c75bc~1vnve0ayQ2500425004epcas5p4O;
	Wed, 21 Feb 2024 02:04:32 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240221020432epsmtrp15cd8eb5bd274aed9b3747399f3a7d23d~1vnvdBtLD1595015950epsmtrp1w;
	Wed, 21 Feb 2024 02:04:32 +0000 (GMT)
X-AuditID: b6c32a4a-ff1ff70000002719-36-65d55d63a6cc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9E.66.07368.03A55D56; Wed, 21 Feb 2024 11:04:32 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240221020431epsmtip1cf78aebccc892023d0a43ad74eb5f2ed~1vnuARfia2355323553epsmtip1W;
	Wed, 21 Feb 2024 02:04:31 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com
Subject: Re: [PATCH v9] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed, 21 Feb 2024 10:04:27 +0800
Message-Id: <20240221020427.309568-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240219064241.20531-1-xiaobing.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmlm5y7NVUg3eP1SzmrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5x
	ia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGps2/GAv+Slc87JzA1MDYIt7FyMkh
	IWAicXfvAtYuRi4OIYHdjBK7rzexQzifGCXebrrEDOF8Y5RYvukYG1zLw0lsEIm9jBJHn3xm
	gnB+MUpM7JrFBFLFJqAtcX1dFyuILSIgLLG/o5UFpIhZYB2TxKcdbewgCWGBUIknpw+D2SwC
	qhJnzl8Ca+YVsJWYt/EwK8Q6eYn9B88C3cHBwQkUX3rQHaJEUOLkzCcsIDYzUEnz1tlgp0oI
	TOSQuP1uKjtEr4tE3/pbTBC2sMSr41ug4lISL/vboOxiiSM931khmhsYJabfvgqVsJb4d2UP
	C8hiZgFNifW79CHCshJTT61jgljMJ9H7+wnUfF6JHfNgbFWJ1ZceskDY0hKvG35DxT0k9h5v
	gYbpBEaJT7c72SYwKsxC8tAsJA/NQli9gJF5FaNkakFxbnpqsWmBUV5qOTyek/NzNzGCE66W
	1w7Ghw8+6B1iZOJgPMQowcGsJMLLUn4lVYg3JbGyKrUoP76oNCe1+BCjKTDAJzJLiSbnA1N+
	Xkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTCyFy6/OL1Ow+FoQ
	Nf2W5Ca/Q+ueHDR1Yshfd3m19+EdBm4/fDZE3FfrP2HzrX1HyaeJ2bvSP3O7mIjv4VjiepCJ
	/ehfufPasqYBjRM+urFN8OBVZVi2eWFNwyvJvIOfHi5Y7rMvatLVm7zKEdYXP760//7cxy6q
	V8jHe53fli0/HJk4HAUtQj8kVviHrD/3YPdT9+QDYYuEFGIZjjZmJMloJiW3J51XlZtforJ2
	3/woi9St9jkXtmV8SyuN5AucsTD1xLzS7Pe7WUxulD7LFV8grrWN++WyHy7mMnVzn6uvuKdZ
	LjdrS2/Svn1/XWZ6rdp8ZpdMn/hmL+6Ji1bNUPWQMWr5+E3Pj0NUX//LPCWW4oxEQy3mouJE
	AMTnX6BBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnK5B1NVUgzOP9SzmrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PT5l+MBX+l
	Kx52TmBqYGwR72Lk5JAQMJG4+3ASWxcjF4eQwG5GifNnVjB2MXIAJaQl/vwph6gRllj57zk7
	iC0k8INR4mVnJYjNJqAtcX1dFyuILQJUs7+jlQVkDrPAHiaJd9M+gyWEBYIl1ja8B2tmEVCV
	OHP+EhOIzStgKzFv42FWiAXyEvsPnmUG2csJFF960B1il43E/U1P2SDKBSVOznzCAmIzA5U3
	b53NPIFRYBaS1CwkqQWMTKsYJVMLinPTc5MNCwzzUsv1ihNzi0vz0vWS83M3MYJjQUtjB+O9
	+f/0DjEycTAeYpTgYFYS4WUpv5IqxJuSWFmVWpQfX1Sak1p8iFGag0VJnNdwxuwUIYH0xJLU
	7NTUgtQimCwTB6dUAxNr8ksRzZQ9qRx6Jx7Hrmo4lbxu1V/tVp6yr3+jtuq3Zc5kPyp+UU1t
	/Yef7lv+Vk1RbLLaOCtZ+VzZ1YC9t7JVReZ2nNZZecejSGtZ8LqUG/JPDi/2FLvT8y0lo/1u
	wjPDnONGxhaH/TpXuxVMev79orazh7VYvr9qwb9jykEt1d2unsI7jCwTPffxeGybr33O7kLT
	tMYJ7h/WGv3RSq5f6GrLtape+VdY/8vAZ3pTdHLPqwWmi7rbOd6u65vzkOszW07cxXlXcle/
	5O677fTux/f4rnIR83v8H6snpiwWOBfPnP766G0G5cL5V1MEfT0MMrjcQ2f/EJd3NFQ/ta56
	qujBkA9q4fGrryoeUWIpzkg01GIuKk4EAFbtUEn0AgAA
X-CMS-MailID: 20240221020432epcas5p4d3f6dcf44a4c2be392e94889786c75bc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240221020432epcas5p4d3f6dcf44a4c2be392e94889786c75bc
References: <20240219064241.20531-1-xiaobing.li@samsung.com>
	<CGME20240221020432epcas5p4d3f6dcf44a4c2be392e94889786c75bc@epcas5p4.samsung.com>

On 2/19/24 14:42, Xiaobing Li wrote:
>diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>index 976e9500f651..37afc5bac279 100644
>--- a/io_uring/fdinfo.c
>+++ b/io_uring/fdinfo.c
>@@ -55,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
> 	struct io_ring_ctx *ctx = f->private_data;
> 	struct io_overflow_cqe *ocqe;
> 	struct io_rings *r = ctx->rings;
>+	struct rusage sq_usage;
> 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
> 	unsigned int sq_head = READ_ONCE(r->sq.head);
> 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
>@@ -64,6 +65,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
> 	unsigned int sq_shift = 0;
> 	unsigned int sq_entries, cq_entries;
> 	int sq_pid = -1, sq_cpu = -1;
>+	u64 sq_total_time = 0, sq_work_time = 0;
> 	bool has_lock;
> 	unsigned int i;
> 
>@@ -147,10 +149,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
> 
> 		sq_pid = sq->task_pid;
> 		sq_cpu = sq->sq_cpu;
>+		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
>+		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
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
>index 65b5dbe3c850..006d7fc9cf92 100644
>--- a/io_uring/sqpoll.c
>+++ b/io_uring/sqpoll.c
>@@ -219,10 +219,22 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
> 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
> }
> 
>+static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>+{
>+		struct rusage end;
>+
>+		getrusage(current, RUSAGE_SELF, &end);
>+		end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>+		end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
>+
>+		sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>+}
>+
> static int io_sq_thread(void *data)
> {
> 	struct io_sq_data *sqd = data;
> 	struct io_ring_ctx *ctx;
>+	struct rusage start;
> 	unsigned long timeout = 0;
> 	char buf[TASK_COMM_LEN];
> 	DEFINE_WAIT(wait);
>@@ -251,6 +263,7 @@ static int io_sq_thread(void *data)
> 		}
> 
> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>+		getrusage(current, RUSAGE_SELF, &start);
> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> 			int ret = __io_sq_thread(ctx, cap_entries);
> 
>@@ -261,8 +274,10 @@ static int io_sq_thread(void *data)
> 			sqt_spin = true;
> 
> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>-			if (sqt_spin)
>+			if (sqt_spin) {
>+				io_sq_update_worktime(sqd, &start);
> 				timeout = jiffies + sqd->sq_thread_idle;
>+			}
> 			if (unlikely(need_resched())) {
> 				mutex_unlock(&sqd->lock);
> 				cond_resched();
>diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>index 8df37e8c9149..4171666b1cf4 100644
>--- a/io_uring/sqpoll.h
>+++ b/io_uring/sqpoll.h
>@@ -16,6 +16,7 @@ struct io_sq_data {
> 	pid_t			task_pid;
> 	pid_t			task_tgid;
> 
>+	u64			work_time;
> 	unsigned long		state;
> 	struct completion	exited;
> };
 
Hi, Jens
I have modified the code according to your suggestions.
Do you have any other comments?

--
Xiaobing Li

