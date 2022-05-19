Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4352D617
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbiESOaz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 10:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiESOay (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 10:30:54 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7EC32
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 07:30:52 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id f4so9405361lfu.12
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 07:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=v/9u8Imy9wLRfYHBxZ32XU6PyvAPyOYsjrvd7MK9l3c=;
        b=eaOE6+Y20AmRa6nSUYi7geIR7y/yn/2PASJIV5qzYyDB6uR6xRAVOuFN3V/UnNIH5M
         26SZQjvVd+k+L58xBa0lL+d/7x36ah8wc87F8UlsMb5wc09DF4Pc5bn1Ue9CNrngxEmQ
         rujvItsfN8DHXlCNtjEY9sOnjgY9+qPcFxdpugQM+pL8o3a9pjz/zI2ByEpjrazS9jj7
         RxRiQ2McaC+Q1r0odu1Huw8tyIP9HnMsjz+7KMrlms6HUv3h5dGyFqEn+lOxlHWKHapY
         fG61sn3MSGPU7p9Zu9P4jkwlQ5oJYJXIZun/HOlHmFqzFhu0XGxWPN44Grct9Rn5NWjz
         yXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=v/9u8Imy9wLRfYHBxZ32XU6PyvAPyOYsjrvd7MK9l3c=;
        b=7xr61p6MTFsjvhwsBSLizYRz6iOEZc0zOcS0ifyAxrhTVh5Gtxig1E90REGH+Txjy5
         Wu9ruVNRxBiyxdWiRLUeRER5xChO+I18CylTc8kWHsvi2rfvzJOWT5gzLp5G0MDGGqcU
         KvaUgnB1GKGroc9Iw2MRNTRwlHbeBDRLjYK/4WmPALpClgVxiKtEx0+cBbDiAjFhWHh/
         Cb6zBg4MALWXmX3iZ3HZK+ItDK6gKonQ4YjF3dThYZXzCt053Y0SMl9kRwY1OcYWORT4
         g5TrT3Sc5TCqYY11YZcLhWqte00zoRnPtz5C5uaCf701GF8BiW5ITGG8JEW/Kqf1rzeS
         mMcw==
X-Gm-Message-State: AOAM5337l/AqJQhAe4e9Fo9YzJdUkwTPC2dckMXHkkF4ebt+J43Tj3Ka
        0IJ0cIwR827mIWyaFt4IXujhDJSvm2l9IA==
X-Google-Smtp-Source: ABdhPJyRZHYDd6kSYR3c0rhv9w4eYdGNQxiFk/lUQ+ZunBiRsQGfvCDxNyRijOiVzLAzMZqW6VekGw==
X-Received: by 2002:ac2:482f:0:b0:472:47d5:ef32 with SMTP id 15-20020ac2482f000000b0047247d5ef32mr3587303lft.344.1652970650876;
        Thu, 19 May 2022 07:30:50 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.185])
        by smtp.gmail.com with ESMTPSA id d25-20020ac24c99000000b00477b624c0a8sm304402lfl.180.2022.05.19.07.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 07:30:50 -0700 (PDT)
Message-ID: <6f009241-a63f-ae43-a04b-62841aaef293@openvz.org>
Date:   Thu, 19 May 2022 17:30:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH v3] io_uring: fix incorrect __kernel_rwf_t cast
To:     Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc:     kernel@openvz.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
References: <2eb22fb3-40cc-48f6-8ba9-5faeae0b43ff@kernel.dk>
Content-Language: en-US
In-Reply-To: <2eb22fb3-40cc-48f6-8ba9-5faeae0b43ff@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently 'make C=1 fs/io_uring.o' generates sparse warning:

  CHECK   fs/io_uring.c
fs/io_uring.c: note: in included file (through
include/trace/trace_events.h, include/trace/define_trace.h, i
nclude/trace/events/io_uring.h):
./include/trace/events/io_uring.h:488:1:
 warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype] op_flags
    got restricted __kernel_rwf_t const [usertype] rw_flags

This happen on cast of sqe->rw_flags which is defined as __kernel_rwf_t,
this type is bitwise and requires __force attribute for any casts.
However rw_flags is a member of the union, and its access can be safely
replaced by using of its neighbours, so let's use poll32_events to fix
the sparse warning.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
v3:
  1) fix only hunk in TRACE_EVENT(io_uring_req_failed),
     rest ones was fixed by Christoph Hellwig already.
  2) updated patch description

v2: updated according to comments by Christoph Hellwig

---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 80d2588a090c..6ba87a290a24 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -520,7 +520,7 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->off		= sqe->off;
 		__entry->addr		= sqe->addr;
 		__entry->len		= sqe->len;
-		__entry->op_flags	= sqe->rw_flags;
+		__entry->op_flags	= sqe->poll32_events;
 		__entry->buf_index	= sqe->buf_index;
 		__entry->personality	= sqe->personality;
 		__entry->file_index	= sqe->file_index;
-- 
2.31.1

