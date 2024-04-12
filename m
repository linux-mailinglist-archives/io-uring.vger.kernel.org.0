Return-Path: <io-uring+bounces-1522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC1B8A2EA6
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6E56B2155C
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA8B5B1E8;
	Fri, 12 Apr 2024 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7/v0226"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1145A0FE;
	Fri, 12 Apr 2024 12:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926539; cv=none; b=duZDNrH5vsVPgpzgsmhf9Q25nZgJfaW2qcjiPihuA2KHvH58oRj2t56MULJS020pknL3kIDKRxJLYwvp7u5R0EoUWcOaSyelEtDXz63UID/L4Y4Zn4XEtuH8tlUNBOWT+rtaj0X4INN651GW8t1gRcoJxi33Q9swxf/Anyw0N/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926539; c=relaxed/simple;
	bh=nnVzZ/5kAa/izHjn2UfPI1FOnktlC7X+kBBZVKz0ESw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJKAlbwUw2bL+uTaRJRv0Vv3duLpZVI6qCi0MAVv08YknZNSjg1W9Qg5/PBXNgrKde6PLqAQRGqYYZKcaJSBb7caXVYJ/WlHEBZu73yGUGjDB8RyaBbdbzS8NnIaov8p/VbbZJJ8Fv51Xbai8D5t8s7ZekqZGlLaLrx2amelL9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y7/v0226; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56fe8093c9eso845272a12.3;
        Fri, 12 Apr 2024 05:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926536; x=1713531336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9q0kwJKFg8QYJez2kJDUkUykIMbBt4afcht1V97p18=;
        b=Y7/v0226ceVplJw6TPTzeAZniOuGSVqWb0AzYv97XRH8/ME+TxBKuU8aRzEfOUEsQh
         suzTCYPAlgoDj5KJGdWa+bB9TztC4OfIAfA5rgLMR9lypcBfHNzJEnU+K8OxMo/TKC8d
         UKZfKVH7jzYF8aKVt54WkOFpQJI/XlGb3R/FxbvLxi+rfuBZEBzJ7f+JqSjR7Vubq/eH
         E8J48fTOeeFkKI3RJLYkVi43jzDCLAaJ90JQ0AerxGXZXiKFEmGCrk3lUSMhMpL3nuqh
         G8J8uVb44JywqxkmWIRSNFZ/rQs9X4279aGKhzLBTGYwfbzuarWIFBoJ+vSakEX3nLRX
         TIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926536; x=1713531336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9q0kwJKFg8QYJez2kJDUkUykIMbBt4afcht1V97p18=;
        b=Jwh+YkCUcUG+s9n3d1MdnjeAX8DILt/45S9GUmI7wEdKiLhn8rBhxlZAc3dlrFZjM9
         Q0G7e1aQd/Z3x2m+5+3qIz7j/SCuXJ6GkeW4G5XAakkMh39qHmE3IQvbnSDClWlAAw4I
         ii7EvRfa9wNbysKGfhLElmZ1g6DikoaAw9n2tyczYav8GNrhTvzOtu/vgurD8SLk0dRc
         kkU9xC35XX8DNkuWZiFplj3aqN1kzItdMoZntSwE6Ha5XF9+OA4OEaImU2YfiVIu7BuU
         zsxlw7iJGh63gAxtU+dW7w0k0RN8my7V74acclcdOS5uOilGw+Twp5n6kS3434L1ywdQ
         YjFA==
X-Forwarded-Encrypted: i=1; AJvYcCXMm0ownYKawU0s3kZlnkGWJDTth0usrORikmg5MN5pj6zF5iiNHxEil9htY1g/sUjavXr87TENWRfuGge9KTjgsy6ffgo+
X-Gm-Message-State: AOJu0YxVLN0PgQzTBZ7YwgMLeBMOV92yh7eyORVV18HU5TnXf0MkwstF
	6kVnBDJ5sFXGsyhqsoACnX7DLj9UWph2K16TNwCHo3TGz+sSIjg6aaCiAw==
X-Google-Smtp-Source: AGHT+IGT4Aj0LXY5I8Fl7BlsyVEv6USGyEQhdi1UaM+tYMczu/nO4qEDAJPcHW7xL823e93oDoh+Zg==
X-Received: by 2002:a17:906:af8b:b0:a51:8d60:215a with SMTP id mj11-20020a170906af8b00b00a518d60215amr1540878ejb.27.1712926536515;
        Fri, 12 Apr 2024 05:55:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC 2/6] net: add callback for setting a ubuf_info to skb
Date: Fri, 12 Apr 2024 13:55:23 +0100
Message-ID: <d0d9e3fffcaba4ace1fb8f437bd4783928bb2d24.1712923998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a110e97e074a..ced69f37977f 100644
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
index 749abab23a67..1922e3d09c7f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1881,11 +1881,18 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
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
@@ -1899,7 +1906,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
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


