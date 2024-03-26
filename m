Return-Path: <io-uring+bounces-1215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F064088B862
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 04:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 676D11F3A95D
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 03:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD121292E1;
	Tue, 26 Mar 2024 03:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bW0lpK74"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EB0128816
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 03:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423444; cv=none; b=BZ4TkXvV7xEPLJMdTufsgScP6nSja+ClySf4ziqdJAkh7NHDiPkEjWP3bxvGGIuFOnmNDsbxTUbBVe0OEderlfjPjqkW+YzD4fxa91OP9VXHxzByEU6q52ny28wJOPk6r7Y4ATxMfTHVUeYqZvaM65FWm5No9XhFdB2wGu/YsG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423444; c=relaxed/simple;
	bh=t2hCITEJ6wxpOWXwYTCuSE28aMfvwSP99iXFbW9bDq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qypwAiR1sVkJPlw1bHNDbdZP0tDtnWisqiHue2DpbF3VRtEeVJ5KbFSfU2jF3UGuk4u40jOlHpvqM3uMPoS5T4jbG1KcylmzT7O/sDeMpL1yKyQGa6IBILOqUgT0P6znWbvccIOg5OAzeaIXHAIE3LNg6TLKM6UjyLAsJuCLLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bW0lpK74; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240326032353epoutp042e59d5d33e875a3796272b97653f6ee2~AMoukpdiH1030510305epoutp04S
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 03:23:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240326032353epoutp042e59d5d33e875a3796272b97653f6ee2~AMoukpdiH1030510305epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711423433;
	bh=t2hCITEJ6wxpOWXwYTCuSE28aMfvwSP99iXFbW9bDq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bW0lpK74HfPlw3VSoaSVEz9l2VPBfBZM0gUUgjbZ4CRE3NaGgueiX79igkAa49f9t
	 f1IA4KMW+JKZFfUseWvwFIWVDceH21m3nRcsGlKE4p8vUMrP+dviO6Zismatb5Nlvv
	 B59Uf8J6xCvK8Yo15ZLAhpzvHkiAoheDwDdwkSaE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240326032352epcas5p2b86b7aea4214f4ebe795b515f00ac272~AMotq4yUf0799607996epcas5p2P;
	Tue, 26 Mar 2024 03:23:52 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4V3Zs343nWz4x9Q3; Tue, 26 Mar
	2024 03:23:51 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.01.09666.7CF32066; Tue, 26 Mar 2024 12:23:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240326032337epcas5p4d4725729834e3fdb006293d1aab4053d~AMofbxyNC0935509355epcas5p4U;
	Tue, 26 Mar 2024 03:23:37 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240326032337epsmtrp2e886086276c45637755e04674d36af91~AMofa9xQz1617016170epsmtrp2J;
	Tue, 26 Mar 2024 03:23:37 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-6c-66023fc7ce78
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	04.30.07541.9BF32066; Tue, 26 Mar 2024 12:23:37 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240326032335epsmtip2a5844b54d3515f434b559cdd286485c0~AMod6dI-R3072530725epsmtip2c;
	Tue, 26 Mar 2024 03:23:35 +0000 (GMT)
From: Xue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com
Subject: Re:io_uring: releasing CPU resources when polling
Date: Tue, 26 Mar 2024 11:23:31 +0800
Message-Id: <20240326032331.1003213-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240318090017.3959252-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmhu5xe6Y0g6YlkhZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGa06Lpwis2B32PnrLvsHpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QnUoKZYk5pUChgMTiYiV9O5ui/NKS
	VIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IznR34wFdxkqvhwnLuBsZ+p
	i5GTQ0LAROLT3gYgm4tDSGA3o8SD+UdYIZxPjBIfP55nhnC+MUosm9gL5HCAtTRuUYGI72WU
	uHrsCFT7L0aJC5P/M4PMZRNQkDh/+DPYDhEBYYn9Ha0sIEXMAuuZJJqO3mMDSQgLWEl0TfvH
	CmKzCKhKTJ25kR3E5hWwlrgx6yg7xIHyEvsPngUbyilgI7Hw12xWiBpBiZMzn7CA2MxANc1b
	Z4OdKiEwk0Pi6909UN+5SJyYOgtqkLDEq+NboGwpic/v9rJB2PkSk7+vZ4SwayTWbX7HAmFb
	S/y7socF5GVmAU2J9bv0IcKyElNPrWOC2Msn0fv7CdQqXokd82BsJYklR1ZAjZSQ+D1hESuE
	7SHxre0ZOyS0+hkl9s5YxzKBUWEWkn9mIflnFsLqBYzMqxglUwuKc9NTi00LDPNSy+GxnJyf
	u4kRnHa1PHcw3n3wQe8QIxMH4yFGCQ5mJRHeli8MaUK8KYmVValF+fFFpTmpxYcYTYEBPpFZ
	SjQ5H5j480riDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYIpbt2TB
	zePzKi/fYDwlecNs2ycXC58FTl/uaJxPZzzplrQyV0x7dUPc7u9NU7eU59rvtQjNcRNTzH3t
	z7j23nL3E1qZ336o2DEyHTowUYVnd/SWijnbWATSFh0W1m2SX7G35pzyw4b1HS7x6xbVzdUS
	D/tySDh45mMfQf+pImrS/5aXxlg0llqldaV+uXvi1F32kqLnXx/f4kiLZPV4cKKs5cf/11YR
	/H94DsT1JtvKqN2UP7Ja5sDeR70Tol+df7uqQX1xSeVCuZJzRjv+B//mXszEpSv1LFNNwdk6
	VvD5W741stF/ffbp//vpu1dtFU/e7m+T5v45v7B/znEN1blbTTbMLz/kd2PnF+HJFSuUWIoz
	Eg21mIuKEwGNXh8zRAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSvO5Oe6Y0g2uPxSyaJvxltpizahuj
	xeq7/WwWp/8+ZrF413qOxeLo/7dsFr+67zJabP3yldXi8q45bBbP9nJafDn8nd3i7IQPrBZT
	t+xgsuhoucxo0XXhFJsDv8fOWXfZPS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujOdH
	fjAV3GSq+HCcu4Gxn6mLkYNDQsBEonGLShcjF4eQwG5GiTVf2oHinEBxCYkdj/6wQtjCEiv/
	PWeHKPrBKNH6ZCkjSIJNQEHi/OHPYA0iQEX7O1pZQIqYBfYySdze+oYZJCEsYCXRNe0f2CQW
	AVWJqTM3soPYvALWEjdmHWWH2CAvsf/gWbB6TgEbiYW/ZoPVCwHVNEz7wQhRLyhxcuYTFhCb
	Gai+eets5gmMArOQpGYhSS1gZFrFKJlaUJybnptsWGCYl1quV5yYW1yal66XnJ+7iREcF1oa
	Oxjvzf+nd4iRiYPxEKMEB7OSCG/LF4Y0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4ryGM2anCAmk
	J5akZqemFqQWwWSZODilGpjKNAst1R057977u8hM9WRc3s28BXmr09f9/6vjcGfJlzkzNjnb
	G70oy1t1c7rin4JV1icueZx3WZqUsjM58eveunfLyqr8mUr+MO36rJeqrlRUdk90cpz91jev
	t3zUWstmfWs5k12LqugkgTNbNjAttGbd0yUrLlthWfO/2tyzTVqyXmmOXkRK5QmHFPEDl7qV
	eV5elUkLtToZbFIkt2ZGedynwpWTugIqGiy+PPM5yVd+pTT0wW7xwy9MV//3mKkm3HshwuN9
	T+LBuPIZ/7+zGefxb6qb2Cq9+c2sLWtn/Jv6PGd/p+mlw2Vzre484Di89r2N+237O1HTl/oZ
	s85uiV/woKg2SqPhpNqtugQlluKMREMt5qLiRACU8MSq+gIAAA==
X-CMS-MailID: 20240326032337epcas5p4d4725729834e3fdb006293d1aab4053d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240326032337epcas5p4d4725729834e3fdb006293d1aab4053d
References: <20240318090017.3959252-1-xue01.he@samsung.com>
	<CGME20240326032337epcas5p4d4725729834e3fdb006293d1aab4053d@epcas5p4.samsung.com>

Hi,

I hope this message finds you well.

I'm waiting to follow up on the patch I submitted on 3.18,
titled "io_uring: releasing CPU resources when polling".

I haven't received feedback yet and wondering if you had
a chance to look at it. Any guidance or suggestions you could
provide would be greatly appreciated.

Thanks,
Xue He

