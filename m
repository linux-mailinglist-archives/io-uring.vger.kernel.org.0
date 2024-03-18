Return-Path: <io-uring+bounces-1103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E2F87EA27
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40AE31F22835
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 13:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A8320315;
	Mon, 18 Mar 2024 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MAA12Nud"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF9D481A8
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710768854; cv=none; b=UryDWsGC7EeSn9xcJddo2YYm5Gq5vhOaF1rHzpIH7EJ+xXjV9dC6tleq2zNUHlTXQMHH//2uIBRYKaHXeJtc2zW0IJqwRX5lOcMhvTUO+nQt2pAXOdeZxIzg6QKclYNMpIgVlRIBEuX/AybNTKQJ6GtaT/dPsJCRJJnh/7ipA/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710768854; c=relaxed/simple;
	bh=KBawqmx5ROMf0Pxv/ZnkwVrxI83Je3L3VlDjZ4KJsVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=BoL7UdLAXkF8mKM+0a70KyH97O67tTSZueGes6rnHIUpSTk1xuITIzpjvY4hZLXCugwWyTJu1V1IYqdzK3p/97nCJ4+69mg3hCZ6yKbyUu6WL4V9oH9Aqtd4yuJAEgTCsyTJJBgzNMy4lTlGhMi/7P9TIoPhMlFJBnfQm2A2V+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MAA12Nud; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240318132633epoutp039dd2a4847b4ff29eb9299bf2b84c7a91~93sob1KwY2513825138epoutp030
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 13:26:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240318132633epoutp039dd2a4847b4ff29eb9299bf2b84c7a91~93sob1KwY2513825138epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1710768393;
	bh=KBawqmx5ROMf0Pxv/ZnkwVrxI83Je3L3VlDjZ4KJsVo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MAA12NudkcBYwMUhclUDG/qgjga5y3FoN63Z+ilU2ZZtq4AS/GiRBGaJ1oYNc1Dug
	 g1v3byT8yYAytEhAOcgdLEqSrh4At7GenXQmJFFdd2GhTmusMvgz3+2OCVzlac38VN
	 /AXRvyZvFrXg8vAad2V4E8MIwGiB4QbLnvanCKCQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240318132632epcas5p48223bf2917a1bad4fb5a7b37a3940e18~93snsJzkY1066410664epcas5p4A;
	Mon, 18 Mar 2024 13:26:32 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Tywc64CPSz4x9Pt; Mon, 18 Mar
	2024 13:26:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BF.76.08600.60148F56; Mon, 18 Mar 2024 22:26:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240318132630epcas5p306a62941c18a9620e5245f551956c787~93sl0pEjT2004020040epcas5p3Z;
	Mon, 18 Mar 2024 13:26:30 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240318132630epsmtrp14c9867b8372c25f23992e0867c773fb5~93sl0E1wm1771517715epsmtrp1N;
	Mon, 18 Mar 2024 13:26:30 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-77-65f84106e76f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	DF.F4.19234.60148F56; Mon, 18 Mar 2024 22:26:30 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240318132629epsmtip1de5b434ec2950cf60bac895c6e7398c6~93sk8KWo80842408424epsmtip1G;
	Mon, 18 Mar 2024 13:26:29 +0000 (GMT)
Message-ID: <7a89d6f5-1c8f-2549-f435-61d334837934@samsung.com>
Date: Mon, 18 Mar 2024 18:56:28 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 06/14] nvme/io_uring: don't hard code
 IO_URING_F_UNLOCKED
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Ming Lei
	<ming.lei@redhat.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <e2939a17b63f9347ba3c1c193c4a9306c3ba0845.1710720150.git.asml.silence@gmail.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdlhTU5fN8UeqwceZ8hZzVm1jtFh9t5/N
	4l3rORaLvbe0LQ5NbmZyYPXYOesuu8fls6Ue7/ddZfP4vEkugCUq2yYjNTEltUghNS85PyUz
	L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKuSQlliTilQKCCxuFhJ386mKL+0
	JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtjxp/lLAXtTBXnvr5ga2C8
	x9jFyMEhIWAiMeuMRBcjF4eQwG5GiZmvtjJCOJ8YJR50HWWGc67On8HWxcgJ1rF4xk4WEFtI
	YCejxKynchBFbxklJjx6zQqS4BWwk3h+qIsJxGYRUJVoOd3CAhEXlDg58wmYLSqQLPGz6wDY
	UGGBIIk1zQvAbGYBcYlbT+YzgZwnIuAqseKTCojJLBAv0XJLD8RkE9CUuDC5FKSYUyBWYuue
	bnaIRnmJ7W/ngJ0sIfCSXWLJlS+MECe7SHy+uw7qfGGJV8e3sEPYUhIv+9ug7GSJSzPPMUHY
	JRKP9xyEsu0lWk/1M0OcoCmxfpc+xC4+id7fT5ggYcgr0dEmBFGtKHFv0lNWCFtc4uGMJVC2
	h8TFV0uZIAH1gFHix+WLTBMYFWYhhcksJL/PQvLOLITNCxhZVjFKphYU56anJpsWGOallsMj
	Ozk/dxMjOEFquexgvDH/n94hRiYOxkOMEhzMSiK8rmJfU4V4UxIrq1KL8uOLSnNSiw8xmgIj
	ZyKzlGhyPjBF55XEG5pYGpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fEwSnVwKQk
	Mz3yoyj76wbn5wru9wI550yMDS5l+f5twbnLIZ8FbbYcl7LY97TfQuqlhvAX58s5r1g/N6zW
	yAz4bOTaIvbyQOPR4Kep6yaLveacxPxtrsW35/1b56QxapaX5aR8mHfOk9n3Vtzn1irBt9L/
	0t9L7Ln+wd1csCilxfToSXO2o2nuUnXJk55/lJ0Wxuq+yYBFKEyCafXBPypV6S2GHMvfmjkm
	ZRk4Sbpt3qjv9kzwVs2c/I9LTohenHWPy+qATN+ZeSnbPWq2nWLUaFDJ5DdcZchWfOrXGV6l
	rFOHTj/aJqtXfEzk6LS/v3/d21gousp2J9ehpgdfdrJZ3Vz3QPyXgZPq6rDC07sU56l13VBi
	Kc5INNRiLipOBACU0tzFGQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnC6b449Ug49buCzmrNrGaLH6bj+b
	xbvWcywWe29pWxya3MzkwOqxc9Zddo/LZ0s93u+7yubxeZNcAEsUl01Kak5mWWqRvl0CV8aM
	P8tZCtqZKs59fcHWwHiPsYuRk0NCwERi8YydLF2MXBxCAtsZJabOaGGHSIhLNF/7AWULS6z8
	95wdoug1o8SnbWtZQRK8AnYSzw91MYHYLAKqEi2nW1gg4oISJ2c+AbNFBZIlXv6ZCDZIWCBI
	Yk3zAjYQmxlowa0n84F6OThEBFwlVnxSgQjHS6x63MoMsesBo8S57g5mkBo2AU2JC5NLQWo4
	BWIltu7pZoeoN5Po2trFCGHLS2x/O4d5AqPQLCRXzEKybRaSlllIWhYwsqxiFE0tKM5Nz00u
	MNQrTswtLs1L10vOz93ECI4FraAdjMvW/9U7xMjEwXiIUYKDWUmE11Xsa6oQb0piZVVqUX58
	UWlOavEhRmkOFiVxXuWczhQhgfTEktTs1NSC1CKYLBMHp1QDk8kDsycKvnOWrLH6mT/tdOdy
	/3t/en/P5/z0+c6BDRI2AhY7Ai3T96snZu9du5+1lP0R38PzWz48W1Zy4FjSdnVDr29VYZd2
	tBRMimG9b+vyliXvQ9+KKyJsXavO7Y4/+ex1scXvXzaNZyoWxGy/3flS4G7Ju+qZz4w51dV1
	/94rdt9+KuWwS+a0lcxaJ0I0lP+KsQVYdkac4woueJEqejc/yXdD8PypLG8DYlUZlaZekX8/
	U1Z1X4Nrm90N04hnqqGJT9LfNiyXW6xnUsqn+MOC4RvbNb2e/wetOc/un+ZZqp6x6oBB1Ept
	xao3JvFdj3fW3yxyE/tr9lHn3pmHBwLe3GiRCNj5XYCt98mbBUosxRmJhlrMRcWJAGRtzwz0
	AgAA
X-CMS-MailID: 20240318132630epcas5p306a62941c18a9620e5245f551956c787
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240318004348epcas5p43e669407fc4400bbc403c670104ba796
References: <cover.1710720150.git.asml.silence@gmail.com>
	<CGME20240318004348epcas5p43e669407fc4400bbc403c670104ba796@epcas5p4.samsung.com>
	<e2939a17b63f9347ba3c1c193c4a9306c3ba0845.1710720150.git.asml.silence@gmail.com>

On 3/18/2024 6:11 AM, Pavel Begunkov wrote:
> uring_cmd implementations should not try to guess issue_flags, use a
> freshly added helper io_uring_cmd_complete() instead.

NVMe interactions look/work fine.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

