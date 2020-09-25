Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EA2278C06
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 17:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgIYPGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 11:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgIYPGD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 11:06:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F35FC0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 08:06:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id md22so1456725pjb.0
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 08:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=U3rAWzNXCK2+8FhVnXH+5e+yrkKXpyTZGdaq+nvWyUc=;
        b=cYOlqM+L8QM8MrcUNE7QRrg2Klp4f6yWltaDPW8ZM9HNTjWe4nH9OS1emgzp2JGVSQ
         dRe1kbCn9zVMdUQoocpn7x74EzUBeR6AagoTPoYQ8JALjFrqMLxCa5q5HX9VGR0T89gO
         Sdq/8rFMMr4aA07iowAZ16ROjE/qu64GLyrAocP/PZEnyq3xPU5bvtBi5WnmzeKMfKjo
         sLZV6b66TqCGuebur0duC/3WWRzBy6N1aNPkUXtjlqXi5RYaPFwlxcwoxWf+FgKznmn/
         nCH1DnttpgkAhtUW+OU9rF+BuoKhNCJgh/xbnGKMh7scnDnxrLjZVnRKj8RCkp0KJaOm
         To/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U3rAWzNXCK2+8FhVnXH+5e+yrkKXpyTZGdaq+nvWyUc=;
        b=Cp+zVTnsnN0OpbyeIfWNl2T5iabCZzHRbgN53tpoT/plGckJ1UG757x4IAgG84luR9
         WaDJFDdW4Ey8IQnVUtnHQRUy0F8wQyQMi/NHlx+ueQegRn93oZsqT3/qNbSnIsgN3RGa
         cFmFBV8J68nCQ/iB3nwpjP6hOBDG818agMUuLtGNjpSR0SIu2+7Wm+zafizHf8wxmonY
         S7he/4ZE7bM7aV23yn3K3XZVvY874d91qkjaydOKLcuV40O2et3OKaFdBQi8AuVhjIar
         NDGYMYNYINe8QLEyXiTqMQ5I4GvkovOemFzzvLqp7HXZx0iSvuVibkOefxyoSrf7XVcR
         yTNQ==
X-Gm-Message-State: AOAM530ZqZAgabFNUxck9f0UuhG7RJ1uExLR96DecvjO6cNX2OQP0PT1
        wnzQTIrSW5QIbDN5dDLBUQGTMla578IdEQ==
X-Google-Smtp-Source: ABdhPJxJtfOYVFBTJJNZXEHmuB/YqcWz4aRUVbNICQYN7dIl2Vvqo1YDqhslIuG2Jj1WNrD5d/F/rw==
X-Received: by 2002:a17:90a:ea08:: with SMTP id w8mr80214pjy.124.1601046362242;
        Fri, 25 Sep 2020 08:06:02 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::11de? ([2620:10d:c090:400::5:c9f4])
        by smtp.gmail.com with ESMTPSA id o15sm2636357pgi.74.2020.09.25.08.06.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 08:06:01 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't unconditionally set plug->nowait = true
Message-ID: <1e9b172d-7f00-b651-7615-313ac055a1d6@kernel.dk>
Date:   Fri, 25 Sep 2020 09:06:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This causes all the bios to be submitted with REQ_NOWAIT, which can be
problematic on either btrfs or on file systems that otherwise use a mix
of block devices where only some of them support it.

For now, just remove the setting of plug->nowait = true.

Reported-by: Dan Melnic <dmm@fb.com>
Reported-by: Brian Foster <bfoster@redhat.com>
Fixes: b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ab16df31288..ad828fa19af4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6353,9 +6353,6 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  struct io_ring_ctx *ctx, unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
-#ifdef CONFIG_BLOCK
-	state->plug.nowait = true;
-#endif
 	state->comp.nr = 0;
 	INIT_LIST_HEAD(&state->comp.list);
 	state->comp.ctx = ctx;

-- 
Jens Axboe

