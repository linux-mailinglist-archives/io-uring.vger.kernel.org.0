Return-Path: <io-uring+bounces-5543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A24AC9F5BB2
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE4F216B7BC
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D94481D1;
	Wed, 18 Dec 2024 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Avswi1MT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA697374D1
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482284; cv=none; b=OboP+WNqeDCJjz77ew8x88W7iIWuq9Epue4WCb17nVMy8KFURg112SDx+phaV4XLegCC6RaI/FwvQaEf6dZf2QE+ZvcutsqRmUSFEJnuHvAbs5Jz8WnxtKKx4n85jkc20eWJeGY6mvYM/GyJZWjvZZvT3+sS3YRy4+VpsLEYWn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482284; c=relaxed/simple;
	bh=135g8sWdi14q9q8Itt2VZQPm7R0gFcz1ULHZpEn4dmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khaPgEVqa5hT6tToLsy+FGTWX8nJtjbLPXH+ZvhowqmjrqYVC3o9Im+1v1PMnIWkuypSXJF4/H2Ur/lglQHhSnquebtFrh6taJQ7bNnPxuhUAXVfiouCyr+XfEYUppNVzQ0YK73I2USeXvxYIihlWAlpdqvWRwXVpLp3f5fp0XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Avswi1MT; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7265c18d79bso6295701b3a.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482281; x=1735087081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQ73wFKVt12qccWHG7cPPzOfiVyAwI1MB/XTBNYCLeg=;
        b=Avswi1MT3cwCmp8ZmdnQvv6eSNnUtLFSxWtgryWPBUBQv3fnmraImOQdxuyzCx8zqb
         cDmVA1irUZ5SNO5S+VRr+O3Xb5d6RL4rXN06t+iPlPR3LbHlhwc5cR4PvAwYAXVCpXrQ
         Fp9gUV3jy5EgVYLp/fUo66PerxeZUctk6SbpUkH2KVeig71w0VR1zllAWmrd26KkUuUr
         a8ldijZFoD4c983kq4Vfk6FULYoe/Fkltj27Ig/vIhC45NlmaGqVmu72a6KTXEUYBvXS
         dkceQTUVzFcbd1CHllKp2qRfQOk7JsFGveFbsJmFlHxk5h3p6yKEkJZe6lA/u/xHIPkg
         Bacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482281; x=1735087081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQ73wFKVt12qccWHG7cPPzOfiVyAwI1MB/XTBNYCLeg=;
        b=kReUGZwmQ51Y6HUM3mu3Ue3DT1xEp/N5DvLlwfeyIZxjrczZk3ac5BcjD1tZO4cEGg
         yxBbuKILry44iof7VJiDFpLE9hRAi3stTgHCrg631Lw+Rxm6jPBYCo8nUZgMaiQTObZ9
         Z/EprRM6V334PpYuWWqTsNkNo1lStwBBP8D73j39kYF1Y8L/34jsPTuYr5BpGX3jyJF9
         gtvPxEiofceG/IKcPfYTuZfMdNbAiFwn88oeT+2obPWyKg86fS4sshoj3MjdLzsS8MiI
         lNkOR/5iSWvwG3tdO3+KQVoSeDTPlbdp8/QHQt2QCoSoXLM4ULElZYjQhhZraJBSANtG
         ba/g==
X-Gm-Message-State: AOJu0YyvBWKIY6VDU3nRz6WPXaVVkYE2Mhd+86Mj/RzIIXeGS7n7ioG9
	I/3pS+o1oQmaoopKmNnBF4vArSlHqM3z4QzldqY0jiBjBxE4vIKjPB6Nu0EXRuwUBxkfe+nOayt
	X
X-Gm-Gg: ASbGncsZM9cIjBHi8w0IhbL072CpDbs9jT6k5U5DXJ26DOH4iD7y5YRlkRHRUN77TOo
	TfdshXolroclg3uKMrY/VqSniVbTfEKBg4VxvENhV/TmSucy9q+zvY+xwWBbLqoirGLSM66O5sS
	qIBEzKw/nUwKj1PfJcGTRQZtFvs68JpmVcutmpHNO+mZX7T1LcK0fAAo/+y46vqpX4FV7CKsjjD
	BFCZ3D0Pe+uGRTKY+F3Nn98b7Y33GR+dgpvbgtj+w==
X-Google-Smtp-Source: AGHT+IEncnAy4AjWnukyzHbHIB+xx0R8pVx/ioXleyWjgeqxb6nBK1dbkbwXfUfkrn1tzDRwDHd5ig==
X-Received: by 2002:a05:6a21:c94:b0:1e1:a647:8a3f with SMTP id adf61e73a8af0-1e5b4824307mr2076401637.22.1734482281227;
        Tue, 17 Dec 2024 16:38:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918bad9f8sm7329764b3a.150.2024.12.17.16.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:00 -0800 (PST)
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
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v9 05/20] net: page_pool: add mp op for netlink reporting
Date: Tue, 17 Dec 2024 16:37:31 -0800
Message-ID: <20241218003748.796939-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add a mandatory memory provider callback that prints information about
the provider.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/devmem.c             | 9 +++++++++
 net/core/page_pool_user.c     | 3 +--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index d6241e8a5106..a473ea0c48c4 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -157,6 +157,7 @@ struct memory_provider_ops {
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	int (*nl_report)(const struct page_pool *pool, struct sk_buff *rsp);
 };
 
 struct pp_memory_provider_params {
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 48903b7ab215..df51a6c312db 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -394,9 +394,18 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
 	return false;
 }
 
+static int mp_dmabuf_devmem_nl_report(const struct page_pool *pool,
+				      struct sk_buff *rsp)
+{
+	const struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
+
+	return nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id);
+}
+
 static const struct memory_provider_ops dmabuf_devmem_ops = {
 	.init			= mp_dmabuf_devmem_init,
 	.destroy		= mp_dmabuf_devmem_destroy,
 	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
 	.release_netmem		= mp_dmabuf_devmem_release_page,
+	.nl_report		= mp_dmabuf_devmem_nl_report,
 };
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 8d31c71bea1a..61212f388bc8 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -214,7 +214,6 @@ static int
 page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		  const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
 	size_t inflight, refsz;
 	void *hdr;
 
@@ -244,7 +243,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 			 pool->user.detach_time))
 		goto err_cancel;
 
-	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
+	if (pool->mp_ops && pool->mp_ops->nl_report(pool, rsp))
 		goto err_cancel;
 
 	genlmsg_end(rsp, hdr);
-- 
2.43.5


