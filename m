Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A608D57FCC0
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 11:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiGYJxv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 05:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiGYJxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 05:53:50 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D821704C
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:49 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b26so15193513wrc.2
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YqG0evu8QU96PZzvZYAhUUI1Uw0ucnERiwnkZnU2xmI=;
        b=FwAHLQpvj3X7nFNMr0reYM/T/qsF0DRdUPMneChBJlGTuCSFpQY2Envou9WkIHMZFi
         P09PMRQWDy4I33ay+1NHcu10ceD+6JF77K65Ps7SOKtGL8YybeXF9CLGE9piz/RQOG3l
         iIJY2BmbaxwsM16rZpgtUtZjklexJASDBRcWLGEuoNbWnw98a7NJXZRTHwZSdcAxV+VG
         uLftku3M1A3Uh/z+3DDMvCg1Wmoo8yiMEAaYF3ThQC1msQ1Flo/djHpaCCKatzsL9aqT
         VfxxVDzQ/airqu+SsvsRRWSCV4k4oXXp1irlJ7tiCZZ01zrLy80Clsd8js+gWwn4Ckmf
         nZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YqG0evu8QU96PZzvZYAhUUI1Uw0ucnERiwnkZnU2xmI=;
        b=WJo7g8qEVhXC8YhRJiHBV7li7BHSxjJOrGyE18s3MSfAYnlUGRtcK9OWhfdsPDHnAQ
         oOctLmRdQub5+SP3iWh2b9GNaIkeB4LnxQBMV4w/WM+hWwpeS4dRpyNOw6vfVt4+iemD
         pobknqj8Kno1cgnGhBliFwz6M/dloukJXz8KHFNL45Yz+2gt4Zay3ybQ9bxSeygM+SGe
         6H1PmGgQEgaW/3XTlcHHodHOOVNOAR35i+EaJ13uagVP3aY4vYTmoYQ25pw3CwGzIbgd
         EED/CqTsNtGnNNYmRism40CRJ4INa1YuonPTV/LnDUq6y907Qb63ASPIMHY9uGJszxxW
         4clA==
X-Gm-Message-State: AJIora/2VU/hOyerGFUtZrQs3Kp3Dq5I/NeakgIz7Szo1u6vWDabx9b/
        EbsOznyd6GU+DnX0MhD/9nC7MVJ2nz/bqg==
X-Google-Smtp-Source: AGRyM1s6o37bI4TRwzlzszVmWTUJk3WkxNOedCx7rSPadwa+QtvAdLRYP5M8lym3tGL71yZXxFBtPw==
X-Received: by 2002:a5d:64a3:0:b0:21d:ad9e:afd7 with SMTP id m3-20020a5d64a3000000b0021dad9eafd7mr6991476wrp.524.1658742828928;
        Mon, 25 Jul 2022 02:53:48 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:1720])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003a2ed2a40e4sm18909636wms.17.2022.07.25.02.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 02:53:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/4] io_uring/net: use unsigned for flags
Date:   Mon, 25 Jul 2022 10:52:06 +0100
Message-Id: <5cfaed13d3191337b14b8664ca68b515d9e2d1b4.1658742118.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658742118.git.asml.silence@gmail.com>
References: <cover.1658742118.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use unsigned int type for msg flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index c13d971c7826..8276b9537194 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -55,10 +55,10 @@ struct io_sr_msg {
 		struct user_msghdr __user	*umsg;
 		void __user			*buf;
 	};
-	int				msg_flags;
+	unsigned			msg_flags;
+	unsigned			flags;
 	size_t				len;
 	size_t				done_io;
-	unsigned int			flags;
 };
 
 struct io_sendzc {
-- 
2.37.0

