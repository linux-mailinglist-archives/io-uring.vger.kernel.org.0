Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D488777E20
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbjHJQX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 12:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbjHJQXy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 12:23:54 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D142702
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:53 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-3498976ebc6so646635ab.0
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691684632; x=1692289432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cxaHqbHr486dg1bk6KiT4/voNxx72SQhsGodxfLREeA=;
        b=rMo9AuQAc6dNcvJBrHSLUUXBqqmQ4y1QW/m57+qEzUQOZOkeTblel/Ocd87tNH05BT
         unfvYrLAEVUx5B8eWBu5N1fItFOr2RAlWXu+r2Fjo3IFB4iYRg8f2+IzGGyOA84VeCnZ
         YGXzDKliLjX700pTwOevmAdLm3HrJtoVipyxTXqhj/+uhvEqMOAUXz/0bXP6tNYB1mw6
         oeyy7L1hKtDRLDF5MIZxH+tLDk0+PWLpV9MpPs3GqC/UillpbkfNIva368hahec9XFAf
         B0U8P6nHpawCoJZTuwIpBCk1mvJJl1wohH6LuKcg1wq0Notnv/qCOO1iYVgLJlF5VUpz
         WYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691684632; x=1692289432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cxaHqbHr486dg1bk6KiT4/voNxx72SQhsGodxfLREeA=;
        b=EW0hDc8vMyct5+qIli4tq/sbmElc1jeT9xsOmlzdUmWwAZgCqeg/ccftA3wsD1pUwF
         zUmv67FE0517/I2N+YCtFi9NH2OH9Pik6gw21807nsgTiIEU9uxiJIf5SV03ypXgMPm2
         H6WHxwp+NdrlviqrqRkjQNmeET+VMQ+IKASBWHU255F1+kpO7bkZQasGmbIsnXuJeIVD
         AXktqjgLX1l1jjhGovEF1DYZ/gDcRj0UQFGEeZ2EBHIFAKegIFjxbfCqwzfqp24rFvA8
         +mt2E58DQncIHlgiKYYBpPCbAV5tF27PkEvMdtfwcXsfQC9GLL8PW1lit+APzOgWUXja
         W4Og==
X-Gm-Message-State: AOJu0YwcvXs5cvSs59S3l3Ujaqv2hBbkXVQCSVzYlrdINGujwqrAezB/
        GS577xyaNadPzYkgNP9C5TyZkfhXP0cZIfNIbPQ=
X-Google-Smtp-Source: AGHT+IEt2IT5yaBvNdkSNaWIXBaSsWmF0QklmvZCGR5i1ONw4wBOrHOEs6WjvA9HIOJ+1Ti+eUudtw==
X-Received: by 2002:a05:6e02:542:b0:349:582c:a68d with SMTP id i2-20020a056e02054200b00349582ca68dmr3404939ils.3.1691684632654;
        Thu, 10 Aug 2023 09:23:52 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j5-20020a02cb05000000b0042ad887f705sm491941jap.143.2023.08.10.09.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:23:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/splice: use fput() directly
Date:   Thu, 10 Aug 2023 10:23:45 -0600
Message-Id: <20230810162346.54872-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230810162346.54872-1-axboe@kernel.dk>
References: <20230810162346.54872-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No point in using io_file_put() here, as we need to check if it's a
fixed file in the caller anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/splice.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/splice.c b/io_uring/splice.c
index 2a4bbb719531..7c4469e9540e 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -68,7 +68,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 		ret = do_tee(in, out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
-		io_put_file(in);
+		fput(in);
 done:
 	if (ret != sp->len)
 		req_set_fail(req);
@@ -112,7 +112,7 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
-		io_put_file(in);
+		fput(in);
 done:
 	if (ret != sp->len)
 		req_set_fail(req);
-- 
2.40.1

