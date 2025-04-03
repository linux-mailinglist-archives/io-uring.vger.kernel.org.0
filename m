Return-Path: <io-uring+bounces-7379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF739A7A543
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 16:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 867F43BA314
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 14:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7627A24BC06;
	Thu,  3 Apr 2025 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aw7/Mhsp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4924C08A
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743690745; cv=none; b=oksZDJ8SCn7Dem2d+nUKEO5isVpMZTPif2Twt0Gzl6FnWLBFH8YejoipTgOQ1gJxcY6T1l3fosZEf7/7eWrBaUz0jlxn4N/GNHm/kcStkq4iefcuNQ/K21Tw/+5ztl/bFF8/R2Cx4kHEUJSqqQUbZT59E0bhnL1uh9pE55thtvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743690745; c=relaxed/simple;
	bh=6ycuuFGYDUoISrOZU+vg45uaTxz5KKbLr+W+6GlK5vs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FD6WqSd0vTVDvxwyah1ZUyHYTR1mBHDCKnnLnvP0vxIA3ai32n98K6KwjZSY5+lksETT7XnDK+Y6mMTsMeAXbLHrNfsG+xxKSBzQ6H0CEzDh/xjrBpFuP5vdZ8nYk0P3/CFWCJf2tx7Utl1zyCXekqaJf4v8b0XpceloEP7L6Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aw7/Mhsp; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d6e11cd7e2so2700255ab.3
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 07:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743690741; x=1744295541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6QhqDBfLB8BMGQdUu9jL1ZFuZXg4bem5gk6VCsoPzk=;
        b=aw7/MhspxtaZ3HFF7IlfS1rz88Xgo6jHh9wRCNipkZReYy3tjpZTjLVrSywGF8UeBz
         ZmWh68heute6ugAQNXzdqKqFxPoYqnoVa4r2jfXlMu0aTYP8XXC6Ghfuc9UTbk8A8bWY
         u8By7bYoEvvV4vQpIB6N4uBVa9aI43pbbsk11/cgB48vUS29LkNSQ+9piqoXe4omdMSX
         YUhCegQp0WwmeuNHlMWZFk/DqPCcD9ENOUWSltQrFSqtvy9jt7XtLz67gVaLRhEI5mz9
         ZN8Tj+XLuJKgNLN/Jn5WJM54r14/HXVGHpfC3nUOur4p1s0Jj4diRrpCciznJYzbsV+c
         bRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743690741; x=1744295541;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6QhqDBfLB8BMGQdUu9jL1ZFuZXg4bem5gk6VCsoPzk=;
        b=MWM7P2JtI7ZjTB7M1KjebIQHsR1KTJnCiYBCsJlWcm2jt1reL3mcFhPBRhNUWMpUT3
         Xe87gvUsybzWQCZkRlNTPYA+xNgaQL4lNl+BH6UOMNAEkTLxlMjXxcbVyrhMLM6kSfR2
         rNN8Ve4pkGVldD2jq7PQVsoQPwwKKKqkyyxnAqdneTlS3j7JsZXHp+nXgFNE+kqyKCyu
         d+9X0uos1TlPwSDe8vW1IwM2olFbS7Dl03NQipDxB6oTPCbTo41+faBmHuhcYn7+qIj7
         RfiyfipFstqmv90AoOQ0gc3+tlz9IP1md9I2UFWHIZvuImNrAic9BV8q5y3rzwvHHD8v
         Bbsw==
X-Gm-Message-State: AOJu0Yz4gVDfyqBtIRJq5rLFUyAQmJTGid7H4VExzUlqYjgkZyXu2V1M
	0Q+EI0KTKjqjmFF/Vse/uoXGidmtp6J5r1BC5hpTiN/vNtjJn7qBrEVU8l0Ei1XcEhNfeOSq+8S
	8
X-Gm-Gg: ASbGnctEKcXy7r/zK1J4tOG1FGd+c2V2tKUUmZhN0Pf/si7+9ttQkXwh/ttXefDC9RS
	YPiaWPYdwfYu3dOQ2gwcWZ6gVQwStJ7CkrDl354RNiK8539pwLd+6IRjZofkfLOt75xJ0tS/u8l
	9DXsrA36OBBX0llxnL/yWCOVcKUk3JveOXSaui5gAHLp7htVaaHn1/bJZLcqUoTBFm6VL1kMoiA
	enl4XlcP9+FtlMmuIHeKNgLtK9KmJnYUIG3oCecYg8vJx46/5/7CqI94ZSzhB0Ol9SgMqImzMeU
	KqFqLA76HexswGjrwSKbM9I4nu/+NZor0hyBraQLUiF1yg==
X-Google-Smtp-Source: AGHT+IH+cxlOVxTNGwGgZR2RsF04yOPOOcnJpQQ6I3gd7WIbKZIQIzhzzJa/N5II3b+rnoo5EbXnvA==
X-Received: by 2002:a05:6e02:3d84:b0:3d6:d162:be54 with SMTP id e9e14a558f8ab-3d6d554380emr67174665ab.14.1743690740778;
        Thu, 03 Apr 2025 07:32:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de79f259sm3196695ab.13.2025.04.03.07.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 07:32:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d880bc27fb8c3209b54641be4ff6ac02b0e5789a.1743679736.git.asml.silence@gmail.com>
References: <d880bc27fb8c3209b54641be4ff6ac02b0e5789a.1743679736.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: always do atomic put from iowq
Message-Id: <174369074004.172837.7459354560566437088.b4-ty@kernel.dk>
Date: Thu, 03 Apr 2025 08:32:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 03 Apr 2025 12:29:30 +0100, Pavel Begunkov wrote:
> io_uring always switches requests to atomic refcounting for iowq
> execution before there is any parallilism by setting REQ_F_REFCOUNT,
> and the flag is not cleared until the request completes. That should be
> fine as long as the compiler doesn't make up a non existing value for
> the flags, however KCSAN still complains when the request owner changes
> oter flag bits:
> 
> [...]

Applied, thanks!

[1/1] io_uring: always do atomic put from iowq
      commit: 390513642ee6763c7ada07f0a1470474986e6c1c

Best regards,
-- 
Jens Axboe




