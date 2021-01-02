Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C32E87D4
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbhABPWb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbhABPWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:07 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53661C0613CF;
        Sat,  2 Jan 2021 07:21:26 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id e25so13776093wme.0;
        Sat, 02 Jan 2021 07:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XV9zM74CTwn4+eOGP/R29Owp4dxby4wP3b3oxVzvafI=;
        b=SFOgPJzQdnQe9hMNyQxyQbgPlbohVEDn3pDwGhwgxKOSsT8dm8/2bAbej1/rjSTtri
         ukGLApzLogZWfv11VeVtgIPhW6awxqXpE7QP3IlLTnYIPyP+iFk5IGsXXgmVvQOPQxZJ
         TCphjgqog4CNIRgdfbE+pXjdH5B5VbGFy1aYwjG6mm7JM1Oh8PCoE4aQ4Y2EzwoFbFjI
         E/6LmzLKTkRVgnRsa5HlcvVzmcRJ4wXrxPM54VS/zG84Nv8uYfyIOnG5YqTrIUPT+4+Q
         x1zwgtU8+DEwQchxEcFpE1ikA3Qg3TbyJ0cGMNrqU3UEuyi35sfE5gXzZ3rw3LPWBlKi
         a/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XV9zM74CTwn4+eOGP/R29Owp4dxby4wP3b3oxVzvafI=;
        b=JHPvl42CtZQ+9ghptE4CRi99VwVCUQK5I/Wfua7wZuE+/AUhxngjFUsS7AklCo7Yix
         kfnUUrJLCLvwQHbMkjGNfVOjIDrfEIB/p1wpNwWoShAl8nhp8OD/UgD+NxLbDWX9v1is
         vsyxaPJhY0RdGDbVkj6p5IZ1ZclwP5U9+HuYRtw2rCpsPRG/HTuXAQL/jeLVwTqGqi14
         bVOL6zVHnXvFHsimBYZZYO3W1gp+YR2oCZpEXT5KOXP+RNs2biIvaC1gJ2lgwxR85KBx
         7qg4W75H2SQO0KcBRKEMJXzyaLYntN3Zky6I4q+2EA8CBFPB3eU5z9nJQwqXUsn5BcoH
         6DqQ==
X-Gm-Message-State: AOAM531OU0U/YorZBuev68TnwtEiny8QRgwVV0SrgUfWnWF8hKTWD48p
        U05jOzAhiWfnz6xn8Vj7p7vUAr1NY2Ewfg==
X-Google-Smtp-Source: ABdhPJxwu7FOcxfliyqioKGivmZLgq8xfpPKYLmREFyeGepQEsU4cSXXuM6gY2U1D8AB/l/odvpL3Q==
X-Received: by 2002:a7b:c04c:: with SMTP id u12mr20318416wmc.185.1609600884854;
        Sat, 02 Jan 2021 07:21:24 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 2/7] bvec/iter: disallow zero-length segment bvecs
Date:   Sat,  2 Jan 2021 15:17:34 +0000
Message-Id: <b46b8c1943bbefcb90ea5c4dd9beaad8bbc15448.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

zero-length bvec segments are allowed in general, but not handled by bio
and down the block layer so filtered out. This inconsistency may be
confusing and prevent from optimisations. As zero-length segments are
useless and places that were generating them are patched, declare them
not allowed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/filesystems/porting.rst | 7 +++++++
 lib/iov_iter.c                        | 2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 867036aa90b8..c722d94f29ea 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -865,3 +865,10 @@ no matter what.  Everything is handled by the caller.
 
 clone_private_mount() returns a longterm mount now, so the proper destructor of
 its result is kern_unmount() or kern_unmount_array().
+
+---
+
+**mandatory**
+
+zero-length bvec segments are disallowed, they must be filtered out before
+passed on to an iterator.
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..7de304269641 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -72,8 +72,6 @@
 	__start.bi_bvec_done = skip;			\
 	__start.bi_idx = 0;				\
 	for_each_bvec(__v, i->bvec, __bi, __start) {	\
-		if (!__v.bv_len)			\
-			continue;			\
 		(void)(STEP);				\
 	}						\
 }
-- 
2.24.0

