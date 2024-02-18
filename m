Return-Path: <io-uring+bounces-618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B88A98594EC
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 07:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C96D283525
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 06:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B843522A;
	Sun, 18 Feb 2024 06:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pSH6/Tby"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EDA2F50
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 06:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708236013; cv=none; b=TzEtqMmLDPyO6XYvUt1Yw8u4t3MD2sKUHdoothESjtWwDPLWEHnV1FFPyvjh7NxFcFsgyujrHcDSHVu+0QIr52DWt2ukVXbRZ6xXtINsfs1/gda4Y3TwH/UMXSrUbgfA/rd569YwwrV4XXLggPvpLCFk3jZMvVwpiF5jOf0XjiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708236013; c=relaxed/simple;
	bh=amJWEKl10w2be7PZ/y173OKtiDmrAL2EwAaeeRH1lAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LdGrzxg40oSykHeEkEjpnlVLCvs1BTKRHf3/htnIkTB/OATg4Eo2SoLb/trm5X1zZTrsR1AlVcqJQfVtGj2OZe+Um+OsHkvtHq6dyMqgxR8Cd8pnDUAe73bPpvd2CO+4R2yyFUDAOGbNlTHKADlK2Af0xMDMu7yg10aUK/A9N3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pSH6/Tby; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240218060008epoutp04987eab02a92a6a882a6b55eb046e8d1d~035l5RmHd0559705597epoutp04T
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 06:00:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240218060008epoutp04987eab02a92a6a882a6b55eb046e8d1d~035l5RmHd0559705597epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1708236008;
	bh=KAsYtb5y8XLZHK3OBj1ZIgnxXVZpJOPSieE2Qp4j0M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSH6/TbyQ7XQLx0lxJBVo83xDYkC3Fls8dYJUwhAILYOFXYXfgyfleM49Yna4xHbD
	 qC/dTYX76YJskKCc/G9e45i5fGRzKWc/jBgMaBjLyOaivMywn7sd7yw6d+xfkJhSyH
	 rlOhcn0EmIdaqkACfysvSPE+jAoxjjKGyCffu4pw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240218060008epcas5p323291d178502f193e43e343399781c2a~035lin6Ls0952409524epcas5p3n;
	Sun, 18 Feb 2024 06:00:08 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Tcw4R1Kwrz4x9Pw; Sun, 18 Feb
	2024 06:00:07 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	33.39.19369.7EC91D56; Sun, 18 Feb 2024 15:00:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240218055959epcas5p2ac436be88fecd625f072c78ff77610ef~035c6ttXD0050500505epcas5p2j;
	Sun, 18 Feb 2024 05:59:59 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240218055959epsmtrp2aeea7b72184d819801b7614d0ee39f8b~035c227Qj0692806928epsmtrp2l;
	Sun, 18 Feb 2024 05:59:59 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-d1-65d19ce7b519
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AE.23.07368.FDC91D56; Sun, 18 Feb 2024 14:59:59 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240218055957epsmtip2c63341500d2f8969cf275aa4236fd4bd~035bo7yEW0417604176epsmtip23;
	Sun, 18 Feb 2024 05:59:57 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: xiaobing.li@samsung.com
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com
Subject: Re: [PATCH] liburing: add script for statistics sqpoll running
 time.
Date: Sun, 18 Feb 2024 13:59:53 +0800
Message-Id: <20240218055953.38903-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240206024014.11412-1-xiaobing.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmuu7zORdTDdYeYreYs2obo8Xqu/1s
	Fu9az7FYHP3/ls3iV/ddRoutX76yWlzeNYfN4tleTosvh7+zW5yd8IHVYuqWHUwWHS2XGR14
	PHbOusvucflsqUffllWMHp83yQWwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQ
	K07MLS7NS9fLSy2xMjQwMDIFKkzIzrg+6S1TwWL+ipX7bzI2MK7m6mLk4JAQMJG48d2gi5GL
	Q0hgD6PE4yWzWUHiQgKfGCWuRkPEvzFKzPy6AijOCVb/tX8eI0RiL6PEr3enmCCcX4wS7xpP
	s4FUsQloS1xf1wXWISIgLXF9yyawImaBr4wSU35fZQRJCAv4S/S/vQzWwCKgKvH1/31mEJtX
	wEZi/53PbBDr5CX2HzzLDHISp4CtxPFOKYgSQYmTM5+wgNjMQCXNW2czQ5S3ckhcnxcJYbtI
	3PzZxg5hC0u8Or4FypaS+PxuL9T4YokjPd9ZQW6TEGhglJh++ypUkbXEvyt7WED2MgtoSqzf
	pQ8RlpWYemodE8RePone30+YIOK8EjvmwdiqEqsvPWSBsKUlXjf8hop7SDz5cpUZElgTGCUO
	HnrLNoFRYRaSf2Yh+WcWwuoFjMyrGKVSC4pz01OTTQsMdfNSy+GRnJyfu4kRnFa1AnYwrt7w
	V+8QIxMH4yFGCQ5mJRFe96YLqUK8KYmVValF+fFFpTmpxYcYTYEBPpFZSjQ5H5jY80riDU0s
	DUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYPKbvf1Ai3nUfxEWDftf9j2q
	gUVtkRfT3t+5e+xZ0zfLqQvvTn+/R63LqD5B8sMq3otuySq6gp58S4v8jN5tfz9pmv/ie+wq
	/yZeYVvrJZTvNpn7Ds90Vubs+69LIv1tfaWvVXx6+iT7d/DG54JHdzj+0eow2SZ1qX9dUu/G
	p35s319z8+7MUj67Wzrdt6390IHZOWYfNjnd3vH4T9GuDBaNp+plrVK1dwN8PGUFinzX/5r0
	Z2s7x/anvX/f3BLkbVfOXF20bH5Hjq+hp6PrlPylJ/MYT4bor9pV73EwT22n1Y93e6qK821m
	pFZpzNyq1JWdoxPF4Rv1dMrGW4ExuzQmNFVE2cS8W+mVsuh5iRJLcUaioRZzUXEiANeQB5k0
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO79ORdTDbacY7OYs2obo8Xqu/1s
	Fu9az7FYHP3/ls3iV/ddRoutX76yWlzeNYfN4tleTosvh7+zW5yd8IHVYuqWHUwWHS2XGR14
	PHbOusvucflsqUffllWMHp83yQWwRHHZpKTmZJalFunbJXBlXJ/0lqlgMX/Fyv03GRsYV3N1
	MXJySAiYSHztn8fYxcjFISSwm1Fi4d9n7F2MHEAJaYk/f8ohaoQlVv57zg5R84NRYu+Th8wg
	CTYBbYnr67pYQWwRoPrrWzYxgdjMAo1MEqvWhYDYwgK+EmtbfoPFWQRUJb7+vw/WyytgI7H/
	zmc2iAXyEvsPnmUG2cspYCtxvFMKJCwEVDLp5zsWiHJBiZMzn7BAjJeXaN46m3kCo8AsJKlZ
	SFILGJlWMUqmFhTnpucmGxYY5qWW6xUn5haX5qXrJefnbmIEh72Wxg7Ge/P/6R1iZOJgPMQo
	wcGsJMLr3nQhVYg3JbGyKrUoP76oNCe1+BCjNAeLkjiv4YzZKUIC6YklqdmpqQWpRTBZJg5O
	qQYm2+KkDytUPds7ljMGu939lfE5b45shWHwy2l8j6Z6sW5+kLJXwGqhWNe2bf2v3h26eGK7
	TyHPC+56IZ5Y25fGrPtTFqZv+SU3c5O/5fvQy3enVEq2366xPX7pcbgc8/t6bh6BwjuGH5hN
	tm7LMjjEcp+ro6Iv80TZc4NNi22lLNb9+V771P714nY7wb82/+7qyKSErE5y9G18crJDd/np
	bxM/PIpbkXe84GSdo5O4THns3O218v2LDeuVpGuWFN4ujDsYs3eSXaWAGEeu0OOlZX8XFHxT
	y1WfWa7feEgvsiL9VIvuIk3Rx6fe3JNxvhS1JlPE7/SeunVWSywW614vs+E5d2avsJH6HflU
	kUwlluKMREMt5qLiRACLTxcl6gIAAA==
X-CMS-MailID: 20240218055959epcas5p2ac436be88fecd625f072c78ff77610ef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240218055959epcas5p2ac436be88fecd625f072c78ff77610ef
References: <20240206024014.11412-1-xiaobing.li@samsung.com>
	<CGME20240218055959epcas5p2ac436be88fecd625f072c78ff77610ef@epcas5p2.samsung.com>

On 2/6/24 10:40 AM, Xiaobing Li wrote:
>diff --git a/test/sqtimeshow.sh b/test/sqtimeshow.sh
>new file mode 100644
>index 0000000..e85fd2f
>--- /dev/null
>+++ b/test/sqtimeshow.sh
>@@ -0,0 +1,61 @@
>+#!/usr/bin/env bash
>+
>+UPLINE=$(tput cuu1)
>+
>+function set_header() {
>+    printf "\033[47;30m%-15s %-15s %-15s %-15s \033[0m\n" PID WorkTime\(us\) TotalTime\(us\) COMMAND
>+}
>+
>+function get_time() {
>+    pid=$1
>+    item=$2
>+    proc_file="/proc/$pid/fdinfo/6"
>+    if [ ! -e $proc_file ]; then
>+        return
>+    fi
>+    content=$(cat ${proc_file} | grep ${item} | awk -F" " '{print $2}')
>+    echo ${content%us}
>+}
>+
>+function show_util() {
>+    index=0
>+    while true
>+    do
>+        data=$(top -H -b -n 1 | grep iou-sqp)
>+        if [ -z "${data}" ]; then
>+            echo "no sq thread is running."
>+            exit
>+        fi 
>+        index=0
>+        num=$(echo $data | tr -cd R |wc -c)
>+        arr=($data)
>+        len=$((${#arr[@]} / ${num}))
>+        i=0
>+        while [ ${i} -lt ${num} ]
>+        do
>+            pid=${arr[${i} * ${len}]}
>+            name=${arr[${i} * ${len} + len - 1]}
>+            work_time=$(get_time $pid "SqWorkTime")
>+            total_time=$(get_time $pid "SqTotalTime")
>+            printf "%-15s %-15s %-15s %-15s\n" ${pid} ${work_time} ${total_time} ${name}
>+            ((i++))
>+        done
>+        sleep 2
>+        update=$UPLINE
>+        for j in $(seq 1 ${num}); do
>+            update=$update$UPLINE
>+        done
>+        if [ ! -z "$(top -H -b -n 1 | grep iou-sqp)" ]; then
>+            echo "$update"
>+        fi
>+    done
>+}
>+
>+function main() {
>+    # set header
>+    set_header
>+    # show util
>+    show_util
>+}
>+
>+main
 
Hi, Jens and Pavel
This patch is to add a script that displays the statistics of the 
sqpoll thread to the terminal.

--
Xiaobing Li

