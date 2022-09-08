Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B582F5B2616
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiIHSpn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiIHSpk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:45:40 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A758804BF
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:45:36 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220908184534epoutp03aa082331fafd8afef012a6b3ebcd22e6~S9vKMilm50611306113epoutp03T
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 18:45:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220908184534epoutp03aa082331fafd8afef012a6b3ebcd22e6~S9vKMilm50611306113epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662662734;
        bh=2CAPPezBpRudgC2/iVSQKO5OZC1ekpekq3vqFH1gTUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRaGXvV45FpQVrP7zNqxAJYXr3a8ChF3Jlp/tKwbQtf7QJ45u2OcGVaZKnwsgvp89
         auJgXmA+NjYfmHank2sgT3xbnJspL7uCviPDZX2n81f9d52gG9mCHS2rLd3utaSiRL
         NLwY8IVkHh9XZiytk7DTEjFqCaiiTy3L+vspmw2w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220908184533epcas5p42a5b682da9ae518321d181d89bca18d4~S9vJQozPw1434814348epcas5p4z;
        Thu,  8 Sep 2022 18:45:33 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MNp3G65Sqz4x9Pq; Thu,  8 Sep
        2022 18:45:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.49.54060.A483A136; Fri,  9 Sep 2022 03:45:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220908184530epcas5p44d67b682ee86fabbb3f3912e8fde332b~S9vGgtBJn0530505305epcas5p4l;
        Thu,  8 Sep 2022 18:45:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908184530epsmtrp17dfdb0d12ee939ecaccfc477c79c1801~S9vGf7pel3080730807epsmtrp1b;
        Thu,  8 Sep 2022 18:45:30 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-ce-631a384ac589
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        24.DD.14392.9483A136; Fri,  9 Sep 2022 03:45:29 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184528epsmtip25070875fc57a0e6c730b79be13990e6d~S9vFDM6w41574515745epsmtip2S;
        Thu,  8 Sep 2022 18:45:28 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v6 1/5] io_uring: add io_uring_cmd_import_fixed
Date:   Fri,  9 Sep 2022 00:05:07 +0530
Message-Id: <20220908183511.2253-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908183511.2253-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmuq6XhVSywf4eA4umCX+ZLeas2sZo
        sfpuP5vFzQM7mSxWrj7KZPGu9RyLxdH/b9ksJh26xmix95a2xfxlT9kduDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObRt2UVo8fnTXIB7FHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
        uoaWFuZKCnmJuam2Si4+AbpumTlAxykplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1Jy
        CkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjO237zBXrBYqGLywvWsDYzT+bsYOTkkBEwk/k75
        y9jFyMUhJLCbUWLh989sEM4nRomTWz4wQTjfGCVuX5jDBtPSeX0DVMteRomfR3pZIZzPjBId
        07YAORwcbAKaEhcml4I0iAh4Sdy//R6shhlkx9sbjewgCWEBD4k5n06zgNgsAqoST9r3gMV5
        BcwlHtzfzQ6xTV5i5qXvYDangIXExS8P2SBqBCVOznwC1ssMVNO8dTYzyAIJgVYOiS8f70M1
        u0hsWfeACcIWlnh1fAtUXEriZX8blJ0scWnmOaiaEonHew5C2fYSraf6mUGeYQZ6Zv0ufYhd
        fBK9v58wgYQlBHglOtqEIKoVJe5NesoKYYtLPJyxBMr2kLh3fC00FLsZJRZdn8s0gVF+FpIX
        ZiF5YRbCtgWMzKsYJVMLinPTU4tNC4zzUsvhMZucn7uJEZxItbx3MD568EHvECMTB+MhRgkO
        ZiURXtG1EslCvCmJlVWpRfnxRaU5qcWHGE2BYTyRWUo0OR+YyvNK4g1NLA1MzMzMTCyNzQyV
        xHmnaDMmCwmkJ5akZqemFqQWwfQxcXBKNTBtO3fzw4EZfJ266yacVtE+d8F/2S5h2V9c+p2B
        86Z+OZdw60NK6fcCPYUKnuatoZw3cwv8twtz7ZddGbmifrfJizfMwel1Sh2XY3SfW+TePKoq
        O+fjzpfhRYt/39/Vtm/n+9/9fz4qPjkruyRRLDcx73jIB9Nde7zf8B7j4i5n+9yra/bir/f8
        c3eXXfg9PyblsUL+LQ3jQtHlX5oOHJq8w3pfO4PztLx4/pA/PNGpTT3Gj/+sNFv44KBEUJzQ
        x0mtE959qvu91tA6ZIX85k/m3N43jkh+Or89ZTrTU8G0ricOu2foCnZO2lp0InkLh4WQdlz9
        2dDNRb+aor4zs+5K/muYu3HvPGXVMxfy6pP8lViKMxINtZiLihMBa+wHry0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvK6nhVSyQd8HG4umCX+ZLeas2sZo
        sfpuP5vFzQM7mSxWrj7KZPGu9RyLxdH/b9ksJh26xmix95a2xfxlT9kduDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGdtv3mAvWCxUMXnhetYG
        xun8XYycHBICJhKd1zcwdjFycQgJ7GaUOLztCitEQlyi+doPdghbWGLlv+fsEEUfGSWmrlsG
        5HBwsAloSlyYXApSIyIQIHGw8TJYDbPAQUaJy8+esIAkhAU8JOZ8Og1mswioSjxp3wM2lFfA
        XOLB/d1QC+QlZl76DmZzClhIXPzykA3EFgKqufZnOjNEvaDEyZkQM5mB6pu3zmaewCgwC0lq
        FpLUAkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwTGgpbmDcfuqD3qHGJk4GA8x
        SnAwK4nwiq6VSBbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomD
        U6qByTVexPeGvn2jsf1aG7FPUTb8X/I0OHUO++V9v+WjH8xaoyKTbvk8VlrgaFLD++X2E69s
        uWLw03tTAJfMi9+aPS8X9wr6pngcWOBRN9snpX+W8PmONW83Wp0KO/+1X37ytbmdR6w8smZ9
        PbfMYcPZy6zbTR4EsxtzWYfus3oce/DG+i+9j8MqFykocBf/cU66fNY2tVWcWcn3+9JMk4th
        Os0f8k4l/RHZ6XXFZ+Zn311eq1snZG9KLbvff0eVY/2tk1tlN139HJT2LIhr0+Mle+N39V3Q
        m5km+P1BxvNtjPzOzHVR0ts0Gj1XJvXs9sl2dFU62PL1SB4DN2ulT25Jy7aZuqYOH5fPud4h
        5nBbiaU4I9FQi7moOBEAWyGDxPACAAA=
X-CMS-MailID: 20220908184530epcas5p44d67b682ee86fabbb3f3912e8fde332b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220908184530epcas5p44d67b682ee86fabbb3f3912e8fde332b
References: <20220908183511.2253-1-joshi.k@samsung.com>
        <CGME20220908184530epcas5p44d67b682ee86fabbb3f3912e8fde332b@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

This is a new helper that callers can use to obtain a bvec iterator for
the previously mapped buffer. This is preparatory work to enable
fixed-buffer support for io_uring_cmd.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h |  8 ++++++++
 io_uring/uring_cmd.c     | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 58676c0a398f..202d90bc2c88 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/xarray.h>
+#include <uapi/linux/io_uring.h>
 
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
@@ -32,6 +33,8 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *));
@@ -59,6 +62,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd)
+{
+	return -EOPNOTSUPP;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f3ed61e9bd0f..6a6d69523d75 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -8,6 +8,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "rsrc.h"
 #include "uring_cmd.h"
 
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
@@ -129,3 +130,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
+
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_import_fixed(rw, iter, req->imu, ubuf, len);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
-- 
2.25.1

