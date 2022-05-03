Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E35518C96
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 20:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbiECSxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 14:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbiECSw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 14:52:59 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9493F8A6
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 11:49:19 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220503184916euoutp02f95ef0d17cf776a6575b241025e8607e~rrN3CVUY01352413524euoutp022
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 18:49:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220503184916euoutp02f95ef0d17cf776a6575b241025e8607e~rrN3CVUY01352413524euoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651603756;
        bh=Fd0Idph3+yCUGerksJR5ASthBc+ItaHVT/eibBKrEkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4XKR5ZlEz2MT99tknlaadIUiOZouVkstMuvp/SjM8zjI/XjeLXPci61KLwSvP5z6
         TS5RaPGWUEAOOEtkX3iPwGkFxe6JLaS1AO8n0dVx+qfsRed240uwElh2bmpy+D5m0v
         vEal6gXhi+odtrJOodAGRYm9Q+sUBhfFZuCFfkjY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220503184915eucas1p2df2a3cce27ad97608880e41ce4ee84e4~rrN14AXf30682506825eucas1p2B;
        Tue,  3 May 2022 18:49:15 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id A4.2E.10009.B2971726; Tue,  3
        May 2022 19:49:15 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220503184914eucas1p1d9df18afe3234c0698a66cdb9c664ddc~rrN1Gx8O_1807018070eucas1p1-;
        Tue,  3 May 2022 18:49:14 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220503184914eusmtrp2223296c032eb9f41fe987a678ff24e7c~rrN1GDZ5N2575425754eusmtrp2T;
        Tue,  3 May 2022 18:49:14 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-95-6271792bb440
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 8A.80.09522.A2971726; Tue,  3
        May 2022 19:49:14 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220503184914eusmtip1369a086dda9e93fdd6c01f68efe410c1~rrN01we-N0995809958eusmtip1D;
        Tue,  3 May 2022 18:49:14 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com
Subject: [PATCH v3 3/5] nvme: refactor nvme_submit_user_cmd()
Date:   Tue,  3 May 2022 20:48:29 +0200
Message-Id: <20220503184831.78705-4-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503184831.78705-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsWy7djPc7ralYVJBm/3iFrMWbWN0WL13X42
        i5sHdjJZrFx9lMniXes5Fovzbw8zWcxf9pTd4saEp4wWhyY3M1lcfXmA3YHLY2LzO3aPnbPu
        sntcPlvqsWlVJ5vH5iX1HrtvNrB5vN93lc2jb8sqRo/Pm+QCOKO4bFJSczLLUov07RK4Ms6s
        ecpYsFGyYvXio8wNjK9Euhg5OSQETCQmn+5h6mLk4hASWMEo8WjGPWYI5wujxORzr1kgnM+M
        EvMaP7F1MXKAtbxaVgQRX84osXT+V1YI5yWjROfarYwgRWwCWhKNnewgK0QE5CW+3F4LNohZ
        YDujxJPZX1hBEsICthJ/rvcygtgsAqoS69c3sYDYvAKWEk++7maDuE9eYual7+wgMzkFrCR2
        zGeGKBGUODnzCVg5M1BJ89bZYFdLCLzgkPi4YxkTRK+LxP2dhxghbGGJV8e3sEPYMhL/d86H
        qqmWeHrjN1RzC6NE/871UF9aS/SdyQExmQU0Jdbv0ocod5R4euQKO0QFn8SNt4IQJ/BJTNo2
        nRkizCvR0SYEUa0ksfPnE6ilEhKXm+awQNgeEv8atjBPYFScheSZWUiemYWwdwEj8ypG8dTS
        4tz01GLDvNRyveLE3OLSvHS95PzcTYzARHX63/FPOxjnvvqod4iRiYPxEKMEB7OSCK/z0oIk
        Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUzW2l0rlWfl
        pXm9vH7JvOD/EcUZtxNu+nz/Oac1+PvtI6tyo7bbLdS6K73w6/fLoR9vvUmav7aYbX79RL7r
        H/Y5R3y5sO7iHcZl8cLVp86uTlJhmKzZN133gOGLQyv0sy2MC725pl3L+P3QLOfCb+vMPvXO
        YHsFronq2nwRa5+eXO/eoLv1UV/i59CUO4/FJixbn+JRIm/HYsVdM9unUHlFyKYNEb7PCzS2
        T3vjOPGvMM/xRuVN8U4mDa/Vt9UqT9Li8fpz+z37nYK3u4SWO5ReuFQycVdBy7zUb8FfdI0W
        X2biuXnoLP/0Z0EXns50ttRdeOPxqQsVVbU7Z9uaXkr4nXlMMevLpgmChc3KGenqSizFGYmG
        WsxFxYkAJbuME8MDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t/xu7palYVJBjMWqljMWbWN0WL13X42
        i5sHdjJZrFx9lMniXes5Fovzbw8zWcxf9pTd4saEp4wWhyY3M1lcfXmA3YHLY2LzO3aPnbPu
        sntcPlvqsWlVJ5vH5iX1HrtvNrB5vN93lc2jb8sqRo/Pm+QCOKP0bIryS0tSFTLyi0tslaIN
        LYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0Ms6secpYsFGyYvXio8wNjK9Euhg5
        OCQETCReLSvqYuTiEBJYyiix9+cb1i5GTqC4hMTthU2MELawxJ9rXWwQRc8ZJSY/PMEC0swm
        oCXR2MkOUiMioCix8SNEPbPAQUaJ3l5mEFtYwFbiz/VesDiLgKrE+vVNLCA2r4ClxJOvu9kg
        5stLzLz0nR1kJKeAlcSO+WCtQkAlbRMXs0OUC0qcnPmEBWK8vETz1tnMExgFZiFJzUKSWsDI
        tIpRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMworYd+7l5B+O8Vx/1DjEycTAeYpTgYFYS4XVe
        WpAkxJuSWFmVWpQfX1Sak1p8iNEU6OyJzFKiyfnAmM4riTc0MzA1NDGzNDC1NDNWEuf1LOhI
        FBJITyxJzU5NLUgtgulj4uCUamDSS/dx/VLx5pmRrPiqk3U3/v054v6c5fOtcg2nE5FPHMPu
        vbjatWCC7NkGzqtzGjML5GMX/PxyZoLjOqf0qbUZ+R3986/Zm2WwL8pVSWiSnVz07qelWN4B
        /9WyIhftDW9PNui4sO71ui7Pam9N5xkX5KdUb0mbtUZBcOuE1edv9q5M2VS9dGHSlk3aXyap
        Tg75/8698L42282PAYbik3+r908MX6VQ1zlh5o8jdlPev4g4r5Kz4KrphANFIdf22JT8ZdXq
        /13oJ35zhmAHz4qOSWlr0xhKXM9c1vhkbBi6KJcrbyE73/a8iviXszSOyUjllp85MEvlfrdQ
        sc6M2v1Tfk7Zez56RYGKivGqJdfDlFiKMxINtZiLihMBb7vMvDEDAAA=
X-CMS-MailID: 20220503184914eucas1p1d9df18afe3234c0698a66cdb9c664ddc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220503184914eucas1p1d9df18afe3234c0698a66cdb9c664ddc
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220503184914eucas1p1d9df18afe3234c0698a66cdb9c664ddc
References: <20220503184831.78705-1-p.raghav@samsung.com>
        <CGME20220503184914eucas1p1d9df18afe3234c0698a66cdb9c664ddc@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Divide the work into two helpers, namely nvme_alloc_user_request and
nvme_execute_user_rq. This is a prep patch, that will help wiring up
uring-cmd support in nvme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 47 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 554566371ffa..3531de8073a6 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -19,6 +19,13 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
+static inline void *nvme_meta_from_bio(struct bio *bio)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	return bip ? bvec_virt(bip->bip_vec) : NULL;
+}
+
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
 {
@@ -53,10 +60,10 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
-static int nvme_submit_user_cmd(struct request_queue *q,
+static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
+		u32 meta_seed, unsigned timeout, bool vec)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -68,7 +75,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 
 	req = blk_mq_alloc_request(q, nvme_req_op(cmd), 0);
 	if (IS_ERR(req))
-		return PTR_ERR(req);
+		return req;
 	nvme_init_request(req, cmd);
 
 	if (timeout)
@@ -108,7 +115,26 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 
+	return req;
+
+out_unmap:
+	if (bio)
+		blk_rq_unmap_user(bio);
+out:
+	blk_mq_free_request(req);
+	return ERR_PTR(ret);
+}
+
+static int nvme_execute_user_rq(struct request *req, void __user *meta_buffer,
+		unsigned meta_len, u64 *result)
+{
+	struct bio *bio = req->bio;
+	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
+	int ret;
+	void *meta = nvme_meta_from_bio(bio);
+
 	ret = nvme_execute_passthru_rq(req);
+
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
 	if (meta && !ret && !write) {
@@ -116,14 +142,25 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			ret = -EFAULT;
 	}
 	kfree(meta);
- out_unmap:
 	if (bio)
 		blk_rq_unmap_user(bio);
- out:
 	blk_mq_free_request(req);
 	return ret;
 }
 
+static int nvme_submit_user_cmd(struct request_queue *q,
+		struct nvme_command *cmd, void __user *ubuffer,
+		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
+		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
+{
+	struct request *req;
+
+	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
+			meta_len, meta_seed, timeout, vec);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	return nvme_execute_user_rq(req, meta_buffer, meta_len, result);
+}
 
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
-- 
2.25.1

