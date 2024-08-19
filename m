Return-Path: <io-uring+bounces-2830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D640956149
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 04:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F4B71F2190D
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 02:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CF1947A;
	Mon, 19 Aug 2024 02:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZFZRMi/h"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838494594D
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 02:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724036386; cv=none; b=dDeKleXoyvoHwrMhNhxpKHbC/swzBdbDqMisCoi+jRT8DEuyfXn9R1Kyc7fH00rrWe2D35S9Sw7YKrX8eUB9Hppc6/9Bl0EU1l2EsQmObXeWEoiVEUSs7jL5VIDUGbQGqs/+cJsxbvc8zYBRj9hFYRqPXMz/NfUQ/M6FwI686C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724036386; c=relaxed/simple;
	bh=DTYsoVBv4qcuw+irvmC89n4g9DfsW1cJjYEWLSea77Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=FEbLLLPRWj291UOdR+m6oelKFlfWLUQtUUUJ2XpsKdfx4ikUjgEP3plc2L2Oo89JR8fDlx9Arr4yII5rVksatsVq5Z6M4SB69PWqVMwaNw/lFr47cyQ2cYL8skxC5j1reSrlpZ/rxY7nrmqCxbhGi926lnUBk3Ae2dpWUdwTpU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZFZRMi/h; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240819025935epoutp02f35f16a57e5afb70904496d51e149d7c~tAfMFuRbg0065600656epoutp02b
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 02:59:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240819025935epoutp02f35f16a57e5afb70904496d51e149d7c~tAfMFuRbg0065600656epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724036375;
	bh=DTYsoVBv4qcuw+irvmC89n4g9DfsW1cJjYEWLSea77Y=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ZFZRMi/hk2GS70VWBNHcvZzc8LVmc9elL6WV491gXq6eym67/YJKfHzjX2fdvsnn8
	 3zi4MLcjDasuGaYDv083Qpkg108m7AI/mfVh7z6raL6L9/yqjVti/Pzd+ybMkLpSDf
	 eqjgIKNwMfJPusdmJCQ5hucg2pq3JoQA2EBkv4BI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240819025935epcas5p197d3be67b43c2a5637004d56afadafe1~tAfL3uApc1978019780epcas5p15;
	Mon, 19 Aug 2024 02:59:35 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WnHPd3phNz4x9Pt; Mon, 19 Aug
	2024 02:59:33 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.4A.09640.515B2C66; Mon, 19 Aug 2024 11:59:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240819025446epcas5p43dde8e55435917ecd0175400b0b7cc62~tAa-QHmiT1123311233epcas5p4L;
	Mon, 19 Aug 2024 02:54:46 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240819025446epsmtrp1bbf561fc03d74d073db162a379403ff7~tAa-PgZa12777327773epsmtrp11;
	Mon, 19 Aug 2024 02:54:46 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-75-66c2b515b09d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	AA.A2.19367.6F3B2C66; Mon, 19 Aug 2024 11:54:46 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240819025446epsmtip24ac20cb2222310753db0ddf64ddefafd~tAa_a1tic0786307863epsmtip2h;
	Mon, 19 Aug 2024 02:54:45 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8] io_uring: releasing CPU resources when polling
Date: Mon, 19 Aug 2024 10:54:32 +0800
Message-Id: <20240819025432.2939198-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmpq7o1kNpBk8nSlnMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YHdg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnnGi+wlYwgani
	7T+nBsbbjF2MnBwSAiYSy94cZupi5OIQEtjNKLH02Td2COcTo8TfL3sY4Zyf8w+wwbS0TnnA
	BGILCexklNjbwwlR9INRYvP96+wgCTYBJYn9Wz6A7RAR0JZ4/XgqC4jNLGAlcXbOTzBbWMBN
	4uuDQ0CDODhYBFQlrm73BwnzClhLLHj7FGqXvMTNrv3MEHFBiZMzn0CNkZdo3jqbGWSvhMAu
	dombhw6yg8yREHCRmPMvEKJXWOLV8S3sELaUxMv+Nig7X2Ly9/VQ79dIrNv8jgXCtpb4d2UP
	C8gYZgFNifW79CHCshJTT61jgljLJ9H7+wkTRJxXYsc8GFtJYsmRFVAjJSR+T1jECmF7SOx5
	cYgVElSxEm3fzjBNYJSfheSbWUi+mYWweQEj8ypGydSC4tz01GLTAsO81HJ4rCbn525iBKc/
	Lc8djHcffNA7xMjEwXiIUYKDWUmEt/vlwTQh3pTEyqrUovz4otKc1OJDjKbAEJ7ILCWanA9M
	wHkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTD5TfVj3OG2MT5/
	mo7MDFN3yVWlNlot695+kLwteu1PIJtr49r1ibPStXXvLLX5YSVbeTfM+OR8IaMjhhx/PcI8
	vDK1jG92Bd2rdy65UP3HT1B4FofelRP/vxVGPS78Wax2f0sfc9lTY+OQNRdFLCrW97gcZbi8
	lUlc+MGJ7/o7r98pUJgm6quZX+/j9GjSyoKvt1/FblWuW/fuC7eiMGMtz7Rjx5ZvXFbyO/bq
	hY7HKYpnjCR7E1rvJ6zLvdLFO+Hctvw9rwMc7OceVtZpcbxUbrqHJe3yIxZvI/E56lt9QhQO
	MUVK7G9k/vDz8tEvV5b1bgpePHcG05LprLfe1+/gnBYjwrNZ+hv3vO01068rsRRnJBpqMRcV
	JwIAv2153QgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSvO63zYfSDC6dNreYs2obo8Xqu/1s
	Fu9az7FY/Oq+y2hxedccNouzEz6wOrB57Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo40XyFrWACU8Xbf04NjLcZuxg5OSQETCRapzxg6mLk4hAS2M4ose7qYWaIhITEjkd/
	WCFsYYmV/56zQxR9Y5ToaNgDVsQmoCSxf8sHoEkcHCICuhKNdxVAwswCNhI7W7awg9jCAm4S
	Xx8cYgIpYRFQlbi63R8kzCtgLbHg7VM2iPHyEje79jNDxAUlTs58wgIxRl6ieets5gmMfLOQ
	pGYhSS1gZFrFKJpaUJybnptcYKhXnJhbXJqXrpecn7uJERyCWkE7GJet/6t3iJGJg/EQowQH
	s5IIb/fLg2lCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZVzOlOEBNITS1KzU1MLUotgskwcnFIN
	TOqp534L1bvP6G2242FLcfp6v+ZjqHfAGXORyHxT9aq1jCePNj1p+6ZwUOLt5qgfayeJ7hDN
	e/WOaeIyu6VPrRa+PL990q13NeemBaqdN5iroPd8N9PLFzsZv5vJbdo5U2dpQnqlp55w6c/N
	nzLXxx19wlP5WePSlKx5q0OqXbSELft2zfp9JNz4mrkyb55CX5bllgqpkEt19UfSNBOj/rtp
	TOJ3lNX817Xx8Bm1DMN76SvjDn67fO/rWaGdU/1Npr79zX9eYK3G6Y8ThU3zH9qI+jXNPyRr
	XrLjt8ES/zPrDJdcEPluIF3kfVKs78HvfbVGFs7M59+JGwXkJFb/iuYrSZkf0zrD9fbhEwLX
	LyqxFGckGmoxFxUnAgA2PCarsAIAAA==
X-CMS-MailID: 20240819025446epcas5p43dde8e55435917ecd0175400b0b7cc62
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240819025446epcas5p43dde8e55435917ecd0175400b0b7cc62
References: <CGME20240819025446epcas5p43dde8e55435917ecd0175400b0b7cc62@epcas5p4.samsung.com>

On 24/08/12 1:59AM, hexue wrote:
>This patch add a new hybrid poll at io_uring level, it also set a signal
>"IORING_SETUP_HY_POLL" to application, aim to provide a interface for users
>to enable use new hybrid polling flexibly.

Hi, just a gentle ping...
--
hexue

