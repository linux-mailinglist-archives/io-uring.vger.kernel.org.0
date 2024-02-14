Return-Path: <io-uring+bounces-602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C34854CAD
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 16:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5F27281516
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 15:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29CF5C8F5;
	Wed, 14 Feb 2024 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Kepo3blf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64325A0FB
	for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707924488; cv=none; b=Ex2hv8jZ9gAxpfnIJnTDCSlqXUbmYoZRszU2BwUBtCpEf3EiMnn5mRzsi+Fl8ueNoRYrROS9tSsMpojConph1I2Y17F2rC7XXSzFn2KXpfBmD6SlOL5zFgDShFZ2UA7OBdjlus2ls8NcGW4SNHwne0qibqdize1db0pHaYwxa2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707924488; c=relaxed/simple;
	bh=4Qn03WyiijgSqC7Xb55+zKxaz0DNBVrdvSnYUbCQ4+E=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=i3qZ2CYrxBunPY7jFeC42WWl7okufEko/LfRmQQXnqXCKlwmzCoPttXYtRbh5hFqErH/rXy2zaUKaVN8iL0VYj1jIJfzBoyu47C4dCQ80SVmqi/0iSbtjAF7fVNAUs32yeI4u/IOfHUAWXje4oGzOd9GJeNM0jcmiAa42ykS4sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Kepo3blf; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so58061339f.0
        for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 07:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707924484; x=1708529284; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wctp5s3wQ8vKZHezJS1boAMg9KatMgeHm08XDLWHNiU=;
        b=Kepo3blf1iwcf2ezblkg8FQsDXVu2FuXFdqxOrDNtqbeq2/nsVqD/U5QFOk9uFnkXd
         fvwM7NUn2trCAUC8wjQalDtvWXO1/XVwTU2YwmsdaXn6XpMym4zEb4wX8LuMm5NDZhgC
         vEhx07m6YO80NJOvbB4S0SFIV/os4kHIytZn+Ddr2WIf83ovDqFKdtaSuYMPJxe3BHYZ
         aC4BZ2ueiOWdyGbu4S9ES/hvPwdH8H+hCvZ55XeaaUbFeOxfb0YQHkf31Gwo65Z+emIa
         lFTQpVGIAz+n8jPLOz3aw6QkfWkX317FGuKUCjKYp+MK3GbQso5qw8e6UO0v/+amdP1K
         csEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707924484; x=1708529284;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wctp5s3wQ8vKZHezJS1boAMg9KatMgeHm08XDLWHNiU=;
        b=RpxDxc2aDs0C3X42zW4BJ3kCo7cpkI3NNLneN1fOHdZmp7j/9nkJM9HfMXNphyhppn
         aJuMMVKJ4kRHDZYCuGJojjva+6LlhN3c9FM8UTM8Ezac6keFczVHyptVw5MysLoDtapA
         rhjoxkVarAU0qvdvtMdYtpmtM66q/gP/aSicsxSD64qsCUh/967eqll5dDYSjoJQ8fLX
         hGar0Gl9ew7XllogBLswFlWEGAa6xP3n8ETR2gfhLcGKPvNGe6F13JSsQksuLznI0yZb
         z2KeXeTouU+gInsQDo8BrJepCsMqp0smUOIT+E0r1tyDvs/4bfMQ7p2NcG+Fp721gPkN
         kTZQ==
X-Gm-Message-State: AOJu0Yzo47qzujarfT3Vs+wtg63h2a8YGzPVA1MubpdZWqUzJLM7urEw
	MYFGvNSLqRIFh084VnTCU5knV41/jFaLrUYKliTfVOuiue7YTcf8i70rA3dXMLOs0zx8UaAWWmp
	W
X-Google-Smtp-Source: AGHT+IFK6mHqxDCyCWLLFTBBm4SPly2pszAQEWblkL20Um74iaYZxEZUw0Q+QdR/7gv95XG06AjWrw==
X-Received: by 2002:a6b:ec1a:0:b0:7c4:8398:ac64 with SMTP id c26-20020a6bec1a000000b007c48398ac64mr2006962ioh.1.1707924484041;
        Wed, 14 Feb 2024 07:28:04 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9-20020a056602044900b007c4853b4939sm356940iov.25.2024.02.14.07.28.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 07:28:03 -0800 (PST)
Message-ID: <d674f450-8090-4217-9ccc-41a4342e7ef8@kernel.dk>
Date: Wed, 14 Feb 2024 08:28:02 -0700
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
Subject: [PATCH] io_uring/net: fix multishot accept overflow handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If we hit CQ ring overflow when attempting to post a multishot accept
completion, we don't properly the result stashing or return code. This
results in losing the accepted fd value.

Handle this like we do for other multishot completions - assign the
result, and return IOU_STOP_MULTISHOT to cancel any further completions
from this request when overflow is hit. This preserves the result, as we
should, and tells the application that the request needs to be re-armed.

Cc: stable@vger.kernel.org
Fixes: 515e26961295 ("io_uring: revert "io_uring fix multishot accept ordering"")
Link: https://github.com/axboe/liburing/issues/1062
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 43bc9a5f96f9..161622029147 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1372,7 +1372,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 			 * has already been done
 			 */
 			if (issue_flags & IO_URING_F_MULTISHOT)
-				ret = IOU_ISSUE_SKIP_COMPLETE;
+				return IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
 		if (ret == -ERESTARTSYS)
@@ -1397,7 +1397,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 				ret, IORING_CQE_F_MORE))
 		goto retry;
 
-	return -ECANCELED;
+	io_req_set_res(req, ret, 0);
+	return IOU_STOP_MULTISHOT;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

-- 
Jens Axboe


