Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11B4D52D2
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 21:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiCJUHh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 15:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237904AbiCJUHh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 15:07:37 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440E1199D43
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 12:06:35 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id r11so7782782ioh.10
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 12:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=cPltiTh9wRUv4TpvV8s5G33dusVaaqJMQJVQKyysldU=;
        b=iTH9rbO+2Xksbzbp4a3ND18hYogcV8Bneo0RkKyaNUDBJ3RBkkI/0HLSnk/6i32LIg
         f7/sXPQGdr97J7yE7QPamdsrAuxTeVKv88XIylFnAjZmES93HRcOFhgnJHj+VV4mB1KP
         wpyvvSnf7GlUFWpNVIqvrp0XyQEpoLGDAg7CY8BnquRlmBRkjhRIf+k6jAC0TCFz+71E
         0CC1ipYzAIb7f8iYpDzh+lDPebyzxMXDzffCCbX9phIEExUeICtYOy7G3idmxoFfhSO5
         6AgTDUQopVXLU7XzcQdp/lxtMAoAl9LWjD6hwM+A2Ta4zVMMDAxQVyOmixPGU3TgHKO9
         I8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=cPltiTh9wRUv4TpvV8s5G33dusVaaqJMQJVQKyysldU=;
        b=TCXtS8kXEwPvyD0QVt+GtOOTXW88+AcAy6WYX0iknQDyC+ReI65Vc/Zu3m39ffyyz8
         sx9IVzEINpHbMEcUfCOd0sj8g3OADLtlqWpOkqgmwCYAMd/mvOsvaZ2Zha4y1+hmTBmB
         KYsLLNnzc9mtr9bSZ4optmO4hfJTgX8ldslnOkUIa5vd7x8YIP/uNbmH5KWcTw2hCEWu
         qGD8CJVLLjh3jx/7NlKKaU5fU7aHBKNELZK+FMvgMM6gWtgFwdMXFTF4KsmbaLTHdw5n
         R2ab+tiRTz6sdqRg+mGNL2GJVGdxBdNdXHqstbgHoUyFvrl+q39V6qGYdiDH+S8jBqyH
         C2Ug==
X-Gm-Message-State: AOAM533pNfDySsjLw8scs85O1FCQ42jASzYPX5qqiJw9iHVcMZQjbbGF
        JwcbniDJJ4hXMG9fOzS5enOCwPnGwQllTzVE
X-Google-Smtp-Source: ABdhPJyASmJnEwZL4vc7+ymplEdGHcb14/tLiTlPIStvu0bTlyCqJcWVHZW/7BquQJ388zJVP7uzlw==
X-Received: by 2002:a05:6638:16d2:b0:319:9cf8:fe18 with SMTP id g18-20020a05663816d200b003199cf8fe18mr5269530jat.202.1646942794423;
        Thu, 10 Mar 2022 12:06:34 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a18-20020a6b6c12000000b005ece5a4f2dfsm2991355ioh.54.2022.03.10.12.06.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 12:06:34 -0800 (PST)
Message-ID: <671f5715-9f94-568b-685f-ec6f16a875f9@kernel.dk>
Date:   Thu, 10 Mar 2022 13:06:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH[ io_uring: allow submissions to continue on error
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

By default, io_uring will stop submitting a batch of requests if we run
into an error submitting a request. This isn't strictly necessary, as
the error result is passed out-of-band via a CQE anyway. And it can be
a bit confusing for some applications.

Provide a way to setup a ring that will continue submitting on error,
when the error CQE has been posted.

There's still one case that will break out of submission. If we fail
allocating a request, then we'll still return -ENOMEM. We could in theory
post a CQE for that condition too even if we never got a request. Leave
that for a potential followup.

Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This has come up before, let's finally provide that flag as it makes
it easier for applications to deal with.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3145c9cacee0..229b31d644ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7801,8 +7801,14 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		/* will complete beyond this point, count as submitted */
 		submitted++;
-		if (io_submit_sqe(ctx, req, sqe))
-			break;
+		if (io_submit_sqe(ctx, req, sqe)) {
+			/*
+			 * Continue submitting even for sqe failure if the
+			 * ring was setup with IORING_SETUP_SUBMIT_ALL
+			 */
+			if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
+				break;
+		}
 	} while (submitted < nr);
 
 	if (unlikely(submitted != nr)) {
@@ -11265,7 +11271,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8bd4bfdd9a89..d2be4eb22008 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -101,6 +101,7 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
 
 enum {
 	IORING_OP_NOP,

-- 
Jens Axboe

