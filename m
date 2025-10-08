Return-Path: <io-uring+bounces-9931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F96BC6255
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 19:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC5C91896271
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 17:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDD82BDC1B;
	Wed,  8 Oct 2025 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ui4fiZw/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991DD1F462D
	for <io-uring@vger.kernel.org>; Wed,  8 Oct 2025 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759944728; cv=none; b=XQ9KkgV32cuW8V8OYfW7tHVBn7ZlNtoIPXE20m8HIeKk6N0kNPUofMUsREmHEOLbQBvqG4TIAdk614x5jG7UrnUu+h/3rBtXFOSOeNS3wqV2JrsHpCsDsji8ov+eubBFvhngzOqwIr+WxO/d8YoWqOn742q+SKlMUMOKL4ovAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759944728; c=relaxed/simple;
	bh=R6F57YDITyqieFRSeJYftHE+oqSvEakx9pph8j301Tc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KjPzN4V15FMRlkQI2JgmKWcVMKtJVnJ4JGzNtT0O7IR3UPYXI0PLRjZxfnEKc9mSG2H/dbbujEPX+stP1dGerH2uVor1cgw6PK3OmPjqUIDSjOl8payIR7VwwZDIDEJe+x/I1p29nhf8Lx/doxbgTulQU3MQ+v8qvcQke9g/Hqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ui4fiZw/; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-93bccd4901aso2630339f.2
        for <io-uring@vger.kernel.org>; Wed, 08 Oct 2025 10:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759944723; x=1760549523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s07bq3yefwfB+/Gr+LJUgvY+fKCLyAq4B8pbnxhVLw0=;
        b=ui4fiZw/rGVErBEQRgobDqtWl8vWgZ+tQLOUBlxmj01ZYuUCIUd7SePdzBV6ZSDVoy
         unr+a0tIsuecdeSdcX5MYc6LZ/YS6iIU6zCY3xyfnSMrEWcu1tdKSxQuZOy2GX+y21sz
         JE0CybEsgihe46JB4KleWdXgza5y3KsaYQPFHj8ScXaHG1JgOsRMqbHnN6GcjbUDlpau
         /QChKsSXNomrzyCPX7Gupj2QCTPGMlDM8OYMskJ4ezUQKWWh5o5dBri8pYCizCdLjp2f
         X95G7RelTxsORt8RqZtPbgGTS2kOvZ89cQNfTj7i+mvrWQAu538TgdLWLm49+BsbzIrC
         OUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759944723; x=1760549523;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s07bq3yefwfB+/Gr+LJUgvY+fKCLyAq4B8pbnxhVLw0=;
        b=aeymFHx4P6bX2Oz4U27zs/MolnILDLv2fbKQii7kcK48y/Q8WwAUkZlKF1dV9Zhgsx
         9mY2Fn/byMFpOU9k0cfSfFmV1m+94WPKWu01KRD7bGkoAKlisokpvDkuXQBYBcpKqed5
         HdpPPa03SW/HpfVmCAmDB5UjoniCZEY2gs8LphOQ98aFCBMQSuc7aoJV6owxd6CqeV0i
         qvxBJF2KY5H5oZXHBIoCTGkTrIvFBmMEWbUDAkfU8Z0VIfOLaFIen0eIlLwUSKB5wVDO
         7caGbnOLMpU9AHLnU2zJbh4LvOu+sp7mCVNeH2fwvMkepiosn/AnoQ3WdOwI7Qf0okLI
         Lt7w==
X-Gm-Message-State: AOJu0YxpHJl7SSHvAMHn6seM3vBtYW4ReN6WT4qgeaEuogz1Kjbt/ye2
	KDz7+U3c2IGJPvgZK1vtdsaeKUawGyRedWFtHX2YgVwfdnr0a63oIRiiMMFXg4SopvQ=
X-Gm-Gg: ASbGncvJcMs2WiFQo0VWvwNgk/AdBdZnGJorQoArJbgyC+POuMSuPJBV686HE9GVX65
	FZP2KLBQHOw/SgEIabP4gQ7nnc8qYQraCLX8WKCHGzG+BOLlCuRuB+D7TKH5zHUPLcUPq8DOK4Z
	z5gjwkcldsb33+6TrCtRUo1qHpwv9k0iYkeHPUeKFB9oizvJDqhkoolxuVZLWb0ZvBOSE2octLH
	5XPGYCql7diaMMyrAKgnA0cI89sAdl17yjcqKyX/cwouYy2YfpvSsdWxSpwI8PZBVj3ohHz+TWs
	pD37tEJ5HN4k/hmB53SdtB3e8puSvBPUR6odS+5hJxFL6hWLdUzJDiOzfxNY90E+1VcfmdWgSt8
	Q0EmVNtoGDSOwnWsapQjpDhByA+S6u1OVrtIqbw==
X-Google-Smtp-Source: AGHT+IHKT/Ts5Q1f0eBOyGJ/SqRQvtvv14mZDbGopPP+3ngExKSfBHL0g1I+xOXweyXm4CrMKSFCpA==
X-Received: by 2002:a05:6e02:1806:b0:42f:8633:bfd3 with SMTP id e9e14a558f8ab-42f873fe7aemr41500515ab.25.1759944723118;
        Wed, 08 Oct 2025 10:32:03 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f9027872csm1366205ab.10.2025.10.08.10.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 10:32:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, Matthias Jasny <matthiasjasny@gmail.com>
In-Reply-To: <b0441e746c0a840908ec3e3881f782b5e84aa6d3.1759914280.git.asml.silence@gmail.com>
References: <b0441e746c0a840908ec3e3881f782b5e84aa6d3.1759914280.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix overshooting recv limit
Message-Id: <175994472198.2061199.6935762244237340434.b4-ty@kernel.dk>
Date: Wed, 08 Oct 2025 11:32:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 08 Oct 2025 13:38:06 +0100, Pavel Begunkov wrote:
> It's reported that sometimes a zcrx request can receive more than was
> requested. It's caused by io_zcrx_recv_skb() adjusting desc->count for
> all received buffers including frag lists, but then doing recursive
> calls to process frag list skbs, which leads to desc->count double
> accounting and underflow.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: fix overshooting recv limit
      commit: 09cfd3c52ea76f43b3cb15e570aeddf633d65e80

Best regards,
-- 
Jens Axboe




