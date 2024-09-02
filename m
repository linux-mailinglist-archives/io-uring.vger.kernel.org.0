Return-Path: <io-uring+bounces-3011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04ED3967F7E
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 08:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 265861C217D0
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 06:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35178156993;
	Mon,  2 Sep 2024 06:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YOqGjt2D"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E5027713
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 06:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725258649; cv=none; b=ltz80/DHHRqFWqX0xmWkAQar34tgVwnepqrNVdLRGJAip/WXx/QOn23VYNpSPH1jvr0W/Tlx0oBlmtoUt7V236Z94YQ5wGPJbP4myN56VOUgo3ezyXV3qeMfjdriiS0D7UbatG6bQs7U6AjmtRsskD3idiVRwb92mQFaca9ff1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725258649; c=relaxed/simple;
	bh=5eRs0gzpgMBcNvBdzqcLhEMND/55GSv5aQ6m2Plhcvs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Ob2wxm7zW4NhGzAOI1qCWJ9s2dFH7683bXYTyghj9jlYGe8euBP8dgKwuqa/zhehghxNPM6gei95j9PfTiLn6ljZXYcprkm6ozn4jMFb5YW7hHMxoVWWCZTCwbMGQ1WBb3Qk/eHBcydHINgFHIX1lvwkCKRs3Ba9/mPJgsA2USM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YOqGjt2D; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240902063043epoutp043e5a772960177f63b9be1992b1b4d260~xWZiMqgUy1921119211epoutp048
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 06:30:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240902063043epoutp043e5a772960177f63b9be1992b1b4d260~xWZiMqgUy1921119211epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725258644;
	bh=EiVlzJbrTymsG3STjNjdYn3y/Vuu0/OPNEt43pymV0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOqGjt2Dd/DHOoxsJJGd0IGCB8FSPvyD4D1AIQANc6LdZ+X14CqiCUUqT+35ejwq0
	 9rPyCqfY5XBIdovdg2j6ypnhSnh3HHZSetq0hzZTykJVjpRWbuZlU+hITvyzAtg4jw
	 IR3R+79/16cE1mrE79oTM4rr0bn9HM68thQ6JTwU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240902063043epcas5p2046af7e716967d21190450c02ca6422c~xWZh3LJ1e2809528095epcas5p2N;
	Mon,  2 Sep 2024 06:30:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WxzQn4yWTz4x9QT; Mon,  2 Sep
	2024 06:30:41 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.6A.09640.F8B55D66; Mon,  2 Sep 2024 15:30:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240902062909epcas5p29fbe563a154702da069dbeb348f8821b~xWYKR7T7i2718027180epcas5p2a;
	Mon,  2 Sep 2024 06:29:09 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240902062909epsmtrp2d27be94b074d8f2ff5d568eda512f6f0~xWYKRW-6F0631406314epsmtrp2r;
	Mon,  2 Sep 2024 06:29:09 +0000 (GMT)
X-AuditID: b6c32a49-aabb8700000025a8-51-66d55b8f5c48
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	1D.7F.19367.53B55D66; Mon,  2 Sep 2024 15:29:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240902062908epsmtip2db4e0923ba275f319133a0a2ac815cbd~xWYJeVNI52070320703epsmtip2r;
	Mon,  2 Sep 2024 06:29:08 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v1 1/2] io_uring: add new line after variable declaration
Date: Mon,  2 Sep 2024 11:51:33 +0530
Message-Id: <20240902062134.136387-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240902062134.136387-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmum5/9NU0g79fNS2aJvxltpizahuj
	xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgicq2yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
	Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzpgx+RJjwWqWisMP9rE0MJ5g7mLk
	5JAQMJF4d/MYexcjF4eQwG5GiT2bO9ggnE+MEivPbGOCc/4ufMgI03Js8UeoxE6gxO0FTCAJ
	IYHPjBJdc7NAbDYBdYkjz1vBGkQEtCVeP57KAmIzC9hLnFv9AaxeWMBT4vDjO2A1LAKqElNv
	rmIDsXkFrCSmXYGwJQTkJWZe+s4OYnMKWEv0/ljACFEjKHFy5hOomfISzVtnM4McJCFwiF3i
	y+uVLBDNLhKznr+CulpY4tXxLewQtpTE53d7oRakS/y4/JQJwi6QaD62D6reXqL1VD/QUA6g
	BZoS63fpQ4RlJaaeWscEsZdPovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPidNP70PDuo9R
	4m73BZYJjAqzkPwzC8k/sxBWL2BkXsUomVpQnJueWmxaYJiXWg6P5eT83E2M4FSo5bmD8e6D
	D3qHGJk4GA8xSnAwK4nwLt1zMU2INyWxsiq1KD++qDQntfgQoykwwCcyS4km5wOTcV5JvKGJ
	pYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUwSjualJ5mkTyZ6K3oujZ+b
	GazZrndn9tJFMYkmcZqbvv7Xin8/137u/Zml01jOife+Prtoo9ftxP9Ktouu9ExLqGnba3md
	Y4o3Fy+jn+TS29K5q/J32cb9SvL+8W1rpVWoSKqQru0brZyWHTcCg3RXSV/6O+UT/5a7C/+/
	NNkkuPztZyep0K4E68LovXfey2nmfHk2w/br1rnvdgfHBkyLEtTacvwtX6rYevvT8zren3/+
	+OVp6cMPJtm0fJn6dOdfy8alwtZaxa61LF+O+c5KqZz6U1jpLwfT3m+N6wuuPjXwzecws1+9
	9NCawwwc2wIT1bd4XWL5uGdp2LIVeqsv7l0285PMkY9dauHdu46bK7EUZyQaajEXFScCAN2Q
	8IkOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSvK5p9NU0g3tz5CyaJvxltpizahuj
	xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmDH5EmPB
	apaKww/2sTQwnmDuYuTkkBAwkTi2+CMTiC0ksJ1R4m2HAURcQuLUy2WMELawxMp/z9m7GLmA
	aj4ySty5cJcNJMEmoC5x5HkrUBEHh4iArkTjXQWQMLOAo8TUDdfYQWxhAU+Jw4/vgM1hEVCV
	mHpzFVgrr4CVxLQrELaEgLzEzEvfweo5Bawlen8sYIS4x0rixebPzBD1ghInZz5hgZgvL9G8
	dTbzBEaBWUhSs5CkFjAyrWIUTS0ozk3PTS4w1CtOzC0uzUvXS87P3cQIDlCtoB2My9b/1TvE
	yMTBeIhRgoNZSYR36Z6LaUK8KYmVValF+fFFpTmpxYcYpTlYlMR5lXM6U4QE0hNLUrNTUwtS
	i2CyTBycUg1Mli32n4pmCLHNLau4u8xVpOboj+NOXT1N+zaad/Nwsn+ebTsjv1bm+j6fjlpj
	/oUfH7lMO7PtxhvDC2Y77O/crLERXFy/a/Llr7N293qdaJvlIBZ/jaU204VDVM1g9vwnD9T/
	bTxmO7NbTeL16neb+36rbmnq+DmN/WlZ5YsLFWfjtHsOn1hQJ832Zvs1nqu/ex0jbzFdPc3+
	+dP0q4wXOZs4Wg57xr1uXTp38ufYlTtuM5cr39ljwNH8aNEkbd9/zNKM23/b3mj1KBCYxzex
	Y93WL1VPrWc93WrH7dC37KW5k0LopNqoqb7tcQLbD/3bVCPi+cOiza2VPcRlmvKtrdlb77uF
	TUtVXBm0XrqXSYmlOCPRUIu5qDgRAED7ep+/AgAA
X-CMS-MailID: 20240902062909epcas5p29fbe563a154702da069dbeb348f8821b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902062909epcas5p29fbe563a154702da069dbeb348f8821b
References: <20240902062134.136387-1-anuj20.g@samsung.com>
	<CGME20240902062909epcas5p29fbe563a154702da069dbeb348f8821b@epcas5p2.samsung.com>

Fixes checkpatch warning

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/eventfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index b9384503a2b7..d9836d43725f 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -126,6 +126,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
 	if (IS_ERR(ev_fd->cq_ev_fd)) {
 		int ret = PTR_ERR(ev_fd->cq_ev_fd);
+
 		kfree(ev_fd);
 		return ret;
 	}
-- 
2.25.1


