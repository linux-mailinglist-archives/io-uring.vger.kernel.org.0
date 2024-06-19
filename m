Return-Path: <io-uring+bounces-2267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FF190E39F
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 08:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EDF31F24E74
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 06:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73F14C98;
	Wed, 19 Jun 2024 06:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IZIIJgLv"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5972D6F2E2
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 06:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718779233; cv=none; b=ecEvIGSXFg5vmMVwjy/rM4d8fX3g2G1CchFXBsLFWskXuEi+gtfqmBRRZHNKz/yUGRv5B22eZWI9Bp5fco5zI/CxzxfJpmT9wXEbD6JtHpoze8Wbc+xeekGKq1NmYk6vuI/wCpr9TGvGRKpzfsZ0o/w8N7hR5e67oU5zZY7yEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718779233; c=relaxed/simple;
	bh=SdS7mLn+EAhA0nywge3xC+e5CTmvNKRiUKxOLOAVaIs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=RRxu/JN0Ag14icl5a6tGDv+psHa3XKr5nX274MgjvgKV51sI4aE7c7oxN72nEfchXkrACQhkwYQGlNjKPi7m0FBAj8cSQD6vlkU4Fd0wbICtOu7k3NFLlAQfb4SdNs7q4MiV8hDyPSAaqaTedU+u6prRXQVmJhYMYehq10xZuyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IZIIJgLv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240619064027epoutp01873269d6f0e27b72b27b2cb0a0137a90~aVJnckKIs0966809668epoutp01C
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 06:40:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240619064027epoutp01873269d6f0e27b72b27b2cb0a0137a90~aVJnckKIs0966809668epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718779227;
	bh=NNndmY5cuMAnTd7h9BEL5xj7uRyEUW/R9qwgWy0wcMM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=IZIIJgLvzLykNyv4u80ZAExzOJB1OOzRucjKqWd9s00b4uguFUYT9f56XqIiK/JWP
	 5WtDG8ht+AhlZuCGkW8CPHlJdQUBBLxppTwZbmIXR2I7dJ9hJb/2PkX3TBH0Ecboln
	 pu80vxn4DT39b0xKkVCqLT7RSsvbXWtBs1IPPDb0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240619064027epcas5p25021f0e733cdacc196f42c8db24f18ff~aVJnKREQN2266322663epcas5p2E;
	Wed, 19 Jun 2024 06:40:27 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W3vBd5yD2z4x9QM; Wed, 19 Jun
	2024 06:40:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.75.08853.95D72766; Wed, 19 Jun 2024 15:40:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b~aVH13urOD3140131401epcas5p2u;
	Wed, 19 Jun 2024 06:38:25 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240619063825epsmtrp2c97e89d699350a86a8d1f8c371e9e0ed~aVH12vJGc0980309803epsmtrp2K;
	Wed, 19 Jun 2024 06:38:25 +0000 (GMT)
X-AuditID: b6c32a44-fc3fa70000002295-16-66727d59627e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	65.46.19057.1EC72766; Wed, 19 Jun 2024 15:38:25 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240619063824epsmtip1c093ccdc8f4e165f56667f8488bedf02~aVH02hpdq2965729657epsmtip1F;
	Wed, 19 Jun 2024 06:38:24 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH] io_uring/rsrc: fix incorrect assignment of iter->nr_segs in
 io_import_fixed
Date: Wed, 19 Jun 2024 14:38:19 +0800
Message-Id: <20240619063819.2445-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmlm5kbVGaweZHWhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsbn9yvZCl6zVVzvmsDcwHiUtYuRk0NCwETi/8eTLF2MXBxCArsZ
	JfpbuphBEkICnxgl/m12h0h8Y5T4crCDHaaj8chPqI69jBJLjhxlgnCamCSOT/7FCFLFJqAj
	8XvFLxYQW0RAW+L146lgNrPALkaJheekQGxhgTiJg+1vwOpZBFQljt2/D2bzClhLdLx9ALVN
	XmL/wbPMEHFBiZMzn0DNkZdo3jqbGWSxhMA9dontW9+zQDS4SCx7uRvqOWGJV8e3QA2Skvj8
	bi9bFyMHkF0ssWydHERvC6PE+3dzGCFqrCX+XdnDAlLDLKApsX6XPkRYVmLqqXVMEHv5JHp/
	P2GCiPNK7JgHY6tKXDi4DWqVtMTaCVuZIWwPicOTL7BBgjRW4sTD16wTGOVnIXlnFpJ3ZiFs
	XsDIvIpRMrWgODc9Ndm0wDAvtRwescn5uZsYwUlTy2UH4435//QOMTJxMB5ilOBgVhLhdZqW
	lybEm5JYWZValB9fVJqTWnyI0RQYxhOZpUST84FpO68k3tDE0sDEzMzMxNLYzFBJnPd169wU
	IYH0xJLU7NTUgtQimD4mDk6pBiZRXtdGFpXQR5+E7yRyxKl5HT2+4cXiC/cFqkMrXuixVMid
	9Tf+3tb0M8oszLHITsTw2oQ3a/1UNbiWWtbwdm580vLgmCIrk8BSXbP6PznLZExrlh6dyfmO
	ydrco3xqqKdQxT2FN59mbcox4n17UeaHymuPl5OfST668XLL49Rtt51n3T997NZV1R1yAVs4
	dolGBi96tunia92vT1VKdqX+2Pjoop+hYMfiq0vbmLfU2zUy8h44uXLbIrm66wrJffPehLNU
	6FsKnW2o33J+Kj9fRkf3/ePC/3jiL70I6Prx+z/HxSNPP07UiTZayDbr9dWdYlNM/59+5607
	336n8YrvHY8nX9nKc+93/EHbVUKmSizFGYmGWsxFxYkAb6719CMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSnO7DmqI0gzPL5S2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuf3K9kKXrNVXO+awNzAeJS1i5GTQ0LA
	RKLxyE8WEFtIYDejxJIzshBxaYmOQ63sELawxMp/z4FsLqCaBiaJqSva2UASbAI6Er9X/AJq
	5uAQEdCVaLyrAFLDLHCIUaJ5QzMjSI2wQIzEmW9rmUFsFgFViWP374PFeQWsJTrePoBaIC+x
	/+BZZoi4oMTJmU/ADmIGijdvnc08gZFvFpLULCSpBYxMqxglUwuKc9Nziw0LjPJSy/WKE3OL
	S/PS9ZLzczcxgsNXS2sH455VH/QOMTJxMAIdx8GsJMLrNC0vTYg3JbGyKrUoP76oNCe1+BCj
	NAeLkjjvt9e9KUIC6YklqdmpqQWpRTBZJg5OqQamqHR2vrMzEyInsWX21aSdXf5Q37njRnaB
	y46I6QKCMs+PnP1p2vWtLe7y82NvFkzpibhobyBzmJ25JvvxJGO3goviUpvvNi0oVLvEbmjc
	2HskWDdzca1HV2CX7ezG+VeOfKs2603dH1yyo25G4yxOE9lLSerri5MZApT28c7jv/KPSVpw
	TpDTr8K7W5u33bNW3ML9remuzLLpEyVPTLn14NTGx9942K16ndy8WGUXW2XNaRGZzzm3VaBB
	zyaApVNmQmfy5TmWfZMdBDvMdl7dFPlx5dz3NZNWmxk/WWy27NB5rYST10Wb+CbteXPJSlZb
	7CxL6YSzKS+mBORMOsp9yfzJ56eLfrverAxcHbhJiaU4I9FQi7moOBEA5Q/dmM4CAAA=
X-CMS-MailID: 20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b
References: <CGME20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b@epcas5p2.samsung.com>

In io_import_fixed when advancing the iter within the first bvec, the
iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
bvecs, plus we don't need to adjust it here, so just remove it.

Fixes: b000ae0ec2d7 ("io_uring/rsrc: optimise single entry advance")
Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 60c00144471a..a860516bf448 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1049,7 +1049,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			 * branch doesn't expect non PAGE_SIZE'd chunks.
 			 */
 			iter->bvec = bvec;
-			iter->nr_segs = bvec->bv_len;
 			iter->count -= offset;
 			iter->iov_offset = offset;
 		} else {

base-commit: 3b87184f7eff27fef7d7ee18b65f173152e1bb81
-- 
2.34.1


