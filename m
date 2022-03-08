Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D754F4D1C08
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346457AbiCHPnn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347929AbiCHPnk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:40 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF9BE17
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:43 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154242epoutp0317591dab3fbd812455674a3d281c3d41~aci_BGJgj2872928729epoutp03J
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154242epoutp0317591dab3fbd812455674a3d281c3d41~aci_BGJgj2872928729epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754162;
        bh=B9TCCvMpq0hZ8/Gfc3DGPxKEOS7j8oXEpRjRFqsjyFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1qbUeCVC85O/d9o9pjyBjUdN0oxRnKCImsmwGVM0lP6UoXwT5ojM6tDfL2/fpjAW
         zqMmY8GwNNc1VyCl2f6gWZXBlIEN6kWSMeIjYCPpcXEKQowoNP2G3AfFJkpdmYNVgj
         X/yqmWCPiZxkaPf7Zg8T2GeVISUdlINdJqb8MC9w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220308154241epcas5p45d1f0d628e028943aa92360091e60bb3~aci9ZQ1-H0458304583epcas5p4J;
        Tue,  8 Mar 2022 15:42:41 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KCfjB3kgFz4x9Pp; Tue,  8 Mar
        2022 15:42:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7A.57.06423.E6977226; Wed,  9 Mar 2022 00:42:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13~acVbjD1AI0623006230epcas5p3d;
        Tue,  8 Mar 2022 15:27:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152711epsmtrp2182fc0fe1c80190c69467d6c864a0e91~acVbiFBOx2761027610epsmtrp2D;
        Tue,  8 Mar 2022 15:27:11 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-00-6227796ea243
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.96.03370.FC577226; Wed,  9 Mar 2022 00:27:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152709epsmtip1d1199c377ac2493630a28bda0b92732b~acVZhcOPT0990109901epsmtip1c;
        Tue,  8 Mar 2022 15:27:09 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 09/17] io_uring: plug for async bypass
Date:   Tue,  8 Mar 2022 20:50:57 +0530
Message-Id: <20220308152105.309618-10-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmum5epXqSQdc+CYvphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQP0g5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10v
        L7XEytDAwMgUqDAhO+PJjqtsBUdZKq5/3cPYwLifuYuRk0NCwETi476V7F2MXBxCArsZJXo2
        LmCBcD4xSvTPWsMK4XxmlPj78hlcy9LN85ggErsYJT5fWc0GV3XhzEmgDAcHm4CmxIXJpSAN
        IgJeEvdvvwebxCzQxSTxdt99NpCEsICZxNtff1lBbBYBVYmDZ+aA9fIKWEl8XWsPsUxeYual
        7+wgNidQ+OetrWDlvAKCEidnPmEBsZmBapq3zmYGmS8hcIRDomXHDUaIZheJQ78vs0PYwhKv
        jm+BsqUkPr/bywZhF0v8unMUqrmDUeJ6w0wWiIS9xMU9f8EOYgZ6Zv0ufYiwrMTUU+uYIBbz
        SfT+fsIEEeeV2DEPxlaUuDfpKSuELS7xcMYSKNtD4vT3pdCQ62WU6Hp4l30Co8IsJA/NQvLQ
        LITVCxiZVzFKphYU56anFpsWGOallsOjOTk/dxMjOGFree5gvPvgg94hRiYOxkOMEhzMSiK8
        98+rJAnxpiRWVqUW5ccXleakFh9iNAUG+ERmKdHkfGDOyCuJNzSxNDAxMzMzsTQ2M1QS5z2d
        viFRSCA9sSQ1OzW1ILUIpo+Jg1OqgUmRc+OcgtIV99bO/mMY2WFR9vXCI8dZ/Ifcq9z9Hndt
        qflxfWLV/KeHZlhPW7XmUZ5lfMJ07RiBORnH5BfvWLfqxZOtisK1fqyyCocKDGub0nvlZL4+
        VFwVeDSBM70naWZEpw2Po6Pzzx29anvlwiYV2NivWG7Geq0v9o13jRI33/QDjw/s7t0Y8Gt5
        SFPOpHk512tk+Q+GHjIwu+SV4WWnxCH8WSVKnaHDavM8+f5vhyo4Tr//92DhnvTfXy9tPXau
        esqWfev6TkrnyXo1FLo8Fl3Devh9izBPpOacSQ9nda8StNsrcPrYkmofrY0OIV5yLXdXpfgy
        Cgr/cTh+/vS7WUmiP/mz05u+dK9b+1eJpTgj0VCLuag4EQA2GwXSYQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTvd8qXqSwf7fahbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr48mOq2wFR1kqrn/dw9jAuJ+5i5GTQ0LARGLp
        5nlMXYxcHEICOxglFkx5zQKREJdovvaDHcIWllj57zk7RNFHRomru/8CORwcbAKaEhcml4LU
        iAgESBxsvAxWwywwg0mip/kz2CBhATOJt7/+soLYLAKqEgfPzGEC6eUVsJL4utYeYr68xMxL
        38F2cQKFf97aClYuJGApsWLdbzYQm1dAUOLkzCdgI5mB6pu3zmaewCgwC0lqFpLUAkamVYyS
        qQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwfGkpbWDcc+qD3qHGJk4GA8xSnAwK4nw3j+v
        kiTEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk7qPS4C/
        0SOHp4nyAplJGmGzJ8y5dViTReLq2tZYOc6bW/gm+dRy9+aeX/BzjtnEt+0aFSXCS9kPcYWL
        XdHKmfF4UgUr199Hk2QO1XPtWLqId/qBmwqbdSbIlrKEdebX3lTzDzz7J+u6wQKptF9n4zPT
        NP93qT7ulIxmTXvEwfTjzvOoPRNUdhSeu7ypYrLdjKNi2W+2ZH3Ywp4qIi714sNRJp2WJq1D
        7fwndtx4lvM+2nqCg3N0eO8l5rjlUs5psi5F0TcS5ll/SfKZM/lywDK3vS5TK4V3Pdy7KO2l
        5/EvVlor5uT96jltWjy7VXumma5ESOjtC4Im30QvLDkYemD6CvFT6i06jx7Xfd8spcRSnJFo
        qMVcVJwIAHVdqpsWAwAA
X-CMS-MailID: 20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Enable .plug for uring-cmd.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a1dcea0f538..f04bb497bd88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1106,9 +1106,11 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_LINKAT] = {},
 	[IORING_OP_URING_CMD] = {
 		.needs_file		= 1,
+		.plug			= 1,
 	},
 	[IORING_OP_URING_CMD_FIXED] = {
 		.needs_file		= 1,
+		.plug			= 1,
 	},
 };
 
-- 
2.25.1

