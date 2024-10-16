Return-Path: <io-uring+bounces-3735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 199E29A0B11
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 15:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D40B2281775
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 13:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8506208228;
	Wed, 16 Oct 2024 13:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xcv1P7Aq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EED12E75
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729084321; cv=none; b=T2cCXTBLRcrrVRoLjS2AjXTwpfFg/+xHjX5QkcpF3dhADbhQ3CMq14BinR2lFNOPTw62xKRpa+U4E50B54wno50lwt/+GQruTrkMWnhxSBPAw5vWgCEaCmTSA3A6rAyQffwnHojnTKXJLBGS0nCv2+fs9jDo3x62N2mZG+4eYwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729084321; c=relaxed/simple;
	bh=Xlv5Yre4SIScRY7EReEeySGJaZlHaEoZR4Y4bo8LhDc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=RvoK5Hdmad+mLzLhz1QbRyf2tGnkjPvDoQlZ+NoEg5gpTrEuObBUljx6YqAMM8dLikbROsv4f0KcezY/NbDAu8oRHV3LP6EMJ+GEcGavtSieodTewqumn/aoBCILugb9emrvdcIhdBvQVl3HNYyjHhDwvXtSQdlsqRxh46bYRWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xcv1P7Aq; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83a98e107feso35425739f.3
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 06:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729084318; x=1729689118; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vZWw1B3Ha3iaftJQpdu5aX/kd8uQkdjVbaL2kP/g9o=;
        b=Xcv1P7AqpCp51/JZ7ImAk8K7gOdq/NLNXQtp2ZjVsb2pjsFhDR4NoQmH+cnEGF6VAJ
         E1a0W/JnGrW1xp70z7o31SD8Vm4y44bITrbdJjiy9d8xGsRP+0lWXXrjdvvzZCwDaPiB
         pggAhGDHjD+0Y/5dLC1RS1jLtxgIoIG4mtNSEJZ87q6fNXI+yUhm429NmA6xG10s58m8
         i1qkMyEINAuiiZ253UJ152FuxdwI4z59HMkZhAfg8FMzZpCWgnQa0vKQVPcXl9xlnAWC
         D9VPT/4ktNKtEZQ4B2eKnXsmKlo+cH66ILnyMIXOIFsGsKEvBGZdmBnxqwNGRjF+4GPf
         zJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729084318; x=1729689118;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8vZWw1B3Ha3iaftJQpdu5aX/kd8uQkdjVbaL2kP/g9o=;
        b=rEirQp7+3HaEhcSzYGlRD1lVltNc8ZxNxr3fakYt+wpbbwWD5CjDN/BfhHZayl0Jtq
         eKqE+ZZkTdH0vfuk60xbVETvPJrA29HgzS3WHW/3FmACKyFvZtBZkH+Ljl7T8B0vsnFz
         htBUfbxwNtNzj4e99P68ZiGh/mTMRrDd+0uspkHT71KTceTgLYth08wCwg2tw73i4gja
         te3hIKrYtqy9QgXN6KYscvqCbW9e6zma5EmMHJU1FRvMHrzBlj5+fyuC24SYaPGh66fp
         +ixUWhlYObU7XEjmuY/rbCC0jYSmm0Lai6FoCbw0HMtQ8LLzDzJHh2qzQRkLMnkJ7Hfw
         V7pQ==
X-Gm-Message-State: AOJu0YzVS65OlrPBdxToXWYaziAcnFaudnM9xswiztaVJvBKJnDM+5yO
	qmIkTO4LJer/cEHgYiwiPgkUTRIHMMn4uPLJ/2QLWTmZff8ZO9IZwTI1mgA9S7R4LgOsYAisiPv
	9
X-Google-Smtp-Source: AGHT+IFV10KicPiZugTG64Y5AnJpwa5ycSTj3swru5O/Z/1fm3o7u50Tpxo+01NLXKsQytwidsYfpQ==
X-Received: by 2002:a05:6602:3c8:b0:832:480d:6fe1 with SMTP id ca18e2360f4ac-83a942f964dmr431981239f.0.1729084317807;
        Wed, 16 Oct 2024 06:11:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83aace97469sm810039f.2.2024.10.16.06.11.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 06:11:57 -0700 (PDT)
Message-ID: <45120dbb-beee-4718-a8b8-ef5755909c0a@kernel.dk>
Date: Wed, 16 Oct 2024 07:11:56 -0600
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
Subject: [PATCH] io_uring/rsrc: ignore dummy_ubuf for buffer cloning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For placeholder buffers, &dummy_ubuf is assigned which is a static
value. When buffers are attempted cloned, don't attempt to grab a
reference to it, as we both don't need it and it'll actively fail as
dummy_ubuf doesn't have a valid reference count setup.

Link: https://lore.kernel.org/io-uring/Zw8dkUzsxQ5LgAJL@ly-workstation/
Reported-by: Lai, Yi <yi1.lai@linux.intel.com>
Fixes: 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS method")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 33a3d156a85b..6f3b6de230bd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1176,7 +1176,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	for (i = 0; i < nbufs; i++) {
 		struct io_mapped_ubuf *src = src_ctx->user_bufs[i];
 
-		refcount_inc(&src->refs);
+		if (src != &dummy_ubuf)
+			refcount_inc(&src->refs);
 		user_bufs[i] = src;
 	}
 
-- 
Jens Axboe


