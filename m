Return-Path: <io-uring+bounces-1690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DECF18B7BFC
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 17:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF2E7B20F76
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 15:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1A9171E71;
	Tue, 30 Apr 2024 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eF3Vw8YO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07070128375
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491742; cv=none; b=Sr5+bV3tPX4ywRGGghf/sPjKz7VXKVZlJZNHm8Ez6zYTWMrZc5jqXEt7a8hTemaozZE+HOrJtaMKN8kLsNU2ykvKsyGGlE5SVRQaoz6U3Agv+IAmSeeF+JZB7GsrMeIbdgr1ppL1lvnJtHOH0S74GvdE6qln+HnobadIwTzLTrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491742; c=relaxed/simple;
	bh=Quc7OtgU4GyMnaFQWM7sDb2+MafOLDFtyU49qyEHUKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z+/DRrLh1Rs1Fu+3HRJO8M9G6lhS80ifPmnqPpbGDf2edlNNRrai8+waS8PmMtlO/5GEY5XrmarORZgd7vDlsYxFxDYFKaJn80co6SFK4SrzoJSZpeN1u2ehl4rnhlNjcPTpVepmdIcadurUDnnlnJu4Oc6NabwQA+q2zAru4rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eF3Vw8YO; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a5200afe39eso656353066b.1
        for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 08:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714491738; x=1715096538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vOAErpJjDPvjdo3GZMTGF4Dx86VhYa8r8qqkqDSr9Ig=;
        b=eF3Vw8YO7c2ApVbUpmvU0Pbqbs8g81IgtV0v/QYt0B1iw2EW6k71QNylt8M4N605Ln
         Akr0W0gHTf9yPrKs+ILAI/ZMfSoDuaiyCeRBWxSZP7e0cJ16STEnvn4advTmOPnigt8M
         DMNCnKeOfVmmHMIJ5s1wmks4z3hIQOhl0Z30fJ9fri60R5im+Qk5EVJbMF/DwiYfGNVg
         pAmPsgHyIw7i7vlu7myCf1AA6GltNCR8mfhH/SarweNo26pQpAUWdpiEoh4k70CAIpKN
         26GE23c4xFKQuuA1G1RzM2czVSKvZXDJuaUZp803RBckMWBphVXBd+HcrEmKw1O8csdM
         WGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714491738; x=1715096538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vOAErpJjDPvjdo3GZMTGF4Dx86VhYa8r8qqkqDSr9Ig=;
        b=hZZS7EtOa6GtcBECor2npwzvSiaBkNALlNYkgOzLwhmCOuInEiJsoOkIaOnuSxsLZS
         n1gyjo7CTKjTIJg7KfGzLFyr+LqKbfjzeg8VFA5qMgmunq5dv7/TSia3fnoHxqT1q9rZ
         6tqncKXiL/wKXZT36zKQvnmPplZ2h37xY1C/ACL6AlgDiTHDeivUEIYRo1jjfZ7hDXQi
         LhN2vS+/T7SSYmAs8U1/9Fduv4QBdI6I3ARpaOTI0Kg8XGZNBvbTurOBw5rhH5PePqxA
         K2Bft71OZ00g2/TwIAWEU1FpQSPHCKBluXiqtvGjtPJjlg0Rzxj92kpqm7cwV1QURKaC
         Adfw==
X-Gm-Message-State: AOJu0YwixE0HdtlfSBVQlRm1L6dgxRQ2WDuDr/Lm9vf6b/1PGfuSYnai
	Eyt5+GZZuquuIAf7+rMgxCxowUZaLRGaeb+AG27edolc7zzYi95gv6Z2eLll
X-Google-Smtp-Source: AGHT+IHMkowFB8v+dUERi7c8cGPG5wRcUe5sJkglivxyOZXUUolFcBJzTitKUqL3qsxgOD8OjOprxw==
X-Received: by 2002:a17:906:194d:b0:a52:4246:92fe with SMTP id b13-20020a170906194d00b00a52424692femr71409eje.48.1714491737531;
        Tue, 30 Apr 2024 08:42:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090653c800b00a51a259fa60sm15201465ejo.118.2024.04.30.08.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 08:42:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/2] LAZY_WAKE misuse fixes
Date: Tue, 30 Apr 2024 16:42:29 +0100
Message-ID: <cover.1714488419.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAZY_WAKE can't be used with requests for which users expect >1 CQE,
otherwise wait(nr=2) may get stuck waiting for a tw that will never
arrive. Fix up invalid use of LAZY_WAKE with sendzc.

Pavel Begunkov (2):
  io_uring/net: fix sendzc lazy wake polling
  io_uring/notif: disable LAZY_WAKE for linked notifs

 io_uring/net.c   | 1 +
 io_uring/notif.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.44.0


