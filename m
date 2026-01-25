Return-Path: <io-uring+bounces-11921-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGRUMEhOdmn4PAEAu9opvQ
	(envelope-from <io-uring+bounces-11921-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 18:09:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 110DF8189E
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 18:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A978B3003ED0
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 17:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A05D22D785;
	Sun, 25 Jan 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FrA5LKbK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6D31A0712
	for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769360966; cv=none; b=f+dRX6GyD6nIkd9sYhA4EaX6LOEDYJxD+0CGZpXtWL8ahWyNYVegr8Yt//RM67q7T3DYQRLEktIexuEq6jb79VNx8nacjDvPT1mBOM4rq1HYqlqdxrKFAuNuEfvn79FNV1TvPIr8PYCo7yfopVizy63IL/fvMOuHvR1OvV5mGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769360966; c=relaxed/simple;
	bh=lGW3eg7pMCSg6FEuQM3KRqWvk28gMO9PTd6Xfp3kbZk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=VjK7h9FtpFoUdiV05OEH83sUzG9bG+EKrr77OvylQ44haMceUXZJGpDZ2hIwIDrHZ/xEx2r/Np6ujF82xtot7r5j81g417YHQZEIbLAWKbVYOmQvoD4Wq2i61qt8mmSgxc4JX317j0sVU/zO1EklLk38UTlcoF75MMGk67XNoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FrA5LKbK; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7cfda2de4efso3615737a34.3
        for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 09:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769360963; x=1769965763; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Hf5rb7A6YY64TQvDCw7SxHMw0fW9f0RTeyNTKio+2Y=;
        b=FrA5LKbKA0gTRG5zgRHF4Pk2Muya8DSgebXI50tkigxTuLVhn+mA9u++GnZurdCQ6A
         g5Kps+hWFM5C+fZQZTcotJ9rYmBmJxRyymW2oXPIfaRuamAdgJK/ncnh34QCMEthJHDo
         eld3zPhDrBJ3srMGDICn6wTADOkKn971oDNFQAwuXXWPDreNE9nuZMLfSO/9Nge+7G9n
         ean9rWKre++mmNA9w6wYAt8FGkLHJ4PFM7pF5wfoPgBfkdxUOppyFQXgwNVaqM45zUuU
         /JBD0ynV7RBa+6jNVSsKK4SRnpZMVqOMyKYslmAEG1I7bYXdH5x0uDomMeAbISGo1i64
         UG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769360963; x=1769965763;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Hf5rb7A6YY64TQvDCw7SxHMw0fW9f0RTeyNTKio+2Y=;
        b=B2vt2LHoOvW+pFu0FSE7sGmdG92IW1OIyyAx8d5d+B7JrKcBAfrq0DnsXppSP/cH9l
         qVGJdkF4aFkpVO4znfi+jQykIGD/wQ58NzqgpiR5mYIBlEL3AGR2cUV2Muf9lL3XCgyR
         KudDNfm1ioxd90HYqy1Q2GrHap0kMDJhbDfotPmHbespHYppnoRwY8QLM6mOcmufUG87
         rkgXyHKA63+Xw5U2k8QQEoj6X0LyHp/Ao+C+Ws5PVkQgkm08vZB5h//ok1y4SBttKJRp
         D2hODPrYXwTkmuy/vVgUaIKOUKGaoKxAIXsqbMNvCH2tMa++WrMOO5IbGF09M82iPX6/
         CeIA==
X-Gm-Message-State: AOJu0YyaS3tclQgR/rcXAgxhf4VPP/NYLBHoXanEdAt/AaKyslUgk/7d
	3QNvKhMIu+3CyZFHQ3iePpPmDy6CbVQWh7yQCChw+PyCuyyUhMkzWXxhfceRGqSutw5FkNiFX+B
	ec0FJp9Y=
X-Gm-Gg: AZuq6aL+wX3a4zMUmDZDRNjfZj00QWXSgfkES7TcHiUW6GDEKpSeG7DtUecOGoQUVgP
	qYn35DRAXrad7wNWzFjWEHQYclbKhBR+M3VUBWQM7Y9I7AwzeFD+ryREWIVAOMxSQrOaEl7RLMm
	G+SWadJPC0H4wPVWm6OgirDZgctYel44kBcpy62mpJ4rP+vtwzamAjlQBMA9ATKnihXPgqPDogs
	ZsZ1inLGH4LyA67x9xnIM02qUR88ZG/Xw/fqWwWaBW4DDSzU0hwXxxDVXk5zU0+esWfbMteuU90
	2My7Y/q0bB5QLbMUMgDiyJZbEZok9oa8ysaSvmtnChEniPSGGRilIFbslcdQQt3wfbj6c8apwF7
	nETpQebIwzgNqWqtNrK8LWqxgz4ViFTJ3LMOAX+eaf5L63bgYVmnU4hQ/8gjzR/02SjYYhgGQDh
	aoc1z6J44aGPn2G83QG6VzQiGugOcGO4FNwDpusv2w43he12hCL5GSkCZLu/6vB8cVlBxCMg==
X-Received: by 2002:a05:6830:f85:b0:7cf:dc2d:850e with SMTP id 46e09a7af769-7d1701b59e0mr1059270a34.1.1769360963098;
        Sun, 25 Jan 2026 09:09:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b3e2789sm6272412a34.27.2026.01.25.09.09.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 09:09:22 -0800 (PST)
Message-ID: <0ee9c7b1-fd49-4170-8672-b37e83ccded3@kernel.dk>
Date: Sun, 25 Jan 2026 10:09:21 -0700
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
Subject: [PATCH for-next] io_uring/rsrc: use GFP_KERNEL_ACCOUNT consistently
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11921-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 110DF8189E
X-Rspamd-Action: no action

For potential long term allocations, ensure that we play nicer with
memcg and use the accounting variant of the GFP_KERNEL allocation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 18e574776ef6..81b527dc96f7 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -56,7 +56,7 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	if (WARN_ON_ONCE(nr_pages > INT_MAX))
 		return ERR_PTR(-EOVERFLOW);
 
-	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL_ACCOUNT);
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41c89f5c616d..73b38888a304 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1329,7 +1329,7 @@ void io_vec_free(struct iou_vec *iv)
 
 int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_NOWARN;
 	struct iovec *iov;
 
 	iov = kmalloc_array(nr_entries, sizeof(iov[0]), gfp);

-- 
Jens Axboe


