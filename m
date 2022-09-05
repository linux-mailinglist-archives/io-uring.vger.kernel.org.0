Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA595AD4B6
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiIEOXg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbiIEOXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 10:23:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC51853014
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 07:23:29 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s11so11539124edd.13
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 07:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=AKrZ1urcngCqlh4eeSJunnwPCrMDBRenolGBDYtEd20=;
        b=N0/Hw04jRYvVKGfLhfXvYMDa7hV33/Oyc4qfWe2CNLNZXgEKFrT+a1li/D3GSpxP9v
         sZE7YCniJg7MCZ2oBR0S5ff2h+4PNOm7wEcXPNTk8+jc67Cs2g/7DVjbO5GWPtAmFxqs
         sQRAelbOnti5BM2XlZL1EZgmkgDW7U3dMPvp0pXIEiEgAUdtDCzj32efVrEtfudfHuLo
         h5JIho46qgXtq131fKVGasM+xqT5bCb/ZMIMeqtqMG44mlU2hQew1FJvwSVyKa37qksg
         Xywia1INNqmIkP02104WOUsOaj96Vt0zTT1blaoJFXbYFVVyZ8ad/+FbPX7djbuZoDlE
         NN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=AKrZ1urcngCqlh4eeSJunnwPCrMDBRenolGBDYtEd20=;
        b=CdzhfeTD5U3KK3eciH0WiYL1JXjxes4NoYTdn3TgeX4mB+gAVwD852pUpbIZsHXUqS
         20lU81OMEJcfNiT0EN2YKxkxSYp3RdmkHox8lzpio8balEaPQy9gSoBfTPHwIJFWqAt8
         MqxFy2K5XKAIGlNClGJe1QZrt/ehuVWEnNCLZMaL5vZNwNQtTRjYaau+cSMFSeeLqEJD
         NmhiEKTwobKUdZf7mYZms4pp1L3wvMBmF/TpFjnEIm5/oq41kqOHk6yNtJvDX/eWRGUF
         SeH/pCtEAbB30KWRmPC399wcpvKQ0q8K7K9APP92cF3gxGKNk7tmAE0LXPJITmlyupOz
         RTtg==
X-Gm-Message-State: ACgBeo2rxSiKMXaBBjil5dd87ud0ZwUw2i0X3Hp7CPHvr9RtumjSv+iT
        OlrOcRIs4W6fsv7PtPhrhYl3/8jHbjc=
X-Google-Smtp-Source: AA6agR789VbcnyO21Woh+Aiq7a0FpNeBEyu3VUd4VWsezstwCbS6hwGmdkOjYNKAIcp0VU5zEh0xag==
X-Received: by 2002:aa7:dc13:0:b0:443:3f15:8440 with SMTP id b19-20020aa7dc13000000b004433f158440mr42264890edu.274.1662387808237;
        Mon, 05 Sep 2022 07:23:28 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709064bca00b0074182109623sm5168799ejv.39.2022.09.05.07.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 07:23:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/4] tests/zc: fix udp testing
Date:   Mon,  5 Sep 2022 15:21:05 +0100
Message-Id: <f85ddc0dd0712ce17a5e7f73639c55d9c612cedf.1662387423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662387423.git.asml.silence@gmail.com>
References: <cover.1662387423.git.asml.silence@gmail.com>
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

The tcp vs large_buf skip condition is not what we want and it skips udp
testing, fix it and also make sure we serialise cork requests with
IOSQE_IO_LINK as they might get executed OOO.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index f80a5cd..bfe4cf7 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -285,6 +285,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		}
 		if (force_async)
 			sqe->flags |= IOSQE_ASYNC;
+		if (cork && i != nr_reqs - 1)
+			sqe->flags |= IOSQE_IO_LINK;
 	}
 
 	sqe = io_uring_get_sqe(ring);
@@ -380,11 +382,9 @@ static int test_inet_send(struct io_uring *ring)
 			int buf_idx = aligned ? 0 : 1;
 			bool force_async = i & 128;
 
-			if (!tcp || !large_buf)
-				continue;
 			if (large_buf) {
 				buf_idx = 2;
-				if (!aligned || !tcp || small_send)
+				if (!aligned || !tcp || small_send || cork)
 					continue;
 			}
 			if (!buffers_iov[buf_idx].iov_base)
-- 
2.37.2

