Return-Path: <io-uring+bounces-98-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 307CB7F0484
	for <lists+io-uring@lfdr.de>; Sun, 19 Nov 2023 06:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B08AFB2075F
	for <lists+io-uring@lfdr.de>; Sun, 19 Nov 2023 05:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4314153BF;
	Sun, 19 Nov 2023 05:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mtA7JnCP"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB45192
	for <io-uring@vger.kernel.org>; Sat, 18 Nov 2023 21:44:31 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20231119054427epoutp03408af6334d2c801faa678d403e774ecb~Y7_6Puu661935419354epoutp03G
	for <io-uring@vger.kernel.org>; Sun, 19 Nov 2023 05:44:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20231119054427epoutp03408af6334d2c801faa678d403e774ecb~Y7_6Puu661935419354epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1700372667;
	bh=acisFztUKpjeKMKioP89uYReNJaDW+C6LZ8gdfib14g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtA7JnCPRutWsbCfRE3KFGXIiLcTPq6WX0Nh6pYqIIIq21lzwp/vb7a4YDrva7u1M
	 VjcSaj7iswepOGuBoXT6Ipk3pVFs63mkv+gsY4wp9vblFq51uHtXUbMvW2Zy2H7zJE
	 0QEHbz3FnZK9vtaynmltV2jUuF2Qj/vjt1o6imp0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20231119054426epcas5p3e6d458615f54d4b2dd71249773656510~Y7_5vxSGt1479714797epcas5p3g;
	Sun, 19 Nov 2023 05:44:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4SY02K05mRz4x9Pq; Sun, 19 Nov
	2023 05:44:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0A.5A.10009.8B0A9556; Sun, 19 Nov 2023 14:44:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231118032740epcas5p20b6aad6264323376fa024bc2a56f0990~YmeMh0elz2208922089epcas5p25;
	Sat, 18 Nov 2023 03:27:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231118032740epsmtrp2a136bf86f3267b036f187156306d1c0d~YmeMg3Pug0866708667epsmtrp2d;
	Sat, 18 Nov 2023 03:27:40 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-1c-6559a0b8e667
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	68.BA.08755.B2F28556; Sat, 18 Nov 2023 12:27:39 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20231118032738epsmtip22d14803f98dafe47a22a79304adc65de~YmeLQZepw2926129261epsmtip2t;
	Sat, 18 Nov 2023 03:27:38 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: [PATCH v3] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Date: Sat, 18 Nov 2023 11:19:51 +0800
Message-Id: <20231118031951.21764-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <605eac76-ec47-436b-872a-f6e8b4094293@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmpu6OBZGpBgsem1vMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLaZu2cFk0dFymdGB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IxrDcdYCxaIVBzqNG5gbBToYuTkkBAwkWi5O5e1i5GLQ0hgN6PE
	rD39bBDOJ0aJ88+2sEM43xglpjx5ygjT0vr2LFTVXkaJyT83sEA4Lxklvj65yAZSxSagLXF9
	XRcriC0iICyxv6MVrIhZ4C+jxISXv5lBEsIC8RLH5hwDKuLgYBFQlbj7qg4kzCtgI3Hj3ilm
	iG3yEvsPngWzOQVsJf7tWMUMUSMocXLmExYQmxmopnnrbGaQ+RICX9klPk7awwrR7CKxc8Yl
	NghbWOLVcZB/QGwpic/v9kLFiyWO9HxnhWhuYJSYfvsqVJG1xL8re1hAjmMW0JRYv0sfIiwr
	MfXUOiaIxXwSvb+fMEHEeSV2zIOxVSVWX3rIAmFLS7xu+A0V95D4tHA1G8hIIYEJjBKPdSYw
	KsxC8s4sJO/MQli8gJF5FaNkakFxbnpqsWmBUV5qOTySk/NzNzGCk6mW1w7Ghw8+6B1iZOJg
	PMQowcGsJML7TSgiVYg3JbGyKrUoP76oNCe1+BCjKTC4JzJLiSbnA9N5Xkm8oYmlgYmZmZmJ
	pbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTMHTLzDdTey4+/XRqXLV+68XBFm8Fv3i
	E6zeoi2cZjYha1HRundKfJN42yTWcvc8/OBx0D/Bq3n258+6d6d6T2X66D2XN759Qud1phSj
	/+Fsl8Oy+tbNLWI+Idm4+WdHws5395b+X9z0Zz/rxAWH1Q8883ow91T1XsZLnsbticLGr05N
	SgoWUMrk59rvKb52ydH7r3sLLvuvLNnQ9ix1+qal/9fcVAhuXmC9T5E/SjdJNUDW6RuLPnOP
	gKjz05A1Ph2TMjJWTnROTbXaoSeiU3J++dwU21W2fKrhehwSiUtmzuKL2TDLcXXqpvaOd/Ob
	bNa0LX1afSBsRtXVHQsO5lh2ssVUdnuydp9+Y/w3RImlOCPRUIu5qDgRAE8MW8kvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvK62fkSqwZVZVhZzVm1jtFh9t5/N
	4l3rORaLo//fsln86r7LaLH1y1dWi8u75rBZPNvLafHl8Hd2i6lbdjBZdLRcZnTg9tg56y67
	x+WzpR59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVca3hGGvBApGKQ53GDYyNAl2MnBwSAiYS
	rW/PsnUxcnEICexmlNg+7x5jFyMHUEJa4s+fcogaYYmV/56zQ9Q8Z5R4e+Y8E0iCTUBb4vq6
	LlYQWwSoaH9HKwuIzSzQySTx+rMeyBxhgViJyz9KQUwWAVWJu6/qQCp4BWwkbtw7xQwxXl5i
	/8GzYDangK3Evx2rmEHKhYBqLqxVgSgXlDg58wnUcHmJ5q2zmScwCsxCkpqFJLWAkWkVo2Rq
	QXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwmGtp7mDcvuqD3iFGJg7GQ4wSHMxKIrzfhCJS
	hXhTEiurUovy44tKc1KLDzFKc7AoifOKv+hNERJITyxJzU5NLUgtgskycXBKNTAd+Tkh2uxt
	v/RsY+v5l2L5eVsfajX+v/g/2DUlKVmeKUXk2+dIM2bL5V/mK6kx7t5hrnm2t1VMMGfqxAuN
	r547fur6omodf/4kY/ONiz9+nJ6fWsNaJBdcNGcel967k9eybR8FTO2YovPx0eKdxfHubU1t
	PeuSWNgOxU3VPOOixO0Yo7148VmHlm3WRYxM/byMj/52PzO6zVQaZMztv2bdNrmouUnJEZWP
	ztauWmndsPT7H3WX1AO3mnOzW3S9FH3X/K7WfPB1hruFqf//iHX+vjMmz2A9sXXaTlNdfz+x
	C/5cLnn+BbqL9wetUqzMinGfGLpemc1Ip/N++lZLUyG+ibL+12I11x7jet9spsRSnJFoqMVc
	VJwIACCkQsniAgAA
X-CMS-MailID: 20231118032740epcas5p20b6aad6264323376fa024bc2a56f0990
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231118032740epcas5p20b6aad6264323376fa024bc2a56f0990
References: <605eac76-ec47-436b-872a-f6e8b4094293@kernel.dk>
	<CGME20231118032740epcas5p20b6aad6264323376fa024bc2a56f0990@epcas5p2.samsung.com>

On 11/15/23 6:42 AM, Jens Axboe wrote:
> 	 */
> 	has_lock = mutex_trylock(&ctx->uring_lock);
> 
>-	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>-		struct io_sq_data *sq = ctx->sq_data;
>-
>-		sq_pid = sq->task_pid;
>-		sq_cpu = sq->sq_cpu;
>+	if (ctx->flags & IORING_SETUP_SQPOLL) {
>+		struct io_sq_data *sq;
>+
>+		rcu_read_lock();
>+		sq = READ_ONCE(ctx->sq_data);
>+		if (sq) {
>+			sq_pid = sq->task_pid;
>+			sq_cpu = sq->sq_cpu;
>+		}
>+		rcu_read_unlock();
> 	}
> 
> 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>index 65b5dbe3c850..583c76945cdf 100644
>--- a/io_uring/sqpoll.c
>+++ b/io_uring/sqpoll.c
>@@ -70,7 +70,7 @@ void io_put_sq_data(struct io_sq_data *sqd)
> 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
> 
> 		io_sq_thread_stop(sqd);
>-		kfree(sqd);
>+		kfree_rcu(sqd, rcu);
> 	}
> }
> 
>@@ -313,7 +313,7 @@ static int io_sq_thread(void *data)
> 	}
> 
> 	io_uring_cancel_generic(true, sqd);
>-	sqd->thread = NULL;
>+	WRITE_ONCE(sqd->thread, NULL);
> 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> 		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
> 	io_run_task_work();
>@@ -411,7 +411,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
> 			goto err_sqpoll;
> 		}
> 
>-		sqd->thread = tsk;
>+		WRITE_ONCE(sqd->thread, tsk);
> 		ret = io_uring_alloc_task_context(tsk, ctx);
> 		wake_up_new_task(tsk);
> 		if (ret)
>diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>index 8df37e8c9149..0cf0c5833a27 100644
>--- a/io_uring/sqpoll.h
>+++ b/io_uring/sqpoll.h
>@@ -18,6 +18,8 @@ struct io_sq_data {
> 
> 	unsigned long		state;
> 	struct completion	exited;
>+
>+	struct rcu_head		rcu;
> };
> 
> int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);

I tested this and it worked after adding RCU lock.
It consistently outputs correct results.

The results of a simple test are as follows:
Every 0.5s: cat /proc/10212/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 17422716
SqTail: 17422716
CachedSqHead:   17422716
SqThread:       10212
SqThreadCpu:    73
SqBusy: 97%
-------------------------------------------------------------
But the name of the sq thread is "iou-sqp-" + "the PID of its parent process":
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
  10211 root      20   0  184408   8192      0 R  99.9   0.0   4:01.42 fio
  10212 root      20   0  184408   8192      0 R  99.9   0.0   4:01.48 iou-sqp-10211
Is this the originally desired effect?

