Return-Path: <io-uring+bounces-13948-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fzLXKW8LUmoJLgMAu9opvQ
	(envelope-from <io-uring+bounces-13948-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:22:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 19DF474107D
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:22:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W4d2f/sY";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13948-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13948-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 905AB301946B
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D09E3859F6;
	Sat, 11 Jul 2026 09:22:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FDC38655E
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:22:46 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761768; cv=none; b=SknaryDDKlQFXeT7F8MrGPRMCJtS5A5rDmVGkxPXkmO6uVwmpC1Den+Qgs1vcVUkJZimPwbw/7ER6JkoDbQvlgo2S5YImNxHQnXa1v/uhgzauTmmtJ5ykbUIqsjfaHCdVGV9qGPMYlqfbsuvJDV0xlChV1dZ05MVDoh8KFfO+pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761768; c=relaxed/simple;
	bh=P6EalHP9+BROphJZ27YayPMaRYCunePC8pUzelEWcIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg8T0jCtc19S8bMt0eAeBEbY+Owmw3JOBe4G7sm0oVTWMqdea2jSQ8glj3ufaKv8BpCmIxw4U22HY3x/sjsIb9h9d+cFaHU/Uy577y3WkiQhNj4HlZ/WjRP8R4jTLMagowg7+7peGtPehDH/6RzlGJbyQtJb8gN6XMNO5yBIogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4d2f/sY; arc=none smtp.client-ip=209.85.218.46
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15f360851aso243949466b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761765; x=1784366565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lvyvBidIg+3UrKO0u6pDrezQDrSqlxgzpFXwZxQCFac=;
        b=W4d2f/sYmntSs1OO/unm+kTutkeKV9eF7SzZd/6S7ZzAnOjZoNjgWbnZf6+KC8RILu
         1qjxI3FYKwGzjgYS2EnGuoHFNoSW1SQzVjUJfyj1vwglN+ic7Z6YSWTuWj8P2WIsdpw/
         0uLztHyEWfwzT5Ja3cn/axnHgEhbzSPWmNzO/tiTuVtz+LLSBoeYJ7e2cqOFKiSycz5C
         lrLEVLkMpOfXUr//Lr785JPSA8Kt9k/7EJ0Kuc4gRm2xwil1f89pOeUNwQzpV2hRLIFg
         PdKzM/HGS/RmSZ7PCy7exfjwrTuCcLQYo62SvAqqiJcPUKYaSHctEYJmsDET0IXJHr4Z
         jorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761765; x=1784366565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lvyvBidIg+3UrKO0u6pDrezQDrSqlxgzpFXwZxQCFac=;
        b=aI1yvX6dB6Vio47FyOmxMX6jAPNqtOu6IkgDF4MjNlrKFqIdWTbQ0MOs8GfVVuRYmL
         I7ufBIm/aa+k3novlx0bGr9XxIK6W28N9BLrTkZ/bmWS3CZdRrthHzUTFKNCLOsCt1cU
         bG/o+FVHiEWKnQtyVszmZOlD4/6asx5ThFDW6lZ9sMQJcqxRqWFrx17yDZjKaOCVtN3a
         h+rppZ/3fvY2iI7i0QJJwhypJwD1yVhZEfXf+J6mBChtUKV+GGm+lqiZrnUR7ZpTpwVE
         GfQs8E+u1LiRlSdlR4hIVIxvSbRFQ17Qu2pkCGNJe5LJHKqR6yQrcGAwQVcP3zf3zSvK
         P65Q==
X-Gm-Message-State: AOJu0YxO4d+m/3QOdyYHQJuYXci7TDLudM3k7Iux+xOk1Mut8TeC6yd5
	yaKn/jbkuzvhOsk45Q6CDUXy6ZdOlPU8njCEAIdidm/qVYCVXmrQ0QYa
X-Gm-Gg: AfdE7cnBvzODLSicyUqdAAa4g+ylgP2UYXMR97k2Qpzc3/bdO40AJkWfC4SUCB81eCF
	7xku0v6XFoOIvXzl8lHoQNvKZi6/0HPX9QDwKW2gauhFp09jVgIMDvqFWZL0mt123mdClSxeM92
	L0BlkRY8MT5hV2ODKIBO90bpGHvWZsNllnCeArBaeApGnUO19OHX7QLXbRaCSpFCDcv3a8TyhBT
	2IlviGHTYSEXm03mB9Ih8lQkcsZbo7dD2sh6G+cOaJYS/zyNiV/AAXYayAP+KdnllUyk2WtMtGc
	VNn4OWWCB1+r1XbeV/Pc8No4cSSx5hJRkjbAmJr/x63oHvzfcfxEuMUg5n+mdhNkxzKT6yr2zpw
	pWbo+s4EJhDGP0RA02UUzWer3fU2GxCSk8Wwyjl5iBtRjh87ujpm3qDQNxd3895ocSg09gvFcGf
	eHDwp0Tu0cOUS8Mmq+DHvr5+GwXXXNkGNP7W+RXLolFTkHwKwOb3wWUjInnEWHDuZoQZPR2F83u
	nK9LgkWQc0eBWwhlSA9r3WsVzfg57+YhfZvhIB+yuCtG7I=
X-Received: by 2002:a17:907:f497:b0:c15:e07a:eb4b with SMTP id a640c23a62f3a-c161e958ae5mr77326966b.3.1783761765333;
        Sat, 11 Jul 2026 02:22:45 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:22:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 2/9] net: add provider specific net_iov field
Date: Sat, 11 Jul 2026 10:22:12 +0100
Message-ID: <f610bd27092b068f2141c2687cb51b6a1e959a1f.1783619193.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783619193.git.asml.silence@gmail.com>
References: <cover.1783619193.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13948-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:netdev@vger.kernel.org,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 19DF474107D

Use a hole in struct net_iov to give some extra space to memory
providers like zcrx. Keeping some extra info in net_iov itself helps
with cache utilisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netmem.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index bccacd21b6c3..a564c510b484 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -95,6 +95,7 @@ enum net_iov_type {
 struct net_iov {
 	struct netmem_desc desc;
 	enum net_iov_type type;
+	unsigned int mp_private;
 	struct net_iov_area *owner;
 };
 
-- 
2.54.0


