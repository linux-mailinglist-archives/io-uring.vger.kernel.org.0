Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62CE635BE5
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbiKWLgh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236183AbiKWLgf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:36:35 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF30E88FB9
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:34 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id cl5so28973696wrb.9
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rt32A+mPj3rYWuCqBVS19xPD/wXoK2EaewkcD5uohDs=;
        b=JC7V4dOeMFy8iz0N/HFDuDjl5Jeu4jQIVGvHRYr2S0Q2ug7MQxZyzinhqJLrj+/p7x
         5WHK7SeL6uB291L+i5bOiWCKlTHQWX0XcSby4YTSQZNDEQHbr19rInsOhFAtVSIiTIRi
         DUfl3sg3Q7CnYCdKMslWkB/xahBAcqz3o61Ag42lV4kYBUt800S4dGTgT+58VqU9vFg6
         ImJrFMOMTt3S8aAFimSuoBT74CtTXBJe4HqSO91deut2q3aVvHwC2Ah8lI1FSODm8+VU
         3JWRJ7tL9CCv9Pb8xTHQZLoiMN6l+VI2JXuwwifMczF9Z2dweS6/aWAnXhBvkphuBqfb
         7KnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rt32A+mPj3rYWuCqBVS19xPD/wXoK2EaewkcD5uohDs=;
        b=Urt4/Iv3D5+1PR/0bBIxp87olfdBVBCzWarjmh9wulxEVTCo7BMGNIO1BFoxtzVtQo
         4OvCxoa/o1PF5bPFUulra6rdD0IjWVrQqcJYZVJFbwo1DFzLaHC5D08Izcn8vvExpMQb
         1SGZCY1YLmjD572//emvO610dgrvGr9hm/MvtE4vFqx/OGLGEF3SrYL2C7pQw9y2e9Ga
         EKAuAzYGG7Icn12dTUKRirJpnN5PB81ncWkTTmjAvWig6g3ATUBoWDTFZ4kZNNO6n0Rb
         vAC2dxRToht1SX+wtD6llitWff5glnQimyT6ZYxeiDD9Uu8pnj/YhG1zKlEfozbPU2aQ
         QHAg==
X-Gm-Message-State: ANoB5pmR3A/U4blmcxH63Cnvx2iXHGFdso2yiPm9OY7EDw8DCJDPlQ4w
        MRjffFtDUp3YtnUu5L6Tqid949Bxc58=
X-Google-Smtp-Source: AA0mqf7I8AVoZ9sE2KyqZFa9NmCgAHy1G47dVNpa6TIY85pd63gqbIgnxMskHrwT/8wJSTRuZC8+mw==
X-Received: by 2002:a5d:5685:0:b0:235:f0a6:fafd with SMTP id f5-20020a5d5685000000b00235f0a6fafdmr17224881wrv.75.1669203393295;
        Wed, 23 Nov 2022 03:36:33 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id y9-20020a5d4ac9000000b00241ce5d605dsm10854508wrs.110.2022.11.23.03.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:36:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] tests: remove sigalarm from poll.c
Date:   Wed, 23 Nov 2022 11:35:08 +0000
Message-Id: <cb1f7add1ede0a1f9526b53ba8ff337fd9a754c6.1669079092.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669079092.git.asml.silence@gmail.com>
References: <cover.1669079092.git.asml.silence@gmail.com>
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

Test loop handles timeouting and killing stuck tests, no need to have a
separate sigalarm in poll.c

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/test/poll.c b/test/poll.c
index 1cd57ba..42123bd 100644
--- a/test/poll.c
+++ b/test/poll.c
@@ -14,12 +14,6 @@
 
 #include "liburing.h"
 
-static void sig_alrm(int sig)
-{
-	fprintf(stderr, "Timed out!\n");
-	exit(1);
-}
-
 int main(int argc, char *argv[])
 {
 	struct io_uring_cqe *cqe;
@@ -43,20 +37,12 @@ int main(int argc, char *argv[])
 		perror("fork");
 		exit(2);
 	case 0: {
-		struct sigaction act;
-
 		ret = io_uring_queue_init(1, &ring, 0);
 		if (ret) {
 			fprintf(stderr, "child: ring setup failed: %d\n", ret);
 			return 1;
 		}
 
-		memset(&act, 0, sizeof(act));
-		act.sa_handler = sig_alrm;
-		act.sa_flags = SA_RESTART;
-		sigaction(SIGALRM, &act, NULL);
-		alarm(1);
-
 		sqe = io_uring_get_sqe(&ring);
 		if (!sqe) {
 			fprintf(stderr, "get sqe failed\n");
-- 
2.38.1

