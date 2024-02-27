Return-Path: <io-uring+bounces-774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2628688C1
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 06:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FFE31F23104
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 05:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EC952F91;
	Tue, 27 Feb 2024 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DaDhswZg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E5352F90
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 05:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709012910; cv=none; b=tbN0zeNzjRcUXnC5MIv9rs1jkWJ4IExMDK1NN7YAzzzNpajbT7jav9bnMnNUroVC/Ub44Ct86TQwNiJonSOSqQLtKyuvOgdBxPftn6s54N6FJUeb4u1LpANR0BeTjF9cbxjzge+PEkwXgTn3ytaJzkoofrVZErjZyHviaAnM0uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709012910; c=relaxed/simple;
	bh=nSPpsR7nfBehtnxcyNPB+XHo+S22hS6GhOpitI+dgcc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NmL1nxHIOnslFZQrFwZpmjbPdyIflpemu729r3+5yQCXcMt7nLz0YSTeCoPzmtepY3tlZbU3XV5qrSSjakcSsohPBxctA9m57WgWy4QO9i2BEInSw0diUFRxrHen79nqaholmdmq6HHxQ3IeTyiZiFfqOoLBkeVwQH1KefRjh9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DaDhswZg; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240227054818epoutp02ef7a7ca20fad094f26cc7a5ad27308ab~3oi03RGVx1713117131epoutp02v
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 05:48:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240227054818epoutp02ef7a7ca20fad094f26cc7a5ad27308ab~3oi03RGVx1713117131epoutp02v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1709012898;
	bh=/PGjpIIwUmQfGhv+CMcsmTgstWsV33NXT6J2c69FJqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaDhswZg8u8jpcn1H6EZf7CejKq6QIaOlxXaJxyfSTD64T/cmppI/qmGqkaAwLIhU
	 01PXHIiN8qlcYzpuOS02lRSZn95zShmzObIGuqPqPacA2pfV2scc07soJQV4dpCou8
	 rj/Dwt4AHDgNMFb9xL4G5gNYmDXFFg8Ed4JSb6oA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240227054818epcas5p4aff9391bffbb09f77830b3162cc56c43~3oi0ZoUEG1431714317epcas5p4K;
	Tue, 27 Feb 2024 05:48:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TkRNc48q8z4x9Q5; Tue, 27 Feb
	2024 05:48:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.67.09672.E977DD56; Tue, 27 Feb 2024 14:48:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240227054554epcas5p3ada1c39620d0156e6db87f05449dd624~3ogugFDMB2214322143epcas5p3y;
	Tue, 27 Feb 2024 05:45:54 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240227054554epsmtrp1d6f2a18a4a34ae6919976d81bf668ed7~3ogue-f1d1211512115epsmtrp1Q;
	Tue, 27 Feb 2024 05:45:54 +0000 (GMT)
X-AuditID: b6c32a4b-60bfd700000025c8-e0-65dd779edb4c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2F.14.07368.2177DD56; Tue, 27 Feb 2024 14:45:54 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240227054550epsmtip2801b59fac6cbdb04e7164604af451a7f~3ogrAKscj0416904169epsmtip2B;
	Tue, 27 Feb 2024 05:45:50 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com
Subject: Re: Re: [PATCH v9] io_uring: Statistics of the true utilization of
 sq threads.
Date: Tue, 27 Feb 2024 13:45:45 +0800
Message-Id: <20240227054545.1184805-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0d0fda8f-36c1-49f4-aef0-527a79a34448@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmuu688rupBgfXyFrMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEtUtk1GamJKapFCal5yfkpmXrqtkndw
	vHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0IlKCmWJOaVAoYDE4mIlfTubovzSklSFjPzi
	Elul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMQ7+WMRWclq9YN5G/gfGbZBcjJ4eE
	gIlE1+djrF2MXBxCArsZJZZd2sIKkhAS+MQo0TbZACLxjVFi2+LTrDAdpyatZ4RI7GWUOPB8
	DRNExy9GiW9n5UBsNgFtievrusAaRASEJfZ3tLKANDALrGOS+LSjjR0kISwQKdGw+QYLiM0i
	oCqxc/d2sEG8AnYSx/d+ZIbYJi+x/+BZMJtTwFbi1p/vzBA1ghInZz4B62UGqmneOpsZZIGE
	wEQOicOTe4A2cwA5LhL7VnhBzBGWeHV8CzuELSXxsr8Nyi6WONLznRWit4FRYvrtq1AJa4l/
	V/awgMxhFtCUWL9LHyIsKzH11DomiL18Er2/nzBBxHkldsyDsVUlVl96yAJhS0u8bvgNFfeQ
	mPq1gwUSchMYJZa/3sc+gVFhFpJ/ZiH5ZxbC6gWMzKsYJVMLinPTU4tNC4zzUsvhkZycn7uJ
	EZxqtbx3MD568EHvECMTB+MhRgkOZiURXhnBu6lCvCmJlVWpRfnxRaU5qcWHGE2BAT6RWUo0
	OR+Y7PNK4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamBS19/6RkU6
	Q3XHvN9buGNu5F2+dLXh3omopBNSnZMvB7pdKvUODHt0SsJ75cIT1qI+9vyXms4cUg8W94hY
	GyA362RK6MsmjQ8393ZL1x+VrnarELn0iN1p143PpmtWesxb+yN6u6ONYuoaZ6X9hi9XSGc/
	5V2Qt+Pw3G+sjjGhF7lCljtkbNtzTaE4pH493y4Hs/Zp0+1O9GZL2thNWCO6cdpGvVlzzmzZ
	uFtMdt3Ch8m5ooLSspxFZ97IKjmd61GaUKj3Vont7tIUUzvGh8K585hMT+m9rg24pZp98K5q
	dmFkTrxqg9JJn6aZHzwnfzpiaPk/4fGcJdveFet73BFhKmbb8ftx8tZlRQyVsz4qsRRnJBpq
	MRcVJwIAEt0M7T4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvK5Q+d1UgyvnhC3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PQr2VMBafl
	K9ZN5G9g/CbZxcjJISFgInFq0nrGLkYuDiGB3YwSG780sHUxcgAlpCX+/CmHqBGWWPnvOTtE
	zQ9GiYsLHrKDJNgEtCWur+tiBbFFgIr2d7SygBQxC+xhkng37TNYQlggXKLz72YmEJtFQFVi
	5+7tYDavgJ3E8b0fmSE2yEvsP3gWzOYUsJW49ec7M8gRQgI2Evf3GkGUC0qcnPmEBcRmBipv
	3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl5+duYgTHgpbGDsZ7
	8//pHWJk4mA8xCjBwawkwisjeDdViDclsbIqtSg/vqg0J7X4EKM0B4uSOK/hjNkpQgLpiSWp
	2ampBalFMFkmDk6pBiam5oBJXStSrPIW+rXcaK7ZanT319p9acZrV12QruLyX/CNKdVrglzO
	3gW37sTr3v5VsEc9o+blo6VyJpfqz7FxTjzXaHxOydkjdH3vZuHyapX680r5S9jObao9/O5Q
	9Ikonfjuy79953gmzpA76mvfXfD/t0DYQ6tgd9UXLp9NXK65tSmlHzweLuExqbzm5Pp29l+z
	HnnNLHngt+rnpjmvxU3EC6zkPTnMwyxK/J7bP2I+/W/GRIaCekaTmccLTnIky6Vc3HfC4NVC
	E+tXrQ6bXL4clPBgsbLvuBtTKp4W9/DkvP8iC3Sz35zS6LmXfzN32Y3ZB9O1+6a4mrN+P5HL
	ZPv0sJuv7CUn5ZupW5VYijMSDbWYi4oTAUm/gyf0AgAA
X-CMS-MailID: 20240227054554epcas5p3ada1c39620d0156e6db87f05449dd624
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240227054554epcas5p3ada1c39620d0156e6db87f05449dd624
References: <0d0fda8f-36c1-49f4-aef0-527a79a34448@kernel.dk>
	<CGME20240227054554epcas5p3ada1c39620d0156e6db87f05449dd624@epcas5p3.samsung.com>

On 2/21/24 10:28, Jens Axboe wrote:
>On 2/20/24 7:04 PM, Xiaobing Li wrote:
>> On 2/19/24 14:42, Xiaobing Li wrote:
>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>> index 976e9500f651..37afc5bac279 100644
>>> --- a/io_uring/fdinfo.c
>>> +++ b/io_uring/fdinfo.c
>>> @@ -55,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>> 	struct io_ring_ctx *ctx = f->private_data;
>>> 	struct io_overflow_cqe *ocqe;
>>> 	struct io_rings *r = ctx->rings;
>>> +	struct rusage sq_usage;
>>> 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>> 	unsigned int sq_head = READ_ONCE(r->sq.head);
>>> 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
>>> @@ -64,6 +65,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>> 	unsigned int sq_shift = 0;
>>> 	unsigned int sq_entries, cq_entries;
>>> 	int sq_pid = -1, sq_cpu = -1;
>>> +	u64 sq_total_time = 0, sq_work_time = 0;
>>> 	bool has_lock;
>>> 	unsigned int i;
>>>
>>> @@ -147,10 +149,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>
>>> 		sq_pid = sq->task_pid;
>>> 		sq_cpu = sq->sq_cpu;
>>> +		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
>>> +		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
>>> +		sq_work_time = sq->work_time;
>>> 	}
>>>
>>> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>>> 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
>>> +	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
>>> +	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
>>> 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
>>> 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
>>> 		struct file *f = io_file_from_index(&ctx->file_table, i);
>>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>>> index 65b5dbe3c850..006d7fc9cf92 100644
>>> --- a/io_uring/sqpoll.c
>>> +++ b/io_uring/sqpoll.c
>>> @@ -219,10 +219,22 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>>> 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>>> }
>>>
>>> +static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>>> +{
>>> +		struct rusage end;
>>> +
>>> +		getrusage(current, RUSAGE_SELF, &end);
>>> +		end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>>> +		end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
>>> +
>>> +		sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>>> +}
>>> +
>>> static int io_sq_thread(void *data)
>>> {
>>> 	struct io_sq_data *sqd = data;
>>> 	struct io_ring_ctx *ctx;
>>> +	struct rusage start;
>>> 	unsigned long timeout = 0;
>>> 	char buf[TASK_COMM_LEN];
>>> 	DEFINE_WAIT(wait);
>>> @@ -251,6 +263,7 @@ static int io_sq_thread(void *data)
>>> 		}
>>>
>>> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>>> +		getrusage(current, RUSAGE_SELF, &start);
>>> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>>> 			int ret = __io_sq_thread(ctx, cap_entries);
>>>
>>> @@ -261,8 +274,10 @@ static int io_sq_thread(void *data)
>>> 			sqt_spin = true;
>>>
>>> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>>> -			if (sqt_spin)
>>> +			if (sqt_spin) {
>>> +				io_sq_update_worktime(sqd, &start);
>>> 				timeout = jiffies + sqd->sq_thread_idle;
>>> +			}
>>> 			if (unlikely(need_resched())) {
>>> 				mutex_unlock(&sqd->lock);
>>> 				cond_resched();
>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>> index 8df37e8c9149..4171666b1cf4 100644
>>> --- a/io_uring/sqpoll.h
>>> +++ b/io_uring/sqpoll.h
>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>> 	pid_t			task_pid;
>>> 	pid_t			task_tgid;
>>>
>>> +	u64			work_time;
>>> 	unsigned long		state;
>>> 	struct completion	exited;
>>> };
>>  
>> Hi, Jens
>> I have modified the code according to your suggestions.
>> Do you have any other comments?
>
>Out of town this week, I'll check next week. But from a quick look,
>looks much better now.
 
Hi, Jens
Do you have time to check now?

--
Xiaobing Li

