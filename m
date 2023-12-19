Return-Path: <io-uring+bounces-308-lists+io-uring=lfdr.de@vger.kernel.org>
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D6C8191F4
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:04 +0100 (CET)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E3FE1F25356
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:04 +0000 (UTC)
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36C03C495;
	Tue, 19 Dec 2023 21:04:17 +0000 (UTC)
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="hVQfTmM3"
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E9339FD3
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:14 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6d7f1109abcso1703383b3a.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:14 -0800 (PST)
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019853; x=1703624653; darn=vger.kernel.org;
        bh=wkWI+jBk9ibeTFLlqTLjoDgBCcMIsyS5O3uAoss9Ttk=;
        b=hVQfTmM3DGTVb0Jan2JmJg5ujHubg0EH2ANU5ALsN4ZlCGRUqKSThlyVoG3cXCt6gM
         o0zGDSXVWz0CBIfLNpyAJaXOn2ej86C7V//wnQQHmhD82gFLmqWy254/QTdHe+ElPkSN
         AwuLwc+0aZpnVJhuVBNt4gAuG7+PhhP5JCrCNmLHnWVRk8gCK5T5lKmqrjiaVE6nwpeX
         a2ciwGXVYSWJPGG4EOaHdoevMfdaZzERV/kd5ApQx0jIxn/8LFtVp3XhOXeS4lKH7mzr
         tGygr/wgMbAPN2w1MZp3L8HtK6DXwC/Krno/uzbTeakRFmIYfSFx3hNqu0ZpkVR719ET
         wl1Q==
        d=1e100.net; s=20230601; t=1703019853; x=1703624653;
        bh=wkWI+jBk9ibeTFLlqTLjoDgBCcMIsyS5O3uAoss9Ttk=;
        b=Jw/+l50i7fQpUO+xOditdd9/ZfXDHqG1U1yA3kx5zOdReQgLxQV9tP6g5xZBN+mRQw
         xtJXu/2YKKAi79hDRehHMl356kWkJ0lGjgnbmKIRZ6n+09Vq7R+Ay7jPKT5TjLphdgM/
         ZeQUrPXVLWztsvxNad3Bty0/To/lUD85Me89vdEWq0GRP9rEaPuSgO7Bxq97HurvAakI
         gkyUMl7Kx7prMrm9/IYXRVs8X+2gkBqpFp45evXZh/EPCzT9KAvgJ+0fVOroZbvg1PPj
         +kDnC6Y/bThHr+WLZm9yiDtsF/94+ea1f8Dt6z4xiHpOPWG/srri4h490Nozd0UShiD/
         V/+A==
X-Gm-Message-State: AOJu0YztKNr5bUtMSCsFXAafHLpBRNhpCWlDhk78r7SRVT17p5UJJR+R
	Vp8GEuEhuo1Ioy4OKRA1qrao65Z1JX8D1L3ZxmbDzQ==
X-Google-Smtp-Source: AGHT+IFkIV9kmjgRboZ06qcSOFb/5LLi9sCmzo0B4VxRAsTpi263CWRkMG9FMB5SxtZFYbwU0PQDWQ==
X-Received: by 2002:a17:902:d4c7:b0:1d0:910e:5039 with SMTP id o7-20020a170902d4c700b001d0910e5039mr10917744plg.77.1703019853402;
        Tue, 19 Dec 2023 13:04:13 -0800 (PST)
Received: from localhost (fwdproxy-prn-019.fbsv.net. [2a03:2880:ff:13::face:b00c])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b001bf044dc1a6sm21422316plc.39.2023.12.19.13.04.13
        Tue, 19 Dec 2023 13:04:13 -0800 (PST)
Subject: [RFC PATCH v3 09/20] netdev: add XDP_SETUP_ZC_RX command
Date: Tue, 19 Dec 2023 13:03:46 -0800
Message-Id: <20231219210357.4029713-10-dw@davidwei.uk>
From: David Wei <davidhwei@meta.com>
RFC ONLY, NOT FOR UPSTREAM
This will be replaced with a separate ndo callback or some other
mechanism in next patchset revisions.

This patch adds a new XDP_SETUP_ZC_RX command that will be used in a
later patch to enable or disable ZC RX for a specific RX queue.

We are open to suggestions on a better way of doing this. Google's TCP
devmem proposal sets up struct netdev_rx_queue which persists across
device reset, then expects userspace to use an out-of-band method (e.g.
ethtool) to reset the device, thus re-filling a hardware Rx queue.
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a4bdc35c7d6f..5b4df0b6a6c0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1097,6 +1097,7 @@ enum bpf_netdev_command {
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
 	XDP_SETUP_XSK_POOL,
+	XDP_SETUP_ZC_RX,
 };
 struct bpf_prog_offload_ops;
@@ -1135,6 +1136,11 @@ struct netdev_bpf {
 			struct xsk_buff_pool *pool;
 			u16 queue_id;
 		} xsk;
+		/* XDP_SETUP_ZC_RX */
+		struct {
+			struct io_zc_rx_ifq *ifq;
+			u16 queue_id;
+		} zc_rx;
 	};
 };