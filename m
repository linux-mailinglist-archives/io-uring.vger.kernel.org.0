Return-Path: <io-uring+bounces-5761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C06AEA067D9
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F78167C08
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384D7204F6A;
	Wed,  8 Jan 2025 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ijaa+zOr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CBB204C38
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374034; cv=none; b=KIEzoYKChrDL33fb+WEedheMQtO4OgSoq5c3X7k8ajpWKwbviM7MkO8ANOIJvtr3vLHWmpw4Op6hqsc8js8gRFGzGq/J9D2/GUzqNfsMVpleU/aURzvNxfv4UX4xtJ8Xx1CnxS/JOCalYYztT9lto2OOkVbDXa3uNKSvlf9ILLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374034; c=relaxed/simple;
	bh=BLz2CIl+2gWaVD1yXUBMqm+9EtPiGKPqSFLgPfg/p4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwTDwoKbj8BhHR929NYC6I3hVtV7PFtUPI5BGtVvLXxIICr7mk5AHjWcr21NrNEhvXMnc65SR2pJrSxV3i8/QAgELymJXR+V03hP541frKnQSRGT9ZyVjVAbdEOu32QuqqG+4k0TbegScxb7J6n8tECKG9O/x8TqcOHxBRL/yBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ijaa+zOr; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21636268e43so4118165ad.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374032; x=1736978832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mX/tjyz7ib4qidu6OyYUCNKQIC8lKBXHPUPNB1Bean4=;
        b=ijaa+zOruUF1SCTIV7cKfw7SaBorWMxiJ9rmP3g2PvWOpmHCLTYggEcIPirDERYUy+
         FUhVGoqjNRETFL59QGx5QanS9pyvtZCLpaWqesEsaxGVQzzcXwOx1BRtk5Pq6xzedxhD
         k/DjrnEh21qvCn4kErJy3HZOjHh/KWWYknFTCe5gZTD0Vez3hGPiplitYvfGc4MDpvOv
         En1T3y/rDjIT0N4Qb/sCY6DFYbeTHyxkRJTLyQqD8UnuHR8G+bYMfq4yY/zlGVy01B4x
         w9a55vhrTt6LfDIrPxxBWz0EC5pNYL2ANrZdw4iMplSaNb6imhQlKIRq3lUs79rEGn1h
         8iPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374032; x=1736978832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mX/tjyz7ib4qidu6OyYUCNKQIC8lKBXHPUPNB1Bean4=;
        b=MaBteP5qpgfisXpm0Txa83KRlUJt+g9lwaeR9DBDJDtHTOCDzIkDw2Vt8jD2GwEine
         d75M/MZUAaYrb7TzUKPfcJjfLqrbLOZqbEj4uSaSVkEQvPy6xDBGOVDSi2/0fkKfMKGD
         liVR1BeBGiLPbDhmDYLYkVQEVoysZzNGjboOe57jRzuyBgYitCLZDWNySSzU7lXo2/4o
         C2JX0SAmkAI3rg3nM9czvRcfjzhMCdSISBixBy1IjfiTJFf/zzlDmSVYEaHsxuyaOwqM
         PKMb/5VqdaX8U8eWNcv7YYLQHCISwGHJlBTdNUfmbHAJ/sPwiN4H+ynbmFtwHLqVL127
         nOAA==
X-Gm-Message-State: AOJu0YzfGAt6qfHh9F1Lauq+Wxabhz/rMh6CLEn4/ZiJW6KDiGrSuc5T
	LvIR/pwUAaIiv285hCL9kzbjJgNGlmXue3XYc6sKvpbKFpYgwLrNetX4uD5AXGUycIfGsvfjZW9
	F
X-Gm-Gg: ASbGncu9Y8qnJAffCY99NgrstJsV7BtblFS33/ZefF0gHh6lXpsWe3juSTH8lQSFjid
	srtdxUqebA0FBZDldxH9r4mPh2q5s3mkbTSr4lzFU7wazSQ/85fu5OIMyWsZkUuv5Leg8NItHiB
	YPqm94Ucb5y5RJqobzzybhm5LPOiQoS88nUpJJp7HgS+yZGZIi/7PnsyTla95QTMh9iCXFyLt8g
	b1MQtdRZreqzi+uSfiig9lo+HwhhfqNEK22PAGbIQ==
X-Google-Smtp-Source: AGHT+IFQ/fod37JQsWNUJCo1pK530n5DANk+hYj+5M6R5H9LpNdJGMMQyjPm5JTJAtys3l6Z+VUAHg==
X-Received: by 2002:a05:6a21:33aa:b0:1e1:f281:8cec with SMTP id adf61e73a8af0-1e88cfa61dcmr7504727637.10.1736374031918;
        Wed, 08 Jan 2025 14:07:11 -0800 (PST)
Received: from localhost ([2a03:2880:ff:11::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8fb9fcsm35897270b3a.164.2025.01.08.14.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:11 -0800 (PST)
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
Subject: [PATCH net-next v10 07/22] netdev: add io_uring memory provider info
Date: Wed,  8 Jan 2025 14:06:28 -0800
Message-ID: <20250108220644.3528845-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
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


