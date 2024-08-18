Return-Path: <io-uring+bounces-2829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE60955EC4
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 21:40:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AF5B281239
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 19:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CE6136E0E;
	Sun, 18 Aug 2024 19:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2/oW6tiP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1D2581
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724010006; cv=none; b=b8gWcKBKsDAuR3FWteWEgWDdLK1YzYvk+3W/5IQkJIC2j05ijZi75L/X4pK2lXcvzE0mn7uyqJVZPUorZ75LCtkPK5uYgn8BsjRNE4jJsrv5N+VTjMQTgIsc5MfMRUcQzDGVd910u86/DBVOpJUFuE0MUD0eLUWqwL9yy5at0J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724010006; c=relaxed/simple;
	bh=hLgZFyHKba2UkC6jIotzKpA3qRiw86Hm4wpS7/9aUr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lkeHyWg5aRhL8LxVQkFfD35CP+JQ4YNbtPteglQ2GXLH7fR/8qQHCOnnZZJELsMDuY6NqEkOXDscwOXIpOsmFIytcjR4I/BPICriQDj37bGCUwPTeps9Fv94zVUTVbvGI49j1eCRzkaLPTvdDv2EK79PvAbd8y54WE+pwyVUOEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2/oW6tiP; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d19bfdabbso95489b3a.2
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 12:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724010003; x=1724614803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DKQKf9PcCn/w3TCw2/W+MAFOEGGlrtG+Hta7+pn5gZw=;
        b=2/oW6tiPksVbJINjezspTXQN0tTmJznwX4l0tyGFO0yJ7SgCQr+DbsFBHmMcsPdx6D
         sZkBBWZX+SOd1NA6/J0ip3lwGTDRMfGm/TJTy4Y98OcTivoQ9NMliiICHOBAylYQnTFc
         XjvWcV6Ggy1DgY73m+rhRUS4ZqTB7lHHAjwgk3MNSmxfTLx1dFfy2yI021yiYZ2J0Bwy
         eRJd5HpV+wnsLotS3Eat4i1A4FQ0lxrAnlt+nW/huGxV0IgHcVad52Ig1XHokQZTb2sd
         DlqoUNTxOU2+WO7KDRk0JTZP5MteXi+8TfEJjjscJrDz2jRvSUlLa4WiTvf6uFAaCAQ3
         +QUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724010003; x=1724614803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKQKf9PcCn/w3TCw2/W+MAFOEGGlrtG+Hta7+pn5gZw=;
        b=VhbyZm5AzAHlWIQj5vTxxSvO/+TMiBY83p1GMTR8nasM9zVXuLdxyKvBrIBcsRK9H0
         ftChpepQOmrI0Q17UIKy8p3Sfi97JPrf/lg6F6o2ohHo2Gp+Q05IigXbf1kRMx+m0xYW
         0WCkKVR1Wmmp9Zyk7kKHis4ZQ3JKFUS9oZCRyRC5WhA3zqXRUbY6N/rPXqEQqRpWpacS
         gMndEL//yCNt6wfV629+IyaUOgM1CFj/Nb4/DHZspB4SYIp5ne9Caw0o6lVXQwrUOajP
         0T6ToozCjwg+CKPWX3SDC4g0jrK2sZbE+j6UNaVlOsK4rmYKr03h/jJip8eSTXE1E43n
         dDXA==
X-Forwarded-Encrypted: i=1; AJvYcCW1JJqunCQvt7k5r/5d76ulfqZEhjF9FYjFEjMRy1VxKd/aI8CSZFm6n08jKbfNW8751gWC9pJyYwnaGN+XdT2VzDdLDQywpRQ=
X-Gm-Message-State: AOJu0YyDHloUgH8OwLyuBBT6BV9NAOe7iWJSDbG9xmi/2epDg9y7MUUL
	h6bXvyfLe86nAsL6mM+ndMi+KB6z/XiO+Idhr1cQaawdqVSpgygGSln9GU17xUJC4rIxzFksInN
	E
X-Google-Smtp-Source: AGHT+IHb2dpfYKuT8xDcShvZNLTUgX7kSIc8nBHI73Xp9ztlcOU4gBMAzu9vCp018z0xURDET5tGZA==
X-Received: by 2002:a05:6a00:9191:b0:710:5d11:ec2f with SMTP id d2e1a72fcca58-713c5423829mr6775519b3a.0.1724010003087;
        Sun, 18 Aug 2024 12:40:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af3cebdsm5506050b3a.214.2024.08.18.12.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 12:40:02 -0700 (PDT)
Message-ID: <35738b1d-7736-4030-8cc5-5742e91f5610@kernel.dk>
Date: Sun, 18 Aug 2024 13:40:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/4] Tests for absolute timeouts and clockids
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1724007045.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1724007045.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/24 12:55 PM, Pavel Begunkov wrote:
> Add definitions, tests and documentation for IORING_ENTER_ABS_TIMER
> and IORING_REGISTER_CLOCK.
> 
> It also adds helpers for registering clocks but not for absolute
> timeouts. Currently, liburing does't provide a way to pass custom
> enter flags.

Applied, and then I wrote a quick io_uring_register_clock.3 man page
for it as well. Please double check it...

-- 
Jens Axboe



