Return-Path: <io-uring+bounces-3182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F46976F2A
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE0B21F235A1
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F891BDABE;
	Thu, 12 Sep 2024 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpjrmvtQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C01BDA87;
	Thu, 12 Sep 2024 16:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726160011; cv=none; b=LevQfIvSxgNgpf99qkNHSDcgfbqsejQ5MqOOcZjPHbl/ZP75YgDhLuML4MjM9hbQ4Pl7NPDSQEBScqdn0BX0S7cA0N3BWaau3+DEvyDTqo0TiT42ry/b6cdu5iZNaAYr4hwpXu/DTjd6DuTbmGVwcwNZcymf5znXBwfelnigLBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726160011; c=relaxed/simple;
	bh=OZQKVyVkZOxQEHwg3MOzLA7aQtsHzkXXM8L37Sdii9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=My1h/g/BG533e4fUdgZOPMSgwN5Z5Cp/vrIWKkCtWJ2ERznBFPA9jb1VG0TtNyH6htxGb9wWPcOTBrE5DoFE3MdI7SYsXzzdfdv3XhxKVZVM02205WdvrQq3SpjjPo9wQynqAwAh6o95fWl8grEeyhYNCpjLz13W53CL34+8OAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpjrmvtQ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-374c962e5adso774843f8f.1;
        Thu, 12 Sep 2024 09:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726160007; x=1726764807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3+TMXkLYIBdYwWS5zoZpThaARY3AGh3Sj0RZ+lAi4Vo=;
        b=DpjrmvtQz3dZM+gJXjpApJQ19GFVDFh6zyNP6E7WDwVyx4w4rQWmfaGFXZkPA0byFq
         Bx3pJEHgwiumMPqBCHzsYS+LWNkLOUxvSNc35SDwGedlak3/ghoCvpEcuR4w+PAlr8p/
         dVBH0MvupSaSXGM6PDWp2gXm+gzG+oKhTZDlHS01xIhiy37IK7s/1EhRZfhWzG4XOaE0
         rd0Nvs1O00bGM/irFlyk8ufNjN5d69xBkwgBqEzu3wyMbr+wl0cMnnL2iZAdHRA9d9/g
         Ya8ld2xZxw7EOq3+Mct6LZ9g7E2HjV/JeufVvphzi/hkV4+Q4oCAODr9jwOVygU5cnls
         xAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726160007; x=1726764807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+TMXkLYIBdYwWS5zoZpThaARY3AGh3Sj0RZ+lAi4Vo=;
        b=OzMPrl42vGrbPnJXtaB4fzVQJgonsFNtjuCrHrLTUyuhEh5IQCEUEP1NVli41ZPdiK
         I1kcJMV2kYT4h8uYZC9lwSATZFKU36y/N128bKJ+IoLXh/iFGb7smtUUIW8IHMCfXMFX
         FbmYEduySjTKolQwIn0o8mKuT9dbMa/QpDKlXPfckAJKrXdnR1t/Lonat7iwBOlkxY7q
         ibg2G1te5wG3YsbjUy4YVZzHHVctCV8oBwVDX1SHkEju/ifVYcEi54rZoquuPjEzGig2
         xGnduoiT7Mnmo+INl2rn+kpPvoxhWERqjRaiNdBJDnAaDRQb3wZSQJTw4TY0owACWKDa
         O74g==
X-Forwarded-Encrypted: i=1; AJvYcCWtQn6lRPj1FG5wZdPBAhwb/iUW5hl6zD+Yh7aiUeQee7goklizcCVWMcBbKNh8ZG9pD2+n5utGCYdFiQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNdozRojYKnGcoc0W/RQeAUVwzuI5SYqlPO7ZnheNIsBmc1N/Q
	AeZisFzlZqcp88bG8bdch/d3A+zVn88ISkjS+DMq0eKMVFPAZUVc
X-Google-Smtp-Source: AGHT+IE+AMRIpg84NLhwoIlIbcdIuZUksArwuCENkLvlqgMXldebEjOlPoaTirqhVKaafnrFIVJOoQ==
X-Received: by 2002:a5d:6e54:0:b0:374:cd15:c46c with SMTP id ffacd0b85a97d-378a8a1dac8mr6891748f8f.15.1726160007346;
        Thu, 12 Sep 2024 09:53:27 -0700 (PDT)
Received: from [192.168.42.65] ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378956650f2sm14771777f8f.26.2024.09.12.09.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:53:26 -0700 (PDT)
Message-ID: <6ecd3129-e039-4b86-9e67-03a7a519266e@gmail.com>
Date: Thu, 12 Sep 2024 17:53:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Conrad Meyer <conradmeyer@meta.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
 <ZuK1OlmycUeN3S7d@infradead.org>
 <707bc959-53f0-45c9-9898-59b0ccbf216a@gmail.com>
 <38a79cd5-2534-4614-bead-e77a087fefb2@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <38a79cd5-2534-4614-bead-e77a087fefb2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 17:32, Jens Axboe wrote:
> On 9/12/24 10:25 AM, Pavel Begunkov wrote:
>>> an entirely different command leading to applications breaking when
>>> just using the command and the hardware doesn't support it.
>>>
>>> Nacked-by: Christoph Hellwig <hch@lst.de>
>>>
>>> to this incomplete API that will just create incompatbilities.
>>
>> That's fine, I'd rather take your nack than humouring the idea
>> of having a worse api than it could be.
> 
> How about we just drop 6-8 for now, and just focus on getting the actual
> main discard operation in? That's (by far) the most important anyway,
> and we can always add the write-zeroes bit later.

That's surely an option, and it's naturally up to you.

But to be clear, unless there are some new good arguments, I don't
buy those requested changes for 6-8 and refuse to go with it, that's
just creating a mess of flags cancelling each other down the line.

-- 
Pavel Begunkov

