Return-Path: <io-uring+bounces-499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1199841D01
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 08:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28F781F2742E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 07:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099105380F;
	Tue, 30 Jan 2024 07:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AE8VCBBn"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC8A56B71
	for <io-uring@vger.kernel.org>; Tue, 30 Jan 2024 07:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706601155; cv=none; b=LHHFyrSr1BnTWWaacww/btTG7pyWc5eTSn5I0npDq66wHgd4EbKBWFaaBH0+V4LVrioZX42osm4OX/EgJbRrsIWEAPYZfEyPk94RN0/lr2SlcEkiklyZ9GufX93FecLVkB4r8LUwopucLS5XWxttQiT8fy1Id1QpOMDm9eJoxTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706601155; c=relaxed/simple;
	bh=pb/LnA0yM9eURb/c2PSjDZQPoCZrE6NsMFcH1GbD9Bo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EAcjZk+TA0oDghwREnxx4mACOVX8PQPlXYhK6RopJ3lOqH5+KJfMdE9qjvEBSnreB5zSFUWBkTLLok/wsh/CHOWfSXoSJ2UPTBc1YrQzqDHyFa8VjxaSmy0UvQEKL1GBVdrJNaWjMbF8iuzwinU+YUYzf8aedYo1UXFq3oGzFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AE8VCBBn; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240130075225epoutp026d047b2e128c18c5257179d1ab03a61a~vELMRJ37i1163311633epoutp02Y
	for <io-uring@vger.kernel.org>; Tue, 30 Jan 2024 07:52:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240130075225epoutp026d047b2e128c18c5257179d1ab03a61a~vELMRJ37i1163311633epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706601145;
	bh=4GusHRVSl/jPvRw8MbBdoLjJ+enCGbBslEdWi0taXsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE8VCBBnaISokPMzZcplUb+LVI/SgK4DiA1ISBZ1FQffyeWaCWoyhuXxdSgDy6KaO
	 N3J7F4emTp5i9QDkE9HbQPCvlCRuNyczwf33ffiLbaWaa5etKDVnzlh6xSQlEBujZr
	 iKn94s5o+NhohiHeCr3sj6M1MILx+LD2OVByqJTo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240130075224epcas5p1a99b7f76986370fb610abf88792969c8~vELL12u3n1098810988epcas5p12;
	Tue, 30 Jan 2024 07:52:24 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TPHSk5XDGz4x9Q3; Tue, 30 Jan
	2024 07:52:22 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.6F.10009.6BAA8B56; Tue, 30 Jan 2024 16:52:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240130055554epcas5p2ad9d28f1e6c256db540ce985c4351461~vCld8z7hm2990729907epcas5p24;
	Tue, 30 Jan 2024 05:55:54 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240130055554epsmtrp28e51d871603fc187bd3212b2bbf72b87~vCld75MH_2750927509epsmtrp2j;
	Tue, 30 Jan 2024 05:55:54 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-27-65b8aab6cfd0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.3B.18939.A6F88B56; Tue, 30 Jan 2024 14:55:54 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240130055553epsmtip268f856ca6e9327b68145bb173a734122~vClcpXhPU3025130251epsmtip21;
	Tue, 30 Jan 2024 05:55:52 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v7] io_uring: Statistics of the true utilization of
 sq threads.
Date: Tue, 30 Jan 2024 13:47:42 +0800
Message-Id: <20240130054742.417610-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <3044a700-252c-4e87-a0cf-a1fec6e83f8f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmlu62VTtSDXp3aFnMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBTo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZ7y+/Ja1oEm44ufumewNjM38XYwcHBICJhK7ujO6GDk5
	hAR2M0qs++jYxcgFZH9ilDjYtp4Jznn6uI0FpAqk4eeLq4wQiZ2MEpNeHGaBcF4ySpzduwes
	ik1AW+L6ui5WkBUiAlISv+9ygNQwC3xjlHi/fg0zSI2wQKTEgo8z2EBsFgFViedfVoL18grY
	Ssw6eRVqm7zE/oNnmUHmcALFF98pgCgRlDg58wlYCTNQSfPW2cwg8yUE/rJLzL71lhmi10Wi
	c+ldVghbWOLV8S3sELaUxOd3e9kg7GKJIz3fWSGaGxglpt++ClVkLfHvCsgzHEAbNCXW79KH
	CMtKTD21jgliMZ9E7+8nTBBxXokd82BsVYnVlx5C3S8t8brhN1TcQ+Luq6dMkLCewCjxtTFz
	AqPCLCT/zELyzyyEzQsYmVcxSqYWFOempxabFhjlpZbD4zg5P3cTIzipanntYHz44IPeIUYm
	DsZDjBIczEoivD81t6YK8aYkVlalFuXHF5XmpBYfYjQFhvdEZinR5HxgWs8riTc0sTQwMTMz
	M7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoHJav1yBwVp06ONNmsCfpRbrtnldcrU
	o3+2pXHg87MTrllYBCZdcKz2TNaY1jMtc1eTnVKN/ZnZpwO4si5oix3ePauLWXPWz/Ifbo4X
	z6XzFtlsMpms/XLeYu0VNvlOTa/7W6omP6nr7Sjw4CoXXukXmZsWe9Xap9tXcav+vV9H/7x9
	9Mbx9aom1+meNoLebfePT9Aw59tbuWOd595kgXvvX1e9af/3O5LvXdClKbdce3W9DCa2zyr9
	m7ZF9o2WYPwyh5TC+YEzKpuWHLs2u4dhcxr75v2PVrk1s8u2ZTzQXXy6YY/u+4Lft4zj54Wq
	3P2+5kt858WWB5GH4455n2RpniDF3S7b4jbvqNSa18pKLMUZiYZazEXFiQAUqbNvMwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSvG5W/45Ug0m35S3mrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZry+/ZS1oEq74uXsmewNjM38X
	IyeHhICJxM8XVxm7GLk4hAS2M0pcunmUpYuRAyghLfHnTzlEjbDEyn/P2SFqnjNK/Ho3hRkk
	wSagLXF9XRcrSL2IgJTE77scIDXMAk1MEn2PGhlBaoQFwiVWHvzBBGKzCKhKPP+ykgXE5hWw
	lZh18ioLxAJ5if0HzzKDzOEEii++UwASFhKwkXizbiJUuaDEyZlPwGxmoPLmrbOZJzAKzEKS
	moUktYCRaRWjaGpBcW56bnKBoV5xYm5xaV66XnJ+7iZGcLhrBe1gXLb+r94hRiYOxkOMEhzM
	SiK8PzW3pgrxpiRWVqUW5ccXleakFh9ilOZgURLnVc7pTBESSE8sSc1OTS1ILYLJMnFwSjUw
	CV3tcArVDpt+6rfts9jOCaV/+AREru3b3BeSIvJ8yQzF3vWsUgnxO294cNZx5j+4ls3uWlP6
	+7LNGtHQP5mfS+UlO2PcY13nX2m6+qaU1eBxtQSHklHTTU0rq4qqr/ddpsm4CvfdjN/ttfdX
	avjFup7jfJWbS+v2Lfs6Q6Y4Z6bImlj3qcaBOgFbWlq+Zh59quBcbvXld69NGGdB67e28n01
	lrmO6nHxl7dqHup4vKVwmtZbTVYjA4+qyK2tvy8xNSawaJXM38XEtETPxKtG5piq5jt1vdSs
	CJ+bBbfmzpY4fI5va8VHwz9KG5yF1Y907tpxxX6TwqNTSd8MnrftmSbHOcVvnfZOVq+MdCWW
	4oxEQy3mouJEAI9lcAXmAgAA
X-CMS-MailID: 20240130055554epcas5p2ad9d28f1e6c256db540ce985c4351461
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240130055554epcas5p2ad9d28f1e6c256db540ce985c4351461
References: <3044a700-252c-4e87-a0cf-a1fec6e83f8f@gmail.com>
	<CGME20240130055554epcas5p2ad9d28f1e6c256db540ce985c4351461@epcas5p2.samsung.com>

On 1/29/24 15:01, Pavel Begunkov wrote:
>On 1/29/24 07:18, Xiaobing Li wrote:
>> On 1/18/24 19:34, Jens Axboe wrote:
>>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>>> index 8df37e8c9149..c14c00240443 100644
>>>> --- a/io_uring/sqpoll.h
>>>> +++ b/io_uring/sqpoll.h
>>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>>>   	pid_t			task_pid;
>>>>   	pid_t			task_tgid;
>>>>   
>>>> +	long long			work_time;
>>>>   	unsigned long		state;
>>>>   	struct completion	exited;
>>>>   };
>>>
>>> Probably just make that an u64.
>>>
>>> As Pavel mentioned, I think we really need to consider if fdinfo is the
>>> appropriate API for this. It's fine if you're running stuff directly and
>>> you're just curious, but it's a very cumbersome API in general as you
>>> need to know the pid of the task holding the ring, the fd of the ring,
>>> and then you can get it as a textual description. If this is something
>>> that is deemed useful, would it not make more sense to make it
>>> programatically available in addition, or even exclusively?
>> 
>> Hi, Jens and Pavel
>> sorry for the late reply.
>> 
>> I've tried some other methods, but overall, I haven't found a more suitable
>> method than fdinfo.
>
>I wouldn't mind if it's fdinfo only for now, that can be changed later
>if needed. I'm more concerned that reading fdinfo and then parsing it
>is incompatible with the word performance, which you mentioned in the
>context of using 1 vs 2 syscalls to get the stats.
>
>That can be left to be resolved later, however. Let's just be clear
>in docs that stats could be 0, which means the feature is not
>working/disabled.
>
>Another question I raised in my reply (v6 thread), why it's using
>ktime_get(), which same as jiffies but more precise, instead of a
>task time?

Sorry, I forgot to reply to you.
I was thinking wrong. you are right,  we can use "getrusage" to statistics 
the work_time of sqpoll in the ring.

>
>
>> If you think it is troublesome to obtain the PID,  then I can provide
>
>I missed the context, where do we need to know PIDs?

Since obtaining the fdinfo content of sqpoll requires finding the corresponding 
PID first, I guess Jens thinks it is troublesome to manually obtain the PID of 
each sqpoll thread when there are many sqpoll threads.
Therefore, I want to write a script that can automatically output all sqpoll
 statistics.
 
--
Xiaobing Li

