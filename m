Return-Path: <io-uring+bounces-502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5F884208B
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 11:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA20288858
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 10:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C5966B54;
	Tue, 30 Jan 2024 10:03:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85F60BBB;
	Tue, 30 Jan 2024 10:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706608984; cv=none; b=Lz+t/vwqCJvD+Su3Jo32MjKDsC5FphQ0mcSM9hOjP+k6GPytIYe8OhxFiF3GHhrCabhGQJSwPiwbWEjRfbWl1u01iEaVSjMVMSIuEyfWvbDkOyftSkpJc302MHl9HNStEGdoh87npda829DzHZsi5LC6WJ8hR9bcbKzv1kNGFkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706608984; c=relaxed/simple;
	bh=chGWEln/xl2IgQzp0pg8bGFsb7zFOeDgHEalUKmpMWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eXkhhrDnCFGaTPPBGqWpQrCOZJRD3S8zeyPlWqQ1Zzfwt1FKMgrKqRsd5gcg3e+A6DFdA92WZ0Uv8hteleMBxBv4kTFzoPXcYRWB86Ssdrk7TQvbueeOyFc/hZZwX1llHOUDHcp7V5Vbv/x29IJ7VTvNhVaG9dSUGwSnGpjT+/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ece618e1cf814360862a7ff9215f02dc-20240130
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:aae264a8-4af7-494a-b93d-e5201429f6f8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.35,REQID:aae264a8-4af7-494a-b93d-e5201429f6f8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:8777ea7f-4f93-4875-95e7-8c66ea833d57,B
	ulkID:240130180251FTY18M0A,BulkQuantity:0,Recheck:0,SF:66|38|24|17|19|44|1
	02,TC:nil,Content:0,EDM:-3,IP:-2,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,
	TF_CID_SPAM_FSI
X-UUID: ece618e1cf814360862a7ff9215f02dc-20240130
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1033402814; Tue, 30 Jan 2024 18:02:50 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 06041E000EB9;
	Tue, 30 Jan 2024 18:02:50 +0800 (CST)
X-ns-mid: postfix-65B8C949-7875361294
Received: from kernel.. (unknown [172.20.15.213])
	by mail.kylinos.cn (NSMail) with ESMTPA id 79CF4E000EB9;
	Tue, 30 Jan 2024 18:02:49 +0800 (CST)
From: Kunwu Chan <chentao@kylinos.cn>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] io_uring: Simplify the allocation of slab caches
Date: Tue, 30 Jan 2024 18:02:47 +0800
Message-Id: <20240130100247.81460-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

commit 0a31bd5f2bbb ("KMEM_CACHE(): simplify slab cache creation")
introduces a new macro.
Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..9a810b1169f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4175,9 +4175,8 @@ static int __init io_uring_init(void)
 				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
 				offsetof(struct io_kiocb, cmd.data),
 				sizeof_field(struct io_kiocb, cmd.data), NULL);
-	io_buf_cachep =3D kmem_cache_create("io_buffer", sizeof(struct io_buffe=
r), 0,
-					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT,
-					  NULL);
+	io_buf_cachep =3D KMEM_CACHE(io_buffer,
+					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
=20
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
--=20
2.39.2


