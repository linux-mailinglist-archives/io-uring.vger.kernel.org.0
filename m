Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B01C567C99
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiGFDli (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiGFDlh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:37 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828801D337
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:36 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z191so12939516iof.6
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yDg6wC7nuZZX8KWmjdjU7VBm9TO44Q1YklajAUbfBmw=;
        b=MhoLdYR4BKTgVaD7bIkgz9rTuDL0ChkCD5K/Yrq86zloAXi6TEWeeqvZJDv7MHm/vq
         uQMjtR+AlEOaXXnyesl7sFVEaZbRZnjOL890kHUWsF989s8BDlupOsvUtRGUJDuKrV95
         S8XfQYay5pufOg7F4iNtmaK+s4X1RXH0jLA9x6Wr+/I4amrHugcXnp4kQj71pUrWjE9v
         FxgjFMYpIL9ATrP9ow5jioSvFjjWISYClwHzXtZziP5nTPQ+S8xXi/dCo0DSDX+MuG1O
         k6VnN0jiEa0tF8jXi6nFhrhybwPjEX+92MVwe8a5tE08K0XUqHO+Hma7YAqljDoRFg55
         KKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDg6wC7nuZZX8KWmjdjU7VBm9TO44Q1YklajAUbfBmw=;
        b=IFYACKdxBSf+Wbv4U2mh+TbVDcxw4GaDIV7UI7oRkkwwlreERzpQm7ESSKE1QxC3o/
         l5jBo12HgbAbclNIMu+aH5sclcxRKgaly8AT+dnrvYFOhkeyjZrCSBPaE/iePW6Qhe21
         U0/9yyWm/tsweUihzwZdKEfAtqaxChamFKi556+5ZZzt2w1YWQXidcK2ldryEgiomQaT
         GYDWv3A+abJ9L/Xyx+ym3hQucOJy18YfDKzR2gm97774imUj3XtOMWFdBZtDF+71slQN
         OOaNkQUPQmpfbmLdxSsGbhXJll0UQma8K471zfRC0L7dU9tkVYbSNlE7kh3k+c60GyGh
         RgAw==
X-Gm-Message-State: AJIora/PQnGOFYtghRbTrJ75/AkMEht+MFW2yUvSEvhROngtlbfplBCs
        pXDTedBjERc5hPr9gi4ojcEsx0bKLMKtc2lY
X-Google-Smtp-Source: AGRyM1u+5HKkYBTrEyc4tSw/zklLIPrGvbHfrSBcMNbViWvMtKghTwNIx6vf8QoUj7wm+3XcpVgSAw==
X-Received: by 2002:a05:6638:328c:b0:33c:b753:69f6 with SMTP id f12-20020a056638328c00b0033cb75369f6mr23713694jav.73.1657078895598;
        Tue, 05 Jul 2022 20:41:35 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:35 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 6/6] tests: correctly exit with failure in a looped test
Date:   Tue,  5 Jul 2022 23:40:58 -0400
Message-Id: <20220706034059.2817423-7-eschwartz93@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706034059.2817423-1-eschwartz93@gmail.com>
References: <20220706034059.2817423-1-eschwartz93@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A common test pattern in this project is to test a couple related things
in a single test binary, and return failure on the first one that fails,
if any. Tracking subtest failures cannot be done well with simple exit()
statuses, though it can using something like TAP and parsing a generated
report.

However, this test simply set the value of `ret`, then proceeded to
another test. If the first failed and the second succeeded, we would log
a failure but then return a success.

Just return immediately on failure as is done elsewhere.

Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
---
 test/multicqes_drain.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
index b7448ac..1423f92 100644
--- a/test/multicqes_drain.c
+++ b/test/multicqes_drain.c
@@ -373,7 +373,7 @@ int main(int argc, char *argv[])
 		ret = test_simple_drain(&ring);
 		if (ret) {
 			fprintf(stderr, "test_simple_drain failed\n");
-			break;
+			return T_EXIT_FAIL;
 		}
 	}
 
@@ -381,8 +381,8 @@ int main(int argc, char *argv[])
 		ret = test_generic_drain(&ring);
 		if (ret) {
 			fprintf(stderr, "test_generic_drain failed\n");
-			break;
+			return T_EXIT_FAIL;
 		}
 	}
-	return ret;
+	return T_EXIT_PASS;
 }
-- 
2.35.1

