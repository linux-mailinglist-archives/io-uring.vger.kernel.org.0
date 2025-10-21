Return-Path: <io-uring+bounces-10084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C7BBF808E
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 20:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EFD8D3573E7
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 18:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839463502A2;
	Tue, 21 Oct 2025 18:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="upxYl89n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EB03451DF
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761070926; cv=none; b=XPGiipvvQhegP9aEMCNLmauo4ZFxXI/aQlaPom4i50oo68qyYgRBiazlXNdTDxTMZ4aBCFtybAKO+s1SI6KGTE/anHc7XJiPXmFsTNaLo4LSEHMEUTmeVDQAFbPPMw8btkpF03yTnjjKGTLg4CvYaEPqicnwR8MFhVFh3/FCPu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761070926; c=relaxed/simple;
	bh=79ji3lRxCDVH2zpvzp7RBs9o8422wf8mQPe676ijU8Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lZrLGlhOzluQ1uf8AabxB7AsTDfrnp5dZKLZNbsC+jJ27lnrFL51SipI+VGWjIgyldHlFTsZDcR5IxSdsmcr6Q7vyzQ+qSh42bJlOV3uOGqQukBKTtKy7xg//uAiRR6fmM1AzU9rTb593/Q9kKDkHN9uHAaRwUnTDBJkEnDnJTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=upxYl89n; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-424da17e309so62459615ab.2
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 11:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761070922; x=1761675722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hwb5AIrReUvMBmNj6v22zzS4g0svF5NEcsjcLOGLDJE=;
        b=upxYl89nX7S3ZT4RtV1vgms/KWj5gS2hsHQGpfQLkxcw6RWrCZXdGv1AyzITSsffGz
         wao/gn9BaDEVK1gb4SN96e7y24ndTldRbTUYtf7nnqBn/BbLLG2Qs8yft83dA8pl+0d8
         IUTSycmJytvCwyaqO6BRSzRD/p9r0fByBJec9B27Dp2pWE0ZOF7+akUTgUs3OnIIxhO0
         3vBCzalSH6iOEtW0MIywa/Nih5hg5j+oqQb+Et4/bGJv3KUlYq6tABwyv41mdf0/Ukg7
         BAQbtxGDTt5pWxtOElzX+jClNHSwsZbU5D86FUAwWqZCiBRb1/Ptz2rtAt2OJ5OPWj8H
         Toyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761070922; x=1761675722;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hwb5AIrReUvMBmNj6v22zzS4g0svF5NEcsjcLOGLDJE=;
        b=GsHfRxPupgPGAtx8z8PoqjfFp0sn8yeKINVifQhrU/LGVXBCtXj3RmsyfA+Ppz6Cjy
         UY9UwoHzyDqYA+FMXDUKxc/E3TkT73MtvA1ojaKoAqhAmv4VYUoI+M7lPhVaGDvCrx3W
         wv0HFrMdzqZn7oCKGkrLvwPYPwBrJRMBxWKBBk7dCM4ukPCrOiw1wAObp3sTvhD+Bh4R
         9sqSC6MOhQ3bMce6wEUQCP270cvcpBSKDHMQUwedvHpEe+G1GijP36Oc7hgDLAN0eFuc
         or29cSsgX4QIkvBqcHwusI2eN22PnIHdxSnIPCWswwh2xuHhXQgMsIYr75SJ1L8wn9sF
         MqXg==
X-Gm-Message-State: AOJu0Yx6mKTWJg6eKypbs9cgLmoX/GEhG9yTNZMsWdUcR5LvfoSYyMv0
	P0Da7wGvCWn5BxKX/vwma6f7DTJkS3q0ENfEistXQ8P9ZejFg4ZoQ5AGF6bl0qK2IFk3UvqOiZE
	JtNzSycg=
X-Gm-Gg: ASbGncuQ+auPrsTIvPUk9j0MSxAxx51RMEWJfTgxJmENf83KZvNzTDW9YQXQ40e21Fe
	LkFR0PSEIS9GrK2lTsjn3zeS0QIMIl8FBqEWDzkU69biHHj+/4D0jukZHE9C/o6A8HMpKuD6Zm7
	4YiDP+y7F2gOX3XXoN/C69qK09ewgUIzBkVPXl3niCVJZmhjYtmGIsGGnfSqizLLzYFtv8ZDnY4
	+fo4V47LPkRmObVUv98idbxqTD0s1+k1JJfVkECGRP0jUUo7knzkZFW4nDpO742jzKpTXyPbre0
	2LYlvMjsEGU+SrVh1txMJwJ2y1LWffZcSs03r3+6Xrnbo476nRqBmIkv9A4fpRea3+zW9bB3ZzC
	IPbr871sM6hCJqpDByymYhp0bSo3n4uzr6InsyJMC8kWoqeU5OT6ilSM5cWANmHH5czKTtJStE5
	y51w==
X-Google-Smtp-Source: AGHT+IFgvS4Hrtx9ZCCqnSX34c4rLtA7kZh40GCk23wzu2Dl6Bq3N1MD4Xw6Te/SetuH8H3DDeCNtg==
X-Received: by 2002:a05:6e02:1c01:b0:430:a14f:314c with SMTP id e9e14a558f8ab-430c5205699mr254831015ab.7.1761070921883;
        Tue, 21 Oct 2025 11:22:01 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9630a45sm4346361173.20.2025.10.21.11.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 11:22:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ranganath V N <vnranganath.20@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251021-fix_indentation-v1-1-efe8157bd862@gmail.com>
References: <20251021-fix_indentation-v1-1-efe8157bd862@gmail.com>
Subject: Re: [PATCH] io_uring: Fix code indentation error
Message-Id: <176107092101.199360.7637020500608445837.b4-ty@kernel.dk>
Date: Tue, 21 Oct 2025 12:22:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 21 Oct 2025 22:59:30 +0530, Ranganath V N wrote:
> Fix the indentation to ensure consistent code style and improve
> readability and to fix the errors:
> ERROR: code indent should use tabs where possible
> +               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);$
> 
> ERROR: code indent should use tabs where possible
> +^I^I^I           struct io_big_cqe *big_cqe)$
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix code indentation error
      commit: ea3ba56a6f0b66d3e6cc01692d5a83a6d96797bf

Best regards,
-- 
Jens Axboe




