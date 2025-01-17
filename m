Return-Path: <io-uring+bounces-5982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E49AAA153D7
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15D703A74A1
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2CC19EED7;
	Fri, 17 Jan 2025 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZVbRuzl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B3219D8AC;
	Fri, 17 Jan 2025 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130285; cv=none; b=OpLDWc+RDMkRiD27TOlmbq1uYFrUp9okGFfw3KWA3lvLkmRmYY1hkXvvAOglf52nbh0b2oONfKK5oWvRbooWDbiWMEWKYL7I7/ZpsXWW8qTBdB7SifsyJV073bE6nUPju2PyPupIKNHrei9WF9a0hOVqo8fHWE7iUdsvy7x/4Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130285; c=relaxed/simple;
	bh=SZl183b/DPWI5juMXy0YwJdwtSzW+eSy82+x2+PSLiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvJ9+jlY7XctNcOdCFMiShkidd4D4AafCOjkg0Mv07csmQYQQk+aRGq1t5aKOeEDfQ3ABB3+n8rBIjBVdxESNgnE9YQQtpHnA+uEZFBd33aKvUNwDBuvXPamYeZlY/RZV+dlu65gbaPSp1Cz11PXPWOuoPHbNSbGjBxjUQa3tEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UZVbRuzl; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d9f0a6adb4so4656780a12.1;
        Fri, 17 Jan 2025 08:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130282; x=1737735082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIp/+aRSJ8ja9DquormKZLk+R2k2At54M2TTTA6f1ds=;
        b=UZVbRuzluf+DFeXi15Zfeazr5ZrC+8IsRi1mI85FVE+UQaZexACazYji8Vyi8V5iQM
         uNVXGaKctHLdeq2oslE20f3G2dRr3DC1mze38pCFE7I+KB+Wf6FQ60fhVDZaYMTUBl4C
         JapAl0uf0Yda/gnJXD/RtLl75G3qscXkJ3Km179Qp7gbU0o4NUkLSBVAja3Cx6/YTDuV
         E6zZSNzDTjojXw2UyMDESooHASWsHajzF0K82CF++qbb05iSaN4PU2QCjrjLuk7ve2n0
         vzp7UQEeI1ny/T0v1tCZO2Nv4zMIrN/rDf2BIq21iG555GB+MgeZP3ehQluaPtAbl48a
         FFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130282; x=1737735082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qIp/+aRSJ8ja9DquormKZLk+R2k2At54M2TTTA6f1ds=;
        b=noEAAnrFoCQHlZAOHFme9aetCXN3kjzYK2l7jrJgs7LJNvC+wnAteD+mt+8L8WrjSU
         N5lnpoM+7qRIzFTbh96He2oSdTFoZLd9EY8JwWZfh3rAmQaYYu0lYrm6PV2nhWYzNSdt
         pTLdQ7rYo624LYeWb4aTYXEZSf7Ykw7tywpgW/tcK74jp0n9wEemTe6m51R51+W0vZrA
         E6+RCjhWQqbGDhPBbIwJpKAy6h42PzRr8POeqIngOqr08VHo195h6mMHdJVb+xIudvas
         cRni2Q52eOLHjJebfs2qvBiuWjxqK6491eGJz3zqaY67z0UIcjp4gboBo+zXHe3DUyOU
         kCig==
X-Forwarded-Encrypted: i=1; AJvYcCVKx6vnvZcgHb5yNPH2gNgNX0QsBnyw/FitfiQlKx2dLmB6KHRUDmOOCzgc2ktJ0alEgQtuKiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/B54+ut5iGe63xJcyciw8x5bDe1ZPPpIui8GzKZbsko7+LheE
	jOuhQ51Cz6KAssNO04UAyUX/Dhsv2nNFZ+PPTxXkfIwrwh/RjgPdMTzneA==
X-Gm-Gg: ASbGncuWSm8oy5SGkyx5AGWNolW/GgXrAgYS7iMoq5rCLlb1QGzbx25IetAlECZ1r3g
	K2Eu8WO++ycbkd9+blBATd5ghpFNZ39YIRHR2N0fRx+8M5eX/J2IENgf6V4ejXT0chmC9foIHqz
	FRI6rv4zBJoZYqmlE6Y4PKaMXkjDoNraeRlsAUTbCM945itngQOcX2X6HNc+8b+7hcMYrTIycYp
	8BIOhSOqqIUKnphnInbWj8ADZk/yq0xYshko7Hq
X-Google-Smtp-Source: AGHT+IGBwGCr881zCycTxUD7CFW5M+lM332oWUYBECQkuzU0tnC5QeBZAh5s8bvB5DcI73VTEMl/iw==
X-Received: by 2002:a17:907:706:b0:ab2:eb1a:9471 with SMTP id a640c23a62f3a-ab38b3cf59fmr331086766b.48.1737130281934;
        Fri, 17 Jan 2025 08:11:21 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:21 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 05/10] netdev: add io_uring memory provider info
Date: Fri, 17 Jan 2025 16:11:43 +0000
Message-ID: <45e621e569a0ad2c172a19d0bbe5977ff6ec42f3.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <dw@davidwei.uk>

Add a nested attribute for io_uring memory provider info. For now it is
empty and its presence indicates that a particular page pool or queue
has an io_uring memory provider attached.

$ ./cli.py --spec netlink/specs/netdev.yaml --dump page-pool-get
[{'id': 80,
  'ifindex': 2,
  'inflight': 64,
  'inflight-mem': 262144,
  'napi-id': 525},
 {'id': 79,
  'ifindex': 2,
  'inflight': 320,
  'inflight-mem': 1310720,
  'io_uring': {},
  'napi-id': 525},
...

$ ./cli.py --spec netlink/specs/netdev.yaml --dump queue-get
[{'id': 0, 'ifindex': 1, 'type': 'rx'},
 {'id': 0, 'ifindex': 1, 'type': 'tx'},
 {'id': 0, 'ifindex': 2, 'napi-id': 513, 'type': 'rx'},
 {'id': 1, 'ifindex': 2, 'napi-id': 514, 'type': 'rx'},
...
 {'id': 12, 'ifindex': 2, 'io_uring': {}, 'napi-id': 525, 'type': 'rx'},
...

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 Documentation/netlink/specs/netdev.yaml | 15 +++++++++++++++
 include/uapi/linux/netdev.h             |  8 ++++++++
 tools/include/uapi/linux/netdev.h       |  8 ++++++++
 3 files changed, 31 insertions(+)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index cbb544bd6c84..288923e965ae 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -114,6 +114,9 @@ attribute-sets:
         doc: Bitmask of enabled AF_XDP features.
         type: u64
         enum: xsk-flags
+  -
+    name: io-uring-provider-info
+    attributes: []
   -
     name: page-pool
     attributes:
@@ -171,6 +174,11 @@ attribute-sets:
         name: dmabuf
         doc: ID of the dmabuf this page-pool is attached to.
         type: u32
+      -
+        name: io-uring
+        doc: io-uring memory provider information.
+        type: nest
+        nested-attributes: io-uring-provider-info
   -
     name: page-pool-info
     subset-of: page-pool
@@ -296,6 +304,11 @@ attribute-sets:
         name: dmabuf
         doc: ID of the dmabuf attached to this queue, if any.
         type: u32
+      -
+        name: io-uring
+        doc: io_uring memory provider information.
+        type: nest
+        nested-attributes: io-uring-provider-info
 
   -
     name: qstats
@@ -572,6 +585,7 @@ operations:
             - inflight-mem
             - detach-time
             - dmabuf
+            - io-uring
       dump:
         reply: *pp-reply
       config-cond: page-pool
@@ -637,6 +651,7 @@ operations:
             - napi-id
             - ifindex
             - dmabuf
+            - io-uring
       dump:
         request:
           attributes:
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index e4be227d3ad6..684090732068 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -86,6 +86,12 @@ enum {
 	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1)
 };
 
+enum {
+
+	__NETDEV_A_IO_URING_PROVIDER_INFO_MAX,
+	NETDEV_A_IO_URING_PROVIDER_INFO_MAX = (__NETDEV_A_IO_URING_PROVIDER_INFO_MAX - 1)
+};
+
 enum {
 	NETDEV_A_PAGE_POOL_ID = 1,
 	NETDEV_A_PAGE_POOL_IFINDEX,
@@ -94,6 +100,7 @@ enum {
 	NETDEV_A_PAGE_POOL_INFLIGHT_MEM,
 	NETDEV_A_PAGE_POOL_DETACH_TIME,
 	NETDEV_A_PAGE_POOL_DMABUF,
+	NETDEV_A_PAGE_POOL_IO_URING,
 
 	__NETDEV_A_PAGE_POOL_MAX,
 	NETDEV_A_PAGE_POOL_MAX = (__NETDEV_A_PAGE_POOL_MAX - 1)
@@ -136,6 +143,7 @@ enum {
 	NETDEV_A_QUEUE_TYPE,
 	NETDEV_A_QUEUE_NAPI_ID,
 	NETDEV_A_QUEUE_DMABUF,
+	NETDEV_A_QUEUE_IO_URING,
 
 	__NETDEV_A_QUEUE_MAX,
 	NETDEV_A_QUEUE_MAX = (__NETDEV_A_QUEUE_MAX - 1)
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index e4be227d3ad6..684090732068 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -86,6 +86,12 @@ enum {
 	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1)
 };
 
+enum {
+
+	__NETDEV_A_IO_URING_PROVIDER_INFO_MAX,
+	NETDEV_A_IO_URING_PROVIDER_INFO_MAX = (__NETDEV_A_IO_URING_PROVIDER_INFO_MAX - 1)
+};
+
 enum {
 	NETDEV_A_PAGE_POOL_ID = 1,
 	NETDEV_A_PAGE_POOL_IFINDEX,
@@ -94,6 +100,7 @@ enum {
 	NETDEV_A_PAGE_POOL_INFLIGHT_MEM,
 	NETDEV_A_PAGE_POOL_DETACH_TIME,
 	NETDEV_A_PAGE_POOL_DMABUF,
+	NETDEV_A_PAGE_POOL_IO_URING,
 
 	__NETDEV_A_PAGE_POOL_MAX,
 	NETDEV_A_PAGE_POOL_MAX = (__NETDEV_A_PAGE_POOL_MAX - 1)
@@ -136,6 +143,7 @@ enum {
 	NETDEV_A_QUEUE_TYPE,
 	NETDEV_A_QUEUE_NAPI_ID,
 	NETDEV_A_QUEUE_DMABUF,
+	NETDEV_A_QUEUE_IO_URING,
 
 	__NETDEV_A_QUEUE_MAX,
 	NETDEV_A_QUEUE_MAX = (__NETDEV_A_QUEUE_MAX - 1)
-- 
2.47.1


