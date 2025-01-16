Return-Path: <io-uring+bounces-5930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00913A1453A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 610F4165E79
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0F72419FD;
	Thu, 16 Jan 2025 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="MhWOmsvZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAE324226E
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069437; cv=none; b=X239QBQaFF6QgcqE/T4RBsCesQ6T7DxoCn695pFlkLOCNXL7PsxhxfKN2k9L8edYH+NnqO5roRyCHFcJ3aAfkYO9O5N7/DF2/i28CDHisLu7VnmkytAYqdqj9DoILFov9+uNnAs0MpnOVb/VjmKPaSBwuRAv4N/mHgkncrahtaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069437; c=relaxed/simple;
	bh=pC+izCPPiOw4hj77bHjJXxuiiJXIs1YU+ft+8NS5olQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+2rpz+EmkhV9qwKIxPR/02PgPfm6qX50plNabJWDaw+/LAjfLGNwgwKjLxoq8Nwdog1YyRffxcnWZUe/un+/5SG8t2v4BbGKoKi5ote77oTbYq4Q+MfUoiG7zLaAbIxC994jizIBkRxVa3C0GF5d/L0CzaC8n86kKZ8WTaYfbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=MhWOmsvZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2165cb60719so27712595ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069435; x=1737674235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FSAJNCphdORunxyfbKbeJpz17xsYuZAoUUdQ0kuFhk=;
        b=MhWOmsvZSKuJFs4nOFUyxc3wjG6PCpQOc7daLyTV1R5lAL1DNu4krWXdbrYIUS6Rf+
         HqdCXNSNzpX74oeNYs06hijSF+FOAR01WUbUikx5gCBBtRXbItqm/htgMnQJljI83r9F
         NicwGwYdmNFe2JuvDys2FzDUjnNY/i/mZVGj5vfDLPDlLF07LvlC0eRs9aDQhS+8lKAQ
         sE5HAZv/l0m8KuGvSup0x/2F5Oiz056A7pNOiczmchgZkmDvrdWbz/qJNo9p9v3nsWsx
         UE8zw1yVGzHEpTyN7cIf8CYfjDeY5TeEMBTNO29Q6NWLI6RPPpHOSBH2StuRzpxFEzRg
         EMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069435; x=1737674235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FSAJNCphdORunxyfbKbeJpz17xsYuZAoUUdQ0kuFhk=;
        b=XKYihcCV7lVKZFBC7D5nmGsOaESOvYS6tNTzM5kSxXpVTG/O8XQ5gXosElQAVOMGPp
         gIniwo8G0e43MLvyu7xJdn2vd7K+UWs1ca32Q4jlhJduwSftFLGRzh1fA5Vp/9bCp3qw
         YNBKHzNZ2EkSMgv2Tyt/j/W++ewRLvy2/Cs+zZWwz34MiorI0d9gccyn7lclVmbhw72J
         1PBCrvPlhDbLwSnirpoPjpCBBttWjWEQw5W3orpoSEoPzSjQyasHfbqbYMHSg0NDfEtB
         UYeMSB1YhyUyooOfRlhG3QsQXI/5eJEKctejNBjV91NxMiHYMYCTf16nVpg09SvxldD6
         22ng==
X-Gm-Message-State: AOJu0YzsRDbZ3oklatOT8zLOz1yxnU9yb3MY6GAQf+2sLlLOVx4REdWU
	m8snfHUtdClkT8NNzKZPBJ2nSqveer2XXRRwFyhq9opB6ylNYeKik1pE9JquG/jYCtuTt+EMNjs
	t
X-Gm-Gg: ASbGncuRUW1tukdXnud8pCrhc1eS/LVx9m1CmhefIW5bVZiAf04jazO0uQflMolJFOK
	KCyNHXVwUgufGoa/O9VPO21dIGtj++iTCv1MPTtVf2XpfVitnp4/j0KPvcmr4n5M9N0ByX41Hyr
	LbDFu+o7gVxVffGwEMD1hVncSTFYjdMdkK7m1Kj4/Vf+5QrQhTBphzZ1S+cFqSZ+TKKk+9f2XAb
	4ZA5P1kdeD61wO3RxWxcg0+AMV8QzewFpeJgd81WQ==
X-Google-Smtp-Source: AGHT+IHedyepUZITwcmVCPI/PDCZLlhzbajAfD5uFw0pI37FVETUFJhRTBupzGFiFEFPGnhoIgXD6w==
X-Received: by 2002:a17:90a:e183:b0:2f5:63a:449c with SMTP id 98e67ed59e1d1-2f782d4ef30mr576843a91.28.1737069435153;
        Thu, 16 Jan 2025 15:17:15 -0800 (PST)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c2bb480sm3855603a91.33.2025.01.16.15.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:14 -0800 (PST)
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
Subject: [PATCH net-next v11 05/21] netdev: add io_uring memory provider info
Date: Thu, 16 Jan 2025 15:16:47 -0800
Message-ID: <20250116231704.2402455-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.43.5


