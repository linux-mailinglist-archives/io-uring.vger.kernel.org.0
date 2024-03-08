Return-Path: <io-uring+bounces-862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EAA0875B9C
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 01:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19D01282508
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 00:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A4120B35;
	Fri,  8 Mar 2024 00:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EKOn9F+h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5DE1D6AA
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 00:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709859104; cv=none; b=kJip3vBxDfoq8bhEPIXglPxW11DVg+2jZIXK+HDud64VcXjxFeV9iJXa+ug+qrImereAACxC1V1oL+U+OsNOrsjsuy30iDKt77KfActhqn2FVs32sXOddxLWgnW4PtIcxXuRYM35PClNrBLMpfcwe2/26PLQdNdN3b48z+x2NdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709859104; c=relaxed/simple;
	bh=xnIDWTDj5eax90X+686DrUTiXuUSmtNqk7HajlK4jB0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=i/QHSWGMmBYR7NURb6fqy6d9Cfmd3YmnV0x15H3M5ui+adVMjG6ac5homTATgT/eXm9T8Di903m+LKGrkSDE/Pr5JpYrrY0aJgcIKaIfkyAYRHrj5N20JHKedhHR/zZDZGxUcRNGr3tK9MQ00BtD9XxiHrLNmpDID+QsKlv7tgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EKOn9F+h; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso586063a12.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 16:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709859099; x=1710463899; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNiQkzsQ4nEPMRDe1KDElfGZ8q5KwJJ8I+ODow9f3/w=;
        b=EKOn9F+hdxKhCQW2L6FeBIDRipHCDCKi+JIa/DHE7hqSwpZ/27ZAqPWvLK514qzhW4
         TTHk3k0AnW40YL19E1gOqyPB07DvIA5bz8WkCzplhcf1LPUuGFIFoKm3Vx+Tded+teDu
         7Uc++hWX5at7eV46u/AzRDcYqGl94CZ9n6R4mCKLFPUtwWHkU4hNr5wlDRWdc2KO5lyz
         JAAl9grwo0FdDTgMDyN3j8zUoDCzWqcf3ro7lptEUvLvZX2yv/20pdGrXn25ZtGMzFNo
         9VX0I2g4RM6PgLsCRlexh9leKZw8AWvORnLJke0b4kZnxoEF37h1mrW2IxAa13P+109M
         84bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709859099; x=1710463899;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wNiQkzsQ4nEPMRDe1KDElfGZ8q5KwJJ8I+ODow9f3/w=;
        b=LX6rT/TcxZFDPXobkd/ugJgY09wIya3SqPTWDJXgjTZtc/aGK4DY1wzXjY4jFfMHac
         0zpvlrG50iuCElzvknZHTHaPjuLv810nVckzbsIJ5Aht4pFXPGBeCLWlnTdt39I4LW57
         b9RKhY8oCm+Kdifb4f8n3nSD+cnd00absugRqZN4iFkCPbkQnO8hQFCBvKBTTmbzKtqE
         /Y2uEQ5eXn8o9PLzWurLjjGeedMFozjP0bwg32tVpL1B/VezQWb/22M1IIxtkiqy/t+d
         Znpy0dS8nQ6bAaVxe66SH/XD3I1PmR9cVDiCIs+6z0uhtxlatoOEuZhX4gbbTKdxMyH/
         cnOg==
X-Gm-Message-State: AOJu0YyA8sGIRLvNUcahRhmdRZaz6r+0JOV2vkfwhv8lvnRZE3L/sTLo
	1XYMyeyqe+nvOIWe6h0eO4NRuxE53Q462KQ21QZTtSHI68YsxBSp5QGVu+RIrWPSdN4GMgyT+Qd
	q
X-Google-Smtp-Source: AGHT+IEwwW06lnUuhXZrMY5RBMbJMJBV37wyooH4HWCrBIUEhl/ELyVe/TQdjw5fjUqLnOQDMU2r7A==
X-Received: by 2002:a05:6a00:2d93:b0:6e6:3b49:c4d with SMTP id fb19-20020a056a002d9300b006e63b490c4dmr771467pfb.2.1709859099391;
        Thu, 07 Mar 2024 16:51:39 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z24-20020a656658000000b005cfbf96c733sm11692618pgv.30.2024.03.07.16.51.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 16:51:38 -0800 (PST)
Message-ID: <0baadaaf-2f6b-40d7-b7ec-e0e175e3c4ed@kernel.dk>
Date: Thu, 7 Mar 2024 17:51:38 -0700
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
Subject: [PATCH] io_uring/net: correctly handle multishot recvmsg retry setup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If we loop for multishot receive on the initial attempt, and then abort
later on to wait for more, we miss a case where we should be copying the
io_async_msghdr from the stack to stable storage. This leads to the next
retry potentially failing, if the application had the msghdr on the
stack.

Cc: stable@vger.kernel.org
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index e50947e7cd57..52f0d3b735fd 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -931,7 +931,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kfree(kmsg->free_iov);
 		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-	}
+	} else if (ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	return ret;
 }

-- 
Jens Axboe


