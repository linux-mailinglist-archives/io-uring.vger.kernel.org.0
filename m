Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216BF5B1CC1
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiIHMWx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiIHMWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8C91316D1
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:42 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bj12so37540570ejb.13
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=GB9BOyQODze5Kg82+IrDJOynNmHrAMiNDdnDkl3bHr4=;
        b=p2D+IMj+zJC+TIIteOvukNaHtUlcnpiBGbQceD0tkpCv957T5QX3roOucKQmeCrRi1
         ViyL/DOF+uCIK94CiahKVHH3vlGglhGrrAXqWvJxdV3VKzcudWvNOhgoHDIABqeyHl9a
         p5JnL5ft2N3oYcTr3EgzXSvpKgkSyrw6IEqGuqQEeTe1UAB6o+BkmH8A6bb5xFXMZxKx
         Glm/UpERZ+Z7SGbMLuJFnlcbLAz/TGfdOo/J4EYJQrsDo0br8TVq/5S/swQUP5DPoEvZ
         MlaBwGAaPox2CHgb+pLyv8oOTeAaBc3SDf3X9JkDwMI1fF21h8beFVNTcBuh3UiORcxA
         4hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GB9BOyQODze5Kg82+IrDJOynNmHrAMiNDdnDkl3bHr4=;
        b=CNxAruZZe/DXnp0G/9O0LyuN91OOiijtzlyicZzQ9UHnyhVXfdI3DmqhDzrWhgJbSz
         nH511n9zVOoKYAf77zDZTnoPfhds+PI5/FnYzPptTOX3yl8BMlRajqX6uYZm8lNSLXKs
         Bg72YJOE3t3RX7mC6z/JL7UhNsX7F8d93MQqkAsTKYeMFXFEewrRE3P8YgdL+NuACM3E
         zEnoxM32WCnH/Pe7BOxOd3ToUdAfwcDcpm/+uTnTE+EwrAEvT3kyz6wPahqyWYxxCJz1
         5M6NfHxHMvfDPWDmJc0AkvbWDjGESWeNjezQZttayGla/que8UPEHNGLTttCCniEomm7
         tEXA==
X-Gm-Message-State: ACgBeo0z+Um+XeSGKJ7TU9FS723I7YfeRAFgxaS3N4cmHcYa2IEZzEp0
        ycHLljSZnABtl3EZS0IsjxE3toLMTkM=
X-Google-Smtp-Source: AA6agR7JsWOagimuwgu/sCtQWUdXfcX/TlKE/hVlOPHNit6kqIybirqhzDG1AqpzwZIpm8FuijlCAA==
X-Received: by 2002:a17:907:7242:b0:741:7cd6:57d5 with SMTP id ds2-20020a170907724200b007417cd657d5mr5802799ejc.419.1662639760559;
        Thu, 08 Sep 2022 05:22:40 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/8] io_uring/net: refactor io_sr_msg types
Date:   Thu,  8 Sep 2022 13:20:33 +0100
Message-Id: <42c2639d6385b8b2181342d2af3a42d3b1c5bcd2.1662639236.git.asml.silence@gmail.com>
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

In preparation for using struct io_sr_msg for zerocopy sends, clean up
types. First, flags can be u16 as it's provided by the userspace in u16
ioprio, as well as addr_len. This saves us 4 bytes. Also use unsigned
for size and done_io, both are as well limited to u32.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4dbdb59968c3..97778cd1306c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -55,21 +55,21 @@ struct io_sr_msg {
 		struct user_msghdr __user	*umsg;
 		void __user			*buf;
 	};
+	unsigned			len;
+	unsigned			done_io;
 	unsigned			msg_flags;
-	unsigned			flags;
-	size_t				len;
-	size_t				done_io;
+	u16				flags;
 };
 
 struct io_sendzc {
 	struct file			*file;
 	void __user			*buf;
-	size_t				len;
+	unsigned			len;
+	unsigned			done_io;
 	unsigned			msg_flags;
-	unsigned			flags;
-	unsigned			addr_len;
+	u16				flags;
+	u16				addr_len;
 	void __user			*addr;
-	size_t				done_io;
 	struct io_kiocb 		*notif;
 };
 
-- 
2.37.2

