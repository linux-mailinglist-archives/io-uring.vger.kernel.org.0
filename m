Return-Path: <io-uring+bounces-8701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B19EEB07AE0
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 18:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2F5E1882276
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED8923ABB7;
	Wed, 16 Jul 2025 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhJAE2Et"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D09318D65C
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682617; cv=none; b=R8dwkkMMu2Dnws+t09n+iQG5Zuz9hnQVgNEQfE3Dj0spT7cNKV/teoFZ/3VNRjYRuEZIqRDIYMVrb+iZEIjHhAys9NmRJdw81drb4MRER2f2ftcUBVW9Aq+iU3oxRYQ5pNvE5EvyUtGTT84JgRiftgDCosoVqT0+8M5w+JtfQhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682617; c=relaxed/simple;
	bh=VgHi1TW71jfIlxSFpsG07BqJdkZzTyJJqfdom6q1Etg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NCZwv52wRaFNrYSWPROlk0LiCabkqWEMztDNlYocPbah1XADkq7T2bFR5spQ5cdxQgywaXaSrkpqBG6YvOFwvVYzbh803dA316bheh+4D5hmLoXP2bJ3rQ6dzYBI7u1tOOgdovWPlGc5t5TaGpMva74H2RE6XLZDS8jckeOooTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NhJAE2Et; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60dffae17f3so10671431a12.1
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 09:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752682614; x=1753287414; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LkmRgGtTYtH6ZoSisGFloXi1BecE6fYuwUc/wSEg9OY=;
        b=NhJAE2EtNnywCFfiofG5BRsWvQeiOmtJXKSI9N/CGusjuIWfnRpGi9Z7MAPr4Am/J8
         p/Gh5+alTGTa0f+igaRQbFh2f25Z17tYL5lo9hfA8eow/YW2yJrV1/3iscsBYsOtj/Vv
         lMRo1LMzq8Q4PsALHfPau0G2Ao9DcDtyne+hTjSs9yW4ZO2E37PyPZ/PlH/tNNRt7lY9
         67vImT3zwBmNZSxhZWZY68/gbv32+mYPfIWWUw3cNTqMh8ZbcR/FBnuNm3eTXTYUyUT0
         Dzn136YzoNJtshj8JVOs1O9C/mOF4K/31/UXuEUPGQOb/QdmyAB1gGrY8SL68OTmnglK
         EFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752682614; x=1753287414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LkmRgGtTYtH6ZoSisGFloXi1BecE6fYuwUc/wSEg9OY=;
        b=UyRpiXnzo5WlmX4+iVl+Uw3fR9ZBIdpUdD0cu/q6DX8qcQYBYGNPSC5Pl6J2UL0+8x
         706gdPuT3aR8ceIOxHvD5pHyRi0Km/fMF5HfaNLPTc1bZ/qB7nBvS2VsLSSUTTqrCpB0
         499IS4QCWdcn4OKu5CE2eWH2lTySqHTs4np3R3o9czYfZbN/yQiXfkoF6p4Dh5BQ1WlP
         +pv/iqUikSDpXjJSjwHh6UvKNwtbKvgnLBXf/Uer77eEfGUQgn+fOYHJZX+wX0//ZY4c
         5KovlIc4tn8/OccJwRuYxkAR8zude5UeH6iYhWoPIhRhjvbhaiGAGnj3x4ZxA7xI+EEC
         JLtg==
X-Forwarded-Encrypted: i=1; AJvYcCVI+WnOOReAWGWITmps6wBwMNkKt5lvcEolWn60LXPVu5uTozlbadXp9FCaoietOmKu3u88lzfIIg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrh5VYT2RHnhIpzf8MsRTWHjY8dz0QcB4zSFpMt+lPk8YSr8Gb
	S14VhzjVCv6mlUpgYWK3DMLJovmp9wazxBcyFoLZbfqvF+jpQolATR8Yc/7Waw==
X-Gm-Gg: ASbGncs5LU0WpIbc5JzbbG2N7gPaL1/QIQ9H5jNcVL4gAuHN/pbCGPtMbLQG47tdbPS
	sCEtch4mlI5rYBFx4pyCKoXVymAtQoPWE+W+7iYtimooxIb2xlFtZUFG5RGPeZEJp9IBvlg9pt/
	WYTMmSL5wI8vQxRjh5aKfWBwW4b4+dVBYWqv4/Btmt+ei61lqG2MaHP4xrEl3UWnNXYVUqOZMFm
	hyyiSG8qXzDpoGjPDV6XQK6Z6lWyFkigQinj16FNdwGracWg45Hx4I6pOKjokPH+W7xdDXqXrgA
	6pNp4yIuUMx/S6GzhkrfaIJQI2A0XxzkXjWnJ4psk+aY/g8OtV43RK6TFHKSpAZ4+rJdL+p0Kdi
	xMOJloP5Iv02eXbSNdkkezL9gRnelbu6E
X-Google-Smtp-Source: AGHT+IGTv4x5R9fggvNx+hGszefVTEEfhc4EvLngTiIBVRhkAyBD7Bm/i7PKbfZDLvjk3pTwDUkEcA==
X-Received: by 2002:a05:6402:1d4b:b0:607:206f:a19 with SMTP id 4fb4d7f45d1cf-61285bfd69emr3087056a12.25.1752682613540;
        Wed, 16 Jul 2025 09:16:53 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.211])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c9543144sm8863333a12.33.2025.07.16.09.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:16:52 -0700 (PDT)
Message-ID: <2926a9d7-3484-4004-a40b-9a739bdaea13@gmail.com>
Date: Wed, 16 Jul 2025 17:18:19 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
 <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
 <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
 <7432e60c-c34d-4929-b665-432b6d410b5b@kernel.dk>
 <3b7eb60d-9555-4fa4-a9b8-5605abd3988b@kernel.dk>
 <bf0de1c6-64e6-4a4a-b741-3fab0576339f@gmail.com>
 <8d9a1230-0db4-4f7a-bca8-565465d3c186@kernel.dk>
 <cb896d1f-6260-4ba6-b6f6-6b4693f5e6b3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cb896d1f-6260-4ba6-b6f6-6b4693f5e6b3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 20:12, Jens Axboe wrote:
...>>> How is it related to POLLIN?
>>
>> Gah POLLOUT of course.
>>
>>>> should let it go through. And there should not be a need to call
>>>> vfs_poll() unless ->in_progress is already set. Something ala:
>>>
>>> In any case, v1 doesn't seem to work, so needs to be done differently.
>>
>> RIght, that's what I aluded to in the "improved/fixed" further. FWIW, I
>> did dig out the old test case I wrote for this and added it to liburing
>> as well. So should have somewhat better coverage now.
> 
> How about:
> 
> if (connect->in_progress) {
> 	struct poll_table_struct pt = { ._key = EPOLLERR };
> 
> 	if (vfs_poll(req->file, &pt) & EPOLLERR)
> 		goto get_sock_err;
> }
>   
> with get_sock_err being where we do sock_error()?

Seems to work. sock_error() can also race, but I don't want to
waste any more time on it.

-- 
Pavel Begunkov


