Return-Path: <io-uring+bounces-2404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C5091E407
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 17:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1771F210DA
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 15:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A412158D7F;
	Mon,  1 Jul 2024 15:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xfmZKcms"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DDC53AC
	for <io-uring@vger.kernel.org>; Mon,  1 Jul 2024 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719847557; cv=none; b=gzXA6pPvqmHSOX2i+/bqAkf8s8cOgAVCEl+4pvNQaxESPAL/w7lsp58xbIonnTevmYIzdYkGY2Xt3VaQX2l/fTbUyzSGK+NElYfK4RK4QausFaU50gRsavIRY7MTGtDa5CJIMZx+UWoR6gl+DbkRCNqj3pGnGWBuAns2n1LX9iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719847557; c=relaxed/simple;
	bh=hlbSg7yBQL4EdljYBSd6/2FVQJY8L21wDb9f++LCO3M=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nj/3ZajWJaSjrG7IpHwW3lpA8njwp368xsQzpo9SEvCL+84MUnvHc90eWOS3Hq8c1SeTLjKfXd3uP7Xlcqz6JFEHJg/8c6PUB83qj0VuuTGddbMC+eWMhUSMDy5aypJWglrtwtsVLqjH0AOMYj3/8KQgesRZHzl53no25pB3PbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xfmZKcms; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3d565b869d9so148760b6e.0
        for <io-uring@vger.kernel.org>; Mon, 01 Jul 2024 08:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719847553; x=1720452353; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUZ2bbs2uEK/ryxRLMgQ0EUuWpQEptPtkN45AyD9Tps=;
        b=xfmZKcmsv/8X6y7ZZwJz48rEtnKm6HSRvmYPqGXgXc30Z1EyKuTCD8NKuFLQTUN/qr
         E1TuP2BhsIKJk2miScLK0bQ4P/Ka5v5UJlafwNbXaFM8m7K1AyG/13FgiLQcboq8SrPf
         U1iknkM/MEqs1t710JkM4fCUmVDu/SoerIOt8ZT13wNB0PuiUXgpxSp7eIS13zCSXsOO
         LqcRRMjt36uuzGKdqX00OKvuGBs8n+lJXz4EXt2vCtwXfEiDMc7pnmBalCFgmdQsF4Le
         zGWInYHzS5VOu8n70dQ1eRrL2GOZj+n/PgxAKyPQHTDu3x6UYskPZTB7Tj0BhFE+PqZH
         JSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719847553; x=1720452353;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dUZ2bbs2uEK/ryxRLMgQ0EUuWpQEptPtkN45AyD9Tps=;
        b=T+q+zcmkiNXTWjgBBVMlbGPKB980KgRw9EZvoFCdpkw7QpeS8PD6Ypa4Fo58VQewkh
         ZCyhaWv677cGCkG/1e7iqQV4w0QteFGqiBNPI+yV/XEzKKEM3hmULPkmWP3+LnRnkxbm
         ntXo7iU6Jrk3Yf4p1zvmhZmTthWzvbeh7Pybk9mnGHR4EqNzsNgwx2KzaJUnHN9XYxpV
         wxh+pXAXu7+lBNKQmpuMoXJoN81rssI2KTGzz6Qyk5hEMRP04mBL2kVfbeB+LyDxFPd0
         R5XHzTJ4h3grbR6ip6qiWU+oF94lVbzM0a7DPlLhi5ePKQH/0teG5eX2ckeYo5E2XIbu
         qhRA==
X-Gm-Message-State: AOJu0YyFETJL63juD3rf18ZYRI+DV/IoRRWUUb/9rsxl3B4u8F5SwEry
	A9hzCj48RcrL5rL4S3SfDl3BX6/TijWBmFAjpH9HOZSGz8T0x14yV/244aAn5+pbkpc3AdAu4Ua
	If8E=
X-Google-Smtp-Source: AGHT+IGAwLVt06a0AIZr58Qg/xVLoIUmp6rWraLymp8GWQGE7OjYH7mUePSfq+XK9QiU4YpS+MHDyQ==
X-Received: by 2002:a05:6808:2209:b0:3d5:6338:49de with SMTP id 5614622812f47-3d6b5e3dd4cmr6958986b6e.5.1719847553168;
        Mon, 01 Jul 2024 08:25:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d62f9c7e16sm1396774b6e.19.2024.07.01.08.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 08:25:52 -0700 (PDT)
Message-ID: <717788e2-a124-4f95-ad7a-bc4e0dc264d5@kernel.dk>
Date: Mon, 1 Jul 2024 09:25:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] MAINTAINERS: change Pavel Begunkov from io_uring reviewer to
 maintainer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This more accurately describes Pavel's role for the project, so let's
make the change to reflect that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/MAINTAINERS b/MAINTAINERS
index cf9c9221c388..ad96b9bd68ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11570,7 +11570,7 @@ F:	include/linux/iosys-map.h
 
 IO_URING
 M:	Jens Axboe <axboe@kernel.dk>
-R:	Pavel Begunkov <asml.silence@gmail.com>
+M:	Pavel Begunkov <asml.silence@gmail.com>
 L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block

-- 
Jens Axboe


