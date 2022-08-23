Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B759EFDA
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiHWXqZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 19:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiHWXqZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 19:46:25 -0400
Received: from sonic306-28.consmr.mail.ne1.yahoo.com (sonic306-28.consmr.mail.ne1.yahoo.com [66.163.189.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88ED8A1FA
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661298382; bh=aBkJ3Ci7nn2Ns1T52hI8dCjRTfzQV+SHzDpNnzjYPVI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=AsUQLTfdmBHNoJCqIWJeLrhvZOIaZLa/qgCJ7mf5zbxfjBiib+XHm1jTdyiOcLAM1TBBZBhu4Z0UWn7shcmqlp11FQh7kV/+MzFHIfDdsQA4eyykK4EzBEwAYkhVPShGraCPyeb3INjgLt4vTOWlmUVEq/k63+ybHeYHP6T5LnkqX4mt3BWtx2ksyX6+5tKzsEGyUUbSBz+X2Kic1DWfPSKjxEBP1CIY0ahII7a/wfFEbXluD7tC25yqN+qdwntUuT3ANRMbmeNHm0WJVDIk9EXaQzPIH2dcNRAQGAhDf6Q1PP6UBhX/J6WJCZ/arDnNVTmDMqRa0ED9BjoUr+V85w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661298382; bh=IpX39hitprxVvT+vmhQYtNd763Tc1EBKrj6rYiyZb7w=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=St6NHC3lcPyuIPjp4n1X0bqrnHL/gbI52PpqP65vUVjurGJaFrEhBzCMi4a5ckeS2luli5PmE1pPS/boirIizHBsDx/bU1p3TusB+QYV183IPmHLFH8K1IJ+SQgrxcpxInMS/wMZUcE5xcVY6q1Pw0WAcklP9EKdXd4aP/l28sh7CSu0IoQ7V4kYTxe7AcIy41OxCBYKZ+/jX/H9J7FtVY3z8cYapDnjbweHe/C4qmt4C1ROcyaPS/A4LWNT+1j72diX8rfwF9sXN1CJ1U+GRRFqNW3967dFuHonl8XKxJtXuarr2wLTz2Dqd519PNJBqF8ojawEdTut2DHPZh8AyA==
X-YMail-OSG: eECJpNUVM1mKj.S1NXCHAZAeb485PPmMKt6L1Oyo5j45CKsU6Wj_u71KyKm5vPg
 6s4EIK06nw9pxvlw1eYrbo_mKgAsHbkyv9Tjy8VwvxKUhlD9z.NRMwnFRQUPYDGgzFTqqDWWM94x
 iuZQWWYxkEqVUsqjIkqoeJC15DSA26fqDHHDxj6GKGXAkYZ.N0_PJXd6vuvXzYcY.WiXlD75a.Jv
 7IpYkPqpKwaxScCQnKqL0Yltl.X0WmOowWpaVWjPORG924GJNhRtfbqLrCRESFo8mTc6ydPLAU8y
 jx33WwFPvQDR13tzH7Xn_BYgtLVlXIZGEqPxl0faKf8YkFlnuQx6qTf06Om7W37Gl.qkaVAm9lOn
 blF8gqxxK7tnngm_Yj1qYInNZ.lwnCRmR9joco5vcLcw_DFdcUG5QBlM3_VL6e0dWqQ9I1sQV3Vc
 Bxhi5cFPr5PK7nPbtECgFOob4eFmuA0qRCJ3ZYUvk9hg79TxeELqc2CJ7BAIECL6SWqHa9tg1oIW
 fTsffv7_NRp7POIPpahaBBSmjQ9gEY05afgQuQ6JYtPHg685ffRYZaFZD7sFzeBbjJid3KmjuR77
 AsTUV5rNQ58qHYnzbmjbSrhvUaLaOQOo0fHDtXqTKu9i0yxQ6xV_hJGTal65Rbtqe_QUTUOF8qUN
 OmadFJmfKfVf4vG_qdLZe2j3LzMgJspRRfbdnqqekUkEGAqbt3jDSobxJ1kuzVebWmS1u5tfAi8J
 2j9ORNQSODRcv9kNEDf3W.e0I9Ih9xVC_Sqjk5W03aU0N406VPcS1BXMzjyLkBjFcBA58IBger5v
 l8W2Kqadk316MDxY9tnOidLukUMRJfro9Oyo0y35HAoU.bbUE5XBeiSNEi.ZE9kBNEYRrAAkowk9
 M77u1C.kIhb163PcoWeB9ud8Ot7hlvHxqCEJP4F8FVPfDBa2Hnl.24l57LvcLPejm.F_6w5sPvJk
 _BvoguBJLx0wTpHFZoZhyzvX3mf.WlFeul6DTm1ZpYW_RIadiII63.Iu.OcsxY2.u9Yc3OrTeps0
 3MsEaIIfKzC25XuzQwI7uqjl6RcFm8laGT5MCHVgUMXiXulwW5M_SubwRN7wIxsb6sFYj8VITWyF
 XwnzytK_uCCYsCnWQ62uY_nfmB2wLjOViVXBw8D99kD5rX9ziQrDGwnzip_WNWQHsBIIVFzOidmU
 8n9UtkCr3s3zT.UnB25O66Cnu1951FxA0q19lRpJTzB.S4eB.lQhRBKIyHjfNj_NsyKIiMxlUDrH
 1fPP7AWSjkcmh2ElmoAKOelxbgg36sQiGMrMEque2cAu1OyZZNbjcFyprl3lI2NFAaqofr0uHBk.
 Q_pedsv5BUkEEjdEyv9hrpz_i0ss0qPLPlMIw1T8AXGDil5jy67w0NZ_cnV2DcKawNgPFzRn_o8u
 _xzxpes37.yS0ISvOrHfvvTqUqevmfPvFYmTXHIVIetGSlWawK.m4baoJ0ZAqu7nWvDXoKlJUPGg
 mv0bh2X67.WyVD6wZ12tVMVXQ21pNmA0xAsxPPE3DmgxUNtxkKYIHe6rCWlAHmTr.7tSxKEemS4.
 Qw8C5kntnpx9fIIjeneyBkFmGrXh4pKsEdl7JOyr4ppn7T5AoNUS1SqgPL8XvtVJ70jsaeRYn4yt
 sySdUTDEFXXndj7g5IDo0tr1ALK_8f.ofGbmYKNK.nLdg7s9XUQ.gZy3NNsHylp3tPFr8_ufDP8j
 R6IRLQYJIABwVeSazPIlapMROcvnzcePameQJefd6Ewft6xY2eA9DkCJv5jrdRIH2fEUoP7Ne8r8
 cAjmGTih9pdU5BhO4trzPyHZh3tP55pbYTqJ_TdZL.xPtNAW9OuIT4NKd1tGrfGfEmKlpHotm.6c
 P7PQ.Ymef5xxZcbfYJV2oZTwXrZ2MntZrcKmzZus334VZxAtyD5tFsLcEMacD14Kg_p14OBRkTVQ
 X.Zr5sk8N7RKc5AoraJgiBkh1gjaxQyqLlVbrGTIgh7f7S6CDOzAaDIoSDp0w1JoqIP2XwceqTXD
 dLmj8fqQv0jSpsZnC9BaTk9gbOQEKlyZRfYpSrYqebfSBSX0AZwyJ7l4kMtBKaE89WidYgpGfmLw
 Pu7gyaF0zFg0sT.y0Gd9jfo6N0YMD6TC1ODz5c0T.OSyi2o2Q5nzEmu1zkeMx2TuEE8_58HVaItv
 HN21RrEKRmo9ysPCWkWxzhrlj9660q1xYiFrXQg4wmyLxEXpUszucVDVOohUYjQQa6UrJF7jeLsN
 CribaDI_Gn6tn1lL4punboGGebMqHziSv5SYUFQjLuiy8HGT5MiWDk.OZZgy4JPlRQ_3MLStFpMM
 bu2lk8NaUViXR7UloIq5ISLU-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 23 Aug 2022 23:46:22 +0000
Received: by hermes--production-ne1-6649c47445-kh29z (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID d12fd735438e984c3468fd9375b97c34;
          Tue, 23 Aug 2022 23:46:20 +0000 (UTC)
Message-ID: <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
Date:   Tue, 23 Aug 2022 16:46:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, io-uring@vger.kernel.org,
        joshi.k@samsung.com, casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20560 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Limit io_uring "cmd" options to files for which the caller has
Smack read access. There may be cases where the cmd option may
be closer to a write access than a read, but there is no way
to make that determination.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
--
 security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 001831458fa2..bffccdc494cb 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -42,6 +42,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/watch_queue.h>
+#include <linux/io_uring.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
@@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
 	return -EPERM;
 }
 
+/**
+ * smack_uring_cmd - check on file operations for io_uring
+ * @ioucmd: the command in question
+ *
+ * Make a best guess about whether a io_uring "command" should
+ * be allowed. Use the same logic used for determining if the
+ * file could be opened for read in the absence of better criteria.
+ */
+static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct file *file = ioucmd->file;
+	struct smk_audit_info ad;
+	struct task_smack *tsp;
+	struct inode *inode;
+	int rc;
+
+	if (!file)
+		return -EINVAL;
+
+	tsp = smack_cred(file->f_cred);
+	inode = file_inode(file);
+
+	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
+	smk_ad_setfield_u_fs_path(&ad, file->f_path);
+	rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
+	rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
+
+	return rc;
+}
+
 #endif /* CONFIG_IO_URING */
 
 struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
@@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
 #endif
 };
 

