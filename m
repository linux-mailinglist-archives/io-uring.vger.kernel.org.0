Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099E859E9CA
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 19:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiHWRhS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 13:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiHWRgw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 13:36:52 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D508B175AD
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 08:20:23 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220823152021epoutp0189c6d7a990dd6aa92566f426cff18105~OAnaw_9Nz1567915679epoutp01G
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 15:20:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220823152021epoutp0189c6d7a990dd6aa92566f426cff18105~OAnaw_9Nz1567915679epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661268021;
        bh=E0qqw9YRX7QpAFzrzfu3nwtXA+cdfjOo1JWFrRTjuuo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Be4FqeKrEChoP9zHMjuCbtMhrq/Y0eBoVASBY3Mq85pn2lnYiVOzyMGXMwlfXTVUk
         SXoUV0yW9qZfc7DXFoY95ySeFEdatKGHLZCOGeLkqjJylKrO1WQtBc+hyI2eWQeYHV
         STPFX/z31obMXObaddmO5qLvhyjVo9rWU2p7bArw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220823152020epcas5p44f0141bd673b4f0ca232339d84663903~OAnZ12ACf0819008190epcas5p4d;
        Tue, 23 Aug 2022 15:20:20 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MBtFt4B8zz4x9Pp; Tue, 23 Aug
        2022 15:20:18 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.F6.15517.230F4036; Wed, 24 Aug 2022 00:20:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32~OAnXrXQeg1281412814epcas5p3C;
        Tue, 23 Aug 2022 15:20:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823152018epsmtrp14d92db7c5450cca02b15f57e497ebf59~OAnXqtIvx1507415074epsmtrp1M;
        Tue, 23 Aug 2022 15:20:18 +0000 (GMT)
X-AuditID: b6c32a4b-e21ff70000003c9d-40-6304f032e0c5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.40.14392.130F4036; Wed, 24 Aug 2022 00:20:17 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220823152017epsmtip279a15b40aa2f7772aca6f4ce7500bb9c~OAnWwSQO62484324843epsmtip2_;
        Tue, 23 Aug 2022 15:20:16 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        anuj20.g@samsung.com
Cc:     Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH] io_uring: fix submission-failure handling for uring-cmd
Date:   Tue, 23 Aug 2022 20:40:22 +0530
Message-Id: <20220823151022.3136-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7bCmlq7RB5Zkg93XFCyaJvxltpizahuj
        xeq7/WwW71rPsVgc/f+WzYHVY+esu+wel8+WevRtWcXo8XmTXABLVLZNRmpiSmqRQmpecn5K
        Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xpGb8xgLVrNVTN23lL2B
        cQZrFyMnh4SAicShz6+Zuxi5OIQEdjNKzJkxDcr5xCjx6s90JgjnG6PElOPLWWBauo+eZYFI
        7GWUaNgyG6rlM6PE/i/bgFo4ONgENCUuTC4FaRARiJU4+uAMO4jNLKAu8e7MSjaQEmEBD4lZ
        W8HCLAKqEicmv2EGsXkFzCVWb/zPBrFLXmLmpe/sEHFBiZMzn7BAjJGXaN4KsVZCYBu7xNwl
        99khGlwkDrTdgbKFJV4d3wJlS0m87G+DspMlLs08xwRhl0g83nMQyraXaD3VzwxyGzPQ+et3
        6UPs4pPo/f0E7CsJAV6JjjYhiGpFiXuTnkJDUVzi4YwlULaHRM+sjWCvCAF9PmvLNpYJjHKz
        kHwwC8kHsxCWLWBkXsUomVpQnJueWmxaYJyXWg6PyuT83E2M4PSm5b2D8dGDD3qHGJk4GA8x
        SnAwK4nwWh1jSRbiTUmsrEotyo8vKs1JLT7EaAoM1onMUqLJ+cAEm1cSb2hiaWBiZmZmYmls
        ZqgkzjtFmzFZSCA9sSQ1OzW1ILUIpo+Jg1Oqgenxj5WvezI0yyfmPfzk86jnqvKeMkeHvN86
        LuseyH7YMtl1ovbUYLNrmcsf+O64wvZp/0KmaVZ1j99Wf/CW0jo3L2tHO7PX3TdbPLfMjbWL
        U7sbtsWYSY+n8fWs7Nb0FsEL/G7Ptimnfko0LIwurpSdczD070vnWXHGrsYbpGek99g+csuc
        zOv/RD0xp/YyiyXX5rWdT+tPCSt5K9SIyGjPmJMZ6/X9ZcbmA+fkd201633LXbWbr+B93qXX
        v/YFVX4IF5xT5/oooD5Bp39bhPnXnRd4nAo5v/nY2b7/sqLJUDZgj7RJdC7j/PP3bnuHr5/O
        sGbzmrAFt57scGfjLss8Jnn34vulH5syFqavF1FiKc5INNRiLipOBADu+Dke+AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSvK7hB5Zkgz1XTSyaJvxltpizahuj
        xeq7/WwW71rPsVgc/f+WzYHVY+esu+wel8+WevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
        kZvzGAtWs1VM3beUvYFxBmsXIyeHhICJRPfRsyxdjFwcQgK7GSU2/rzPApEQl2i+9oMdwhaW
        WPnvOTtE0UdGifU37wAVcXCwCWhKXJhcClIjIpAocevVXrChzALqEu/OrGQDKREW8JCYtRVs
        DIuAqsSJyW+YQWxeAXOJ1Rv/s0GMl5eYeek7O0RcUOLkzCcsEGPkJZq3zmaewMg3C0lqFpLU
        AkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwSGopbmDcfuqD3qHGJk4GA8xSnAw
        K4nwWh1jSRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qB
        yU7hSh7PhAks4s/PMWiqlDv5aiQJzA1TrOXMuvKr6iWr4L/HUxf7bbG6diHw1rxY9T1xtzpK
        YiIuVXrFzbrloRY1n5Xx5vZv7ZO3zUkTcZdmzltw/lnJd9/VrTN95PW/PHyesKmaRTz6SGqr
        zweR13kGZ3QbToSuDWJcdOrS30KVivPZSY8vXinLq5q3w+Btu8zM9b/Usi+a/ZXYf1PIj1U1
        4YbhrCuzIhJvHOPK/R/+7fXDeykRl78eqp3H7dERfcU9uvxA5I9Gxesbb56cPePhhMRZRsfO
        zHR69rT6iYVR9Re1+YqRbz/m5137Zj9dW3jiOeOwBjOmLdusdOfyyi/NtH3TM8HuZIZYKrPy
        ViWW4oxEQy3mouJEAE4mP9iwAgAA
X-CMS-MailID: 20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32
References: <CGME20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If ->uring_cmd returned an error value different from -EAGAIN or
-EIOCBQUEUED, it gets overridden with IOU_OK. This invites trouble
as caller (io_uring core code) handles IOU_OK differently than other
error codes.
Fix this by returning the actual error code.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b0e7feeed365..6f99dbd5d550 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,7 +119,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret < 0)
 			req_set_fail(req);
 		io_req_set_res(req, ret, 0);
-		return IOU_OK;
+		return ret;
 	}
 
 	return IOU_ISSUE_SKIP_COMPLETE;
-- 
2.25.1

