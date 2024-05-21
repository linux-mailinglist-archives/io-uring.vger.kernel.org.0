Return-Path: <io-uring+bounces-1942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC558CB37D
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 20:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F0011F21490
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 18:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DC236B0D;
	Tue, 21 May 2024 18:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FfAP5k8l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B50E21105
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716316187; cv=none; b=kzJ70WEv8pji915b4+b3HUsuHyFCiatxX0HBsAGoPzKWAn5dP0mhrMKiH6/JEgfmU1VPPlRXYEJLYFnQe9JTAED3SXXws83uopJlmAhxYzAm7brbvcBNqixnyHw0Ezt/Nya4yXD7RiLXMF38MqM+4WrTdnEXYEyfwMJHRm6oP+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716316187; c=relaxed/simple;
	bh=dgdXpkIhU+y9iHEBqZOvE4CDrXAha91+KB/GLyOImZA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=edJ2ZZ5BDstY13GRtEGFoWFVBwAArF67TvFgM8Jg3o9FZ4hFzSTWxj4M5KwL9yV0yw8drJ1+1uZqjjmHiFCzpU2eTBbRSrokQSijALKh3NKYuVlUXQaYPC9iuHK1LwDa0fiyhOJvsFTFtWyLOyw2ILuV3uEpaXO3IJ4EBzZ7ywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FfAP5k8l; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7e24aa659abso13624539f.3
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 11:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716316184; x=1716920984; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QiL8jPCVLJm4ChkHzmJn8WCo6IbWuNrnx20w9l78O+c=;
        b=FfAP5k8lwl2ggxGxPpJatKZlfTAlVEMETzNMQU/Ii3FF17uIwlNcwONJtDBlvfcQFW
         E0ulZ35r6OyZcgD7WLDqXNGGTrXtAhzEOKFA0KZDVACSg1OJB63+ILHKWvXGCVqp4rC6
         x+81BvHxcobhIwcdAcKYDoboj/Q8CfieEZqlELPbLXh6AL+qdRWRgWJy+lWB6F/rk1Wz
         fBt4SbugcmzMTb04ALUkkuZwriRmRMVZJliDcSE9DSEEO3L3zfqcjui8zu1yjuzWBL27
         hG2/pEjpBlD+KsJetldxUP662FqsJoa86elIObDp7bjIuAf5UagUpM9Asccb3InN9UvK
         Gu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716316184; x=1716920984;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QiL8jPCVLJm4ChkHzmJn8WCo6IbWuNrnx20w9l78O+c=;
        b=GJ5wJOltRLcqxcG1x2+DBtoZjvuNzYW1gv6dlMPAsjkXcbEUWQdY0v9XRe1ofjkChx
         SPu2Yxi/mxs2qwgoa+SZkFW+LfMV1lQmVi0/wMapD1N/jVuCnutduVGD4tLutLiKywgi
         FW5/dE9F7KIMnQTaHtDFHeGcRsMpfyxC85EXRKJ3Mta6QFkkH5jv9tv1Rd0acSDEHWRZ
         /4IyUOB/ZUtAe81WS9rUfx3pytB5vMi8+aPXrhfsSti/NETen/aLfiynH5wWenSRCHJg
         L2ZzJn0FZShZAvj37BN2VX0HTTeigOERcgIAGZUCPuccNtS6SWd8x1lHqf/Ab275XG88
         EVLA==
X-Forwarded-Encrypted: i=1; AJvYcCVZjFGUfyJXDUQd+UTp2/dk8dCy8C+jv3GD3G8bkERRrykvaRsxHJmfZzr3wuIe0alNESAdMe7nfFlLNrC3W9WtgZONFpr8opE=
X-Gm-Message-State: AOJu0Yx5BEpEQsaq1pjr+tAuu+Y4lOVWCdnIysUPNAztqYeITWpVpQYP
	YfHmnNK7stoYacnzCj1w2RM42BwH8e6miq+B7m++FBdtDqhyDLoBnF6Cu78gbgqZwqzJ9+GYzM8
	u
X-Google-Smtp-Source: AGHT+IFRYPG2Ng3/qufyEbP7kiQVtzyIgSegpCO0NthddraXsbj7qpouf4hoXqCV1QNRdJw05Qyr+A==
X-Received: by 2002:a6b:d203:0:b0:7de:e04b:42c3 with SMTP id ca18e2360f4ac-7e1b5022577mr3343650839f.0.1716316184314;
        Tue, 21 May 2024 11:29:44 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4af93f3555bsm213969173.98.2024.05.21.11.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 11:29:43 -0700 (PDT)
Message-ID: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Date: Tue, 21 May 2024 12:29:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
From: Jens Axboe <axboe@kernel.dk>
To: Christian Heusel <christian@heusel.eu>
Cc: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev,
 io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
Content-Language: en-US
In-Reply-To: <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 12:25 PM, Jens Axboe wrote:
> Outside of that, only other thing I can think of is that the final
> close would be punted to task_work by fput(), which means there's also
> a dependency on the task having run its kernel task_work before it's
> fully closed.

Yep I think that's it, the below should fix it.


diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 554c7212aa46..68a3e3290411 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -241,6 +241,8 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 			return count;
 		max_entries -= count;
 	}
+	if (task_work_pending(current))
+		task_work_run();
 
 	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
 	return count;

-- 
Jens Axboe


