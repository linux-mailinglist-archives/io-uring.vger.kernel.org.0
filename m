Return-Path: <io-uring+bounces-28-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C550D7E1B8F
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 08:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B20DB20CA7
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 07:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42EF1E56A;
	Mon,  6 Nov 2023 07:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RkiLi7xB"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD60DF66
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 07:55:45 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FBDC0
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 23:55:41 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231106075539epoutp0135176a7f1b9aef6918dd56fbf3b37101~U_Ywyhdo92716727167epoutp01S
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 07:55:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231106075539epoutp0135176a7f1b9aef6918dd56fbf3b37101~U_Ywyhdo92716727167epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699257340;
	bh=6NYx99oCWyMXAuJQC3OusH2vT6lJSfTjX8zw5hfAzvE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=RkiLi7xB6zo9N59+xDVnUYmDs/jmrv43VHQ5is2cshmjymwgNPZMkTjDGwrtesrfF
	 3b54bOggM8c8MuknK9YdOWsCvLYWrj8TBsgztKwMlh8wpxWvNz8Gz0lgklILT9o7hr
	 k4llRwM2qWzKY0Q5ohaKBeZltJXkeRa3rmrzDsaE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20231106075539epcas5p3b7b48b19d7968bacebe62918775115b4~U_YwY_dFe2090520905epcas5p3h;
	Mon,  6 Nov 2023 07:55:39 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4SP3Yk1zLXz4x9Q9; Mon,  6 Nov
	2023 07:55:38 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	67.CB.19369.AFB98456; Mon,  6 Nov 2023 16:55:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231106074844epcas5p252beb2aa7925de34aea33d5c64d1d72e~U_StddITd2058820588epcas5p2n;
	Mon,  6 Nov 2023 07:48:44 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231106074844epsmtrp20f47fa419814ea03c209a3b9c4d9dc19~U_StctKF91829318293epsmtrp2c;
	Mon,  6 Nov 2023 07:48:44 +0000 (GMT)
X-AuditID: b6c32a50-9e1ff70000004ba9-ea-65489bfaa706
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.6E.07368.B5A98456; Mon,  6 Nov 2023 16:48:43 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20231106074842epsmtip29fbba4a4dd6ccb175ec68b965e03fa4b~U_SsQtdsB1909319093epsmtip2Z;
	Mon,  6 Nov 2023 07:48:42 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	Xiaobing Li <xiaobing.li@samsung.com>
Subject: [PATCH] IO_URING: Statistics of the true utilization of sq threads.
Date: Mon,  6 Nov 2023 15:40:55 +0800
Message-Id: <20231106074055.1248629-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmlu6v2R6pBt0dXBZzVm1jtFh9t5/N
	4l3rORaLo//fsln86r7LaLH1y1dWi8u75rBZPNvLafHl8Hd2i6lbdjBZdLRcZnTg9tg56y67
	x+WzpR59W1YxenzeJBfAEpVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0k5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0
	L10vL7XEytDAwMgUqDAhO2PN2mOsBS2CFR+7VzM2MB7l7WLk5JAQMJGYf30eSxcjF4eQwB5G
	iTMHN7FDOJ8YJdZ0r2GCcL4xSqz+38sK0/L9UgNU1V5GiW9HXjFDOC8ZJXYsO8oCUsUmoC1x
	fV0XWIcIkP368VSwJcwCn4Hm3v4GViQs4CNxb/k3dhCbRUBVYv2PfWwgNq+AnUT/lBmMEOvk
	JfYfPMsMEReUODnzCVgvM1C8eetsZoial+wSz3/JQtguEj+btjJB2MISr45vYYewpSQ+v9vL
	BmEXSxzp+c4KcpCEQAOjxPTbV6GKrCX+XdkDtIADaIGmxPpd+hBhWYmpp9YxQezlk+j9/QRq
	Pq/EjnkwtqrE6ksPWSBsaYnXDb+h4h4S5y7sYAYZKSQQK7Hibf0ERvlZSL6ZheSbWQiLFzAy
	r2KUSi0ozk1PTTYtMNTNSy2HR21yfu4mRnDi1ArYwbh6w1+9Q4xMHIyHGCU4mJVEeP/ae6QK
	8aYkVlalFuXHF5XmpBYfYjQFhvFEZinR5Hxg6s4riTc0sTQwMTMzM7E0NjNUEud93To3RUgg
	PbEkNTs1tSC1CKaPiYNTqoFJtvdu/6XbRgHZd5XEXp52v3LQffefleKc9wsydq2VmXB7xZZD
	ot9fGv75slXX2qluvb/vhx8cMnOV/irs0NM9LVPRN9E6de9399lC/+JW2Ol3l5U/cG76W3jO
	eceNiVwLJvwxF/DOfNbB1y5R2iZ03XOS2YvDwupHHmiZvZFkir3j+F3JaPWROQqrDkb8efXc
	/cmswI5ZHG66P6q4zpx6fHFmu0RWXNOqqr13z5nxnY5Uuf3h1tv1K4qOf1jpNJsp91NfA38G
	x6mwvT13L35xL1jD2zFF9E20nOOqedfvTu8xqGJpeyEowr1nuQVH0nLelP/yzG77nBp6OTiv
	GK7d+bPU1OQFe2hg57EOJoGlSizFGYmGWsxFxYkA61MqQCUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSvG70LI9UgyMdFhZzVm1jtFh9t5/N
	4l3rORaLo//fsln86r7LaLH1y1dWi8u75rBZPNvLafHl8Hd2i6lbdjBZdLRcZnTg9tg56y67
	x+WzpR59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVsWbtMdaCFsGKj92rGRsYj/J2MXJySAiY
	SHy/1MDexcjFISSwm1Hi3aGrLF2MHEAJaYk/f8ohaoQlVv57DlXznFHi8OHpjCAJNgFtievr
	ulhB6kUEdCUa7yqA1DAL/GWU+Lp6DhtIjbCAj8S95d/YQWwWAVWJ9T/2gcV5Bewk+qfMYIRY
	IC+x/+BZZoi4oMTJmU9YQGxmoHjz1tnMExj5ZiFJzUKSWsDItIpRMrWgODc9N9mwwDAvtVyv
	ODG3uDQvXS85P3cTIzh8tTR2MN6b/0/vECMTB+MhRgkOZiUR3r/2HqlCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeQ1nzE4REkhPLEnNTk0tSC2CyTJxcEo1MM279DT8qsGF65WTdzr3ZwtOvNmi
	dHvXv3DdyckGL75fzj6gyB9/es6f2UXsLSrKwcaMQWUHnksomZ636Dl2KE3h7605dz9cfRPy
	26Ms3m7xWivOA1Kxv+VfsCgXf8/s+6J4fO2zxze2Z9d+m1STfVPYSy5hWewr+/6OFL6YiL2W
	B9lVbm/kDrmX+eTci+9/H364K/faLq9+9j9N/1X67zqXvv6+xl555rmdN+zr4zMXxPns/2q6
	dO+qZ7FLSxVnsqoxp/MxnPn1cFaJyBzVSzcmleoLJN7JuJtbyMYVpCmacfNl/ZOlgdZnP1ww
	nvtqa6pgtOfWascEZ2XGCK+ZpidMjs8KLVr9xOXAlhLt6+uUWIozEg21mIuKEwGi1af/zgIA
	AA==
X-CMS-MailID: 20231106074844epcas5p252beb2aa7925de34aea33d5c64d1d72e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231106074844epcas5p252beb2aa7925de34aea33d5c64d1d72e
References: <CGME20231106074844epcas5p252beb2aa7925de34aea33d5c64d1d72e@epcas5p2.samsung.com>

Since the sq thread has a while(1) structure, during this process, there
may be a lot of time that is not processing IO but does not exceed the
timeout period, therefore, the sqpoll thread will keep running and will
keep occupying the CPU. Obviously, the CPU is wasted at this time;Our
goal is to count the part of the time that the sqpoll thread actually
processes IO, so as to reflect the part of the CPU it uses to process
IO, which can be used to help improve the actual utilization of the CPU
in the future.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 io_uring/sqpoll.c | 8 ++++++++
 io_uring/sqpoll.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..27b01ad42678 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -224,6 +224,7 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
+	unsigned long long start, begin, end;
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
index 8df37e8c9149..c6b2ecb654fd 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,8 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	unsigned long long work;
+	unsigned long long total;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.34.1


