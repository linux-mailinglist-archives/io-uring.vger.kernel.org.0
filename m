Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54A958FAAE
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 12:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiHKKaG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 06:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiHKKaF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 06:30:05 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2761B275FD
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 03:30:02 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220811102958epoutp013bd9d9bb6801dfbb3776f72f472ae206~KQ6dI_gXZ2511825118epoutp010
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 10:29:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220811102958epoutp013bd9d9bb6801dfbb3776f72f472ae206~KQ6dI_gXZ2511825118epoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660213798;
        bh=udUnT4Y9x67V/qJI78uSMA2oRR0gaH9MW2CegOdoJug=;
        h=From:To:Cc:Subject:Date:References:From;
        b=o8cHVM+HXogq+yxJegL4296J/1zwpc9Dytl2jhq6l9p38USxeAmFOMlwKNzeh95Yo
         BI674p5JfY5tUfX10J8lp2kmYF+WxifGoda6dZ8vyUfJDvoMSGSYkVKzJBJpVv5Pv2
         Iv4CfE+hmeDSx3fmAYrntAkdHIKyvRlNUAh2Gd4Y=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220811102958epcas5p46bb0348c4d0536d5dcd406ab2ec1e7a3~KQ6cy4o191029710297epcas5p4U;
        Thu, 11 Aug 2022 10:29:58 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4M3NNN332Tz4x9Px; Thu, 11 Aug
        2022 10:29:56 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7A.5C.49150.42AD4F26; Thu, 11 Aug 2022 19:29:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb~KQBxvxQXh0490804908epcas5p24;
        Thu, 11 Aug 2022 09:25:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220811092503epsmtrp2a1c316a50728a4e4429d4eda14eb0ec5~KQBxuGzEv2932429324epsmtrp2X;
        Thu, 11 Aug 2022 09:25:03 +0000 (GMT)
X-AuditID: b6c32a4b-393ff7000000bffe-d5-62f4da247972
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.B6.08905.FEAC4F26; Thu, 11 Aug 2022 18:25:03 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220811092502epsmtip267aecc3c831d4e2db85abfab14164759~KQBw2hea70903909039epsmtip2f;
        Thu, 11 Aug 2022 09:25:02 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH] io_uring: fix error handling for io_uring_cmd
Date:   Thu, 11 Aug 2022 14:44:59 +0530
Message-Id: <20220811091459.6929-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsWy7bCmpq7KrS9JBlMPiFk0TfjLbLH6bj+b
        xbvWcywWR/+/ZbM4NLmZyYHV4/LZUo/3+66yefRtWcXo8XmTXABLVLZNRmpiSmqRQmpecn5K
        Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xoOn39kLvrJX7H24h7mB
        8RBbFyMnh4SAicTdt9sZuxi5OIQEdjNKvDn0lQ3C+cQocXDlalYI5xujxKojbxhhWuZ8ugLV
        spdRYmXXPGYI5zOjxPtP+9hBqtgE1CWOPG8F6xAREJbY39HKAmIzC1RLLN18EGy5sICdxJ69
        v5i6GDk4WARUJe51mIOEeQUsJCYe2ckCsUxeYual7+wQcUGJkzOfQI2Rl2jeOhtsr4TANnaJ
        3u4NUA0uEu1ntkFdKizx6vgWdghbSuLzu71QT6dL/Lj8lAnCLpBoPrYPqt5eovVUPzPIPcwC
        mhLrd+lDhGUlpp5axwSxl0+i9/cTqFZeiR3zYGwlifaVc6BsCYm95xqgbA+JLR+ugp0gJBAr
        8XfBH8YJjPKzkLwzC8k7sxA2L2BkXsUomVpQnJueWmxaYJyXWg6P2OT83E2M4NSn5b2D8dGD
        D3qHGJk4GA8xSnAwK4nwli36nCTEm5JYWZValB9fVJqTWnyI0RQYxBOZpUST84HJN68k3tDE
        0sDEzMzMxNLYzFBJnNfr6qYkIYH0xJLU7NTUgtQimD4mDk6pBqbQtlueCebyvl5zXc77lM/c
        lX/YIzpSyktq/fmFL+05r07nlFiRySsg9XSz2f3zD/e5Xzh0bvtzU5cX03anSQXvaTc48Clv
        p0lC60ymkKLfR/dP8FA7kvhC79GPQx2M616ffHaZNd7ac7+A428Zj6uvv/9RanZzk+v41PrI
        xeMgs2BisN2cgNioGTL9hjo/LNVC6n5sTBSMsir2PZEouzortbdQU/PlliOfTvG1Feb4HVnM
        W3HncbrAcYYJh6QvaRdGmFwRiWyz57zdt9Wc86fZJ/ctN5TD6hVeR7gUR1hJNPPPdvEvZ9Ob
        e+f6zP+P82qXKVgUcM5eETFffe+7f9Lln3R2njJaeuheaIdXixJLcUaioRZzUXEiAEPWS6wG
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSvO77U1+SDLqWiVs0TfjLbLH6bj+b
        xbvWcywWR/+/ZbM4NLmZyYHV4/LZUo/3+66yefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
        g6ff2Qu+slfsfbiHuYHxEFsXIyeHhICJxJxPVxhBbCGB3YwSk2cLQcQlJE69XMYIYQtLrPz3
        nL2LkQuo5iOjxOFpD8ASbALqEkeet4LZIkBF+ztaWUBsZoF6ibUnf7OD2MICdhJ79v5i6mLk
        4GARUJW412EOEuYVsJCYeGQnC8R8eYmZl76zQ8QFJU7OfAI1Rl6ieets5gmMfLOQpGYhSS1g
        ZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcglqaOxi3r/qgd4iRiYPxEKMEB7OS
        CG/Zos9JQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTBd
        2B53aAFXCLvSJL3DN93Kz+cJP+/9c8Fk55MyHTXTGiHvJbvbfnVUGRX/lloq0dqyv/GQtMzS
        qfNfbu2wTKpU48nf2FJ0p+zkb61ty2YecIvdri2gL83kfLKou73y39FnJkFib1eHcP4OX1zZ
        wj3p5SG3E3se7Ps071v51MUvpYVDorU/Hz+vq6a0QtPGxpPdUSBvh/3/V2n7DmfN1/CRZ57D
        2z/T/crEJac85imsC87sllD89ZJ1tj6T/QHuknq95x7Mn1VmLpBfG2JgPHeFyYMrAcyPQ0uS
        r0Xe+ZC5/uimv8/+XZAq33Xr0dXu0mmzC3qMVDfdy9rwVmbOvLN95ffLX80PY/BIiLDTu5Gh
        xFKckWioxVxUnAgADmclorACAAA=
X-CMS-MailID: 20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit 97b388d70b53 ("io_uring: handle completions in the core") moved the
error handling from handler to core. But for io_uring_cmd handler we end
up completing more than once (both in handler and in core) leading to
use_after_free.
Change io_uring_cmd handler to avoid calling io_uring_cmd_done in case
of error.

Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 io_uring/uring_cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0a421ed51e7e..d5972864009e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -106,7 +106,9 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (ret != -EIOCBQUEUED) {
-		io_uring_cmd_done(ioucmd, ret, 0);
+		if (ret < 0)
+			req_set_fail(ret);
+		io_req_set_res(req, ret, 0);
 		return IOU_OK;
 	}
 
-- 
2.25.1

