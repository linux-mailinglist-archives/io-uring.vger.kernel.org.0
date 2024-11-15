Return-Path: <io-uring+bounces-4724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9549CF22C
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9F831F2B2E8
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB0D1BC077;
	Fri, 15 Nov 2024 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFshcYp1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FED1D6193
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689642; cv=none; b=aa8HMFU+GinmHtfXDUmudIVQMNFr5i9Lj34Xz3iZbeO3he+OXC6PpyfwZ4Q6vInazNKm3xMK7rt7OLgWNUZ1ZqBLLUweWymtKtR/74xZC2uXzdz25x4Pn4LaYbjd2Qs1U0r4j40C8h6QX2G9VnNBdgBmQVbuSkCrbezJtGvq0cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689642; c=relaxed/simple;
	bh=eGfmk5pHWRmz/5IEyopxX540NFO23oPagEaL0p8rDAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ4nAAqhJ+TxLFJUVlTcE1/F3XpvO8nctuQ6uwu4Cmrw3Ciqbb1ZHv0kqrnyKWAMVRc8bfiXo5/gOEzDw5AuY539CNha8vTmI2paXMRd3Qc+PXUOqYwexOrMAoBZrUifeB+k6A4AmuDIyhP0cm1mC5+A7bCEBD3RNjT53ZmpuMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XFshcYp1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43152b79d25so7625685e9.1
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 08:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689638; x=1732294438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbuG+/DWjJeYlovcxNfbsJzRVRRM+t1Xz3YpJq8xpS0=;
        b=XFshcYp14LWrKv0blDx2iz22niZjbVcSHkZIY7vnaoOMTsiidoqDt6Iw+FsdnbLioU
         gF1LB6W+SYOAoBKqBeyoWvyq/wnBAGDyRqn1Ni/8jZg41RWSP5Po1s76o+gvVdhZQ+ny
         UKXDvs2+v1T1coqs71T3MuWbOVdHtY2ried69hMpwNzi+XUbi9fsktcuVuQTPeNzzYw7
         GO48lFOR5xgoFbOONv0nVNsxhLxzOMHk4vSfKAR5WDEcUE4IGbiJotZMk6cMZGLCcXt3
         v4oTDb166hXnB+pYjJjKqendtAqg/FSt2iNriZzmCKkyW5gCOQfHh6troJ8JniF9Xvca
         t/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689638; x=1732294438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LbuG+/DWjJeYlovcxNfbsJzRVRRM+t1Xz3YpJq8xpS0=;
        b=S8o2ihfG+XZocGHZr9JKqvJE2NmcNB55aDOUe++ucqZ60o4GWl9wpACXPUSPgM4KTw
         FBL67qaIXcXfetI/R31EzN1WQRG78p1FCB3321gxhjLewD9JxKBr630d7DSQgKGyHpZ1
         YvBQqN/xQI56BHn393qalIC7wT26TMB6LhmXDXvfoCZ3j2kH59Zz5607ucTL3zYmjD+T
         Y0HXgnKpcnmnT37HsnJg+49BsmOiQUKndJoFNQ8aAJC7nvYAY9q4a3AeO6BjSeBi3KLW
         3s+xZn5u71htNo0ypoiPBHOoldhFZ4nfpMevL+RENxEOo2XzD0/4hANhMdG2u9K78JE9
         KGXw==
X-Gm-Message-State: AOJu0Ywng52HzXy/67QLh7wbPWQM+HwS7YszVtccDsDJxDou6O+AWYqB
	QvBgl7WNZS183u4EwnMoO4A7Ilc/wcNmZcsFstwK+PTCyPQbdaGZqqn6eQ==
X-Google-Smtp-Source: AGHT+IEJxaVtJYtyJ0rRdBA+3ko+Tv/ERgTAwAYV3iLFWdiDtvdJIlIEfvII4r4pzj7HXM4Sabrczw==
X-Received: by 2002:a05:6000:400c:b0:382:2ba9:9d53 with SMTP id ffacd0b85a97d-3822ba9a365mr1252396f8f.16.1731689638208;
        Fri, 15 Nov 2024 08:53:58 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae2f651sm5011895f8f.87.2024.11.15.08.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:53:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 1/6] io_uring: fortify io_pin_pages with a warning
Date: Fri, 15 Nov 2024 16:54:38 +0000
Message-ID: <d48e0c097cbd90fb47acaddb6c247596510d8cfc.1731689588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731689588.git.asml.silence@gmail.com>
References: <cover.1731689588.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're a bit too frivolous with types of nr_pages arguments, converting
it to long and back to int, passing an unsigned int pointer as an int
pointer and so on. Shouldn't cause any problem but should be carefully
reviewed, but until then let's add a WARN_ON_ONCE check to be more
confident callers don't pass poorely checked arguents.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 85c66fa54956..6ab59c60dfd0 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -140,6 +140,8 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(nr_pages > INT_MAX))
+		return ERR_PTR(-EOVERFLOW);
 
 	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-- 
2.46.0


