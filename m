Return-Path: <io-uring+bounces-5398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 723899EAA19
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 08:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BE971666EF
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 07:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081C922D4EB;
	Tue, 10 Dec 2024 07:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aZh/96Uu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AA222CBED
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733817492; cv=none; b=YVY8Eqy7IqPYjFLPq5LkgkVbZM8Vo7PFjJjPcW8wj74gS2WWPsyO3t6pd1KqemOGzxBQlt14gzslh5g5fTufIxVz87hDLE630C+Vc0pELtSIhUfno9geCMIMajUtNXZfoxuEkmJ90zF3W5M25W5ro5G8Qsh7HCbLVUPP8nzvzDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733817492; c=relaxed/simple;
	bh=QxBz4I5Bd8yWJ2kULw7TmX5U/VJ7rww++l23i4gpHzo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fq9SiI5mMYLdWssTt4w/Yp02nz0n+WFJ6c10yiwfMxPPtKSkbAg1VXdOaPWCwJiMjhYHgzhm7V/zh1tcP4uoUSPdLxtO5nSauDZ7NciaTSrw5iM3AexX7O3DyO4y9WS4DpgYjGHmZehE5TAK7CHplfKEL6E1p8584McyTLu29i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aZh/96Uu; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241210075808epoutp01b3ba5179ba7d6c56fd0ac40d7da96d0c~PwdHgrtAH0623106231epoutp01q
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 07:58:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241210075808epoutp01b3ba5179ba7d6c56fd0ac40d7da96d0c~PwdHgrtAH0623106231epoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733817488;
	bh=QxBz4I5Bd8yWJ2kULw7TmX5U/VJ7rww++l23i4gpHzo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aZh/96Uuht6nSe0ISywMQATQj5JwCVljoUsVK/+IDcpxayPuqCP0RQeET3FBrXiaj
	 idzrqMY0Hey95LCtf1ukS5uch8Bv2pDn8NYBK40eXqnA2kNv3H0US5p0zbVlMBhZrf
	 6L+5RT231zp7EGPHsAaNQupWhd5jsLQEnI030+fE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241210075808epcas5p44d08286581c4f706349efc99603f17bf~PwdHAPseg1109211092epcas5p4D;
	Tue, 10 Dec 2024 07:58:08 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Y6rgy2H8Xz4x9Q3; Tue, 10 Dec
	2024 07:58:06 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	64.AA.19956.E84F7576; Tue, 10 Dec 2024 16:58:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241210073523epcas5p149482220b87ff3926fb8864ff1660e0c~PwJPv5MQY1662116621epcas5p1C;
	Tue, 10 Dec 2024 07:35:23 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241210073523epsmtrp2d39c52502af4e68a701f215ac25204ff~PwJPqPHvd2642626426epsmtrp2m;
	Tue, 10 Dec 2024 07:35:23 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-1f-6757f48e11bc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	A2.C8.33707.A3FE7576; Tue, 10 Dec 2024 16:35:22 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241210073521epsmtip1d748fa8397b43956ed6c747819394c4f~PwJNzhOrs0603006030epsmtip1X;
	Tue, 10 Dec 2024 07:35:20 +0000 (GMT)
Date: Tue, 10 Dec 2024 12:57:27 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 12/12] nvme: use fdp streams if write stream is
 provided
Message-ID: <20241210072727.ehcfor5lifk4klrf@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241206221801.790690-13-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmhm7fl/B0g62/eCyaJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO0OHN1IYvF3lvaFnv2nmSxmL/sKbvFutfvWRx4
	PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j3MXKzz6tqxi9Pi8SS6AMyrbJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsax/nOsBVdZ
	Ks5ff83awDiRpYuRk0NCwETiws2fTF2MXBxCArsZJRZd3McM4XxilNh/t48FzmnY0cEI0/Lm
	Vg8jRGIno8TZh5vZIJwnjBL9F7cDDePgYBFQlTg+PQLEZBPQljj9nwOkV0RAUeI8MCRAypkF
	JjJJ/D7UxA6SEBYIlNjT+5ENxOYFWjCt8SkzhC0ocXLmE7BbOQXMJXZt+8sO0iwhsJRDYvmN
	o8wQF7lIHJvSwARhC0u8Or6FHcKWkvj8bi8bhF0usXLKCjaI5hZGiVnXZ0G9Yy/ReqofbBCz
	QIbEyq0PoYbKSkw9tY4JIs4n0fv7CdQCXokd82BsZYk16xdALZCUuPa9Ecr2kNi2tJsVEirb
	GCX2/PrGOIFRbhaSj2Yh2QdhW0l0fmhinQUMMWYBaYnl/zggTE2J9bv0FzCyrmKUTC0ozk1P
	LTYtMM5LLYdHc3J+7iZGcCLW8t7B+OjBB71DjEwcjIcYJTiYlUR4ObxD04V4UxIrq1KL8uOL
	SnNSiw8xmgIjaCKzlGhyPjAX5JXEG5pYGpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE
	08fEwSnVwOR0/KbN6Z8pm2Wtr8w6Nn1rxV8h/z/CWfI7thxj3/IumOkB766Vei/8bocf8nmX
	++jw0jdPOvfPMJ6wWOrvY+0rG+NnOd66NN/s6v3Pe6eKcc48d+NLZ6pAmaDgSg9xjhTmyZP8
	HURk975aa/jnb9Sd6AKZU+37BbRzzl5l/2HmeHOCkoCcig9bPv92gRtipwOvssQaFsiddPRl
	DmDIW/mggLE6s1x+/vQfLCH/dN6o2/yXUZlYfFBjxfrb+WUlvzN3njQVS159Qz7EUGiN+zH3
	VyuaxV8FOV148Enu7NsPzLb+pXeMb9opXOKaaB2VuC6h8OiTIK5y5uOlogE5z1luBq6cJp62
	2K8mbcO+d3JKLMUZiYZazEXFiQD/ivsNTQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWy7bCSnK7V+/B0g8sLLS2aJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO0OHN1IYvF3lvaFnv2nmSxmL/sKbvFutfvWRx4
	PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j3MXKzz6tqxi9Pi8SS6AM4rLJiU1J7Ms
	tUjfLoEr49rX86wF7UwVN3ZtZW5gvMvYxcjJISFgIvHmVg+QzcUhJLCdUWLO/wVMEAlJiWV/
	jzBD2MISK/89Z4coesQo0b9rAlARBweLgKrE8ekRICabgLbE6f8cIOUiAooS54GuASlnFpjM
	JPF85jEWkISwQKDEnt6PbCA2L9DiaY1PmUF6hQSSJF5+N4cIC0qcnPkErJxZwExi3uaHYCXM
	AtISy/+BjecUMJfYte0v+wRGgVlIOmYh6ZiF0LGAkXkVo2hqQXFuem5ygaFecWJucWleul5y
	fu4mRnDEaAXtYFy2/q/eIUYmDsZDjBIczEoivBzeoelCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eZVzOlOEBNITS1KzU1MLUotgskwcnFINTKFifiwXBI+JfdRhlM7/aLpgkekctRvuykfPXz1x
	5A/LuwUsp1amGN2TWHY0u/hszizOWbZzFWR+tjzZVn3nGMOM8K7FwZM+s72r2bngnbSXsP3x
	iHN/2ZNiMpgWP5DdrapsninGm9k+f7d5QcnKOTnWc8SDp3QWTMoRXmnvlHHO8Ea7yfHf6Tq6
	fqe3FB+dKnZe9nFty9orKv4dNw1lngoa/9ONCJ/Ye6i8Lu5I2JG0ntXRJ2f9Wnx63ZOnKUtn
	tRwPZfZI4Jqy4ePe/LiXjorbN2yU374jzeCDwHl7ve+NB2NfxnpI71uv8q1t5Zzmc6fv7ZP7
	dIXfsbwj7dvr/QemtfhdC5gt78W2O66+47QSS3FGoqEWc1FxIgBVHUL6BwMAAA==
X-CMS-MailID: 20241210073523epcas5p149482220b87ff3926fb8864ff1660e0c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_710e1_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241210073523epcas5p149482220b87ff3926fb8864ff1660e0c
References: <20241206221801.790690-1-kbusch@meta.com>
	<20241206221801.790690-13-kbusch@meta.com>
	<CGME20241210073523epcas5p149482220b87ff3926fb8864ff1660e0c@epcas5p1.samsung.com>

------OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_710e1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 06/12/24 02:18PM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Maps a user requested write stream to an FDP placement ID if possible.
>
>Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_710e1_
Content-Type: text/plain; charset="utf-8"


------OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_710e1_--

