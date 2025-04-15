Return-Path: <io-uring+bounces-7463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41978A89FB6
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 15:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4632444D3B
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 13:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1081315381A;
	Tue, 15 Apr 2025 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PAOEUxjV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA3514B08C
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744724338; cv=none; b=o7bVU+YG6/j9uFHs5UBSSA0FK5GykUXN9BDdmGfG87g+OG/4Q0fCPAP+t2gHIqEqoX/ZNaPS9XbgzFCIzloT8w8cGmM58kwPENMiZIml7VFxknrxd45KW7KelGgzMHRnOAswQom6z57S4iF9qf6sOOpWs3BjAZpSXOAt+lzqzfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744724338; c=relaxed/simple;
	bh=5HnGCc+mZwxQiFyPtEXEYnqEnoEQeS2x0bjv8tfgAu4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WrUa09lxwz7iOrmoXHooNcOk4kfVQWIezY6EdrfG3iS6MISfULgBKlT/iCPVDMrwRPAobAzaKJI5BOzP05YY9pCFcVCzr4bQcfRbaiNn/MRI4Naw4t6P///uEnK7mHlwADM1FRjWBADYSZMPgui7kYG9G8OqWmh8mBsqVz8/WRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PAOEUxjV; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d589227978so17559625ab.1
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 06:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744724335; x=1745329135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tRs7fFnTXfFQ+v8cn2I1tHHgXAtIpwGSvh9cFVMsRFA=;
        b=PAOEUxjVZB1ZpSsbCouASbPv7ajBxfqyn1lCfH4DYSEMOj+pHO7MALLOBpTLohf2pY
         2avPVc8rUr0HBZ2873KWRHNZCFI6MYQvKyTC2CRm6jx3hRvJXxV66FvMf+up8+KR3XZM
         fJQ4YTs9lytiUJ9HdJSuryAyrfObP81c0124fqAimxYRN6x9ubch4Ul3qCm7eJ5/ONIY
         eqledX8BiraUNG6dLsXl7qgldeFvpOQsG1iV4D8YX2RT5ySYvuKwxGlZV/LXp2NLALcL
         Xyq/Dpdc57EgPkeFRXWLUkFUGqbSvVeAc0XNyhTGcxQnXNMm7QnFqV2a50g/IJD1noSA
         54UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744724335; x=1745329135;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRs7fFnTXfFQ+v8cn2I1tHHgXAtIpwGSvh9cFVMsRFA=;
        b=vfQCcCewne0jLio4DvUWyVPbVPaUIoO54c//pBCPO1pG0SAKjenTdmXDu0Nx3Ge5Nl
         +x4ZKglIEVN/OEyaUWn+nX6H88UdYcIa6PU9NzYFyBLlNGmdaJSL2byhabs20nPoitH1
         P+lDIAjfCSFWp12uhDYH/SAW5q+WLOxIEcWvLJkStD1NHYBCFvOTnyRD+nZSBL0nMEsZ
         U6jEhGQm4rWNVE5n8mjP4S76r4T4iSuhRovvi+XPLVUM27L9QWZZ2YeXKTMr5CCjo10r
         izvPVADuwzwfdzUKYxf6HyqM9J8cXml4jPV4lXcYLPlT+2VnkT+qpFiwyLO/czMAII36
         qZ7g==
X-Gm-Message-State: AOJu0YwtbL1dSk4j9twanWIo/bjVrfLuJFG6JBOjaAxIzwE+8MuRjH7u
	i9WlfqKD7dU/Ek05CgLok5np1Yz9hR8fet1xmaYwP+iyuUrPn6BvukDSyD5O9nlnCZBsWiiUUnv
	h
X-Gm-Gg: ASbGncuLQzrjA04cm1SlV1DPmdx/E/WdVwwWN40JVRyCW7jAWYTSzx6JZOPbYg4wh2A
	EIQaS/1CtnmPASYM3gn5MS3I20VKVIWWl8wiMR3a+xd60iiDTHqwDibRVZ0nq+fexWL1tmdGDqq
	Lou6r4nZbOeaIjAaLopSbm1qUtmO8Q4efztAtv5CwxNZ6fHedxxT3cE6AJCn1AxXVfk4YpN0Eb3
	A2oGKik6UcMtEtUy8zq7dO/ie51MsMMzfcSF99xR+i9bn75rijc9IlN/eYIp7K7usSSl5R+HMkE
	NuS08WdRcjYiKOTHebQGd10gWhFvscld
X-Google-Smtp-Source: AGHT+IFldX3SqpvfGnTcReUm3t4ryY4r30kQK/JlGZhswHqcxgb+g814Bo+HcKwGIY8kwrVYLUHsCQ==
X-Received: by 2002:a05:6e02:2285:b0:3d6:cb49:1e5f with SMTP id e9e14a558f8ab-3d809c31224mr34336465ab.2.1744724335193;
        Tue, 15 Apr 2025 06:38:55 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm3170439173.126.2025.04.15.06.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 06:38:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3522eb8fa9b4e21bcf32e7e9ae656c616b282210.1744722526.git.asml.silence@gmail.com>
References: <3522eb8fa9b4e21bcf32e7e9ae656c616b282210.1744722526.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: add pp to ifq conversion helper
Message-Id: <174472433454.141496.1287477602004861988.b4-ty@kernel.dk>
Date: Tue, 15 Apr 2025 07:38:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 15 Apr 2025 14:10:16 +0100, Pavel Begunkov wrote:
> It'll likely to change how page pools store memory providers, so in
> preparation to that keep accesses in one place in io_uring by
> introducing a helper.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: add pp to ifq conversion helper
      commit: 70e4f9bfc13c9abcc97eb9f2feee51cc925524c8

Best regards,
-- 
Jens Axboe




