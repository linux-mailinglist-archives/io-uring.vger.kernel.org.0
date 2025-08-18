Return-Path: <io-uring+bounces-9017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AAE6B2A868
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4793F6E1EE8
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B763218B5;
	Mon, 18 Aug 2025 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+e//LQC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B12F320CC6;
	Mon, 18 Aug 2025 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525398; cv=none; b=NBtvxL97a+rD+/WlDS9Fz27p3mAc7vAFXSrN6M0tuQte1kKjTZvydZ/W8TMjHOBahK6IpOi3baMAYcV6a4D9Y4rN2tEUn4lOZnVqa7qcwHUh6b7ta+fpDgc2xjM9cALS6VkqD3ScXSYawaF675LUYQtXM3vKq0KsALKYj69rXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525398; c=relaxed/simple;
	bh=HrrAxyj61SLnsN3GJ6LjWToWuINFN/Kn5UpaU740itM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwb4cEwTPADVyLEqbuOujpbX3r/r59Cjm1PsOXAYRiQcvQ1mMwC82MUVdifRynlGf1aM1pTq7soealwx2pLj/pVGahzPFs91YQPiSWchIzraepc7zAeCuVrnvas63i8slYUqD2gyguN90EmaVBng7z+IHUrW6Kn26x8uH9N8pck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+e//LQC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1b0becf5so21594955e9.2;
        Mon, 18 Aug 2025 06:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525394; x=1756130194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBAG0Fay451JgNwYj7hM+/kGoelDE4FVCawIWFGrRP8=;
        b=D+e//LQC9bRe4e/Z2lZ42tSlY/Hc2aoh7W3PzN9dAqETkL0STzNDQ0lyHTvhvr2TQr
         on1Yl10h6bClmYxj6D/SOsidDoGrAy4qJsSLQqi9u9wSggpekH1hS3RShtQb88b1y7XX
         KTCIadI+ZwqLFUUZhwJqwN+90TZl4OWfgSL9O5iTOCKV/wJVVJ9hPwgrKUl414tfhk6h
         ppHXk04i5oWjdmlkwXl5L7RReI5Jcb8TZy86nKEEkOCCp6XYJBzE0XHT04A3WmeBol5d
         x7Xn+OJkXumcLeHHXjjQNADGCRyc7McX6P7uylBNEGMTBOXJ+NmIctahH+c122qlmLMq
         FRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525394; x=1756130194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBAG0Fay451JgNwYj7hM+/kGoelDE4FVCawIWFGrRP8=;
        b=e0N0tcVp/txAwgzeCttdl7COwS4JQg92adtOdUpgNQ1UszuJ8zaE+x+kUzNGL+8INK
         KLWonhfhWM3h/ZtR5F7te7+7cChk8NnP1qkZuyA5908wKgVC+EWak3xChRuGaMLoedZQ
         x9NW/ik06jL5F3FcJ7C3rfzjySMIjMJqa3zgXNZ9HjXn3cIaycpTdDMKiDrlWGUMQ3Xv
         UxF7CN33iDs/jyL0/oir36Wx/bpa0Wlk+IiYIQwNxtS+dbzh7PK4sfv6ZPBOejTWbZmS
         Km7kohNs4caYcDrxKWrOc1WtArAck3tXIvnlIJGdGgBlifZaJcnS9edB3EwASdzyqeYd
         kkog==
X-Forwarded-Encrypted: i=1; AJvYcCUEzylFtOfpbJ6mOWxfU7+2WSH4ApDsAOVE5OWVoGYow52buwEY67APxt4CrjBPtMb7BKqUCqLpbA==@vger.kernel.org, AJvYcCWlWE4rbzLpArGms9ksdk5tlqPZtA1ikti40/bsgDBFbJrKETvONZIGpOvOuk6QQQmrLqiOw46W+RxTWThg@vger.kernel.org, AJvYcCX7+8FCUaL3tSi2EBl3RYHfxbGRvuOtgj2zcRq4ImS+salWadQ94X3Vi7soXFa+RYmvkecOYwcO@vger.kernel.org
X-Gm-Message-State: AOJu0YynkseXQCtV7Y+ZtAYXyHxw/NC/sNBsmuSKbuMqF1ZMOT3A7F/b
	e2elfYj5rPUQCJhqG3kdzWPa4QlJiWYv6ftHnzTfvuLKYcRLS6JkWvGP
X-Gm-Gg: ASbGnct3JRIXjJeVMeOKm2kS6XeytZN58t7kqGbmfkGw/sSrvmiuVvb2R9Y6qIHLsJg
	8qecovkamSEvU8YRQCS1BL4IOzvaZzCpO1YYrwaK2GB9lZUy0232ReIfH/XMNHsspwwRgcV6TOd
	1zEJh9H5iXfXraGfSDGgHiC7/B1o/NaLbWm4kQtWRlnHmaJapDclWfrGAutDM16XfBXKF3Fuym+
	7ALgwvG+7lVtHejV1a8fTcxK4XZU2cShslXwJCUCzYrIWsjB2q74pkCgEGi+g4DbbOqwMvaICsN
	dO9Ony+eqMS1WGrtQiqXDbrOUM73mgk+e5RZqf213+kP1SsT+IpphLR+whs8dAIW85HBVu/INvF
	/NoJqI+CHM4Whd0ZbGdK2DstfItixyKTyXQ==
X-Google-Smtp-Source: AGHT+IEX7pzIuAwqyMznwnGBXAQ/IYXLai9r4ecCjkFzntVgaCB8J6e+LGm7kUWPJDcSneo0XZSz+A==
X-Received: by 2002:a05:600c:1c11:b0:453:78f:fa9f with SMTP id 5b1f17b1804b1-45a21800120mr95968575e9.11.1755525393444;
        Mon, 18 Aug 2025 06:56:33 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 02/23] docs: ethtool: document that rx_buf_len must control payload lengths
Date: Mon, 18 Aug 2025 14:57:18 +0100
Message-ID: <353e0195a0f44800c0b5aa4a6d751d3655d9842b.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Document the semantics of the rx_buf_len ethtool ring param.
Clarify its meaning in case of HDS, where driver may have
two separate buffer pools.

The various zero-copy TCP Rx schemes we have suffer from memory
management overhead. Specifically applications aren't too impressed
with the number of 4kB buffers they have to juggle. Zero-copy
TCP makes most sense with larger memory transfers so using
16kB or 32kB buffers (with the help of HW-GRO) feels more
natural.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index ab20c644af24..cae372f719d1 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -966,7 +966,6 @@ Kernel checks that requested ring sizes do not exceed limits reported by
 driver. Driver may impose additional constraints and may not support all
 attributes.
 
-
 ``ETHTOOL_A_RINGS_CQE_SIZE`` specifies the completion queue event size.
 Completion queue events (CQE) are the events posted by NIC to indicate the
 completion status of a packet when the packet is sent (like send success or
@@ -980,6 +979,11 @@ completion queue size can be adjusted in the driver if CQE size is modified.
 header / data split feature. If a received packet size is larger than this
 threshold value, header and data will be split.
 
+``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffers driver
+uses to receive packets. If the device uses different buffer pools for
+headers and payload (due to HDS, HW-GRO etc.) this setting must
+control the size of the payload buffers.
+
 CHANNELS_GET
 ============
 
-- 
2.49.0


