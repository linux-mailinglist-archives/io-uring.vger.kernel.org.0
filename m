Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C756205C
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiF3Qfh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbiF3Qfg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:35:36 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6109F3AA55;
        Thu, 30 Jun 2022 09:35:35 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so2064079wma.4;
        Thu, 30 Jun 2022 09:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lZIrTmlOnvUkLrFbSOhPtwGibISpt/RODIchaEd1CDY=;
        b=gvOxH2z87z7QsFkRgTQuNhQyyz+dHV1+8rh1sM7GpDupM74IOa6Ym2zyVx4Y0mEnkA
         xFy3h+4BLgQAGQb7kHWwxfMcgIUz4Tef84LuOZORClSobvlsqYZZA4JRBDfKNY3iS9A8
         W3vDemOPYtYp6bt4LA+muwinmH5c50oo9YbK3ghNa7sz/mzg54ZgVTtrFKX2Cgzw+P3N
         ELSRjvVF4ivQ1YmTMe+MNMmYKoyNYpV+LtXu6h2BXUafKGQrVOGF0X6LVvrsdTzc/XfD
         EcDDOVPqA+9w2kvc7GCTWMKYCQjY0KUvF3eMQA1meIaibaLIqLPbyUm6YJoKiAbmsj+a
         uGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lZIrTmlOnvUkLrFbSOhPtwGibISpt/RODIchaEd1CDY=;
        b=GTEt4q69tWJR2OLe5ZtgtbMVaSXCHk6rFl+Ko7Mg3+tdejbLhNQrZ7yv8of3PJFB0A
         CRj0NMSrYyMIv1DmTeONmJqx/dc2hDoBsEdpee75d2hd37af4iHnJiMUjeMWfcckq5Ti
         1PTnrWm2Vt5xfFsjJOuTpXDNf0rxy/J20CCEq8e8o4TDSlpd5K2JFJ7F1gxs7Cdqcywa
         pS5vjHKig30sFfm7mYlue0GiTsNsLKeHnlVueUP6YEtZfvgErXKA7AhFJbciQXJgFIDx
         SpGPD4NzJAy9ZjbTrwVc8L7WrIefPO2dJs7lYYvoMaxbcZWLXilwm+Y6M27vCoNc5CIb
         acaw==
X-Gm-Message-State: AJIora8BaJ8TbUcC2B5jXAMHiQF7qD84IBqucxn25/bqj/KmDHxTyI+A
        UXuS0uhkwzeGqPuKuZLR8Fk=
X-Google-Smtp-Source: AGRyM1sQNe4+WIPmqW10XET/JjOyzodgMYKlJLfdcugPO9fE6FCvfEevPFPhlgS/sBSR469fLSNDFQ==
X-Received: by 2002:a1c:4b11:0:b0:3a0:4270:fcfa with SMTP id y17-20020a1c4b11000000b003a04270fcfamr12974836wma.53.1656606933805;
        Thu, 30 Jun 2022 09:35:33 -0700 (PDT)
Received: from localhost.localdomain (host-87-6-98-182.retail.telecomitalia.it. [87.6.98.182])
        by smtp.gmail.com with ESMTPSA id u3-20020a05600c210300b003a044fe7fe7sm7112303wml.9.2022.06.30.09.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 09:35:32 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nvdimm@lists.linux.dev,
        io-uring@vger.kernel.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
Date:   Thu, 30 Jun 2022 18:35:27 +0200
Message-Id: <20220630163527.9776-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The use of kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page().

With kmap_local_page(), the mappings are per thread, CPU local and not
globally visible. Furthermore, the mappings can be acquired from any
context (including interrupts).

Therefore, use kmap_local_page() in exec.c because these mappings are per
thread, CPU local, and not globally visible.

Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
HIGHMEM64GB enabled.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 fs/exec.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0989fb8472a1..4a2129c0d422 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -583,11 +583,11 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 
 				if (kmapped_page) {
 					flush_dcache_page(kmapped_page);
-					kunmap(kmapped_page);
+					kunmap_local(kaddr);
 					put_arg_page(kmapped_page);
 				}
 				kmapped_page = page;
-				kaddr = kmap(kmapped_page);
+				kaddr = kmap_local_page(kmapped_page);
 				kpos = pos & PAGE_MASK;
 				flush_arg_page(bprm, kpos, kmapped_page);
 			}
@@ -601,7 +601,7 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 out:
 	if (kmapped_page) {
 		flush_dcache_page(kmapped_page);
-		kunmap(kmapped_page);
+		kunmap_local(kaddr);
 		put_arg_page(kmapped_page);
 	}
 	return ret;
@@ -883,11 +883,11 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
 
 	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
 		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
-		char *src = kmap(bprm->page[index]) + offset;
+		char *src = kmap_local_page(bprm->page[index]) + offset;
 		sp -= PAGE_SIZE - offset;
 		if (copy_to_user((void *) sp, src, PAGE_SIZE - offset) != 0)
 			ret = -EFAULT;
-		kunmap(bprm->page[index]);
+		kunmap_local(src);
 		if (ret)
 			goto out;
 	}
@@ -1680,13 +1680,13 @@ int remove_arg_zero(struct linux_binprm *bprm)
 			ret = -EFAULT;
 			goto out;
 		}
-		kaddr = kmap_atomic(page);
+		kaddr = kmap_local_page(page);
 
 		for (; offset < PAGE_SIZE && kaddr[offset];
 				offset++, bprm->p++)
 			;
 
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		put_arg_page(page);
 	} while (offset == PAGE_SIZE);
 
-- 
2.36.1

