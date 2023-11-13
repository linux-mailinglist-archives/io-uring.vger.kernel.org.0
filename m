Return-Path: <io-uring+bounces-82-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B66E97E967D
	for <lists+io-uring@lfdr.de>; Mon, 13 Nov 2023 06:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94EEC1C20311
	for <lists+io-uring@lfdr.de>; Mon, 13 Nov 2023 05:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFF112B7E;
	Mon, 13 Nov 2023 05:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DcGMil7O"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03B712B69
	for <io-uring@vger.kernel.org>; Mon, 13 Nov 2023 05:44:45 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9F810FD
	for <io-uring@vger.kernel.org>; Sun, 12 Nov 2023 21:44:42 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20231113054430epoutp0367f792d003d858589919c1e628a486d3~XGHP666lB2969529695epoutp03Y
	for <io-uring@vger.kernel.org>; Mon, 13 Nov 2023 05:44:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20231113054430epoutp0367f792d003d858589919c1e628a486d3~XGHP666lB2969529695epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699854270;
	bh=n+9IJbg+E4pf3GdwOBNUAgca2LdO/0XImWLpjniajW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcGMil7OIdpbNdOI+Z0xT1bnXWA9RbXhoXbEa97SzqXuAa7I94ENSj0Kb3hWArP4P
	 jATcil5Boh0/IwV1Im9thuB67euQ+8js7YDC4d97VlY3RmAD7whBCodfMWNda/x7Da
	 wBiudj32PJNGoDscktBVlcSQ4yJJJK0IdsRStTls=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20231113054430epcas5p48317b6a5595bc9a2566961d6798edd69~XGHPiaRSR0066600666epcas5p47;
	Mon, 13 Nov 2023 05:44:30 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4STJK83tmSz4x9Py; Mon, 13 Nov
	2023 05:44:28 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	38.A0.08567.CB7B1556; Mon, 13 Nov 2023 14:44:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231113031827epcas5p2e6e858292a3cd4b9e03b4615d972b22d~XEHuOEVsb2866328663epcas5p2H;
	Mon, 13 Nov 2023 03:18:27 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231113031827epsmtrp208259b0f6b435f43128e687028ff6d10~XEHuNUwFM1807418074epsmtrp2t;
	Mon, 13 Nov 2023 03:18:27 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-3c-6551b7bcc812
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.5C.18939.38591556; Mon, 13 Nov 2023 12:18:27 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20231113031825epsmtip1a3a1699fa70a0b270697ce7f5611744e~XEHs9TaNy1691216912epsmtip1y;
	Mon, 13 Nov 2023 03:18:25 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v2] io_uring: Statistics of the true utilization of
 sq threads.
Date: Mon, 13 Nov 2023 11:10:40 +0800
Message-Id: <20231113031040.1391334-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <60464608-a9b7-4cf8-bd6d-c982210c6f83@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmhu6e7YGpBsueSlvMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLaZu2cFk0dFymdGB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IxDF9YzF3xjqWhtXMXSwNjO0sXIySEhYCLx99RjVhBbSGA3o8T6
	t9xdjFxA9idGia4jb9ngnLtdJ+A6/ixpZoZI7GSU6N/ylgWi/SWjRHtfKYjNJqAtcX1dF9hY
	EQFhif0drSwgDcwCfxklJrz8zQySEBaIlFg/9T5YM4uAqsTdbUuYQGxeATuJ2d+7obbJS+w/
	eBasnlPAVuLHipPsEDWCEidnPgGrYQaqad46G+wiCYGv7BKXNq5jgmh2kdj57BorhC0s8er4
	FnYIW0ri87u9bBB2scSRnu+sEM0NjBLTb1+FKrKW+HdlD9AGDqANmhLrd+lDhGUlpp6CmM8s
	wCfR+/sJ1C5eiR3zYGxVidWXHkI9IC3xuuE3VNxD4sXa7UyQoJvAKLFo2jHmCYwKs5A8NAvJ
	Q7MQVi9gZF7FKJlaUJybnppsWmCYl1oOj+bk/NxNjOCEquWyg/HG/H96hxiZOBgPMUpwMCuJ
	8OZpBqQK8aYkVlalFuXHF5XmpBYfYjQFhvhEZinR5HxgSs8riTc0sTQwMTMzM7E0NjNUEud9
	3To3RUggPbEkNTs1tSC1CKaPiYNTqoFptu2+k4LFq+fqSN7asfGR9Xel9Q4iv2+v6a105bJ2
	7n7wZ9HE3oL50XoPqsOfn2312KrBYRidPHurQ8Val+uBfy659DUuUWRzEim25G1IPrbH2CJ1
	frnMU5VN1rHf58kdXpby8o3YXf+C1rxImblpalPdVUytps6cHbbcNURV9W3Aj+nvdqcHrr3Z
	Okvkblh0bfX8bz+1G1yXREfGGu+5JLzg4Nd9s+005PJ90jQ+/nJ7//bJwpB7phfOrZE+056d
	FLWpxyXrxN3Z2stCi/IXGSnHFGqcLVYMD8jZdldmpuLfWT8Pcr6zeffAgd3hxkGhox1KW9me
	TzHi+PDxxonCOe27AjwW6W5NYxV3uvlXiaU4I9FQi7moOBEAPNs3yTEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnG7z1MBUg4erOCzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFlO37GCy6Gi5zOjA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49CF9cwF31gqWhtXsTQwtrN0MXJySAiY
	SPxZ0szcxcjFISSwnVGi/Us/UIIDKCEt8edPOUSNsMTKf8/ZIWqeM0ocv7eaESTBJqAtcX1d
	FyuILQJUtL+jFWwos0Ank8Trz3ogtrBAuMSHC7+YQGwWAVWJu9uWgNm8AnYSs793Qx0hL7H/
	4FlmEJtTwFbix4qT7CC2kICNxOZT59kh6gUlTs58AjVfXqJ562zmCYwCs5CkZiFJLWBkWsUo
	mlpQnJuem1xgqFecmFtcmpeul5yfu4kRHOZaQTsYl63/q3eIkYmD8RCjBAezkghvnmZAqhBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwenVAOTQMQnjZkrHn00
	8zx9ZrsbI+Mi77qyY3LM6ydcW/qAX6HpdKNz4ZNKxqxKzlX9i732cO4uYwgzO6L3epGt3XPF
	HUVfuKbNe39WSoF30qFbnl6HH2z/7boq8vAbZquUQ1XhpbMVlkX2FP/Z0hLHVfX9s9w2wZKo
	fVyrnsRPbL1ZvbjkuNv+Hv75fJetjfsz5T13aIuIfPgppvGl/oTUg5jlbZUuz42mnpv81djE
	/m3VN37r9P/Zq5keRC7+I3YtdvPF7hpTu17DCSujxRi4v1mdU58XveObz6TrvIp3WwUteVfb
	Xf/LXC4buP/fue6f73c9ebfRZFGh6pGjC+YsvLXTekvC46d+/1ibVEySbHefUWIpzkg01GIu
	Kk4EADRPS3/iAgAA
X-CMS-MailID: 20231113031827epcas5p2e6e858292a3cd4b9e03b4615d972b22d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231113031827epcas5p2e6e858292a3cd4b9e03b4615d972b22d
References: <60464608-a9b7-4cf8-bd6d-c982210c6f83@kernel.dk>
	<CGME20231113031827epcas5p2e6e858292a3cd4b9e03b4615d972b22d@epcas5p2.samsung.com>

After careful consideration and testing, I don't think getting the
uring_lock is possible here, for the following reasons:
Due to lock competition, ctx->uring_lock and sq->lock are usually not
available here. The best proof is that the values of SqThread and
SqThreadCpu always output -1. In this case, it is impossible to obtain
the required work_time and total_time values.
In fact, it should be feasible to obtain work_time and total_time by
judging that ctx->sq_data is not NULL, because if the sq thread exits,
the action of reading data will also stop, and the possibility of a null
pointer reference is very low.

