Return-Path: <io-uring+bounces-792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E22086AAF2
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 10:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B0FB1F22956
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 09:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C99832189;
	Wed, 28 Feb 2024 09:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G63OxGy3"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869F62E651
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 09:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709111411; cv=none; b=ay6/G+38jJhsgfnuZd4FJGcSKvrVdcsXHNwiruVRTFhSDnJidoveFXfPwALNSMEqVOeY1ZY+j6J2gYb91Syapzr1tR1vnnKZGGiCaw1NjGbtjip3HyJPUk3KU2ppPxZ8qCiP4PHqp4L/G1pNsu1EijKkrNlNKMHBf3lVMhSlSoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709111411; c=relaxed/simple;
	bh=C4DMvGkpUakZWIjw3aTNdIJrzEuIUMIctVOczHho8oA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=n5H9ixN9c7SmdcYGBafow9Z86tf6CZfiWqFzevtYPWH3trGhFpR4o5Y60URkUOpkunQcbmYI6nXBPWA4/awKrZZb2IlxVoOu7bGUBr0A3hiA5SBbg3n6J9g60d9ywN+FhZNm7KlEo/5QgUUH6DD1F5+nrl77cJYf0PgVF/pQQKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G63OxGy3; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240228091001epoutp04270a6c0e1b94f65a052af29e5f90a6da~3_8OS91_B0761307613epoutp04f
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 09:10:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240228091001epoutp04270a6c0e1b94f65a052af29e5f90a6da~3_8OS91_B0761307613epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1709111401;
	bh=jC0Eo3T7+Csn3U7VEHidoDHQpeC6gUpWqwhzqBteH0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G63OxGy3EoLTPZizki2oykSDaR4yu/FF2Skwrpa5H9luTTAmwEwtT2f7/gG9+CC27
	 8VTyhl7FJM8qmsm+wOE5Bu7GB+kbevop92xItjnwx6hNBgx3NUM30rkalS2X2i6AyU
	 +Jxd5LC5XTsII4ZvReT6SVyeYyilebhFmBinlltg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240228091000epcas5p40677d44658c339411e142a4c7525ae5d~3_8N2kJAp1546215462epcas5p4F;
	Wed, 28 Feb 2024 09:10:00 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Tl7pv16zwz4x9Q6; Wed, 28 Feb
	2024 09:09:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.22.10009.768FED56; Wed, 28 Feb 2024 18:09:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240228090948epcas5p2d7efbaa6c9a80b3e4d18755674c08178~3_8DAiwKl0638706387epcas5p2m;
	Wed, 28 Feb 2024 09:09:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240228090948epsmtrp17df2df5c8ce5f8daa5f43841c04bb424~3_8C-qHQ90773907739epsmtrp1z;
	Wed, 28 Feb 2024 09:09:48 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-11-65def867274e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D5.07.08755.C58FED56; Wed, 28 Feb 2024 18:09:48 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240228090947epsmtip1473112094ce462968a1e7ba838828049~3_8BhxACf0291702917epsmtip1e;
	Wed, 28 Feb 2024 09:09:47 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com
Subject: Re: [PATCH v10] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed, 28 Feb 2024 17:09:42 +0800
Message-Id: <20240228090942.511087-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240228085154.193363-1-xiaobing.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmlm76j3upBn+bWS3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5x
	ia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGwyuX2QrOSlSsWbqctYFxkUgXIweH
	hICJxN67il2MXBxCArsZJU4t2MsG4XxilPj7eyMLhPONUWLf9MNsMB2tmwMg4nsZJc58uMQK
	4fxilPi/bhZjFyMnB5uAtsT1dV2sILaIgLDE/o5WsEnMAuuYJD7taGMHSQgLhEnMXXUCbCqL
	gKrErxNVIGFeAVuJfT+b2EBsCQF5if0HzzKD2JwCdhLLWq8zQdQISpyc+YQFxGYGqmneOpsZ
	ZL6EwEQOic2rfzBDNLtI9H+6zQJhC0u8Or6FHcKWknjZ3wZlF0sc6fnOCtHcwCgx/fZVqIS1
	xL8re1hAjmMW0JRYv0sfIiwrMfXUOiaIxXwSvb+fMEHEeSV2zIOxVSVWX3oItVda4nXDb6i4
	h8TTR8cYIaE1kVHizozjTBMYFWYheWgWkodmIaxewMi8ilEytaA4Nz212LTAKC+1HB7Lyfm5
	mxjByVbLawfjwwcf9A4xMnEwHmKU4GBWEuGVEbybKsSbklhZlVqUH19UmpNafIjRFBjgE5ml
	RJPzgek+ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGptgp33sf
	vly35rPM7rYOzrtvZoQfu5nczT6vwkzd78ziJU3rj/zzVTn30F2w9nj1WwPzqd9da3/EOc/f
	e8nkguNq1SLVvfy9datqQ11Pf1L937aboawz/Dr/ammVvgnbryjPqt17f9+MQ975vTd33Vdc
	dOhhs8LL1PIk9vnfTqjw7D2T8Nbb5ablhmK3quDOlWzSczgzHwVcVfJevTdqI/NHhbn+7bpH
	n+6PkMtvtlZ+cFkjUEDRo9N8V0nk4VN1TJ5rz0VJsc7SONPPbcM9g+P2j/SWyNk/Vt26qlgw
	/1LzpLYr5eKTZ0qt2OT5tiHz2xX7ivXVVzpj7SM/divP7jW4yym357J937TAzkXRP5VYijMS
	DbWYi4oTARDsXEQ/BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnG7Mj3upBlNuGFjMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bDK5fZCs5K
	VKxZupy1gXGRSBcjB4eEgIlE6+aALkYuDiGB3YwSx/+vYoSIS0v8+VPexcgJZApLrPz3nB2i
	5gejxJ6GCSwgCTYBbYnr67pYQWwRoKL9Ha0sIEXMAnuYJN5N+wyWEBYIkVhwcSszyFAWAVWJ
	XyeqQMK8ArYS+342sUEskJfYf/AsM4jNKWAnsaz1OhNIuRBQzaaZsRDlghInZz4BW8sMVN68
	dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI4ELc0djNtX
	fdA7xMjEwXiIUYKDWUmEV0bwbqoQb0piZVVqUX58UWlOavEhRmkOFiVxXvEXvSlCAumJJanZ
	qakFqUUwWSYOTqkGpk1fKhrPFe/J8vzQZzBR6qHNk2y7VqkvM+wVIhWfdF95bpTxc5La/1Zm
	W41DwYxX5bQPSSYwZ3Z08Z10dtX5vMZv37yD0qd/VVcK8Khu7tWxfPX9RXPZikkPOg4KHnB5
	qJNfXGUonq5c9iU47ZNBhVf59YffRHV+m/zgmFb5e2XkmvvuBpsDhINPS6vvN/l+9r/0hWfS
	ZnnWL547OJjsDOVc8TKvybD8GGc9X1TPfuH/DDK7whO2nupbuvjyueUfohY9VhD7aXDq9pRT
	SmfTefmkXkx/6HvW+77q1qytK+Zwc33Laly5jGW94jfHZvkpW+/u65l0/PO8x4UVK0883nu8
	mzczNKNvOdPz1SvM65VYijMSDbWYi4oTAeNPbrjzAgAA
X-CMS-MailID: 20240228090948epcas5p2d7efbaa6c9a80b3e4d18755674c08178
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240228090948epcas5p2d7efbaa6c9a80b3e4d18755674c08178
References: <20240228085154.193363-1-xiaobing.li@samsung.com>
	<CGME20240228090948epcas5p2d7efbaa6c9a80b3e4d18755674c08178@epcas5p2.samsung.com>

On 2/28/24 16:51, Xiaobing Li wrote:
>diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>index 976e9500f651..42b449e53535 100644
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
>@@ -147,10 +148,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
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
>index 82672eaaee81..363052b4ea76 100644
>--- a/io_uring/sqpoll.c
>+++ b/io_uring/sqpoll.c
>@@ -253,11 +253,23 @@ static bool io_sq_tw_pending(struct llist_node *retry_list)
> 	return retry_list || !llist_empty(&tctx->task_list);
> }
> 
>+static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>+{
>+	struct rusage end;
>+
>+	getrusage(current, RUSAGE_SELF, &end);
>+	end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>+	end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
>+
>+	sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>+}
>+
> static int io_sq_thread(void *data)
> {
> 	struct llist_node *retry_list = NULL;
> 	struct io_sq_data *sqd = data;
> 	struct io_ring_ctx *ctx;
>+	struct rusage start;
> 	unsigned long timeout = 0;
> 	char buf[TASK_COMM_LEN];
> 	DEFINE_WAIT(wait);
>@@ -286,6 +298,7 @@ static int io_sq_thread(void *data)
> 		}
> 
> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>+		getrusage(current, RUSAGE_SELF, &start);
> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> 			int ret = __io_sq_thread(ctx, cap_entries);
> 
>@@ -296,8 +309,10 @@ static int io_sq_thread(void *data)
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
 
Sorry, please ignore this patch, I will resend a v10.

--
Xiaobing Li

