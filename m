Return-Path: <io-uring+bounces-3114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37926973ABC
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEB8628914F
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E04193085;
	Tue, 10 Sep 2024 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r1N6eSDM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0851925B4
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980317; cv=none; b=PRZj+b14cKpkh4Ivtret8NPtwTSmQJvfXYLnOgIF+PiBoQJBdqUAdTUoj8VxQ4M5uwCNRPQDKstLB7GGSz79uNBVTqj7YrsitSBuGmsvfNIUqwHsKIfGk2r5yOGc75NjWD+jIOCljAUsyAeRq5EkxQyi2t+67vc2CIkXg5jsANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980317; c=relaxed/simple;
	bh=uwhRWHhLfpxNMulRvdzfJLOsZdur9yh48wdTC1gtmMM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=K4svfr7ogNA15u4nrbuAlEpySiFkf2EQKEnZxLRtBXQTfSBmDW+z1fIIdm5DR0mTlJgQhdk1Dg/CLinEarrDhCWLqI3DOW0wr5gzavio9M453RvJ0KOTyZzmr5JcgJxJTPDFtAx2zl0yiABQHJJN6yuQ0YitHccNGzE99M5Osa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r1N6eSDM; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-39f4f62a303so3380475ab.1
        for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 07:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725980314; x=1726585114; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbsn459S/l7CA5B7ZLUChP4WtNiEn64xXVNvnsU/J08=;
        b=r1N6eSDMBGWALbfLinmu6+ektz1ekhY8hEQXLeiYOrP8Q6Z+D9w2qo3eXcutPFNTfj
         1g4yw9q5wve/kAkWeTH50zjMX/oROFDpOKX124kPjJmnxJ7O/bcdX9Ww6Qh67BTocTot
         A46Z3gYANl7dcqJgZNVv/L4w6ww+GKLZvGyji9G7Z3QTHDON+B7DLxfOhfr0srREBIrh
         ixU44RNBpErPMX12DHcMiiUqqFKbMGlqrDUwnMmcz/n5Rvs+MBSi3s7SKx6Z0w286Z6J
         vC6vzhJrkESQF1Mrz53k5JuIrNx2czbaiiHoaj00eW/w2OeEBMWARvdbW0huK0T3UV7K
         yuUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725980314; x=1726585114;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zbsn459S/l7CA5B7ZLUChP4WtNiEn64xXVNvnsU/J08=;
        b=r1KNyQrOIq3+G+iLVDFy1/YgE954X7jQoXGDr0ZCWV/kLChdu3B7w4zxBRpjCIkfVR
         vSbTZP4vzTex9/ot/lYc6X1JBXPYhBWKyUVu6F5BaDVwFzV7TxxwZe+cNT8y5ADAmuWa
         UJbC0m0cOXutbzDtF8ihFI4HqEnV6EVkXBJxDthm+62TC/+WQRN37RuCQxYMimaTA/XA
         zl4Z2DMfOigifwNnauHPDOkp9mce0MvMDvM6ixASZyqMfG60JqKkChNfTgAudvx3H13z
         8WpthAOCaMEgNfve87Da02uiJIGlEVM+GmfZIkOOpgq8h9HarzlcrGSqJ6fc1BVGqoNX
         q9YA==
X-Gm-Message-State: AOJu0YyjlVAMTMT4DDrjE/e7709uui59LBvr1S/lVq/MIq+afcG8FGQs
	IaB6+AUoG8pbAgOwneLmAx4b6D8KUfEgtaVYhKZKlpqSCdm36nb+gJ2I6nILTuj5LR40v3N1Un6
	V
X-Google-Smtp-Source: AGHT+IHaPLSg0Ev/ZSdIpUbUWbHaNkJ6JTZLUM4iwPObw+8IZlOhtW1krB38GHIs/kGG1VTFa2Aokw==
X-Received: by 2002:a05:6e02:198e:b0:39f:7318:c1c6 with SMTP id e9e14a558f8ab-3a074254b98mr355785ab.15.1725980313850;
        Tue, 10 Sep 2024 07:58:33 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a059016207sm20331295ab.74.2024.09.10.07.58.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 07:58:33 -0700 (PDT)
Message-ID: <7df73a76-d1f1-48f9-83b6-176380edafac@kernel.dk>
Date: Tue, 10 Sep 2024 08:58:32 -0600
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
Subject: [PATCH for-next] io_uring/rw: drop -EOPNOTSUPP check in
 __io_complete_rw_common()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A recent change ensured that the necessary -EOPNOTSUPP -> -EAGAIN
transformation happens inline on both the reader and writer side,
and hence there's no need to check for both of these anymore on
the completion handler side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index d85e2d41a992..56a69f0e5d23 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -467,8 +467,7 @@ static void io_req_io_end(struct io_kiocb *req)
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (unlikely(res != req->cqe.res)) {
-		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
-		    io_rw_should_reissue(req)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req)) {
 			/*
 			 * Reissue will start accounting again, finish the
 			 * current cycle.
-- 
Jens Axboe


