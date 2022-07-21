Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF657D04E
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiGUPvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiGUPvr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:51:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECD04E868
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:51:46 -0700 (PDT)
Received: from integral2.. (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id 9B4947E254;
        Thu, 21 Jul 2022 15:51:43 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658418705;
        bh=joJoeSk8fiLwl4RDyUpcYPSMZ7y2SRsdolkLAuAOiKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pym2sWZdwwXgvuaTru2I0UeyCwSDcvWIlyykS1aaj/ph8KI/YV2szC5Gd+X75WG/P
         /mPegIpS6h+JGLDcxQ2iB3gmfKt7gjNzAlXo1VV768InWX3Bf3AgNDk4buYN+imCa5
         YPHBuRiUdjHZdeEuFrruwumxYRvAXWJZKCDAxQvP68bqB1/SUOja3XL7Z/fWJM8Q8P
         kGpBunWL0DPAlScbUTfIgYcHyytpa5n1sc8Jr4XTMYWmHTOyNqjmPqJmJT3ygS4VVs
         wriv6HhEgUeR50bxBp85wSflgf9fiXi6ApVLUqGRQHSNhXSmRSZNLHYHt0v4DHLzhd
         BvMK9r90NxwqQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH] arch/generic: Rename `____sys_io_uring*` to `__sys_io_uring*`
Date:   Thu, 21 Jul 2022 22:51:38 +0700
Message-Id: <20220721155139.760436-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2a1a1e2d-6c9c-acc8-ac46-78d30ba35a6a@kernel.dk>
References: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org> <165841756488.96243.3609313686511469611.b4-ty@kernel.dk> <aa364933-4113-3e69-eed9-8fe6a8197f42@gnuweeb.org> <2a1a1e2d-6c9c-acc8-ac46-78d30ba35a6a@kernel.dk>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2732; i=ammarfaizi2@gnuweeb.org; h=from:subject; bh=joJoeSk8fiLwl4RDyUpcYPSMZ7y2SRsdolkLAuAOiKY=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBi2XXyd5ArAK3r75XWuCSSeukrG5tEUpSH+Q9kRfJF zB+BQ52JATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYtl18gAKCRA2T7o0/xcKS2xuB/ 4hEWowblBJHdq0q93eLKp6Y8ntzjvgmXbVRX1Ag80oDmf/RCrBRSXkYvikgT9Jbpq1xDUtcYAVrS+M 8tHC5BgoPWzeoEev6PGyh8wdFuQm5VYCdHPBIeYQhoJL75SqgjM3IJKCaASH9h/eDhUNy/VA7AT/OZ 2V7SUuCMwWPy0YSbfuMNoNCbn51Ehye0yFXL9dQlS8SfQFa9AfctUU0nX65/6A6y6hvkD1/FoDktUf f2lxT6PRO/BeoTuZvTk4lYldHswsPGRkE5uLH+LBwkZWT9nUUUs9VyQVA6Hf4IGlLWMKNbZc7zaMUE CH9LaM+dVFH3gmUqu7HfuPb13AfMoH
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In commit:

  4aa1a8aefc3dc3875621c64cef0087968e57181d ("Delete src/syscall.c and get back to use __sys_io_uring* functions")

I forgot to rename `____sys_io_uring*` to `__sys_io_uring*` in
arch/generic. This results in build error on archs other than
aarch64 and x86-64:

  error: implicit declaration of function `__sys_io_uring*`;

Rename `____sys_io_uring*` to `__sys_io_uring*`.
Thanks to the GitHub bot who spotted the issue quickly!

Fixes: 4aa1a8aefc3dc3875621c64cef0087968e57181d ("Delete src/syscall.c and get back to use __sys_io_uring* functions")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index e637890..5a172e1 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -5,25 +5,25 @@
 
 #include <fcntl.h>
 
-static inline int ____sys_io_uring_register(int fd, unsigned opcode,
-					    const void *arg, unsigned nr_args)
+static inline int __sys_io_uring_register(int fd, unsigned opcode,
+					  const void *arg, unsigned nr_args)
 {
 	int ret;
 	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int ____sys_io_uring_setup(unsigned entries,
-					 struct io_uring_params *p)
+static inline int __sys_io_uring_setup(unsigned entries,
+				       struct io_uring_params *p)
 {
 	int ret;
 	ret = syscall(__NR_io_uring_setup, entries, p);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
-					  unsigned min_complete, unsigned flags,
-					  sigset_t *sig, int sz)
+static inline int __sys_io_uring_enter2(int fd, unsigned to_submit,
+					unsigned min_complete, unsigned flags,
+					sigset_t *sig, int sz)
 {
 	int ret;
 	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
@@ -31,12 +31,12 @@ static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
-					 unsigned min_complete, unsigned flags,
-					 sigset_t *sig)
+static inline int __sys_io_uring_enter(int fd, unsigned to_submit,
+				       unsigned min_complete, unsigned flags,
+				       sigset_t *sig)
 {
-	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-				       _NSIG / 8);
+	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				     _NSIG / 8);
 }
 
 static inline int __sys_open(const char *pathname, int flags, mode_t mode)
-- 
2.34.1

