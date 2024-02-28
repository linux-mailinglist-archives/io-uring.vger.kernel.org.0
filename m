Return-Path: <io-uring+bounces-790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9746B86A8B3
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 08:12:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E44531F23EDB
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 07:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830992374A;
	Wed, 28 Feb 2024 07:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="V/sXHJ5E"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42EC22EF9
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 07:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709104324; cv=none; b=kvFln/XVFYqaLUKTM0IPeGQ6WCNhYje5WAb77P3fbiP5XibxdUHfBBB8m8kUUqOI31aAX8uj57H9vuY5ge2ZE9hyE/DSW3+Tmx57rosIPVpYrqKv5fYoNmbNYA84QKgitn+bsrItMfkfXpTgdQ/VGWk8/dSr+vYJa2K8RcsYYEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709104324; c=relaxed/simple;
	bh=tzfxafuNKbhOtn2FYYTqc/CaHJFNymtSrhTBAv67CIk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VC3xENGP82mRq541uM4EkknfzxWqqu+b7/qWD0PlttIOm1UrKvkDzYRb8Yfw3wRe0viYyh8w6LJQRXTljbv5qIQzsEM4jauwkdLaeYtZEnds5FdvJYQR6z0w5SBOaFcDoXltJhhOA2QBZDk8KDO0OnUMUcmw6T7tOpuWfSqMHmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=V/sXHJ5E; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240228071152epoutp0379d680aaed485eccaadec6f49334ae14~39VFDUPuf2339323393epoutp03T
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 07:11:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240228071152epoutp0379d680aaed485eccaadec6f49334ae14~39VFDUPuf2339323393epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1709104313;
	bh=FxM63+wxM0TTZ0any1xpD43Jo9Apgd618WROCp12kLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/sXHJ5EBgYNmsco57DUpdHQrEzkNogv9fEi2C3O/G4fVRU6I14MvOgx8+3lVSNyG
	 JT0zxjLlr8Nzv56ELnVEIMRksGqUKszWGagqTKn3iQJCtp2BaXbmtw2mM+j2oSjp/n
	 Qp7VRsEZl/dQz4eKEaXu8dXwJSq65GS4ouMch4jg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240228071152epcas5p2b109e03255635d8fea5d3f6ac1fc1b9f~39VEY6pu91818518185epcas5p2C;
	Wed, 28 Feb 2024 07:11:52 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Tl5BZ3v63z4x9Q1; Wed, 28 Feb
	2024 07:11:50 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	ED.6D.09634.6BCDED56; Wed, 28 Feb 2024 16:11:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240228063029epcas5p47871105810840bfa7dc9da8d710ba2ec~38w8fLAvy2235322353epcas5p4f;
	Wed, 28 Feb 2024 06:30:29 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240228063029epsmtrp2ea2585878c966c69b04f67bf80ea7fdc~38w8eRuuh1036510365epsmtrp2B;
	Wed, 28 Feb 2024 06:30:29 +0000 (GMT)
X-AuditID: b6c32a49-eebff700000025a2-9d-65dedcb6b16c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	37.B2.18939.503DED56; Wed, 28 Feb 2024 15:30:29 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240228063028epsmtip2ac1eae56ba227873d6e5b6fa391b0990~38w65hDFa2859828598epsmtip2b;
	Wed, 28 Feb 2024 06:30:28 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com
Subject: Re: Re: [PATCH v9] io_uring: Statistics of the true utilization of
 sq threads.
Date: Wed, 28 Feb 2024 14:30:23 +0800
Message-Id: <20240228063023.1428736-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <94284465-0b46-4df4-842e-a0c65dee5908@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhu62O/dSDfZ8FLeYs2obo8Xqu/1s
	Fqf/PmaxeNd6jsXi6P+3bBa/uu8yWmz98pXV4vKuOWwWz/ZyWnw5/J3d4uyED6wWU7fsYLLo
	aLnMaNF14RSbA5/Hzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTMvHRbJe/g
	eOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoBOVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZdxYuZS/oUa44fuMqawPjf5kuRk4O
	CQETiQdNf1m6GLk4hAR2M0ps3P2ZFcL5xChxrPkFG5yzfVs3I0zLgdPvmSESOxklzr35yATh
	/GKUmDJxN1gVm4C2xPV1XawgtoiAsMT+jlawJcwC65gkPu1oYwdJCAtESjRsvgGU4OBgEVCV
	2N0LdhSvgJ3E0bvn2CC2yUvsP3iWGcTmFLCV+HP8BBNEjaDEyZlPWEBsZqCa5q2zwS6SEOjl
	kPi0eRpUs4vE/Rl/oM4Wlnh1fAs7hC0l8fndXqiaYokjPd9ZIZobGCWm374KVWQt8e/KHrDj
	mAU0Jdbv0ocIy0pMPbWOCWIxn0Tv7ydMEHFeiR3zYGxVidWXHrJA2NISrxt+Q8U9JK7/2A4N
	ugmMEm2nfzFPYFSYheShWUgemoWwegEj8ypGydSC4tz01GLTAsO81HJ4PCfn525iBCdcLc8d
	jHcffNA7xMjEwXiIUYKDWUmEV0bwbqoQb0piZVVqUX58UWlOavEhRlNggE9klhJNzgem/LyS
	eEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpiSuHVjp21cY/HC9vw+
	mwil1GRv5ZvXXx5eUVzff1Lxp1JnyqKmM29OTF08KXvmz2tioQahhjLJx6c/bJ5ZLjbBxm59
	9c/ePSoHlhmdS0gQf7Cpt7WmpqtBM3b/jYUfdk+eYnmxT+OSTvEecc07zJfVQpbE7D194an9
	3P2vgt9MFF9X/PmJ9Mk9f67PmLKR9fudxIU7t9i6TJlYyt/4+pTYyuhofYX3K/8lKfWdsQj4
	Xrqp5UzOC67Vn6/1BzJ9k34jsvGixe6/F6MunHrsIf5aeZ7w9xlPGIJ9ffd0ZF/jmPl608ST
	bRdlOw60+Ft0JMZf6rp6lm3u5CcBEotWPveWZHkVJC5fsDwn2jc4W8E9VImlOCPRUIu5qDgR
	AGUJKblBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSvC7r5XupBts3G1jMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8adhUvZC3qU
	K47fuMrawPhfpouRk0NCwETiwOn3zF2MXBxCAtsZJeZtuQPkcAAlpCX+/CmHqBGWWPnvOTtE
	zQ9Gic9Xv7OBJNgEtCWur+tiBbFFgIr2d7SygBQxC+xhkng37TNYQlggXKLz72YmkKEsAqoS
	u3vBFvMK2EkcvXuODWKBvMT+g2eZQWxOAVuJP8dPMIHYQgI2En1PdrFA1AtKnJz5BMxmBqpv
	3jqbeQKjwCwkqVlIUgsYmVYxiqYWFOem5yYXGOoVJ+YWl+al6yXn525iBEeBVtAOxmXr/+od
	YmTiYDzEKMHBrCTCKyN4N1WINyWxsiq1KD++qDQntfgQozQHi5I4r3JOZ4qQQHpiSWp2ampB
	ahFMlomDU6qBadaBeZ1KVgFTn/qcC+aeqNVzvC+k+q7r5RWX9ivNjzIVkPdY/Dw9oPl0ZvvD
	26esBfZXdlr7zrCtD5/v+bLOQ97y2vrIO5a7cyrkgpe37F66md9uTqKFd+z3nmc3N3VbWrR5
	tc/ZZawo9eWdZrG/n3HPhTPtsZny7FfTDiqnZarqRy0NSPfJL+v3vJjlYjRj/cnIa6o7n+2+
	+MvpmWjBl93vJnfb2rYtF97ItPb1cY4Ki8meIlWKjdN3pt6ftdPf34rh3YzePGW2+Tkr9/nm
	xDGI+29W513FOVHk0fdIMV1lgfyS50IGc4VzqpdtPeLxKdfz/by5c1apS7Sxzb+9xeMo91nP
	CaXaLYcz+uOUWIozEg21mIuKEwF2SoAo8QIAAA==
X-CMS-MailID: 20240228063029epcas5p47871105810840bfa7dc9da8d710ba2ec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240228063029epcas5p47871105810840bfa7dc9da8d710ba2ec
References: <94284465-0b46-4df4-842e-a0c65dee5908@kernel.dk>
	<CGME20240228063029epcas5p47871105810840bfa7dc9da8d710ba2ec@epcas5p4.samsung.com>

On 2/27/24 14:36, Jens Axboe wrote:
>On 2/26/24 10:45 PM, Xiaobing Li wrote:
>> On 2/21/24 10:28, Jens Axboe wrote:
>>> On 2/20/24 7:04 PM, Xiaobing Li wrote:
>>>> On 2/19/24 14:42, Xiaobing Li wrote:
>>>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>>>> index 976e9500f651..37afc5bac279 100644
>>>>> --- a/io_uring/fdinfo.c
>>>>> +++ b/io_uring/fdinfo.c
>>>>> @@ -55,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>> 	struct io_ring_ctx *ctx = f->private_data;
>>>>> 	struct io_overflow_cqe *ocqe;
>>>>> 	struct io_rings *r = ctx->rings;
>>>>> +	struct rusage sq_usage;
>>>>> 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>>>> 	unsigned int sq_head = READ_ONCE(r->sq.head);
>>>>> 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
>>>>> @@ -64,6 +65,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>> 	unsigned int sq_shift = 0;
>>>>> 	unsigned int sq_entries, cq_entries;
>>>>> 	int sq_pid = -1, sq_cpu = -1;
>>>>> +	u64 sq_total_time = 0, sq_work_time = 0;
>>>>> 	bool has_lock;
>>>>> 	unsigned int i;
>>>>>
>>>>> @@ -147,10 +149,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>
>>>>> 		sq_pid = sq->task_pid;
>>>>> 		sq_cpu = sq->sq_cpu;
>>>>> +		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
>>>>> +		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
>>>>> +		sq_work_time = sq->work_time;
>>>>> 	}
>>>>>
>>>>> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>>>>> 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
>>>>> +	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
>>>>> +	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
>>>>> 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
>>>>> 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
>>>>> 		struct file *f = io_file_from_index(&ctx->file_table, i);
>>>>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>>>>> index 65b5dbe3c850..006d7fc9cf92 100644
>>>>> --- a/io_uring/sqpoll.c
>>>>> +++ b/io_uring/sqpoll.c
>>>>> @@ -219,10 +219,22 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>>>>> 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>>>>> }
>>>>>
>>>>> +static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>>>>> +{
>>>>> +		struct rusage end;
>>>>> +
>>>>> +		getrusage(current, RUSAGE_SELF, &end);
>>>>> +		end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>>>>> +		end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
>>>>> +
>>>>> +		sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>>>>> +}
>>>>> +
>>>>> static int io_sq_thread(void *data)
>>>>> {
>>>>> 	struct io_sq_data *sqd = data;
>>>>> 	struct io_ring_ctx *ctx;
>>>>> +	struct rusage start;
>>>>> 	unsigned long timeout = 0;
>>>>> 	char buf[TASK_COMM_LEN];
>>>>> 	DEFINE_WAIT(wait);
>>>>> @@ -251,6 +263,7 @@ static int io_sq_thread(void *data)
>>>>> 		}
>>>>>
>>>>> 		cap_entries = !list_is_singular(&sqd->ctx_list);
>>>>> +		getrusage(current, RUSAGE_SELF, &start);
>>>>> 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>>>>> 			int ret = __io_sq_thread(ctx, cap_entries);
>>>>>
>>>>> @@ -261,8 +274,10 @@ static int io_sq_thread(void *data)
>>>>> 			sqt_spin = true;
>>>>>
>>>>> 		if (sqt_spin || !time_after(jiffies, timeout)) {
>>>>> -			if (sqt_spin)
>>>>> +			if (sqt_spin) {
>>>>> +				io_sq_update_worktime(sqd, &start);
>>>>> 				timeout = jiffies + sqd->sq_thread_idle;
>>>>> +			}
>>>>> 			if (unlikely(need_resched())) {
>>>>> 				mutex_unlock(&sqd->lock);
>>>>> 				cond_resched();
>>>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>>>> index 8df37e8c9149..4171666b1cf4 100644
>>>>> --- a/io_uring/sqpoll.h
>>>>> +++ b/io_uring/sqpoll.h
>>>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>>>> 	pid_t			task_pid;
>>>>> 	pid_t			task_tgid;
>>>>>
>>>>> +	u64			work_time;
>>>>> 	unsigned long		state;
>>>>> 	struct completion	exited;
>>>>> };
>>>>  
>>>> Hi, Jens
>>>> I have modified the code according to your suggestions.
>>>> Do you have any other comments?
>>>
>>> Out of town this week, I'll check next week. But from a quick look,
>>> looks much better now.
>>  
>> Hi, Jens
>> Do you have time to check now?
>
>Can I ask you to resend it against for-6.9/io_uring? For some reason I
>don't see the original patch on the list.
 
ok, I'll resend a v10.

--
Xiaobing Li

