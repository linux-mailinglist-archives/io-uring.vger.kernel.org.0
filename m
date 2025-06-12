Return-Path: <io-uring+bounces-8320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA96BAD7332
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 16:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A7A87A51A1
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 14:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595F1248881;
	Thu, 12 Jun 2025 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jLMaqWT1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16117185E4A
	for <io-uring@vger.kernel.org>; Thu, 12 Jun 2025 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749737179; cv=none; b=EpY864CtB1f/s52ZGt+6meVxQdlCov4jUi6nZJre50s1eAIz54wnbuA3yGGP1MMnnrifYfD7ZztzqwkoDDMZCcKaclhDZaZAUAn+ehSjZ7LBZ003fF/rYbfzWD2yvRm0nDABN0PYFb/Yf3Q42gz8CTOR18/ZiC/GiXVMXFstDUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749737179; c=relaxed/simple;
	bh=4ChK7e4PZIbGo6yIhGanb9DQUsVcV2UEtIFr/3kfE74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gG1cVpkZd3mwmHGgHMXzAWUoHrTB6V5nHQwkrC9hvU20WGBL+B2zBz+QMi9lFryydzBMsJyQMRhdr2wFxq9Zer/87vdKg0tl3Am5aVxTUu+d8gkQJVA0uOqqafbT+glxaRr3IMiGOdFdNt5a50R4ENE7buSw8U927oY8vm2APwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jLMaqWT1; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86a052d7897so87994239f.0
        for <io-uring@vger.kernel.org>; Thu, 12 Jun 2025 07:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749737176; x=1750341976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bU6I8KFtIF7gtlB8ZnFNNleYs6udjVIddSeSWWR+RTk=;
        b=jLMaqWT1BEgl0/V26AQ6QvbOzAwrlSs6JmaTA/YqKMgf3CGUpUJey8j6TYA9+bpF6z
         hrHwFR4BplAvwb3U+OE70O4z2OhO4kfFkgBuiktW+5HKHPK+7FEwEd6xn4DMoJG1CCMi
         4CpqQM37OLf3pxLphThmlhZSMVQnbiAPEalhpi6g9LSChwx4vATi7FTQiCwH/bItCC4t
         OWfVrrWWKnksu6ZmXeamxhTmFU9JciUVqNXwJnhHasBMiG0a12bgqImDxEPgi1bk5smP
         SOg+sxWUzPwnh2Q/DyLroiUYLmIgnFYbiLGwEJL80pU5XoQyfQyIieOmWomvjYZODEqP
         5qKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749737176; x=1750341976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bU6I8KFtIF7gtlB8ZnFNNleYs6udjVIddSeSWWR+RTk=;
        b=CtjsFBUbt6f9rKEsHWmV3b9jSzjT7tWJe8H0F7spnudRf8GRdv4qdvHYD3Af63maMn
         pAVH98IZe/T3ESE8JZJyFq15Q7MJrLkIFs5P1HHfdNzGEaMWc7uTvo5EDhOazcyLZFcy
         DB924Xl9eJnjzrJ7k4fYZ+ZPR8uDEpuSrI542aoRWEqFkGiG6gskNlZnNnjdYK8GsmHQ
         F7lXhjm6jBuIzOWJfYKMLNTUixzgDU2Vs4R7/B555ek0jFiS69xhZiN3JaSxJozY98TD
         2CvaPgljFYuow9LSryrSOvccQGR23gCepQ/c7BKEfyeWRla3r5CB3Tg6XU1uJfdaQOst
         K4dg==
X-Gm-Message-State: AOJu0YzJJ436YxCiDzcgcxcstvTwfUh99XGoeSY6GuIRe8N5ivmTVPoQ
	Hh/gUDgSTiJgjYN7xiwuNTtjyc3fbY6mKlqbR4ksB80GzPr+wp1SwNmBLGOU/tKdD6Y=
X-Gm-Gg: ASbGnctjBC07F29yYXgw2LnbBMENW1Iv9wkliv8BCMKjcI4YC9FACS9sXoTeAkINbCE
	flZMqAEZNMMg8q5kfY4l8vhF69Q3MQzUB0iXOBEspYvgOh0GCKLFXZGRHQnbcy814vpIiWdHjQn
	f1vHD9HCJC82TK1MRM12vDTdLI/BnMPV/eQZUUyaGetl/oIB/+g362+yYWYyAOZyLRdurGqnhUL
	oAE0kt1e1bAuNz/COgJsRiy1+UfI4fPzpF1asRq37TjbjfIg/MHPT1G7OwT+kyT8JuP6xO3kkHa
	M6VXKolI3H48Kdyp9OfFwxXUc4dullj7u0kqDV8EVJdF0juE4/Hxjy94oWA=
X-Google-Smtp-Source: AGHT+IGwa/W/bwZ6mhkAXRr6G5LVK0LhE+hanV4uE2MJO+JAFyftWu8co4CAKe/KphaDCpHFbCPT8Q==
X-Received: by 2002:a05:6602:3a03:b0:869:d4df:c2a6 with SMTP id ca18e2360f4ac-875bc49bbd2mr915998539f.14.1749737176105;
        Thu, 12 Jun 2025 07:06:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875c7f64de6sm35469939f.33.2025.06.12.07.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 07:06:15 -0700 (PDT)
Message-ID: <e6194c29-18de-4dc9-a2fb-2ad63816481d@kernel.dk>
Date: Thu, 12 Jun 2025 08:06:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Pavel Begunkov <asml.silence@gmail.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
 bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <cover.1749214572.git.asml.silence@gmail.com>
 <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
 <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
 <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/25 7:26 AM, Pavel Begunkov wrote:
>> For next revision please post all selftest, examples,
>> and bpf progs on the list,
>> so people don't need to search github.
> 
> Did the link in the cover letter not work for you? I'm confused
> since it's all in a branch in my tree, but you linked to the same
> patches but in Jens' tree, and I have zero clue what they're
> doing there or how you found them.

Puzzled me too, but if you go there, github will say:

"This commit does not belong to any branch on this repository, and may
 belong to a fork outside of the repository."

which is exactly because it's not in my tree, but in your fork of
my tree. Pretty wonky GH behavior if you ask me, but there it is.

-- 
Jens Axboe

