Return-Path: <io-uring+bounces-892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B4C879666
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 15:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC7F11F2237D
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 14:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2789677655;
	Tue, 12 Mar 2024 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lqQ2RJNv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8278667
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253975; cv=none; b=SAk8z48RJ5CgxX/ztZq1VmFSWJ4lj2nxR1Vnv8cYdHk1DrNbwAtsLJn0rZ6VT9ae55grzqKmT+uFS37LhwP5NGBAIVNrWhMzDkjy6nmJWJ07F3e6uP9xe8ZA55w3+hiax1ohhn+cLL7YIAdjEQ+Ah54Gm6gTXaR8mc30bKz2Alg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253975; c=relaxed/simple;
	bh=34obJHVzMGr5puoMPRCovsgnd9sXytAo9UyZFJXa5vg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=j4m7Z9rdA9leKqNBtOLQx0kqWD6IoXzMvo/NM49XN3tR92enX7hVczneapOjyc1JAbKM+SbXKT7qUFkafinae3qplCNxy7m4IBoeNpeg61jQ1KUrCw2Yc5qgEMNP5Q40RsqfXZj579M+sl6CDr5MjEt8X2kilFKoMb6Q2QUqRZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lqQ2RJNv; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-58962bf3f89so1675833a12.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 07:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710253970; x=1710858770; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nsy9s1ukCNvquyo8xteME61vHtGaw1Uc9M2HZx3LH4=;
        b=lqQ2RJNvpFUnvokwlJvQLdg+2yitRgw9Yf75PNbLMER4xc1Uyx2hUHuRmiFRWs/kmO
         CAYM1ko6y2SsZZxo9ZN5F0YHwgrABl9ba7sjv9STl4Jzcrkc73fZF67nwnGmy8Q6qnpv
         IysulaGPH8vMGBGNnQVDHP8vrDECR5OAqOOgYLqDTbADt1P8xdPWNvGPzeYaCf/mSjpU
         ku9v3NIXQanHmauUAjJZBIviyaAhG8MvKOLqiylgbNiEBIfzxLG4OJHhuYHYcsyVwY//
         m05IDj75okXzZMZyI2P9l/auxmhulIk5pHO8IDTFDuj8JczfyjddQ8j9Zz54WisTMoX8
         vn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710253970; x=1710858770;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8nsy9s1ukCNvquyo8xteME61vHtGaw1Uc9M2HZx3LH4=;
        b=IKkV7JgXrGbWc0BHvkA54+dksmya/uFYdG0Coch9kGRYaWP4lsPbOJSF6vSbFLvxUV
         fbFGFteiqqlX2RPovNK7smkaQEqosf/Gdfh3L7wWZapDeX3KCA3YTWH/82J9iSUCxWos
         Zzl2jMvPyfWCPwSGA3QU5p1ESPzOzmJcmfITiYKvIZDIfV1jhyHf8cYEhSHjc24+iqSn
         ZcZ4PUlBhCLJuk6KoSTf24N1an5Fi6tkePnP31R09nwEPTi7ibNRs+fVownCcZnSlkqZ
         bsouqlKN1b37dmymRaLcKAi4A8jv6Whw/CwEkiQC0IQFHbL6h4cAFuysb8NUBFQTCnDY
         I1yg==
X-Gm-Message-State: AOJu0Yy9gwPWkZR4u2IjOgDirmi9ehqWlj73YYyqVmIz3A5RMsrG6H0O
	6oWL/zDdECVHWW5xP5KgP0QnhKZDqGhzm2iiMoOhf2/jvtYwC2u5yZALOnv36qdNWLcjx5Z5v++
	/
X-Google-Smtp-Source: AGHT+IGRV2UbGJdNwcBe2DHjFlnnjKC6JYyaoOFkVhfuoLfdP3ISzDfbY1P/XWQKoBc6CEnHgktQ5g==
X-Received: by 2002:a17:90a:b017:b0:29b:780c:bc71 with SMTP id x23-20020a17090ab01700b0029b780cbc71mr8252175pjq.0.1710253969797;
        Tue, 12 Mar 2024 07:32:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21d6::1197? ([2620:10d:c090:400::5:d2d7])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902e54c00b001dbae7b85b1sm6693832plf.237.2024.03.12.07.32.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 07:32:49 -0700 (PDT)
Message-ID: <7225a4d1-a499-42e1-83a1-87223e83ba14@kernel.dk>
Date: Tue, 12 Mar 2024 08:32:47 -0600
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
Subject: [PATCH] io_uring/rw: return IOU_ISSUE_SKIP_COMPLETE for multishot
 retry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If read multishot is being invoked from the poll retry handler, then we
should return IOU_ISSUE_SKIP_COMPLETE rather than -EAGAIN. If not, then
a CQE will be posted with -EAGAIN rather than triggering the retry when
the file is flagged as readable again.

Cc: stable@vger.kernel.org
Reported-by: Sargun Dhillon <sargun@meta.com>
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 47e097ab5d7e..0585ebcc9773 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -947,6 +947,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		if (io_kbuf_recycle(req, issue_flags))
 			rw->len = 0;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_ISSUE_SKIP_COMPLETE;
 		return -EAGAIN;
 	}
 
-- 
Jens Axboe


