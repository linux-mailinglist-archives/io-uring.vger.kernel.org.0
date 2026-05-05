Return-Path: <io-uring+bounces-13237-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMHjBOKe+WmQ+QIAu9opvQ
	(envelope-from <io-uring+bounces-13237-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 09:40:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA814C81C7
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 09:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF9C7300F11B
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 07:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136C53C5526;
	Tue,  5 May 2026 07:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Uy4soQ0F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B042290DBB
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 07:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777966748; cv=none; b=pvVtLwI7fhOlMg9JE3yGgSXs5cN4Tm/Y4wMWfstVfTuZnkFybyXvwCesE/duKDf5SHE4YdjlOloeQhQpBhPYJXz0XK86XYoIPrzuXM0SUYbdPiv44Bw4WcxvbkmL0JRa/GlNjmk+v7D+cHPrj9ebrYcGWREphfORmV3vCpwpFnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777966748; c=relaxed/simple;
	bh=x3t7CqHGPD4J4L/ylzzph1OeM21h/k34NS8Qy+vR88o=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ibw5SZoe0OvPKnuOvoa/Zss59khXEWItFeA9cqRZTyXvT56BA9WiMl7O1h7j/8FdmCPSAhHrSfFYZqrBCi8kQxR8WsQmv2DwzSuIWaYtHDSElZuQ5IsTrLfrCqDCOczgzG9ovoJLszd1tHpoP69olyEJSwN7gYN+5HTqllImuug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Uy4soQ0F; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48d146705b4so7213365e9.3
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 00:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777966744; x=1778571544; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIGGuN+GhElqlA1tsuYCYgDDvgyDZWXKwIZIzXJ97Fs=;
        b=Uy4soQ0FeusWmgvFZGL9+t0lZv2y1PwHBE5IHSs4uXEuhjJOAbq4/ZVbKRESp+OBjZ
         WOlUhUSxmUNrM9xYAQfhLCNuLJ/UcgrtOhK1dX2DdjVXpaYaLR9YxWVTfvideDdQtIRn
         xiIVBydymbjEWXXgA5GoqQzgNAr8pRdcNhSEhbxwkpFDEs5NWlxxTLM7qiGnHuYxg50G
         B9pttpfojRoHGPC16o+rFcOazmFupqcdSbEV/p5M3Nyl/DFg53hflU5K9q+WrZQeehOB
         6BC9fRkLStrQzSMpxCmlQ2HkGSs6CT0fP3qI1jystljaF8YD5xU1HRZM8tYz/bIKbRtw
         8Xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777966744; x=1778571544;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EIGGuN+GhElqlA1tsuYCYgDDvgyDZWXKwIZIzXJ97Fs=;
        b=fl6QD0RO/5EOGpAk2Wnkwb/yFB+CCRhJ9OE9BvznBkUX3m0OopByMv5hR/9he9UPVQ
         VI2b7Ks0rvzdhO2Jwu3KPgooRKS5FhUCBfc2NJig154YpSgg6gdDt7qvEfLb19J8cCl8
         tWCvsXTinEkpnvheaLWG7DRwDhunZaT+zalipZelLIxdtkIjSz8dcteBcxJVrFmcla2H
         phJjSwzhsudVBdTYvBsphQwS/QpBS2FlXgz8nCXPKw7Nr5EZDc1TQoFtmcV2QfntnNdl
         qbCib8FmSnfhGa40FIwxxQEk5VcFsb0QR2pYLNzQnl00QFKFNTQcLZU5HG5KJz7foTNJ
         vHKA==
X-Gm-Message-State: AOJu0YzECQk+gruH8iEg6LqWVfWEIOYFt8TpYM8d5n0sCBl7bZlsP7CD
	aT6tfKOIMqK7bsePgHJZs8d22nrRF48pxM+qoy8G2qYE9JHw6mAOvRiT69Y1ErM2eBXU/h84KuO
	CWMZpdV8=
X-Gm-Gg: AeBDieubzHc3SJ9ZkyoOj27iLbx5yhJu+BfvJzE+6paO+ACmtFcZzIn/IgEvXYjs8EL
	hVC8bry7wbHRVO0lZWusyiw8rn1vfhm/qQcTpOoUzpR/yOoqBP7OCEcf0E2kzlAE4Dec4qpXF9v
	j2xCfPWkp0NUIQU1DxUaqt8QUlEn9px9aGqjCExWKgeoAsKggp3sO8MOkkIfjbzUh/2EVFf7kmN
	lsvN3eaT38HjL+seZJ5clmZ0VZBQetIEUCBhQUhe1dmtXWAQ9cED3h6wFfP24Clf7ZYkT9Ys+NX
	5Nw83vWyAGbOvkE9zZSxJR0i7H5kmWTRT8oBnfFO4DG85J3OsCMBuINzQXUmqi23DKn/d7DnWiq
	owg/CtvyGW/tIoeypqVMPM2iNZC+rg8g8FEmAml2wlcsWv7umO5Q8F3vmxA274V4tXiZQQH8SCj
	0xClZPjzf9boWKviw471I7OX8ArVg9HZAqKSJWO7cnBuFfuScb2GiYBYXcWXCC4Jvmi1TqdlGJ6
	Drc9uwC9gttkw4BPnlm
X-Received: by 2002:a05:600c:810a:b0:48a:592c:e655 with SMTP id 5b1f17b1804b1-48d18be5ab5mr27767125e9.17.1777966743648;
        Tue, 05 May 2026 00:39:03 -0700 (PDT)
Received: from [10.211.9.173] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a82301b7bsm452022915e9.11.2026.05.05.00.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 00:39:02 -0700 (PDT)
Message-ID: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
Date: Tue, 5 May 2026 01:39:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Andres Freund <andres@anarazel.de>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rsrc: remove registered buffer 1GB limit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5BA814C81C7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13237-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+]

There's no real reason to have a limit, as the memory is accounted by
the lockmem limits anyway, if any exist. io_pin_pages() will still
restrict the maximum allowed limit per buffer, which is INT_MAX
number of pages. For a 4kb page size system, the limit is 8TB.

Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 4f9b439319c4..74149b1cae5c 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -53,7 +53,7 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
 		return ERR_PTR(-EINVAL);
-	if (WARN_ON_ONCE(nr_pages > INT_MAX))
+	if (nr_pages > INT_MAX)
 		return ERR_PTR(-EOVERFLOW);
 
 	pages = kvmalloc_objs(struct page *, nr_pages, GFP_KERNEL_ACCOUNT);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..0b85b35bfe08 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -88,8 +88,14 @@ int io_validate_user_buf_range(u64 uaddr, u64 ulen)
 	unsigned long tmp, base = (unsigned long)uaddr;
 	unsigned long acct_len = (unsigned long)PAGE_ALIGN(ulen);
 
-	/* arbitrary limit, but we need something */
-	if (ulen > SZ_1G || !ulen)
+	/*
+	 * No specific buffer length limit outside of what io_pin_pages()
+	 * limits us to.
+	 */
+	if (!ulen)
+		return -EFAULT;
+	/* 32-bit sanity checking */
+	if (ulen > ULONG_MAX || uaddr > ULONG_MAX)
 		return -EFAULT;
 	if (check_add_overflow(base, acct_len, &tmp))
 		return -EOVERFLOW;

-- 
Jens Axboe


