Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E6A789219
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjHYW4O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjHYW4I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCE8E77
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bc63ef9959so11672855ad.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004165; x=1693608965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNgO5ZIv14KVZmuHWpj5cSQRK/umULxc7iSIeMaS/eA=;
        b=BmmrwZyXUBHl4GJCQjWdVUbF20KZZOuMmPvVfB6/rM3sdRxVWtl8PljXY7qJ+Euc4s
         ATZlKZzQIDCx6cPqxs6/DOgredR4EuPEtZh6+leI4zp3nrOZ8NnAN18u3hy9hZW5elIo
         D/LcDD1IMadUHEX7j/NGq4iTuE4l/tR7tMLQc7Cu9TKgGsmmEjvHidne9aEv+bKKjf+O
         0XkLbMJGSfGNrjYXOPmm9M7oEMzG/dFYD2a/c5k/2ewsMP6u+KSz4EX9BNOAQR7SyFrn
         ejE/Ml/2IzteP/RDTJqK/F56VDoo6Jasndwosc1NjVzT1XYXTr10IeEkqUJ/Qnokw42A
         wgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004165; x=1693608965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VNgO5ZIv14KVZmuHWpj5cSQRK/umULxc7iSIeMaS/eA=;
        b=JOj6YJ/uCkPIzy2Ns66dLKorSxOp+bkac/Zh8WMIgfhkxvIyOY5oIHtucK6ehD7Tg3
         3sN/OYKTtptMmlmfsw61yt3od41Tb4ejON0W79n8bNyu3OmaWhrSlmHR/SUEvjznNXd8
         /1puds0Snm7LRx7kAAfO4awAt8Izuv9j8g3u4tAw+p88sNLHNLA2poNx4pZGsmGxwT4l
         ZQrsbGH8FHZknqV4lksP8siYSwAcE6sseFxlcir/tcJbJ/XkrPQxlWglyY+wO5wcPn/3
         k1xcv9QC71DxED/Crzmj5F+NH4tjfeQ4VdGncLmUdPJyi7emxss8n8+vyMaUFXATTxIe
         eptg==
X-Gm-Message-State: AOJu0YyTnAl6pNjCeP5kpzuFXjlSQOaEYLTNUisgrJ7+o6iOF/IXAH8J
        tsOA44bypmiLhrwCvjERE+8OSw==
X-Google-Smtp-Source: AGHT+IEdAXgNnXWaE1z0emant2hN3KQjegin/G691vq4DRoTrEr/U4RM7R4c6/MC7MeiKXZIFkad9A==
X-Received: by 2002:a17:902:d50c:b0:1c0:c4be:62ca with SMTP id b12-20020a170902d50c00b001c0c4be62camr6641452plg.17.1693004165377;
        Fri, 25 Aug 2023 15:56:05 -0700 (PDT)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id bh9-20020a170902a98900b001b51b3e84cesm2284135plb.166.2023.08.25.15.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:04 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 03/11] netdev: add XDP_SETUP_ZC_RX command
Date:   Fri, 25 Aug 2023 15:55:42 -0700
Message-Id: <20230825225550.957014-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
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

