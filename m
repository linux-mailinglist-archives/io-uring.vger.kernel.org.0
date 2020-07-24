Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFEF22CAED
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGXQXa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:23:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16906 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgGXQX3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:23:29 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200724162326epoutp04c0d54767bc7fe6fb22c67fbda0307f80~kvNi4G56v3120231202epoutp04w
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:23:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200724162326epoutp04c0d54767bc7fe6fb22c67fbda0307f80~kvNi4G56v3120231202epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607807;
        bh=xc9JvOoe3FCec3K3v2rO1C6IyF+36UYIKKZhwsGDQp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBaQ8Jv7PYoipwAbpdSUV9hxaxSXI77ickTNAEtwsfFeB8jY6Y6kC2KSrsdKp0xUt
         igKQQdVj7GTj/xQqqmm4QM70WzofNXc49+gJreE181cz3wHU93coyNXcbQkg3Nwr7F
         4e7Yc7ODESQq8oOCYmcDInh3sLL1qbq3E7rACuN8=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200724162326epcas5p20a8f7970a6a546d0acce3eabd72f4cdf~kvNiU3JHw2787827878epcas5p2z;
        Fri, 24 Jul 2020 16:23:26 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.7B.09475.EFA0B1F5; Sat, 25 Jul 2020 01:23:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200724155329epcas5p345ba6bad0b8fe18056bb4bcd26c10019~kuzYsjVlr1405014050epcas5p3t;
        Fri, 24 Jul 2020 15:53:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724155329epsmtrp218904c25aa29bb8887fb44f9bbf1ec15~kuzYo8gB92867528675epsmtrp2V;
        Fri, 24 Jul 2020 15:53:29 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-a1-5f1b0afefb39
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.02.08382.9F30B1F5; Sat, 25 Jul 2020 00:53:29 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155326epsmtip1a5c04dab3e98b550817addc8dc8141c6~kuzWCzzyY0434704347epsmtip17;
        Fri, 24 Jul 2020 15:53:26 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, SelvaKumar S <selvakuma.s1@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v4 3/6] uio: return status with iov truncation
Date:   Fri, 24 Jul 2020 21:19:19 +0530
Message-Id: <1595605762-17010-4-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsWy7bCmpu4/Lul4gzNXBS1+T5/CajFn1TZG
        i9V3+9ksuv5tYbFobf/GZHF6wiImi3et51gsHt/5zG5x9P9bNosp05oYLTZ/72Cz2HtL22LP
        3pMsFpd3zWGz2PZ7PrPFlSmLmC1e/zjJZnH+73FWi98/5rA5CHvsnHWX3WPzCi2Py2dLPTZ9
        msTu0bdlFaPH501yHu0Hupk8Nj15yxTAEcVlk5Kak1mWWqRvl8CV8exzN0vBV66KyR+3MTYw
        fuLoYuTkkBAwkXi5+jdjFyMXh5DAbkaJyU/PsUI4nxgl1j+7zAbhfGOUeLPjGhNMy7LrU6Fa
        9jJKrN78kQXC+cwoceLseqAWDg42AU2JC5NLQUwRARuJnUtUQEqYBZYzS0zo+MEKMkhYwE7i
        9qwZbCA2i4CqxJavzewgNq+As8SNKf2sEMvkJG6e62QGsTkFXCQuXLzLCBHfwiExf1YQhO0i
        sfbjT2YIW1ji1fEt7BC2lMTnd3vZIOxiiV93jjKDHCEh0MEocb1hJgtEwl7i4p6/TCCHMgPd
        vH6XPkRYVmLqqXVgDzML8En0/n4C9TyvxI55MLaixL1JT6HuFJd4OGMJlO0h8X7NU2jITWeU
        6PxxlnUCo9wshBULGBlXMUqmFhTnpqcWmxYY56WW6xUn5haX5qXrJefnbmIEpygt7x2Mjx58
        0DvEyMTBeIhRgoNZSYR3xTepeCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Sj/OxAkJpCeWpGan
        phakFsFkmTg4pRqYYtQ4b/2J74hZvS4+3iRtktpMTr7mLwcbFG/OKatptTdweHn7w73oNfqL
        dt/59TTYS0E+T1Aj7brcSd1VTyf9rDguVGZSZHrTvojhleaMSTkX2edO7zqRkSctsGqX+PPH
        y69x+eu0fZuz8tj3snVrz303FsryvG+lLbTjiYPNCRYGI3vZ00wPd2yZN/mCyoqSI4o3kxc+
        n3HY5Gq0jPT87o+yDDtWbLOeW1/C65P/SiDT3sJTqax9yq+pLF8eLnnhmGVduPqEbhhzfnj+
        BJYFfglnOJ5aL/A6ftfyxPybogten3mfd9HA/NSe+26zmec3WS3fu/T01Ni1r+eIpIVWyUQJ
        TxUw/Cf2RK4mhN9GT4mlOCPRUIu5qDgRAIoeLQXAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSnO5PZul4g0UvuC1+T5/CajFn1TZG
        i9V3+9ksuv5tYbFobf/GZHF6wiImi3et51gsHt/5zG5x9P9bNosp05oYLTZ/72Cz2HtL22LP
        3pMsFpd3zWGz2PZ7PrPFlSmLmC1e/zjJZnH+73FWi98/5rA5CHvsnHWX3WPzCi2Py2dLPTZ9
        msTu0bdlFaPH501yHu0Hupk8Nj15yxTAEcVlk5Kak1mWWqRvl8CV8exzN0vBV66KyR+3MTYw
        fuLoYuTkkBAwkVh2fSpjFyMXh5DAbkaJqVNXMkIkxCWar/1gh7CFJVb+e84OUfQRqOjdHKAi
        Dg42AU2JC5NLQWpEBBwkuo4/ZgKpYRbYziwx8+hcVpCEsICdxO1ZM9hAbBYBVYktX5vBhvIK
        OEvcmNLPCrFATuLmuU5mEJtTwEXiwsW7YPOFgGou/iifwMi3gJFhFaNkakFxbnpusWGBYV5q
        uV5xYm5xaV66XnJ+7iZGcBRoae5g3L7qg94hRiYOxkOMEhzMSiK8K75JxQvxpiRWVqUW5ccX
        leakFh9ilOZgURLnvVG4ME5IID2xJDU7NbUgtQgmy8TBKdXAtHaSecW85y8um2yRMzLV3fPZ
        om6NT1/3Ir8N9/sa9wsU9vr8LG+Ob+/ru/l3oUH8nV3J+Y13POXdr+XuOxWhwfHchKGA31Ly
        m2rZzPdTz9uEy/4TiXksyxbauszj6qZ1k3e77/TZvZv9yYtDCz9tefnOYZP67zUvEusEDnQv
        MP/5mXsnjzb3pyxnng3Oy5TrTR7zrOqvsZgSy3vq38z/3Gu8ZN3ZD/+vZGW4m1pU/WJpMOdk
        2VfS7nr5Z9vjlKuMBLbqRy7eVPVbquxeI1+72s97DbMDK+6fTjycF7nm6exu018Ge60iNPvu
        xj0L8p00Pdc4s1qbcVt1mPb8s29nm7EcWjZX+v+v4I3pR/d9VWIpzkg01GIuKk4EAK7A5s/x
        AgAA
X-CMS-MailID: 20200724155329epcas5p345ba6bad0b8fe18056bb4bcd26c10019
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155329epcas5p345ba6bad0b8fe18056bb4bcd26c10019
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
        <CGME20200724155329epcas5p345ba6bad0b8fe18056bb4bcd26c10019@epcas5p3.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: SelvaKumar S <selvakuma.s1@samsung.com>

Make iov_iter_truncate to report whether it actually truncated.
This helps callers which want to process the iov_iter in its entirety.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 include/linux/uio.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 9576fd8..c681a60 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -241,7 +241,7 @@ static inline size_t iov_iter_count(const struct iov_iter *i)
  * greater than the amount of data in iov_iter is fine - it'll just do
  * nothing in that case.
  */
-static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
+static inline bool iov_iter_truncate(struct iov_iter *i, u64 count)
 {
 	/*
 	 * count doesn't have to fit in size_t - comparison extends both
@@ -249,8 +249,11 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count)
+	if (i->count > count) {
 		i->count = count;
+		return true;
+	}
+	return false;
 }
 
 /*
-- 
2.7.4

