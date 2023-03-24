Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9968B6C7FF7
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 15:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCXOfq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 10:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjCXOfp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 10:35:45 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FDA10EB
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 07:35:40 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s1so986048ild.6
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 07:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679668539;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRfSWtLaxNh4KxM+MTQDmObepYKCm52fzT3iWsVoHy0=;
        b=uw6BSpconT7LeTDg06Rtz2boPdVyz4SOMFVNcteO8PeJktBSgVj32OMCE/lx95uyyM
         xrEKloNDHoja4PiY+6UiPCHXaKs/1AoNYxqydSRU/Khvot+jdm0Eu8OsZBdMnj0/zWk+
         D15tpdWuqLg6n1LT/TI//TnQZpwLZ/FjBfwiA8PObsEO7fmj9+4clk5Fo1s5sEUfPP3L
         pjx77wP52fUvppVF8Pi/qvnwY2XpXKcGWBU8s0CQro0XF4ZO6V2EuutJXrjszblQ/SJN
         GXsyBreUayQ+3JEaZCpuGdnSTQomet+3GE0TEfDqxoqWKcwGKRfBkVGYEtcp8A7b7DJb
         8oXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679668539;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aRfSWtLaxNh4KxM+MTQDmObepYKCm52fzT3iWsVoHy0=;
        b=C/BUZdeMjCdCUVp9f209mJXyJ+Hx1YOeeJ318Aj5soX5GWNVzQpzpjhwqRt5o0yGLb
         8sZ041psaSQsdMvhBzIajsv1iKlFs/ZdgWTGFMNZcYOaFOEvuuE8aoIVI+P8BsEFMEOf
         qAaDPxPckKcMAd69+CJWsCMi2+hvnidniyzbCccBIOGdIYM5P54exGtdFhflsWEIHAdw
         H3tIKXHtagDAVujOtZ38OfCtBYy/Vmrk3Ef4T/JUzHpJuqIpu2p82xu653BCQoiX8TuO
         r3zQ6Hxj2VvFSiBAGvYynSSGRkp6K2n+iQyNGGegwG21r8UKCK4Hb/gpD2TOEpMcShvB
         3NHw==
X-Gm-Message-State: AAQBX9c4wtpCsZBNpygBNum63HD2LihCPLsOaqezBthkBUS/jF7iL4nc
        79IwXXyUIVnjai2HbORq9ex3rr1SBKgn33yC0Ibqkw==
X-Google-Smtp-Source: AKy350YmgNXsJCJAuNBy6vfSFwetIQ0F5lDqEjJN0u2/f/khu6O60AGzBc8E0i+eTA7ZjXn7c8xVRA==
X-Received: by 2002:a05:6e02:1042:b0:323:504:cff6 with SMTP id p2-20020a056e02104200b003230504cff6mr1225316ilj.3.1679668539282;
        Fri, 24 Mar 2023 07:35:39 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c33-20020a023f61000000b003e80d0843e4sm6528486jaf.78.2023.03.24.07.35.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 07:35:38 -0700 (PDT)
Message-ID: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
Date:   Fri, 24 Mar 2023 08:35:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: transform single vector readv/writev into ubuf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's very common to have applications that use vectored reads or writes,
even if they only pass in a single segment. Obviously they should be
using read/write at that point, but...

Vectored IO comes with the downside of needing to retain iovec state,
and hence they require and allocation and state copy if they end up
getting deferred. Additionally, they also require extra cleanup when
completed as the memory as the allocated state memory has to be freed.

Automatically transform single segment IORING_OP_{READV,WRITEV} into
IORING_OP_{READ,WRITE}, and hence into an ITER_UBUF. Outside of being
more efficient if needing deferral, ITER_UBUF is also more efficient
for normal processing compared to ITER_IOVEC, as they don't require
iteration. The latter is apparent when running peak testing, where
using IORING_OP_READV to randomly read 24 drives previously scored:

IOPS=72.54M, BW=35.42GiB/s, IOS/call=32/31
IOPS=73.35M, BW=35.81GiB/s, IOS/call=32/31
IOPS=72.71M, BW=35.50GiB/s, IOS/call=32/31
IOPS=73.29M, BW=35.78GiB/s, IOS/call=32/32
IOPS=73.45M, BW=35.86GiB/s, IOS/call=32/32
IOPS=73.19M, BW=35.74GiB/s, IOS/call=31/32
IOPS=72.89M, BW=35.59GiB/s, IOS/call=32/31
IOPS=73.07M, BW=35.68GiB/s, IOS/call=32/32

and after the change we get:

IOPS=77.31M, BW=37.75GiB/s, IOS/call=32/31
IOPS=77.32M, BW=37.75GiB/s, IOS/call=32/32
IOPS=77.45M, BW=37.81GiB/s, IOS/call=31/31
IOPS=77.47M, BW=37.83GiB/s, IOS/call=32/32
IOPS=77.14M, BW=37.67GiB/s, IOS/call=32/32
IOPS=77.14M, BW=37.66GiB/s, IOS/call=31/31
IOPS=77.37M, BW=37.78GiB/s, IOS/call=32/32
IOPS=77.25M, BW=37.72GiB/s, IOS/call=32/32

which is a nice win as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c233910e200..5c998754cb17 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -402,7 +402,22 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 			      req->ctx->compat);
 	if (unlikely(ret < 0))
 		return ERR_PTR(ret);
-	return iovec;
+	if (iter->nr_segs != 1)
+		return iovec;
+	/*
+	 * Convert to non-vectored request if we have a single segment. If we
+	 * need to defer the request, then we no longer have to allocate and
+	 * maintain a struct io_async_rw. Additionally, we won't have cleanup
+	 * to do at completion time
+	 */
+	rw->addr = (unsigned long) iter->iov[0].iov_base;
+	rw->len = iter->iov[0].iov_len;
+	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
+	/* readv -> read distance is the same as writev -> write */
+	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
+			(IORING_OP_WRITE - IORING_OP_WRITEV));
+	req->opcode += (IORING_OP_READ - IORING_OP_READV);
+	return NULL;
 }
 
 static inline int io_import_iovec(int rw, struct io_kiocb *req,

-- 
Jens Axboe

