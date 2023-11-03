Return-Path: <io-uring+bounces-21-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9234A7E0595
	for <lists+io-uring@lfdr.de>; Fri,  3 Nov 2023 16:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31F88B21224
	for <lists+io-uring@lfdr.de>; Fri,  3 Nov 2023 15:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E051BDF6;
	Fri,  3 Nov 2023 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b1xwr5aw"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683191BDE8
	for <io-uring@vger.kernel.org>; Fri,  3 Nov 2023 15:32:40 +0000 (UTC)
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B36112
	for <io-uring@vger.kernel.org>; Fri,  3 Nov 2023 08:32:38 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7a680e6a921so19267139f.1
        for <io-uring@vger.kernel.org>; Fri, 03 Nov 2023 08:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699025557; x=1699630357; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1Dn43ZhhQRT0DljABtrFHIjTRwlpbqzIexV/5slnmI=;
        b=b1xwr5awOZuvPZW5Jez2ndiP7zHg2NuQVMtMuCDrUovgNzZKpz3aTWvwTnHHXFDlcg
         MiAHmr6HYEEUUDJMj1lsLBsTNeup8hO0+FPWhX5Gw2uyov2/30+104FICFWCnfoCJUMg
         bIZYJ+NOZVUh2IQW8vulNQRKSLWbd8f1jCfrY7lE+AtsC2cjWLcg/FtHpKdONnDvki74
         CGAMY13Zc6grhbj4WOxNe2M5sOylYGuCN4NTNiZKDh90qRoUdXvNgvaVh7EBUw3Xn/Kz
         wI0wrT0ATGWh3F0LTvXi5jc10uppe5RYb2Myeu7jrrShDBZb3dO6lQhL4jB4ELGUpate
         gT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699025557; x=1699630357;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d1Dn43ZhhQRT0DljABtrFHIjTRwlpbqzIexV/5slnmI=;
        b=MivH5Tj8IWfbUdw6CwjAUH44o7a2yT5ggcr99a/2w9dKLH+1gBSJHyZDBsUOGdy0DY
         36v3/PmNFkqxoOeaS9ayVBE9xdCIQfRMaeYvjzw6fL9YkSudjq36hCieWEOgyFJWrEzl
         bHL93srEhVEJu38wlnsAaeV8x9RnyN6ntyNxd5yG8gZ5bueusLYIlfuWVCa2nqVqPDop
         51/di9AYMegUM+d0lyhqFG/a+9I65KXOE0KQ04SM+/FFPa2+MgbcJmviTL/CnttzkDR5
         F1Q77snzTO4wMaD+fE11oxlCTV0UL2IZFaKZ5C5r50orqj7BmokVSvccCTZ3AancEGBY
         nDQA==
X-Gm-Message-State: AOJu0YwMtZ70XBQEB56X55xnp5swHB7qqJMfchkw1ojcUvEZhdIlMAc+
	V0/ce4ErBrkC2Vf2O+vCyeKrvBSbASpD6Scip46fxQ==
X-Google-Smtp-Source: AGHT+IE5MGoCD/L3gO6Z1O3RUPHiyDe1YRzroJcx6LdZb5S0G7QgVAqVh7pmcwZ2ivIDjiY28rM3wQ==
X-Received: by 2002:a6b:5c10:0:b0:790:958e:a667 with SMTP id z16-20020a6b5c10000000b00790958ea667mr22170106ioh.2.1699025556686;
        Fri, 03 Nov 2023 08:32:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b6-20020a02c986000000b00430996b3604sm555096jap.125.2023.11.03.08.32.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 08:32:36 -0700 (PDT)
Message-ID: <92ae2dcd-3b6f-4c7f-b12c-f50a4a9fd538@kernel.dk>
Date: Fri, 3 Nov 2023 09:32:35 -0600
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
Subject: [PATCH] io_uring/rw: don't attempt to allocate async data if opcode
 doesn't need it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The new read multishot method doesn't need to allocate async data ever,
as it doesn't do vectored IO and it must only be used with provided
buffers. While it doesn't have ->prep_async() set, it also sets
->async_size to 0, which is different from any other read/write type we
otherwise support.

If it's used on a file type that isn't pollable, we do try and allocate
this async data, and then try and use that data. But since we passed in
a size of 0 for the data, we get a NULL back on data allocation. We then
proceed to dereference that to copy state, and that obviously won't end
well.

Add a check in io_setup_async_rw() for this condition, and avoid copying
state. Also add a check for whether or not buffer selection is specified
in prep while at it.

Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218101
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3398e1d944c2..1c76de483ef6 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -131,6 +131,10 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	int ret;
 
+	/* must be used with provided buffers */
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return -EINVAL;
+
 	ret = io_prep_rw(req, sqe);
 	if (unlikely(ret))
 		return ret;
@@ -542,6 +546,9 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 {
 	if (!force && !io_cold_defs[req->opcode].prep_async)
 		return 0;
+	/* opcode type doesn't need async data */
+	if (!io_cold_defs[req->opcode].async_size)
+		return 0;
 	if (!req_has_async_data(req)) {
 		struct io_async_rw *iorw;
 
-- 
Jens Axboe


