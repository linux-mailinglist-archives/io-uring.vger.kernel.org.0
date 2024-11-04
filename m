Return-Path: <io-uring+bounces-4436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58EA79BBC52
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 18:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 865191C2179D
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F279A1C0DE2;
	Mon,  4 Nov 2024 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P/AU3rAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA42176FD2
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730742598; cv=none; b=r/YsxWfeKq+fMV/i2jKcLjMtcYHHwWjycP9X5Vp980iQ5YqssTimBXZ3KtNT1dIWFt0+U25a2hMfwb5ghwEqcpC+5JOhUtBjuqHKpDXzHNmpqXvwGM9k6AWMygWQTzt2LheaX8jKEbU2M7X/tVmJTwJDhdbFJGhe64xWyvNerBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730742598; c=relaxed/simple;
	bh=HxPjMmEWixHH1kc7kHLO/vireJC6n2B6W8qqZtV+iJg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fpTb5JPqEoLBYTXMfodYIkgN/p9EDXTXzeijpq4j4QBGSxIq+wIXUcGx9KxNDhwVp3TeKw4ViQptqcCFZXO7KA2N20ex9fJLt2hoVCWgIgwMiP//yZv8t1Meg+L9p+T2jjv4ALNqsK6WzhBCrhdX+xMWQDzQxvWCuhTQiHBzdM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P/AU3rAZ; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83abc039b25so180005239f.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 09:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730742595; x=1731347395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WZY8opErCIAcUOIH9YHeDLMPFLmg1HF5hKi7JEMk13c=;
        b=P/AU3rAZ0Yp5ulR7k8ueZPxcqiVBQqcpVY+274i1RI9WiOFDt1wQPpMk0raMviQkT5
         /a1Z88QZmWmOhXHs5OpWOVIaUhLRg8yjgIP464vWo0IoI2IULzlCOB+RO284VB2gXtjO
         F6pxOM6VpUawP3tbhUZmLuebSwKeaoRdP4dmC4DbOII2v73hsJ7n2UJtol668hkSjMU5
         SBSIsKQsJeXMVgLuEHQb7T7yux1Y2ZY7swstEbaeKUV6tK0e3vZ86XeCDqO54jgc+MgR
         O5yMa4AgC2H2IUoOwXaQBjFgFkD6ldtM/+Zftnh2VuW+gCs0hHi5nlegoe1xyO14kcyA
         zTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730742595; x=1731347395;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZY8opErCIAcUOIH9YHeDLMPFLmg1HF5hKi7JEMk13c=;
        b=wPC9cpsmdTgpU4HK+/g8QUUxgVF3kTq5CV/1CapYOLvJ6lmF5osdS6Zn0lFXFfj1XF
         hcli650eUaRJXoJvKaQ3nu9sEXraFVQWE1Qnvs3n3BaQYaHqfOLncmDqH5vjFXNsw7Qz
         QKZnPL2M2EZntjL9nSewDLrzBN2Ml8CKQU7EjcHvvBZlUjBip9Dx9Af30epW9YCFCFCn
         srvtBGwBFVar0spsAcBSrJl8lrvOk6EjzVc0lTKQ0OtwIodKhOI53bAuAzv2HjuFfgSG
         xZ15lh3KIm9KGLMm1zxP9NjotDw9HEp1AsFjNKVWiYCoZOU7A04ZYPjScHWuzuXXup8X
         1Fcw==
X-Forwarded-Encrypted: i=1; AJvYcCW7mvLiaqkw1e/lhKBOOfQC0Hw0XKdq2Xm3D9GU1DO5eSrKZPD74DB53NCNlRKdeKvRwWfREW5vRg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxSu91f1JoHEodbxJmM4bxugAcKikBDrq6mYB7jcTMKw6kDng7
	gJgOPzXYsBLxBI5BJ2e6modLACGjO0CpEVBEkX43XGr9vp3fOqa9S/m515/c1O0=
X-Google-Smtp-Source: AGHT+IHV9wuEKhJkt6c2D24dgqtk+E447K3YLCRYaPqI6NX0ma6pfCAaCD/75CfBz9xpJ5XZ/Sw0BA==
X-Received: by 2002:a05:6e02:1a8c:b0:39d:2939:3076 with SMTP id e9e14a558f8ab-3a6b0394ec1mr118388395ab.25.1730742595465;
        Mon, 04 Nov 2024 09:49:55 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de04888292sm2028111173.25.2024.11.04.09.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 09:49:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <cover.1728828877.git.olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
Subject: Re: [PATCH v4 0/6] napi tracking strategy
Message-Id: <173074259442.421784.9269680507652013350.b4-ty@kernel.dk>
Date: Mon, 04 Nov 2024 10:49:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Sun, 13 Oct 2024 14:28:05 -0400, Olivier Langlois wrote:
> the actual napi tracking strategy is inducing a non-negligeable overhead.
> Everytime a multishot poll is triggered or any poll armed, if the napi is
> enabled on the ring a lookup is performed to either add a new napi id into
> the napi_list or its timeout value is updated.
> 
> For many scenarios, this is overkill as the napi id list will be pretty
> much static most of the time. To address this common scenario, the concept of io_uring_napi_tracking_strategy has been created.
> the tracking strategy can be specified when io_register_napi() is called.
> 
> [...]

Applied, thanks!

[1/6] io_uring/napi: protect concurrent io_napi_entry timeout accesses
      commit: d54db33e51090f68645fecb252a3ad22f28512cf
[2/6] io_uring/napi: fix io_napi_entry RCU accesses
      commit: 613dbde4863699fe88e601ddd7315f04c1aa3239
[3/6] io_uring/napi: improve __io_napi_add
      commit: e17bd6f1106d8c45e186a52d3ac0412f17e657c3
[4/6] io_uring/napi: Use lock guards
      commit: 6710c043c8e9d8fa9649fffd8855e3ad883bf001
[5/6] io_uring/napi: clean up __io_napi_do_busy_loop
      commit: c596060fbe5a1c094d46d8f7191a866879fe6672
[6/6] io_uring/napi: add static napi tracking strategy
      commit: cc909543d239912669b14250e796bbd877f8128a

Best regards,
-- 
Jens Axboe




