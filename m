Return-Path: <io-uring+bounces-414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CBF830274
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 10:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE646282952
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 09:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F405214275;
	Wed, 17 Jan 2024 09:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Q/w4HmFm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A2B1426D
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 09:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705484355; cv=none; b=gMDcHgnzrtI0u3+SiYDNLA70y6/ffcpPhhUTX1jWqKJg+LOFMLf0gs+ka9+FbKLWsMQl/vzWOD4UKSns1Rak0GdcKc0xtxIVkM3eR/lYM/Wo3wU9YonYvta1PQvx62WMdtk4HREul+BjCg+OMABe1piAC5+14nxycR7ix8Klqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705484355; c=relaxed/simple;
	bh=OUbyHm3Ep8amQqoXsm1ozhAUSNIBr9wHY6wZYKCwNo4=;
	h=Received:DKIM-Filter:DKIM-Signature:Received:Received:Received:
	 Received:Received:X-AuditID:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:MIME-Version:
	 Content-Transfer-Encoding:X-Brightmail-Tracker:
	 X-Brightmail-Tracker:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:DLP-Filter:X-CFilter-Loop:
	 X-CMS-RootMailID:References; b=NAL8IsnE/1kRfZf5Mw1ZRTQSUdh+/+bKNkmHAUwv4Kr5xWSf4VYfbLb/YMnvOuHr+eHmyJu2rfkheREYvaVxVRwIsGgMHb592NRoJOKXximUe8bgipBYnY7CnWuDdhl6Dcz80MDrI4Qxy8mSKoJeK4MMv96hJF6oCFXXXsyLep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Q/w4HmFm; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240117093904epoutp04f5f6de587151d1069bb9d10f082d217e~rGPmbeIUq1380713807epoutp047
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 09:39:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240117093904epoutp04f5f6de587151d1069bb9d10f082d217e~rGPmbeIUq1380713807epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705484344;
	bh=OGni/UXXm5nQUN7/SK+J7VW0F1JPyAGxNcWJ2RPs0Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/w4HmFmQA4ikyiGyF6/V8L0xa8orvecL+risCpMJLvOLuUNU9wyrqPRPBa4johyJ
	 t7tjP5/L0z1yKgeRxTP0yZJ/nK7AE0GXM83+53LZe/h4bFsSTHo0cZ9IeaPSfBV3EM
	 F4CxARh+CEx8Ss8pV55GUeyarJlwf6xUpY252vvk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240117093903epcas5p33ebf38ce311b3613ceb267cf8b6c6346~rGPly6N7d0819308193epcas5p3G;
	Wed, 17 Jan 2024 09:39:03 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TFLRp0v26z4x9Q3; Wed, 17 Jan
	2024 09:39:02 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FF.DE.19369.530A7A56; Wed, 17 Jan 2024 18:39:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240117084516epcas5p2f0961781ff761ac3a3794c5ea80df45f~rFgoZi9GW2677426774epcas5p25;
	Wed, 17 Jan 2024 08:45:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240117084516epsmtrp129edf63873e49147268cd0de33a16a40~rFgoYynpG3093530935epsmtrp10;
	Wed, 17 Jan 2024 08:45:16 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-91-65a7a0351c8c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	59.0F.08755.C9397A56; Wed, 17 Jan 2024 17:45:16 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240117084515epsmtip1e99bc0aead86dc03cb69452d9c9772bd~rFgnJk8L00794407944epsmtip1P;
	Wed, 17 Jan 2024 08:45:15 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v6] io_uring: Statistics of the true utilization of
 sq threads.
Date: Wed, 17 Jan 2024 16:37:06 +0800
Message-Id: <20240117083706.11766-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e117f6e0-a8bc-4068-8bce-65a7c4e129cf@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmuq7ZguWpBtOvMVrMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBTo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZzw8/p+5YIF6xfxjLxgbGL/KdzFyckgImEjMOfCLrYuR
	i0NIYA+jxKEDS9ghnE+MEk0bF7CBVAkJfGOU+DfDFqbj0IVTUEV7GSVuH+pggXBeMkp8vjiX
	BaSKTUBb4vq6LlYQW0RAWGJ/RytYEbPAX0aJCS9/M4MkhAUiJTq/nWcCsVkEVCU+r/7MCGLz
	CthI/Lv6mx1inbzE/oNnweo5BWwl7p18xAZRIyhxcuYTsGXMQDXNW2czgyyQEJjIIfHm4koW
	iGYXiT8b5jBD2MISr45vgRoqJfGyvw3KLpY40vOdFaK5gVFi+u2rUAlriX9X9gAN4gDaoCmx
	fpc+RFhWYuqpdUwQi/kken8/YYKI80rsmAdjq0qsvvQQ6gZpidcNv6HiHhJX/rQxQoJrAqPE
	9i1n2CYwKsxC8tAsJA/NQli9gJF5FaNUakFxbnpqsmmBoW5eajk8opPzczcxgtOrVsAOxtUb
	/uodYmTiYDzEKMHBrCTC62+wLFWINyWxsiq1KD++qDQntfgQoykwyCcyS4km5wMTfF5JvKGJ
	pYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUxdny9vKd/X27BCuWPOF95d
	6T6bbp1Ze27qfdb1rib/GfcZbNo1nafwQZL2y3nnLAoOyFxOj3u4e+N2mZrvS1dtVzgjv1v+
	mktixELBPX3HnF82N+iZn40vuCn5N067dPvhW5nPu0Qa+NeWcAm+/OogYaI56cRxk6umS54k
	bNQ6+lvap2pW2wk3awfm2VtuXnDflG73tmW99JSFy44tiM5csz4wjfHPxCUbSy5LbNo9VWCC
	S4Rb5aQwvbQrdvlyDI3Oxq/b1comn77+xnTVxlgN45R3ldkvU3v1HmV/WPj615I1UXu2tQvv
	Zwy+rGC9TTna9PD1AiG3KXsiogVEXY9//tU2N+xBkcy1lRPaj0qvUGIpzkg01GIuKk4EAGz2
	6H84BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSnO6cyctTDdZuFbOYs2obo8Xqu/1s
	Fu9az7FYHP3/ls3iV/ddRoutX76yWlzeNYfN4tleTosvh7+zW5yd8IHVYuqWHUwWHS2XGR14
	PHbOusvucflsqUffllWMHp83yQWwRHHZpKTmZJalFunbJXBlPDz+n7lggXrF/GMvGBsYv8p3
	MXJySAiYSBy6cIq9i5GLQ0hgN6PEz/atLF2MHEAJaYk/f8ohaoQlVv57DlXznFHix9pVbCAJ
	NgFtievrulhBbBGgov0drSwgNrNAJ5PE6896ILawQLjEweZbjCA2i4CqxOfVn8FsXgEbiX9X
	f7NDLJCX2H/wLDOIzSlgK3Hv5COw+UJANQ1HWtkg6gUlTs58AnYbs4C6xPp5QhCr5CWat85m
	nsAoOAtJ1SyEqllIqhYwMq9ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOEi3NHYzb
	V33QO8TIxMF4iFGCg1lJhNffYFmqEG9KYmVValF+fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp
	2ampBalFMFkmDk6pBqaNy5PalIxmT5I5ZcshWvI1meWzxYVz59l25rY4LNoafufY6WkyWp6s
	ew5E2vEs3qT31LVrQndsUGpC/pOfvZZ9Ac8cE4T7P+9iO+rBefiBYbtncu7MU1YPRNuuN3Kx
	pKreTp0rE2RYJPFXT5CVuzbeiTPlp9ZHrq9FzILrSnW6rNZPZeV+Vcbo5dLtMJfRifNXzaQQ
	e4MZ5xQnCKsqbPiQyMnZ0FXLaL67nkksbvoi9jkWEp/S3Hq8Pt5/tFrtgXLjYukdRyzLza9Y
	WM9763wt/jCrv3y1m1iv9vm3l6+WPrlw/m78uzM++ROqanc17Gg039IZfElcJtE0Jz3ORXVn
	cuTy0h8mS/I3xSYrsRRnJBpqMRcVJwIAHZ05pQEDAAA=
X-CMS-MailID: 20240117084516epcas5p2f0961781ff761ac3a3794c5ea80df45f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240117084516epcas5p2f0961781ff761ac3a3794c5ea80df45f
References: <e117f6e0-a8bc-4068-8bce-65a7c4e129cf@kernel.dk>
	<CGME20240117084516epcas5p2f0961781ff761ac3a3794c5ea80df45f@epcas5p2.samsung.com>

On 1/12/24 2:58 AM, Jens Axboe wrote:
>On 1/11/24 6:12 PM, Xiaobing Li wrote:
>> On 1/10/24 16:15 AM, Jens Axboe wrote:
>>> On 1/10/24 2:05 AM, Xiaobing Li wrote:
>>>> On 1/5/24 04:02 AM, Pavel Begunkov wrote:
>>>>> On 1/3/24 05:49, Xiaobing Li wrote:
>>>>>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>>>>>> Why it uses jiffies instead of some task run time?
>>>>>>> Consequently, why it's fine to account irq time and other
>>>>>>> preemption? (hint, it's not)
>>>>>>>
>>>>>>> Why it can't be done with userspace and/or bpf? Why
>>>>>>> can't it be estimated by checking and tracking
>>>>>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>>>>>
>>>>>>> What's the use case in particular? Considering that
>>>>>>> one of the previous revisions was uapi-less, something
>>>>>>> is really fishy here. Again, it's a procfs file nobody
>>>>>>> but a few would want to parse to use the feature.
>>>>>>>
>>>>>>> Why it just keeps aggregating stats for the whole
>>>>>>> life time of the ring? If the workload changes,
>>>>>>> that would either totally screw the stats or would make
>>>>>>> it too inert to be useful. That's especially relevant
>>>>>>> for long running (days) processes. There should be a
>>>>>>> way to reset it so it starts counting anew.
>>>>>>
>>>>>> Hi, Jens and Pavel,
>>>>>> I carefully read the questions you raised.
>>>>>> First of all, as to why I use jiffies to statistics time, it
>>>>>> is because I have done some performance tests and found that
>>>>>> using jiffies has a relatively smaller loss of performance
>>>>>> than using task run time. Of course, using task run time is
>>>>>
>>>>> How does taking a measure for task runtime looks like? I expect it to
>>>>> be a simple read of a variable inside task_struct, maybe with READ_ONCE,
>>>>> in which case the overhead shouldn't be realistically measurable. Does
>>>>> it need locking?
>>>>
>>>> The task runtime I am talking about is similar to this:
>>>> start = get_system_time(current);
>>>> do_io_part();
>>>> sq->total_time += get_system_time(current) - start;
>>>
>>> Not sure what get_system_time() is, don't see that anywhere.
>>>
>>>> Currently, it is not possible to obtain the execution time of a piece of 
>>>> code by a simple read of a variable inside task_struct. 
>>>> Or do you have any good ideas?
>>>
>>> I must be missing something, because it seems like all you need is to
>>> read task->stime? You could possible even make do with just logging busy
>>> loop time, as getrusage(RUSAGE_THREAD, &stat) from userspace would then
>>> give you the total time.
>>>
>>> stat.ru_stime would then be the total time, the thread ran, and
>>> 1 - (above_busy_stime / stat.ru_stime) would give you the time the
>>> percentage of time the thread ran and did useful work (eg not busy
>>> looping.
>> 
>> getrusage can indeed get the total time of the thread, but this
>> introduces an extra function call, which is relatively more
>> complicated than defining a variable. In fact, recording the total
>> time of the loop and the time of processing the IO part can achieve
>> our observation purpose. Recording only two variables will have less
>> impact on the existing performance, so why not  choose a simpler and
>> effective method.
>
>I'm not opposed to exposing both of them, it does make the API simpler.
>If we can call it an API... I think the main point was using task->stime
>for it rather than jiffies etc.

Hi, Jens and Pavel
I modified the code according to your opinions.

I got the total time of the sqpoll thread through getrusage. 
eg：

fdinfo.c:
+long sq_total_time = 0;
+long sq_work_time = 0;
if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
	struct io_sq_data *sq = ctx->sq_data;

	sq_pid = sq->task_pid;
	sq_cpu = sq->sq_cpu;
+	struct rusage r;
+	getrusage(sq->thread, RUSAGE_SELF, &r);
+	sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
+	sq_work_time = sq->work_time;
}

seq_printf(m, "SqThread:\t%d\n", sq_pid);
seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
+seq_printf(m, "SqTotalTime:\t%ldus\n", sq_total_time);
+seq_printf(m, "SqWorkTime:\t%ldus\n", sq_work_time);
seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);

The working time of the sqpoll thread is obtained through ktime_get().
eg：

sqpoll.c:
+ktime_t start, diff;
+start = ktime_get();
list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
	int ret = __io_sq_thread(ctx, cap_entries);

	if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
		sqt_spin = true;
}
if (io_run_task_work())
	sqt_spin = true;

+diff = ktime_sub(ktime_get(), start);
+if (sqt_spin == true)
+	sqd->work_time += ktime_to_us(diff);

The test results are as follows:
Every 2.0s: cat /proc/9230/fdinfo/6 | grep -E Sq
SqMask: 0x3
SqHead: 3197153
SqTail: 3197153
CachedSqHead:   3197153
SqThread:       9231
SqThreadCpu:    11
SqTotalTime:    92215321us
SqWorkTime:     15106578us

Do you think this solution work?


