Return-Path: <io-uring+bounces-7278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E85A74E92
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 17:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EFC53B4B71
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368152AF07;
	Fri, 28 Mar 2025 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Tgnque9x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3292AEED
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743179692; cv=none; b=Xo9Rzu0hIFI+h497vr0Q4O0FXDcbSsFmnsgceQpZdK2NqyfVuU/dDluRGlfwSw7SFjQbNNpN4NmGk4L+G1Qsrk/wEsKzCWjYImDlOY9QneNcAWvkvOxknuTwBx6/GKLbTnxpeRmAxwsfnLHHGLfbjmTZQSIH9NjcTQrTXyLu640=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743179692; c=relaxed/simple;
	bh=Goq0sc9w2c98tp76TmXi/Pg9/jUIGit6I5+eg7N+1j0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=om43dXMoUv9BjMoFB0+3IyVBuW9vvcnjF+Zf9vJ0o62KNDeJoRmZkLRCgeJGnlRNAdcb7UQLcrf8fM3+HGqOPW+2vUBcvWtOPme9QM5A+b1KzZllAfaVe84lQN2oaLfwE3GjG5Kpu6CI2AwFZPm54hh7zyONX1X+oIuJheq6ccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Tgnque9x; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-855fc51bdfcso93404539f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 09:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743179688; x=1743784488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5y8qmDTUCBGqQfqV+HdsWLJFfT7S2rNM2Zj7K4eVV+w=;
        b=Tgnque9xXk6YZufnFSo3sc1KRmm0q10484qly5WyluoLd8xfGzw2afY4e4MD7a5HrI
         oPpwV391QUENaEm90Ie/d2wS5b/6ez5YJgTukRaUvN8B7wR8KRzT4CMaoHJ0qzMlT9P8
         nt/gwZqW+ARYVtRlyGWLNKnDeZJIRPfUuNG5HqK9qwM/svGciINOg8IeM1wtp6fT2W41
         46MzLPzt7LQN2DLDBe8/kDZo+ahQ3o3u307TdVp9A7gAao2b+6x9RW+IE/hfvivKHsEM
         T1HfORQchwy99/hFiHByH1uLDNKceUI/vAq1+Zv3vg7YRtUbtu//J+0wiJ092oLevwTp
         VCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743179688; x=1743784488;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5y8qmDTUCBGqQfqV+HdsWLJFfT7S2rNM2Zj7K4eVV+w=;
        b=VQDNlRWek8uLxeyb/zpur/wUkRvcHuxDLp5IlalNLGoBdcnIEn65JWvOtxcFZHiT22
         8FPYvhOsRa0FAk0v+O6rQatEUrgfLXI30U74j/ycCokZ0LyGGI2a4o1wVxuN1jy16zVh
         43dNPsW2ADylNh2EG7kXUkfBADEcleunMMMNo8fle1/LVt+eHpiYaTTpZdNvADFwDoQJ
         i5uvwGl5mDe+CXmJ6qzSVM4tUceu7HFK6+Ktdhozr09qTjgbmY60WUvFsX7wDx6vNmP/
         0RC69Hj/nebeXSLCUW86Rqyij1uvz0ECcNFFN2UoeDJasrkeFHujxy0u9KJXXMqdpV6t
         4qhA==
X-Gm-Message-State: AOJu0YxWF4HWFM31VeK/JGGmlM34WlZctt5iySHN4Il0lx/QE31V289B
	1CDzimtLj8PiarJxN7lvAHL56JMY8CVVB9o7H/jZ5PkCSmwYwG9vi0SAP/eusjM=
X-Gm-Gg: ASbGncvE7l2Q5U5Mpi5s/y2aOoFtmYelsrC9jp+zEg8k9vUNWRfnMysijq8xtlFvFqT
	gny1yewVnYamOuEsk0zbhR2BNXG16uvKBuA8oJL92jOmyBmPwQacMdQOTT+t/+tMSlTLGzR1yVY
	mCPelQ59Fw1WYJJtKNSDaLUxuwGz7oj3GHzHu78us16WdFrrl+XYdBI0OqjdDeE/p3o3VNXpI5u
	Xqj+GzXQs31vZxYbX136cWAbwr949sHr+Mr43Qb8JQ1oDw48bM/nnkI1cXH5Tmm3XM7EhP7M7j6
	KhSqIsXkdBsdqYYlSjqMidG9lJFeXNgHXlQ5zgEn
X-Google-Smtp-Source: AGHT+IFsZ2ix015eSvkDf4/8WtxyNR7hSBSVZ+ZHayUebuaM8rzbDz4EzscjO/sTsCdiTVAZIAmtrw==
X-Received: by 2002:a05:6602:4c0e:b0:85b:4310:a91c with SMTP id ca18e2360f4ac-85e9e846441mr16179339f.1.1743179687841;
        Fri, 28 Mar 2025 09:34:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85e90249a32sm44471239f.31.2025.03.28.09.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 09:34:47 -0700 (PDT)
Message-ID: <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
Date: Fri, 28 Mar 2025 10:34:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>, Breno Leitao <leitao@debian.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/25 9:02 AM, Pavel Begunkov wrote:
> On 3/28/25 14:30, Jens Axboe wrote:
>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>> while playing with the kernel QUIC driver [1],
>>> I noticed it does a lot of getsockopt() and setsockopt()
>>> calls to sync the required state into and out of the kernel.
>>>
>>> My long term plan is to let the userspace quic handshake logic
>>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>>
>>> The used level is SOL_QUIC and that won't work
>>> as io_uring_cmd_getsockopt() has a restriction to
>>> SOL_SOCKET, while there's no restriction in
>>> io_uring_cmd_setsockopt().
>>>
>>> What's the reason to have that restriction?
>>> And why is it only for the get path and not
>>> the set path?
>>
>> There's absolutely no reason for that, looks like a pure oversight?!
> 
> Cc Breno, he can explain better, but IIRC that's because most
> of set/get sockopt options expect user pointers to be passed in,
> and io_uring wants to use kernel memory. It's plumbed for
> SOL_SOCKET with sockptr_t, but there was a push back against
> converting the rest.

Gah yes, now I remember. What's pretty annoying though, as it leaves the
get/setsockopt parts less useful than they should be, compared to the
regular syscalls.

Did we ever ponder ways of getting this sorted out on the net side?

-- 
Jens Axboe

