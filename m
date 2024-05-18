Return-Path: <io-uring+bounces-1930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DD38C8EFA
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 02:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2C022820D4
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 00:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5CE637;
	Sat, 18 May 2024 00:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="TCWxKgnZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F52624
	for <io-uring@vger.kernel.org>; Sat, 18 May 2024 00:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715993555; cv=none; b=ZZj674nYDhnhCjl9A/rkM7+uJLqaopS9jowROLqNnpGPTNJ9DwvdQmwu6fvr1tb3jJMbmJkLsTVQA41rO7HPA+j0tIfXe7LeIi+D5YLlvyNBmm9IcNjdHdUYJh1kyGgAnkRCnUlnC+fB1qXXtXzHywsFe/72bRF4POiJIbNBjM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715993555; c=relaxed/simple;
	bh=fXse41TXriAJjyQjI49JVXR03cQ+2VDqWYQQlvaCirs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LTy4K6r4tTKMn17vzz7dI5j//FBOUP2hZVM3DIFQve18q1yD0xc/DoOpOuNfB2fZNuz54XPWVZxOwYwN16skJSN6eBuJhy3B1dIx3kv2IUKQPUFr/TmbXvFt1tqtND5uq4fuKQOUm36WKKz6X890t030jt7aQ+gmVKDFyDExQMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=TCWxKgnZ; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-23dd94111cfso1037461fac.2
        for <io-uring@vger.kernel.org>; Fri, 17 May 2024 17:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1715993553; x=1716598353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xfmreaTtNvmFqRFO1F5cr+T5NLKnxNPnIjqp2z7i/vI=;
        b=TCWxKgnZan6gt5wm2d6mbX2UDlnRtquRpme5XqpjkOPa7jsa13gUViZFBVBoBfN8AJ
         SDccc/5uoUaB6sV+nDRFUJ1e6sds2scFvr23oowBXlc8YdPUnVtLs6W/+fqNY09jBb6C
         tNH0YSEM7KQMQ4Bfdfv2nzXBpG9Csrml+m2J7INLnxa141BG5N7fIIyR4WyVf/yhjYpT
         Mc8vmRmy+dfcTZ+bpWn4R5yFGdl2qlwZyzJEG5ouVFbvKgPsVlCg7qZ1flRMJQ8t9hfd
         gRzUVeAI4k8vJWsl62IRyyrPcE3Fui4fnao9JRbHsa+zGHXPCpTJaGYiDiFN/X7uhnph
         /w3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715993553; x=1716598353;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xfmreaTtNvmFqRFO1F5cr+T5NLKnxNPnIjqp2z7i/vI=;
        b=U/93u3I/+M7b4uLt/6ev+WD0SL8ZvN7FzcJLm27OVO2eJhEINylEErFr9AXGivbPSA
         XZKaM2G3ilp8k2UrRx4vvtgcMHyTCN+0y3knj0Mp1qlzGYz/lY/27YDgd1DxmZC2e7fk
         KJLiMvByizisucGfsQFg+gYsdKbvp1UAlK8HiT7+//Q5lwbp3QNOQ4/Ned+dIQEVtdZG
         QRoseYIloFBaLx/nAayAv31pbeBdWrPtwLpUl5nXXloxzq3iqJEXvQ8vWoWlyvMhJgUx
         Y3gKg4RbhYfjSXvWM3mgN+9nRmJ35VvkF3UJLdf6JkqYgBBKW6pWJb94klG/m9AmAw7A
         B7Ug==
X-Forwarded-Encrypted: i=1; AJvYcCURVlyzsSvesa8TOqZu1mftklsCTDgNh3ScgLUbhOnx7+KGs1F9PPoLaiu9kHcOvHBcVhQd12JXGVKDqz9hNibbmwxkdKxwBJY=
X-Gm-Message-State: AOJu0YyyRpxpe+0IUI7EjhonzlW6NFX+jluoVI5MI2rdaRMFKuKGgP0d
	WwPzfwvsSh4zxAXpBogFCG7zbezy3bNrTmjOgxCGFP/aOmgJvhHQdG7MTkvNWmTVBev4OLDJGgV
	I+B8=
X-Google-Smtp-Source: AGHT+IHaL60kWxIw+oC5oD219ZJ5DvKb/ueWDTGm8wVIqh1MaEmPtBirlqYb2OSROSf9ydpgJvtpew==
X-Received: by 2002:a05:6871:4ce:b0:22a:4c6a:39ea with SMTP id 586e51a60fabf-24172a68171mr25447815fac.14.1715993552996;
        Fri, 17 May 2024 17:52:32 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cbd:da2b:a9f2:881? ([2620:10d:c090:500::6:9fd9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f694647472sm1547571b3a.199.2024.05.17.17.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 17:52:32 -0700 (PDT)
Message-ID: <740aed6f-2ebc-4ad8-807b-bf1cef719313@davidwei.uk>
Date: Fri, 17 May 2024 17:52:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announcement] io_uring Discord chat
Content-Language: en-GB
To: Mathieu Masson <mathieu.kernel@proton.me>, Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
References: <8734qguv98.fsf@mailhost.krisman.be>
 <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk> <ZkfZIgwD3OgPSJ8d@cave.home>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <ZkfZIgwD3OgPSJ8d@cave.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-05-17 15:24, Mathieu Masson wrote:
[...]
> Not to start any form of chat platform war, but the rust-for-linux community has
> been using Zulip for a while now. At some point they made the full message
> history live accessible without an account :
> 
> https://rust-for-linux.zulipchat.com/

This looks and feels more like a chat/forum hybrid with discussion
threads etc. I strictly prefer chat's lower friction but understand that
it makes it difficult to archive vs threads.

How are the threads created? Is it done at the start by the author? Or
can someone just type and start a convo in a generic stream e.g.
Filesystems, then an admin later groups the discussion?

