Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7A7892F8
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 03:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjHZBWE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 21:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjHZBVd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 21:21:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902032680
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-56c2e882416so844381a12.3
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693012891; x=1693617691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNgO5ZIv14KVZmuHWpj5cSQRK/umULxc7iSIeMaS/eA=;
        b=xNwKRdqsMh+qCjPp4OBeyPIsa34xOMM0cUzK6Yg3OyHro97dhOGmYbOl6u1MnHSawg
         emgcdbv9xTbN4SU4UljeHyRZhsc4ACF485ui6vFOpna6Bjpl3VhZjDCVImSqZphpuCp9
         kOc58NE3nU45sTbG2clqpPwtCTMrCclDzRqOaZJmYUpbnoL2nChtDxnftBIngLyhFPn/
         WXmtLo32T4q5AZeNwYPrcoHGqWTmXIe7BoMQcy2FJMznQgooT4o4Nj825wGKtcacxT/K
         9AQ0tqCwIghD6xF/bQ0ugmO8RelpH7B9h62pdHYzx9Mr/u7pYZ1WwML10UKRltJpWV9o
         3Evw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693012891; x=1693617691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VNgO5ZIv14KVZmuHWpj5cSQRK/umULxc7iSIeMaS/eA=;
        b=bpgieCsGNw8niQufKF/QXr9RUnapjnW67DBriFcqff1UvwuxCnRGyBSJPzKfltUW94
         AvBYEY2KoNB3t43KsHwQhVRYkiIZr9oua2/Mkqa3VVepNMZ7nIixzK3A/43iN/IS5uk6
         8dXut5WUrFVwaVW+uu5ZHMP3EvRci3xiJzTKIunXpbHb2ga5EbwJN01dERLr1fDQ6Ump
         QO8qqsTfK0oQT7J1PmSr3u75CX/haOMDxqDeDZcEGP/XsTFr6SfXV1OeGC8kKX9EecP7
         BfhYzt/zA98Qzo/75sDuOXVJKMHLTmxFTE1EDEjRSWqBUKvIhbirvx9eSEOvSuWkObau
         KB2g==
X-Gm-Message-State: AOJu0YwG1TjJGnBxCstZbRjkW3f76hUz5lkrpa8SubPwXkBETxVD7K6e
        XVo6wPSsciFNpsqu2rJEa14/BQ==
X-Google-Smtp-Source: AGHT+IFzWc4+ijhlirnZLcO2bqVcRhIBIgdFNaal1xrptHcSU36WHJC7JgXlaeCAvzW0niN/CeFJvQ==
X-Received: by 2002:a05:6a21:3390:b0:14b:f78e:d05c with SMTP id yy16-20020a056a21339000b0014bf78ed05cmr6858254pzb.15.1693012891044;
        Fri, 25 Aug 2023 18:21:31 -0700 (PDT)
Received: from localhost (fwdproxy-prn-120.fbsv.net. [2a03:2880:ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090341ca00b001b9de4fb749sm2420621ple.20.2023.08.25.18.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:21:30 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 03/11] netdev: add XDP_SETUP_ZC_RX command
Date:   Fri, 25 Aug 2023 18:19:46 -0700
Message-Id: <20230826011954.1801099-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230826011954.1801099-1-dw@davidwei.uk>
References: <20230826011954.1801099-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch adds a new XDP_SETUP_ZC_RX command that will be used in a
later patch to enable or disable ZC RX for a specific RX queue.

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..a20a5c847916 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1000,6 +1000,7 @@ enum bpf_netdev_command {
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
 	XDP_SETUP_XSK_POOL,
+	XDP_SETUP_ZC_RX,
 };
 
 struct bpf_prog_offload_ops;
@@ -1038,6 +1039,11 @@ struct netdev_bpf {
 			struct xsk_buff_pool *pool;
 			u16 queue_id;
 		} xsk;
+		/* XDP_SETUP_ZC_RX */
+		struct {
+			struct io_zc_rx_ifq *ifq;
+			u16 queue_id;
+		} zc_rx;
 	};
 };
 
-- 
2.39.3

