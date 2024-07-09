Return-Path: <io-uring+bounces-2465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DACCB92B2E4
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 11:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 569631F216DB
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 09:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEE912C478;
	Tue,  9 Jul 2024 09:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PxrCpOnX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA1A153824
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 09:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720515610; cv=none; b=b+MTvIN+ySbTJYLIeDfi6Yy6bn7R75j0tEu4bMWaBXCoCmRKSs5kku6syiT+1iTKafVVoNZQYfs+8jr0FgVJNykXdt+06sIknAIQ8z+NnSSQTPtjhxNgDwLtDevjpi+keVD8DWSc2Dfs5SjOjB1+FnNi8oQWXqchJwmY693jsyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720515610; c=relaxed/simple;
	bh=rSEx5LXb19RFI6tQdZ90d+lSOvudX1BzqdW9FYXHaRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=hlmlBgzm91rcrzvY9QcGuhr6WADYO31uzxcRpiqtN1gbpOp5gwlinHL9tT39eLIKmPpI1r4pd5RrbZtv8WNfGLPhFN8gdiFxpi6aQTuf0y6iAAmrivyt1OFDA+CWp7+ek9F2SowqqvYFN56/UZy+qvAa6ePwx/SJkjtnRDtFq1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PxrCpOnX; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240709090005epoutp0357415caad2327ad341ca6db1a2bec6ee~gf9PaH0Mg0484404844epoutp03K
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 09:00:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240709090005epoutp0357415caad2327ad341ca6db1a2bec6ee~gf9PaH0Mg0484404844epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720515605;
	bh=/LrVJ+LpewOfLOi/U8Ctrj59xEIFiGAGsOhkk/FMUtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxrCpOnXI0v/GtQZRIBa8Cdo3lDD0F7vcu+nFMRnsm1WJwLKaoAqx+9SqdsmnQwL/
	 B6xNnErdjAwb612ed+daw2YcnNfBiBlFTJoQAGNeeHW2nQCMEKWWJK4DEfHqIfCyRJ
	 Cou39p5DxJhO5+t1mRVVna9S5n8A69Yj//VpoXbU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240709090005epcas5p4899067563465cfd53b17a1620785d03c~gf9PGmZQM1581615816epcas5p4U;
	Tue,  9 Jul 2024 09:00:05 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WJFLW6dd9z4x9Q3; Tue,  9 Jul
	2024 09:00:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.E8.07307.31CFC866; Tue,  9 Jul 2024 18:00:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240709085955epcas5p267fabe2536dc064f6595df1b46463a1e~gf9GMVKB71544815448epcas5p25;
	Tue,  9 Jul 2024 08:59:55 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240709085955epsmtrp2f633d1e191344ad10e8ac2c99c320b4a~gf9GLqm3s3087030870epsmtrp25;
	Tue,  9 Jul 2024 08:59:55 +0000 (GMT)
X-AuditID: b6c32a44-18dff70000011c8b-4f-668cfc13d1ea
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EE.B6.19057.B0CFC866; Tue,  9 Jul 2024 17:59:55 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240709085954epsmtip27d2ef8ed44a34dec2a25495778297e62~gf9FDKwu_0804008040epsmtip2R;
	Tue,  9 Jul 2024 08:59:54 +0000 (GMT)
From: Wenwen Chen <wenwen.chen@samsung.com>
To: xue01.he@samsung.com
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] io_uring: releasing CPU resources when polling
Date: Tue,  9 Jul 2024 16:59:41 +0800
Message-Id: <20240709085941.3195547-1-wenwen.chen@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240709081619.3177418-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZdlhTXVf4T0+aQf9+HYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hszg74QOrRdeFU2wO7B47Z91l97h8ttSjb8sqRo/Pm+QCWKKybTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADlBSKEvMKQUK
	BSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGf8ejef
	reABe8XV5weZGxgPs3YxcnJICJhI7Dn4lKmLkYtDSGA3o0TjuTOMEM4nRolbe5pZIZxvjBKf
	Ok7CtVybvp8dIrGXUWJh6242COcHo8TH+U9ZQKrYBLQl3q9tYQSxRQQkJNadXwUWZxZIldg+
	7x1YXFjATeLz1E1gNouAqkTf7z/MIDavgJ3E21WrmSG2yUvc7NoPZnMK2EjMa1/CCFEjKHFy
	5hOomfISzVtnM4McISFwi13i/OcPbBDNLhJP9yxlgrCFJV4d38IOYUtJfH63F6qmWGLiwS/s
	EM0NjBLHL35lgUhYS/y7sgfI5gDaoCmxfpc+RFhWYuqpdUwQi/kken8/gZrPK7FjHoytJLHk
	yApGCFtC4veERdCg85A4OwEUQKDQ6meUOPj3E/sERoVZSB6aheShWQirFzAyr2KUTC0ozk1P
	TTYtMMxLLYfHc3J+7iZGcLLUctnBeGP+P71DjEwcjIcYJTiYlUR459/oThPiTUmsrEotyo8v
	Ks1JLT7EaAoM8YnMUqLJ+cB0nVcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoR
	TB8TB6dUA9P6ZSUiSn3Hr07Mux3N6rp/y0uN0/d7AuatXhPuX568xzTLwITvmfj5xUVeXV/S
	3sssnZFqGuh9Y+7L5dLrD5Rn7/0fLmaWbTT59S5f8SWKlSrqBfJ37Cb2XRUr+Df3U+D6v/q5
	S1u3nTXyPuBYMF806fiSS6XVb7Y8OSvo8+Hxl5Vhf7ekGpeunFF794/Hk/q573Yods5ML/S8
	t7WfSXzD/4nfLmSbCDlZdCq4xGyUFopdIevvesQxQXhuo2qKyEmJf7H/Dzg6yH3J6G2QN1sq
	di7C9IVJ1sH1/RMlW/pP7SpIWfL0T+KttCnqOe/DLX+5RZUk+WdxzF7ez9J7OPywXa6oW9Ci
	7rqQhoL4xUosxRmJhlrMRcWJADBf5s0fBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSvC73n540g8PdchZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWi64Lp9gc2D12zrrL7nH5bKlH35ZVjB6fN8kFsERx2aSk
	5mSWpRbp2yVwZfx6N5+t4AF7xdXnB5kbGA+zdjFyckgImEhcm76fvYuRi0NIYDejRNukbWwQ
	CQmJHY/+QBUJS6z89xyq6BujxL9PHUwgCTYBbYn3a1sYQWwRoIZ151exgNjMApkSP58sZAex
	hQXcJD5P3QRWwyKgKtH3+w8ziM0rYCfxdtVqZogF8hI3u/aD2ZwCNhLz2peA1QsJWEss3byS
	CaJeUOLkzCdQ8+UlmrfOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6
	yfm5mxjBoayltYNxz6oPeocYmTgYDzFKcDArifDOv9GdJsSbklhZlVqUH19UmpNafIhRmoNF
	SZz32+veFCGB9MSS1OzU1ILUIpgsEwenVAOTYdhFpanKr8vsHPIO3D2W80yap8YtoLb02sn0
	x7yXTQI4W3svWDDKFV/eZJU57ZWkoWJTlfePtmnVqjtU3ftPN80xDZVY48oebcx2UviKhFnt
	VBf+Z1zbTgjePG7nseZfvf2PNL7bk+N2/V/Pbvzq/hvJhLbW3MM3ph8KmPrFsm1NlZqZYVH4
	gw3v25RjFxxVOthykVMlSIRlHR/z23MbDty+v8Ms6pGMy46ZthUM8odFd2ncP/tM7W/ZlKS4
	5NZT8+4keN2uUyi79snrUFnbF4a9+46vfDzjmvvXrav5IpwFzum8LUl9c7hXXW7aH3nfNWG/
	/z3eLcWy7u12j9Vni2O85/xRkFHP2Og33TNYiaU4I9FQi7moOBEAB3VF29QCAAA=
X-CMS-MailID: 20240709085955epcas5p267fabe2536dc064f6595df1b46463a1e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240709085955epcas5p267fabe2536dc064f6595df1b46463a1e
References: <20240709081619.3177418-1-xue01.he@samsung.com>
	<CGME20240709085955epcas5p267fabe2536dc064f6595df1b46463a1e@epcas5p2.samsung.com>

Sorry for bad format, here is the test results maybe looks better:

Performance
-------------------------------------------------------------------------------------
                  write          read           randwrite       randread
regular poll    BW=3939MiB/s    BW=6596MiB/s    IOPS=190K       IOPS=526K
IRQ             BW=3927MiB/s    BW=6567MiB/s    IOPS=181K       IOPS=216K
hybrid poll     BW=3933MiB/s    BW=6600MiB/s    IOPS=190K       IOPS=390K(suboptimal)
-------------------------------------------------------------------------------------
CPU Utilization
-------------------------------------------------------------------------------------
                write   read    randwrite       randread
regular poll    100%    100%    100%            100%
IRQ             38%     53%     100%            100%
hybrid poll     76%     32%     70%              85%
-------------------------------------------------------------------------------------

--
hexue

