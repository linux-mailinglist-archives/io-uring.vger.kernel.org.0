Return-Path: <io-uring+bounces-7610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E089A96644
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 12:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F37B3AF576
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA6A1EE002;
	Tue, 22 Apr 2025 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTyOVtqa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160951D54C2;
	Tue, 22 Apr 2025 10:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745318781; cv=none; b=k3QpF9ieMkkwm7Snc6thdbt9SI4Tzng1GGY0m2apgmHbrClqPn2GETEVblULWRuDSPDEjb8RWwfhe0MNZ1670FX8+zjyFOUc/vWeDZk9dvhj+pGasT4Z/0+CSdwjdSEFqWqahy/z0jzpyHB83iDvpeNs+3ezA1+qNMAVBRv86yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745318781; c=relaxed/simple;
	bh=riTPMhcadxwpUbCakRdCNbb8gPBt4Dlh4hK5pGGVbgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYR78BtKHnnfHB48Zbq76jRUqlxNQSlhx+t1L+w59iHa5g7GMTyVKd0NjJW2x8na5ijr7ewsbDTactnexSR81PsV2wI1cFZWCWH5jyDgT/VImI03fMlLpJNFr856HuSzvLS2aTdL9IrE3rZuqEjD6FGzm4y2DLTr9LPh5pVh3dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTyOVtqa; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-30828fc17adso4275943a91.1;
        Tue, 22 Apr 2025 03:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745318779; x=1745923579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xly8X1cEz+i+9kvxZBf7zmULO0Y4b0BskUgodyS4Lpc=;
        b=JTyOVtqaE4z/i0e8L3qwNGMpGGtvaWiGzeSNohlAh1ipWXtGCTW7lavjicmOZfbQ7m
         FHbJF2RgikYLtdu81ASES35P6T9OiURfJM+N49G7D9Oav6SzniIWSe6utpV3FqWYQbic
         /FVPSpyqq7u8UHXtsljSGNoIOu/YbPBG2RLGM+g7x6tXxpC03oCERF7rC9VtKCYRP53Y
         D6Yo/A1p65AeO4DeIqmzNhzlnzUYK0qo6lYtfa6k33LQHONhs9pdLGw6+1P4C41Ito5q
         837y+MR8UPb7CZP9KB7dLgtzhgZnkGujvaw1341dEVtNwhsMPYSBCLH2qh6doR3Wn8lc
         6TEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745318779; x=1745923579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xly8X1cEz+i+9kvxZBf7zmULO0Y4b0BskUgodyS4Lpc=;
        b=qCq+9Ha5bkEuCVrzXabBlA0KfhwKYJPvLIjxQ4vY/fS4xv6eQq8C42zPp+vjztH0Fj
         kyHzHAjVM0lNB8ZlRes+6U/gQziov1eIoYrNWLaR4d+urLK4lUBjqs76b/OP8pVH5APy
         FejFNZ37rtuSb85fF4oKYerX8MmkIzTgnYvaPHPyWPzoZ+EB0WJsWgGtSwQ3RpTTKyW9
         T6z0Sk12LDSOQjgNvlGNPAdLfTvbuGVeeDNRGpNXb64/Aigv6RQ7HLwHY2bmyA2hbYQC
         2qoh/rPdDFkKSKmFgB35eBe0yNMp7zhhwQjvo14cKOcMotewxcTKbT6FPy2ddXdb8B6f
         O1+A==
X-Forwarded-Encrypted: i=1; AJvYcCUSbiS70UQ03zz4UJIU7RzSmEF7TDcVA6WtUwW6cY4l0fjTesVp7CiaQsaTRKT79NWS0JD18DfaAQ==@vger.kernel.org, AJvYcCUg2is03shZ+0Rzc0UghJnREES5fvwndPlWDbZPSfxuWySsNldhI9KX0oPyiRWs+px5rHT4hU+nupnTXe1NQQ==@vger.kernel.org, AJvYcCWM7ql8N++B7M1/PUo2y6I7OxC5yIUDdobJ7rP0pZ6x9gM66d0IBWW+fN8oGhKaG7bO61l6pIAtVnloars8@vger.kernel.org
X-Gm-Message-State: AOJu0YxhF4OplSzbhLLR/93VR5MTo5RF93cier8pJniTJ2hFZj2nADft
	QE47Fc6wuPuGAVP/i/SvnVrTnVK/elj6XmcSBbei0jj9RfUCM6M8PaDo1tjy1NVmLQ==
X-Gm-Gg: ASbGncu3LTpu9H/xm8Z2/ur6BE5Dk9PQ4cdnJiFO81aaAxIkVCKrix85FXA/ADvWC8K
	bqWhuntshhsLGSMoiyMcZBPK805zGMqkMRmIHOFWzXfdwJW4UQTZoDOh4rrRXtie+e7xnZO7fsI
	L5hAWD2i1vgdgddgDV2ni93ejM4Zpt4dPjTnAkt19OkcrkXGqdiYNKJ6OBPc4DGnf7ct7W+9o0j
	zPd0erc0VFXUcIsjEo0z7ZeDLv6Cwa8udl4jq9q5Lc1MihPfm9R4CReNziExQWu3b5fcXjflPki
	ZLXg+yxjEJI7R+ZlVUOHDfPXuw/LZJw/1T16QsiWIcDLgEtUuVVejnu63+w9Nu43GeBI2bS0hIZ
	8U6WGo6u/QQYzk+UsnGtJKaH2Qa8ZDC9tgR6+a6hBwpZQVuwkdla9dzFW1Jd2FwaXLXrMuc4Rbs
	aUF+lz
X-Google-Smtp-Source: AGHT+IEvi8cHEqKxCFXREp4zm5+5YB1OUJt9x/7QpkeaDQmDO+nzdR3N8oeB3QOX75NaFlZSTp6kLw==
X-Received: by 2002:a17:90b:5646:b0:2ee:f80c:6889 with SMTP id 98e67ed59e1d1-3087bcc8a9dmr24601641a91.33.1745318779308;
        Tue, 22 Apr 2025 03:46:19 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3087e05e90bsm8276853a91.45.2025.04.22.03.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 03:46:18 -0700 (PDT)
From: Zhiwei Jiang <qq282012236@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	peterx@redhat.com,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Zhiwei Jiang <qq282012236@gmail.com>
Subject: [PATCH 2/2] userfaultfd: Set the corresponding flag in IOU worker context
Date: Tue, 22 Apr 2025 10:45:45 +0000
Message-Id: <20250422104545.1199433-3-qq282012236@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250422104545.1199433-1-qq282012236@gmail.com>
References: <20250422104545.1199433-1-qq282012236@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set this to avoid premature return from schedule in IOU worker threads,
ensuring it sleeps and waits to be woken up as in normal cases.

Signed-off-by: Zhiwei Jiang <qq282012236@gmail.com>
---
 fs/userfaultfd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index d80f94346199..74bead069e85 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -32,6 +32,7 @@
 #include <linux/swapops.h>
 #include <linux/miscdevice.h>
 #include <linux/uio.h>
+#include "../io_uring/io-wq.h"
 
 static int sysctl_unprivileged_userfaultfd __read_mostly;
 
@@ -369,7 +370,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool must_wait;
 	unsigned int blocking_state;
+	struct io_worker *worker = current->worker_private;
 
+	if (worker)
+		set_userfault_flag_for_ioworker(worker);
 	/*
 	 * We don't do userfault handling for the final child pid update
 	 * and when coredumping (faults triggered by get_dump_page()).
@@ -506,6 +510,9 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	__set_current_state(TASK_RUNNING);
 
+	if (worker)
+		clear_userfault_flag_for_ioworker(worker);
+
 	/*
 	 * Here we race with the list_del; list_add in
 	 * userfaultfd_ctx_read(), however because we don't ever run
-- 
2.34.1


