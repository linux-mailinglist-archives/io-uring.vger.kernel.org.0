Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF6581254
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbiGZLux (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGZLux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:50:53 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327B432DBF
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:50:51 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220726115046epoutp014b2f6636d69cf43a1af995c282d66cb8~FXsboFI1u0603106031epoutp01O
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:50:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220726115046epoutp014b2f6636d69cf43a1af995c282d66cb8~FXsboFI1u0603106031epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658836246;
        bh=GaFMiezcC/Oe0p+cfmaYFu1JQYpckb58+h9LHvgAYKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6rUCRvfTA1fYpWtRxvaijkqu/bXQC3B55c5QrHwPfjrsY7rOKQD5jYeydaIsrFMS
         hNzxV1UXIu4F61pLjAFgluMwCMqoSCSqtFp/mcnO+zIV9xU0720gGYTN73gTW3ca75
         P32CW96InC2+tnE7DJUWAv9wWZBI0ZXgW4JacQWk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220726115045epcas5p2fb1d6de1f996d5244130cc99b07089b7~FXsbaCMTq0568605686epcas5p25;
        Tue, 26 Jul 2022 11:50:45 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LsZwz109mz4x9Pv; Tue, 26 Jul
        2022 11:50:43 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.CE.09662.F05DFD26; Tue, 26 Jul 2022 20:50:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220726105813epcas5p44c4058c9d3e9332ef939dbbb9a052738~FW_jeho7f2203422034epcas5p46;
        Tue, 26 Jul 2022 10:58:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220726105813epsmtrp2e1739a33789c0046949f0b5502880d15~FW_jd6JxZ3043430434epsmtrp2W;
        Tue, 26 Jul 2022 10:58:13 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-1c-62dfd50fd88f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.D9.08905.5C8CFD26; Tue, 26 Jul 2022 19:58:13 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220726105812epsmtip1baa3c7077a243fdeae17fea01d54b1e5~FW_isxgU-1956619566epsmtip1C;
        Tue, 26 Jul 2022 10:58:12 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v2 1/5] configure: check for nvme uring command
 support
Date:   Tue, 26 Jul 2022 16:22:26 +0530
Message-Id: <20220726105230.12025-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmhi7/1ftJBnOmWlisufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfsfzSftWAWV8WWhRYNjPs5uhg5OCQETCQW
        LrHsYuTiEBLYzSjx9OZMFgjnE6PEoenP2LsYOYGcb4wSm9f5gNggDS+n3mOGKNrLKNH7/BEj
        hNPKJLFuZg8LSBWbgLbEq7c3mEFsEQFhif0drWBxZoEoiTWvzjKC2MICQRJ3LywG28AioCox
        v3E9K4jNK2Aj8bb9FBvENnmJ1RsOgM3hFLCVaHo5hRVkmYTAInaJ+W2nWSGKXCQOTnvEAmEL
        S7w6voUdwpaS+PxuL9SgbIlND38yQdgFEkde9DJD2PYSraf6mUFhwSygKbF+lz5EWFZi6ql1
        TBA380n0/n4C1corsWMejK0q8ffebai10hI3312Fsj0kGj+9ggbjBEaJPQemsExglJuFsGIB
        I+MqRsnUguLc9NRi0wLDvNRyeJwl5+duYgQnJy3PHYx3H3zQO8TIxMF4iFGCg1lJhDch+n6S
        EG9KYmVValF+fFFpTmrxIUZTYABOZJYSTc4Hpse8knhDE0sDEzMzMxNLYzNDJXFer6ubkoQE
        0hNLUrNTUwtSi2D6mDg4pRqY5r486mkRtmSvRWHyB76ApvUzcmPOrLmayX0icdsTw1mLm5Wu
        f5NJsfTJS+X7pmQ9Y43mrOMvVF+1dkn8D5iocvMxz/nEMj1msVSz4ilT0jdWvL/+Q3S2vNHD
        k4+qayKYJm5at8PyZ+/8iI/BAkI9DN9anG5ppMT+P10Tm2V32O/DKe1Zc7j3s/X3f6v4OkHM
        NGxr+Us3VmetbUaNy93bpLR//Szm6FHf9W5K7qY7DYdmG3lbV+xNq1u3NSns7TVp6d/TFXdO
        ZHgd9teZSZszKf7olXg1FyOBfS0/I7T9mez3NlRbVgu7ctSvNer79ejb7OlphslSbZprXz+9
        Gz61R4Dd50vEslgfb8HEyQlKLMUZiYZazEXFiQD8u9tU1wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsWy7bCSnO7RE/eTDC6cFLFYc+U3u8Xqu/1s
        Fu9az7FYHP3/ls2BxePy2VKPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj/aD5rwSyuii0L
        LRoY93N0MXJySAiYSLyceo+5i5GLQ0hgN6PE2m2TWLoYOYAS0hIL1ydC1AhLrPz3nB2ipplJ
        4uXtB+wgCTYBbYlXb28wg9giQEX7O1pZQGxmgRiJqUcOg9nCAgESG9/uZgWxWQRUJeY3rgez
        eQVsJN62n2KDWCAvsXrDAbA5nAK2Ek0vp4DVCAHV/D10jG0CI98CRoZVjJKpBcW56bnFhgWG
        eanlesWJucWleel6yfm5mxjB4aOluYNx+6oPeocYmTgYDzFKcDArifAmRN9PEuJNSaysSi3K
        jy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoGJNWfG9GoP2VPesi8iPqXE
        TU98zXH75FsDsSuX/nwQl4ivTPXsZ7j0KaHm0/9rP/Meru5TvlKktKVXkLEudQP/jFgD3tnV
        qsl8hW7/uzurq594CHoX7F+uLXuOpW2y2/HyUz+6vr3Z1W/m877z5tT8oxc1tUVvW+6W9rYU
        t7ncsNjZnYcj7Hvmqcl86xQidJh/T1ObnLRyg//1+F2fNmp8OfSqb6HT5Bc257clN1//uPz1
        qd7a7LSXwklnnq3umMyUl1f5hmVtqvOp+Tpcq+eJzGO5dve425Tdmx6rRrEH54WVOTg/2tSe
        31OtdVjD/B1vgcTP+Veywk4/ZjCKcby4fknEsW32Oq98WZqKJsopsRRnJBpqMRcVJwIAEbs4
        xI4CAAA=
X-CMS-MailID: 20220726105813epcas5p44c4058c9d3e9332ef939dbbb9a052738
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105813epcas5p44c4058c9d3e9332ef939dbbb9a052738
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
        <CGME20220726105813epcas5p44c4058c9d3e9332ef939dbbb9a052738@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Modify configure to check availability of nvme_uring_cmd.
The follow up patch will have uring passthrough tests.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 configure | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/configure b/configure
index 43071dd..1b0cc50 100755
--- a/configure
+++ b/configure
@@ -367,6 +367,23 @@ if compile_prog "" "" "has_ucontext"; then
 fi
 print_config "has_ucontext" "$has_ucontext"
 
+##########################################
+# Check NVME_URING_CMD support
+nvme_uring_cmd="no"
+cat > $TMPC << EOF
+#include <linux/nvme_ioctl.h>
+int main(void)
+{
+  struct nvme_uring_cmd *cmd;
+
+  return sizeof(struct nvme_uring_cmd);
+}
+EOF
+if compile_prog "" "" "nvme uring cmd"; then
+  nvme_uring_cmd="yes"
+fi
+print_config "NVMe uring command support" "$nvme_uring_cmd"
+
 #############################################################################
 if test "$liburing_nolibc" = "yes"; then
   output_sym "CONFIG_NOLIBC"
@@ -402,6 +419,9 @@ fi
 if test "$array_bounds" = "yes"; then
   output_sym "CONFIG_HAVE_ARRAY_BOUNDS"
 fi
+if test "$nvme_uring_cmd" = "yes"; then
+  output_sym "CONFIG_HAVE_NVME_URING"
+fi
 
 echo "CC=$cc" >> $config_host_mak
 print_config "CC" "$cc"
-- 
2.17.1

