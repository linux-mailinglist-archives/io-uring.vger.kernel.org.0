Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F05B5B1CC0
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiIHMWx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiIHMWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:49 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB46E1316CA
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id y3so37675064ejc.1
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=UCrnjc/M5Xx+EyDrYtQMAIxMwOtjvwYqP0u2cAd22I8=;
        b=D6T7raRpuFsJ27rgeDhm4bviuKPFOiqnsWzPhDSIwWZEYSLZw5sA4pEppSl0iWp+cA
         RK0Nnv9ssov5u8FDvocbmFI42Vv28cWGqQ7WPIIUo3AMoAY0Cb7K/LOlyd3x/02SQOV4
         Wsmnaqd+bAtDQJGk1aZNh8vtJzOEua/QiwJA3qhH4GmPWzfugwLQrlv4H4Z0cg2ZsaY5
         Z4bHx7rLqpuP7D7Bj9vK0iW2ETA5YPP0h3R+DJT3ZVbk0ni/c5JpAO8ryvbQ28NHSYxi
         TWh6etHbZxQS4yO3/kLp6iusoA8Rc2t7wSaQCR+BDyCIVkCCP4jUm2/X0Keoz3YC86LB
         FaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UCrnjc/M5Xx+EyDrYtQMAIxMwOtjvwYqP0u2cAd22I8=;
        b=cMU+a3u/uMQlaWX5SNC+ckLDapVMTYdT6KrMoDFcJjORHa3LsYtipego5W4HqTI3Xe
         lsw8HzYhUzJr4+dVz4gaRanL+PwhuVbWFFyiy8JEdfpFC66HKWHi9IxfygpsC51cgxgI
         B4hSB8OtNT3r/kOLfibHOtm8PfW1Ge0mV9Jo5tz26beW0oKRTzkNtvOejmYbyywkQZgR
         F/Mh+j8kqGU6JACCnZnm0Bqs33en4M/QCtZyvBFi9EKSC92RbwZIoLMfkMku3upOuUr1
         gcWjRt+uWXZLMYUXEsPh8VYwgdoSHcRLj0ZN85v9FFwOg+JNZgjFDs06d73By+gbp3T3
         wWAw==
X-Gm-Message-State: ACgBeo2G6VfPEULdB0xC9PX8K4b3UX1L9cIQjOhnpOwvMLfVHhMAaUp2
        /KTcq70sGiZ2UCA6j+uFLyaXcAYAqjI=
X-Google-Smtp-Source: AA6agR6nOzkVl2CTS6DNle+El+0cp0zT1pOxYxYw9/CGOn/5dt5WisM4vuDMryCyrVwdFxhCA6grrg==
X-Received: by 2002:a17:906:ef90:b0:730:9cd8:56d7 with SMTP id ze16-20020a170906ef9000b007309cd856d7mr5620858ejb.94.1662639759723;
        Thu, 08 Sep 2022 05:22:39 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/8] io_uring/net: add non-bvec sg chunking callback
Date:   Thu,  8 Sep 2022 13:20:32 +0100
Message-Id: <cda3dea0d36f7931f63a70f350130f085ac3f3dd.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
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

Add a sg_from_iter() for when we initiate non-bvec zerocopy sends, which
helps us to remove some extra steps from io_sg_from_iter(). The only
thing the new function has to do before giving control away to
__zerocopy_sg_from_iter() is to check if the skb has managed frags and
downgrade them if so.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index ff1fed00876f..4dbdb59968c3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -948,6 +948,13 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static int io_sg_from_iter_iovec(struct sock *sk, struct sk_buff *skb,
+				 struct iov_iter *from, size_t length)
+{
+	skb_zcopy_downgrade_managed(skb);
+	return __zerocopy_sg_from_iter(NULL, sk, skb, from, length);
+}
+
 static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 			   struct iov_iter *from, size_t length)
 {
@@ -958,13 +965,10 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	ssize_t copied = 0;
 	unsigned long truesize = 0;
 
-	if (!shinfo->nr_frags)
+	if (!frag)
 		shinfo->flags |= SKBFL_MANAGED_FRAG_REFS;
-
-	if (!skb_zcopy_managed(skb) || !iov_iter_is_bvec(from)) {
-		skb_zcopy_downgrade_managed(skb);
+	else if (unlikely(!skb_zcopy_managed(skb)))
 		return __zerocopy_sg_from_iter(NULL, sk, skb, from, length);
-	}
 
 	bi.bi_size = min(from->count, length);
 	bi.bi_bvec_done = from->iov_offset;
@@ -1044,6 +1048,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 					(u64)(uintptr_t)zc->buf, zc->len);
 		if (unlikely(ret))
 			return ret;
+		msg.sg_from_iter = io_sg_from_iter;
 	} else {
 		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
 					  &msg.msg_iter);
@@ -1052,6 +1057,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_notif_account_mem(zc->notif, zc->len);
 		if (unlikely(ret))
 			return ret;
+		msg.sg_from_iter = io_sg_from_iter_iovec;
 	}
 
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
@@ -1062,7 +1068,6 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg.msg_flags = msg_flags;
 	msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
-	msg.sg_from_iter = io_sg_from_iter;
 	ret = sock_sendmsg(sock, &msg);
 
 	if (unlikely(ret < min_ret)) {
-- 
2.37.2

