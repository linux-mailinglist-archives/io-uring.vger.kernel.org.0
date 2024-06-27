Return-Path: <io-uring+bounces-2369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F382491A732
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 15:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF4712888FE
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 13:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB881849D9;
	Thu, 27 Jun 2024 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6Td1TR2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E8181CE0;
	Thu, 27 Jun 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493187; cv=none; b=ZjyU7tLGRnlrzUcZl9CHlZMGY10C+2V3UezVuy62QyWPaWj5FcVrFCybOy41VVNNu5SVruPodvCkIEN0CF7rymHh09Y2yw4vGxqeViuEFZy+NZWmFeFpOEa7u7QVJ3JZ26BwGABTmP/vFnsJCHRiD9vawwnDQHDbZfOrsBzWkL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493187; c=relaxed/simple;
	bh=7wf4t3zNVFL5MLPArmxzZz/difFq2GZjTGI/zq/4wFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRNM2lmG2OfWKITjSmAT6esIzD0Prm8Nu5m1zWFEYXeYWV0ox1Vpl7Jm+phQrXnObyOa7BUZaRNqSYzSHtTej2Cs9OyuCZeb9ePEHuQF/ZJaZZf9qCNsSmAc9TmjwkZFKwtMoca/Y8ISTqcOJa/uhlX9JxdODr7QL4ipiyqatAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6Td1TR2; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6fd513f18bso799848166b.3;
        Thu, 27 Jun 2024 05:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719493183; x=1720097983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hgg2HLxbQmSoQjOf3ORs+BE3/TW3TRuVxCZz2YM2kI=;
        b=k6Td1TR2QX63+vdS7q6Q2IEJYONyoLl8BXJE5AXduqiSg+VbWAyW4R30KGBxHdBsEq
         7iav5yjWo2X2Srdnv2urzueMAH87TzoZDYqRZ/gSV0sbqevtpsSa7nYwVfmNUyugVFON
         QZcVKKj5DFhwPgF+m9BwYUdXp+9oltqXgXk7E42JAyaeXqV42pf8HvUeCQQO914rAhg8
         TRYb9yZMx+9jWlI+B6e1fw1DOzw6uJF19G6mcijesxVNcqWM4BPPLK/dtUOepbH/7Nfx
         l1Y4yP7lz24pfsQYlUPvgAfS3ND07rYfK21mZsw0xKAoshqJ8bpSawCIze2yRgZe3xpp
         plZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493183; x=1720097983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hgg2HLxbQmSoQjOf3ORs+BE3/TW3TRuVxCZz2YM2kI=;
        b=tQlpltvq3nhkaEUtPZEuKtSOFPGxZdahTXZqvplzB10W3X1VnfUm9VNZKrWU8EB1qy
         3KxeLsp4Qud0TR2ahEDdS9PFJgptIg51mQgMq191T3mSOAXeavLpVnJH/eemebHH9JHO
         uQM4y7xYAZXQSW2aS97wbGT6jT6WBFDwWGxKOAB6agPtrXqH1Ut8RB+4xPbXH1CVnmzh
         c7ftmnBkZ53Hsr7VHtdCIt70RESZsiuwkx4qamyAHjUPr5RvUFUrp39wwhd1bgUhBun7
         Ql9P7Wojjkaw6DQUhoL9Kv0l5Ya5X7CI7ged41jg2SCzQtn0vyHSWUkoQhiFRaqnKTa/
         L88Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1h8i6tDqa06N8batGdSPaIVqADL66RIzZwDDpjSg8bFxM3gIzUrwzltbN5DqX6P4wbJX/ui4LdomguIm1keNr1R+LpPvD
X-Gm-Message-State: AOJu0Ywi+UxlPu9R+IAqJ2P0zTGtxVH6mWVWw8s+Hh4iWcJsmvv8oEFR
	Zyeq1spgCuTPOe4Ysh5hcbZ6ARW95g15oBYUB5CEZi5wdRYmEIApoANftiIh
X-Google-Smtp-Source: AGHT+IHvtGynC0PYko7Pz/guu5wq17ijkLER0KNUXZnI3f8bZvANVMd95hl74otdAJvA8s2YdeeFjg==
X-Received: by 2002:a17:907:d047:b0:a72:744e:6703 with SMTP id a640c23a62f3a-a72744e6addmr601006266b.22.1719493183491;
        Thu, 27 Jun 2024 05:59:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d7c95a3sm57267766b.194.2024.06.27.05.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 05:59:43 -0700 (PDT)
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
Subject: [PATCH net-next 2/5] net: split __zerocopy_sg_from_iter()
Date: Thu, 27 Jun 2024 13:59:42 +0100
Message-ID: <e128f814a989914c27318dcbd8f8c7406c9b9fd3.1719190216.git.asml.silence@gmail.com>
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

Split a function out of __zerocopy_sg_from_iter() that only cares about
the traditional path with refcounted pages and doesn't need to know
about ->sg_from_iter. A preparation patch, we'll improve on the function
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/datagram.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 95f242591fd2..7f7d5da2e406 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -610,16 +610,10 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
-int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
-			    struct sk_buff *skb, struct iov_iter *from,
-			    size_t length)
+static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
+					struct iov_iter *from, size_t length)
 {
-	int frag;
-
-	if (msg && msg->msg_ubuf && msg->sg_from_iter)
-		return msg->sg_from_iter(sk, skb, from, length);
-
-	frag = skb_shinfo(skb)->nr_frags;
+	int frag = skb_shinfo(skb)->nr_frags;
 
 	while (length && iov_iter_count(from)) {
 		struct page *head, *last_head = NULL;
@@ -692,6 +686,16 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	}
 	return 0;
 }
+
+int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
+			    struct sk_buff *skb, struct iov_iter *from,
+			    size_t length)
+{
+	if (msg && msg->msg_ubuf && msg->sg_from_iter)
+		return msg->sg_from_iter(sk, skb, from, length);
+	else
+		return zerocopy_fill_skb_from_iter(sk, skb, from, length);
+}
 EXPORT_SYMBOL(__zerocopy_sg_from_iter);
 
 /**
-- 
2.44.0


