Return-Path: <io-uring+bounces-4130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F348F9B5000
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80D82B2316C
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB8C1917C7;
	Tue, 29 Oct 2024 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="At43ifBd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9276198A07;
	Tue, 29 Oct 2024 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221254; cv=none; b=ujJhoRYdutMNMccAZ8q7FaCUjv4xcP7m8WHOyMFdFayjuUMWvlUeXxiBNIwJ046XsM+8K2KMnlexIV4uF6tTgvxmlA+vXZ4BnLDBN5YYluAoqRsu2FNtZ4ZrvnX+cRX9XdlzO3GonRbA0shQXcld1BrvwqNn9MewjHnRfYBSk8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221254; c=relaxed/simple;
	bh=9k2dXaA4ejieLq67aSzQEryCTxdJjykltyxZJka76JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NBI6l1WB3LQIZZJYfGZ511dRuRuAPlvM3faSraj61SjLuwjw3kH70fmwJLJllRVDOLl7JZPWrxD8dS0ZApkpe0efvWBufvfMAjIm7Ez7bIvEsZkh3hsyy/nkSDT+9PxPFWyz8U/ULprIKzxjqorzi01w51nw7SC324n9RJ8mfr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=At43ifBd; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d462c91a9so4086720f8f.2;
        Tue, 29 Oct 2024 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730221251; x=1730826051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NcHZRXwwbzOwt5fnhWSn9bTm8JE1mdpbW6MkLse8x2w=;
        b=At43ifBdKKhKEWvi07T37y6KALQ9dJ0KWeitERat+PUOR9mL1ee7LlZxDLqbMJIfPC
         kDZOhmnrhPBY2zl1qbSnVjOSo/qQ3kV7bgU2AEZwj7GUh6DoSlniOEpYsH3Gy29Hjvzc
         yR+ishF2KnHVoxWnjkOxP5FOcGkge4niMQZjFGCl9rUZINyCbG2+dlefzohOhPQScWbz
         Fpp7dpaldqKuBk9WFjMUPgTZEhfDMw8RcbIHU+AYAMQCskQZKRjEUYnPBkObpCASrVI4
         NT2TRr7UvHCSfeI7QdOvQ29dDiJYY4Vj8jEggXiewITTESBpv5N1cqZF11XpnJLUVrBe
         DJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730221251; x=1730826051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NcHZRXwwbzOwt5fnhWSn9bTm8JE1mdpbW6MkLse8x2w=;
        b=cpNfyixIJ1HjSFw1g8OcxD29cljI/k4xY0Wrl1esWvIaN4JDTdfY/3a7v/2ryW4r65
         2kWYUuVi4UWmHzuasqfbRydCciMHTjNPA6+W4AjKL6X17EIAmC9NsRiS8F2zvs4yfb0z
         V6V2QoraZi1Ss41nDKX3cAnCY648JDbWPToL2cJX5uqXcKuThEAkTfcQ+ayBRbBVUXpL
         xfko16A9kXZaU486GiGyFG66XW9UviH9ViMF1NL9wdDVtD37fUwvq2tCJvGEOBY2LihU
         W2zVBrR1MRZnBe+cfRb+48FWFSaDvY9LHFI434nvJsIlCiDj+d+BE3yA8Br07mEW+KN7
         afqw==
X-Forwarded-Encrypted: i=1; AJvYcCUL42y2379/ZnpufXDIBfxjJoz6uK4nVWCAemCMqgGO3FesQbUKCiTUp8U1QsxVnGjPNxlTvzCgeg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2FlG6GJ69ReBjXcxbhDabNlFr0XK12m00/JfZLyqLmu5SF5Sq
	o8KFMfS2DP4rX2lEyHr9GXlmJ7FQNRkr6jSqvTEqanLsg84pdqFt
X-Google-Smtp-Source: AGHT+IH6cqDsb0qdCbJ8u0KrajBv7kge5Cl+pQKSNUH4H/HipsbLnzSGCN/Kboux0qK55PwKHYrxqA==
X-Received: by 2002:a5d:5749:0:b0:377:6073:48df with SMTP id ffacd0b85a97d-381b710fa38mr222839f8f.58.1730221250346;
        Tue, 29 Oct 2024 10:00:50 -0700 (PDT)
Received: from [192.168.42.53] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b70c44sm13025022f8f.80.2024.10.29.10.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 10:00:50 -0700 (PDT)
Message-ID: <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
Date: Tue, 29 Oct 2024 17:01:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241025122247.3709133-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/24 13:22, Ming Lei wrote:
> The 1st 3 patches are cleanup, and prepare for adding sqe group.
> 
> The 4th patch supports generic sqe group which is like link chain, but
> allows each sqe in group to be issued in parallel and the group shares
> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
> sqe group & io link together.
> 
> The 5th & 6th patches supports to lease other subsystem's kbuf to
> io_uring for use in sqe group wide.
> 
> The 7th patch supports ublk zero copy based on io_uring sqe group &
> leased kbuf.
> 
> Tests:
> 
> 1) pass liburing test
> - make runtests
> 
> 2) write/pass sqe group test case and sqe provide buffer case:
> 
> https://github.com/ming1/liburing/tree/uring_group
> 
> - covers related sqe flags combination and linking groups, both nop and
> one multi-destination file copy.
> 
> - cover failure handling test: fail leader IO or member IO in both single
>    group and linked groups, which is done in each sqe flags combination
>    test
> 
> - cover io_uring with leased group kbuf by adding ublk-loop-zc

To make my position clear, I think the table approach will turn
much better API-wise if the performance suffices, and we can only know
that experimentally. I tried that idea with sockets back then, and it
was looking well. It'd be great if someone tries to implement and
compare it, though I don't believe I should be trying it, so maybe Ming
or Jens can, especially since Jens already posted a couple series for
problems standing in the way, i.e global rsrc nodes and late buffer
binding. In any case, I'm not opposing to the series if Jens decides to
merge it.

-- 
Pavel Begunkov

