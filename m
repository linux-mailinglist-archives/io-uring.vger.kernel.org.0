Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1852462C6D0
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 18:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiKPRuF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 12:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiKPRtt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 12:49:49 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997AE5E9DF
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 09:49:45 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221116174942epoutp01639b5c60972d8929e806ce2b37d17dfa~oIfF7mfes2839928399epoutp01f
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 17:49:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221116174942epoutp01639b5c60972d8929e806ce2b37d17dfa~oIfF7mfes2839928399epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668620983;
        bh=lUhU524QX+KijjCrcU2r+s1yFfBszGGFNdvnU0M5zN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U4pPiQCdm2aXh2W12fohetwzDBTPVmNoiCdK+KWkjDWGiAntOaeeW9jdHhdY4bjxq
         Lu5BJ9eWuFjRhQLDyZarCJaggAaXESAR/d4DfmVSZkHS5dXlSe/PuMRMom0CUZbTIZ
         TuWQrZCLz/FBui+3mptAbLTtSmh6Rig6j4AJ1oAA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221116174942epcas5p36edbd2f5dbfde6e2304b8d26b35912a1~oIfFXitld0099700997epcas5p3D;
        Wed, 16 Nov 2022 17:49:42 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NC9Y11rJnz4x9Pp; Wed, 16 Nov
        2022 17:49:41 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.C3.39477.5B225736; Thu, 17 Nov 2022 02:49:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221116174940epcas5p45cb1039a9e79412c060ce232fe9a35ac~oIfEBDjbW1045410454epcas5p4I;
        Wed, 16 Nov 2022 17:49:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221116174940epsmtrp1c0591a8f1b2210f64a6bf2e07b9f2580~oIfEAaIkf2157521575epsmtrp1C;
        Wed, 16 Nov 2022 17:49:40 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-58-637522b59091
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.8E.18644.4B225736; Thu, 17 Nov 2022 02:49:40 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221116174939epsmtip2c99bd0e146f3873ccf9df05a5acb65a2~oIfC6_rrq1625516255epsmtip2w;
        Wed, 16 Nov 2022 17:49:39 +0000 (GMT)
Date:   Wed, 16 Nov 2022 23:08:21 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Joel Granados <j.granados@samsung.com>
Cc:     ddiss@suse.de, mcgrof@kernel.org, paul@paul-moore.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <20221116173821.GC5094@test-zns>
MIME-Version: 1.0
In-Reply-To: <20221116125051.3338926-2-j.granados@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdlhTXXerUmmywZdlXBZf/09nsXjXeo7F
        Yun+h4wWH3oesVncmPCU0eL2pOksDmwem1Z1snms3fuC0aNvyypGj82nqz0+b5ILYI3KtslI
        TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
        FJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ1xv2Up
        e8EyiYreyTfYGhjvCncxcnBICJhIHJ0j3cXIxSEksJtRoqF3PksXIyeQ84lRYvtHP4jEZ0aJ
        q73X2EESIA1vjk9hg0jsYpToenecHcJ5xihxaf5DsCoWAVWJ3ev72EFWsAloSlyYXAoSFhHQ
        kmj4dRKshFmgRmLtjxNg24QFciSubnvDBmLzCuhIvPixA8oWlDg58wlYDaeAncSMC7fAbFEB
        ZYkD244zQRz0kV3i+WNVCNtF4sCTxVCHCku8Or4FypaSeNnfBmUnS1yaeQ6qt0Ti8Z6DULa9
        ROupfmaI2zIkFj6exwRh80n0/n7CBAktXomONiGIckWJe5OeskLY4hIPZyyBsj0k1m9cBA2S
        o4wSU64dZZ3AKDcLyTuzkKyAsK0kOj80sc4CWsEsIC2x/B8HhKkpsX6X/gJG1lWMkqkFxbnp
        qcWmBUZ5qeXwGE7Oz93ECE6QWl47GB8++KB3iJGJg/EQowQHs5IIb/7kkmQh3pTEyqrUovz4
        otKc1OJDjKbA2JnILCWanA9M0Xkl8YYmlgYmZmZmJpbGZoZK4ryLZ2glCwmkJ5akZqemFqQW
        wfQxcXBKNTBNvtgv4dO48NKldxsyEsInT+czzvzz2ETWjS/fhtHbWCopeUHG+V/acv5hnOdS
        /ksbJmeXnlsQd7FLe+/S+EMfN7w8dF+J79WvBZfeS1c+u3Za6Nx5xsVLjooa5d3b+nKLpFjA
        Fr15UtNX1R/iiJ448aRk1oeJQg6Kx+wEVz4xYJo3bYtlHE/hrgNRKwwn7maykmPfpm63NTmq
        ccrS63+mzUidn3FBIMNY7eFrobl+LLPMen/evRruEm3ec03yvsPpHUzaU0W3rj3w/FOfgsnX
        0u5Dh3NPONheerRZvfvtv1TXJex9xSLbPn6fyJ9WzZGYX2j8Tiib4fmElgmWH1quMgkrrIk4
        tttkxscPpl8dlViKMxINtZiLihMBrz96ARkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO4WpdJkg4OnDSy+/p/OYvGu9RyL
        xdL9DxktPvQ8YrO4MeEpo8XtSdNZHNg8Nq3qZPNYu/cFo0ffllWMHptPV3t83iQXwBrFZZOS
        mpNZllqkb5fAlXHl73LmghuiFf8ev2RuYFwp2MXIySEhYCLx5vgUti5GLg4hgR2MEvc7D7BC
        JMQlmq/9YIewhSVW/nvODlH0hFFiwc0DYAkWAVWJ3ev7gGwODjYBTYkLk0tBwiICWhINv06C
        lTAL1Eis/XGCBcQWFsiRuLrtDRuIzSugI/Hixw6oxUcZJb6/m8cMkRCUODnzCQtEs5nEvM0P
        mUHmMwtISyz/xwES5hSwk5hx4RZYiaiAssSBbceZJjAKzkLSPQtJ9yyE7gWMzKsYJVMLinPT
        c4sNC4zyUsv1ihNzi0vz0vWS83M3MYLDXktrB+OeVR/0DjEycTAeYpTgYFYS4c2fXJIsxJuS
        WFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9N55TbLuvbHsp8S
        NPIPfNwiF+ljq9FYprUz+kSYwvvX+6O4MxIC7XxSfWL4nXSVhIxXbFz5/3Ht7rrQHTOkV9Su
        Srhq9Ur00bwJjRYZn45tmRDDuFlXl8lX7MXRldUXr6jtuTv1/r05LJsmP485Iin3f5eGtP52
        g/xz+xZzdK5dWno5a8Py2FNCW564abFnz63dkRfOM1VYODZ4nW1pWm7e7s1+13WbLf+uKLZ1
        tzXfdeXXF9+I3ZpS9+a8dciZWMV+Mml12IeAPaFbPm12irPYE3JnCa/Nu5vPz2V4VBw/kXM2
        RVA5vbFj2gQr9cVm9qps1nlM69+dabf5vyYvVkC5SSzfu7ZHdVrqddeIAiWW4oxEQy3mouJE
        AAjboRvqAgAA
X-CMS-MailID: 20221116174940epcas5p45cb1039a9e79412c060ce232fe9a35ac
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_4b3ee_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
References: <20221116125051.3338926-1-j.granados@samsung.com>
        <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
        <20221116125051.3338926-2-j.granados@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_4b3ee_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Nov 16, 2022 at 01:50:51PM +0100, Joel Granados wrote:
>Signed-off-by: Joel Granados <j.granados@samsung.com>
>---
> security/selinux/hooks.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>index f553c370397e..a3f37ae5a980 100644
>--- a/security/selinux/hooks.c
>+++ b/security/selinux/hooks.c
>@@ -21,6 +21,7 @@
>  *  Copyright (C) 2016 Mellanox Technologies
>  */
>
>+#include "linux/nvme_ioctl.h"
> #include <linux/init.h>
> #include <linux/kd.h>
> #include <linux/kernel.h>
>@@ -7005,12 +7006,22 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
> 	struct inode *inode = file_inode(file);
> 	struct inode_security_struct *isec = selinux_inode(inode);
> 	struct common_audit_data ad;
>+	const struct cred *cred = current_cred();
>
> 	ad.type = LSM_AUDIT_DATA_FILE;
> 	ad.u.file = file;
>
>-	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
>-			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
>+	switch (ioucmd->cmd_op) {
>+	case NVME_URING_CMD_IO:
>+	case NVME_URING_CMD_IO_VEC:
>+	case NVME_URING_CMD_ADMIN:
>+	case NVME_URING_CMD_ADMIN_VEC:

We do not have to spell out these opcodes here.
How about this instead:

+       /*
+        * nvme uring-cmd continue to follow the ioctl format, so reuse what
+        * we do for ioctl.
+        */
+       if(_IOC_TYPE(ioucmd->cmd_op) == 'N')
+               return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_op);
+       else
+               return avc_has_perm(&selinux_state, current_sid(), isec->sid,
+                                   SECCLASS_IO_URING, IO_URING__CMD, &ad);
+       }
+

Now, if we write the above fragment this way -

if (__IOC_TYPE(ioucmd->cmd_op) != 0)
	reuse_what_is_done_for_ioctl;
else
	current_check;

That will be bit more generic and can support more opcodes than nvme.
ublk will continue to fall into else case, but something else (of
future) may go into the if-part and be as fine-granular as ioctl hook
has been.
Although we defined new nvme opcodes to be used with uring-cmd, it is
also possible that some other provider decides to work with existing
ioctl-opcode packaged inside uring-cmd and turns it async. It's just
another implmentation choice.

Not so nice with the above could be that driver-type being 0 seems
under conflict already. The table in this page:
https://www.kernel.org/doc/html/latest/userspace-api/ioctl/ioctl-number.html
But that is first four out of many others. So those four will fall into
else-part (if ever we get there) and everything else will go into the
if-part.

Let's see whether Paul considers all this an improvement from what is
present now.

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_4b3ee_
Content-Type: text/plain; charset="utf-8"


------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_4b3ee_--
