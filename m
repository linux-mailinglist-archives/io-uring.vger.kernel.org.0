Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19210591735
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiHLWTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:19:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAF5B441B
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:19:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso2060992pjd.3
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=a16BHwkOhfJFZVPlo7F3Fcn8OZg9BOqNfW2Nk2uzoyk=;
        b=4Gr4JkNgKcFn4i6yw3kPBOiD5uyWmKRzkuZ6m983VdQ3nU0QMewv0eHRAKQyOVSO78
         AbwKi4eSU0HmTJYH61wju9cPMEy1cet/PaG66ZI0QR2OZenRWvRhDJNgew56cmY/Ufa9
         a9/PApjcTd8oYp6Xud4Pctp5qTShgGKF02yD//aIVbwMPbzdlcMLCnh5gucz57BQlhHn
         lP4JjByk5GZ+39cml04fjpOngtk14ONCdA377KjZc4ZAscPt8RahdWaMpyv06skVYIV7
         DsY7Gw3++V2qtU/EkEdx/4M+QUTnelV8btBwcS8UUoS0nXKL43yYQKWlvPFQoH5UW+dr
         wjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=a16BHwkOhfJFZVPlo7F3Fcn8OZg9BOqNfW2Nk2uzoyk=;
        b=YbhBt8ParU+LReA8GJUeBUim9OKdTH1q+MAMHzSLgdycSQDWpPYTmkMA8UNfyjIzSe
         7qS9WAdri91ftDpLD9Syi4oCS+bOTPGvZ28pZd8bubLjw1KlI/L7TgqhEHdDBacwtbcf
         yrbUwApPaogN2y1Gblgn2BApGTuVY1Gqidzh07kfaVP0K9OnEyg6vtyyvaf/QFnduJrh
         Rx4ZShD2weW1YpnABBAmEUsvhSYeHY6Du4helMclSYLNGdnWBN2ICuSd98sd+dp/55NX
         oujhQmMfyugFIIfqEXMnL0eBOYOW2r31Gdy1B+QjeaH8kvhBEf78CmDVS6zlsfCrHb/k
         gx5g==
X-Gm-Message-State: ACgBeo2mo4z5YXcBN1x2uOG4zxePNVYrZPLxW+ciD4/iEXelRnaLWPh6
        TXr/4C79i9oRJl/3MyISxabg2Q==
X-Google-Smtp-Source: AA6agR6JcqRbGlvq/p5lY5Yj/MoPqjeMZgWfQaM9lsDnmCp298yvipK+UJNcuhNO0uIsz1VzK4LgWw==
X-Received: by 2002:a17:902:b481:b0:170:a33d:7bde with SMTP id y1-20020a170902b48100b00170a33d7bdemr6080996plr.6.1660342748566;
        Fri, 12 Aug 2022 15:19:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i1-20020a17090332c100b0016c29dcf1f7sm2297853plr.122.2022.08.12.15.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:19:07 -0700 (PDT)
Message-ID: <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
Date:   Fri, 12 Aug 2022 16:19:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
In-Reply-To: <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/22 4:11 PM, Jens Axboe wrote:
> For that one suggestion, I suspect this will fix your issue. It's
> obviously not a thing of beauty...

While it did fix compile, it's also wrong obviously as io_rw needs to be
in that union... Thanks Keith, again!

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..7ef7cffff0d2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -481,14 +481,31 @@ struct io_cqe {
 	};
 };
 
+struct io_rw {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct kiocb			kiocb;
+	u64				addr;
+	u32				len;
+	rwf_t				flags;
+};
+
 /*
  * Each request type overlays its private data structure on top of this one.
- * They must not exceed this one in size.
+ * They must not exceed this one in size. We must ensure that this is big
+ * enough to hold any command type. Currently io_rw includes struct kiocb,
+ * which is marked as having a random layout for security reasons. This can
+ * cause it to grow in size if the layout ends up adding more holes or padding.
+ * Unionize io_cmd_data with io_rw to work-around this issue.
  */
 struct io_cmd_data {
-	struct file		*file;
-	/* each command gets 56 bytes of data */
-	__u8			data[56];
+	union {
+		struct {
+			struct file		*file;
+			/* each command gets 56 bytes of data */
+			__u8			data[56];
+		};
+		struct io_rw pad;
+	};
 };
 
 static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1babd77da79c..1c3a5da9dcdc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -20,14 +20,6 @@
 #include "rsrc.h"
 #include "rw.h"
 
-struct io_rw {
-	/* NOTE: kiocb has the file as the first member, so don't do it here */
-	struct kiocb			kiocb;
-	u64				addr;
-	u32				len;
-	rwf_t				flags;
-};
-
 static inline bool io_file_supports_nowait(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_SUPPORT_NOWAIT;

-- 
Jens Axboe

