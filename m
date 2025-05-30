Return-Path: <io-uring+bounces-8133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1371AAC8D25
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49AC63A40D7
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 11:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0255225788;
	Fri, 30 May 2025 11:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="az7yeyp7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FC33FC2
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 11:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748605743; cv=none; b=bce3J6ScAPZWUP9lyBtkLCpUME7OfPCBclKJDGHiKrFtdLCQCAYfSn66s9VgzEgenuIyaNtIHENO7N2gr+/bJdeQiILb7nF1njQ2t0Yb13sBB0c1lqWxWUybuFrzIMfKzqP/3CBT2MlEqWw6LdaPEl7F+b82rfNnC8geEFQYOFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748605743; c=relaxed/simple;
	bh=I2Kcmgwk9kkuVff5nYzmRnGEWITcCKZBKBLFZOoh9MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=I1O6qTC+Dzkeu6pVOLPCTqFCGEAyWVupd9jr8oZL5NGDMrsEycIQsNfjJeqpzPsY7GzdvSsnArrcKyIiEudaJzDvJZbKB9EyAnlPSo89vtJLwxCGp0Cc9Hqh7xvhY2tH3zJxoEhLr/+qQxciI3S6seQlnUDOV8XykfwaQCjXOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=az7yeyp7; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86a464849c2so61360239f.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 04:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748605740; x=1749210540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JoKaNof+ATgeTKNw2AjeHvtVN1VbHcYHmeEbozD/JLg=;
        b=az7yeyp70ez9qi6Pae+ILUOi33NyPqU6xOhVfTdPqs59BS3w5PWC2/ScpmLSRZCbOR
         gESLlO3MKAPX7f8hOux8BwYXlprjgL968bO0tiOtUGqyHYRKiHhC98HFAsWuh2vOOFjD
         9Aj6XIj/WpfgOer8WVIqGf61KHMJITvA0/0TriXR0s9bn59aD39tlUWQfa8v64d8LKRi
         U3zU75qUzYWFRqD5wKvPLJxyMzCcrOWk66KOpYBZz0thkNB7RPUKUdJzlgCIZEQgyIJ1
         bXxHmURI3Sz2hJmsnJMIi4fiMhjdCLh6U8Hhli9z/J93+dzhsftANVLN5q+LzbqZBlJr
         UW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748605740; x=1749210540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JoKaNof+ATgeTKNw2AjeHvtVN1VbHcYHmeEbozD/JLg=;
        b=piUXLCh1cttJnAhJq3tSwaxhCIh8Ea5izd4juP7n6F1iEMXa/O1lugF/LA1284Sikq
         d7SjcC7+qtEYL+Bz51arSk+a7tBJGR02yemFN9g+yd7iMSQLvXEar+hPYc2oDI8ajcLq
         jhCJkFca4cpTCPiTS4w10OxNb+eusXYFHkpP7KEzLyLoS3TZXiXF7GnPjHu/vEWnHTIe
         FtfCuvtwLe3uK9uvAtFG6DVnB/xdkjKjH+YYBnZfxFmFakeKKGIeoPh3KyIcJzKZho/7
         VQNIl/MrW38rSwiCmud9XFYkigc2quk6xA3PJtnKLaZsLT/8B3dakwaCODkcV3iYWF/7
         VUmA==
X-Forwarded-Encrypted: i=1; AJvYcCVxBV1SQSLZl6+rSX/p3f6j7GUpTyWZyBi0NAdvBYu7J4BAiuNbZWMPB/P4mgn6R5jqQwCkYdKO1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzokocpjoieBCrCfz8cGGSmJBu+WfmQLmzkLuMs5x/TsqoZS1K+
	2UrD/TKGSILuDqZNg/1nDVs6YDp7dVHI7ua7qQpP2tHwi6DqfeVt/qj7NZQxiR2FAqo=
X-Gm-Gg: ASbGncvLHUu/ipYM6ozytCL+2wJXB5LzyvedG3ddKa4DeggQvmu7KpSoiuIOSI09Nm+
	7nLPoaWC+reS2v8u5qCuoQJwnxItqzw9MWpYMWkrdrJhanirwze8PfLLwhWv95BrI3F3TMVcfAJ
	cKvvcpuqUMLQlgI12Q3pPj7csG2PtYAcjjFvtn+2ZMzkrNWLOmoFGTYX7IBxhxufnBixxY+Zflt
	do/WHhAzk/R3Iu499y6Kw2uktD05FHIy0NIOFBxIBP3CMOydN+SulCv8tI7XEIbdR2zrSPCsPsy
	Om4jzwJXVNr8LLSfjtq1XdBWUqQLdzry7V0pj0Wz4P4W/Giu
X-Google-Smtp-Source: AGHT+IGb2Nf1LlXrvq+rJjKsom2ByYACOpqekt0wMpKAFEpJYHX3iyETxDt1ITBZ6fZtnDxbNtxspA==
X-Received: by 2002:a05:6602:4a0c:b0:867:16f4:5254 with SMTP id ca18e2360f4ac-86d0106747dmr344518139f.6.1748605739644;
        Fri, 30 May 2025 04:48:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79c13sm62974439f.18.2025.05.30.04.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 04:48:59 -0700 (PDT)
Message-ID: <fdb9c49e-b8b6-42cc-8a6e-010d0906dbed@kernel.dk>
Date: Fri, 30 May 2025 05:48:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748594274.git.asml.silence@gmail.com>
 <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
 <f3941c74-5afa-43fe-93c1-f605b4cbeb82@kernel.dk>
 <7518de34-8473-4fa0-9a3f-42769de4c03a@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7518de34-8473-4fa0-9a3f-42769de4c03a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 5:45 AM, Pavel Begunkov wrote:
> On 5/30/25 12:31, Jens Axboe wrote:
>> On 5/30/25 2:38 AM, Pavel Begunkov wrote:
>>> io_uring commands provide an ioctl style interface for files to
>>> implement file specific operations. io_uring provides many features and
>>> advanced api to commands, and it's getting hard to test as it requires
>>> specific files/devices.
>>>
>>> Add basic infrastucture for creating special mock files that will be
>>> implementing the cmd api and using various io_uring features we want to
>>> test. It'll also be useful to test some more obscure read/write/polling
>>> edge cases in the future.
>>
>> Do we want to have the creation of a mock file be a privileged
>> operation?
> 
> It doesn't do anything that would warrant that, maybe just yet.
> Do you mean from the security perspective? i.e. making sure a
> user can't exploit it if there is anything to be exploited.
> I'd really hope nobody would compile this thing for non-test
> kernels. Maybe I should make it dependent on lockdep to enforce
> it.

People do all sorts of weird stuff. I know it doesn't do anything
that warrants making it root only, but at least as root only, any
side effects will be limited to that. I think that'd be better than
making it forcibly depend on something unrelated (but debug'y) like
lockdep.

-- 
Jens Axboe

