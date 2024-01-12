Return-Path: <io-uring+bounces-393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDC682B914
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 02:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 356A6B24D47
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 01:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FEB2A3F;
	Fri, 12 Jan 2024 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ah4DutBe"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46AD171C4
	for <io-uring@vger.kernel.org>; Fri, 12 Jan 2024 01:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240112012257epoutp02a231d31a7fe0d7f8639325565adb104d~pdQBG9zIt2245922459epoutp02D
	for <io-uring@vger.kernel.org>; Fri, 12 Jan 2024 01:22:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240112012257epoutp02a231d31a7fe0d7f8639325565adb104d~pdQBG9zIt2245922459epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705022578;
	bh=SFU7BaLlItzshQF51gNiPtOFAobwD70oxh7hUcOIdQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ah4DutBeudNLZhDDJP8SKSeLwgwAx6vr6ie06s6lhSG/8lN85bBXajadAY9zLQvxS
	 JaG91Wg5FbvHxVMSriIAEka3Um8RyfLGxPC2oMUpEnXP1gQcytrecFJC0/aV11Dwy6
	 AWY8QGb4QusJYvnvRRo3rl8m0zNVkw/YuIG67F/c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240112012256epcas5p17a75106713f4d72ae60e9727e033ddf7~pdP-_ENFF2394323943epcas5p1c;
	Fri, 12 Jan 2024 01:22:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TB3gg3jxbz4x9Pw; Fri, 12 Jan
	2024 01:22:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.FA.10009.F6490A56; Fri, 12 Jan 2024 10:22:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240112012013epcas5p38c70493069fb14da02befcf25e604bc1~pdNnrMaMm2285922859epcas5p3K;
	Fri, 12 Jan 2024 01:20:13 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240112012013epsmtrp205ed4fe17598397c86e63ba7a850d2ff~pdNnqQ6002752627526epsmtrp2n;
	Fri, 12 Jan 2024 01:20:13 +0000 (GMT)
X-AuditID: b6c32a4a-ff1ff70000002719-65-65a0946f0aac
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.E7.08817.DC390A56; Fri, 12 Jan 2024 10:20:13 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240112012011epsmtip1c7980d0818c780cc9d6e19307ba4b481~pdNmO1XZG0923009230epsmtip1g;
	Fri, 12 Jan 2024 01:20:11 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v6] io_uring: Statistics of the true utilization of
 sq threads.
Date: Fri, 12 Jan 2024 09:12:02 +0800
Message-ID: <20240112011202.1705067-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b0c67327-5131-4cde-a8bd-df69b1f300e5@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmum7+lAWpBrfWS1nMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBTo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZ9z/EV/QKlHxeO0S1gbGDcJdjJwcEgImEju/v2DvYuTi
	EBLYzSix4OZPdpCEkMAnRomLOyQgEt8YJc6sucIK07H6yGpmiMReRonvb+awQjhfGSV2zFrL
	CFLFJqAtcX1dF1iHiICwxP6OVhaQImaBv4wSE17+ZgZJCAtESnR+O88EYrMIqEpM3rMWzOYV
	sJNYNbEFap28xOIdy8HqOQVsJfrfXGeGqBGUODnzCQuIzQxU07x1NjNEfSuHxKb11hC2i8SJ
	F2cZIWxhiVfHt7BD2FISn9/tZYOwiyWO9HwH+0BCoIFRYvrtq1BF1hL/ruwBWsABtEBTYv0u
	fYiwrMTUU+uYIPbySfT+fsIEEeeV2DEPxlaVWH3pIQuELS3xuuE3E8gYCQEPicf7xCCBNYFR
	Yv/+1+wTGBVmIXlnFpJ3ZiFsXsDIvIpRMrWgODc9tdi0wCgvtRweycn5uZsYwWlVy2sH48MH
	H/QOMTJxMB5ilOBgVhLhVfg8J1WINyWxsiq1KD++qDQntfgQoykwvCcyS4km5wMTe15JvKGJ
	pYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUwVe0sD9LclPq6WKmMKt5v4
	Q0hZfKotn9Teap+5hZ+YpG5+eXkuQOSRnKfaR84XQubvY44U1ua/P2I7c7fE0qO/HrRnPmDq
	Vdxxl6n0zt6M5LoZd/9zH/8tNS//8zmHLb4JOYfLpnItM56d8f3qxODPVuVvVwqvWjKVLeNO
	hJHp6alFR1wjyn+fyvhtkPykcO+eP8dtwkWXlc148TrqlVHA9xxVjv0trE83fllw7BOrYFJp
	ZnXp7eYK1hkTq/y//kp90eu8oibMSchQo+E01/X3C5TKyjvC++tiX06aGyDm35tWt8Jl5cdm
	7mvVdffLxQ9asr/bqOj2yiyTM+dm2rWnj66aCfA+Wfynt3AH53MlluKMREMt5qLiRAAqCHtU
	NAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO7ZyQtSDZb8YrOYs2obo8Xqu/1s
	Fu9az7FYHP3/ls3iV/ddRoutX76yWlzeNYfN4tleTosvh7+zW5yd8IHVYuqWHUwWHS2XGR14
	PHbOusvucflsqUffllWMHp83yQWwRHHZpKTmZJalFunbJXBl3P8RX9AqUfF47RLWBsYNwl2M
	nBwSAiYSq4+sZu5i5OIQEtjNKHHr7Fv2LkYOoIS0xJ8/5RA1whIr/z1nh6j5zChx/WQ3G0iC
	TUBb4vq6LlYQWwSoaH9HKwuIzSzQySTx+rMeiC0sEC5xsPkWI4jNIqAqMXnPWiYQm1fATmLV
	xBZWiAXyEot3LGcGsTkFbCX631wHs4UEbCS+nWhggagXlDg58wnUfHmJ5q2zmScwCsxCkpqF
	JLWAkWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZw2Gtp7WDcs+qD3iFGJg7GQ4wS
	HMxKIrwKn+ekCvGmJFZWpRblxxeV5qQWH2KU5mBREuf99ro3RUggPbEkNTs1tSC1CCbLxMEp
	1cBkvsy62FAv0Lxt79bkjLLeNbWBR+wTr0S+Tll+OHJp8YdZAbezWjVPbl83iTdq1cIjYmtE
	GCd9NQuP/BDNcvMGg7HAxCnzrbMD1mcfDckNq1joWnZtT4uybHnEuX8GicUzLnBsn99sEBN9
	XkPu2/26bXOnvO9Z1Hpy3T9FxYP9c5Mk5+zmjlBb0Xbx6JXatq7GRB9uuZtymZOe7Kwp1/f/
	6HrQmT3wUqSo5YKTU9c9C1wt+Ub5YMX2C39E/bxOmTE6nH59cc4FTjfRJrU3+w2+aCd9XMv4
	39Fci8kn7pj7IW/zw/Pi1ztoXecRMNfakH/m85x2vR8fhY5Pebq46OTGo2WlfpV8bF7WCTsL
	XqkrsRRnJBpqMRcVJwIAqUTybeoCAAA=
X-CMS-MailID: 20240112012013epcas5p38c70493069fb14da02befcf25e604bc1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240112012013epcas5p38c70493069fb14da02befcf25e604bc1
References: <b0c67327-5131-4cde-a8bd-df69b1f300e5@kernel.dk>
	<CGME20240112012013epcas5p38c70493069fb14da02befcf25e604bc1@epcas5p3.samsung.com>

On 1/10/24 16:15 AM, Jens Axboe wrote:
>On 1/10/24 2:05 AM, Xiaobing Li wrote:
>> On 1/5/24 04:02 AM, Pavel Begunkov wrote:
>>> On 1/3/24 05:49, Xiaobing Li wrote:
>>>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>>>> Why it uses jiffies instead of some task run time?
>>>>> Consequently, why it's fine to account irq time and other
>>>>> preemption? (hint, it's not)
>>>>>
>>>>> Why it can't be done with userspace and/or bpf? Why
>>>>> can't it be estimated by checking and tracking
>>>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>>>
>>>>> What's the use case in particular? Considering that
>>>>> one of the previous revisions was uapi-less, something
>>>>> is really fishy here. Again, it's a procfs file nobody
>>>>> but a few would want to parse to use the feature.
>>>>>
>>>>> Why it just keeps aggregating stats for the whole
>>>>> life time of the ring? If the workload changes,
>>>>> that would either totally screw the stats or would make
>>>>> it too inert to be useful. That's especially relevant
>>>>> for long running (days) processes. There should be a
>>>>> way to reset it so it starts counting anew.
>>>>
>>>> Hi, Jens and Pavel,
>>>> I carefully read the questions you raised.
>>>> First of all, as to why I use jiffies to statistics time, it
>>>> is because I have done some performance tests and found that
>>>> using jiffies has a relatively smaller loss of performance
>>>> than using task run time. Of course, using task run time is
>>>
>>> How does taking a measure for task runtime looks like? I expect it to
>>> be a simple read of a variable inside task_struct, maybe with READ_ONCE,
>>> in which case the overhead shouldn't be realistically measurable. Does
>>> it need locking?
>> 
>> The task runtime I am talking about is similar to this:
>> start = get_system_time(current);
>> do_io_part();
>> sq->total_time += get_system_time(current) - start;
>
>Not sure what get_system_time() is, don't see that anywhere.
>
>> Currently, it is not possible to obtain the execution time of a piece of 
>> code by a simple read of a variable inside task_struct. 
>> Or do you have any good ideas?
>
>I must be missing something, because it seems like all you need is to
>read task->stime? You could possible even make do with just logging busy
>loop time, as getrusage(RUSAGE_THREAD, &stat) from userspace would then
>give you the total time.
>
>stat.ru_stime would then be the total time, the thread ran, and
>1 - (above_busy_stime / stat.ru_stime) would give you the time the
>percentage of time the thread ran and did useful work (eg not busy
>looping.

getrusage can indeed get the total time of the thread, but this introduces an 
extra function call, which is relatively more complicated than defining a variable.
In fact, recording the total time of the loop and the time of processing the 
IO part can achieve our observation purpose. Recording only two variables will 
have less impact on the existing performance, so why not  choose a simpler 
and effective method.

--
Xiaobing Li

