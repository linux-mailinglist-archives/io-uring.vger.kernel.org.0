Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00935A38B2
	for <lists+io-uring@lfdr.de>; Sat, 27 Aug 2022 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiH0QJu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Aug 2022 12:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiH0QJs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Aug 2022 12:09:48 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEE3B87
        for <io-uring@vger.kernel.org>; Sat, 27 Aug 2022 09:09:46 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220827160941epoutp02083d6e199c07da7f85d60e0e894d87c0~PP3pKfysS1660816608epoutp02S
        for <io-uring@vger.kernel.org>; Sat, 27 Aug 2022 16:09:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220827160941epoutp02083d6e199c07da7f85d60e0e894d87c0~PP3pKfysS1660816608epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661616582;
        bh=evygocT09tMs7CGvqbG9AooamCGCcoExTqJyCrFX1Hw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OHYnVFDR2ehc6p06vJSaN3oQoVIZq3T/W+as+vwLj7DwlDw2OQ8tykaESl9nvO29Q
         oqtcgNutSfxgH83kbLvPsIvuEseY08umI7hPo9JXLbZ9pbql8ppqATnR8I0FLu+nQl
         MWpVdiTsz+3+dlfFpnVOMhVQ6Dc/ABayF7Y4jzQ0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220827160940epcas5p2e8834706a88370fd71a304e00ea310a0~PP3n3YSbJ0945709457epcas5p2b;
        Sat, 27 Aug 2022 16:09:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MFM8y1Cmlz4x9Pt; Sat, 27 Aug
        2022 16:09:38 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.EA.54060.2C14A036; Sun, 28 Aug 2022 01:09:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220827160937epcas5p4bb20671f88d91eee6ac226dcb29b7e74~PP3kvMEk52668426684epcas5p4D;
        Sat, 27 Aug 2022 16:09:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220827160937epsmtrp25123dfdff76c3b757ff9c5dfc51cce6a~PP3kr3GRO2008920089epsmtrp2-;
        Sat, 27 Aug 2022 16:09:37 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-f3-630a41c27689
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.40.14392.1C14A036; Sun, 28 Aug 2022 01:09:37 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220827160936epsmtip1600119da0a25d6f99df9d3673a207db6~PP3juxF832186821868epsmtip1r;
        Sat, 27 Aug 2022 16:09:36 +0000 (GMT)
Date:   Sat, 27 Aug 2022 21:29:54 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Message-ID: <20220827155954.GA11498@test-zns>
MIME-Version: 1.0
In-Reply-To: <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTS/eQI1eyweM9rBZrrvxmt1h9t5/N
        4t62X2wW71rPsVjcnjSdxYHV4/LZUo+1e18wevRtWcXocXT/IjaPz5vkAlijsm0yUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
        9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Izvt2+xFzQJ1lx
        axJPA2OXaBcjJ4eEgInE37PX2LoYuTiEBHYzSmxZPg/K+cQo8fDwClYI5xujRNval2wwLZ82
        7YVK7GWU+DqtjR0kISTwjFHi4rnaLkYODhYBVYkr50tATDYBTYkLk0tBKkQEdCT27XnODtLK
        LNDKKPHz8mFWkISwgKPEtl8XwcbwCuhKTF2+mBXCFpQ4OfMJC4jNKeAi8ebZJyYQW1RAWeLA
        tuNMIIMkBN6yS/xuXssOcZyLxMeXy1khbGGJV8e3QMWlJD6/2wv1QLLEpZnnmCDsEonHew5C
        2fYSraf6mUFsZoEMiY1XjzNB2HwSvb+fMIE8IyHAK9HRJgRRrihxb9JTqFXiEg9nLIGyPSQ+
        P5vIBAmff0wSN/fPZ5zAKDcLyT+zkKyAsK0kOj80sc4CWsEsIC2x/B8HhKkpsX6X/gJG1lWM
        kqkFxbnpqcWmBcZ5qeXwKE7Oz93ECE6MWt47GB89+KB3iJGJg/EQowQHs5II79ddHMlCvCmJ
        lVWpRfnxRaU5qcWHGE2B0TORWUo0OR+YmvNK4g1NLA1MzMzMTCyNzQyVxHmnaDMmCwmkJ5ak
        ZqemFqQWwfQxcXBKNTD18KYFJ9UtLqzacrR9RqLG9tmPKv3/VMg/3Pbs4hX7q/eq776enCCt
        dUeE79pRr10uxt8mno8U23pw1qZX4ROK11+7893y/ucGsagmez7niRtPuZlvCer6cP38zhiV
        GukVbqkv3dW71nVc36/9b5riYanmzYd/1+wyz61R+9fhYLDigWbKrmcs+4UuJ+0UYfJ5N9/8
        huH74J+fLLuVLuidWLr5/v1zaZNENIoORimd61yWZ7hW5mSk3iv+2766Zi81eLINMgNtpxpU
        aZ6N+6twflubx8EL3z7uu1R++GftOTaXAqEJ9ZG3Tq+W6+l6G/3RZZJh+J+uY2cX7TAOfzHr
        zKW7nKKLK5V+pe3PvWNxW4mlOCPRUIu5qDgRAMQ5txQVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO5BR65kg8PTWSzWXPnNbrH6bj+b
        xb1tv9gs3rWeY7G4PWk6iwOrx+WzpR5r975g9OjbsorR4+j+RWwenzfJBbBGcdmkpOZklqUW
        6dslcGXMXvaOqeCAWEXvtNAGxmtCXYycHBICJhKfNu1l7WLk4hAS2M0ocfzXCRaIhLhE87Uf
        7BC2sMTKf8/ZIYqeMErcWf6IuYuRg4NFQFXiyvkSEJNNQFPiwuRSkHIRAR2JfXsgypkFWhkl
        di7bxgySEBZwlNj26yLYTF4BXYmpyxdDLf7HJHHl8TRGiISgxMmZT8COYBYwk5i3+SHYLmYB
        aYnl/zhAwpwCLhJvnn1iArFFBZQlDmw7zjSBUXAWku5ZSLpnIXQvYGRexSiZWlCcm55bbFhg
        mJdarlecmFtcmpeul5yfu4kRHOpamjsYt6/6oHeIkYmD8RCjBAezkgjv110cyUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwHZ7AasA2Kf/trfSq1DmX
        Yg/t3NVuuDJ/w0etu53Xzq3bNHWqybJC1ZhPvmo2CtFKZg9sDvl0T3u36smKB+7Gm4JmGwYJ
        BZa9F/FlyP2zUurb0zcS131F2gQO7nT78deFxUryybojPftsk83b3n1RUjufPdVkC0fbgTOc
        sSfu2S1/v7g6eN2Rp12BW6cw1t8xyt6xrKfhyfq1sRpXyuZdqF4zJUpkF7M5j8u3TQY1yvGZ
        TcLHIvwSNN5MbmIRPiD3i8dZ9WC7Ps95qwdyuQ+4GVepRv88bTj1GO9BJoNcw3IVp516J09+
        T54YkTl/rsZlGR++wPY/Dhvi1fdlV2i4HWQ8kZy69LJGud0MxUs3lViKMxINtZiLihMBn1fx
        GeQCAAA=
X-CMS-MailID: 20220827160937epcas5p4bb20671f88d91eee6ac226dcb29b7e74
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_b38af_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
        <20220719135234.14039-1-ankit.kumar@samsung.com>
        <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
        <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
        <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
        <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_b38af_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Aug 23, 2022 at 04:46:18PM -0700, Casey Schaufler wrote:
>Limit io_uring "cmd" options to files for which the caller has
>Smack read access. There may be cases where the cmd option may
>be closer to a write access than a read, but there is no way
>to make that determination.
>
>Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>--
> security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
> 1 file changed, 32 insertions(+)
>
>diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>index 001831458fa2..bffccdc494cb 100644
>--- a/security/smack/smack_lsm.c
>+++ b/security/smack/smack_lsm.c
>@@ -42,6 +42,7 @@
> #include <linux/fs_context.h>
> #include <linux/fs_parser.h>
> #include <linux/watch_queue.h>
>+#include <linux/io_uring.h>
> #include "smack.h"
>
> #define TRANS_TRUE	"TRUE"
>@@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
> 	return -EPERM;
> }
>
>+/**
>+ * smack_uring_cmd - check on file operations for io_uring
>+ * @ioucmd: the command in question
>+ *
>+ * Make a best guess about whether a io_uring "command" should
>+ * be allowed. Use the same logic used for determining if the
>+ * file could be opened for read in the absence of better criteria.
>+ */
>+static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
>+{
>+	struct file *file = ioucmd->file;
>+	struct smk_audit_info ad;
>+	struct task_smack *tsp;
>+	struct inode *inode;
>+	int rc;
>+
>+	if (!file)
>+		return -EINVAL;
>+
>+	tsp = smack_cred(file->f_cred);
>+	inode = file_inode(file);
>+
>+	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
>+	smk_ad_setfield_u_fs_path(&ad, file->f_path);
>+	rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
>+	rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
>+
>+	return rc;
>+}
>+
> #endif /* CONFIG_IO_URING */
>
> struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
>@@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
> #ifdef CONFIG_IO_URING
> 	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
> 	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
>+	LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
> #endif

Tried this on nvme device (/dev/ng0n1).
Took a while to come out of noob setup-related issues but I see that
smack is listed (in /sys/kernel/security/lsm), smackfs is present, and
the hook (smack_uring_cmd) gets triggered fine on doing I/O on
/dev/ng0n1.

I/O goes fine, which seems aligned with the label on /dev/ng0n1 (which
is set to floor).

$ chsmack -L /dev/ng0n1
/dev/ng0n1 access="_"

I ran fio (/usr/bin/fio), which also has the same label.
Hope you expect the same outcome.

Do you run something else to see that things are fine e.g. for
/dev/null, which also has the same label "_".
If yes, I can try the same on nvme side.

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_b38af_
Content-Type: text/plain; charset="utf-8"


------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_b38af_--
