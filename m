Return-Path: <io-uring+bounces-1591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E3B8AAD5F
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 13:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A04B1C2135F
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 11:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544C8823B7;
	Fri, 19 Apr 2024 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NITY6W+g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B680BEC;
	Fri, 19 Apr 2024 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524928; cv=none; b=Zv3PXiZFmSTJ5WxJJAhucSq8ANUiEGzddWKS6Z5k+tHme2JTts8V279eErbIJ1DofMjwyhxAQNYdcjuHez2nUZaLOIEtH86S2hSicVv8dLDlE4vM43GDJRaquFl2VuDx97Xtbo9k3mk1yZTlbpbEFbFgljb67s2TvWZYM2EXhl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524928; c=relaxed/simple;
	bh=1eVlmu4WPqTzS1vEzdsZXLCBN4erb9MBcCXhDGVcS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXw7knYCgFHwF0L5wJGvbnaidAgmz9z7DlTsLFWuw91B+qp2JS6ePW+IjmQ+Pc8DgYrnSxdJqa4Q2UPhgOUayz4epM7NvMO3Sag5JSes3zEPbuT4dQ190T54Zkr/D2K99qWiuxVUHKjlPNhIcam7S+3HaO7nkQWdH5u0dtA0y1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NITY6W+g; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e477db7fbso3145772a12.3;
        Fri, 19 Apr 2024 04:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713524924; x=1714129724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gztq7q+tVBfKfiFB41TR2uivJxMSmSRECNayk7q9P5o=;
        b=NITY6W+gh/D6k7iDsgwSkeVVJBXE1otCGC5Qs7Y/aUhht6p4l8CPyy6z+86LY6WykK
         ii/G9SxkpOcBcH3omBR18JmP92kJLs64iew3KRFySE73gUk63FjufhnMTehmaepVw6Qz
         iZYLhsIfNClk5Tvo2UmkTtc4Sipv34JqaHguGPpnLdKZcxsQmAm+TUPo2dAg3pJ/m+WO
         jgFxc+3Wc1981wXwy0Wk0yxeCbKI3pOr3snFKRjbEfNZr/SzRhcFNZf9D+/elCNVLTv4
         WHfaKTpvFVLJOJ14JkTr7zQnUv/HGFWmlC6pApw5lF8pBSx9Kkref/2nRyrdbxwmg5C6
         FwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713524924; x=1714129724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gztq7q+tVBfKfiFB41TR2uivJxMSmSRECNayk7q9P5o=;
        b=vqDnicXStK5rcLIKwpwcitoR/JzDxsQ+UTg6PQrNkmm/tuzmHvrRBYx+sl+7d4gJYD
         hP8fSZD+ZDS3IwZvwXlhpdYqQWDJHNwD1ZwhFpv0CLDUwhGlK0XeJkZYydFeBioFiNXA
         0ErTIJhU78Sa/MxszD5GuXTyX7LIaFXlhuWBoZ2g/t5RXWA4le4HqUo5mriHcIVEdm2v
         a72tT2jEMT/CW1XwMtgSuQ4gcQopD1SVBlBiYNflbyYcB7aZZq8PIAl8fX9QYQVYQjcp
         lx5JOzr71GCotFSaqv6y4akIgPjeWsZrSs42Fv1kghesRjWCcCzN6IvAWHAo66voldtF
         /LXA==
X-Forwarded-Encrypted: i=1; AJvYcCXmZW+7128IdGKIkXIQCDpHJekebwzyLBo362c3Yz6L9wNct/owwfjAg5nPgZTXJs/yoAr0BE/Ow/q75GQ+DGmj/OoK4P2fYIvfrHFa94L/WveuxnIpCdZDdzof
X-Gm-Message-State: AOJu0YwZlN6BTbEddHiDPqNhhLQqnVCi1z/6n3fjvKQL6FdYZKgwffLs
	B7Wupm9LslwvkpIfOT0wOTStIoGqDoIevETP68cjhRHyOY7Yk26ZU6hsDg==
X-Google-Smtp-Source: AGHT+IFLPp89/CqqYt/oDY9TsD6MpTpW+WHomUzd8c9Q6sFQ45RxeiYZXRR2f3kaQNaQYK9HhlusCw==
X-Received: by 2002:a17:907:9624:b0:a52:2a36:38bf with SMTP id gb36-20020a170907962400b00a522a3638bfmr1634494ejc.55.1713524924521;
        Fri, 19 Apr 2024 04:08:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090655cd00b00a4739efd7cesm2082525ejp.60.2024.04.19.04.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 04:08:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH io_uring-next/net-next v2 2/4] net: add callback for setting a ubuf_info to skb
Date: Fri, 19 Apr 2024 12:08:40 +0100
Message-ID: <b7918aadffeb787c84c9e72e34c729dc04f3a45d.1713369317.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713369317.git.asml.silence@gmail.com>
References: <cover.1713369317.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment an skb can only have one ubuf_info associated with it,
which might be a performance problem for zerocopy sends in cases like
TCP via io_uring. Add a callback for assigning ubuf_info to skb, this
way we will implement smarter assignment later like linking ubuf_info
together.

Note, it's an optional callback, which should be compatible with
skb_zcopy_set(), that's because the net stack might potentially decide
to clone an skb and take another reference to ubuf_info whenever it
wishes. Also, a correct implementation should always be able to bind to
an skb without prior ubuf_info, otherwise we could end up in a situation
when the send would not be able to progress.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a44954264746..f76825e5b92a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -530,6 +530,8 @@ enum {
 struct ubuf_info_ops {
 	void (*complete)(struct sk_buff *, struct ubuf_info *,
 			 bool zerocopy_success);
+	/* has to be compatible with skb_zcopy_set() */
+	int (*link_skb)(struct sk_buff *skb, struct ubuf_info *uarg);
 };
 
 /*
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0f4cc759824b..0c8b82750000 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1824,11 +1824,18 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	struct ubuf_info *orig_uarg = skb_zcopy(skb);
 	int err, orig_len = skb->len;
 
-	/* An skb can only point to one uarg. This edge case happens when
-	 * TCP appends to an skb, but zerocopy_realloc triggered a new alloc.
-	 */
-	if (orig_uarg && uarg != orig_uarg)
-		return -EEXIST;
+	if (uarg->ops->link_skb) {
+		err = uarg->ops->link_skb(skb, uarg);
+		if (err)
+			return err;
+	} else {
+		/* An skb can only point to one uarg. This edge case happens
+		 * when TCP appends to an skb, but zerocopy_realloc triggered
+		 * a new alloc.
+		 */
+		if (orig_uarg && uarg != orig_uarg)
+			return -EEXIST;
+	}
 
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
@@ -1842,7 +1849,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		return err;
 	}
 
-	skb_zcopy_set(skb, uarg, NULL);
+	if (!uarg->ops->link_skb)
+		skb_zcopy_set(skb, uarg, NULL);
 	return skb->len - orig_len;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
-- 
2.44.0


