Return-Path: <io-uring+bounces-3299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AC2985654
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 11:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8011C284697
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 09:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F6715B971;
	Wed, 25 Sep 2024 09:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QUOo9tGZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7800E15C15D
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 09:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727256533; cv=none; b=CehB+9+bGIxBmdZi9/7BX+hWKXvIfQsPHayanoUCxQ4kgQlAOh5lMHzGD8lw6X2YSiOuk1kOIDih8i2XtvowUWI2N0vjfS6blp61W+U1gzDn5zjQsS1ZEoOtYPtGYmgQ+oD8X9OFq1jXX/gAqSkskew9+0bQA5YuWxU9Vc2dVyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727256533; c=relaxed/simple;
	bh=2A/5/Zh9h+rW85FdnEo9f/zG7q4C7ky0ju//Of9ir48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Prqx5BSJRQSe8n6oafZ1GM4YRMFcokWrZQo/BProMYvjupjKNGygFVQSrenoxGsz1UTuSvuMP5GQ2Zzx6ffyNc7lPXqIOtb/YXdv0YeQJxcCs2hSWjFo1RT8/Z07Jje3d+Cj8uSJhONkr7zmD60s2S4/FqsSiMPaTq8zzdzEEEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QUOo9tGZ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240925092844epoutp0448b5dbcfd2f1d3b45edab6c53caf5813~4cqhFOI7L1046410464epoutp04j
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 09:28:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240925092844epoutp0448b5dbcfd2f1d3b45edab6c53caf5813~4cqhFOI7L1046410464epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727256524;
	bh=2A/5/Zh9h+rW85FdnEo9f/zG7q4C7ky0ju//Of9ir48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUOo9tGZFMID2dBYuXy7ulXnyC6dtyG3g7yMp+Ao8TTtzFnlZ7gyXq84RxFSBGKDK
	 pV2t2P/De2thJ5dNdvcXpo0vVK7erNmoAdRdZ2qXIBaXLlus3BNFoq/QA5jOZqAsr1
	 9qltRGFnGIt9ne5fCy4QvkxQg6S1fCaMhvH+zfjI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240925092843epcas5p4a14de11937d8b45349d6ceafda3c849e~4cqgqAn802289322893epcas5p48;
	Wed, 25 Sep 2024 09:28:43 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XDBHY6t2nz4x9Px; Wed, 25 Sep
	2024 09:28:41 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.BA.19863.9C7D3F66; Wed, 25 Sep 2024 18:28:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240925082937epcas5p1baa4bb786ea874400d7b18553cd57625~4b25wN5tc1294712947epcas5p1s;
	Wed, 25 Sep 2024 08:29:37 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240925082937epsmtrp1b22f20c9bb6f3b295bfcb5b3e83294e5~4b25vgwqz0616606166epsmtrp1_;
	Wed, 25 Sep 2024 08:29:37 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-06-66f3d7c9a325
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	6F.4B.19367.1F9C3F66; Wed, 25 Sep 2024 17:29:37 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240925082936epsmtip2df8a3d4af1b9f8c3c756a334e070e465~4b25Ai2DR2384823848epsmtip2s;
	Wed, 25 Sep 2024 08:29:36 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: asml.silence@gmail.com, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8] io_uring: releasing CPU resources when polling
Date: Wed, 25 Sep 2024 16:29:32 +0800
Message-Id: <20240925082932.3329096-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240918021010.12894-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTS/fk9c9pBpffmlrMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YHdg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnXLkwia3gHFPF
	vh9rWRsYe5i6GDk5JARMJC4tvcLYxcjFISSwh1Fiyc2TrBDOJ0aJ6Yv/sIFUgTkbj0bCdEx9
	1sMGUbSTUWLr/03sEM4PRolDPWvAOtgElCT2b/nACGKLCGhLrL2/nQXEZhawkjg75yeYLSzg
	JvH1wSGwO1gEVCXWnP4AtJqDg1fAWuJwezXEMnmJm137mUFsTqDWJQ+PgrXyCghKnJz5BGqk
	vETz1tnMEPXX2CW6pilA2C4Sl1csgHpTWOLV8S3sELaUxMv+Nig7X2Ly9/WMEHaNxLrN71gg
	bGuJf1f2sICcwyygKbF+lz5EWFZi6ql1TBBr+SR6fz+BGs8rsWMejK0kseTICqiREhK/JywC
	+0pCwEPi1do4SEj1MkpM+/WVfQKjwiwk38xC8s0shM0LGJlXMUqlFhTnpqcmmxYY6uallsPj
	ODk/dxMjODVqBexgXL3hr94hRiYOxkOMEhzMSiK8k25+TBPiTUmsrEotyo8vKs1JLT7EaAoM
	7onMUqLJ+cDknFcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA1Oe
	x5NXpzZccX9T+7xhZf39/wo8h1gnTApcyzWn4/bkuLN6RQujHmr4VeXzFqq/ZotlDmnYHMVe
	83XxYbXUD6dL+TYH3OGVS5T49oCtt03LSenJzuvbY64XC70Xmf54/pybwgEucxebdWZYZWk+
	kHTbpXhM/mhrPKOBnPPVq4a270Mi9txwObF4S1X6ox9zFKwCWPju/7zUkvMz90hIfMUFux73
	7JXODhJeX2LVn10tFfvuZzWh4LxW85YS026xB8qp2vMl47p+MPiGzkybaVsyN7WtxlXOTiwx
	XKSPpUPwrOEq9w7mvf0azT/eR7TMu8gnmir9+IqfjdjSDPaLsW8NFFOeHM2MZlzPP/WJEktx
	RqKhFnNRcSIAQdtughYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvO7Hk5/TDL4/57SYs2obo8Xqu/1s
	Fu9az7FY/Oq+y2hxedccNouzEz6wOrB57Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4cmESW8E5pop9P9ayNjD2MHUxcnJICJhITH3Ww9bFyMUhJLCdUeL1jUdQCQmJHY/+
	sELYwhIr/z1nhyj6xijx58gRFpAEm4CSxP4tHxhBbBEBXYm1mxrBbGYBG4mdLVvYQWxhATeJ
	rw8OgQ1lEVCVWHP6A9BQDg5eAWuJw+3VEPPlJW527WcGsTkFrCSWPDzKAlIiJGApseGgG0iY
	V0BQ4uTMJywQ0+UlmrfOZp7AKDALSWoWktQCRqZVjKKpBcW56bnJBYZ6xYm5xaV56XrJ+bmb
	GMFBqxW0g3HZ+r96hxiZOBgPMUpwMCuJ8E66+TFNiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9y
	TmeKkEB6YklqdmpqQWoRTJaJg1OqgWnBrtu7j5yZvOXaacHeVGVnU+6Pc30Zt6Wol935/u7m
	SoctXSY/NvSZpYXPYS+M6O3cbfQ8tkFpofChENdrbbfLi9rnl+fWmPFeKsmPyTMzNArpkL1w
	/GlXknH5NbZEpe8vsncecyk38T0dofpXd6GOz7XDqY7TTyxZIhWspbf6wZ7CJemMdao/lt+c
	y8cvsdj+tjV7Mc9Su2+zD8yVfSu8LeGHcgczn6XGZG93D4ELXox3NzHN/PszYqHyz/mPRZlm
	d33T2sNqFOPJ8D2ie1/kvcwdW2dn3tVumxjU+zIja+13t9smrH8/XFKT5F7ru/GIypSFXrH3
	6111Ij5dfeH35ln9P7Hjr7RL+j26nimxFGckGmoxFxUnAgB5s8hlyQIAAA==
X-CMS-MailID: 20240925082937epcas5p1baa4bb786ea874400d7b18553cd57625
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240925082937epcas5p1baa4bb786ea874400d7b18553cd57625
References: <20240918021010.12894-1-xue01.he@samsung.com>
	<CGME20240925082937epcas5p1baa4bb786ea874400d7b18553cd57625@epcas5p1.samsung.com>

On 24/08/12 1:59AM, hexue wrote:
>This patch add a new hybrid poll at io_uring level, it also set a signal
>"IORING_SETUP_HY_POLL" to application, aim to provide a interface for users
>to enable use new hybrid polling flexibly.

Hi, just a gentle ping, is there still in merge window? or any comment for
this patch?
--
hexue

