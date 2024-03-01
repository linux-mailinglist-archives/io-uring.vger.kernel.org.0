Return-Path: <io-uring+bounces-811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 774E786E456
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 16:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CE991F26AC9
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 15:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5D66FBB7;
	Fri,  1 Mar 2024 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iN+Gj8BL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CF76D528
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306999; cv=none; b=VYNTYONpwjQ74SWeC/uTknDDnCdqtWNF3wN7myVZl2ZzvBGJxhZ/chLtL9opjjfRSZ1N7e/lqpDoPRX/44zbSLErzvOru8MQMPVgmi2P5d8sb8goYoU/hT07fpOuvVtgoD08WBAHIyb7CeAzuRRqz09/nDLK16NadKPRdQtyIdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306999; c=relaxed/simple;
	bh=zh1tMmI9C8esm9t8S5ODtHnOIgNunq7h2YrtfEFvx/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=jau09z1RQL9UgFA52xxbzLADu2wb3PJgSSC8CLSO5yTKtqQ2L4/ItpueXhG/o4roaxIyXL5Yx1bfhPdWo7DEEsoui/yEzjnhD3psZkaEEJcAfUVyKtUX/GlDq+F8CDG5Z6++2PhOTp4cL+QHz+u7gUAwykoM5SXmRJhdsjQ/lZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iN+Gj8BL; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d204e102a9so22257601fa.0
        for <io-uring@vger.kernel.org>; Fri, 01 Mar 2024 07:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709306996; x=1709911796; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LwF1vEHHtNcLEL22JU7CbamIfjcY0v8w9f8KAiAGRpo=;
        b=iN+Gj8BLG7HaTyiBwK6YrhMrrIGiUH1KBbRM+WYLGIStLQUsdJiiDT8mAnZhyYDe0i
         c9M/sZSyJC3TxXEIAeRBVuAiHTKg6msl4k8SgObymvgGho+tdkul7JSAZm/ZYzpidVMj
         bFm3yJByorJR58EPp23wAxNsFc+DU7GFkuwsCqsUh+wbHJGPOINsql66cjrGOomlD5fw
         FSgwzISi1HG0hbsWJ2v+R2XowxCCzXND8GW3lWvgMt7eAH5bjqfc1XQXD0f37mVJpHIB
         1ktYZPekGQZubSeNJiS8/IESaCq6PCGWpPnL9Ib2y9V6zRIToV1fOpdDRSbUsDMLAjY/
         HVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709306996; x=1709911796;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LwF1vEHHtNcLEL22JU7CbamIfjcY0v8w9f8KAiAGRpo=;
        b=ujnYhz7FFdZDnM6z67OxA9sdfp7+9ODRxKkP30q9v7i42XDs7N9NEdBiP5RbLG/Ug/
         elI4xoyTqF7pLVuMEIYY5XBlTXM/xPW0m/W+vmf+rKe0Xshx/y3PMhBvRcsxxnUISx+x
         kkMCYxqFwm9Vs92lTNC9bo5qDw3wcH1jlrw62x/dujrddydIZeZOGIiFCG/FBFBBaOxa
         8KEsiu+Juw+X0SvIf72YJWXY8liA1sK5L48JjLQMxLcg8Y6i4/snfi8Q3/z6Ma8k9Uk/
         T6tcz5/fJbnnbgHM+lb9LswyqyYj9Bvfb4+TRHUVt0PlmuAJKtaqGNIv7+5XBVfSYcBW
         QH3A==
X-Forwarded-Encrypted: i=1; AJvYcCXskKwIQhrxwtaY4M4pejzozD95z/fXYIsERNWp5dOhkqI5Eu0JRJGDY6IBBZBJYGKPdZKrybQIXr+rgGfEf2J9zZPn3yc9Uwo=
X-Gm-Message-State: AOJu0YxA+5fS4LE3SfRhOVV0CWD9icgfC+LVTrot9acUCLDvrkr4WLsM
	8X/JGhIVXzSOrpdDhL5rJM2hrUdv1fh/Y5Zgh8yARUCmCQGznREXQtipnuvlniI=
X-Google-Smtp-Source: AGHT+IF+EdHbA/WMtHbEnW0MVWTX37KjpNSG/+lUHF/XBnrsQVeoc3UrADapsOV5vobHj+kpeNESiw==
X-Received: by 2002:a2e:2404:0:b0:2d2:935a:7a3d with SMTP id k4-20020a2e2404000000b002d2935a7a3dmr1312182ljk.34.1709306996297;
        Fri, 01 Mar 2024 07:29:56 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id g8-20020a05600c310800b00412b0ef22basm5835531wmo.10.2024.03.01.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 07:29:56 -0800 (PST)
Date: Fri, 1 Mar 2024 18:29:52 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] io_uring/net: remove unnecessary check
Message-ID: <3d17a814-2300-4902-8b2c-2a73c0e9bfc4@moroto.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f5d7887-f76e-4e68-98c2-894bfedbf292@moroto.mountain>
X-Mailer: git-send-email haha only kidding

"namelen" is type size_t so it can't be negative.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 io_uring/net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index da257bf429d5..04a7426c80d2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -557,8 +557,6 @@ static int io_recvmsg_mshot_prep(struct io_kiocb *req,
 			  (REQ_F_APOLL_MULTISHOT|REQ_F_BUFFER_SELECT)) {
 		int hdr;
 
-		if (unlikely(namelen < 0))
-			return -EOVERFLOW;
 		if (check_add_overflow(sizeof(struct io_uring_recvmsg_out),
 					namelen, &hdr))
 			return -EOVERFLOW;
-- 
2.43.0


