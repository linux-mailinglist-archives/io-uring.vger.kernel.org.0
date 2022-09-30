Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449475F050F
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiI3Gnn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiI3Gnc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:43:32 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72E320856D
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:43:27 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220930064326epoutp0461e2ad77a69de393882ddb8396a3c16e~ZkE8HlF3w0755407554epoutp04D
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220930064326epoutp0461e2ad77a69de393882ddb8396a3c16e~ZkE8HlF3w0755407554epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520206;
        bh=ThnCd0QThrZCq2pxruHyWZ5UgpjXQN5hDvf0/hIjKhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWhKp9CV6W5kFAzcwgQlMbDvIFSMOniW336DWQGd8VSpoNpLXgZO1mqnrqaNs3T4C
         xpZEjwADZEnm5hiM6Hm2pPZNtOr70Jp9NBBODUWDYA0UV5iM+36H8zRF9i4HSPPeU9
         kQzHFpgnlYvLbsroie79Lsm8A5PNeznpWWZ481/A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220930064325epcas5p3fb8eefad42a351c401392784ca151c4a~ZkE7pZWjL1801418014epcas5p38;
        Fri, 30 Sep 2022 06:43:25 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mf0zs22bJz4x9Pr; Fri, 30 Sep
        2022 06:43:21 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.A1.56352.90096336; Fri, 30 Sep 2022 15:43:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063811epcas5p43cce58f5e1589c3e3780ce0cfd563986~ZkAXERA8S2578525785epcas5p4B;
        Fri, 30 Sep 2022 06:38:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220930063811epsmtrp151807c3d2d197186d2db4f69bc5d057c~ZkAXDc2av2657326573epsmtrp1M;
        Fri, 30 Sep 2022 06:38:11 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-f5-63369009e006
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.59.14392.3DE86336; Fri, 30 Sep 2022 15:38:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063810epsmtip2562009c1830622fb08678d770eb8253d~ZkAVvBefV1736317363epsmtip2T;
        Fri, 30 Sep 2022 06:38:10 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 03/12] block: add blk_rq_map_user_io
Date:   Fri, 30 Sep 2022 11:57:40 +0530
Message-Id: <20220930062749.152261-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmhi7nBLNkgw/tPBZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYjHp0DVGi723tC3mL3vKbtF9fQebA6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOmL+ij7mgRbhi15Y1jA2MG/m7GDk5JARMJF5fXMbWxcjFISSwm1Hi
        xMS7zCAJIYFPjBKNs6sgEt8YJd4t38II0zH5Uj9Ux15GiWWbljBBdHxmlLjWpg5iswmoSxx5
        3grWICJgJLH/00lWkAZmgU2MEr+uHwNrEBZwlFj2uB2siEVAVaLt1Dcwm1fASmLdhC1MENvk
        JWZe+s7excjBwSlgLdG8KAeiRFDi5MwnLCA2M1BJ89bZzCDzJQR+skv8eXuWHaLXRaK9sQlq
        jrDEq+NboOJSEi/726DsdIkfl59C1RRINB/bB/WlvUTrqX5mkL3MApoS63fpQ4RlJaaeWscE
        sZdPovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPiQknd7BCAq6PUeLPrmfMExgVZiH5ZxaS
        f2YhrF7AyLyKUTK1oDg3PbXYtMA4L7UcHsnJ+bmbGMGpVMt7B+OjBx/0DjEycTAeYpTgYFYS
        4RUvME0W4k1JrKxKLcqPLyrNSS0+xGgKDO+JzFKiyfnAZJ5XEm9oYmlgYmZmZmJpbGaoJM67
        eIZWspBAemJJanZqakFqEUwfEwenVAOT6V0O93qrgOjtJ7meWbbUvE82d5NcumXuLrEFD/5c
        /mpd5/NSRGi618eVj+eVvFJ7E7ZONWpB/uyAyTNcjgbZHmfTaVtZPeXJ7tIVUceiRDoro8SU
        GH4v+PCTcek2yV95IumTY89Zdd1LL1W4usRhevzp6s2+LMLzfW7tfN3ptYtbhH+d4Vv5hzci
        o36Zzq9wv+Z6NWPTL/eit019ASJXlLS85I2X9z7NZrMQ+WI4p/vl6RPl0/LK5vAYzD8uLPi+
        x+v2jzVur8O2L3Srb/xmaZYeNokn5F7KN6XDFxrda+9XvZPr8L2/86ugq0lY+b/J5zeYKiRU
        7DN3zr08UXGt4mrj2G/dc/n2md+2fPpaiaU4I9FQi7moOBEADdjRCC4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO7lPrNkg0f31S2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MqYv6KPuaBFuGLXljWMDYwb+bsYOTkkBEwk
        Jl/qZwOxhQR2M0o03qqCiEtInHq5jBHCFpZY+e85excjF1DNR0aJy+fvsYIk2ATUJY48bwUr
        EhEwk1h6eA0LSBGzwA5GiXXPFoMlhAUcJZY9bgezWQRUJdpOfQOzeQWsJNZN2MIEsUFeYual
        70AbODg4BawlmhflQBxkJfF5z3t2iHJBiZMzn7CA2MxA5c1bZzNPYBSYhSQ1C0lqASPTKkbJ
        1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4GDX0tzBuH3VB71DjEwcjIcYJTiYlUR4xQtM
        k4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgclsiwLxx
        6/VHmcaH9irp7Cl5Zf1pfszUhuSDnVu7CzZlbff9Z5R60zVd+Csbf8GpHzznrpnWalm9//z5
        2dukpJ8lAgYmKyob6mdnblOTmTT17B3tgw1q1XnnHlzulNn53mXH9Y0y14uNsq2rmr++Mli3
        oNBFzc6iwH0jx76NOmmnX/G4ilm3XAgKEpif1nPQPFHja02o66Eqnf239k7mfZw/h7NrbYTW
        4wVtB/ZsX3/0t8u7TPOXTmF2806l+L6IFUxp/sF9wvC/OtNlE6+kI/nxb1LlNdvfLT/x8saH
        Kn1fnpcLNNir+8XD9rtdvzrnr0/xhM7WrLaZ+/7ybLtstHfqqS2G4lIbtdd3lDEUK7EUZyQa
        ajEXFScCAPwvTmjlAgAA
X-CMS-MailID: 20220930063811epcas5p43cce58f5e1589c3e3780ce0cfd563986
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063811epcas5p43cce58f5e1589c3e3780ce0cfd563986
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063811epcas5p43cce58f5e1589c3e3780ce0cfd563986@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a helper blk_rq_map_user_io for mapping of vectored as well as
non-vectored requests. This will help in saving dupilcation of code at few
places in scsi and nvme.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c        | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7693f8e3c454..0e37bbedd46c 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -611,6 +611,42 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
+int blk_rq_map_user_io(struct request *req, struct rq_map_data *map_data,
+		void __user *ubuf, unsigned long buf_len, gfp_t gfp_mask,
+		bool vec, int iov_count, bool check_iter_count, int rw)
+{
+	int ret = 0;
+
+	if (vec) {
+		struct iovec fast_iov[UIO_FASTIOV];
+		struct iovec *iov = fast_iov;
+		struct iov_iter iter;
+
+		ret = import_iovec(rw, ubuf, iov_count ? iov_count : buf_len,
+				UIO_FASTIOV, &iov, &iter);
+		if (ret < 0)
+			return ret;
+
+		if (iov_count) {
+			/* SG_IO howto says that the shorter of the two wins */
+			iov_iter_truncate(&iter, buf_len);
+			if (check_iter_count && !iov_iter_count(&iter)) {
+				kfree(iov);
+				return -EINVAL;
+			}
+		}
+
+		ret = blk_rq_map_user_iov(req->q, req, map_data, &iter,
+				gfp_mask);
+		kfree(iov);
+	} else if (buf_len) {
+		ret = blk_rq_map_user(req->q, req, map_data, ubuf, buf_len,
+				gfp_mask);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(blk_rq_map_user_io);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 50811d0fb143..ba18e9bdb799 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -985,6 +985,8 @@ struct rq_map_data {
 
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
+int blk_rq_map_user_io(struct request *, struct rq_map_data *,
+		void __user *, unsigned long, gfp_t, bool, int, bool, int);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
 		struct rq_map_data *, const struct iov_iter *, gfp_t);
 int blk_rq_unmap_user(struct bio *);
-- 
2.25.1

