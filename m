Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D773F767224
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjG1Qmv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjG1Qmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:49 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650571984
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:43 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-785ccd731a7so26646939f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562562; x=1691167362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKpdtSS0oh3kDYJZ6F3Ca88AdtI49+W/nTkRsVyM1Ag=;
        b=zGoEYSJZYOD4AuwgEazidpIZwFo55y4OjaJiMaXAFFHq3iGLUh6WtqT6+T0597AiIH
         iM4ad5dZSzqSmj5Ycw0/cAhAzOR2HYX3ABHE9LA/9M133adNJ2o9B2FcpGA9BNg9Za/M
         1zDTorroC8j+40qoe0G0UXaXZONGtOAONO7I49IT8gw37YYYSMmGUevAOzb/klC53eO2
         3df5poDz8gYK/wFg/IhwQ9blj3CGXAwc4OVuUe5s5IM2Vs9Bl7OF3rIMw3no4MpuyNRq
         HFgJ0YFREspmzzaJx5p6rcaZZ/at3qcoDvFUFzlLXjw/acoOJLVNof2pkkIvV06PiuTr
         ukLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562562; x=1691167362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKpdtSS0oh3kDYJZ6F3Ca88AdtI49+W/nTkRsVyM1Ag=;
        b=iKIGtrWNMFKPHN0bnejeh1iPHkd4Tz2PvJVVH8CKRmsSS2fsByzcLKYj0ITRHcMc45
         O7KNTzgIKZU2tigrmhYRhb03ksdHx4NWEtj34CljpsY9susfMiquYb2yuF0lFoYYyBTX
         3/KS+indAeML7dDk2p+Qtpco/JHyrWCET4EfgPzxo64DVl+ATbQnemt1QvkE97gCoJed
         W1d1CPSwNl1xMIRD1pHtHH4t5DMilIOZsv0NhRxqTJWnkuew+YBqGbLzg8Gdu6OVtFuW
         PmbfWjXsWVUaapJLGkrWxqizvT2q142tV8CyhGYBNrogq7ctbhS59hC/2+WNF2sgZ6p+
         v1Cw==
X-Gm-Message-State: ABy/qLYVQPddHmfE3VQ4wXnrE/WiQoecAD+RrkzUz2IKphkfWp8mvmBk
        ykp6LnE4uEyi89ANCN95LdMwwmzQpM8/gNWTZyo=
X-Google-Smtp-Source: APBJJlEKPytW+OfDQhSyWzVRtAXpOYmeOF6DrcyBdt7ZoQAE4hMFG+ra7sFcdN6pXD1t9vvAltlP4Q==
X-Received: by 2002:a05:6602:3d5:b0:780:d65c:d78f with SMTP id g21-20020a05660203d500b00780d65cd78fmr98287iov.2.1690562562667;
        Fri, 28 Jul 2023 09:42:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/12] futex: Validate futex value against futex size
Date:   Fri, 28 Jul 2023 10:42:27 -0600
Message-Id: <20230728164235.1318118-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Ensure the futex value fits in the given futex size. Since this adds a
constraint to an existing syscall, it might possibly change behaviour.

Currently the value would be truncated to a u32 and any high bits
would get silently lost.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    | 8 ++++++++
 kernel/futex/syscalls.c | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index c0e04599904a..d0a43d751e30 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -86,6 +86,14 @@ static inline unsigned int futex_size(unsigned int flags)
 	return 1 << size; /* {0,1,2,3} -> {1,2,4,8} */
 }
 
+static inline bool futex_validate_input(unsigned int flags, u64 val)
+{
+	int bits = 8 * futex_size(flags);
+	if (bits < 64 && (val >> bits))
+		return false;
+	return true;
+}
+
 #ifdef CONFIG_FAIL_FUTEX
 extern bool should_fail_futex(bool fshared);
 #else
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 36824b64219a..d2b2bcf2a665 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -209,6 +209,9 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		if (!futex_flags_valid(flags))
 			return -EINVAL;
 
+		if (!futex_validate_input(flags, aux.val))
+			return -EINVAL;
+
 		futexv[i].w.flags = flags;
 		futexv[i].w.val = aux.val;
 		futexv[i].w.uaddr = aux.uaddr;
-- 
2.40.1

