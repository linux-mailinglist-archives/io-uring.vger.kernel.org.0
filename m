Return-Path: <io-uring+bounces-376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BD0829643
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 10:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A95E286AA4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 09:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05FC3E47B;
	Wed, 10 Jan 2024 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CfAGiVER"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481393DBB9
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 09:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240110092430epoutp04d5d7076503df9fffb60566b4a4c4fca6~o8h4eBaIb2013820138epoutp045
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 09:24:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240110092430epoutp04d5d7076503df9fffb60566b4a4c4fca6~o8h4eBaIb2013820138epoutp045
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1704878670;
	bh=hsT6D1g4JFIvVfkmGFP/Iv6DgAadOcCdaVOlpdYZlUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfAGiVERDjmuC8AWurfvnVhqbiOLXbEdV0ciRR9/xuMN/rbi14SZimBRYRfyg6yIP
	 g2z+TgzAKp/YyzSzQpFVOMjHNxbgSqXL0iNzvhF0cOwA//s6OQsXkbCFktlPUIBcmz
	 ubkeFqqI9A5PHTdy8tYoOPntf7XW6eu1Oh0DOYsM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240110092429epcas5p32d7f35a663c752c1560b42c4d73c1cd7~o8h4GDnnh2952029520epcas5p3p;
	Wed, 10 Jan 2024 09:24:29 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4T92SD32Ksz4x9Q1; Wed, 10 Jan
	2024 09:24:28 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0F.46.10009.C426E956; Wed, 10 Jan 2024 18:24:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240110091327epcas5p493e0d77a122a067b6cd41ecbf92bd6eb~o8YPDMiN00474004740epcas5p4n;
	Wed, 10 Jan 2024 09:13:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240110091327epsmtrp13e63a79e5ce91e2b41b4816341a182aa~o8YPBjbAm2711427114epsmtrp1Y;
	Wed, 10 Jan 2024 09:13:27 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-10-659e624c6128
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.81.08755.6BF5E956; Wed, 10 Jan 2024 18:13:27 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240110091325epsmtip25c47ed3fafff53ce94c4fa9bfe70a03f~o8YNthfy12061220612epsmtip2Z;
	Wed, 10 Jan 2024 09:13:25 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v6] io_uring: Statistics of the true utilization of
 sq threads.
Date: Wed, 10 Jan 2024 17:05:23 +0800
Message-ID: <20240110090523.1612321-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <c9505525-54d9-4610-a47a-5f8d2d3f8de6@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmlq5P0rxUg+cLBSzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM1507mYqmCRXsW7ZObYGxtkSXYycHBICJhKb7u5i72Lk
	4hAS2M0oMfnEZ2YI5xOjxP+WFqjMN0aJlsbjTDAtP1d3QyX2Mkoc3HOQDcL5yiixd9FTZpAq
	NgFtievruli7GDk4RASkJH7f5QCpYQaZ9H79GrAaYYFIic5v58GmsgioSky9vJMVxOYVsJO4
	cOoAK8Q2eYnFO5aD1XMK2Eq0/JzMDlEjKHFy5hMWEJsZqKZ562ywuyUEOjkkZrWeY4ZodpE4
	cOEbO4QtLPHq+BYoW0riZX8blF0scaTnOytEcwOjxPTbV6ES1hL/ruxhAfmAWUBTYv0ufYiw
	rMTUU+uYIBbzSfT+fgINFl6JHfNgbFWJ1ZceskDY0hKvG35DxT0kNt7czQZiCwlMYJTYvCh9
	AqPCLCT/zELyzyyEzQsYmVcxSqYWFOempxabFhjlpZbDozk5P3cTIzi1anntYHz44IPeIUYm
	DsZDjBIczEoivAqf56QK8aYkVlalFuXHF5XmpBYfYjQFBvhEZinR5Hxgcs8riTc0sTQwMTMz
	M7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoFJVKD8i/bcJVu8d790XFhc8fex4VGV
	64HynOnN0/TalT9xTvF7G94f/PqygWzc98NrdeR5zN7XsM0zfN72SHtC6/fT/HUfpz1bwama
	cOOFyOnNViYe/S+9BNbdaHp+Ycb/I+duzC99JjXXtEK7xPXVbANZERlxg1U7kyc3zr3R8/33
	6k+bql0jvR6em9ptt7N69XrPpZsfqc5KnDQvv/PK2j+MOxS2t8hFHrnhume6uJFM94nPW+4I
	tyx9In34mNzRuqN3LtYFMJ7VUt2cctyF9VCt+Ke5GtKddUW9z7VclpgxmOzqY2P7ZzCl2Wva
	o7dXdujLMf9ePV9jQxHD/NN6jmfvVktrVHBV3Dd/pFhxT4mlOCPRUIu5qDgRAMc7vbg2BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWy7bCSvO72+HmpBksWM1rMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgyXnTuZiqYJFexbtk5tgbG2RJd
	jJwcEgImEj9Xd7N3MXJxCAnsZpT49+8tSxcjB1BCWuLPn3KIGmGJlf+eQ9V8ZpT4/fwoG0iC
	TUBb4vq6LlaQehEBKYnfdzlAapgFmpgk+h41MoLUCAuESxxsvgVmswioSky9vJMVxOYVsJO4
	cOoAK8QCeYnFO5Yzg9icArYSLT8ns4PYQgI2EnObn0DVC0qcnPmEBcRmBqpv3jqbeQKjwCwk
	qVlIUgsYmVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgQHvpbmDsbtqz7oHWJk4mA8
	xCjBwawkwqvweU6qEG9KYmVValF+fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkm
	Dk6pBqYdzkf0rWpKfpravP5nflXj+dVv1S6ZfxQ/7lJQ9r6s3pR9+c9Crg+TAiRnrZ+mEHBx
	25/N21Vlt18SvPHdlj2+0qi3ZqM649Edf9+qpt9iqD5tdufIulqGqe7VKkmZUlE62W/eMjDt
	vjJhStoSnVecM2V0i/c+fiTD3al76rqi57vQjWc2KD+pXr926ebqFZc+lSZdX1nos6r08a6V
	mbcDZNjW16xyDHq+fMq2V2UdoXU8e8vtszcIGcw4VP+ej92ksvKu58SeSQ7yZ/tm7QnxkTDc
	dP/v5SmuNjOzp98//NnLK3TzU0l//nALh9DHprYTlpXGOLm39N7t4jZ6GX4i/MkWsztF+5aL
	lsy+Iy2nxFKckWioxVxUnAgAuLFFxOsCAAA=
X-CMS-MailID: 20240110091327epcas5p493e0d77a122a067b6cd41ecbf92bd6eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240110091327epcas5p493e0d77a122a067b6cd41ecbf92bd6eb
References: <c9505525-54d9-4610-a47a-5f8d2d3f8de6@gmail.com>
	<CGME20240110091327epcas5p493e0d77a122a067b6cd41ecbf92bd6eb@epcas5p4.samsung.com>

On 1/5/24 04:02 AM, Pavel Begunkov wrote:
>On 1/3/24 05:49, Xiaobing Li wrote:
>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>> Why it uses jiffies instead of some task run time?
>>> Consequently, why it's fine to account irq time and other
>>> preemption? (hint, it's not)
>>>
>>> Why it can't be done with userspace and/or bpf? Why
>>> can't it be estimated by checking and tracking
>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>
>>> What's the use case in particular? Considering that
>>> one of the previous revisions was uapi-less, something
>>> is really fishy here. Again, it's a procfs file nobody
>>> but a few would want to parse to use the feature.
>>>
>>> Why it just keeps aggregating stats for the whole
>>> life time of the ring? If the workload changes,
>>> that would either totally screw the stats or would make
>>> it too inert to be useful. That's especially relevant
>>> for long running (days) processes. There should be a
>>> way to reset it so it starts counting anew.
>> 
>> Hi, Jens and Pavel,
>> I carefully read the questions you raised.
>> First of all, as to why I use jiffies to statistics time, it
>> is because I have done some performance tests and found that
>> using jiffies has a relatively smaller loss of performance
>> than using task run time. Of course, using task run time is
>
>How does taking a measure for task runtime looks like? I expect it to
>be a simple read of a variable inside task_struct, maybe with READ_ONCE,
>in which case the overhead shouldn't be realistically measurable. Does
>it need locking?

The task runtime I am talking about is similar to this:
start = get_system_time(current);
do_io_part();
sq->total_time += get_system_time(current) - start;

Currently, it is not possible to obtain the execution time of a piece of 
code by a simple read of a variable inside task_struct. 
Or do you have any good ideas?

>> indeed more accurate.  But in fact, our requirements for
>> accuracy are not particularly high, so after comprehensive
>
>I'm looking at it as a generic feature for everyone, and the
>accuracy behaviour is dependent on circumstances. High load
>networking spends quite a good share of CPU in softirq, and
>preemption would be dependent on config, scheduling, pinning,
>etc.

Yes, I quite agree that the accuracy behaviour is dependent on circumstances.
In fact, judging from some test results we have done, the current solution 
can basically meet everyone's requirements, and the error in the calculation 
result of utilization is estimated to be within 0.5%.


>> consideration, we finally chose to use jiffies.
>> Of course, if you think that a little more performance loss
>> here has no impact, I can use task run time instead, but in
>> this case, does the way of calculating sqpoll thread timeout
>> also need to be changed, because it is also calculated through
>> jiffies.
>
>That's a good point. It doesn't have to change unless you're
>directly inferring the idle time parameter from those two
>time values rather than using the ratio. E.g. a simple
>bisection of the idle time based on the utilisation metric
>shouldn't change. But that definitely raises the question
>what idle_time parameter should exactly mean, and what is
>more convenient for algorithms.

We think that idle_time represents the time spent by the sqpoll thread 
except for submitting IO.

In a ring, it may take time M to submit IO, or it may not submit IO in the 
entire cycle. Then we can optimize the efficiency of the sqpoll thread in 
two directions. The first is to reduce the number of rings that no IO submit,
The second is to increase the time M to increase the proportion of time 
submitted IO in the ring.
In order to observe the CPU ratio of sqthread's actual processing IO part, 
we need this patch.

