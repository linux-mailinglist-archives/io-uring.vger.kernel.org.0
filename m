Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F89D47B8B9
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhLUC5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:57:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47149 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhLUC5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:57:08 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211221025704epoutp0312382db7d83ee745d14aa30352d6acc1~CpbgU3A153071930719epoutp031
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:57:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211221025704epoutp0312382db7d83ee745d14aa30352d6acc1~CpbgU3A153071930719epoutp031
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055424;
        bh=5/JeJfIydkPK+f5DVvzf7D85rmek1HpmQwDhHQuwAww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3ulblZ4nW+TtDoj/USdpslunGTVcqD/FhJrJ2+qKdxYluGNw10cPMQmyrvrMMPk1
         CXhPoB7GvXVjQ0CydNQSRoSF/Yb76AKSlI4kAnYskgUqDZVN42YJLOCf4f+75G4Fqa
         q4MGmgS6e9YiPytYXs9MVJUcxQK23YvhBUH2Denc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20211221025703epcas5p3f754819ad6043991093990f2eaaeec67~Cpbfw6_tP2323723237epcas5p3K;
        Tue, 21 Dec 2021 02:57:03 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4JJ1MG10D3z4x9Pp; Tue, 21 Dec
        2021 02:56:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.76.06423.67241C16; Tue, 21 Dec 2021 11:56:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142248epcas5p1e5904e10396f8cdea54bbd8d7aeca9a6~CfI8YXvcb2842328423epcas5p1v;
        Mon, 20 Dec 2021 14:22:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211220142248epsmtrp23a7411e80d9989d0aa94a47322086fd0~CfI8XkkyS1266312663epsmtrp28;
        Mon, 20 Dec 2021 14:22:48 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-b7-61c1427689c5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.65.08738.8B190C16; Mon, 20 Dec 2021 23:22:48 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142246epsmtip1002c69610ffbf8c65bb9b40f9d65a84f~CfI63Hcf80040400404epsmtip1j;
        Mon, 20 Dec 2021 14:22:46 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 10/13] block: factor out helper for bio allocation from cache
Date:   Mon, 20 Dec 2021 19:47:31 +0530
Message-Id: <20211220141734.12206-11-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmhm6Z08FEg4VT9SyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfFh/jmWgpOSFdt/PWdpYLwt0sXIySEh
        YCKx/u0sti5GLg4hgd2MEjsb7rJCOJ8YJfav/coO4XxmlLh3+AU7TMvK138ZQWwhgV1AiStl
        cEVbdu8GSnBwsAloSlyYXApSIyIQLXHh+TU2EJtZoANoRbctiC0s4C1xv+M0E0g5i4CqROcd
        YZAwr4ClxMV5v9ggVslLzLz0HWwtJ1D88OxlbBA1ghInZz5hgRgpL9G8dTYzyAkSAhM5JLZv
        f8gKMlNCwEXizI4kiDnCEq+Ob4E6X0ri87u9UPOLJX7dOQrVC3Ta9YaZLBAJe4mLe/6C3cYM
        9Mr6XfoQYVmJqafWMUHs5ZPo/f2ECSLOK7FjHoytKHFv0lNWCFtc4uGMJVC2h8SB5U+g4dnD
        KDHnwXW2CYwKs5D8MwvJP7MQVi9gZF7FKJlaUJybnlpsWmCYl1oOj+Pk/NxNjOA0q+W5g/Hu
        gw96hxiZOBgPMUpwMCuJ8G6ZvT9RiDclsbIqtSg/vqg0J7X4EKMpMLwnMkuJJucDE31eSbyh
        iaWBiZmZmYmlsZmhkjjv6fQNiUIC6YklqdmpqQWpRTB9TBycUg1MSqwvrzyxa3p+L+Nab5Hj
        2de7X7O5TtflrW+p5Nxj+fTkWfnIqSqiyguPbz1/51PHAi/Vnrv/++qS1WTuF7syLjvYkOGT
        fed1pYVR6Le02TvVfTss+HNMCjeHbK+/KzHzuJKneX9aQlqgjerfzXOs/748804qjOXOklnJ
        wXOjmwIKLhQk1xSGLPVhD+y8OG3Dh+nts9jr3oQFt62oPnTj/dt9S6dt3aaelGFYENA2+QbD
        NcVE9ZiSjtaVhUdv21W8ybXVf99RuqLp7qK4NXq/hKeZbc45myG/Nes7n2vBmd/nGZS0Dr98
        4RK3+Ip+w2fOK2bHkq6+L4psM1qk4z+jimHy1DXzF/gkSbBxTq1TYinOSDTUYi4qTgQAuP9x
        FjwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnO6OiQcSDQ4u57FomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr48P8cywFJyUr
        tv96ztLAeFuki5GTQ0LARGLl67+MXYxcHEICOxglLm69zgyREJdovvaDHcIWllj57zk7RNFH
        RomDXxqBOjg42AQ0JS5MLgWpERGIlfjw6xgTSA2zwCRGiQ39D8CahQW8Je53nGYCqWcRUJXo
        vCMMEuYVsJS4OO8XG8R8eYmZl76DlXMCxQ/PXgYWFxKwkDjx4QsLRL2gxMmZT8BsZqD65q2z
        mScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwLGhp7WDcs+qD
        3iFGJg7GQ4wSHMxKIrxbZu9PFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZq
        akFqEUyWiYNTqoFJY/fNU5ctNkf/W7r6qtK5yxYZqQuMRHiTP61VvTTr/NHuq6au0/a31JS7
        tLQe8Y1mCHg7IyPXxJTJV9owam/LD742tV+rmE/Yfmb64yFcc3TeJDFugavnGB0dbs9Z9Xey
        RX7aydfSizYEbjd42ap+7OK3alZjkdQpRsocIQcXCBd+uHS02P6dCO+eL58XzWDPkLgRME28
        c9Lt62ExztsVYsWSLcs+5/VFHrvRteGw4/VXb5cxfrto0PUu0WSj+H8WgZNznLPXT175oW7P
        th0bWNtYiuZ8j5OJ5T7458GHbzrr1mToSmbeqGU6YbOown/z9xtzl7/jClnz7dw5Me7grN2u
        zV+/PgnszFkZP+ntCSWW4oxEQy3mouJEAGwjypH0AgAA
X-CMS-MailID: 20211220142248epcas5p1e5904e10396f8cdea54bbd8d7aeca9a6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142248epcas5p1e5904e10396f8cdea54bbd8d7aeca9a6
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142248epcas5p1e5904e10396f8cdea54bbd8d7aeca9a6@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Factor the code to pull out bio_from_cache helper which is not tied to
kiocb. This is prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio.c         | 43 ++++++++++++++++++++++++++-----------------
 include/linux/bio.h |  1 +
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6fadc977cd7f..46d0f278d3aa 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1682,27 +1682,12 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
-/**
- * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
- * @kiocb:	kiocb describing the IO
- * @nr_vecs:	number of iovecs to pre-allocate
- * @bs:		bio_set to allocate from
- *
- * Description:
- *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
- *    used to check if we should dip into the per-cpu bio_set allocation
- *    cache. The allocation uses GFP_KERNEL internally. On return, the
- *    bio is marked BIO_PERCPU_CACHEABLE, and the final put of the bio
- *    MUST be done from process context, not hard/soft IRQ.
- *
- */
-struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
-			    struct bio_set *bs)
+struct bio *bio_from_cache(unsigned short nr_vecs, struct bio_set *bs)
 {
 	struct bio_alloc_cache *cache;
 	struct bio *bio;
 
-	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
+	if (nr_vecs > BIO_INLINE_VECS)
 		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
 
 	cache = per_cpu_ptr(bs->cache, get_cpu());
@@ -1721,6 +1706,30 @@ struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
 	bio_set_flag(bio, BIO_PERCPU_CACHE);
 	return bio;
 }
+EXPORT_SYMBOL_GPL(bio_from_cache);
+
+/**
+ * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
+ * @kiocb:	kiocb describing the IO
+ * @nr_vecs:	number of iovecs to pre-allocate
+ * @bs:		bio_set to allocate from
+ *
+ * Description:
+ *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
+ *    used to check if we should dip into the per-cpu bio_set allocation
+ *    cache. The allocation uses GFP_KERNEL internally. On return, the
+ *    bio is marked BIO_PERCPU_CACHEABLE, and the final put of the bio
+ *    MUST be done from process context, not hard/soft IRQ.
+ *
+ */
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
+			    struct bio_set *bs)
+{
+	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE))
+		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
+
+	return bio_from_cache(nr_vecs, bs);
+}
 EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
 
 static int __init init_bio(void)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fe6bdfbbef66..77eceb2bda4b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -358,6 +358,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp, unsigned short nr_iovecs,
 		struct bio_set *bs);
 struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
 		struct bio_set *bs);
+struct bio *bio_from_cache(unsigned short nr_vecs, struct bio_set *bs);
 struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
-- 
2.25.1

