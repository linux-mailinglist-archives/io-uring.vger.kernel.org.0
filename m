Return-Path: <io-uring+bounces-8500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB0EAEBB1A
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EBF25625BC
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA2A2E9720;
	Fri, 27 Jun 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clHeJKWZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7172E8DE9;
	Fri, 27 Jun 2025 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036963; cv=none; b=jFRDvbk0qWQum7eQlBtLaOP8xXuU31D5pY0uvQJDDAMwMhWitECqf/bVWkqxQwr6+6dvZrU06To0pUklYMmqwwVocd4DLcCTX8rw/cRjbi/3DdBeyF1ctEzGrgLJ+f9rZqNkKbvMC9gio+pmojFGmXLHfPxfefMK0e0pmhKc0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036963; c=relaxed/simple;
	bh=hpPGLSpi96pCT/UM/KewWMKmW+5DJlPwTgzb6WXLTwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oT3R2P7ZhL0Y8ClaXwH7ywM/lcQDRvzcbJPhyqdM2+jm3CJaXqiBgKOz7ypdsW8nCH2boxKoDHUD+drRBmn53yp5qYIFu8SeqPRs0I0kbEihUtM8ZMi06gDTXeqo922Z3T+hZjSk5FdrLJH2Rz4yIwfyb52LsPzCi5WgU/EQnew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clHeJKWZ; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60c3aafae23so7185714a12.1;
        Fri, 27 Jun 2025 08:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036960; x=1751641760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x3nCWT1NcldcDc8pq8FE8F+xw71Uaz4QUrkXi441nE4=;
        b=clHeJKWZdJK38qxP+TQ4o+/WXd3+vjbnD7cbL3fkS3dcOeubYJlRLge9wG0jiN+CPv
         AHNekOmsFfgkfb7QAJhvgNZ4/Ie+YjyK7siL5sVegmEbAti6i/hu75aqLiHtKrUs9jNO
         EZ9PFb6Lf3znfyVd9W9f3Q5n1EPmqVSAPijLd2uts7JCE5lV9zpCDCbsgBqozOpdiyt7
         7kl4VF0TCbHuusJeqbDLRb3JnfJbrBLLSj3V+uWK7vMmDuB2vPNyHw34iT2WjSOGjjUf
         RzhjnbWCqJ+SYTR1vooAXt5rWHcR3EHdw19Q1zkDYr7HVpE/e71pLw3QOvRRvkpoKpeE
         gOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036960; x=1751641760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x3nCWT1NcldcDc8pq8FE8F+xw71Uaz4QUrkXi441nE4=;
        b=twNVHSqGts5C3IACZ0Jlog/JQnjcTiKmigtCTIROKOzhUrEJQ1sCUJzkHDlQZlF+nY
         yHJBXepsFuaDv0NbLXnSVXqiB5rUmpBwRSXKKMoVpmwCRcN4yE1x9C8l90/sX+nM2kGn
         m9+xyLGWfr/w2M03qH1DV8qIjWvo3DLVeAydi9KdcAn0A5RAyAN0boL2jaVPChJpCB/l
         pgi6Pi5xMfXI+pcPQmoJ9U+Nds7l7CH9fvVWv5hyO7U4SXCDxORpXJcrUFv+l14mQEs1
         iDEx75oJI8QSSGUa3jy4GrKyP6yF4bsZNtd+Yc+bU+GT+BcI1ZpMhOxa7sHoMV2F81fw
         H7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/w6AzA01CoTSnIVsI1ZMVD0GByXcsSmb1zLngSrCo3v6HJRcUjMh/LLFUqXCR6lvSyjIpWjYhPiMZjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmqA8PAgY+KNDtRw0cs75J0dhh/ELNIqGD7JywvP4Ev/XZ1nMv
	InlfAs9rQzOvp5JcANv3yXw8mfVpTTAStXeswEpJFliDDgN+0/NEKReTCIq6CQ==
X-Gm-Gg: ASbGnctfmCBOR/H784qjczsuYagP2Ukjlp43KjEQvHdv5BytdqcgssTyrJOIRV4jmiB
	Pi4zleMhhcTSsCFK8N6y2KFe1wOowg4mnfkym0yDTKjVDrs0zyJBg6ctLccGvjLcpQz+Bq1O68O
	DJdeUqpuwrB8NFCOUgDgPA0fgs5hPHsql9mLWAiTTxXc+fTAKVRy3DAhl2pP28wlMMGyeVwrxFo
	uIYzKISBD/+BN8sZuy/7DuP1PkMmo4jq1zKaP88pjQ67Zxe2GWOC/tRuirMDlkRWeBek0uRoqBn
	2g+ATe1dVyFLIDVvqDd0AfEt0anUXYMRsXC/xZHva0O1A79QmNOIrerxudNyB4HY1EZyOqAbHJO
	X
X-Google-Smtp-Source: AGHT+IGmvGAQOzgfukcAiQmiXttQr0NA0dvGdxOdGJDKKIcTaii3K7x3hkWnoKCC5+pogFtMy6rD8Q==
X-Received: by 2002:a17:907:94c1:b0:ae0:c606:78d0 with SMTP id a640c23a62f3a-ae3504c8ccdmr293381966b.23.1751036959167;
        Fri, 27 Jun 2025 08:09:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 01/12] file: add callback returning dev for dma operations
Date: Fri, 27 Jun 2025 16:10:28 +0100
Message-ID: <4f8aabdbbeda098424556259d69932200464a526.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a file callback returning a device that can be used for
dma pre-mapping buffers. There should be only one device per file, and
a file should never return different deivecs during its lifetime.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 96c7925a6551..9ab5aa413c62 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -82,6 +82,7 @@ struct fs_context;
 struct fs_parameter_spec;
 struct fileattr;
 struct iomap_ops;
+struct device;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -2190,6 +2191,7 @@ struct file_operations {
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
 	int (*mmap_prepare)(struct vm_area_desc *);
+	struct device *(*get_dma_device)(struct file *);
 } __randomize_layout;
 
 /* Supports async buffered reads */
-- 
2.49.0


