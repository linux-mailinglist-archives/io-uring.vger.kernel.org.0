Return-Path: <io-uring+bounces-530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 174E884AE10
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 06:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7EA12841F2
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 05:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017707F462;
	Tue,  6 Feb 2024 05:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lpGA3O99"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A437F464
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 05:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707197008; cv=none; b=HwEd70Oc9yafZFVL9xqe0ZS706yoNx1HRgv+bRI2VcIz5T9CSNn0jl9ZLszlDCoqcL2+AQYwVhdW/djQxK5zl4qtSgUQHUXRrqExlhPMWcMK7aUeRHt98cOtnZNUpp7tqUP+vHm6Lbok8B0/dmputenNnkxxOE+n+tGWz3EZRwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707197008; c=relaxed/simple;
	bh=XEVDMySbdDpTa7WZXu2xzfB91+TIpxSETUySCbAsvnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=hX6PMahFxS7YndcWKjNNepkguj05G7mOVcUfJ4AixC8pXexHo7bZ4AOx/VvfpigJwYPce1OX+mFdrBtBd6NJCusPY4GF9WvHB8sY3NUibxrFdUtUpIAUoQleItTMecFSvjO7qf/GZS3ih7WBOea+vyM3R3HRchMgaBiu8O8Rzq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lpGA3O99; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240206052323epoutp01d2a998573ecf034cfa5057330694d7dc~xLqEUb8In1382813828epoutp01M
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 05:23:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240206052323epoutp01d2a998573ecf034cfa5057330694d7dc~xLqEUb8In1382813828epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707197003;
	bh=Kn3tsS86gqCdQCfwsQ06f3bnfgxMXBGi8UaNIerSgdU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=lpGA3O99uGBhjk3GVF+pEeo+NP8Dva+tLEBDymvx3GJVS/ueKPezuFZ7YYGEaZTq9
	 nWcocNmsHOctYvRipfhpk4euX01vuARehwetYIVaqyRQd5oMAvlftLCfjWvO1qLSSP
	 gdYO8Y6JCL95vslhwXzdywsGSIjURXUgOqhDSeXc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240206052322epcas5p260a68301e617cb91930af55868a348c8~xLqD3vj1u0065900659epcas5p2m;
	Tue,  6 Feb 2024 05:23:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TTWqY3hLDz4x9QJ; Tue,  6 Feb
	2024 05:23:21 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7F.7F.09672.942C1C56; Tue,  6 Feb 2024 14:23:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240206024828epcas5p2119e961d13e6c9fb6ea114c7aca4bf3d~xJi0FZ-Lv2260322603epcas5p2A;
	Tue,  6 Feb 2024 02:48:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240206024828epsmtrp24464ec0c9644b34fedc1f675b1ba02a4~xJi0Edx-Y0157001570epsmtrp2Q;
	Tue,  6 Feb 2024 02:48:28 +0000 (GMT)
X-AuditID: b6c32a4b-60bfd700000025c8-1e-65c1c249f9e9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	52.53.08755.CFD91C56; Tue,  6 Feb 2024 11:48:28 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240206024827epsmtip19d54c9ef7fc2da7a8230047d984226df~xJiyuV4GX2459624596epsmtip1d;
	Tue,  6 Feb 2024 02:48:27 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH] liburing: add script for statistics sqpoll running time
Date: Tue,  6 Feb 2024 10:40:14 +0800
Message-Id: <20240206024014.11412-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmlq7noYOpBv0bpS3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5x
	ia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGj5kLmAveCFWcXdfG2MB4gaeLkZND
	QsBEYv/XtcxdjFwcQgK7GSU+H1rEDuF8YpR4OGUOVOYbo8Sx1qtMMC3/emdCJfYySlyZ8o4V
	wnnJKPFj/TlWkCo2AW2J6+u6wGwRIPv146ksIEXMAkuYJLZ+Oww2SljAQ+LSol52EJtFQFXi
	7Yw+sAZeARuJU0cPsEGsk5fYf/AsM0RcUOLkzCcsIDYzULx562ywMyQEGjkkDt5YA+RwADku
	Eiv/ckH0Cku8Or6FHcKWkvj8bi/UzGKJIz3fWSF6Gxglpt++ClVkLfHvyh4WkDnMApoS63fp
	Q4RlJaaeWscEsZdPovf3E2hQ8ErsmAdjq0qsvvSQBcKWlnjd8Bsq7iHx/mMj2P1CArESb26u
	YJvAKD8LyTuzkLwzC2HzAkbmVYySqQXFuempxaYFxnmp5fCoTc7P3cQITqta3jsYHz34oHeI
	kYmD8RCjBAezkgiv2Y4DqUK8KYmVValF+fFFpTmpxYcYTYFhPJFZSjQ5H5jY80riDU0sDUzM
	zMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYLLMv5FtENT2gDtS+Eqzd0XwuxBe
	Rb7zp0p3GdwKerf/Tke90TOWdv1WdnM7sd9Miz+eOx/yXitJ00l1OffnyTx1N/nyygX0C9+x
	rTvMc8p03aO+tT/+TLsu9+781HRv+QW/7lfFdC/ddeTfBAbDE5PnWmZ+ZdxxT/C07ia2b/mz
	Zs44ve1hykPjyfePSf9e2PujcaZM+Qr2ZYdzkpj1ny3MEK/sYAu3WGpWqOKTGj53iqn5oc9F
	JgGOgjszr8/n5f4U6lRT+63KMsXAbvvkqQ8+CTUud/i1xWPZAt2nNRMr596MK2kRX8B0LVU+
	KWfS5i7flA8hnLJ5vYrp8/uOTX68y0x/n1LcTO97fElCzUosxRmJhlrMRcWJAHPYWmQ0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnO6fuQdTDc4+lLWYs2obo8Xqu/1s
	Fqf/PmaxeNd6jsXi6P+3bBa/uu8yWmz98pXV4vKuOWwWz/ZyWnw5/J3d4uyED6wWU7fsYLLo
	aLnMaNF14RSbA5/Hzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQifbsErowfMxcwF7wR
	qji7ro2xgfECTxcjJ4eEgInEv96ZzF2MXBxCArsZJRZ9f8XYxcgBlJCW+POnHKJGWGLlv+fs
	ILaQwHNGiTu/a0BsNgFtievrulhBykUEdCUa7yqAjGEW2MAksf/pPFaQGmEBD4lLi3rBelkE
	VCXezugDi/MK2EicOnqADWK+vMT+g2eZIeKCEidnPmEBsZmB4s1bZzNPYOSbhSQ1C0lqASPT
	KkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4NDW0tzBuH3VB71DjEwcjIcYJTiYlUR4
	zXYcSBXiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/6iN0VIID2xJDU7NbUgtQgmy8TBKdXAZPV9
	0nfDl3dz3MXNLtjYPtM/8oN9l13JstBHARdKmW1WrXe+yLi4wUTy0BvJj84PK4WLpm58NLUi
	JjPgyx22T6oLvl0LClP6370po9vUNIBRXmy+1NY3Lmv8zLRfnZtW8LLgyErXdys7N61hYf21
	feHCMw9eprWZSfkcnmt7mevhxzrNY3vPl75N5/36WDn63iL+1cWW34waXZ1UbiolcXfHfr4s
	+/ukQ+0q9tJZyYLPJvDcsYjcFyTwi+3b3bsNPpyGfpNf/d0TlrFYRf5jut1cuZUMXkrH8t4o
	lnSvLnu7U/R+UOr+gMtNj+7Y19Ue2f/w8KXkcJWLt9oY1ydWW9ec+tC4xYJ77d+f27vmSCmx
	FGckGmoxFxUnAgAFs39N3AIAAA==
X-CMS-MailID: 20240206024828epcas5p2119e961d13e6c9fb6ea114c7aca4bf3d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240206024828epcas5p2119e961d13e6c9fb6ea114c7aca4bf3d
References: <CGME20240206024828epcas5p2119e961d13e6c9fb6ea114c7aca4bf3d@epcas5p2.samsung.com>

Count the running time and actual IO processing time of the sqpoll
thread, and output the statistical time to terminal.

---
The test results are as follows:
PID             WorkTime(us)    TotalTime(us)   COMMAND
1188923         1528823         1817846         iou-sqp-1188916
1188920         1539703         1833793         iou-sqp-1188917
1188921         1544210         1847887         iou-sqp-1188918
1188922         1561503         1857846         iou-sqp-1188919

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 test/sqtimeshow.sh | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 test/sqtimeshow.sh

diff --git a/test/sqtimeshow.sh b/test/sqtimeshow.sh
new file mode 100644
index 0000000..e85fd2f
--- /dev/null
+++ b/test/sqtimeshow.sh
@@ -0,0 +1,61 @@
+#!/usr/bin/env bash
+
+UPLINE=$(tput cuu1)
+
+function set_header() {
+    printf "\033[47;30m%-15s %-15s %-15s %-15s \033[0m\n" PID WorkTime\(us\) TotalTime\(us\) COMMAND
+}
+
+function get_time() {
+    pid=$1
+    item=$2
+    proc_file="/proc/$pid/fdinfo/6"
+    if [ ! -e $proc_file ]; then
+        return
+    fi
+    content=$(cat ${proc_file} | grep ${item} | awk -F" " '{print $2}')
+    echo ${content%us}
+}
+
+function show_util() {
+    index=0
+    while true
+    do
+        data=$(top -H -b -n 1 | grep iou-sqp)
+        if [ -z "${data}" ]; then
+            echo "no sq thread is running."
+            exit
+        fi 
+        index=0
+        num=$(echo $data | tr -cd R |wc -c)
+        arr=($data)
+        len=$((${#arr[@]} / ${num}))
+        i=0
+        while [ ${i} -lt ${num} ]
+        do
+            pid=${arr[${i} * ${len}]}
+            name=${arr[${i} * ${len} + len - 1]}
+            work_time=$(get_time $pid "SqWorkTime")
+            total_time=$(get_time $pid "SqTotalTime")
+            printf "%-15s %-15s %-15s %-15s\n" ${pid} ${work_time} ${total_time} ${name}
+            ((i++))
+        done
+        sleep 2
+        update=$UPLINE
+        for j in $(seq 1 ${num}); do
+            update=$update$UPLINE
+        done
+        if [ ! -z "$(top -H -b -n 1 | grep iou-sqp)" ]; then
+            echo "$update"
+        fi
+    done
+}
+
+function main() {
+    # set header
+    set_header
+    # show util
+    show_util
+}
+
+main
-- 
2.34.1


