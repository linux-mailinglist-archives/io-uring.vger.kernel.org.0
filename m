Return-Path: <io-uring+bounces-4380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C75DA9BA98A
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8166B21BB9
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C834189BA3;
	Sun,  3 Nov 2024 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ij3R2tJk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E4C433AB
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 23:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730675873; cv=none; b=eAqJf1HNZvxoGNA0vhm+QXB/h4pLauHVxikL7XaKi62QFYKPdR07AQKwuN8RRxGhUyfFMoFUoMLhJTDugyZwGGNd+Y/2ka1JYeeSwEwtVZ3++cWdW6O6O8dC+6kNVccpiVko5JLCY5/ouivEaFSQtktmkW6VYJYj1AvAxvKBQ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730675873; c=relaxed/simple;
	bh=3L4zWIjlnOh1Y5sSLHf9TdPbIpm8LkROgAxnMrAPhiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QGpnCO05Bo0EOGgWsXxLJ13ocpBfL8FRsz5TsoRSEP4DTqLdHbr0F69ugOzkdZoDsyKuaEUEmKYNLJ92J1zvlgHeqV2x24IhN7l7tbwU3YypYy8mHvkyS3feHabvKjhTPA2CeGSf92yVf9oTrutqWYI4Gb9+4rBzBYVqwDC9hu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ij3R2tJk; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43158625112so31186365e9.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 15:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730675870; x=1731280670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I+aVw8nn7w9EuYSZEHd2vH29CyB0mcV6sD9Qy6eUD48=;
        b=ij3R2tJkMbwZlAg+K7p9dkzGEJ4EmoaN/nHxVhmbRsB+EIjFoiT06DHiEl6bu5mKAH
         vd2X9k+dwzjaHCkgfX6+Vl9wQdTKnm6FdItW4DL9sXwcMHz66etjPUxgA04XthtI0JPh
         8nsqqApUW4uWnhvZ1OnHc2UuEZdVW0/CWCdTj19n87wQ/3IuOn3EoNWWwjXRUBH/sXbB
         SxvqFD4SruwlKJ2EeRNqOEsYW65EYhXpnhlGE8yGlr6p6cQ2UwWnkzH/tfQevsSmVSHZ
         6fzkUC/zo5vyubVn5G5GYQDE4DlU8PTM1jKVBjm+oGz5HUMJl0yEO2ZC4dRXF7AwGsHZ
         EXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730675870; x=1731280670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+aVw8nn7w9EuYSZEHd2vH29CyB0mcV6sD9Qy6eUD48=;
        b=aANOPUCmxdbQJZIqp9k4HwxW8NT+r+JaHP7VN54yZ6CXKa1goE7m1mCTfB/pB4aM4E
         BP/YaW2L6XKD3V7uWGQPwPr0mGAP26v+63TCbARy1AujS+/+NjIMqYtcxch+beSAhJ7f
         HUDlusxRG6LU8OT5KPcy4cprth2geD6Db1SHd6PXsOEso6b9YTVv+tUKNXlIQKR7LR3n
         R9Nw1CEAyFS6sJNyBg2ki3Z/tTriYYFG8bVwksjA6WoHTux+dNgaILX3Z7xuxFTQntS3
         6KKcgDOEaLhICpnfvPqMppZn1xX2lJXhNxM5kpoa3JPlf2ZaRPoPBHAytCpn5R2dTk1l
         iHCA==
X-Forwarded-Encrypted: i=1; AJvYcCWh2WPTLE8opkh+s+aa4TtDkdFDz2eiMLXjY9vpf020Au9vZPdBiUXWrNXiwPbxVqEWT+TkVYTFUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZFMRM9+QwSE46hpobpBOosBHgrjC1+ReyEERdIWM3edTsVsBs
	JN6dpGPY8iOV08L82Dg+PXyXWFZcbBSzs4rVscr2cAwgYiWdoam7
X-Google-Smtp-Source: AGHT+IEu3/X3dKLCL8kGwXR7OYlOGj/ZY8A9DEYLeuLfcz/diQmooIoWuAYF/hkMr5NO3VmXkyPDtw==
X-Received: by 2002:a05:600c:3054:b0:431:44fe:fd9f with SMTP id 5b1f17b1804b1-4328327ec3cmr80048995e9.23.1730675869651;
        Sun, 03 Nov 2024 15:17:49 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113e073sm11575385f8f.66.2024.11.03.15.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 15:17:49 -0800 (PST)
Message-ID: <099ea61e-b36c-4b87-9897-8265e3a6b6c1@gmail.com>
Date: Sun, 3 Nov 2024 23:17:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
 <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
 <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
 <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
 <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
 <03d7e082-259a-4063-8a98-5a919ce0fe3e@gmail.com>
 <40c07820-e6e2-4d90-a095-31bb59cedb8d@kernel.dk>
 <4cd58a90-2cbb-443c-84ab-9a9e0805e72b@gmail.com>
 <81330ac7-6c9b-4515-8dce-6294fcd45641@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <81330ac7-6c9b-4515-8dce-6294fcd45641@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/24 22:51, Jens Axboe wrote:
> On 11/3/24 3:47 PM, Pavel Begunkov wrote:
>> On 11/3/24 22:40, Jens Axboe wrote:
...
>>> Right, but:
>>>
>>> if (current->flags & (PF_EXITING | PF_KTHREAD))
>>>      ...
>>>
>>> should be fine as it'll catch both cases with the single check.
>>
>> Was thinking to mention it, it should be fine buf feels wrong. Instead
>> of directly checking what we want, i.e. whether the task we want to run
>> the request from is dead, we are now doing "let's check if the task
>> is dead. Ah yes, let's also see if it's PF_KTHREAD which indirectly
>> implies that the task is dead because of implementation details."
>>
>> Should be fine to leave that, but why not just leave the check
>> how it was? Even if it now requires an extra deref through tctx.
> 
> I think it'd be better with a comment, I added one that says:
> 
> /* exiting original task or fallback work, cancel */
> 
> We can retain the original check, but it's actually a data race to check
> ->flags from a different task. Yes for this case we're in fallback work
> and the value should be long since stable, but seems prudent to just
> check for the two criteria we care about. At least the comment will be
> correct now ;-)

I don't think whack-a-mole'ing all cases is a good thing,
but at least it can get moved into a helper and be reused in
all other places.

if (io_tw_should_terminate(req, tw))
	fail;

should be more readable

-- 
Pavel Begunkov

