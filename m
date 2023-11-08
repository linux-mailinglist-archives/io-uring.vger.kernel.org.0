Return-Path: <io-uring+bounces-72-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2620B7E51C0
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 09:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 573581C209B0
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 08:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF43DDDA2;
	Wed,  8 Nov 2023 08:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ou7rEsyn"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C358EDDA1
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 08:15:34 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54B61712
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 00:15:33 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20231108081531epoutp03dfec866116bfea10612f754b774e0452~Vl8q6_ZIh0673506735epoutp03J
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 08:15:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20231108081531epoutp03dfec866116bfea10612f754b774e0452~Vl8q6_ZIh0673506735epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699431331;
	bh=31PFSdRimMsZZ+BxKdUm1cVTn6llistXyY95FoxysL4=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Ou7rEsyn0+uDuu4v4BmuM0ZFYXTwtP1mh2BUuJNGvVDgwK1kkEeEVItSADAjKCMVC
	 RcjEwmlgi3d7T00J5NMMX2lFzFiWkGADSVY9OV1Q4HmA32Cu57GVSKbLxMDpPg9qfS
	 xPpefi03DCuCayAiobcMsHm9qAo64oV5u4gen5sc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20231108081530epcas5p161ba1bafe3a28ad4dc222dbe4142ceb8~Vl8qjzpMf2147621476epcas5p1j;
	Wed,  8 Nov 2023 08:15:30 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4SQHvj03Xwz4x9Pw; Wed,  8 Nov
	2023 08:15:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.4E.10009.0A34B456; Wed,  8 Nov 2023 17:15:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231108081516epcas5p442a11004e3b4e6339972fd6da4c6692b~Vl8dS5wdb0759407594epcas5p4d;
	Wed,  8 Nov 2023 08:15:16 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231108081516epsmtrp21a7cb88f4b4e77a34cc7afdb4b96d17b~Vl8dRnGKr1082410824epsmtrp2q;
	Wed,  8 Nov 2023 08:15:16 +0000 (GMT)
X-AuditID: b6c32a4a-ff1ff70000002719-a1-654b43a0538e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.6A.08817.4934B456; Wed,  8 Nov 2023 17:15:16 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20231108081515epsmtip1178fa5bdd393301f0f9846a23c069a8a~Vl8cKIeKR2730027300epsmtip1S;
	Wed,  8 Nov 2023 08:15:15 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	Xiaobing Li <xiaobing.li@samsung.com>
Subject: [PATCH v2] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed,  8 Nov 2023 16:07:32 +0800
Message-Id: <20231108080732.15587-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmpu4CZ+9Ug/8bLC3mrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFlO37GCy6Gi5zOjA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsaMY7PZCn5JVLx9v4atgfG2cBcjJ4eEgIlE+9R5bF2MXBxCArsZ
	Jd4/a2WCcD4xSkyYO5kRwvnGKHHk7EEmmJa9d06zQCT2Mkq8fnUYquUlo8S+hevYQarYBLQl
	rq/rYgWxRYDs14+ngnUwC3xmlFhz+xsLSEJYIFDiTWMnkM3BwSKgKnF7ThqIyStgI9HYKACx
	TF5i/8GzzCA2r4CgxMmZT8A6mYHizVtnM4OMlBB4yS5x4OcDdogGF4m32/8yQtjCEq+Ob4GK
	S0l8freXDcIuljjS850VormBUWL67atQRdYS/67sAbuHWUBTYv0ufYiwrMTUU+uYIBbzSfT+
	fgINCV6JHfNgbFWJ1ZceskDY0hKvG35DxT0kHnfcBLOFBGIlji/uZpnAKD8LyT+zkPwzC2Hz
	AkbmVYySqQXFuempxaYFRnmp5fCYTc7P3cQITptaXjsYHz74oHeIkYmD8RCjBAezkgjvX3uP
	VCHelMTKqtSi/Pii0pzU4kOMpsAgnsgsJZqcD0zceSXxhiaWBiZmZmYmlsZmhkrivK9b56YI
	CaQnlqRmp6YWpBbB9DFxcEo1MJnw33+wqnPiry3P/1w5X1bDZCb2d9lNC7M5O51KdNfuU/5w
	82HZarvkZ2uOTRHZd/zd2lajXza5n1L283qmm9+953xoi+1VhYU3jmnHbLzTtvCAkNbaoPrf
	ny9PeC7bKz9/wvojq/1tjeyYt7E1tDq5WnJ0lu3jkLL5ruIUoON7cNUB/ZdVQRbHrnod+3be
	QGzd1sjjy6IfLM6bzPi0SOzbrderjl6aWXltm+A9y6qzKoUv7VZVKvpV86d9vf4uac+zczpG
	0wLf/n14xinj7U7pteKTuhIXrdzTmOzBqnfyu1fedhUOE5OOHNu0kMNxWe8EhOxMNgdLlm49
	nFKhKS+/ds9TDzNuTZ+Xxp0Pjs5UYinOSDTUYi4qTgQAum++kiQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWy7bCSnO4UZ+9Ug3Nb1CzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFlO37GCy6Gi5zOjA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY8ax2WwFvyQq3r5fw9bAeFu4i5GTQ0LA
	RGLvndMsXYxcHEICuxkl5nZ/Zupi5ABKSEv8+VMOUSMssfLfc3aImueMEj+6bjGCJNgEtCWu
	r+tiBakXEdCVaLyrAFLDLPCXUeLr6jlsIDXCAv4S8y7OAqthEVCVuD0nDcTkFbCRaGwUgBgv
	L7H/4FlmEJtXQFDi5MwnLCA2M1C8eets5gmMfLOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1qu
	V5yYW1yal66XnJ+7iREculpaOxj3rPqgd4iRiYPxEKMEB7OSCO9fe49UId6UxMqq1KL8+KLS
	nNTiQ4zSHCxK4rzfXvemCAmkJ5akZqemFqQWwWSZODilGpgmsCzVX5QZaemrdvviZhEx0YWM
	sxJjT1Zr+vqFik4+5hySKi299EZhCgPzS86N/Ea29p8OeXc27JBXfrx0M+svTsG+lTG7ZhbZ
	LMxKUVFVOr/qrKNY2kqGX0V3w9UM0nNX1/Ft3HpeMWiK88rG7n3Mmw2/Mn/SLGW1/u77qP3F
	dz6drWWPDzNmvdmx/Ojxr433950xKQ24Hqa9c+LCSv07kZNXvtpSMtv/zrrkbT6Zb1p3Cr+/
	9ZvX4uHTW0eXH358yzro0NFVdTvjDVZcnvNktcoWp+fHzlmWtNfP/vdtjU/M2/Bl07zevIuQ
	jp14IiVxxunCM/67YtzncXMJhxmycfDKce4+v+jn7lNb1L9pKrEUZyQaajEXFScCAKupgDTM
	AgAA
X-CMS-MailID: 20231108081516epcas5p442a11004e3b4e6339972fd6da4c6692b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231108081516epcas5p442a11004e3b4e6339972fd6da4c6692b
References: <CGME20231108081516epcas5p442a11004e3b4e6339972fd6da4c6692b@epcas5p4.samsung.com>

Since the sq thread has a while(1) structure, during this process, there
may be a lot of time that is not processing IO but does not exceed the
timeout period, therefore, the sqpoll thread will keep running and will
keep occupying the CPU. Obviously, the CPU is wasted at this time;Our
goal is to count the part of the time that the sqpoll thread actually
processes IO, so as to reflect the part of the CPU it uses to process
IO, which can be used to help improve the actual utilization of the CPU
in the future.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>

v1 -> v2: Added method to query data.

The test results are as follows:
cat /proc/11440/fdinfo/6
pos:    0
flags:  02000002
mnt_id: 16
ino:    94449
SqMask: 0xf
SqHead: 1845170
SqTail: 1845170
CachedSqHead:   1845170
CqMask: 0xf
CqHead: 1845154
CqTail: 1845154
CachedCqTail:   1845154
SQEs:   0
CQEs:   0
SqThread:       -1
SqThreadCpu:    -1
UserFiles:      1
UserBufs:       0
PollList:
CqOverflowList:
PID:    11440
work:   18794
total:  19123

---
 io_uring/fdinfo.c | 6 ++++++
 io_uring/sqpoll.c | 8 ++++++++
 io_uring/sqpoll.h | 2 ++
 3 files changed, 16 insertions(+)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f04a43044d91..f0b79c533062 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -213,6 +213,12 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
 	}
 
+	if (ctx->sq_data) {
+		seq_printf(m, "PID:\t%d\n", task_pid_nr(ctx->sq_data->thread));
+		seq_printf(m, "work:\t%lu\n", ctx->sq_data->work);
+		seq_printf(m, "total:\t%lu\n", ctx->sq_data->total);
+	}
+
 	spin_unlock(&ctx->completion_lock);
 }
 #endif
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..c821273406bd 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -224,6 +224,7 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
+	unsigned long start, begin, end;
 	DEFINE_WAIT(wait);
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
@@ -235,6 +236,7 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 
 	mutex_lock(&sqd->lock);
+	start = jiffies;
 	while (1) {
 		bool cap_entries, sqt_spin = false;
 
@@ -245,12 +247,18 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		begin = jiffies;
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
+		end = jiffies;
+		sqd->total = end - start;
+		if (sqt_spin == true)
+			sqd->work += end - begin;
+
 		if (io_run_task_work())
 			sqt_spin = true;
 
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..0aa4e2efa4db 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,8 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	unsigned long       work;
+	unsigned long       total;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.34.1


