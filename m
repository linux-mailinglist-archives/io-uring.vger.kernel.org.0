Return-Path: <io-uring+bounces-9547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E31AB411E8
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1D91702699
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 01:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2415E1F5846;
	Wed,  3 Sep 2025 01:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0OIlR5gc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687591E7C03
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 01:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756862507; cv=none; b=qe6g0rliit/GjFa8tiarLO4Q6bH+6RA3YtOS7H6btipIgxxXytH5WmpLGhz9zz+GRd9neYzPdeUPbASocC5Iedl4I3ikZ9FB8efJMBxL+QYXIS6oEMtdNxmrt+sfu/r6hbp4wAxy59DeuixH4Oq+K+P4uqSCfPOUEzoOAgoj3Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756862507; c=relaxed/simple;
	bh=tSQUCTJc0B6mCqPpSe5HPg5FHEPKsayYzH9TbUKp4aQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XaPWdn1tztwqzVxQ1Jyzez0RIrksyA53eV62HuZO9Nja1W9CTMKnNLUKW72KZEUrFcACF48ewKaTJjMPg2eBGX+DDRnWyfeeTe4U3y9TlY6PO365KfXHmBaTTyDk0P0OKOxu3zSynl7UAOf+ivCZ7FcPdewDerwmKiQYycUHQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0OIlR5gc; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-88432e29adcso214540739f.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 18:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756862505; x=1757467305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4NIOVQpv6RIEBSqtyyz+LY0rABAsxUnVqFohJq2RFI=;
        b=0OIlR5gchJccOSdersS3RXgzcFbQdwMAMhIQ/40UOBPObQSL82gqeBNzsm8YXCi6LK
         sNRHkJljvYyoOeqDgbuy7Vh6mI7CimvwvASAfl9zFz8caVLxWaPcxpEo/mq1EugRxeih
         NZC0vnBL28EWvO6xEvcmCPh7FcsyTl2xTZQmLRnVEK4Q0ePoex2pQPZNCd5NUN3eNLk5
         0AEvyArcDN4Ih4zbn7qWR4XY/0DMI92XCpt9ItQI94J9LNRrJVs7/pPRVaDDUTvq0SGy
         qvde2ILqoBemRM2ii7a0ENCczI1m5TpfPk9ROM2pr3yYQIhfufpShARkl6fxYjbWjH6r
         vO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756862505; x=1757467305;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B4NIOVQpv6RIEBSqtyyz+LY0rABAsxUnVqFohJq2RFI=;
        b=UWqU82whrWeu24t5/Rq+WaosdZ2vY4Xd0jIxS6Oy/DQA0AZnrHy838wLEQZvVoG4gT
         t1VeHzYIN54OIJPW9C/pKnGlZi/DSByTlpp5OKN1BIVPCdcaga2abgKE0pr/+4+HYdB7
         9FIBRS9LDGiyhYKwCyHYp8gxFIFMYgg1QHJ2C58qutFLC91JZOM6FlDECfyxP4mfwwav
         nssntS8Rh/PhWsbu+crK7ZyMAWF/R/p05ml1pog75MXUA8zmoYXXRz9Ypx4vR6rKgB72
         ZVz8hgEf+w8v3k+KCtmjzRLePYOMIwZj33Hwpxo0oIvWtkDY7d0OUgQUtWUvPOMzeKAr
         tcog==
X-Gm-Message-State: AOJu0YxDpB3mklRtVNv6Ui8uS+BBQ0kxwHPP5RYdYa6shsZRe+L72/ym
	9Xg4AGPoGiuf2YtoEZHhSuCxdRD+K9d2Sehzs3zwVTFF8kHrPZSygc9ryGmX7nGkIUQ=
X-Gm-Gg: ASbGncv0tR8d7RKQ7eyEN1BfBkRdzgNTDPtV1RWpgHpbx6kzyx7KaKVs0cgaEMcW9D+
	5m4DadZcykMhg/HGjDJezsGmJUwqisFls52Q6XllpHHaJ/JbziSBJZ9dvIM5E2adY3iY0btnDAf
	57lqSvN5OLVZ9OIrR6y3EdrpwZvFlJhCBaUHMPjXbN/hPfTKDjPl+6xxT3Gz9K4zDjvfUYyuTdT
	gH7XSbPpovx7a93CASyxCWRVHNlthtMeHp59yS8/SEWwOtpQNV+Pam1p2UG+hPXdcjuBbCLhUoo
	kHB3CMgcaQMGJfOQue/XOICPK7CooW36mfC4VbRPpCAT/apI3ZIaLqj8vZp8XRBgESkDlc9hATT
	mk+BItKzj8W4ZbwaUzyTMPGBaVzsDHEUsvJI53+sjUnu6YoYPgfNXEA==
X-Google-Smtp-Source: AGHT+IFTHza/jI5g5VkO1QeePpLnsb6+uz+U51iDGQOHLDSSg+FLmw/SKGCOVw/bx2upSp6dOQxEow==
X-Received: by 2002:a05:6602:1614:b0:887:4a5:b9d7 with SMTP id ca18e2360f4ac-8871f41ea47mr2701292439f.4.1756862505498;
        Tue, 02 Sep 2025 18:21:45 -0700 (PDT)
Received: from [127.0.0.1] (syn-047-044-098-030.biz.spectrum.com. [47.44.98.30])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31cc0dsm3662537173.38.2025.09.02.18.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 18:21:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250902160657.1726828-1-csander@purestorage.com>
References: <20250902160657.1726828-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
Message-Id: <175686250399.108754.12103527747945353586.b4-ty@kernel.dk>
Date: Tue, 02 Sep 2025 19:21:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Tue, 02 Sep 2025 10:06:56 -0600, Caleb Sander Mateos wrote:
> Introduce a function pointer type alias io_uring_cmd_tw_t for the
> uring_cmd task work callback. This avoids repeating the signature in
> several places. Also name both arguments to the callback to clarify what
> they represent.
> 
> 

Applied, thanks!

[1/1] io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
      commit: df3a7762ee24ba6a33d4215244e329ca300f4819

Best regards,
-- 
Jens Axboe




