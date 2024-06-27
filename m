Return-Path: <io-uring+bounces-2368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A99C91A730
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 15:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C76F11C24BE4
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 13:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83672184103;
	Thu, 27 Jun 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOGo4amE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E7517839F;
	Thu, 27 Jun 2024 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493186; cv=none; b=C73qFxWC1Puw8G4/zO8NvJKHrsTIcRptyzov5lihIJkmkDJZF77YA48nFsxTiBERP41v00GwRxtFuMBMFfLh6c4j83J8BDG6SyuJuiISHh/vSHfzwBxVdO/EWzVxFvsXsyrjrkjhwSr8bb0Qi4d2ZWTbrhpCyZ6OJ03DLI/xM9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493186; c=relaxed/simple;
	bh=7ZoYhK/CgONEjG9pC9F7RougkB4yL0GdwFlB4sNvNOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwMLEMzk3E9GgZNnrfMnXFts5YXKCaX510dHXb/seJwP12Y53HqQjh8xTVaArE0QBW7SLoFbGPbjPjB0ktM0qpLCmWIeXjRmEO/o2vT3t077pmDfGEzUUd5jXvKTZLkB9Ar8SKtID/yo4WmsreGSJ8ZmTtNRH8JkpiQqeMOyDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LOGo4amE; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a70c0349b64so560015466b.1;
        Thu, 27 Jun 2024 05:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719493183; x=1720097983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjjoRZWG8PWTBUhXIjiqjxdChiGsNUGZ3NtShy0+Zv0=;
        b=LOGo4amEx/e+C/hOGvnBou48TUffSijRn35voo+W1DKS47nL9YezS5frUXTgPAqx1O
         mADbmE6XUg/1K7+ir0DTz2GHTizRN1Mugfu1pXSUYVeKzhCTvASYKdEj4F7pASeEg2Yk
         wsRqDJcS+NDTRTl+HusS4I3tIyP+16aM6u350j5ahIPZecbPfdwKsTRN2r/g6ZTTINev
         kgA0H/Sj4Dth447ui6msdgFMX78WX0lpj7z9XzE5cQdPQ/UfuCg4K4ys1N/tYbK3goJo
         XzDKoOfgALykBwC3OUIgTcrNLcgjggvT56lXLeLB2Sh6tQBvsT+zoKQLj8BNCtMp4yb/
         IlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493183; x=1720097983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjjoRZWG8PWTBUhXIjiqjxdChiGsNUGZ3NtShy0+Zv0=;
        b=EqkXMsX5ow1v/nrXXkMXH51apa05w7FEWGG/oJGyBFoQwaQg8HEAMwykyXQ5SKXsBY
         3pnchJ0eLkjMB4byl+IIaUBJiyeLCsgDEv1n0cP/W/NYQDypt2cpoRXovK7tmQV+zLJS
         czS5/83rYj6Lyap+SiEQFIdvij54JazrfwnmjHsMisyWI8zUKgUDs7HmmJFhYIXETvsx
         Y0RFXHjv3Y+jF4HNLP+EqBNpGEKHmea10jds6FKqQ5YNLTlmzjce8qVJLnBrqR2/KCmt
         GGSDGxBwDdAbWjmK+/f8hjENlczMR6PCg7BzA6gkyN06e2mN6ZUv1U5bzrEXL5FX8fOl
         Jt5A==
X-Forwarded-Encrypted: i=1; AJvYcCUqWGaB9r9VKwV9/RIukpgklyQ5FLjVP17PaQ9bPA0umAWwRhUf7GSWgQR/AS9Pr/Ny/Uwk4O/Ml7t0TgQQrhAkvEOjyB2u
X-Gm-Message-State: AOJu0Yz1ELm/QrwPntz037MQHZ4s/Ls40RYgPyMlIyrh0C+CciA4rK43
	TLusYOWPOeBK1eRf40tPKr5UsRLsOIRGe069tizOoRZvKqvWHb2Kss1yqRPH
X-Google-Smtp-Source: AGHT+IFEi5ivycykCJ1gWjuYw1W1Rj6SojBpuwYqBU2kN2eq/C5/kdirvvuWLtWKRkZFHGfWDINhkw==
X-Received: by 2002:a17:906:318e:b0:a6f:5adc:6533 with SMTP id a640c23a62f3a-a715f9795femr928790266b.46.1719493182718;
        Thu, 27 Jun 2024 05:59:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d7c95a3sm57267766b.194.2024.06.27.05.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 05:59:42 -0700 (PDT)
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
Subject: [PATCH net-next 1/5] net: always try to set ubuf in skb_zerocopy_iter_stream
Date: Thu, 27 Jun 2024 13:59:41 +0100
Message-ID: <398a9b0f677348f62edf3572a4896ddb0ebfb940.1719190216.git.asml.silence@gmail.com>
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

skb_zcopy_set() does nothing if there is already a ubuf_info associated
with an skb, and since ->link_skb should have set it several lines above
the check here essentially does nothing and can be removed. It's also
safer this way, because even if the callback is faulty we'll
have it set.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/skbuff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2315c088e91d..9f28822dde6f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1884,8 +1884,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		return err;
 	}
 
-	if (!uarg->ops->link_skb)
-		skb_zcopy_set(skb, uarg, NULL);
+	skb_zcopy_set(skb, uarg, NULL);
 	return skb->len - orig_len;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
-- 
2.44.0


