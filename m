Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA9878921B
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjHYW4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjHYW4M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B48BE77
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:10 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-56a8794b5adso827536a12.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004170; x=1693608970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlVAPC67Ckz18v0seyoQ+Y1mhb5JS+9AeH2Kfw2VkZk=;
        b=weIq1P1fYX9XojAfp1XdSHglagfDrMCXAL9e8Z8laIReXa/R92270FmVh18N1iUp6/
         FN7fir9nSK4oibtMxKgy6hl4FqGxuZFZvDGTku/6FklpHkSuv6WkvSeoC12yAZmeiYZS
         0AWLeFYL0UWTUw2WpMzzV9RUglpaaKYZtTkaXG3GTqhiEaS+fwl8X0fLS7eTCsPcyfaK
         2flfQvQg7+XEXe62cUgfO+JyhMQzczvaXt2pezh7J2TRvBcMdVqzOk0juuQsYvbrt6Ly
         Uz35XLXtjZ9iKxJQ0pw7hHZeTg4gXfhYtC6DpGoDE9kAFJ8/Lo12HMvTNChIst2uGwB/
         fFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004170; x=1693608970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlVAPC67Ckz18v0seyoQ+Y1mhb5JS+9AeH2Kfw2VkZk=;
        b=hNc8s6yH1Z+oI4BJDUIS9eDkza4qlEHSnewtbcT70TXh5D1uxXTHJ0SwKdWwJkElfR
         GCU8ndhmQVGgDyfPtm4OpxOE80OBDam1f555ap76XbZEOLG9yjxL+BI9R5zwKkOHBf9c
         5+eXFyieQeoP+UCEUHoyrBdDNrp6m8MaM2O6ngV0Iynk41+wh30mi4Lhf7PNbTMZJDBC
         Ha7+ZMDnwQOvCBZe+O6ysvR4GCzF9bmkhhWYtMnoiajc1nbotfL0/r0eBKGayFEkHzz3
         5pVzhvRym7DJZyIeOvLXo+GXwAyI0QknGXCPIAXzgoWZAn2WP8RtVEx/QqpGsIgVQ5EB
         F/QA==
X-Gm-Message-State: AOJu0YyWHbv4KX+ugA/8Cu1sfXLCfb3jhFTRFozN0ukWq/BkL1gn4nKx
        1SBsk127qI72oFpqrDrjotXbcPf95R/dN69vSyYddA==
X-Google-Smtp-Source: AGHT+IH/b8FrSUCGu7+W2iSm7lSjsbfYci0VTWbjyeyOfnY4oAfbqNMxdindWhBPKvMajYFpEI6q9Q==
X-Received: by 2002:a17:903:234e:b0:1bd:aeb3:9504 with SMTP id c14-20020a170903234e00b001bdaeb39504mr23697764plh.15.1693004169997;
        Fri, 25 Aug 2023 15:56:09 -0700 (PDT)
Received: from localhost (fwdproxy-prn-120.fbsv.net. [2a03:2880:ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id t11-20020a1709027fcb00b001bb9b87ac95sm2317688plb.103.2023.08.25.15.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:09 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 07/11] skbuff: add SKBFL_FIXED_FRAG and skb_fixed()
Date:   Fri, 25 Aug 2023 15:55:46 -0700
Message-Id: <20230825225550.957014-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

