Return-Path: <io-uring+bounces-3958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7A19ADB3D
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 07:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6735F1F22D05
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 05:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77960170822;
	Thu, 24 Oct 2024 05:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EVLe2lpO"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340731C01
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 05:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729746762; cv=none; b=JVxmNy0Q4bao24I+CbCecW55PdvXci0M8KJqjj7KbNRXPbS2HGx/X0Cw9vWQR+1KCSeLbtV05ClL0QmzN2DtOjnEHpVhCTWZZt7816JGPM7TqPY4qUisfSlEhK5LUm6ywJZ9l1ot7YYjwxxnUWan+UHOVI7TV9dWsJIdUVtfoGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729746762; c=relaxed/simple;
	bh=QMHwjleCWdqJmffl09X8XxcLieRaYgHpBRHiOVAODVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Apa/mFsKrmqht+HZ7+F5TsZF2KHv7nyMdwJxqr/doHY2cvfX0b32yRvbwbgQCTC5hTGV3RUJAFpxLa6XvDvNdMXCOZcb7oJwnVppi5O5ePrRVsnLB1Yyf7xPerZreCoalYmr2nYYzxuC8mQyb2hTX/b9PwXwTTVDg1idSSXi/xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EVLe2lpO; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241024051236epoutp04f7d60641b7330e2174146f329636ff36~BS4KVIPKw2180021800epoutp04W
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 05:12:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241024051236epoutp04f7d60641b7330e2174146f329636ff36~BS4KVIPKw2180021800epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729746756;
	bh=20NJUmqLwCb2XXrI7br3jpwrndagv7bAxQXw0ZBPwdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVLe2lpOm5TJ64fr4cGEw2+Jlnl41VQGhecLlxHcIhovvLyQpGU26/5EKWwlY2Zm+
	 SDuzzu0tMZy89JvUxo00c/cNv1Cvi+Ia04k7Kqyo54lMiRhQcwQEdhnolnFmpPRNmq
	 TdsazmiVYpYalu/oIf/IWa/LBzKWESvqe2m9rGRk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241024051235epcas5p3f10791adf8ae8cff9b5acbfd1d32f3ce~BS4J2YuPp1462214622epcas5p3r;
	Thu, 24 Oct 2024 05:12:35 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XYvDb30Tfz4x9QK; Thu, 24 Oct
	2024 05:12:31 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.6A.08574.F37D9176; Thu, 24 Oct 2024 14:12:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241024023812epcas5p1e5798728def570cb57679eebdd742d7b~BQxW800j43055130551epcas5p1h;
	Thu, 24 Oct 2024 02:38:12 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241024023812epsmtrp1757909e7a598349e37b14d0a845ae2d2~BQxW8LAUq0664606646epsmtrp1u;
	Thu, 24 Oct 2024 02:38:12 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-01-6719d73f3f53
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.52.07371.413B9176; Thu, 24 Oct 2024 11:38:12 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241024023811epsmtip2d3692b7522bbf2b5914ba3084a2a39ce~BQxVzfvEs2454624546epsmtip2a;
	Thu, 24 Oct 2024 02:38:11 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: asml.silence@gmail.com, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v8] io_uring: releasing CPU resources when polling
Date: Thu, 24 Oct 2024 10:38:05 +0800
Message-Id: <20241024023805.1082769-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTXdf+umS6we5dYhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZZ//3sBd8Eqk4
	/l2ngXGXYBcjJ4eEgInEopMHmLsYuTiEBHYzShw4eYYdwvnEKNE2aQ1U5hujxJwLBxlhWhpv
	7GKFSOxllFjz7ypUyw9GiTePdzGBVLEJKEns3/IBrENEQFti7f3tLCA2s4CVxNk5P8FsYQEv
	ifcbj7OD2CwCqhI7/n1lBrF5BawlHrb8YoXYJi9xs2s/WJxTwFai/9c/NogaQYmTM59AzZSX
	aN46mxmi/hG7xJRbWRC2i8SZBa+ZIGxhiVfHt7BD2FISL/vboOx8icnf10N9ViOxbvM7Fgjb
	WuLflT1ANgfQfE2J9bv0IcKyElNPrWOCWMsn0fv7CdR4Xokd82BsJYklR1ZAjZSQ+D1hESvI
	GAkBD4lv37ghQTWBUaLn/jb2CYwKs5B8MwvJN7MQNi9gZF7FKJlaUJybnppsWmCYl1oOj+Pk
	/NxNjODUqOWyg/HG/H96hxiZOBgPMUpwMCuJ8F7MkEwX4k1JrKxKLcqPLyrNSS0+xGgKDO6J
	zFKiyfnA5JxXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVAPThq8H
	K3ZdmdqR5fX2kW/+/iendJ4GW76YZ9kgWHDUIVmj/oQC1+a0O1fndRReOXyjJvz82RmrI897
	GK5LetqrE+tWlv/y/tdsx/Ny0z2yX96ve+fp4J8pcN6PW9LhlWB7bHBp1ueun5MqPwYoC0Te
	WRDF6pAkEa088Xo0d39M+ZljJ6fMWvzxc6iYGtcZvu5YH/2NTBOT/NV0ko1c2oPDTtwybxXY
	c8lkf/Kky1+/3Lx9e3PxpC/pEXps1zJN0j9Z25qHOB3KaXXn0g786Rc0s3Hqq47NZ+0OLdmo
	tCvUTvXNBjcv3xuzc/J7tfj856y4rZ+nMqfnyxTTTPFDp0/MK3Q/z8//beG3bQxbCgOVWIoz
	Eg21mIuKEwF3cKySFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSvK7IZsl0g/0TpS3mrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sDmweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDLO/u9hL/gkUnH8u04D4y7BLkZODgkBE4nGG7tYuxi5OIQEdjNKvDv4kREiISGx49Ef
	VghbWGLlv+fsEEXfGCXOTX/EDJJgE1CS2L/lA1iDiICuxNpNjWA2s4CNxM6WLewgtrCAl8T7
	jcfBbBYBVYkd/76C9fIKWEs8bPkFtUBe4mbXfrA4p4CtRP+vf2xdjBxAy2wkFu6SgigXlDg5
	8wkLSJhZQF1i/TwhiE3yEs1bZzNPYBSchaRqFkLVLCRVCxiZVzFKphYU56bnJhsWGOallusV
	J+YWl+al6yXn525iBAe6lsYOxnvz/+kdYmTiYDzEKMHBrCTCezFDMl2INyWxsiq1KD++qDQn
	tfgQozQHi5I4r+GM2SlCAumJJanZqakFqUUwWSYOTqkGJrWe4tmrLmUdyY9958hfK2dqmLBL
	fA1TzHrWFz07Lzfpm5s4LDx2s+F+7dPZ+fOKTtZMlq4oDXrl7XmgLmtdN0e1kmv0uecd+rvs
	2G4eWrWX8bobu//v1f2Lfp4+0bPj4nzNp/u65t2IkFW+c3LHjMKG+JNnFrgrbp0V3SHsFjHr
	2HFhB8/jSu4L2L5nVsVPPGCo63uvY1JYxmfvJtM1EirWWQ82egUsTZxa0F4bXy/50PzCtg83
	zWNPuhbOa95zLNvv4/Ji7u0eLX0x0vb1OxZPSHVjF3XN1Y4zddhsmB9xaqnDhL4dQrni/NFv
	lZfq7TzN2nO7/qLxF4YnclPf5W80vrPuTsyO8HhLkaP3lViKMxINtZiLihMBHjsXkuMCAAA=
X-CMS-MailID: 20241024023812epcas5p1e5798728def570cb57679eebdd742d7b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241024023812epcas5p1e5798728def570cb57679eebdd742d7b
References: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
	<CGME20241024023812epcas5p1e5798728def570cb57679eebdd742d7b@epcas5p1.samsung.com>

On 9/25/2024 12:12, Pavel Begunkov wrote:
>I don't have a strong opinion on the feature, but the open question
>we should get some decision on is whether it's really well applicable to
>a good enough set of apps / workloads, if it'll even be useful in the
>future and/or for other vendors, and if the merit outweighs extra
>8 bytes + 1 flag per io_kiocb and the overhead of 1-2 static key'able
>checks in hot paths.

IMHO, releasing some of the CPU resources during the polling
process may be appropriate for some performance bottlenecks
due to CPU resource constraints, such as some database
applications, in addition to completing IO operations, CPU
also needs to peocess data, like compression and decompression.
In a high-concurrency state, not only polling takes up a lot of
CPU time, but also operations like calculation and processing
also need to compete for CPU time. In this case, the performance
of the application may be difficult to improve.

The MultiRead interface of Rocksdb has been adapted to io_uring,
I used db_bench to construct a situation with high CPU pressure
and compared the performance. The test configuration is as follows,

-------------------------------------------------------------------
CPU Model 	Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz
CPU Cores	8
Memory		16G
SSD			Samsung PM9A3
-------------------------------------------------------------------

Test case：
./db_bench --benchmarks=multireadrandom,stats
--duration=60
--threads=4/8/16
--use_direct_reads=true
--db=/mnt/rocks/test_db
--wal_dir=/mnt/rocks/test_db
--key_size=4
--value_size=4096
-cache_size=0
-use_existing_db=1
-batch_size=256
-multiread_batched=true
-multiread_stride=0
------------------------------------------------------
Test result：
			National	Optimization
threads		ops/sec		ops/sec		CPU Utilization
16			139300		189075		100%*8
8			138639		133191		90%*8
4			71475		68361		90%*8
------------------------------------------------------

When the number of threads exceeds the number of CPU cores,the
database throughput does not increase significantly. However,
hybrid polling can releasing some CPU resources during the polling
process, so that part of the CPU time can be used for frequent
data processing and other operations, which speeds up the reading
process, thereby improving throughput and optimizaing database
performance.I tried different compression strategies and got
results similar to the above table.(~30% throughput improvement)

As more database applications adapt to the io_uring engine, I think
the application of hybrid poll may have potential in some scenarios.
--
Xue

