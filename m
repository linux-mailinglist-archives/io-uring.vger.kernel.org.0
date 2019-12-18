Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B65124EF5
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfLRRSz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:55 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42442 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:55 -0500
Received: by mail-io1-f68.google.com with SMTP id n11so1250564iom.9
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYrBHxXYiIqMn7AyRM7VutEfqO7rU2p+V8uEiPaEELo=;
        b=zF0PTpKsiBo0vPQX7SwAajHnVDffHFrLeRquX4ty2BsNrIEJK/xeFJDEYS7iGFOCSi
         VkEr4zahxTs0fjW2dbarecpseSWcw8zKyDm7Ew8YzIiXRALZeVcEg+ZQZwpxfqbCq+jT
         IsImYzgYM/sWNWnw0n1ITr740vlPpCG1ods+mCtE+Eics0kR6vJOrm/wVvBdwCp+pMAG
         wL5oT8JHPbwBRXynRNFBt/n35+6KOUaBsojWKSm8oiSmzgbB+jJgJNTojehG4Phc5Q6Z
         TQsYFH1+oavMqYjeP9zT1ajlrX5kMPKAqva/l0Ud9iKDMcsh1+Lm6Bj6S9V08TH6hLrE
         U83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYrBHxXYiIqMn7AyRM7VutEfqO7rU2p+V8uEiPaEELo=;
        b=MN/wja/k/hgwuJvqMsdeWjI8G0InhUqKyvBb1fJ4UlmxFBmWu++3NAJiklLVsR9K0D
         qCY/K+/EfvmUnrMAzi+DrPNGMy51YJZXpCHLlm6oIJWE0sANEbCOmYyt3Ej29QVRg3hD
         LyRdTR/c/mJxe1VIquK3NBINdihmfkWONBMDt1RMuH6xK8q+ddymIf+AOb04+XPXz9BO
         hfQMYPkX26P7tQGMNU60uANSC1N+0rd/SJe5fLNcavb8Ag2dXH+riBqBICdsewUwggS+
         ml/+o55zAuABKqFOVDXz1eLyDe5G075FfeXUh2vfKvEm76bvI4KGB/Pbd+CTxeUrD119
         OYow==
X-Gm-Message-State: APjAAAXjbcdfGRXR+cQuNMtqe6KC/jJWRE5Ru1aywYvPNEdtR6X1G9DC
        maxKmAMHXO7otrXf0oa/wA1HZ6Sp5d8AkQ==
X-Google-Smtp-Source: APXvYqzoOVRr62rAtCafcWIWDAIJCEiVPJV++DBN8nFqsM7nx+nmQDfSXXLCA9X+6PUau7CqHuHPew==
X-Received: by 2002:a5e:c601:: with SMTP id f1mr2580631iok.208.1576689534581;
        Wed, 18 Dec 2019 09:18:54 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:54 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/13] io_uring: don't wait when under-submitting
Date:   Wed, 18 Dec 2019 10:18:35 -0700
Message-Id: <20191218171835.13315-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

There is no reliable way to submit and wait in a single syscall, as
io_submit_sqes() may under-consume sqes (in case of an early error).
Then it will wait for not-yet-submitted requests, deadlocking the user
in most cases.

Don't wait/poll if can't submit all sqes

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74dc9de94117..b7800def3090 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5133,6 +5133,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit)
+			goto out;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
@@ -5146,6 +5149,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 	}
 
+out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.1

