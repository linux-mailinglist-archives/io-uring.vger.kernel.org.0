Return-Path: <io-uring+bounces-7630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3653FA972C8
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744113AEFEA
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E702529346F;
	Tue, 22 Apr 2025 16:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGc7O/S2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B90914BFA2;
	Tue, 22 Apr 2025 16:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745339383; cv=none; b=FxOb2XK+ASt2gYQP4SaqOlILxyCiY1a5bYO/jGPGdmpxXEdALMmxsEgynpnwTInDAFqFaY06bZMSHselzhmQgWQw0k9/jDMdcQXMEvE3JtQr8O0nQzZK88oJu4arC5eLrzUT2JaoPSR5JwWNqcF8id2H8OEXNv63oPSeufzHSK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745339383; c=relaxed/simple;
	bh=ddCiYB7gNQK8k+99evwMXCTTghD704AYlq43WJ6LR38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uy5skDOes89gYoyT+vTzU5U6HwBHj+i4ZRdC2++4IlZyWlejYexGYTZjhIvUAoOvrO+Q9VoazaFjIgm97dbpYgeKrpQiTfc6rCP7i4sOJ7LdqLYN68T6YcOXggF2FnRIri/7pgkcndTJxR9DsFlymW6uOeBjnSIJm9sW+UkDTRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGc7O/S2; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224171d6826so76205905ad.3;
        Tue, 22 Apr 2025 09:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745339382; x=1745944182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fclcTeuF/G5gshbnsn1Bq04Z22JuyFFMaX5b6YaqYk=;
        b=ZGc7O/S2ONg75FMOPBiBWr7CitaDQwXVFm59a64CayRnKjiHYDVcI0spg/c2TZa9TR
         1ErhRHXkRHeOle5D4CGZt5VxR/o6RB9RL68A3NvsxjbhrAj2g+thJ+Jtp3a5GRYQRQQt
         wiFWZD6XOEWjDOdTuPxRrEW1DRviVRD0zoNTXNFNt144KM7AxBdv7og6GvcU6g1YunXl
         RHw+t8omVhUjOlWxZ/z254hPkTO61oihbL+xZt5WCAsZGfnLGcG+u7MLTkpGcFkLq+pQ
         W8vadyb2MU3PIJgEn/cHl9HZb+0/wKRN7S3I70o2Ch3cP9lPtkOUS5hhOzuWVeP28SBb
         XiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745339382; x=1745944182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fclcTeuF/G5gshbnsn1Bq04Z22JuyFFMaX5b6YaqYk=;
        b=IF5WSqvWXWn0UhupcV/cjioWc5oVbHoZ3p9U4zzBFXHcbfHhYiOzNC+AOmjtjRCNIE
         GZ3uzBbYUYiVoNr21Sw0oo4h/aO6upNa7n3LcweW6f7bM/VMoeESZ+hZLilmy+5N0rFN
         hCn+uqbJQZEBL6IOaJ8PkeRoiUAhMIRUNEOHf0lkAlZ0xCkT6csK0XPjTYTq0YBgRGrQ
         HBudSuGla5t2NXCe0ETU0p0god1FLrSzKUxT4LZWc7p3FVYoOQ21IILhuKcARj+O0XBZ
         R4l3nTVJMm+EtiZQUGt8z7x/4JrPUh6kqcxa64Pbnu+Y8sx+on6Ow4mZ7c3LK6j7ehSs
         RPew==
X-Forwarded-Encrypted: i=1; AJvYcCV3DsDNVvbrh8WSJnpbGIPz7CwpMmRzSkWlMCmgWzszQqm3JZtzPk029o3KGQ617mi1xc8YJWdRdqltMI6g@vger.kernel.org, AJvYcCVh1noE+seYqXRXg8doDvVZyHZzoFqQAe+xc/HEs6404cZYHlSbhyMrOXug+9sxxfMn0gA0jbM4KpkNXM2x3g==@vger.kernel.org, AJvYcCXX4j3DoXEwEg7LXyHQsdKvsWFgopfDlKEIOYifCgYFbkzxDYK7GVJFFSc7VNYKP3bP1/JlgYH/cQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd34vkBAWVUPEmXiyP4OMK952wFzBNpvg40GK4EnvG+3fnX19s
	r3hV5L5sPRk4P8I5QjR0I56qPGrblkRQPEluFeiuC69psaiiH0bN
X-Gm-Gg: ASbGncuuA9rLqGGdtrolpLaktyQSOG14ch2JfvjmcH/EgnmRiUVIrOVFezgS1I2ibM1
	skoYSN9u0zz0/B0RTalEKKlakMPrvtxB6be/tFNR2P0k8Oha/RZrIBlD59EUvA83dCH8ap4vQbX
	LfW7JBPxXUhT9rn9Jh8nwFf5b/LE02sX9XkRVPqXd1GE6GLFISTkJtIHbO2RWcnrvVfOBBqz80P
	wsnaFZ8ivZoKmV5HFz8HA7pDBP9KGTydQiQ+AJh0W/+wZ7ldtGWkiAstRlch3tJJIxd4GHsbN24
	gYnEfRXE+jja8ymP3SHh12bq31Roe5mHSoDfPYO9jpAgMQMKZ2MG9C6p84zAd1jIgUZzaaTWP/z
	veMPZmx9N7ueTV//GpeFYzEZ0RSDxeN7eBjCK3H/w9YgHuBx/rXmFJtWiM4GYUDa81e4aqOA3xs
	VwgrWx
X-Google-Smtp-Source: AGHT+IFiIijqJvOxKv2Msh4VSOmr1gEPN+Aj6QW0h2lKI4XTAhql2QMIiQNZ8aasNX99rOtVkVOm6w==
X-Received: by 2002:a17:902:d50e:b0:224:1ce1:a3f4 with SMTP id d9443c01a7336-22c532858cdmr240559175ad.1.1745339381610;
        Tue, 22 Apr 2025 09:29:41 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50fe20b0sm87481695ad.243.2025.04.22.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:29:41 -0700 (PDT)
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
Subject: [PATCH v2 2/2] userfaultfd: Set the corresponding flag in IOU worker context
Date: Tue, 22 Apr 2025 16:29:13 +0000
Message-Id: <20250422162913.1242057-3-qq282012236@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250422162913.1242057-1-qq282012236@gmail.com>
References: <20250422162913.1242057-1-qq282012236@gmail.com>
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
 fs/userfaultfd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index d80f94346199..972eb10925a9 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -32,6 +32,7 @@
 #include <linux/swapops.h>
 #include <linux/miscdevice.h>
 #include <linux/uio.h>
+#include "../io_uring/io-wq.h"
 
 static int sysctl_unprivileged_userfaultfd __read_mostly;
 
@@ -370,6 +371,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	bool must_wait;
 	unsigned int blocking_state;
 
+	set_userfault_flag_for_ioworker();
 	/*
 	 * We don't do userfault handling for the final child pid update
 	 * and when coredumping (faults triggered by get_dump_page()).
@@ -506,6 +508,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	__set_current_state(TASK_RUNNING);
 
+	clear_userfault_flag_for_ioworker();
+
 	/*
 	 * Here we race with the list_del; list_add in
 	 * userfaultfd_ctx_read(), however because we don't ever run
-- 
2.34.1


