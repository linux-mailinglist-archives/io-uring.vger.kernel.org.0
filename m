Return-Path: <io-uring+bounces-6750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A1AA44525
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20CD4861A6D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6021624E7;
	Tue, 25 Feb 2025 15:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOrszp28"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB81547E3
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 15:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740499096; cv=none; b=byrcqfMgUOeBReRPGf7Zv+O/0ww+zPc/isOxAM4GVvKERKYvwfcwv+C7nnP9kxq7XwVxp0oZCemdP0aRTXkThZvmgO1uJVvqmY18LsvcGlRw3LaHIeJ+L4tlfqhghOssnu5KJE1oXh0C1DepFBKqQ8PcibaZMYvD8NhvnfAd9iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740499096; c=relaxed/simple;
	bh=lQRhuRYLHV0maLW0kytyCY1p2qhICbYCZ9GzEfe4PGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lojiJB3PX8wno/bA64cuF+zLE7F/S+c44uIsC8E8XE//HwAZJo+VHnmwmO2v1tQqIAAZF19Nx5jZqcCf8pIu6Df/pR4ULsalE+xvDRdPw7Rf9gUTyCfPO0kCdTZh9Wnml8mgfYpY1Z4gWn65BIE9uuu1N3BnmIFdC8zT6p6bViY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOrszp28; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e050b1491eso11673652a12.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 07:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740499093; x=1741103893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cJdptHx8/khlYNeoyIcC1foj50969LYtQDJyzIaysl4=;
        b=kOrszp28lcGqGvnUU/INUjsNYFL9lGzGF/ayBFbYoj3YfQWLQy0BW+NrjuNJegnr8v
         vJE594sDsMhHh4UijeeiILu7s/xFVGyc5juyB9QxUII5KK/qwiS/JSykk+lKeQQ47WIl
         IJIdAvjr0o4M/esW2QO5fK9snURGPZBDWQAOxm1W9X4uQZFhjt9FKN1rkzgFKNgNPPNh
         0Cq3IS+NfSJ1g6K0PF5IslI3By8OoPoyUsk8h4WB/iv00Kvawy68xq/+hlFFX6xE5IzY
         YDxHems+n9AyyS99qgvTyQFDOTtDym3TbSZXDpqRfw3qHshYaJA4YbspFQY9jdUDUv0O
         i4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740499093; x=1741103893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cJdptHx8/khlYNeoyIcC1foj50969LYtQDJyzIaysl4=;
        b=AoMuSY/mycvfB/HmFy019d2CttNwZojTguYLsPAo0eJyrmes3LJxfVR2+R3IASfYfi
         QiFgX8huN6xVEkSoyjKIZCyjnWhXzMDErbPzYvLihspybZlEU61jIS2SGRYIuNXp4Hxm
         vrwM3/p1Cmrpa0nlIW6/R54Oj+F0LMYuVJE2O+JmXm6UmmnhQp97Kckwm31BvY6fuEWm
         YXpXxVvny9X2ZwXO1zF9YLKFHwZhqB7Ptc9i5KUXuOb9P0xIfuZxmMTOHmJmxApdH09k
         StJT9Z/zmnivDqQLpo06CYDDmOtR0lBkmbwyJQpV3nuwOb8xpmM+wWO1UtHuZQkSs8YK
         F9Zw==
X-Gm-Message-State: AOJu0YxTE1Lr9VZ76CpstlGtxhQ5qWhkNsGsV4w2LYDicc10Lk1eH9DM
	1udb2IDewO+U9TQOtMhFV4niZeVNtPqMQG2/nhYHQCyVITP+QRbt81HOvA==
X-Gm-Gg: ASbGnctqnYTOyw3SUW4HJUyTb+U99cHAh4uoMkUZOmf/ZDF6zbJk2tB+7uRdEmX0lp8
	aOzTS9HSghBJ7ncwtD4TG09n5DRQGU814mdeIHH2v5n9QfNFz2fXskUsIVHXh8w+hOuxJWsNYLe
	oHvljE4KTkTDMEQRgsXgBPnDVxZpsm3wh9SE03no4a5zK0OnWpNz7+f9+rDZU5Zy8YozaARUjOE
	a/uzfC4A16688A3UQcKqE62rp5zBOYng63cx9tJL2OqDygzzdCaEPMp4WVzOIAVNAnPqSbS9OyU
	4oc7jipq6A==
X-Google-Smtp-Source: AGHT+IF7pznJ/bdP+hcr8xYk8iBpDMzvYWURMiPWBmZqo3sQtATLy5TG7Rpgmc57BzYNj5S6vST4hg==
X-Received: by 2002:a17:907:7744:b0:ab7:d34a:8f83 with SMTP id a640c23a62f3a-abc0ae94ed6mr1595397066b.17.1740499092684;
        Tue, 25 Feb 2025 07:58:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed2054d7esm161712366b.136.2025.02.25.07.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 07:58:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/net: save msg_control for compat
Date: Tue, 25 Feb 2025 15:59:02 +0000
Message-ID: <2a8418821fe83d3b64350ad2b3c0303e9b732bbd.1740498502.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Match the compat part of io_sendmsg_copy_hdr() with its counterpart and
save msg_control.

Fixes: c55978024d123 ("io_uring/net: move receive multishot out of the generic msghdr path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8283a1f55192..eda666c834e9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -324,7 +324,9 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 		if (unlikely(ret))
 			return ret;
 
-		return __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		ret = __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		sr->msg_control = iomsg->msg.msg_control_user;
+		return ret;
 	}
 #endif
 
-- 
2.48.1


