Return-Path: <io-uring+bounces-3318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7175E988F24
	for <lists+io-uring@lfdr.de>; Sat, 28 Sep 2024 14:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B1428206F
	for <lists+io-uring@lfdr.de>; Sat, 28 Sep 2024 12:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9965186E54;
	Sat, 28 Sep 2024 12:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3NMda6lA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9821381A4
	for <io-uring@vger.kernel.org>; Sat, 28 Sep 2024 12:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727525923; cv=none; b=DnSEQJAZ2soJCeZg8jMsZck9Ts2hZwd++ob2TZFPb4bc7HgPCyGjqlfQ/7wEA87RF/2i/wlbarLJcsI6cfVu259fR1BerItmWRX7rJZeGYPYPvVH3ifsGGALZnu4s2iZWkZzwtVL1LtGrtYYg1ndFTf4/Ub0yrELan76kkoHFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727525923; c=relaxed/simple;
	bh=TCKCpOoWjNU9xX5PJ6d07XcdPInyurpVDaWQoALW4vg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=gdORmmebl2eK/b1CTztugOLFTHKpxe5kEoCS45UlLzaKxio68xTdB1FvCM5HK5FbxyiVdGPkjTp7OjZTk7nZtJyR9qNkK0O/UXGnwFWTdU56IewBC8Oc9CvAOzS7yKpsx/wuWf75gm64DsPRJbAn3HMPUWqBA4uq3BFaPjKubQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3NMda6lA; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2059204f448so27329185ad.0
        for <io-uring@vger.kernel.org>; Sat, 28 Sep 2024 05:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727525919; x=1728130719; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CO+tGMUzJ2MHlobO1lTFqdzJXo5+AcfSjEJuHGyyqDY=;
        b=3NMda6lAUgyYDeEwwkYuAgMOY8tELNQCWyXWdhe172KBNLZVSVnuDdobW95jOgFZm/
         aXj6odIGzIfiIdi6bJdf06cQo+upjewMlKeYARXeKIpZXjprM0AQiK43KUNjKDU24hOz
         xtUU+5SatU7rSiKNiAZ0ZQ4LOV660yGh0Aza5MsMgNsjh9PhoQE5u8d6QQIxJv0P+E/O
         MaKtWBRUcHu7xnPsl/yOFg9oT61xgb2gPVWFIxHlVXBqngP6fT7w4Ep+xhm8zr/buNiy
         mcjEu0NeRG6j4M6+NYlsxLYdRQfSJgg+iqwwJT0nEvFDdDDVDvBwP62+U6HWzEgZ77Wz
         MHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727525919; x=1728130719;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CO+tGMUzJ2MHlobO1lTFqdzJXo5+AcfSjEJuHGyyqDY=;
        b=oCjsqjBzayBGZgKvEvh+Q/lPMe1p2PHaek5IAVb/7hRnRRElL8qfdr5mNJAlrKBCIO
         W9/QMxQOqvZDokIfbml8v2hc9TUgWTn4tSMEmOlws26BNeq6UKtqL59Z43huTY2TUCWD
         ni+xaQpXwfkwoitDAvyLHv/KKka5Bgn4wIl9OLlzYrK0TFR/C75qCXWeZ9rtb2pGBivi
         OJqKOXIMajvpNiX02vI3Q5I0ctIsyhoCxHe3V6usotcsQLYizTS6rZNKYPBioLRpMhbS
         or7XW7zUwx4IRIFH6zNWzC3GFYHPnYsNVZbJdLWKL3l9H5XThD42/kuCobpzAIZ7AYUz
         zMvw==
X-Gm-Message-State: AOJu0Yw2YDevE8xK8zZIzo+Rt0ZrFCQ0SWFT6eYqojBBNoiGpZc4sDXD
	qXU6Es8v3WdFlCCdcBHSjEF42fm6qiQrfFXRYWlUlfYmzw0l+ZF7kJCl3aYZoXly9mW6BBhQDsx
	ZjSI=
X-Google-Smtp-Source: AGHT+IEiIF1eWxtp9EJnO4YMGlHbA+TMWiGZXkcA260dUpqqCRrtWeVW4wx/TDFqqZt8JaK3d5uSLw==
X-Received: by 2002:a17:902:c948:b0:20b:43f8:d764 with SMTP id d9443c01a7336-20b43f8d994mr84812055ad.8.1727525919157;
        Sat, 28 Sep 2024 05:18:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b533fa125sm11974705ad.141.2024.09.28.05.18.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 05:18:38 -0700 (PDT)
Message-ID: <fc717e5e-7801-4718-941a-77a44513f47f@kernel.dk>
Date: Sat, 28 Sep 2024 06:18:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: fix a multishot termination case for recv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If the recv returns zero, or an error, then it doesn't matter if more
data has already been received for this buffer. A condition like that
should terminate the multishot receive. Rather than pass in the
collected return value, pass in whether to terminate or keep the recv
going separately.

Link: https://github.com/axboe/liburing/issues/1246
Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index f10f5a22d66a..18507658a921 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1133,6 +1133,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
+	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -1187,6 +1188,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 
+	mshot_finished = ret <= 0;
 	if (ret > 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -1194,7 +1196,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	return ret;

-- 
Jens Axboe


