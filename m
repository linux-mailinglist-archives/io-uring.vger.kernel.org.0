Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB36C56CE77
	for <lists+io-uring@lfdr.de>; Sun, 10 Jul 2022 12:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiGJKBr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 06:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJKBr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 06:01:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23227644C;
        Sun, 10 Jul 2022 03:01:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o4so3603862wrh.3;
        Sun, 10 Jul 2022 03:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81hvwpBlfxQBH7APOHFnmGU6Oy26r79hMsY7b8ngUnA=;
        b=LaBR8No6eDA8e9Rql/Q8hpGkLLfuSD5/EMXQepcthh8cGp7UjbSFP1k9BsyzXUHnNy
         /Tpq4atRiIOMgSMJhXBMpDbldJ1g4b5k0jQCcLGn8jfGRoB7x/q/8CTNYecJfV/bu4Bo
         MERWiqyGTdkZFrXjwSPTS3Z7Yn+KmnzXcWrJiE8YusI2QP2MhVEHWCSDIj8F43mtTiYZ
         TEX0Th1RPImvZ0IVeKx1UMGztnYZGsQwur0HjBXDJzClOHfTYfzZhOg8rixDdLobrGug
         oZU4dhUGGW50vkkWM5cZ8x/txINWUWLWL80giRRZdFN9hqvwmfL00pFxL7khmpX45EwE
         onMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81hvwpBlfxQBH7APOHFnmGU6Oy26r79hMsY7b8ngUnA=;
        b=OZysnYXCVTEnCohH+iP4Pss5Txluegcmvu/9wkbPPrOzVlPI8DkC89dvYTjsiuB/ao
         q/2ls0nkVG4E+M/H0+BUzBWbW+dUWhSyjb4LIklt/tJFbgckmoXnjv9+NbWVSlKDTGe2
         f2W9/n9lq5svj9ic6lK9uTLiIm3Kjqb9bYEktdekjxGodFsjX7og7dokMrFUrEp4yTSQ
         uW1mDl7qhXkLUg0+nYwyuS5u49xdzcCMk4kgRbjEwuVw1i3ZBCh69K3mRBjVMYQdgbKf
         x8zjW2mPHeTAst99opb621OJ8zKKabbwCop0x4kpeDI6hGi1amxFA+O0WOiMoMjiXoCq
         45wg==
X-Gm-Message-State: AJIora92itfoN1M5MgKaa2RnbEOup2O2BHy5ZTZu+HaXvBfKjAEm93c/
        vFWl3DNa9nOzHg3++tKS7Rk=
X-Google-Smtp-Source: AGRyM1t1D8hDiyos2lkhzHSCdCKBxQy3yBejjsdGsbA5T1lQgpocurWl0ACdlPHS4JNTO6vo74nRPw==
X-Received: by 2002:a05:6000:54f:b0:21b:944c:c70b with SMTP id b15-20020a056000054f00b0021b944cc70bmr12117283wrf.572.1657447303959;
        Sun, 10 Jul 2022 03:01:43 -0700 (PDT)
Received: from localhost.localdomain (host-95-235-102-55.retail.telecomitalia.it. [95.235.102.55])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c434700b003a2da6b2cbesm3502026wme.33.2022.07.10.03.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 03:01:42 -0700 (PDT)
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
Subject: [PATCH] fs: Call kmap_local_page() in copy_string_kernel()
Date:   Sun, 10 Jul 2022 12:01:36 +0200
Message-Id: <20220710100136.25496-1-fmdefrancesco@gmail.com>
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

The use of kmap_atomic() is being deprecated in favor of kmap_local_page().

With kmap_local_page(), the mappings are per thread, CPU local, not
globally visible and can take page faults. Furthermore, the mappings can be
acquired from any context (including interrupts).

Therefore, use kmap_local_page() in copy_string_kernel() instead of
kmap_atomic().

Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
HIGHMEM64GB enabled.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---

I sent a first patch to fs/exec.c for converting kmap() and kmap_atomic()
to kmap_local_page():
https://lore.kernel.org/lkml/20220630163527.9776-1-fmdefrancesco@gmail.com/

Some days ago, Ira Weiny, while he was reviewing that patch, made me notice
that I had overlooked a second kmap_atomic() in the same file (thanks):
https://lore.kernel.org/lkml/YsiQptk19txHrG4c@iweiny-desk3/

I've been asked to send this as an additional change. This is why there will
not be any second version of that previous patch.

 fs/exec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4a2129c0d422..5fa652ca5823 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -639,11 +639,11 @@ int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
 		page = get_arg_page(bprm, pos, 1);
 		if (!page)
 			return -E2BIG;
-		kaddr = kmap_atomic(page);
+		kaddr = kmap_local_page(page);
 		flush_arg_page(bprm, pos & PAGE_MASK, page);
 		memcpy(kaddr + offset_in_page(pos), arg, bytes_to_copy);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		put_arg_page(page);
 	}
 
-- 
2.36.1

