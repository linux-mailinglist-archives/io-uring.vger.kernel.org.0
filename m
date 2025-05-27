Return-Path: <io-uring+bounces-8117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DD9AC5200
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 17:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 425D0166ED8
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 15:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB6027990B;
	Tue, 27 May 2025 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngvLMpEV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D40253B4C
	for <io-uring@vger.kernel.org>; Tue, 27 May 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748359616; cv=none; b=iriqNV/gYR4IY/VXz1iyz5CbRRm1EKt83MZ5EazVJNYoaRfFmXFZcMPosfK+b1FuYOF/CGtwoN06KAxohQzfDGlAevmR5uhknPPq3NdacWkXz5tfsXvmFLgf93kdqw0x8V7Nk2349hseaPJqwVhCiMK+x9VwDJuYcRu/dwyWM4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748359616; c=relaxed/simple;
	bh=phMO+ISNVTOQMSs+cLJK9pcLHhaZ/dcH+8NUvbYyNVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ssp1p7L9dfRUNgagPv/99uIKdJp8Y9zm/vx0UqCJo6gGC3NqJpWSu6Zso43yqVEm+gFHPtLOE8wbUmGnQ5MvlmHcRN9JpQvrn7n0OyJSWk/EnDi0X4jV4YZrAuHGXG4D5QVbFEfDBwir3hB+sP8C6pLn+UEtB25Sm3DldBLlcw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngvLMpEV; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ad51ef2424bso709463966b.0
        for <io-uring@vger.kernel.org>; Tue, 27 May 2025 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748359613; x=1748964413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jzi6DEsqtvesWkQgW21rjp6w06wt727BDcWCBAVYIig=;
        b=ngvLMpEVTCEU8p30loqbzaWsuMOk5itkPO8y76AwDadsKPPE4R3zj0OuM3isu4kunk
         LUKOjGLFw1UDK3ckIC+D90zR69vQu/ee+lDxL42QBGLRA4Qf3xSVn/16AQSuwvOLfGOd
         tlH+CC/OTjVdLCpTZZ9B/MEdStdQoGCn1+8bRxzIgLfP7kTjdgSHadqqEie2pALtEGhT
         GesRMkFVtzdb2igTGNuekQldeZoXiQ0LfdPMxmhBWM8KbAknzC6zMX0h/vEe6ylGNATW
         QVEZkWzqGBVqwTCjoe+hGENs5FimI4BQiICRpr6oz7lyiBDvrH//Tirdt6QDXob/hLpA
         OSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748359613; x=1748964413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzi6DEsqtvesWkQgW21rjp6w06wt727BDcWCBAVYIig=;
        b=EDT8gqpn7kkfRKdku3RxunULCijnG0/vz3iy61NSO/cU+8vAcLekDGkKUFnQp3cMpd
         DILxvKEqLqmhSdEUMx19n5DmblhBGkggk/uximXVNz31/B6wBdBkJcs2HBIDTrq0EAS1
         utQRy84Qe+mqDeLOBXWiZTP7edvniwthxL9PtZY38OoVOrQvrtswQ4blAnrDSUVyKo1s
         JzDXthB6ij7ee3DlQzmlqxywjNpgFE/IbLxUm+O/4IebzVq4UkDXZVDv0VMErVZeJsSg
         OWFcydIl027SBj3wlwcG3iXQv3NU3NuRAGm3HCc1Hh5CJTx4BWvmpG3e/QYWBCeD1TOw
         wwZg==
X-Gm-Message-State: AOJu0YyYv4wvgtEPJ1scT4hqHix1LfoTSxXp0saO3+sCH4+8vBcwYOs7
	NklJWUlv1fLcQ1PysCHt3jjUcAXlo1Cd1If+ePVKJRDwDg+AJ65rxRESDpaSgw==
X-Gm-Gg: ASbGncunDDk5zmIQnfFMpnzBJdltWhM7tOYkdBKZQqHWfI6zehLQmGvK1ZfguU6/aEz
	Jzh105Lorr9uUw0EA1XT6ED8z9g+kXTe+gDBloTxChdFvmASwo3Ura5sLha+G8UKN7XxEv6EM1F
	3l/uXoMdh4atcrOv6btDbOHAacDBHm1LKkMx0Z7Hr9MB1I62IoEdyEHV1hMzJbFcSsa5dD22auh
	a0oys10TcvDHvjL3k7mWvFnHx4T5ApcnEI1tSv7Jw4utrG2I6AI8ChHerBOuHo+GYNPRQJLqcJr
	A5gXBtYi5czglUxgNY5KPRTyP+bJCuJxweDil5b0oKYhgg==
X-Google-Smtp-Source: AGHT+IFZ96X1ZssRgdsKfFzYa3eeJ6HxzeDmGw4euj2uZECzyGrF3QmvedgE1lAu0OPdag70jsoI/w==
X-Received: by 2002:a17:906:c4d1:b0:ad8:8529:4f9b with SMTP id a640c23a62f3a-ad885295575mr358266566b.38.1748359612906;
        Tue, 27 May 2025 08:26:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3f0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad88d055614sm132462966b.29.2025.05.27.08.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 08:26:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/zcrx: init id for xa_find
Date: Tue, 27 May 2025 16:27:57 +0100
Message-ID: <faea44ef63131e6968f635e1b6b7ca6056f1f533.1748359655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xa_find() interprets id as the lower bound and thus expects it initialised.

Reported-by: syzbot+c3ff04150c30d3df0f57@syzkaller.appspotmail.com
Fixes: 76f1cc98b23ce ("io_uring/zcrx: add support for multiple ifqs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9a568d049204..0c5b7d8f8d67 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -630,12 +630,13 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
-	unsigned long id;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
 	while (1) {
 		scoped_guard(mutex, &ctx->mmap_lock) {
+			unsigned long id = 0;
+
 			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
 			if (ifq)
 				xa_erase(&ctx->zcrx_ctxs, id);
-- 
2.49.0


