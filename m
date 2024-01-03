Return-Path: <io-uring+bounces-372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0185822823
	for <lists+io-uring@lfdr.de>; Wed,  3 Jan 2024 06:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECA7A1C22ED0
	for <lists+io-uring@lfdr.de>; Wed,  3 Jan 2024 05:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E20618034;
	Wed,  3 Jan 2024 05:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N+25HVh+"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C118021
	for <io-uring@vger.kernel.org>; Wed,  3 Jan 2024 05:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240103055809epoutp02d1709e69bf7fe075cef4d4494d15fede~mwMt_hJ5R2270222702epoutp02X
	for <io-uring@vger.kernel.org>; Wed,  3 Jan 2024 05:58:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240103055809epoutp02d1709e69bf7fe075cef4d4494d15fede~mwMt_hJ5R2270222702epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1704261489;
	bh=Pf2dZcRj3DhWgVRNDm7EChH8TNgNl1cEinXghVV1m/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+25HVh+4ML3wkudkDl6FBs2QAVINFb0EWrDUTHUIEi6+0pctB5eASaZ9brs0+sMX
	 bEslyMbpCxQgfNRl8+2Wluh6Ef04tYw1efx/svHveXLsX39xUx04iTL9J2azFz9x49
	 LCGW6hGTsNxDi8Ol1AJYjwrhwn1VaV+7eWIExtVk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240103055808epcas5p15ffe7e7ea10f818af80b259ada734a29~mwMtYYyNb1619516195epcas5p1G;
	Wed,  3 Jan 2024 05:58:08 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4T4fCM2ZRrz4x9QB; Wed,  3 Jan
	2024 05:58:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6D.20.19369.E67F4956; Wed,  3 Jan 2024 14:58:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240103055746epcas5p148c2b06032e09956ddcfc72894abc82a~mwMY6WIXB3067430674epcas5p1x;
	Wed,  3 Jan 2024 05:57:46 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240103055746epsmtrp296aaac7ef0f47548fc855c3e5f4fd4ee~mwMY5mVys1420114201epsmtrp2e;
	Wed,  3 Jan 2024 05:57:46 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-90-6594f76e952d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A9.EE.08817.A57F4956; Wed,  3 Jan 2024 14:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240103055745epsmtip1f241b366c1140cb8ec56c16fb7bdc7fa~mwMXbCpzL2375623756epsmtip1E;
	Wed,  3 Jan 2024 05:57:44 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v6] io_uring: Statistics of the true utilization of
 sq threads.
Date: Wed,  3 Jan 2024 13:49:37 +0800
Message-ID: <20240103054940.2121301-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmlm7e9ympBgcnalrMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBTo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZyyf/oO5oFOg4tPmtAbG5zxdjBwcEgImEjs+ZHUxcnEI
	CexhlNjdO48JwvnEKHHh6GlGCOcbo0Tr5vtADidYx/+vJ5ghEnsZJd50vWKHcL4yStye9ZkJ
	pIpNQFvi+rouVhBbREBYYn9HKwtIEbPAX0aJCS9/M4MkhAUiJTq/nWcCOYRFQFXixocIkDCv
	gJ3Et+ZFbBDb5CUW71gOVs4pYCtx5OMudogaQYmTM5+wgNjMQDXNW2eDXSQhMJVD4tCiG6wQ
	zS4Svy/0s0DYwhKvjm9hh7ClJD6/2wu1oFjiSM93VojmBkaJ6bevQhVZS/y7socF5DhmAU2J
	9bv0IcKyElNPrWOCWMwn0fv7CRNEnFdixzwYW1Vi9aWHUHulJV43/IaKe0hMapsMDdMJjBK/
	dk9lm8CoMAvJQ7OQPDQLYfUCRuZVjFKpBcW56anJpgWGunmp5fBoTs7P3cQITq1aATsYV2/4
	q3eIkYmD8RCjBAezkgjv+nWTU4V4UxIrq1KL8uOLSnNSiw8xmgJDfCKzlGhyPjC555XEG5pY
	GpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fEwSnVwBQ1v/dP/MrZr9XMXD6eWLiI
	MU/f/GnAo6vmnHFXdi//riB3cDnXHu2ST5NPF3RciRHbul7xjWjz77eybJPX1TrofpdRX+C/
	4KbwEa2P8pYbFooaGx3l2r0mcvmd9Rb2q99dOCX/qzQy6HIQt2fpjqdlzd/Cco3OXLopzPNb
	+uZ6vpKq/t92ua2yniUzg7a1xd3mNOhYsf5Bg8T7JcLVnxfZiqZuq2gS7bt4pqLzffHZqH/P
	tLa3Psg0nJ+bf+SIYssNNYb6mJ5Y5jnnsndGJR7Y/Zpf/rM9D3tT056NQiFnMo55zpe3L6xa
	Hl6VvyGzI0EwqG//aj6Wt1G6nNoTZ014WrBG/0zBosXmvRU/lZRYijMSDbWYi4oTATgei0A2
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSnG7U9ympBtffKFjMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgylk//wVzQKVDxaXNaA+Nzni5G
	Tg4JAROJ/19PMHcxcnEICexmlJhwfCljFyMHUEJa4s+fcogaYYmV/56zQ9R8ZpToazrJBJJg
	E9CWuL6uixXEFgEq2t/RygJiMwt0Mkm8/qwHYgsLhEscbL4FNpNFQFXixocIkDCvgJ3Et+ZF
	bBDz5SUW71jODGJzCthKHPm4ix3EFhKwkbiyexsbRL2gxMmZT1hAxjALqEusnycEsUleonnr
	bOYJjIKzkFTNQqiahaRqASPzKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4AjR0trB
	uGfVB71DjEwcjIcYJTiYlUR416+bnCrEm5JYWZValB9fVJqTWnyIUZqDRUmc99vr3hQhgfTE
	ktTs1NSC1CKYLBMHp1QDk/2XQ1t7d0ys4e54drc6WMB8ha1LzNzzdxIrMvZW9V1bt/eUwEqz
	N5u23JoaINDy8MF/AynJw0JMun/Pxxf1GO9KPPS9nuHOdn7ZxJuVZ6ds2CHf02l84KBr986A
	PdMbZibpzX/37CdrbEbfl/2R/rvEFhezBHTdfct5/XHZBqMTPM0pS5sLcmJ5v/5N0w3ZcK2r
	eYM8Y1yF1LHWwx+unG/12MzetEP7U7d2TBvHlPftdZ38pjwuuc9vrTu/adn6uPh3KivffJn9
	/nPT+6QDcdIZU9rUcut91SJ0u9L557hdfq110KGZ5+rXhrXHi2+Iy/PtZeGPTDi9RefbHKmZ
	6m+2+qR09BYXCWWuKlStVGIpzkg01GIuKk4EAA5fCGD/AgAA
X-CMS-MailID: 20240103055746epcas5p148c2b06032e09956ddcfc72894abc82a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240103055746epcas5p148c2b06032e09956ddcfc72894abc82a
References: <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
	<CGME20240103055746epcas5p148c2b06032e09956ddcfc72894abc82a@epcas5p1.samsung.com>

On 12/30/23 9:27 AM, Pavel Begunkov wrote:
> Why it uses jiffies instead of some task run time?
> Consequently, why it's fine to account irq time and other
> preemption? (hint, it's not)
> 
> Why it can't be done with userspace and/or bpf? Why
> can't it be estimated by checking and tracking
> IORING_SQ_NEED_WAKEUP in userspace?
> 
> What's the use case in particular? Considering that
> one of the previous revisions was uapi-less, something
> is really fishy here. Again, it's a procfs file nobody
> but a few would want to parse to use the feature.
> 
> Why it just keeps aggregating stats for the whole
> life time of the ring? If the workload changes,
> that would either totally screw the stats or would make
> it too inert to be useful. That's especially relevant
> for long running (days) processes. There should be a
> way to reset it so it starts counting anew.

Hi, Jens and Pavel,
I carefully read the questions you raised.
First of all, as to why I use jiffies to statistics time, it
is because I have done some performance tests and found that
using jiffies has a relatively smaller loss of performance 
than using task run time. Of course, using task run time is 
indeed more accurate.  But in fact, our requirements for 
accuracy are not particularly high, so after comprehensive 
consideration, we finally chose to use jiffies.
Of course, if you think that a little more performance loss 
here has no impact, I can use task run time instead, but in 
this case, does the way of calculating sqpoll thread timeout
also need to be changed, because it is also calculated through
jiffies.
Then there’s how to use this metric.
We are studying some optimization methods for io-uring, including
performance and CPU utilization, but we found that there is
currently no tool that can observe the CPU ratio of sqthread's 
actual processing IO part, so we want to merge this method  that
can observe this value so that we can more easily observe the 
optimization effects.

Best regards,
--
Xiaobing Li

