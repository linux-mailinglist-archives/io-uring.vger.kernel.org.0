Return-Path: <io-uring+bounces-9807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B63D5B59A64
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 918274A0DE9
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6825433A028;
	Tue, 16 Sep 2025 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7lbGFNy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB14335BBC
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032819; cv=none; b=dMoj3NBMxifX8hCgxPViH3dKfaP0QCylCy4t1FEVq3Yh/w5vDcP0HPlzkzR4xDVfTKYx+txzp91pxF37o9hvS4JxiC/YMw9ruvl5Esa7xnOdXYGRmxLjLaYd/AmZVeFIgbBnUXSJCBNyo8wXZOCE2KkanCEdmbfivekGsBeWk44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032819; c=relaxed/simple;
	bh=8DVyY2My2LnEPwUvnetRDblgxpbBgNNQrN4DCe9dGjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruGCslBFoZHGQJK+Af7B3KvEzzlzJVD2v0Vw5/gaf+7lHiZwY8Eo+h+8S/T+8G1V01lokF6O6rH9ONu3GiQBd1EQ8UHy8FAdGxBM5bJxt40jfL0YBCU1d2Dwsw82SMYnNnr2AQWwpQkOoWU/W80zUPHQTJ6xldiy1oV7R9EAUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7lbGFNy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45f2acb5f42so18129825e9.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032815; x=1758637615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCOQ1oM1+EGK4JaQrE9eg//uAjULVcI6A3Z+lM4I9Hw=;
        b=J7lbGFNyrMaFAMIAmdGhLK48dRx48unwiJwLS+l/miQhfgoAYZbeDRzFmA64IpTF8K
         eTvkjXFJOTBTBlrCaFwK+HOXPKi6P/x0HRuhf27pGpHpn8w0jC0JKudZHlM849pGae5U
         xwTEkwhUdmTWVw5o5N5T/Ead9u7hrLqqoTkDU1Q2t2REY5D8+sU4xWvhbbpB1c7VuvzP
         XZ5jAc1NzzFgOgzarsGeZdi+9n7KKMvfEBMGbBCf4GsjGI+EgPCYcD5gDIO0iZ408eeM
         bR7WVA6Wkd61PA7l4K+HarpEnIHDWQAO47fWk231J56APna7DJNImm5XflFOpmoNsKPz
         6CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032815; x=1758637615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCOQ1oM1+EGK4JaQrE9eg//uAjULVcI6A3Z+lM4I9Hw=;
        b=owdnMtayGWbHot2JXcjqEnvn0aKIQgyVeUEoKlJo4IhakBjxRlinWwREEz6th6rmFs
         ahh8y3JPiaAEyyoaPZXVt0l/WQVuQO698zsvIFhoe8HkeOIfWV6vB+nvoculsBROIMOI
         q4ChUJ7VbLwfFBhUsnkb/8gPUtGbaOIeMiV3dy4fOSArIpVSjkQt6GsJqjJWJIOEJhcv
         +V1TAHT9aVe2gYCPOLwj+ouS4J0Cx9hqz+q6SX/pHYpWyDe7EBO8FvI6oknK5EQKOeJX
         bXqipuZIksdYsb3NhE0mVj6m5dvSrUY7l1TQw2dED2XdUywixxLHCRtQ3MS3fFWrqjpc
         NsPg==
X-Gm-Message-State: AOJu0Yxa5kypc5Ff4L4BxN3uqbSZeO/Ok6Q8XOpVAkLTXNMsejnkaKcz
	0bJd+nVNqTQE0XJ0BGhTlYhm/0fzZbZ7H33NDikagH5V1Mn3OWdepnYfvtC1MA==
X-Gm-Gg: ASbGnctYGu+p2K9XHsngLy2XgUvt4zPTDqiRzzE7AeB5l3zHBIKg/m71eMsDZ14viM9
	CWkDPEfI4V0AbSiRjr9g5Jxr1D+vsfh00P5R55R5/acl0JzuvegIkV92ZbxwlKo9y3vP1J49PKX
	qNPRe1xmNrqblwg/z+lqgHCqyhxgHv1tlzFapgpKf4bFrz2pbOMT0ghuRaZVVQdvaQRyaEtv+ln
	sLyYB/RveKa+kjr9BAxbD1xPzQsbYeyjq5WtqeYI23LqL23GlnR6qyIFjsmjXS6fd7TUZX+LwhA
	PxO7fjCPH/N1TXNBnHEcNon7OSWfEppvC/hLhRnT3P+rU2tMju4dz7l+ddKQlvaKShfq8ffnh6m
	/kKADWU5YWVZY2gmO
X-Google-Smtp-Source: AGHT+IGepxlRfQhtbVssWq1YllEYEBgJiG4tc7DKoOR0KrmEboZOFgDrRjLS0dxnnFqn0l1l0E5mYQ==
X-Received: by 2002:a05:600c:1907:b0:45d:d202:77f0 with SMTP id 5b1f17b1804b1-45f32d16c2emr26029615e9.5.1758032815300;
        Tue, 16 Sep 2025 07:26:55 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 07/20] io_uring/zcrx: check all niovs filled with dma addresses
Date: Tue, 16 Sep 2025 15:27:50 +0100
Message-ID: <e15dea1bae569f620c28edc887596470f3f37322.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a warning if io_populate_area_dma() can't fill in all net_iovs, it
should never happen.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ef8d60b92646..0f15e0fa5467 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -77,6 +77,9 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 			niov_idx++;
 		}
 	}
+
+	if (WARN_ON_ONCE(niov_idx != area->nia.num_niovs))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.49.0


