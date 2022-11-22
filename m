Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA0C633A4F
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 11:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiKVKlt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 05:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiKVKkz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 05:40:55 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0FC1117E
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 02:35:39 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221122103537euoutp01e9f88b433c364db6fa14edd1ede95904~p4byjVEcQ1595915959euoutp01M
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 10:35:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221122103537euoutp01e9f88b433c364db6fa14edd1ede95904~p4byjVEcQ1595915959euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669113337;
        bh=475DnqK0zyMSgEqbuWUeMLIDBvQBj+5UKcxxWGfkf8s=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=KIPhMK2I42BGejx+k4PWp5of4vM0R1zpiRa64fkBXy3UZ5Itx28fv87WHW9TmpU5z
         ctO9DXD+iCwfOZnAAN32UxW4XbqFSPEIkhV9P4E0UA2toIEwyh3bFsW8RAHlCyo6ZY
         DLMie0OCCqo1okwd1nVrdW1FnvV/0C4Sylv9b+gQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221122103537eucas1p28ba66d2d8642a29f274b6aadf9dcffd5~p4byYp61T2716227162eucas1p2D;
        Tue, 22 Nov 2022 10:35:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id AE.5B.10112.8F5AC736; Tue, 22
        Nov 2022 10:35:36 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221122103536eucas1p28f1c88f2300e49942c789721fe70c428~p4byCMpQM0354803548eucas1p23;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221122103536eusmtrp210425cd0a51fc94248d5d37c82f1a41f~p4byBovo01079310793eusmtrp2U;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
X-AuditID: cbfec7f4-d09ff70000002780-7b-637ca5f82e11
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 56.0D.08916.8F5AC736; Tue, 22
        Nov 2022 10:35:36 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221122103536eusmtip2c0e3d5aef6310acdd8e7d1e73a21a007~p4bx1TXdU2765327653eusmtip2N;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
Received: from localhost (106.110.32.33) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 22 Nov 2022 10:35:29 +0000
From:   Joel Granados <j.granados@samsung.com>
To:     <mcgrof@kernel.org>, <ddiss@suse.de>, <joshi.k@samsung.com>,
        <paul@paul-moore.com>
CC:     <ming.lei@redhat.com>, <linux-security-module@vger.kernel.org>,
        <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        Joel Granados <j.granados@samsung.com>
Subject: [RFC v2 1/1] Use a fs callback to set security specific data
Date:   Tue, 22 Nov 2022 11:31:44 +0100
Message-ID: <20221122103144.960752-2-j.granados@samsung.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221122103144.960752-1-j.granados@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [106.110.32.33]
X-ClientProxiedBy: CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWy7djP87o/ltYkGyxYYm2x+m4/m8XX/9NZ
        LN61nmOx+NDziM3ixoSnjBaHJjczWdyeNJ3Fgd3j8tlSj02rOtk81u59wejxft9VNo/Np6s9
        Pm+SC2CL4rJJSc3JLEst0rdL4MponnqApeC7acWT3/vYGxjX6XYxcnJICJhIdOz6xQZiCwms
        YJR4eSS2i5ELyP7CKPFt5QRWCOczo0Tb9ResMB03tl5kgkgsZ5TY/vAfO1zVjM5eFghnM6PE
        nN2PmUBa2AR0JM6/ucMMYosIREhsevMLrINZYC6jxN0Pt8ASwgKuEi9uXASzWQRUJU73XwW7
        ilfARuLQh7tMELvlge6YztjFyMHBKWArse1QNkSJoMTJmU9YQGxmoJLmrbOZIWwJiYMvXjBD
        tCpKbJnzHeqFWom9zQfAbpAQ+MIhsfPPSaiEi8Tlvu/sELawxKvjW6BsGYn/O+dD3ZAtsXPK
        LqihBRKzTk5lA7lHQsBaou9MDkTYUeLuzgNMEGE+iRtvBSHO4ZOYtG06M0SYV6KjTWgCo8os
        JA/MQvLALCQPLGBkXsUonlpanJueWmyUl1quV5yYW1yal66XnJ+7iRGYck7/O/5lB+PyVx/1
        DjEycTAeYpTgYFYS4a33rEkW4k1JrKxKLcqPLyrNSS0+xCjNwaIkzss2QytZSCA9sSQ1OzW1
        ILUIJsvEwSnVwBS5zvT63+5E8ZUnvzTfvz4lVDe8+ts8s7ftGfK8nG9k//j1OOrMnPSxar+d
        YUaO1MrjHj7nZgSEzlluuOmYyRZtS08D94Xf7kxMr5ub4rTc9VLjQnuldNfO7KC6Oy6xoprb
        OBdmBF4/9FxO/MD7mxwOQXvuMswtfNMg8SGqxXieQomO4tUZKZyefNnfu58edRVujoypUWyd
        llBwe9W/wsXzfb6H8+nN+PfZu+9daqdFoghnv+q7KK0vnV05XrI35x362RxqHLR4k+9iT5NG
        /r/XZ7svmx+kxff9wo7/Ado/LgSYMmzs+LX58rfukoZV26UrNjHcTVzct0u74N6j1x18u87m
        ntJVmnT9t9RpViWW4oxEQy3mouJEADv/S2SoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t/xe7o/ltYkG3x7rWSx+m4/m8XX/9NZ
        LN61nmOx+NDziM3ixoSnjBaHJjczWdyeNJ3Fgd3j8tlSj02rOtk81u59wejxft9VNo/Np6s9
        Pm+SC2CL0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst0rdL
        0MtonnqApeC7acWT3/vYGxjX6XYxcnJICJhI3Nh6kamLkYtDSGApo8TN1XsZIRIyEp+ufGSH
        sIUl/lzrYoMo+sgosXz/GTaQhJDAZkaJfQclQWw2AR2J82/uMIPYIgIREpve/GIHaWAWmMso
        cffDLbCEsICrxIsbF8FsFgFVidP9V8EG8QrYSBz6cJcJYpu8RNv16UBXcHBwCthKbDuUDWIK
        AZUs7PKGqBaUODnzCQuIzQxU3bx1NjOELSFx8MULZogpihJb5nxnhbBrJTpfnWabwCgyC0n7
        LCTts5C0L2BkXsUoklpanJueW2yoV5yYW1yal66XnJ+7iREYkduO/dy8g3Heq496hxiZOBgP
        MUpwMCuJ8NZ71iQL8aYkVlalFuXHF5XmpBYfYjQF+nIis5Rocj4wJeSVxBuaGZgamphZGpha
        mhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTAZrq4z01jBq9swy9yO9fP3dVdka7NMVn14
        y9+0qXau3q/tNcebNlednnXwbPaujg6OwruyOibHzs28qXH3tXbn2oDuk3XdtY2WWc4fGGf9
        W77l0mvb2YJx22vFjX7JLb269d1B00XzDsvo/+Ji9mVaNnWnceXrV3PbrN68/rn+Vut+1mxd
        bvmieWuPewt7lzjyJS3as2SN0Rqri/ZaX3Md3Z4mhywotJPt28FxTeTxrj/nHx4WPL1R/Ni1
        nwpT43ym21bXRj3+/WWTPaeekop1SuOb8xIv5lknaWY+/372yF7Vazt17qYy7a6fx8bwSdvw
        Y/eXwrWOfK80jQ/rCnNOU9D4saui7ZfJ0ut969+YKbEUZyQaajEXFScCABdfTG1RAwAA
X-CMS-MailID: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
X-Msg-Generator: CA
X-RootMTR: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
References: <20221122103144.960752-1-j.granados@samsung.com>
        <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 drivers/nvme/host/core.c      | 10 ++++++++++
 include/linux/fs.h            |  2 ++
 include/linux/lsm_hook_defs.h |  3 ++-
 include/linux/security.h      | 16 ++++++++++++++--
 io_uring/uring_cmd.c          |  3 ++-
 security/security.c           |  5 +++--
 security/selinux/hooks.c      | 16 +++++++++++++++-
 7 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f94b05c585cb..275826fe3c9e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2011-2014, Intel Corporation.
  */
 
+#include "linux/security.h"
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-integrity.h>
@@ -3308,6 +3309,13 @@ static int nvme_dev_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+int nvme_uring_cmd_sec(struct io_uring_cmd *ioucmd,  struct security_uring_cmd *sec)
+{
+	sec->flags = 0;
+	sec->flags = SECURITY_URING_CMD_TYPE_IOCTL;
+	return 0;
+}
+
 static const struct file_operations nvme_dev_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nvme_dev_open,
@@ -3315,6 +3323,7 @@ static const struct file_operations nvme_dev_fops = {
 	.unlocked_ioctl	= nvme_dev_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_dev_uring_cmd,
+	.uring_cmd_sec	= nvme_uring_cmd_sec,
 };
 
 static ssize_t nvme_sysfs_reset(struct device *dev,
@@ -3982,6 +3991,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_chr_uring_cmd,
 	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
+	.uring_cmd_sec	= nvme_uring_cmd_sec,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e654435f1651..af743a2dd562 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2091,6 +2091,7 @@ struct dir_context {
 
 struct iov_iter;
 struct io_uring_cmd;
+struct security_uring_cmd;
 
 struct file_operations {
 	struct module *owner;
@@ -2136,6 +2137,7 @@ struct file_operations {
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
+	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index ec119da1d89b..6cef29bce373 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -408,5 +408,6 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 #ifdef CONFIG_IO_URING
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
-LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
+LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd,
+	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*))
 #endif /* CONFIG_IO_URING */
diff --git a/include/linux/security.h b/include/linux/security.h
index ca1b7109c0db..146b1bbdc2e0 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2065,10 +2065,20 @@ static inline int security_perf_event_write(struct perf_event *event)
 #endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_IO_URING
+enum security_uring_cmd_type
+{
+	SECURITY_URING_CMD_TYPE_IOCTL,
+};
+
+struct security_uring_cmd {
+	u64 flags;
+};
 #ifdef CONFIG_SECURITY
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
-extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
+extern int security_uring_cmd(struct io_uring_cmd *ioucmd,
+		int (*uring_cmd_sec)(struct io_uring_cmd *,
+			struct security_uring_cmd*));
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2078,7 +2088,9 @@ static inline int security_uring_sqpoll(void)
 {
 	return 0;
 }
-static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
+static inline int security_uring_cmd(struct io_uring_cmd *ioucmd,
+		int (*uring_cmd_sec)(struct io_uring_cmd *,
+			struct security_uring_cmd*))
 {
 	return 0;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e50de0b6b9f8..2f650b346756 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,10 +108,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = req->file;
 	int ret;
 
+	//req->file->f_op->owner->ei_funcs
 	if (!req->file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
-	ret = security_uring_cmd(ioucmd);
+	ret = security_uring_cmd(ioucmd, req->file->f_op->uring_cmd_sec);
 	if (ret)
 		return ret;
 
diff --git a/security/security.c b/security/security.c
index 79d82cb6e469..d3360a32f971 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2667,8 +2667,9 @@ int security_uring_sqpoll(void)
 {
 	return call_int_hook(uring_sqpoll, 0);
 }
-int security_uring_cmd(struct io_uring_cmd *ioucmd)
+int security_uring_cmd(struct io_uring_cmd *ioucmd,
+	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*))
 {
-	return call_int_hook(uring_cmd, 0, ioucmd);
+	return call_int_hook(uring_cmd, 0, ioucmd, uring_cmd_sec);
 }
 #endif /* CONFIG_IO_URING */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f553c370397e..9fe3a230c671 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -21,6 +21,8 @@
  *  Copyright (C) 2016 Mellanox Technologies
  */
 
+#include "linux/nvme_ioctl.h"
+#include "linux/security.h"
 #include <linux/init.h>
 #include <linux/kd.h>
 #include <linux/kernel.h>
@@ -6999,18 +7001,30 @@ static int selinux_uring_sqpoll(void)
  * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
  *
  */
-static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
+static int selinux_uring_cmd(struct io_uring_cmd *ioucmd,
+	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*))
 {
 	struct file *file = ioucmd->file;
 	struct inode *inode = file_inode(file);
 	struct inode_security_struct *isec = selinux_inode(inode);
 	struct common_audit_data ad;
+	const struct cred *cred = current_cred();
+	struct security_uring_cmd sec_uring = {0};
+	int ret;
 
 	ad.type = LSM_AUDIT_DATA_FILE;
 	ad.u.file = file;
 
+	ret = uring_cmd_sec(ioucmd, &sec_uring);
+	if (ret)
+		return ret;
+
+	if (sec_uring.flags & SECURITY_URING_CMD_TYPE_IOCTL)
+		return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_op);
+
 	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
 			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
+
 }
 #endif /* CONFIG_IO_URING */
 
-- 
2.30.2

