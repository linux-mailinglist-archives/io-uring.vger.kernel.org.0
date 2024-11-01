Return-Path: <io-uring+bounces-4298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2499B8DE7
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 10:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FAD11C20B93
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 09:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A104D1BDC3;
	Fri,  1 Nov 2024 09:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W2HGURR4"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA861581F0
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 09:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453557; cv=none; b=LZNKpCSIQEyGXikwwxcJBRaT1L3iQNVR2ZWCmiFfT+vgmMITk+rtMlu153mCo4O5TCuPZNat4T7L5WQZpEnYjSHH/OIiAZHFiQpHs3DXSNDFN/TJ3CDvlEvx8SCcgd4gzKMI5jAAE+5sFj3yAn1nkgXgs1jKTejmEGUhkjMv3R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453557; c=relaxed/simple;
	bh=8JT1KSGbwIIi9U6Y6JINeq/j0V9Eu+cGVsjZAzNNP5o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=BrWulcFIdcNW+zWh/8Z2bPO+RBkEIE3ibgP5CDy1as0S8fvIpxAmey8Crnq57cS15CpKiTzUlOd1o5GlbGtclHx2XIf3lfgl2+uRa0bHJA+rijo3nG42GujcHo0lsqqrD/oa1r1Y5ICKO+USpNJTNUvvebbpa6nYFWRrSa18joI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W2HGURR4; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241101093231epoutp01fe3c26ca617a34a02b6592edd7ff603d~DzlZLsvg21960919609epoutp01o
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 09:32:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241101093231epoutp01fe3c26ca617a34a02b6592edd7ff603d~DzlZLsvg21960919609epoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730453551;
	bh=RBIeRi6DvPfok+pEnL5Q3tutpIPNPK4K5trjCZx3AIw=;
	h=From:To:Cc:Subject:Date:References:From;
	b=W2HGURR4HXXkcMQ82WvgrPCidN+pD1h0ie2/v6ORV41JIlS27HHcAhCkGtyVRm9R/
	 /l0l9xFbYsWqwKs4MkNhXPjZJWykvg86+cVifUFrbd5nDziZhyhEVzeU3HWnDwVl0H
	 DBSXGuz03tyld/kJ5O+kvdWEn14YcrYXHgzWsEGc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241101093231epcas5p37429a0d3ceecac28544e3cf736904a10~DzlYyOqxi0632306323epcas5p3M;
	Fri,  1 Nov 2024 09:32:31 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xfwcs21f9z4x9Px; Fri,  1 Nov
	2024 09:32:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E7.CD.08574.D20A4276; Fri,  1 Nov 2024 18:32:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241101092007epcas5p29e0c6a6c7a732642cba600bb1c1faff0~DzajrPZQR0809008090epcas5p2D;
	Fri,  1 Nov 2024 09:20:07 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241101092007epsmtrp2a16eb8016917b757decdacbbe84312e9~DzajqkDkq2461124611epsmtrp2A;
	Fri,  1 Nov 2024 09:20:07 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-40-6724a02dd81b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	04.8E.18937.74D94276; Fri,  1 Nov 2024 18:20:07 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241101092006epsmtip2a8781b955a069bf49645f6b99fb8f500~DzaitT17m0073700737epsmtip2k;
	Fri,  1 Nov 2024 09:20:06 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH v9 0/1] io_uring: releasing CPU resources when polling
Date: Fri,  1 Nov 2024 17:19:56 +0800
Message-Id: <20241101091957.564220-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmpq7uApV0g3vfOSzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3x80Av
	Y8F5+YoXq48yNzDelOhi5OSQEDCRaNz9lAnEFhLYzSjRtVS2i5ELyP7EKPFp9nxWOGfyq90s
	MB3fDm9jg0jsZJT4t+ojlPODUeL8k1NgVWwCShL7t3xgBLFFBLQlXj+eChTn4GAWiJJ4sZYb
	JCws4CZx88Z2sHIWAVWJjtX72EBsXgEribXXzzNDLJOXuNm1nxkiLihxcuYTsHpmoHjz1tnM
	IHslBA6xS7w5fACqwUVi2rd2KFtY4tXxLewQtpTE53d72SDsfInJ39czQtg1Eus2v4P6zFri
	35U9UHdqSqzfpQ8RlpWYemodE8RePone30+YIOK8EjvmwdhKEkuOrIAaKSHxe8IiVgjbQ+LK
	5yXMICOFBGIlTi5JnMAoPwvJN7OQfDMLYfECRuZVjJKpBcW56anJpgWGeanl8GhNzs/dxAhO
	hVouOxhvzP+nd4iRiYPxEKMEB7OSCO+HAuV0Id6UxMqq1KL8+KLSnNTiQ4ymwCCeyCwlmpwP
	TMZ5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwLTh2cleN0iPr
	gx8zHWc527itCAz+VnU69VHc/YKmn6GdCRNvV0vXpM7MFRUojr5vGVmvLrDPg2lv9Nuny2Tm
	lOSe6dTmW3r+H6NByguxlR2zYy18Itf9nDnvxseNEcvYPAIjVswy+Po7sGHx5k16DFPypRg4
	KziXqNX5T5rv6CQi7RtlZeH6cNHL11dXFzQa6M878Gq5hNCN0LzotdezJim5/l2/bYb8lAcv
	AnsmKE3qMjv+8KtZzhfRrLNXlt08GG/ttuHFixNz2J57HF/9QmDKhnmPS6+/yfj1Ir/UtuSL
	vQ/zrH8FZmnVtc/T3BZ2ZkX9CqqbeYb3a3CAp0CGx3WWff3XmBMVGI50Vs0SV2Ipzkg01GIu
	Kk4EABtXVdkOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSvK77XJV0g95OTos5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hszg74QOrRdeFU2wO7B47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJS
	czLLUov07RK4Mn4e6GUsOC9f8WL1UeYGxpsSXYycHBICJhLfDm9j62Lk4hAS2M4osf/1JSaI
	hITEjkd/WCFsYYmV/56zQxR9Y5T4f7SVHSTBJqAksX/LB8YuRg4OEQFdica7CiBhZoEYiQ97
	JoCVCAu4Sdy8sZ0FxGYRUJXoWL2PDcTmFbCSWHv9PDPEfHmJm137mSHighInZz5hgZgjL9G8
	dTbzBEa+WUhSs5CkFjAyrWIUTS0ozk3PTS4w1CtOzC0uzUvXS87P3cQIDkitoB2My9b/1TvE
	yMTBeIhRgoNZSYT3Q4FyuhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILU
	IpgsEwenVANTmuONyhUbsj8tKuKIt2R4eSdcpOik7UHHrjd/PvlM49M+6Wila6Qglz7rgmSC
	5KM7/c9frDm+9Pvn39sl2kzET9ast3SW/m2SknZKTfXgtJqkfudtX/ZG177RvMpzsclpDp+8
	xbVfAt4l0vOzlisnet3gmXFDTcrtYA3rleuectNXzHZQuSUU8+24SduXq7Vqkzwbdwqe5cpe
	x8R4Kdxh67PicJ87zo9SXeTmyf1d9U3NQydXdNkjH5Vt/XuZ3pSErD035Zef3iGd84tDk0Ok
	I6/ycs2Ibuswa1u+8fYPWduj+5qWLv6gc25qQUMs4yLBO5/S7ZoEp9gLLi/xvffn9k42g+xH
	T9bJfOW9VFGqxFKckWioxVxUnAgAdddriLcCAAA=
X-CMS-MailID: 20241101092007epcas5p29e0c6a6c7a732642cba600bb1c1faff0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241101092007epcas5p29e0c6a6c7a732642cba600bb1c1faff0
References: <CGME20241101092007epcas5p29e0c6a6c7a732642cba600bb1c1faff0@epcas5p2.samsung.com>

This patch add a new hybrid poll at io_uring level, it also set a signal
"IORING_SETUP_HYBRID_IOPOLL" to application, aim to provide a interface for
users to enable hybrid polling.

Hybrid poll may appropriate for some performance bottlenecks due to CPU
resource constraints, such as some database applications. In a
high-concurrency state, not only polling takes up a lot of CPU time, but
also operations like calculation and processing also need to compete for
CPU time.

The MultiRead interface of Rocksdb has been adapted to io_uring. Here used
db_bench to construct a situation with high CPU pressure and compared the
performance. The test configuration is as follows,

-------------------------------------------------------------------
CPU Model       Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz
CPU Cores       8
Memory          16G
SSD             Samsung PM9A3
-------------------------------------------------------------------

Test case:
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
---------------------------------------------------------------
Test result:
          National        Optimization
thread    sops/sec        ops/sec        CPU Utilization
16        121953          160233         100%*8
8         120198          116087         90%*8
4         61302           59105          90%*8
---------------------------------------------------------------

The 9th version patch makes following changes:

1. change some member and function name

2. Avoid the expansion of io_kiocb structure. After checking, the hash_node
structure is used in asynchronous poll, while the iopoll only supports the
dirict io for disk, these two path are different and they will not be used
simultaneously, it also confirmed in the code. So I shared this space with
iopoll_start.

 union {
	/*
	 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
	 * poll
	 */
	struct hlist_node   hash_node;
	/* For IOPOLL setup queues, with hybrid polling */
	u64                     iopoll_start;
 };

3. Avoid the expansion of io_ring_ctx structure. Although there is an
8-byte hole in the first structure, the structure is basically constants
and some read-only hot data that will not be changed, that means this cache
does not need to be brushed down frequently, but the hybrid_poll_time of
the recorded run time had a chance to be modified several times. So I put
it in the second structure (submission data), which is still 24 bytes of
space, and some of its own variables also need to be modified.

4. Add the poll_state identity to the flags of req.

/* every req only blocks once in hybrid poll */
REQ_F_IOPOLL_STATE = IO_REQ_FLAG(REQ_F_HYBRID_IOPOLL_STATE_BIT)

--
changes since v7:
- rebase code on for-6.12/io_uring
- remove unused varibales

changes since v6:
- Modified IO path, distinct iopoll and uring_cmd_iopoll
- update test results

changes since v5:
- Remove cstime recorder
- Use minimize sleep time in different drivers
- Use the half of whole runtime to do schedule
- Consider as a suboptimal solution between
  regular poll and IRQ

changes since v4:
- Rewrote the commit
- Update the test results
- Reorganized the code basd on 6.11

changes since v3:
- Simplified the commit
- Add some comments on code

changes since v2:
- Modified some formatting errors
- Move judgement to poll path

changes since v1:
- Extend hybrid poll to async polled io

hexue (1):
  io_uring: releasing CPU resources when polling

 include/linux/io_uring_types.h | 19 ++++++-
 include/uapi/linux/io_uring.h  |  3 ++
 io_uring/io_uring.c            |  8 ++-
 io_uring/rw.c                  | 92 ++++++++++++++++++++++++++++++----
 4 files changed, 108 insertions(+), 14 deletions(-)

-- 
2.40.1


