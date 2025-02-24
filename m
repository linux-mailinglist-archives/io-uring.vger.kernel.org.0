Return-Path: <io-uring+bounces-6696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C07A42C67
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9836D170960
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5FD2571B6;
	Mon, 24 Feb 2025 19:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qb3KCe6e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D50B674
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424224; cv=none; b=Z2OYfDXgnuSqdlDJNzQnxqaBJJtvB+lw3iHC++Hwqgu1xDgTtCTloGvEHAkza4kDgPzDgTT8StpCe0TeCqqKlJ2/ICm8JInaGvYAMSbsB94ey+KqQGZFRdMfz7RpYEoS66KxVquJeJfGv7AMuZpH4zX+AqkD0LzMvYFkpf5DBko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424224; c=relaxed/simple;
	bh=i2T6gNXTDl325V79np5whHJFXBpriHDQez+8rSlW5hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kdwkh1tlE0uyzznXvuEuYGr8369+5i3B31EH0ULtNlqYjqGRGUwtxkcc5ciW1DD0BNPLpsFTKYAy2/whXIakuZaeDruuxzHTvpDEshLI9d5JT5skJm4/vtAuclGX/uHyRMe1Ik3MOm68gBDbbQZ0nh8q528dyyV449tszIyH7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qb3KCe6e; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-439a331d981so41686155e9.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740424221; x=1741029021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7GZ+bXOm4llmHFI19nn2ZrZoMccW7yjRL+zBmnGud8=;
        b=Qb3KCe6e07AKPicCbBYZ9wG6RQZU1KYnIr0tWTi/6fJmum+safXTfD5jXx7jwWnKE5
         Vhg7AybRqFETVbz6AH4FcbOMsxdP+i8jziDnn9zPC0wuv8IP1Fqp6aevLzXUCsnyB/Q7
         FkfdgUTT20oDLjTBtJ1xS6MWqvB+sNcgKgV9NtUhoN76aTCnCX2SAqAZuSrG7kIFDtPJ
         U0MSR1SZoFx7oh67RonFTgszUhiHv29UfpZTeuinxVnwt328gJkZxX9CN3adX65GAhe0
         Z81viicavDjPAA3r3EbrKeWTp8PlzQJqZvvcGE3f5sV1YYaey98Egb//qhPvrSuFGoOH
         w0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740424221; x=1741029021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7GZ+bXOm4llmHFI19nn2ZrZoMccW7yjRL+zBmnGud8=;
        b=XFh/ENaUCNi/gT9IZzWrfDUNmrikvec2r/3q7to1rhusZNgM3aM6gwNXap2bXEuQPF
         MnsbwIesyj2f+I1AbrrragPdJNOE8UlUFH8m679xqQjeKKh6JcGy/JDk/sDqcojlXwDn
         LJh+OIo68tzOa/3T9uLYzMkGqxbWZLfLySQ03cbizMlW1unhR6u8aY78q5D7aaI7Mo6R
         pixAT8M2AFND8MRg87gVKQB8NwgK0PFB7ufAD6DmILXJzi1UEd5xr0DuibBoRgXufQvg
         +X5CpdPEYhohTXTLMQdruJwGuevrr/eDyvvDyBQ+6BoW3GJ8lfqisyJS1poOMsh/SILQ
         dRHA==
X-Gm-Message-State: AOJu0Yzj39hO59K2oS/BVTdS3oNbz4gsFAj3TcLHLQkj/Qixf17X/Xb6
	O0QggraQ/f5ABlA8hWO1yCUvU6rpDBqCiaNlmtHhUG46MSgEUI2FCw27bg==
X-Gm-Gg: ASbGncuLi/pIwLcJbdOAtcNXCVeIAP3urjhbPAXa1BTgiatN6zGO0tRHVXIv3c5Tm8n
	3plrZFrtGDn6jo5p6tFx5IOARX59dETbBggOWsIpN3DZp4rFMeLMrETdKXifb7jcQT46Za0DvMo
	gy3X+P6qRkuJaU0PayktVpucn2myqwwYQzU+Fz+1YwUi1hjjdsJ3XkKu7O9zUTeh5HtQYf61/UN
	tAJqNn/jHwP5LU3gO2830AOUAins2Xdd/oozXN5qqyXIu0YHx9HbJLgkKR9+SKpBXGc/sRGszfl
	B/rIuvWKdz2IjPi13SBm92f7lJnKkdSK2RE=
X-Google-Smtp-Source: AGHT+IE2RbaEDG11OH8ZxBIx4IV8gyhuGYcVFlMWpaazkuvDE42kJ4CdRGQ4vYMGQS9mW2FVJtznHw==
X-Received: by 2002:a5d:6daa:0:b0:38a:87cc:fb42 with SMTP id ffacd0b85a97d-38f6e95d5famr12488795f8f.21.1740424221066;
        Mon, 24 Feb 2025 11:10:21 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab155eb6csm263285e9.31.2025.02.24.11.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:10:20 -0800 (PST)
Message-ID: <7aaf635e-8c20-40be-ab6f-383024b07576@gmail.com>
Date: Mon, 24 Feb 2025 19:11:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] io_uring/rw: extract helper for iovec import
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1740412523.git.asml.silence@gmail.com>
 <5cf589c0efb611bfe32fc3b69b47d2b067fc8a65.1740412523.git.asml.silence@gmail.com>
 <CADUfDZp5FJ52F4SUejCcXO4YzM8r411_MwT3sRRTWQBeo89pmQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZp5FJ52F4SUejCcXO4YzM8r411_MwT3sRRTWQBeo89pmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/25 16:48, Caleb Sander Mateos wrote:
> On Mon, Feb 24, 2025 at 8:07 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Split out a helper out of __io_import_rw_buffer() that handles vectored
>> buffers. I'll need it for registered vectored buffers, but it also looks
>> cleaner, especially with parameters being properly named.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/rw.c | 57 ++++++++++++++++++++++++++++-----------------------
>>   1 file changed, 31 insertions(+), 26 deletions(-)
>>
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index e636be4850a7..0e0d2a19f21d 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -76,41 +76,23 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
>>          return 0;
>>   }
>>
>> -static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
>> -                            struct io_async_rw *io,
>> -                            unsigned int issue_flags)
>> +static int io_import_vec(int ddir, struct io_kiocb *req,
>> +                        struct io_async_rw *io, void __user *uvec,
>> +                        size_t uvec_segs)
> 
> Could use a more specific type for uvec:  const struct iovec __user *uvec?

Indeed

-- 
Pavel Begunkov


