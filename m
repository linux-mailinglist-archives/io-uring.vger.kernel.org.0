Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB43158ADB7
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241432AbiHEPzR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 11:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241475AbiHEPy4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 11:54:56 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EE478207
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 08:53:25 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220805155308epoutp024f926f04129fe4de61fcc22eb2255908~Ifc5rGoeX1590515905epoutp023
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 15:53:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220805155308epoutp024f926f04129fe4de61fcc22eb2255908~Ifc5rGoeX1590515905epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659714788;
        bh=lOaVuemJcvzVqvhmC9wH8jBWzJSDY06o4HSKqGiM8oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZakMqwxC5Pm1/VO6o7e4U6t+nRdNPho7hnl4aQaQ612xzmtgCrx+IHWilRPJMY46t
         L4Cgt5ld6mwZ+mTJUSQ7bTHqWhMQ3/bsz3UpHhxEgoY21GhmdSwhsX2oNC+17/lLcO
         oCX52cGLFBcqGpfMK/siVdTvn62CXyZVbQEUgV9c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220805155306epcas5p3d8fbce6a79f02a294b7a787a987b8e50~Ifc4V12580910109101epcas5p3t;
        Fri,  5 Aug 2022 15:53:06 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lzqr06dB5z4x9Pq; Fri,  5 Aug
        2022 15:53:04 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.4A.09662.0EC3DE26; Sat,  6 Aug 2022 00:53:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220805155304epcas5p1bb687a8f9b25317af39def01696626e8~Ifc2T7P2I2222122221epcas5p1l;
        Fri,  5 Aug 2022 15:53:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220805155304epsmtrp1ce7d0923a98420122d44a8d1b0cd35ca~Ifc2TLlrM0820308203epsmtrp1c;
        Fri,  5 Aug 2022 15:53:04 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-5a-62ed3ce00915
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.B9.08905.0EC3DE26; Sat,  6 Aug 2022 00:53:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155303epsmtip2d0a9a4c3e09c5280320d566a091e40c6~Ifc0-PsF71887518875epsmtip2O;
        Fri,  5 Aug 2022 15:53:03 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 1/4] fs: add file_operations->uring_cmd_iopoll
Date:   Fri,  5 Aug 2022 21:12:23 +0530
Message-Id: <20220805154226.155008-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220805154226.155008-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmpu4Dm7dJBvfXG1msvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx9P9bNovzbw8zWey9pW0xf9lTdotDk5uZHDg9ds66y+5x+Wypx+Yl9R67
        bzawebzfd5XNo2/LKkaPz5vkAtijsm0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
        lRTyEnNTbZVcfAJ03TJzgO5SUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgV
        J+YWl+al6+WlllgZGhgYmQIVJmRnbD/9mL1gL2vF9Vsn2RoYj7F0MXJySAiYSMy5/Imti5GL
        Q0hgN6PE14etrCAJIYFPjBLzZqtAJL4xStyevIkdpmPavpOsEIm9jBIv9l5kgXA+M0rcWbUc
        aBYHB5uApsSFyaUgDSIC8hJfbq8Fq2EWOMQo8XzJK2aQhLCAncTau9vAprIIqEqsXnMIzOYV
        sJRY3DOdCWKbvMTMS9/B4pwCVhKth7cwQ9QISpyc+QTsB2agmuats5lBFkgItHJIvJ97GOo5
        F4mln26xQdjCEq+Ob4F6QUriZX8blJ0scWnmOahlJRKP9xyEsu0lWk/1M4M8wwz0zPpd+hC7
        +CR6fz9hAglLCPBKdLQJQVQrStyb9JQVwhaXeDhjCZTtIbGj7Tk7JHx6GSUeTz7HPIFRfhaS
        F2YheWEWwrYFjMyrGCVTC4pz01OLTQsM81LL4RGbnJ+7iRGcPLU8dzDeffBB7xAjEwcjMGw5
        mJVEeH/ueJ0kxJuSWFmVWpQfX1Sak1p8iNEUGMYTmaVEk/OB6TuvJN7QxNLAxMzMzMTS2MxQ
        SZzX6+qmJCGB9MSS1OzU1ILUIpg+Jg5OqQamRdLbghTKX4QsW7aVaZWf+I6eOe5rP85RU5fq
        0N/KdGYe40O5OUUfjidGpn8x55XK5+biYvS6tJ+1gHuXavSeoNZ3YhL3/xg31q0Med3VqJfW
        sNRzn5rXyanqySoM9wIKnustZlQ4q/I3tEZ3bmHE43+FoksOPN2qp/2+X3fZUrceZ+sZJ3uP
        yZT86Pi0LHOV+yHhL1UGVrm3Pp20OFYpURP8wMimwyDhRc3P5DeXrtjZKDxTjzKMvJtreyW0
        ZtvmvAnzSvv0XeUvNs2+uVv89z7BB4/C2lxDtz7d9tbQs1Hg4INXTkYHDVaujDptO0PKMXCS
        X2BW2pf3MqE9lQH7bD97aB+KNXv50MPytoQSS3FGoqEWc1FxIgAYCx8EJwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO4Dm7dJBo83y1msvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx9P9bNovzbw8zWey9pW0xf9lTdotDk5uZHDg9ds66y+5x+Wypx+Yl9R67
        bzawebzfd5XNo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDK2n37MXrCXteL6rZNsDYzHWLoY
        OTkkBEwkpu07ydrFyMUhJLCbUWL2ojnMEAlxieZrP9ghbGGJlf+es0MUfWSU2H31C2MXIwcH
        m4CmxIXJpSA1IgKKEhs/NjGC1DALnGKUeH/0DdgGYQE7ibV3t4ENYhFQlVi95hCYzStgKbG4
        ZzoTxAJ5iZmXvoPFOQWsJFoPb2EGmS8EVDP/DhdEuaDEyZlPwEYyA5U3b53NPIFRYBaS1Cwk
        qQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLDXktzB+P2VR/0DjEycTAeYpTg
        YFYS4f2543WSEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxS
        DUwTOFhSeXxeCuzKFN5jKqnddev+rzkJSnwff22c+jC24K2oreK6DZtM5JwYlQR0UxbEb29s
        cJd1e7aN61LAk+lLRR58OpM6+2CUWedfXutjlkmLvCZk1n+7fe0ky854xz+7Qrh0WOK+9sj1
        l1r++fGjO2KfxJympx9YFbc8Smk+I9Dzvi/15MWzZyzPO/SeDX99f+6GzacLBBelFM9o7HE+
        fMlvXaBinfK1oz8v6zpmOWzSPlmTKqKcyihza0l6kKypdMLHubsk34oJXtoR+Z337/+oDs/E
        x9pLmq5crp8rV7BZcsbhzvjPKVcdZhyJC3Vh/Hr0zudDD5nnfOq5NX+O7b5dSZmSv/4In9nN
        dn65EktxRqKhFnNRcSIAf9tb1eoCAAA=
X-CMS-MailID: 20220805155304epcas5p1bb687a8f9b25317af39def01696626e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220805155304epcas5p1bb687a8f9b25317af39def01696626e8
References: <20220805154226.155008-1-joshi.k@samsung.com>
        <CGME20220805155304epcas5p1bb687a8f9b25317af39def01696626e8@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring will trigger this to do completion polling on uring-cmd
operations.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9f131e559d05..449941f99f50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2134,6 +2134,7 @@ struct file_operations {
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
+	int (*uring_cmd_iopoll)(struct io_uring_cmd *ioucmd);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.25.1

