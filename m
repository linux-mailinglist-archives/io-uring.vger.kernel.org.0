Return-Path: <io-uring+bounces-2372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3AB91A738
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 15:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 186551C23EAA
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 13:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C30185E5B;
	Thu, 27 Jun 2024 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jgjAKBxP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108501802DF;
	Thu, 27 Jun 2024 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493191; cv=none; b=sUUf27ef0B8d9JnaVSbEUSMUJmgR1G1VnEzcOuk92xLixq1MVr54ENBPTACw2M7wwZLRQyy4HipOahDepkHDdWi0XvlvlI1nb4LSfjLxtVWEa14WZO9QChLf+g8AskJwxrL4VLLxeLFNJiYv9c3K4izA1oW98dXpV3pWEhRempQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493191; c=relaxed/simple;
	bh=V+7scOsu2EG9oGv6jur44/RxU3MiYpIAUVh4cY5Kd9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHTEEMF+QZ7alyzcDh3H2/6IZFw+XZ9thxhS/X/qT7c9YBcDTW6NCiXrutsgu5RYv6TmF62WahTMo7lZCPf9amkikS8Cz0vqrIGG8bf+wWoXptTF6WZvMCOJj52xvc6lwTjMeAmNPHlQl2ZqO6G+ajF3lc5d1syLCpm7BYQPScU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jgjAKBxP; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a724b4f1218so676143966b.2;
        Thu, 27 Jun 2024 05:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719493188; x=1720097988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iwlyl7jv323B/JiH9F8ir0gBkVWXQIO2tv0pQQWMneQ=;
        b=jgjAKBxPxGATBFMu6vrrUAIKuRxwnMdxzBzH02y+0Lq9Q6XDYfekkkCoXdBxOr3Jrq
         Pb/ji42BWuuZbGT1PfKZTkoEvxyMcAQzeVqYiV85odDSIKhthQK47Lye70XMDuZwexKP
         aiJF7O6au3EF9Hue5Y8dAUwn2YR6j8IYFJ2Cv3njFSj7sy4/gnK1bQ2iXdNvIit34GhX
         D9mlrQDwhVdTM2eCFQKCtgcd6UvtMP9TiXnBF08VUWmdQk7hot798elO6IH48K+Cxhpx
         55Sa4Fq9yseWyUSJHRHV4qJxmY5PmEXoyMV/KI9/X9uyh5TfvjJ7ahSOJBcdWzl+Z9/C
         H4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493188; x=1720097988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iwlyl7jv323B/JiH9F8ir0gBkVWXQIO2tv0pQQWMneQ=;
        b=Wg97BohuBfoYdCnoasVStPLZa1DSLQBKMhs8JtRbqFwxnwoOg7RqwlBM1O783Mm/Gy
         yuB3iugjAX5xpWwmvMWxfGlP8dthsDL9DWRna56DYrFoHSRLTnmF9LvjbOacrnB6BJ/n
         egvnzl9FwjSg5rlEPpRALYL8PMCK1pTeavKrPIOATxSJACgx4g92wEWor6da0gYCbXfT
         BKZ229UgC9/S3moBIi2+bRIeUEQgrkN9n8oFCvHm202KPEYQBhynpzVNiOpNmMzl6iCL
         wmRRTmLGudoYe/hI59g00rvwWM4NgATdDQKqKpun89LmZLCh7e9fnzKKs/lyeMbeNxdU
         yodw==
X-Forwarded-Encrypted: i=1; AJvYcCUUJatMAhHr/ktyIl9OebITjsRNn1xgy++10dZdbF5PaT5znv0N5FqusBBTivTbyCm3We/e0XyaaI8pBoTuCvj/G9USvovz
X-Gm-Message-State: AOJu0Ywg4FmxRjjnz10Ou/HZkElzEyois1ClJdsEolT6ZONX7mhH+GGE
	WXmOI0JODALirGjhlTAIEaBo2Nk/BWaayLBqmwsrL5xwOECBBh1WJp2N3DEr
X-Google-Smtp-Source: AGHT+IFTHUJ0n+XF7DXbRHGFvJLep8DObLADpO+rj9XioGpbHJDhuyTnUgZMnQRnKnGmqYkdXb8L3A==
X-Received: by 2002:a17:907:a649:b0:a72:7e82:7a15 with SMTP id a640c23a62f3a-a727e827b79mr597962266b.23.1719493188175;
        Thu, 27 Jun 2024 05:59:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d7c95a3sm57267766b.194.2024.06.27.05.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 05:59:47 -0700 (PDT)
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
Subject: [PATCH net-next 5/5] net: limit scope of a skb_zerocopy_iter_stream var
Date: Thu, 27 Jun 2024 13:59:45 +0100
Message-ID: <3f4a39b3966204f062200caad857ff822f9f2895.1719190216.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skb_zerocopy_iter_stream() only uses @orig_uarg in the !link_skb path,
and we can move the local variable in the appropriate block.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9f28822dde6f..9b71e4b8796a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1856,7 +1856,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg)
 {
-	struct ubuf_info *orig_uarg = skb_zcopy(skb);
 	int err, orig_len = skb->len;
 
 	if (uarg->ops->link_skb) {
@@ -1864,6 +1863,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		if (err)
 			return err;
 	} else {
+		struct ubuf_info *orig_uarg = skb_zcopy(skb);
+
 		/* An skb can only point to one uarg. This edge case happens
 		 * when TCP appends to an skb, but zerocopy_realloc triggered
 		 * a new alloc.
-- 
2.44.0


