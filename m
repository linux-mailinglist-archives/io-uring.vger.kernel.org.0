Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14777892FE
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 03:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjHZBWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 21:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjHZBVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 21:21:40 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E852680
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:35 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-53482b44007so810252a12.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693012895; x=1693617695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlVAPC67Ckz18v0seyoQ+Y1mhb5JS+9AeH2Kfw2VkZk=;
        b=nGW64Om9jJ67AXiVQNre278IB66wMDS46pX6N1g2dm/mi2u8gx7VmhYvjBUiV1K5r6
         IBZ0/Fk1h4RbCvebWah92SNYShA20fR+8XkoXXJfb4dP2N8lXOqxqbyhkmaA3THBPvP1
         BLZm4HLkL0ck9wRZ9L1IvJ2NnNRsBNZDd7sn3e4e421Wi0Hg6OPdXyl7spPENIAyABIg
         DTr7tqbLjjm9z9pA1/HMXGBVs/tdcZbfj+ZiL4Wvqid+DO8Bdfi4Yeg1/JfE00IhC6W2
         JbFhtMmwwV8A2CABxIroQrRcRoJA39WdhyfKYcuJGmxuTDzmK/PXZKF69hoEaboom50g
         9wkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693012895; x=1693617695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlVAPC67Ckz18v0seyoQ+Y1mhb5JS+9AeH2Kfw2VkZk=;
        b=CpOVoeGspAscvcngjmEGWSYgbIzubkpZolacsoMYm8crQFDFvKFtDOJ3CTQ0fVbm1m
         ++N/Id/78dIcRfjhzhGSe0wHWpEhD8ht03Lq2BHiTZz2uZExvnjaNtmPDFwCs5mGrwTo
         DDaUn7alY7BfKxqoqWUzhBe9IBnjMdz8gqddP7T5X0uiNor42xFmwHnCjKQzobBc96tK
         TjrygFGYJied+hc0Y5rvlej9Pd7TEGAwDG0Ati4z07rUwgQWeKR7um0a1is2tudcpVWx
         GqYT0Fzu05U6dHNp9BZqM4s8+k34MRWOMupDpJXFWVFQ+nijzVQAnNR4ueWqYGElDz4A
         fpvA==
X-Gm-Message-State: AOJu0YwTR0fO0MTw1xIesaEkgkAcPxszg7Eq+ntURnrDJ0pfYDE/L5IC
        NVfqCpDaMbSfpwkrJOx0PHAbdTH6LwGHLUPnrUkx8Q==
X-Google-Smtp-Source: AGHT+IF+A3AHOxKASsfzkvmfhUkhDeFLttevBVsPTVTM4K1LnkeW4qOJxIZ1ujeO+Cca4jiofNkGzw==
X-Received: by 2002:a17:90a:df07:b0:268:fb85:3b2 with SMTP id gp7-20020a17090adf0700b00268fb8503b2mr16125338pjb.7.1693012894990;
        Fri, 25 Aug 2023 18:21:34 -0700 (PDT)
Received: from localhost (fwdproxy-prn-010.fbsv.net. [2a03:2880:ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id a6-20020a170902ecc600b001a5fccab02dsm2410936plh.177.2023.08.25.18.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:21:34 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 07/11] skbuff: add SKBFL_FIXED_FRAG and skb_fixed()
Date:   Fri, 25 Aug 2023 18:19:50 -0700
Message-Id: <20230826011954.1801099-8-dw@davidwei.uk>
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

When an skb that is marked as zero copy goes up the network stack during
RX, skb_orphan_frags_rx is called which then calls skb_copy_ubufs and
defeat the purpose of ZC.

This is because currently zero copy is only for TX and this behaviour is
designed to prevent TX zero copy data being redirected up the network
stack rather than new zero copy RX data coming from the driver.

This patch adds a new flag SKBFL_FIXED_FRAG and checks for this in
skb_orphan_frags, not calling skb_copy_ubufs if it is set.

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8cff3d817131..d7ef998df4a5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -518,6 +518,9 @@ enum {
 	 * use frags only up until ubuf_info is released
 	 */
 	SKBFL_MANAGED_FRAG_REFS = BIT(4),
+
+	/* don't move or copy the fragment */
+	SKBFL_FIXED_FRAG = BIT(5),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
@@ -1674,6 +1677,11 @@ static inline bool skb_zcopy_managed(const struct sk_buff *skb)
 	return skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAG_REFS;
 }
 
+static inline bool skb_fixed(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->flags & SKBFL_FIXED_FRAG;
+}
+
 static inline bool skb_pure_zcopy_same(const struct sk_buff *skb1,
 				       const struct sk_buff *skb2)
 {
@@ -3135,7 +3143,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 /* Frags must be orphaned, even if refcounted, if skb might loop to rx path */
 static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
 {
-	if (likely(!skb_zcopy(skb)))
+	if (likely(!skb_zcopy(skb) || skb_fixed(skb)))
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
-- 
2.39.3

