Return-Path: <io-uring+bounces-6749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E2EA44402
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1173C3BC215
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CF121ABA2;
	Tue, 25 Feb 2025 15:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y7IFYxzS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8EB26A1C1
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 15:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740496028; cv=none; b=formZIAqBKjya+LCVaXRmwIr9tmFDaokVN1BsY3vy1RXqaFsiN1B58cz/7a502PNOEm0VU1QiYAlisn6NzWK2mu90zyVMzThQJnW5xFn1mmOun66TtBvddZRKEcbMLilJO8IT952n6oSfDVQEEZtzRU6BVzK4Z9nsQP5DxVQNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740496028; c=relaxed/simple;
	bh=B009efDPZygZyxJVOw4K+czmRA9Exrb2Qa97Ni5jlPg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UJfFxstXV3te/rtR//DBV4TJugAno2EThlpXoJTr2IvGZldJE8XHP2VoCy+2/yapDY4zPznZFYmy4wsEEdIyVcwSI0ibzVifAYWDpcUABuHcvfiYQr5yW6IbnM9Y65l9oEeSXmj37ODBtH9yUlFoW3yBKJzXtak0D/t6a4x8u34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y7IFYxzS; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso19720445ab.1
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 07:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740496025; x=1741100825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=deTsz6vaPYf3sDSf//6kgc+SRaxAQgKuaPfuRfkDB18=;
        b=y7IFYxzSTypHDo2++RL122sfZX8W8McCZPf8eMux7eEf8BtimuHioIQYZGtN0br4E+
         mukWZs4ST1XkyZ2WJVy6et4QW67y8LHBuQjTjaeJ+nIu48t9yextxr47JnPU5NaiAmn2
         5lXMBEcMJo29fuzitVNt3ZxUsVN0UfQDytDepk3uR/P0+XiNibrVKhCGhcw74Pg10syy
         LuVb8GtSujYKnAFDrCuxrCHFGxSYnRy/AJGCZPbDriwoGNUvY/HYUqRJlppmroYICfpB
         54Wj1a8//SFqBEVt3hSynvNBPQAvK7IkbnOAW1zrFlhJxlAu+QpYcqlur1byHVcFWgT/
         wdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740496025; x=1741100825;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=deTsz6vaPYf3sDSf//6kgc+SRaxAQgKuaPfuRfkDB18=;
        b=fJ/u76O7bNtAstHNDMZb4APMVZKydyZmrNue4VXgUlHMxMeetwI1PF/SAp2wezBJ8D
         UjbMM0IsHXMzK9Rof2F2q59u+6/fREHFVOkVBucrv0ZExNw+N6MGVNY5oo2WOfmwYD+h
         vcdxYWypU5iFjEs0uytgvvLJAWAgXGHOaeB6+kQU/OnWECXS9UXkTWYW6uTeE3JdvSPe
         EHB0mmg4Un6ZcfSx8C+1g57rpX64lsDIWoM1oT2wHsRG75ffuuDpMDuJO5mMq7iYLXl8
         chRrjNJ59Yuv2ZnYmI3kwuSaVDidkVEgNEjU4Gclkn9FXO0cx42CyH3D4gDJKRqNlBiH
         iAAA==
X-Forwarded-Encrypted: i=1; AJvYcCVKQ8mdOzJFHZpMFtwM9X3fNZo1i5/zNjTkggHTYFFgiJxaY6V7NJE9fnRqnc0h2QEuOXJC/9fv7A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4RMTqbGoOiHtT15lq8JG0DxayZ0t0QJDIQZa+RXYoq5CxrNc8
	JMr8a8sVZIzmwy71Nx0ktdI32K03+ycJluiw2vr95XQ2q/7ajvPeN6PyqxBVuDg=
X-Gm-Gg: ASbGncuUNTN0oyaJiNnvGBbOxVNFLp+lxv2zLmh9ePsQJyZASllF5y5WbsbPxBrtKsz
	B8ewmhp9hWRaJmVib1rTQ3ymrvEo8e8y776baJMmnJ4M5RH1q1xSv5VaqNkcZzjE+K7acStJIg/
	6XVbv/AMBGfLyetwB5DZpi1dZUO7APeB0yS39V2gu45Uhgkrpvc4lIofGtLJcI1KNkNZ/ALqcK7
	zRsCiXld1M/2XHlnai2t9kWFZn2MC3uXvZJG5OmZRLXBchaAPgq9HhkTesMF0veld0Hmfq1gJYV
	JZD1fzGWtXJRjXHd
X-Google-Smtp-Source: AGHT+IEljIBkpApQgkYcq8zFrUakPE3hYS5jFm3Tnmq5CM5VHY6XZWLhxEu6NYet7gZ7xOt6Xk2Rfw==
X-Received: by 2002:a05:6e02:b2a:b0:3ce:78e5:d36d with SMTP id e9e14a558f8ab-3d2fc0ea5camr39683735ab.12.1740496024806;
        Tue, 25 Feb 2025 07:07:04 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04750fcd6sm435827173.94.2025.02.25.07.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 07:07:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: ming.lei@redhat.com, asml.silence@gmail.com, 
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
 Keith Busch <kbusch@meta.com>
Cc: bernd@bsbernd.com, csander@purestorage.com, 
 Keith Busch <kbusch@kernel.org>
In-Reply-To: <20250224213116.3509093-1-kbusch@meta.com>
References: <20250224213116.3509093-1-kbusch@meta.com>
Subject: Re: (subset) [PATCHv5 00/11] ublk zero copy support
Message-Id: <174049602370.2137789.11659945725792344397.b4-ty@kernel.dk>
Date: Tue, 25 Feb 2025 08:07:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Mon, 24 Feb 2025 13:31:05 -0800, Keith Busch wrote:
> Changes from v4:
> 
>   A few cleanup prep patches from me and Pavel are at the beginning of
>   this series.
> 
>   Uses Pavel's combined buffer lookup and import. This simplifies
>   utilizing fixed buffers a bit later in the series, and obviates any
>   need to generically handle fixed buffers. This also fixes up the net
>   zero-copy notif assignemnet that Ming pointed out.
> 
> [...]

Applied, thanks!

[01/11] io_uring/rsrc: remove redundant check for valid imu
        commit: 559d80da74a0d61a92fffa085db165eea6431ee8
[02/11] io_uring/nop: reuse req->buf_index
        commit: ee993fe7a5f6641d0e02fbc5d6378d77b2f39d08
[03/11] io_uring/net: reuse req->buf_index for sendzc
        commit: 1a917a2d5c7ea5ea1640b260c280c2f805c94854
[04/11] io_uring/nvme: pass issue_flags to io_uring_cmd_import_fixed()
        commit: 7323341f44c17b27e5622d66460fa9726e44321a
[05/11] io_uring: combine buffer lookup and import
        commit: 82cbf420496cffbb8e228ebd065851155978bab6

Best regards,
-- 
Jens Axboe




