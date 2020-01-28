Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D093B14B4C2
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 14:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgA1NUZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 08:20:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46375 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgA1NUZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 08:20:25 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200128132023euoutp0260f283eff60255d465af52d0bfd72d8d~uD45ZUWR11868418684euoutp02F
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 13:20:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200128132023euoutp0260f283eff60255d465af52d0bfd72d8d~uD45ZUWR11868418684euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1580217623;
        bh=YQjaE3MTnDd+KhbIU/ti6hTv18/y+fMJHSN1sRL1FMI=;
        h=From:To:CC:Subject:Date:References:From;
        b=ihf2YZVGDhZxlCxYyMrJhWv/vt8U8mWQMz3kzO94TDZO6mAykGl2iyzouQF9QiH3J
         Wcq5ALXvmqC0RJCZeEDhR/UdIIC/t0bSk+0Lf/l6nsttoNj1lttAKp2Pw2oaulHW6i
         YlG/QQ584J3cxo+totVqij4yEpPEed6xGQQMZpN0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200128132023eucas1p2923a45fe543d1c6f23b3b35d25224c0f~uD45RFMb01816518165eucas1p29;
        Tue, 28 Jan 2020 13:20:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 90.78.60698.715303E5; Tue, 28
        Jan 2020 13:20:23 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200128132022eucas1p1e94fc561550c26d2c880282fd9ad9c62~uD44_d3T_0518205182eucas1p1z;
        Tue, 28 Jan 2020 13:20:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200128132022eusmtrp21803f600f032e290daa9ca9d4ea3b14b~uD4494vK22647726477eusmtrp2_;
        Tue, 28 Jan 2020 13:20:22 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-ec-5e30351758e4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 0D.60.08375.615303E5; Tue, 28
        Jan 2020 13:20:22 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200128132022eusmtip2f72c604dfb676f3c9a08b0997d5c39ec~uD440-HND2135321353eusmtip2U;
        Tue, 28 Jan 2020 13:20:22 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
        Server (TLS) id 15.0.1320.4; Tue, 28 Jan 2020 13:20:22 +0000
Received: from debbie.aal.scsc.local (106.110.32.48) by
        CAMSVWEXC02.scsc.local (106.1.227.72) with Microsoft SMTP Server id
        15.0.1320.4 via Frontend Transport; Tue, 28 Jan 2020 13:20:22 +0000
From:   "Simon A. F. Lund" <simon.lund@samsung.com>
To:     <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>
Subject: [PATCH liburing] test/read-write: fixed output, and added 'nonvec',
 when VERBOSE
Date:   Tue, 28 Jan 2020 14:20:05 +0100
Message-ID: <20200128132005.2234-1-simon.lund@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djP87ripgZxBnO2cVisvtvPZvGu9RyL
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBlfNn+jK3gAHvFwcPb2RsYf7J2MXJySAiYSLxZ
        toi9i5GLQ0hgBaPE+22vGSGcL4wSl86dZoJwPjNK/Go/BdeycvpfNhBbSGA5o8TzyUZwRS03
        lrJAOGcYJRoWL2WDcA4zSnw7f5gdpIVNwFBi49S7QAkODhEBUYk5iypBwswCchJLGr6xgISF
        BaIlzq1UBAmzCKhK/N3yAWwZr4CVxInJ3SwQR8hLnO9dxw4RF5Q4OfMJC8QYeYnmrbOZIWwJ
        iYMvXjBD1D9mk3jxtQ7CdpE41/QVKi4s8er4FnYIW0bi/875TBB2tcS6811gv0gIdDBKrPiw
        jBXkNgkBa4m+MzkQNY4Smw/9ZoII80nceCsIsZZPYtK26cwQYV6JjjYhiGo1iR1NWxkhwjIS
        T9coTGBUmoXk/llI7p+F5P4FjMyrGMVTS4tz01OLjfNSy/WKE3OLS/PS9ZLzczcxAtPC6X/H
        v+5g3Pcn6RCjAAejEg+vg5JBnBBrYllxZe4hRgkOZiUR3k4moBBvSmJlVWpRfnxRaU5q8SFG
        aQ4WJXFe40UvY4UE0hNLUrNTUwtSi2CyTBycUg2Mdn3fm2at35FwLvb2TGHfokNH7YL8Xr8+
        bWjo/1rBsEw25JFmwoH3MueEL1eePGytWrEocPr+qv8/lUt+X9IQt2qw4Hnq2Xjvn278s6eZ
        T5/+VVEoutIowZVb3dq/S/j5BYEp050uyZv9iUruXnm16cCNpw+fsHZ181/esGRjO4N4Qmvi
        Su67SizFGYmGWsxFxYkAdRAK+wcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t/xe7pipgZxBs879C1W3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJz
        MstSi/TtEvQyvmx/xlZwgL3i4OHt7A2MP1m7GDk5JARMJFZO/8sGYgsJLGWUONEUBxGXkfh0
        5SM7hC0s8edaF1ANF1DNR0aJ75f2sEA4Zxglns/ezQzhHGaU+HbnGiNIC5uAocTGqXeBWjg4
        RAREJeYsqgQJMwvISSxp+MYCYgsLREr8an0NtoFFQFXi75YPYFfwClhJnJjczQKxWV7ifO86
        doi4oMTJmU9YIObISzRvnc0MYUtIHHzxgnkCo+AsJGWzkJTNQlK2gJF5FaNIamlxbnpusaFe
        cWJucWleul5yfu4mRmDIbzv2c/MOxksbgw8xCnAwKvHwzlAxiBNiTSwrrsw9xCjBwawkwtvJ
        BBTiTUmsrEotyo8vKs1JLT7EaAr0xERmKdHkfGA85pXEG5oamltYGpobmxubWSiJ83YIHIwR
        EkhPLEnNTk0tSC2C6WPi4JRqYMw0q1srtH9BkXWxX/+hN/pbH3CK/ny09IzQ452fqy9ddYpi
        Nbtk87Z396/90tvzd+VOvK17ZM3BKWs6XGf0eTZuWDJpUqGC2bVzUaxhc2+ervsY/eKi3Iyp
        8d1yC5S2s5m1M/9YeD5jTdr2BdkOu+/dX7n+VthbzeWKlZ2MD8PuqP9lnOX26xmLEktxRqKh
        FnNRcSIAMdOVLo8CAAA=
X-CMS-MailID: 20200128132022eucas1p1e94fc561550c26d2c880282fd9ad9c62
X-Msg-Generator: CA
X-RootMTR: 20200128132022eucas1p1e94fc561550c26d2c880282fd9ad9c62
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200128132022eucas1p1e94fc561550c26d2c880282fd9ad9c62
References: <CGME20200128132022eucas1p1e94fc561550c26d2c880282fd9ad9c62@eucas1p1.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Simon A. F. Lund <simon.lund@samsung.com>
---
 test/read-write.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index face66b..64f8fd5 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -62,9 +62,10 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	static int warned;
 
 #ifdef VERBOSE
-	fprintf(stdout, "%s: start %d/%d/%d/%d/%d: ", __FUNCTION__, write,
+	fprintf(stdout, "%s: start %d/%d/%d/%d/%d/%d: ", __FUNCTION__, write,
 							buffered, sqthread,
-							fixed, mixed_fixed);
+							fixed, mixed_fixed,
+							nonvec);
 #endif
 	if (sqthread && geteuid()) {
 #ifdef VERBOSE
@@ -212,7 +213,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	return 0;
 err:
 #ifdef VERBOSE
-	print("FAILED\n");
+	printf("FAILED\n");
 #endif
 	if (fd != -1)
 		close(fd);
-- 
2.20.1

