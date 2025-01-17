Return-Path: <io-uring+bounces-5968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F5DDA14E5D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 862E2168817
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8A81FDE3D;
	Fri, 17 Jan 2025 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZnZBK/o9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026061FBEBF;
	Fri, 17 Jan 2025 11:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737112957; cv=none; b=GhcA16cXkHh2bdGKlvPndCq8VMO9fu6fOlB4sCdhehb4dffhFFVPLBKEhjwSPJo5GRzzNMFROcc4n5JOe3QexUW5coFRo38qq8+0JYAwWCR3fTaq1DfEe5S/FBMT1ziy00W3RCJNGbc10Ico18tKs4i9f7kxwxhbd4OhYlIQ18M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737112957; c=relaxed/simple;
	bh=z1xUjANtNn7T9vxdRuYqUIZPM7q6ZxeL+7pFj2w94jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JBJV0jvzPnD+6jFd+4TNIqu3EkDjLD4uorqx03rz29DrGlkNvLnLi2ac9yioqklYVPB/N2c2PtU67TTuyt8PRsuNKUSCCSAVbr0g/f2eURWTGypyOajVHLEZO1oxyPPQKZDoICIFA70d4b6HXNtuh2lhtAgnW67NfqpHq+OByX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZnZBK/o9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa689a37dd4so401063266b.3;
        Fri, 17 Jan 2025 03:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737112954; x=1737717754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DEATpvFojN/BJsv8hl/8zJONtveqEIrmtiL2FZVmnAI=;
        b=ZnZBK/o93yAGLSOTons8tfnGviHyy2/IbFTLhZH3t4tuy5BH4MEQ7qVHBGk9Ko9eMN
         8jEdSF48LRIUNIlVEw1SVa1klxAyAJcl0CXJumAu1dGoDygliJdqfEY/9ZeHSx07BD6L
         vDQH2vhObYdnv6TV+Y6WMuG5QhK2SG8dOtwEldvVeXqAYFCpBLXHcz1W4LcWFJ146Q/A
         JZMqUMOqgQxTyGHbTr+l5GiEKS5yAuY8Tw45Ynw7K4w9Whe6WW7VO7Gk2yEjNmojrHAh
         UeKCUuuW2ndUalxhgxgpI/BhgkUH9Bcr9YKL9Iv6Pfnl8RMlkaEm1cLkmQkcXGibCXsw
         4zUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737112954; x=1737717754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DEATpvFojN/BJsv8hl/8zJONtveqEIrmtiL2FZVmnAI=;
        b=TcAPISX3ee7ABlkIaBaPJ8PbucwnxQNjfWoGJfjq+xOCFsXDNitG8jr88GVm1ZKCsK
         BFdymQ4YLjj5gmfqI9rKFRBFAjss5rOjmwy1ZK2Sl8rztno4XhgIlktZ/W9x3oyVUA0H
         9vh9aTopUIfi66Oht2rltSIm2L2/+mMw9sEwtlr/KsRhQtyvhBSdf1xYlZjZkxZFIc0l
         +WZfdNPYp6kkjXgv69tQKvHdY5PQM/yfa4+YCMdQLGY6+sS/Esj7defC/rmUz3r62mC8
         I1qIdFOsUZe3+XIfWPNoNgEpGBoDDahlVS0GtESUGWRytuM1Mw6mGgEh+a86dcbm36ol
         BRgw==
X-Forwarded-Encrypted: i=1; AJvYcCVNvnX+2WimLJvxx9egpVLFB1UcG+vO/ulrjbDbxCQWSbyu4RfC1elEE3VXBQ3f7Je7tFmGOkTFGg==@vger.kernel.org, AJvYcCXr1RlYeZLnYjJd6hGETwr4Pxyn3224J3AqjLO3HdvWj7Z4ceF6s1L90Jsgb1GR35z1/Dlu8LDc1JFb8XlQng==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTYCBy4fJZm5Dqc1ty0o8jeLWqiBuWfkBBwJFjEk0PTNeM0ApJ
	RP0SvoZMV0mFvxZwE1dq7ubahF0KJ1mn9fegHb7PQxdqYZxfsbAt
X-Gm-Gg: ASbGnctya+b+Pn+yJf45+dQGnMsfZW9wGRDchCm2OdqnpL7y6MAYvyAPeZJJc7bqnO6
	3kJ8o8Ri43tyMwO5xKSU7oE6DNSVLMyvPVj9GdOzJPHwpVDBz4Mf2tmCjIYIkrtZl/5BI2HeAKJ
	3i1O7feQTa7e4dPCzdoJZdmaVhIew6F5thQqcO7JIpxaR1HY38oyUgYNxx0fPMT3X/8P0DwDAoQ
	1vpZl+56AUJfTWJOn/LifNwJPPTHXVffjK+JTFjQmrTpEutPuqvXifkX34ml+syewo=
X-Google-Smtp-Source: AGHT+IGtmOX3+9Q+D1QOeqEOX5eNOI02LOU7Yq3Bw6OvszPWupVsKVy6U45+MYtryud+zftEeA9oJw==
X-Received: by 2002:a17:906:4fc7:b0:aa6:6c08:dc79 with SMTP id a640c23a62f3a-ab38b42d8f9mr198627666b.35.1737112954097;
        Fri, 17 Jan 2025 03:22:34 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2244csm155250066b.92.2025.01.17.03.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:22:33 -0800 (PST)
Message-ID: <5e1012bd-64e8-45d5-a814-836195fc46c4@gmail.com>
Date: Fri, 17 Jan 2025 11:23:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/17] fuse: {io-uring} Handle teardown of ring entries
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-11-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-11-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> On teardown struct file_operations::uring_cmd requests
> need to be completed by calling io_uring_cmd_done().
> Not completing all ring entries would result in busy io-uring
> tasks giving warning messages in intervals and unreleased
> struct file.
> 
> Additionally the fuse connection and with that the ring can
> only get released when all io-uring commands are completed.
> 
> Completion is done with ring entries that are
> a) in waiting state for new fuse requests - io_uring_cmd_done
> is needed
> 
> b) already in userspace - io_uring_cmd_done through teardown
> is not needed, the request can just get released. If fuse server
> is still active and commits such a ring entry, fuse_uring_cmd()
> already checks if the connection is active and then complete the
> io-uring itself with -ENOTCONN. I.e. special handling is not
> needed.
> 
> This scheme is basically represented by the ring entry state
> FRRS_WAIT and FRRS_USERSPACE.

Looks reasonable

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Entries in state:
> - FRRS_INIT: No action needed, do not contribute to
>    ring->queue_refs yet
> - All other states: Are currently processed by other tasks,
>    async teardown is needed and it has to wait for the two
>    states above. It could be also solved without an async
>    teardown task, but would require additional if conditions
>    in hot code paths. Also in my personal opinion the code
>    looks cleaner with async teardown.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev.c         |   9 +++
>   fs/fuse/dev_uring.c   | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/fuse/dev_uring_i.h |  51 +++++++++++++
>   3 files changed, 258 insertions(+)
-- 
Pavel Begunkov


