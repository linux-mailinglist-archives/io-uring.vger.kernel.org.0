Return-Path: <io-uring+bounces-59-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F2E7E4AE9
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C64991C20933
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E7F2B2E4;
	Tue,  7 Nov 2023 21:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ClCVsMEf"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0012A8FB
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:04 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3BF10E5
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:04 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc5916d578so56104075ad.2
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393263; x=1699998063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cl3ninwz7WqOnfXoQFVr+8n0tlWT0AeCCLPz+qAllN0=;
        b=ClCVsMEfweqFIx0KnAEE7bsyQagoemyd2uQ5pfmU5lPqeReiXqmHJWIjdev7DJ4EuW
         TzjRbU7eHNWI02QGkAhhTMVAq5yLBRPkBW+7Z6gauQHkSOcZV5fQFKaVInLijsSbXDlj
         rM2uvNmZPArv1hnM8i9TzbONrLVw14TEOTlhRLpQ3gDx75+pU9tNS3BgVm5Blnf65UfK
         YjkJJnora83Jt2RYmZyodxK287gilnqYkO42/zWtFdu8AtsObilK7tAp/Z8r/T9L05PV
         Z6Qpdc47l37+ysfadAxZqEkBGo+S0neDOGMK4koROS86/ZndiUr9IRsw4l22oszUuEWE
         /BXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393263; x=1699998063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cl3ninwz7WqOnfXoQFVr+8n0tlWT0AeCCLPz+qAllN0=;
        b=p5OCDRpLVzwYZ9y75qFWuXOO+r83G2l5h5jykvNldHTuqwMabS7BvMlxfkBwo1D4F/
         iBZBdMBUndEyx4Q0F59rTQ0wTyhZj9vZoiPBPGIhGAxsZM9BG0XBm9mzQXT6GqPy+zqh
         9n/FW/qVPNLCpusrcEeSbupCVaRdT3V/G5ZMgvEZdyFVE1Xf8UPyltX8F4HuV8ov9dT3
         LKoIWQFRgio+zetzF6rgOeMADHTdYcXupQGas1zr0KOUWBIUmU/ooNttq3xj1Tg2XAW+
         0gA3/CDz2FEf5BrlsMEh/bO+f7R70+0ggt3oYPBnJkNr59P5lKsiUSQSRIWRE1Krqi7N
         ABkw==
X-Gm-Message-State: AOJu0Yx/FlauVHHO2iLUF2NMfHx2bquoPx7EzZa4lPCIH1qZxY1W0KBT
	wEBZx0OyWsY/QGjGAeG9HNmKyAMs/cCnjF12iFd5ng==
X-Google-Smtp-Source: AGHT+IGrQgMliiiwDX5fn0J+VbpG/ztV2ihkRjg1ZR85mlnjmijxMcX4fMQWqalQs/IVVhQP77L+Iw==
X-Received: by 2002:a17:902:8c83:b0:1ca:3c63:d5d3 with SMTP id t3-20020a1709028c8300b001ca3c63d5d3mr295371plo.2.1699393263695;
        Tue, 07 Nov 2023 13:41:03 -0800 (PST)
Received: from localhost (fwdproxy-prn-014.fbsv.net. [2a03:2880:ff:e::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902cec200b001c3be750900sm270257plg.163.2023.11.07.13.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:03 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 08/20] skbuff: add SKBFL_FIXED_FRAG and skb_fixed()
Date: Tue,  7 Nov 2023 13:40:33 -0800
Message-Id: <20231107214045.2172393-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an skb that is marked as zero copy goes up the network stack during
RX, skb_orphan_frags_rx is called which then calls skb_copy_ubufs and
defeat the purpose of ZC.

This is because currently zero copy is only for TX and this behaviour is
designed to prevent TX zero copy data being redirected up the network
stack rather than new zero copy RX data coming from the driver.

This patch adds a new flag SKBFL_FIXED_FRAG and checks for this in
skb_orphan_frags, not calling skb_copy_ubufs if it is set.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/skbuff.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4174c4b82d13..12de269d6827 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -516,6 +516,9 @@ enum {
 	 * use frags only up until ubuf_info is released
 	 */
 	SKBFL_MANAGED_FRAG_REFS = BIT(4),
+
+	/* don't move or copy the fragment */
+	SKBFL_FIXED_FRAG = BIT(5),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
@@ -1682,6 +1685,11 @@ static inline bool skb_zcopy_managed(const struct sk_buff *skb)
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
@@ -3143,7 +3151,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
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


