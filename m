Return-Path: <io-uring+bounces-11738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F676D26325
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AF18930328EB
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D543C0098;
	Thu, 15 Jan 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xao7+sAw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46D3BFE58
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497154; cv=none; b=ri0BMVTVWvDQGw+Muqyw1zP0yLeKu2cV5Od0wKlQ9rghf8oACwIpAEfY92FNmOkI/FuWCu/TQtXo5PaWqrQAyO6biWtBaKcdxTjO/S4GAAEX7wZ/BJI9i3wJoAtd0MIudNO/QnVl6eT/8imMTo/UqMcgp+0802s0UYKYhJ+r9NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497154; c=relaxed/simple;
	bh=325kOFYzw2k+cqXSD1yZvsNV8lGCDE0J53Wnm9an4I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JulAEUIXtt8WamTH74TMX66v42Q63C98TSc021m3m3Og0DaqqEfZFF0Y3SWUuIdzval1A5uMBqT4b2R/mib3LFwuzj3oXrfN0pbQosWzOkxWQZWTXQco/hhMi8spKJIJC2f6aiRTaKr/vZQ4wWRyccDI1W1Dqt4fMhvdcFNH7SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xao7+sAw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so9947315e9.1
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497150; x=1769101950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXcPbLudM1kUjP1WbAI7w2pUnWk49Wcruu//10Qhzw8=;
        b=Xao7+sAwCNlK123K/6mrDq2XlN4KGPM7mVkycv5Jq4qDr7BNDFDX7/uRjuCIfc5Dz2
         4jsyBfWUBbNKzGGBDRBajJwlIV1lUaFXcwscIlSjKunmwFBagu/syf0nUE+81/KUV8LX
         vKMqZawEaVBiHmD2fgxFkStAtDmtVJZWdsRqNAcWvKZiV6qkYxTM//x3fXsCf41g1QFE
         8F79SAImqdiS/MLfQST+sluDFE2qRu6e7kOKCa5TAdvfM1bnJybXrknVAolm2s/8/Qtg
         YQGWZ1DCy2dnT2ckeRqxdMi86Sv00vWVsaZEBNLX5R2VKyh8CGIXiyTlG8tietWOEiUv
         H4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497150; x=1769101950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jXcPbLudM1kUjP1WbAI7w2pUnWk49Wcruu//10Qhzw8=;
        b=X/omHzegqFthfhVn/ze6KmgV0SPdzCKISDb8Bofg6t7w6z9cr/1rtw1jM8IzGLzhyW
         31DyZagVLv388E/Hk9vWcF577hDMtFqgfFL7suroWxN9obWzEESa7FUUpRJfQEOzHg/A
         58CTRbiPvxfacG0ZBiCSUQa1t69D/5p3PQ9H4XtPp1uecNqF4TZK3IwnKexUgon8xIHk
         4Ckqlx5uVrvP/TYI8KtsGQW/IO4vQ92/eWsSwrsW8q+teYcgBsvd9dhO+fs7veMZTWSe
         JOVnPEyR2qFFrwPvSJ4IT1ms8i1pnPK7gvpZQ8bu4KyBLuPBGMJryRkjn15zxlEVCoWf
         4yog==
X-Forwarded-Encrypted: i=1; AJvYcCWEU83mrxDdj402kX6VpxnQN092IkiQ7cIwdOxGydA8Jt2JKCg/zb1mpQQXyijcdmba33Sel863Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0b6Js6DuYSnHDVA6mEdYiWxCo7c7qcNcQqlHxrs6CFdUaPlwc
	yggyaEgRLtf5PQXrrEjIEGJY/ABO6kcvRaSfEOU9PSZRshnso8OCG+p7
X-Gm-Gg: AY/fxX6KDj8yZxS7NrIgTnh7DgxxtPBPkTMQPrDF/bsZ+nCm93cxA/XMISft4rdVR35
	TdgZKxBTFox065V2Uj45WpzWH01162L68572gLwfWPA4Wee+85FgcCiUzN7F+Cp2BJY1/B0SALa
	mJs3b5r+QiE7S25k3O39D4rmAR0PT+iL7Q/Och8HlPwtK+uBu2HbfWGdATh200ADQige10hgiQY
	a5fYoxgUoqscOP0HkxMIvltOPlmm3kLqcwZUjgoOfd8xuAFbV16B6FdrM53TybHnmdxILy5yfSX
	QGUZeSh8g3uzAKrH4kCBlXiEoxi7tKKO5dOyj8EL/akceBrM1jnqmz+BAu9DsBZp6CP9rZbIdqa
	Qw6GYEYbYFevlQnNUE+ISqSrk2+EEkL+1nOlQQrHvgAhvNqOVk6sLFmMyKxnsxwlkFxqVqDg9Hn
	zGbht7B3/kcXS0mfBLC6YOIvBWLa5BfRMWFXA+0BfzZwW7VMfaaNvxZ+6OUqh4uoTI94TifxlMX
	i/5F6R+oaqnV3n04g==
X-Received: by 2002:a05:600c:4586:b0:477:9ce2:a0d8 with SMTP id 5b1f17b1804b1-4801e29edc9mr7306735e9.0.1768497149877;
        Thu, 15 Jan 2026 09:12:29 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm54741645e9.11.2026.01.15.09.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:12:27 -0800 (PST)
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
	kernel-team@meta.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v9 3/9] net: add bare bone queue configs
Date: Thu, 15 Jan 2026 17:11:56 +0000
Message-ID: <efcb9a4d32d3d9b924642c086b868bfbb9a07c13.1768493907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768493907.git.asml.silence@gmail.com>
References: <cover.1768493907.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need to pass extra parameters when allocating a queue for memory
providers. Define a new structure for queue configurations, and pass it
to qapi callbacks. It's empty for now, actual parameters will be added
in following patches.

Configurations should persist across resets, and for that they're
default-initialised on device registration and stored in struct
netdev_rx_queue. We also add a new qapi callback for defaulting a given
config. It must be implemented if a driver wants to use queue configs
and is optional otherwise.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |  8 ++++++--
 drivers/net/ethernet/google/gve/gve_main.c      |  9 ++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 10 ++++++----
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c    |  8 ++++++--
 drivers/net/netdevsim/netdev.c                  |  7 +++++--
 include/net/netdev_queues.h                     |  9 +++++++++
 include/net/netdev_rx_queue.h                   |  2 ++
 net/core/dev.c                                  | 17 +++++++++++++++++
 net/core/netdev_rx_queue.c                      | 12 +++++++++---
 9 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8419d1eb4035..a0abe991f79a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15911,7 +15911,9 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
 	.get_base_stats		= bnxt_get_base_stats,
 };
 
-static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
+static int bnxt_queue_mem_alloc(struct net_device *dev,
+				struct netdev_queue_config *qcfg,
+				void *qmem, int idx)
 {
 	struct bnxt_rx_ring_info *rxr, *clone;
 	struct bnxt *bp = netdev_priv(dev);
@@ -16077,7 +16079,9 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	dst->rx_agg_bmap = src->rx_agg_bmap;
 }
 
-static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
+static int bnxt_queue_start(struct net_device *dev,
+			    struct netdev_queue_config *qcfg,
+			    void *qmem, int idx)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_rx_ring_info *rxr, *clone;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 7eb64e1e4d85..c42640da15a5 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2616,8 +2616,9 @@ static void gve_rx_queue_mem_free(struct net_device *dev, void *per_q_mem)
 		gve_rx_free_ring_dqo(priv, gve_per_q_mem, &cfg);
 }
 
-static int gve_rx_queue_mem_alloc(struct net_device *dev, void *per_q_mem,
-				  int idx)
+static int gve_rx_queue_mem_alloc(struct net_device *dev,
+				  struct netdev_queue_config *qcfg,
+				  void *per_q_mem, int idx)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	struct gve_rx_alloc_rings_cfg cfg = {0};
@@ -2638,7 +2639,9 @@ static int gve_rx_queue_mem_alloc(struct net_device *dev, void *per_q_mem,
 	return err;
 }
 
-static int gve_rx_queue_start(struct net_device *dev, void *per_q_mem, int idx)
+static int gve_rx_queue_start(struct net_device *dev,
+			      struct netdev_queue_config *qcfg,
+			      void *per_q_mem, int idx)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	struct gve_rx_ring *gve_per_q_mem;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 07fc4d2c8fad..0e2132b58257 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5596,8 +5596,9 @@ struct mlx5_qmgmt_data {
 	struct mlx5e_channel_param cparam;
 };
 
-static int mlx5e_queue_mem_alloc(struct net_device *dev, void *newq,
-				 int queue_index)
+static int mlx5e_queue_mem_alloc(struct net_device *dev,
+				 struct netdev_queue_config *qcfg,
+				 void *newq, int queue_index)
 {
 	struct mlx5_qmgmt_data *new = (struct mlx5_qmgmt_data *)newq;
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -5658,8 +5659,9 @@ static int mlx5e_queue_stop(struct net_device *dev, void *oldq, int queue_index)
 	return 0;
 }
 
-static int mlx5e_queue_start(struct net_device *dev, void *newq,
-			     int queue_index)
+static int mlx5e_queue_start(struct net_device *dev,
+			     struct netdev_queue_config *qcfg,
+			     void *newq, int queue_index)
 {
 	struct mlx5_qmgmt_data *new = (struct mlx5_qmgmt_data *)newq;
 	struct mlx5e_priv *priv = netdev_priv(dev);
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 13d508ce637f..e36ed25462b4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -2809,7 +2809,9 @@ void fbnic_napi_depletion_check(struct net_device *netdev)
 	fbnic_wrfl(fbd);
 }
 
-static int fbnic_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
+static int fbnic_queue_mem_alloc(struct net_device *dev,
+				 struct netdev_queue_config *qcfg,
+				 void *qmem, int idx)
 {
 	struct fbnic_net *fbn = netdev_priv(dev);
 	const struct fbnic_q_triad *real;
@@ -2861,7 +2863,9 @@ static void __fbnic_nv_restart(struct fbnic_net *fbn,
 		netif_wake_subqueue(fbn->netdev, nv->qt[i].sub0.q_idx);
 }
 
-static int fbnic_queue_start(struct net_device *dev, void *qmem, int idx)
+static int fbnic_queue_start(struct net_device *dev,
+			     struct netdev_queue_config *qcfg,
+			     void *qmem, int idx)
 {
 	struct fbnic_net *fbn = netdev_priv(dev);
 	struct fbnic_napi_vector *nv;
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 6927c1962277..6285fbefe38a 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -758,7 +758,9 @@ struct nsim_queue_mem {
 };
 
 static int
-nsim_queue_mem_alloc(struct net_device *dev, void *per_queue_mem, int idx)
+nsim_queue_mem_alloc(struct net_device *dev,
+		     struct netdev_queue_config *qcfg,
+		     void *per_queue_mem, int idx)
 {
 	struct nsim_queue_mem *qmem = per_queue_mem;
 	struct netdevsim *ns = netdev_priv(dev);
@@ -807,7 +809,8 @@ static void nsim_queue_mem_free(struct net_device *dev, void *per_queue_mem)
 }
 
 static int
-nsim_queue_start(struct net_device *dev, void *per_queue_mem, int idx)
+nsim_queue_start(struct net_device *dev, struct netdev_queue_config *qcfg,
+		 void *per_queue_mem, int idx)
 {
 	struct nsim_queue_mem *qmem = per_queue_mem;
 	struct netdevsim *ns = netdev_priv(dev);
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 541e7d9853b1..f6f1f71a24e1 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -14,6 +14,9 @@ struct netdev_config {
 	u8	hds_config;
 };
 
+struct netdev_queue_config {
+};
+
 /* See the netdev.yaml spec for definition of each statistic */
 struct netdev_queue_stats_rx {
 	u64 bytes;
@@ -130,6 +133,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * @ndo_queue_get_dma_dev: Get dma device for zero-copy operations to be used
  *			   for this queue. Return NULL on error.
  *
+ * @ndo_default_qcfg:	Populate queue config struct with defaults. Optional.
+ *
  * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
  * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
  * be called for an interface which is open.
@@ -137,16 +142,20 @@ void netdev_stat_queue_sum(struct net_device *netdev,
 struct netdev_queue_mgmt_ops {
 	size_t	ndo_queue_mem_size;
 	int	(*ndo_queue_mem_alloc)(struct net_device *dev,
+				       struct netdev_queue_config *qcfg,
 				       void *per_queue_mem,
 				       int idx);
 	void	(*ndo_queue_mem_free)(struct net_device *dev,
 				      void *per_queue_mem);
 	int	(*ndo_queue_start)(struct net_device *dev,
+				   struct netdev_queue_config *qcfg,
 				   void *per_queue_mem,
 				   int idx);
 	int	(*ndo_queue_stop)(struct net_device *dev,
 				  void *per_queue_mem,
 				  int idx);
+	void	(*ndo_default_qcfg)(struct net_device *dev,
+				    struct netdev_queue_config *qcfg);
 	struct device *	(*ndo_queue_get_dma_dev)(struct net_device *dev,
 						 int idx);
 };
diff --git a/include/net/netdev_rx_queue.h b/include/net/netdev_rx_queue.h
index 8cdcd138b33f..cfa72c485387 100644
--- a/include/net/netdev_rx_queue.h
+++ b/include/net/netdev_rx_queue.h
@@ -7,6 +7,7 @@
 #include <linux/sysfs.h>
 #include <net/xdp.h>
 #include <net/page_pool/types.h>
+#include <net/netdev_queues.h>
 
 /* This structure contains an instance of an RX queue. */
 struct netdev_rx_queue {
@@ -27,6 +28,7 @@ struct netdev_rx_queue {
 	struct xsk_buff_pool            *pool;
 #endif
 	struct napi_struct		*napi;
+	struct netdev_queue_config	qcfg;
 	struct pp_memory_provider_params mp_params;
 } ____cacheline_aligned_in_smp;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 36dc5199037e..a1d394addaef 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11270,6 +11270,21 @@ static void netdev_free_phy_link_topology(struct net_device *dev)
 	}
 }
 
+static void init_rx_queue_cfgs(struct net_device *dev)
+{
+	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+	struct netdev_rx_queue *rxq;
+	int i;
+
+	if (!qops || !qops->ndo_default_qcfg)
+		return;
+
+	for (i = 0; i < dev->num_rx_queues; i++) {
+		rxq = __netif_get_rx_queue(dev, i);
+		qops->ndo_default_qcfg(dev, &rxq->qcfg);
+	}
+}
+
 /**
  * register_netdevice() - register a network device
  * @dev: device to register
@@ -11315,6 +11330,8 @@ int register_netdevice(struct net_device *dev)
 	if (!dev->name_node)
 		goto out;
 
+	init_rx_queue_cfgs(dev);
+
 	/* Init, if this function is available */
 	if (dev->netdev_ops->ndo_init) {
 		ret = dev->netdev_ops->ndo_init(dev);
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index a0083f176a9c..86d1c0a925e3 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -22,6 +22,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 {
 	struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, rxq_idx);
 	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+	struct netdev_queue_config qcfg;
 	void *new_mem, *old_mem;
 	int err;
 
@@ -31,6 +32,10 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 
 	netdev_assert_locked(dev);
 
+	memset(&qcfg, 0, sizeof(qcfg));
+	if (qops->ndo_default_qcfg)
+		qops->ndo_default_qcfg(dev, &qcfg);
+
 	new_mem = kvzalloc(qops->ndo_queue_mem_size, GFP_KERNEL);
 	if (!new_mem)
 		return -ENOMEM;
@@ -41,7 +46,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 		goto err_free_new_mem;
 	}
 
-	err = qops->ndo_queue_mem_alloc(dev, new_mem, rxq_idx);
+	err = qops->ndo_queue_mem_alloc(dev, &qcfg, new_mem, rxq_idx);
 	if (err)
 		goto err_free_old_mem;
 
@@ -54,7 +59,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 		if (err)
 			goto err_free_new_queue_mem;
 
-		err = qops->ndo_queue_start(dev, new_mem, rxq_idx);
+		err = qops->ndo_queue_start(dev, &qcfg, new_mem, rxq_idx);
 		if (err)
 			goto err_start_queue;
 	} else {
@@ -66,6 +71,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	kvfree(old_mem);
 	kvfree(new_mem);
 
+	rxq->qcfg = qcfg;
 	return 0;
 
 err_start_queue:
@@ -76,7 +82,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	 * WARN if we fail to recover the old rx queue, and at least free
 	 * old_mem so we don't also leak that.
 	 */
-	if (qops->ndo_queue_start(dev, old_mem, rxq_idx)) {
+	if (qops->ndo_queue_start(dev, &rxq->qcfg, old_mem, rxq_idx)) {
 		WARN(1,
 		     "Failed to restart old queue in error path. RX queue %d may be unhealthy.",
 		     rxq_idx);
-- 
2.52.0


