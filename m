Return-Path: <io-uring+bounces-1841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA4C8C10C3
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 16:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 781F2282D5F
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 14:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAD315B57A;
	Thu,  9 May 2024 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="00VbKfdj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671215B556
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715263355; cv=none; b=VNg5qx+fU2qWwjwy/99ZTkuzjisQsFarwjje3cROjzBzfV9glucNIrzSKd8oC+w/+qGYoLCpJdtTmzRwncpTl2CBFkH35GWEe8KrG8scZDWAziRs0m8IUL7K4eYn80bcqpQUuy4b6DuiC57DWtDcIiMXavxIry3dqhDhdiBd9S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715263355; c=relaxed/simple;
	bh=J/4CoO/cE3YT4ZlZcc9PLOaC0qzwXov0buB2ChLQI50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPnxTd+6OaOh2A7um/uDuC9UOQkSmoqOYXPLPJykkssmRk4xvXsRAAX8d8HMytjWZzzNlbZkDceEOqWBqgGTVLDWdDOm+bCsDgr+pOnkZ2RYXg4xk6bTasnStA8sj3VtdrbS9Hbq+cnLANkAy3Jnwb+Vb8pvdC7Z9T1iTXDTblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=00VbKfdj; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36c86ad15caso885425ab.2
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 07:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715263352; x=1715868152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jk6Y3LPp6pG1saX8FdM1yjsulHIvf5O8mkhAYY5EMoQ=;
        b=00VbKfdjceAJ+IjFiBVbZ4w4zDj2/bYpl1jLG39iguEFVJuK4DA4SlRWXv8CWH1YMC
         JdU9hR6cgxHIXtFsAA18flUVopMSYbVCv+vlQt0ax/yRWUulDQfsWXfDfAZdwPHLLrlq
         FkOwQOZnua/0DWu7WDDFru2IQMH5ML0XE9HQ1KiftCorjSbnPX5eKKCq3/Tgn7GcqNt7
         f6E/LeA0pZR2kikHSa9Y/End9SeLBbhHx1bUlxUf1XFPr+HpoUJCgyz9a2xrMN7CAa6n
         P5JjSCteYdZK60fsBlRc511tC15Xz5jDqKpCcWMdOnsei97cYf1W+vFfMggBRZjaOmjB
         mRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715263352; x=1715868152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jk6Y3LPp6pG1saX8FdM1yjsulHIvf5O8mkhAYY5EMoQ=;
        b=hOeYjA7qik8lvVAoW7U8V8buhJT+1+QelF1Nu7VRFtf4Gbu6caHli7ML9sWAl+LC9r
         bgtelqbih7iniEYuNRpdCec6zA6E8dlMIJR48i7fxie+WNCKnJwk/6cDauzk5DARSwal
         mbnRKO3JWd9SvaESUI2orXAS2rODUpIM2ioHltu8LQr0xd+j8rr18GqWAwZ09c7I1pkB
         NVKJfWNubdKnf/mELPhiEC5RsqHyewCNlwJQ3/oT5p6QcK+p0Fwf+nrq6RJvQBuDEUVz
         989d0fqzF96XY+CKnhtWY9Lh5MBwdT+YsvX6JbZqxGqOiiq9tVDjrRHjhgBUkhpM+xZr
         Fmrg==
X-Gm-Message-State: AOJu0YzRQ7EFNwFlaLf+iz+kbIPUYOCQErEn6VRqLTQA6CK1EeghMvhk
	Y+hlujyUic2gAZEWZPvRFOYqpmFP5QTbGWhranZC+xxfYgal5KXFagGWA++gwj8=
X-Google-Smtp-Source: AGHT+IFP0Ehth61IwqAU/CIMreYMy+dvJlAKgsbeyUjqY1TMkpjfEKLaRO3DGoaS+vvAoip79Q0Xyw==
X-Received: by 2002:a5e:c247:0:b0:7de:f48e:36c3 with SMTP id ca18e2360f4ac-7e18fbcfea1mr596995539f.0.1715263351962;
        Thu, 09 May 2024 07:02:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489376dcbfasm369193173.132.2024.05.09.07.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 07:02:31 -0700 (PDT)
Message-ID: <bc1750a4-10a4-463c-b5d1-600b385525f1@kernel.dk>
Date: Thu, 9 May 2024 08:02:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add IORING_OP_NOP_FAIL
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org
References: <20240509023413.4124075-1-ming.lei@redhat.com>
 <1f411b88-f597-40b0-b4c9-257b029d3c9e@kernel.dk> <Zjw9jIHtan4FAc9D@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zjw9jIHtan4FAc9D@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/24 9:05 PM, Ming Lei wrote:
> On Wed, May 08, 2024 at 08:55:09PM -0600, Jens Axboe wrote:
>> On 5/8/24 8:34 PM, Ming Lei wrote:
>>> Add IORING_OP_NOP_FAIL so that it is easy to inject failure from
>>> userspace.
>>>
>>> Like IORING_OP_NOP, the main use case is test, and it is very helpful
>>> for covering failure handling code in io_uring core change.
>>
>> Rather than use a new opcode for this, why don't we just add it to
>> the existing NOP? I know we don't check for flags in currently, so
>> you would not know if it worked, but we could add that and just
>> backport that one-liner as well.
> 
> Yeah, it is just for avoiding to break existed tests which may not build
> over liburing.

Don't think that's a huge risk, if someone is using the raw interface
and just not clearing, they would run into issues with mixed command
usage anyway. And a pure nop test would be fine anyway, as everything
starts out cleared.

> I will switch to this way, looks one-line backporting can solve it.

Exactly, thanks!

>> And if we had such a flag, the fail res could be passed in as well.
> 
> We can just pass the 'injected_fail_res' via sqe->len, meantime keep
> 'nop_flags' for error injection and future extension.

Precisely.

-- 
Jens Axboe


