Return-Path: <io-uring+bounces-11561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D67D08E70
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 12:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80DDB30A83BF
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 11:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B2E3590DD;
	Fri,  9 Jan 2026 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZ3zDuHu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36DC31B825
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 11:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958144; cv=none; b=c2howaX0AXCMSdwOTfC2iU/E4SRGeW/wGfkRBsOjiCz4juF1JOb3NuETGSFLMGulE/5+jj8PixuBUhNK9Ma+u8A2/v4+3LkPe0XAmKMpe8gZO/4fk8B7n4bhcla5aqe8G1jGfMsETf9ONSbEHSzwed9uZVwjQ69B7XeoVBiY2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958144; c=relaxed/simple;
	bh=42xckaESf3j1/c9BstDJDSEUMXBt7iNWBkDF/+HLvPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3uwlhR6wfGCmoXNE2iV9oSvu6lEfWANnNnc2TzUJ8romn+irnEmY6kF3j6L5Nmc6I46kq/yy6F5DeMOFm4LYmz573hENIAYd3lizlWNhbQvFFPGJvdV0jGmLW951LvX91N3lMo08jQ5OOd1RK9ppsY8IaH3Zv2nRT0L0omVawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZ3zDuHu; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477563e28a3so20601035e9.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 03:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767958139; x=1768562939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzXTN5GPRXX9JktaEoAXzWi3s9VynOdluwYCuvOxVM0=;
        b=jZ3zDuHuxK/Sqh+ceepekrnR1yweshgh3nHdiD/9KnWrRAWkW/XMXE9GARjOudogPX
         U4Z8cx2+IVIflPUlCwqB09iQwl09IJ+vDDp8GN25fuhrH5zNp1yRGaL1ySn1tMG4aHe1
         6/BNMOID5X043DtlHMcO/RjOYjhdIIhSV6HSoYuBQtEdc6Y5SXf/0dF1vYyVdxWCpdeX
         g4aQpT5qQxsYmSeS57iEMWLnzqdDwihPt7cWOfnGPbMt6nhV4FkbzpARDA7P65bczK+T
         6QF0va02S1sVrsfjPkr0SRmmV/2MLlmUKZlM05C744KYpXKxnfOPzNPh5uMR41n5Rp+7
         SZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767958139; x=1768562939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZzXTN5GPRXX9JktaEoAXzWi3s9VynOdluwYCuvOxVM0=;
        b=oDd6Kz0HknCFUonN7scMjZIs99cid0paHlL/OXBvwoIErBK6mtgZKaJZ6zhvAJC2AH
         bqceTJ6M1BoYr5e8OwphnLHE9WvDW4B+P7cb7+J+Cjt38r1RUSRU855TL+zvneY5VroQ
         oNOebA4SVytb2xIQokjvXc6wY0u6lxeaUUao0dcOjUhX/9Uy+jANVCfDQdSP0VfKDtKM
         WxkzNg6tZJH9oZT3Hinp8fkLL/ycoH9D/XuP1+/tyL/YOwx1Fv61g8+D/W46jXRIw3WJ
         sdPVmn1fpAPnMzRAGQ+9TBiE8Rrs13IJbQfZ6u6mKzfm9dE8ODdtaGSWQMLGvVRjZkvN
         dM6A==
X-Forwarded-Encrypted: i=1; AJvYcCUT+0WjE6jCSQnR1n3lurp1046mUEEevja/JtW+z3KFeqlsswSqooD3sys79oj6ML4U68iRhW0ydA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsZj+O/xqOEY/INsEXMvhERxDzzZaNZTmJQxdBPbQvwwJqYBxb
	l0h2r6KalFty7/YLGichbCp5ew72sKmnAbtNFb1HIAaKCQm62HwAPD/D
X-Gm-Gg: AY/fxX4zh8BdIW4apzKwv0QzToyyZAoJ9Xv3xYEiFFQ9N/PyEVhbfomGSwq+A0WjKBV
	uPsm8DiRDOKn6+Xl7ePAMkKYd8HN7tRwZxRCAhOD8hRAEwPuPAS6NzDkSARsKN5n6K8fTyyWHMb
	U7MiipH5NDrKho6LmFZWup/bi2g+u8LYCplcrgWsMPr4qWUz+ETWxYwWb9NIi98Ooc7SwC6CPHy
	P66SKnI9kL+3oxuCWzIdKJoCjHdq6Npxd+MEW7QazUJd88DHu1OmLVmEkUeWx7s7fB1G/4um5g1
	e2vF6EoPYxDkYntB0n0SGHDykCtfgTePtHFN+nc35KhJCF4gUXWWcxe8i0NfF7wOM0GCoO9+0Az
	0I9bTnoXTDuwFggUn4J6C9YWIRG+IIR795FZyuIQxqKGGoOkQTVsMbppKA63s7IOzbJhBU488/w
	au4PyIRYPBiimfmKcenvJaIHgFO9DSyODuHAz6iB8y0fYCeHY+gYHkkqEv3plGW8HN/ta5kA==
X-Google-Smtp-Source: AGHT+IEyei4058HWVz7j1Ties6/iGQL4tmWJgfcaL9xqAMs5HpVk0uNC+wFxI/pUEYC0UA3VPD2wSA==
X-Received: by 2002:a05:600c:55c6:b0:477:75b4:d2d1 with SMTP id 5b1f17b1804b1-47d7f627ca1mr114093315e9.15.1767958139299;
        Fri, 09 Jan 2026 03:28:59 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:69b5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8636c610sm60056985e9.0.2026.01.09.03.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:28:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Tim Hostetler <thostet@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	John Fraker <jfraker@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Yue Haibing <yuehaibing@huawei.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	dtatulea@nvidia.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v8 2/9] net: reduce indent of struct netdev_queue_mgmt_ops members
Date: Fri,  9 Jan 2026 11:28:41 +0000
Message-ID: <f6e893b6b745873757331bddf25dd0a978adb5e2.1767819709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767819709.git.asml.silence@gmail.com>
References: <cover.1767819709.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Trivial change, reduce the indent. I think the original is copied
from real NDOs. It's unnecessarily deep, makes passing struct args
problematic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index cd00e0406cf4..541e7d9853b1 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -135,20 +135,20 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * be called for an interface which is open.
  */
 struct netdev_queue_mgmt_ops {
-	size_t			ndo_queue_mem_size;
-	int			(*ndo_queue_mem_alloc)(struct net_device *dev,
-						       void *per_queue_mem,
-						       int idx);
-	void			(*ndo_queue_mem_free)(struct net_device *dev,
-						      void *per_queue_mem);
-	int			(*ndo_queue_start)(struct net_device *dev,
-						   void *per_queue_mem,
-						   int idx);
-	int			(*ndo_queue_stop)(struct net_device *dev,
-						  void *per_queue_mem,
-						  int idx);
-	struct device *		(*ndo_queue_get_dma_dev)(struct net_device *dev,
-							 int idx);
+	size_t	ndo_queue_mem_size;
+	int	(*ndo_queue_mem_alloc)(struct net_device *dev,
+				       void *per_queue_mem,
+				       int idx);
+	void	(*ndo_queue_mem_free)(struct net_device *dev,
+				      void *per_queue_mem);
+	int	(*ndo_queue_start)(struct net_device *dev,
+				   void *per_queue_mem,
+				   int idx);
+	int	(*ndo_queue_stop)(struct net_device *dev,
+				  void *per_queue_mem,
+				  int idx);
+	struct device *	(*ndo_queue_get_dma_dev)(struct net_device *dev,
+						 int idx);
 };
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, int idx);
-- 
2.52.0


