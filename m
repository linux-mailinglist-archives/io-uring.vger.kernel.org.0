Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE2583E6F
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbiG1MQC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiG1MQB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:16:01 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A79C66AD3
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:15:59 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220728121558epoutp01d6a1e02b201bddd4d210226abcab602e~F-VANW9VB0846308463epoutp01S
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 12:15:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220728121558epoutp01d6a1e02b201bddd4d210226abcab602e~F-VANW9VB0846308463epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659010558;
        bh=GaFMiezcC/Oe0p+cfmaYFu1JQYpckb58+h9LHvgAYKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trX2iSD0V3C7VtYS2JGs7yDuKHwQWfCw1FYGALoNGz8aLt3tbj/7l7KJkl+Hw7LQC
         Q87SaeFi3QThsvH/cHfExfkkKtrMZfyJnlHzQ8cD0FJea3tTwsG6t8AZVHL1uHlV2J
         nu0EGXn4HQNy6TiRMz3D9Ex/EA8aGLW91sVQeg1w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220728121557epcas5p25b0e6c7ec2e0409b5d3a560f2d3000aa~F-U-56Hdl3150931509epcas5p2G;
        Thu, 28 Jul 2022 12:15:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LtqP70Kznz4x9Pr; Thu, 28 Jul
        2022 12:15:55 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.DC.09662.AFD72E26; Thu, 28 Jul 2022 21:15:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220728093904epcas5p4eed789c1eda441c223795dd026dc5d3f~F9MA32xkZ0692706927epcas5p4m;
        Thu, 28 Jul 2022 09:39:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220728093904epsmtrp1f23ab3ff929b8faa3dae461a2271690b~F9MA3SSh-1674116741epsmtrp1Z;
        Thu, 28 Jul 2022 09:39:04 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-a1-62e27dfa0d19
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.56.08905.83952E26; Thu, 28 Jul 2022 18:39:04 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220728093903epsmtip14a85e1750395c4e45eac7527286242ef~F9L-yhx1c1234512345epsmtip1I;
        Thu, 28 Jul 2022 09:39:02 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v3 1/5] configure: check for nvme uring command
 support
Date:   Thu, 28 Jul 2022 15:03:23 +0530
Message-Id: <20220728093327.32580-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmlu6v2kdJBjd+WFusufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfsfzSftWAWV8WWhRYNjPs5uhg5OSQETCTe
        P1/O0sXIxSEksJtRouf0UmYI5xOjxMGePWwQzjdGiVmT1jLBtJyfuAGqZS+jxISzdxghnFYm
        iZkr17ODVLEJaEu8enuDGcQWERCW2N/RygJiMwtESax5dZYRxBYWCJI4e6cFrIZFQFXi0ekO
        sDivgI3E4i8X2SG2yUus3nAArIZTwFbi06MTYMskBOaxS5x/9ZMVoshFYs2prVC2sMSr41ug
        mqUkXva3QdnZEpse/oR6oUDiyIteZgjbXqL1VD+QzQF0nKbE+l36EGFZiamn1jFB3Mwn0fv7
        CVQrr8SOeTC2qsTfe7dZIGxpiZvvrkLZHhIrX2+FhuMERommVbOYJzDKzUJYsYCRcRWjZGpB
        cW56arFpgWFeajk81pLzczcxghOUlucOxrsPPugdYmTiYDzEKMHBrCTCmxB9P0mINyWxsiq1
        KD++qDQntfgQoykwACcyS4km5wNTZF5JvKGJpYGJmZmZiaWxmaGSOK/X1U1JQgLpiSWp2amp
        BalFMH1MHJxSDUzNl29GzoyMm3pxiSCT+XFNSyeFz7HKRsrpJ70OVczZmP1zguui9eduPJ3k
        3pTAsMlx4qQHLtfcCxi2eL4JEU6SV3r+TtPMbdU30WkKdWveeZ27MEVYx61njZKiGW/GWbdz
        rAoLTauXTDyySf7Iya/PDGqrlWI6uS425dluPD73s7j+5EVtpzvPeDK8sv313d/toV1E2Uf9
        BbdFwm+1np++cxa79KRfs2LD/sZunrMgr5q1ZpuIyg8GYz5326Ki24um7NyVlV+yKNjxXNOS
        hQuOnNxcfFj+4YMCzvq47WwsNtNqqjQVmJfM+GpyTn7J8hcT0g4etrU8HTjrTKbGorC/ublf
        TM9/Wsq2sGeW6s8HSizFGYmGWsxFxYkAvUPjMtkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsWy7bCSnK5F5KMkg/krmC3WXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4MvY/ms9aMIurYstC
        iwbG/RxdjJwcEgImEucnbmABsYUEdjNK3L6s0cXIARSXlli4PhGiRFhi5b/n7F2MXEAlzUwS
        27p2gNWzCWhLvHp7gxnEFgEq2t/RChZnFoiRmHrkMJgtLBAg8XPZZDYQm0VAVeLR6Q5GEJtX
        wEZi8ZeL7BAL5CVWbzgANodTwFbi06MTjBD32Ei8nrSdaQIj3wJGhlWMkqkFxbnpucWGBYZ5
        qeV6xYm5xaV56XrJ+bmbGMHBo6W5g3H7qg96hxiZOBgPMUpwMCuJ8CZE308S4k1JrKxKLcqP
        LyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgSn1SusF4egNbZNOphv8S11f
        LeES81P44FxBd30Wp6+dM54vPBCk2KIU8T1jubv2gVYmO9aAxiVS0wKFdVJ+TLi/b24qE+eJ
        w4+kwnIdZR+sOSrFWr10msBU6TYjh8jDe9mbowPDcsLuMse1bH8aF74i3mD5Bt73XUzT2Le2
        nF/t9j7OMfVIA+/eKc6uWb5Vt0/G7e5ycrAvPOi/4c/5vAs2TY13D3cJ2v3Xmyc6ZdG6xi2p
        Ad7fwsSvvF0vMjVaaif7na8ROx42sBYmsFbnK2zcMWfvkxNy22b+ue2q/u7HWofViyZaO1xn
        qX36s+0n92vh/u98hvVJN0O6q18Zn+hNN88L+KHjOWdf8+1zf5VYijMSDbWYi4oTAe3ZtpuN
        AgAA
X-CMS-MailID: 20220728093904epcas5p4eed789c1eda441c223795dd026dc5d3f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093904epcas5p4eed789c1eda441c223795dd026dc5d3f
References: <20220728093327.32580-1-ankit.kumar@samsung.com>
        <CGME20220728093904epcas5p4eed789c1eda441c223795dd026dc5d3f@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

