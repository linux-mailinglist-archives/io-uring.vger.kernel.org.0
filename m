Return-Path: <io-uring+bounces-2026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 920FC8D52E8
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 22:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBA0F1C20BB7
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 20:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B902255885;
	Thu, 30 May 2024 20:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CJ2HtA/T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427C44D8BF
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 20:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099816; cv=none; b=XyTHCWgxG7s4svN3KjuPfWZHLmdEtNUMgEEIJnXitf6njBAX3z1AqhqssjUOk12dEtSdwc2xhL2kGLBHJPXUH5MZqeZ6Mfq8BAnqHlg6YgVFwEit9iulYUlYMbX+zFMTxJn7LQj8IUrXWZoXuca6PQYdmBFd8tswjkSrMqDyEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099816; c=relaxed/simple;
	bh=1uhCyqyd6OfBJhLOomRnqKGxLhqaf3SVuyATwGnDEOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S3D3ieC5UnoYa9+5akaEdt5DhrZG3ugl66SpJ5yuo1bA7wwxD+iB04LXAbO/Iz+1CJtjonL92Gv/tJWsZH3uvYCGxavYaTgpdTWlEuolNoLPJRuxgTCWs9Rq+LKA8nC4fUdZA1r5HoLFHfkZ3MgYLUYesD5M3FR7WRj/uMTdJoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CJ2HtA/T; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5b97f09cde3so196207eaf.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 13:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717099814; x=1717704614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zGOf4m18QTtHJvMQUoDQufLKLE25S3D0AAB4RUkeJfc=;
        b=CJ2HtA/TQbQLHoY6Q3Q2jSESKaN8LF7RG9OU5RJrawdojER2cxmfylj9Sgb/1tx+1E
         kQJq18HwPu15UOj72BE94UVY4NC7d+FMA5DJN3HEkLTLOzQN2bbK4sUM4TyVhgdgPZ2G
         koRe56afcmpSLjUmalD+HeuXlQMLQgxSmbuiZpiA/J2aY9j1Gf23er77EpU0o8dpeFVl
         cfmiNT2IsYZYUjHFg33fAC9pb/NcCBDz49d03j11rsbyn/srpCiVP8GeieBKhBDsMRVm
         WaYnNuiHgIkl7xbR9lg/hiaCaCzBBx8Jc5erOddawndf3pzNQP+qN4SvItUvqHYIb5P4
         KOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717099814; x=1717704614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zGOf4m18QTtHJvMQUoDQufLKLE25S3D0AAB4RUkeJfc=;
        b=iCxKXOGbhz8L6lj0/MqSyqRC8w75j1gOPwMHqgJfg9XuG1uCPNuYJoIvfB/fqRsbfC
         u/GvoB6OqaEVUF/F+/vW8X9eDJo+3JKuVylnYLgObLYWJKmEJjq/fBRq7XhB7AbgIJfx
         MugDjEVn2aUV4/ht2rP0YybJxxFTf5ZSwpmacLFguLN45/trZp7RUf0C0jwkdlKbNDY6
         8c9Syr7NSbMVjS2PupzIze0QgH6o8YLa4d+0zuAA3BlTXXPCSJerXdTvzpuDgEtnwkRH
         kzEZOZqn9Juk3vU8s6MqdOKUawhXJG5/mLR/Wuse8W+dM3kW2mTA8bZLuCYnenKNGZmT
         cF3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqgaVZ8t8Z9EGItyHNYJ3AiX6Kax0en2c4BC3tSGdnZHiEb7pjaIeO8M+3oefS2beJbsoc2bPVGxcG3Y3XrjbL+cHaiZ7IWuo=
X-Gm-Message-State: AOJu0YyJxbxJr+yhqKca2m2QOhzGAyeC5gx5yBMrPbmSkLqyijRgpBvU
	U50tYvDIPAu23XpEz5+yacXlqPqnEMLlkxBnNAsk9431BcbwzofuXYP6V3gfMWc=
X-Google-Smtp-Source: AGHT+IFxtfSha2bFV9Bllh6KjryMKTM6ysYjJaNmwUmfLWw/8WlLkOhLC3srNxELNjFhlNeK1I/WBA==
X-Received: by 2002:a05:6808:18a5:b0:3d1:d35b:8174 with SMTP id 5614622812f47-3d1dcca6715mr3424509b6e.2.1717099814399;
        Thu, 30 May 2024 13:10:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1e1a4637esm74809b6e.36.2024.05.30.13.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 13:10:13 -0700 (PDT)
Message-ID: <ecb2472e-b505-42bf-8c02-66567d8c4277@kernel.dk>
Date: Thu, 30 May 2024 14:10:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow
 (2)
To: syzbot <syzbot+97d8b31fbab9db1efe55@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000003870370618b861cc@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000003870370618b861cc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz dup: [syzbot] [io-uring?] KMSAN: uninit-value in io_issue_sqe

-- 
Jens Axboe


