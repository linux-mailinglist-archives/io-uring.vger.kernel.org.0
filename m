Return-Path: <io-uring+bounces-1467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE6489CA77
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 19:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF701C2439F
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 17:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C3F142E9F;
	Mon,  8 Apr 2024 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPMB6/w9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EED14387B
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 17:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712596283; cv=none; b=n9aQLsRN7kKjKcnUCMhYDsUQB8sMLW/E3OEsG2UsIpwrUDTP5xDhv7fO0WJIdGTEb63+3w+Qn00hP1gKM5ohvRvDWC1pq+0U1PY+P5j5O5OQur4oPlJFMrQIx9M+v3YOlArj3nQh2fJ6CO+3Y/txQtG1XH8gxgXh/p/WDNYxKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712596283; c=relaxed/simple;
	bh=xwk3SKYQaN1C15vbMHJpRxe3JiSqBjXS7OiPZIsEuHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mriX/F0u4EKAOF4Y5/AoH4oM3Dl3WP1c/MfJkOPpexLdJpBvBq1kDbCh+ArBkA8c245SxrJmpmSPk38BS0+QFA330cO1Z4jDzBWMsx1hBw9lDMShFsN93j9VwhduVGgd09qToJrpbNY/XhhaKOGJjFszHW0uOqF/we3Wh6wafNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPMB6/w9; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a51daa8242cso127226966b.2
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 10:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712596280; x=1713201080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=naOX1KoHrARiozxv4VGslLHnFurXXKC88xhT4svXf1o=;
        b=kPMB6/w9ycKUP9cAVt2acP3XVEfiaowT1DhsDD0a2WX7BWf0tLMt+82taoxVcH33Oi
         9JTI20rTJfunLsPDcC/cjuX9fwoT/DUXTnjU0YJb00PmP/sT/T/ka3DtXgWXJ8uJ0kUt
         6zgTsn3qtoRtDj2wg3GfCs/gzYZY2FjlXWmBDX1VVZnIanmd5ZarEI5UFb3BCZxVhtYR
         yQgKUrJxmAoM5ktF3i6lHYsvceAkOulaOZxn42uBjchX3Do9JKnwtSQtrNOZn+Vr4xC8
         q80fIymyaM/ga7m98aoYilptqa2nfd+rEPEi8V8W5qVssVLYEptwKFL9HfwXohbh5196
         K8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712596280; x=1713201080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=naOX1KoHrARiozxv4VGslLHnFurXXKC88xhT4svXf1o=;
        b=fOgnNj0WgHmVR0aaVXWlRRZu8rR5r00cu13PxaDlphvZhLwS+j0cy7JF42Hn+JRfDU
         wPGkelYSbaVWrNmpOzMvCF3F2noBzUGIQ41q4O4l+qf87CrUk6fnZbWBaq8NcKB0DcLZ
         OARowoYhRJoe+2H18Sfkmxu0KzZc+5ywa9/IZMiBYZJuLfj1macyM38wD390ZyWIF8Tj
         v8R18lEj4kZj6Y3IWEGRp59sehMHGh+VNXXusGC4/rDzXfuHiTFU8TyRcrvO/PMdnbqv
         2vBMAINDvidZBtDejjO4N29He8ovCRYc/1F8DEJ0njwdrO5dTzNE1N4GSmvxOIaAXdOB
         tNGA==
X-Gm-Message-State: AOJu0YzrOEZMy2IGX5A9X4vY95ThNzr0gkkCX+8rFQ9vLhpt48P+D1Cu
	d4+zuO+o5Ss58DXiEUZQcCheg5SIf0kocp8JXnm1eaPjmtz+vIxCI5gPwGwS
X-Google-Smtp-Source: AGHT+IFP32DwGzyp6mbhyBmuCnClrBUo34LF8z02l9f31bLkQghXf3nObq6siotFUBxSNMmkVwhzwg==
X-Received: by 2002:a17:906:eb43:b0:a51:d611:cd5e with SMTP id mc3-20020a170906eb4300b00a51d611cd5emr1855523ejb.57.1712596280205;
        Mon, 08 Apr 2024 10:11:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id js23-20020a170906ca9700b00a51c6d98777sm2623879ejb.58.2024.04.08.10.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 10:11:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-6.9] io_uring/net: restore msg_control on sendzc retry
Date: Mon,  8 Apr 2024 18:11:09 +0100
Message-ID: <cc1d5d9df0576fa66ddad4420d240a98a020b267.1712596179.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cac9e4418f4cb ("io_uring/net: save msghdr->msg_control for retries")
reinstatiates msg_control before every __sys_sendmsg_sock(), since the
function can overwrite the value in msghdr. We need to do same for
zerocopy sendmsg.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/1067
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 1e7665ff6ef7..4afb475d4197 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1276,6 +1276,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
+		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)
-- 
2.44.0


