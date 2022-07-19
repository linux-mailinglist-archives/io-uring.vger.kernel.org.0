Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8FD57AFB3
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 06:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiGTEJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 00:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTEJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 00:09:54 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA2D1ADAF
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 21:09:53 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220720040948epoutp02abb7a06202b3a58b32479c37a654c571~DbiPabmVI2105121051epoutp026
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 04:09:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220720040948epoutp02abb7a06202b3a58b32479c37a654c571~DbiPabmVI2105121051epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658290188;
        bh=GaFMiezcC/Oe0p+cfmaYFu1JQYpckb58+h9LHvgAYKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGEKRChxZmFLVs8fW9nBuUI9MjtbwK9L7K6aXzz7kyXzX1eSREhQJ5nEoOKHtGVZA
         YFINcar8nVS4iogaGRE88IXrJ4bdTrHcyl2Ixv7oZUSJQFZVKpRgu77vycSPMT+tSn
         pWtCcNUGNJotTU4VdGuK5q4lciXWwO8ZBXRiQjlk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220720040947epcas5p19da35e78deecf9bd4727b4bcdcc5a4e8~DbiO8MYBW0854608546epcas5p1z;
        Wed, 20 Jul 2022 04:09:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Lnhzs6qMWz4x9Pt; Wed, 20 Jul
        2022 04:09:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.FC.09662.30087D26; Wed, 20 Jul 2022 13:09:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220719135832epcas5p31bb7df7c931aba12454b6f16c966a7c8~DP6-3udOd0625506255epcas5p3E;
        Tue, 19 Jul 2022 13:58:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220719135832epsmtrp1040ab7d6cf8e6c443f5043543b817bcb~DP6-3AFbi1050910509epsmtrp1R;
        Tue, 19 Jul 2022 13:58:32 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-4d-62d78003c8fa
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.7A.08905.888B6D26; Tue, 19 Jul 2022 22:58:32 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135831epsmtip1932b3fb621e002749899a96fed1e45fd~DP6_8bRm72318623186epsmtip10;
        Tue, 19 Jul 2022 13:58:31 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing 1/5] configure: check for nvme uring command
 support
Date:   Tue, 19 Jul 2022 19:22:30 +0530
Message-Id: <20220719135234.14039-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719135234.14039-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7bCmhi5zw/Ukg2eLRCzWXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDUq2yYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbG/kfz
        WQtmcVVsWWjRwLifo4uRk0NCwERi1vsmxi5GLg4hgd2MEgtWTWKGcD4xSqz5uIUFpEpI4Buj
        RNfkcJiO+5duQBXtZZRo2bmVDcJpZZI4d+0sM0gVm4C2xKu3N8BsEQFhif0drSwgRcwC7YwS
        HxYcYQdJCAv4S1zccIENxGYRUJXoPP6LFcTmFbCRePRvGQvEOnmJ1RsOgA3iFLCV+LD9Jdhq
        CYF97BJfGr+yQhS5SEzY8pYdwhaWeHV8C5QtJfGyvw3KzpbY9PAnE4RdIHHkRS8zhG0v0Xqq
        H8jmALpOU2L9Ln2IsKzE1FPrwMqZBfgken8/gWrlldgxD8ZWlfh77zbUndISN99dhbI9JKZ8
        n8YCCZUJjBLPV9xmmcAoNwthxQJGxlWMkqkFxbnpqcWmBYZ5qeXwWEvOz93ECE5kWp47GO8+
        +KB3iJGJg/EQowQHs5II79PC60lCvCmJlVWpRfnxRaU5qcWHGE2BATiRWUo0OR+YSvNK4g1N
        LA1MzMzMTCyNzQyVxHm9rm5KEhJITyxJzU5NLUgtgulj4uCUamAyOHTp6pbIk/sS0lZ15Vzy
        eXn/fZV571JhAc0/6bWRxVmz5timBVw9tzD8Tr5cWZWnSU/ZojlLmCPkr9+PepDXU1BfozTv
        v/FcdflPNRmlev8ETzXOudkclW53rNIi50To7623lRkfplQuTteYKfPhaFvYll0XDK/z7Nom
        mX022MFLqlKlyyVnc+USiVcNOpaX/625mrDhO99mLpfdxkqhIlkGvZeP2TjaRLVML1MUXvA9
        tKHjiltksWLJgumePjnb3zt3V/0OMJJ60/pQRTB8mewZXhHTx1HLU+Wv7VkxNSjv1tNiZ6a2
        HZXPNL92pSecnlRdtubJx58tX1M4dZI0jaTCLXPOsvpf//FEWYmlOCPRUIu5qDgRALwvWJjt
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42LZdlhJTrdjx7Ukg3VbdS3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDWKyyYl
        NSezLLVI3y6BK2P/o/msBbO4KrYstGhg3M/RxcjJISFgInH/0g1mEFtIYDejxMJLYV2MHEBx
        aYmF6xMhSoQlVv57zt7FyAVU0swkcf/hM3aQBJuAtsSrtxC9IkBF+ztaWUCKmAV6GSVW/j/C
        BJIQFvCV2HnsOQuIzSKgKtF5/BcriM0rYCPx6N8yFogN8hKrNxwAG8QpYCvxYftLqINsJL7d
        mck+gZFvASPDKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4DDT0tzBuH3VB71DjEwc
        jIcYJTiYlUR4RWovJwnxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgm
        y8TBKdXAZP7BUbaupccpNlP6wvNqjoYK/xNeEVVVfEzLc6PbG23/LZwlryEZp8vi9D3W7Ojq
        OrELERL1F78rWkw8/e6jaErg7RvL035eKE4/vE7n95b25rB/HJpOqYvvCrye2KcjUh51cVaj
        H8edHDmZrOozhfzPbM9vCpv4YJuY6lUnjl3v+W9Uz9bx6t91YcLfx21TWov6FjfMPXB/nfW5
        GDnDgF7Dv5+V7V8/7NlevyP876pJH/4bXz2gz38jSudtivCksN2qMyXDjokHLzS4fGrNCg4f
        g3f1j26udSqYtyTYKVTcqfOg3SZ+3lUfqtjeK3PNWc2stjdBdoPlyQMv/9yZ8/xckJJjjfCV
        rw6Z+3eyKbEUZyQaajEXFScCAGljVk+iAgAA
X-CMS-MailID: 20220719135832epcas5p31bb7df7c931aba12454b6f16c966a7c8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135832epcas5p31bb7df7c931aba12454b6f16c966a7c8
References: <20220719135234.14039-1-ankit.kumar@samsung.com>
        <CGME20220719135832epcas5p31bb7df7c931aba12454b6f16c966a7c8@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

