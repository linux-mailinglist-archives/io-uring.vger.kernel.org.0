Return-Path: <io-uring+bounces-3563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79200998BD8
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 17:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AC811C20D72
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D0B1CEACF;
	Thu, 10 Oct 2024 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QdldYPFs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397A21CDFD1;
	Thu, 10 Oct 2024 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728574526; cv=none; b=P2TVeSvUMzjhlFfxk/NPMrdH0WcdS4RRY02YZwQh1MLqmEfaBucNRKZYukbEizcWFZmo9NFwQDbGLZSxcZL370mOtGb+gXRah1hg9ubLjxBeWnpNzSw9sByO62+ImzTiY5xEywzjesziCCW3i5FAlJW0gFytgXJpnLXV6mNJS3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728574526; c=relaxed/simple;
	bh=lK/FbI9rhoOQXQ66duEZbVUorkX3hB2FZo+hDnhn3ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ip4Iu2e2IDPEiDLBFxl5/RyPQrixh8LP2Q8GyBEMjbEXf1DlCllVDuGujteZFXfZW/fI0VPhtxEOXrmB+tXBpDATDpGcpbi5zFJcna6D6rVfPv+KthCxjsPf0MaPuS2RQTPp9QRpeSHZU9s6TCcXFS5rsvDdK74GWGQFz2or4C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QdldYPFs; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c42e7adbddso1306041a12.2;
        Thu, 10 Oct 2024 08:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728574523; x=1729179323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ha1p6oZOz4NV9Kh6FmrRkFkknVIK2uehqmbeLM8+Rs=;
        b=QdldYPFsf64lKRpiiRz8dn82YZPJU43bgCddQbYJhZmdBNm5m84kzepY/u4D+JevaB
         jkdoTtb3Fl5p2BTWx4rqd5gAev3VhtJKJV3cdsjw/+dBDynoRaruG3F2ZKHVzvDPTruO
         TZ6zgfLMM0bpxKcVpiSASNoFAKFJjZ0DgQ7AneAkamPwxq/9ud2qFC16Pij/S9qbXjmu
         puFwzFlBlEXdxnRb/epnjwPspmDwvWqrqCddp8hKUNspVQyeyVvLrtMnn02t5Bttea2u
         rJqc+NAJmtHZizjiZ8c9P1vGW8McS9l43pe4/q0KByt8CXzXC/Z+YB4BFXzJqg2TTbg0
         1T3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728574523; x=1729179323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ha1p6oZOz4NV9Kh6FmrRkFkknVIK2uehqmbeLM8+Rs=;
        b=o6m38RBDKCmblhGYSEwOLLllLkhkVX+yUFWP4e6P0UXGgV1C+AzeBNFhrFzz3sFDHq
         xtwF6SaQO2V4gjknVs7Iq2VlyxPQIW4uZ+7KkW8KxtZd9uKIupA/fMqn7M9+9o56ZrVt
         V886VTgAWPKzzHqQsS9zm4OFdYYQDhpw2bFSVgbqkvfyiLih9/vFlIrfD1D8ib77Q8TY
         9imlVa1yHVSdg1y3oY4xOxoRn5+zLII+ahAMXHV+Z1osJ23W9IbgvV/zY9PIDpVAHGsB
         Rfv5uxRy3hy5HHaKPYkZXaWuC5z4+K7Tk8feAh8gLoGUufluUmOqILAyXp5q+2UytAPS
         8pOA==
X-Forwarded-Encrypted: i=1; AJvYcCULH5FRnhdw3VHS1Nl8qBO2m9NaXi0of9BtxRrtR29k1RBRuM/A3FTcCB00Q116XeeMY1X4pteBklZF9t8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjrk4AKGLgSeaeRe8v4QvhH+h1M0gE0otMhQiR1mdO6iL7KNVE
	99HFlnlnehcFsQLlvDLKk9n6XJdo1cPh2rXXzfN9ptAup+azVUaJ
X-Google-Smtp-Source: AGHT+IGy0n4mXRI86DwVdcVDYHqAOk08VGEGFrTrc0R72zh/i9vwKAdgBzONBdcoCZt75ayW5CCF+w==
X-Received: by 2002:a05:6402:26cf:b0:5c8:a92b:b0a with SMTP id 4fb4d7f45d1cf-5c91d53c982mr5579708a12.1.1728574523269;
        Thu, 10 Oct 2024 08:35:23 -0700 (PDT)
Received: from [192.168.42.29] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c93715159csm921751a12.42.2024.10.10.08.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 08:35:23 -0700 (PDT)
Message-ID: <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
Date: Thu, 10 Oct 2024 16:35:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
To: Ruyi Zhang <ruyi.zhang@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com
References: <1f21a22b-e5a7-48bd-a1c8-b9d817b2291a@gmail.com>
 <CGME20241010092012epcas5p2bc333a1f880209003523e71d97ba3298@epcas5p2.samsung.com>
 <20241010092003.2894-1-ruyi.zhang@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241010092003.2894-1-ruyi.zhang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 10:20, Ruyi Zhang wrote:
> ---
> On 25 Sep 2024 12:58 Pavel Begunkov wrote
>> On 9/25/24 09:58, Ruyi Zhang wrote:
>>> io_uring fdinfo contains most of the runtime information,which is
>>> helpful for debugging io_uring applications; However, there is
>>> currently a lack of timeout-related information, and this patch adds
>>> timeout_list information.
> 
>> Please refer to unaddressed comments from v1. We can't have irqs
>> disabled for that long. And it's too verbose (i.e. depends on
>> the number of timeouts).
> 
> Two questions:
> 
> 1. I agree with you, we shouldn't walk a potentially very long list
> under spinlock. but i can't find any other way to get all the timeout

If only it's just under the spin, but with disabled irqs...

> information than to walk the timeout_list. Do you have any good ideas?

In the long run it'd be great to replace the spinlock
with a mutex, i.e. just ->uring_lock, but that would might be
a bit involving as need to move handling to the task context.

> 2. I also agree seq_printf heavier, if we use seq_put_decimal_ull and
> seq_puts to concatenate strings, I haven't tested whether it's more
> efficient or not, but the code is certainly not as readable as the
> former. It's also possible that I don't fully understand what you mean
> and want to hear your opinion.

I don't think there is any difference, it'd be a matter of
doubling the number of in flight timeouts to achieve same
timings. Tell me, do you really have a good case where you
need that (pretty verbose)? Why not drgn / bpftrace it out
of the kernel instead?

-- 
Pavel Begunkov

