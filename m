Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF334261333
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 17:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIHPLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 11:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgIHPKB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 11:10:01 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F0FC0A54DA
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 07:57:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u6so7486560iow.9
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 07:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=osHjEvbjXfkbEFqZ69CALfjJAGDfdpaT2338sWoPZJA=;
        b=H4eX7jalCJnj9V8ZZlcB+j7aCuU/D8RZ6pVdWE0HJ6+CBSVZ6Z5lWLkiMKjeTHtJ2m
         q9ytIf81jIc4xDXqMsRaHVn8j8UPYSIyiHGiDN9srEL1FmLUO1wwXbSR/5i+NwI7lUI0
         6WWwgf+JmUftiFqRSAj5NeGevm0rmsOB8n4asw3Z0gHOOpZHam1hJlXQMSScPPasUZOm
         hNhmRpxqZolcrcJ6sTHmzkbzvRssP9T8SKPc1SSMnfi0FgUqb5jU4SucBfrY0Di3XraR
         XFKek+oSE4jAG/iyvhPD/oXDrCu0fytsFso+9bEFnkd6LbSE0FuKdvxyPJ70MUKSpYng
         TK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=osHjEvbjXfkbEFqZ69CALfjJAGDfdpaT2338sWoPZJA=;
        b=L16/s0HjU0KItSiwZYobfYZH+854ZKolWi8h7m3KwksHDp2xwc7eYwXnRCh6uBAVOn
         1XwWZBaz7Fq/9BM1NGNJCgfAbLl1+jwhcvZzxeeSi7anltK0Yq6a4MTf/p/cukcSADSJ
         Wq5WFarIb+zsluIFFubkPDfb/IcD20yjorga5Tzst+M/lSfOawwAIONh9touCy0CMFRR
         0KwZmFoUI1CW0cNvmhZzEF60w5wHKBHrVrhJSfUCbpi93VxWgxKclsCXsT4beWBqiA6Q
         WCi7iAXmafNruA6SMg4ENvuBvVM1Ojcu0OblGdMxNTAGADGSkJtvbQ7KtPnzOps2WNd5
         6h/Q==
X-Gm-Message-State: AOAM530jze8VmjH+cdqrWxln2JKQF2gITyTj5dCH0Frc66w1DpKJDIQF
        sNFecPFtAC1Vm611HRLV9ord/g==
X-Google-Smtp-Source: ABdhPJwuhfsl+wYE9UI6ATZdlc3T9ISHJwNzaUp6TeLZ7zut9aQ+QxNEMA3/rXA2FF0wm2mG/UGQHQ==
X-Received: by 2002:a5d:9487:: with SMTP id v7mr20980682ioj.189.1599577070135;
        Tue, 08 Sep 2020 07:57:50 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h2sm8712943ioj.5.2020.09.08.07.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:57:49 -0700 (PDT)
Subject: Re: SQPOLL question
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
 <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
 <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
 <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
 <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk>
 <CAAss7+pjbh2puVsQTOt7ymKSmbruBZbaOvB8tqfw0z-cMuhJYg@mail.gmail.com>
 <cd44ec4a-41b9-0fa0-877d-710991b206f1@kernel.dk>
Message-ID: <dd59bd5e-cb81-98c1-4bc8-fa1a290429c2@kernel.dk>
Date:   Tue, 8 Sep 2020 08:57:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cd44ec4a-41b9-0fa0-877d-710991b206f1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 8:36 AM, Jens Axboe wrote:
> On 9/8/20 12:47 AM, Josef wrote:
>>> If you're up for it, you could just clone my for-5.10/io_uring and base
>>> your SQPOLL testing on that. Should be finished, modulo bugs...
>>
>> yeah did some benchmark tests and I'm quite impressed, however accept
>> op seems to fail with -EBADF when the flag IOSQE_ASYNC is set, is that
>> known?
> 
> Nope, ran a quick test case here on the current tree, works for me.
> 
> Are you using for-5.10 and SQEPOLL + ASYNC accept? I'll give that a
> test spin.

This should do it for your testing, need to confirm this is absolutely
safe. But it'll make it work for the 5.10/io_uring setup of allowing
file open/closes.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 80913973337a..e21a7a9c6a59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6757,7 +6757,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 
 	mutex_lock(&ctx->uring_lock);
 	if (likely(!percpu_ref_is_dying(&ctx->refs)))
-		ret = io_submit_sqes(ctx, to_submit, NULL, -1);
+		ret = io_submit_sqes(ctx, to_submit, ctx->ring_file, ctx->ring_fd);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
@@ -8966,6 +8966,11 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
+	if (p->flags & IORING_SETUP_SQPOLL) {
+		ctx->ring_fd = fd;
+		ctx->ring_file = file;
+	}
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;

-- 
Jens Axboe

