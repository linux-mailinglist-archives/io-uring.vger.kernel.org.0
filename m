Return-Path: <io-uring+bounces-9123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDF4B2E545
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33CC03BABEF
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D973624C068;
	Wed, 20 Aug 2025 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AknwEl89"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE061A4F12
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755716194; cv=none; b=Lejulbxz9sIhMk1tdAG5OCVZkgdulx6HWnnDCsHSxaZt79d+MsAj59dCv0duoEe6P3wcpl3NAMhqJpFtXpFM82tLScwhTxIKTmNzSfweMdHbME2A1kDE0WOsrxG3475D/VHi7+mXp7gup8FmqXt1jRlLO8bMPLA5t/mxNSu0zdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755716194; c=relaxed/simple;
	bh=dGTZ3ZsuAPleO5p+SZQJkGud9sWAu8b2E9ZK5lk5x/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CAsdriD/t0AZoqBXbFWDbK6iTrJBQIdPg3lUifpLv/FFG9Cz3iluuOEYq1qXfsI8CX0YA+0WVi24+1pU9lIJjtAunTwg1FiOKpmILSU9g07lK0kq80SnXK1vnK+xwAxo2dl5l1NHSDe3tq2B2atlDgZ8y4uoU90G4x9V61jy49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AknwEl89; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so24181666b.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755716191; x=1756320991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o+T9CGnmjAzZRwZgyaBZUzAfDcVuwTSDkO7j8JTM/2c=;
        b=AknwEl896g+jVGPxMxh/GEtsjrgzp1ATr7E7hn9huVWE5BUeoSZiXYkMfGWlRXPDue
         1EW3MGATTK7j+INi3aerEBk2IzbaVMyyL25bZUQm9wwaXK8wVbU+GLF/JLYsb21C6NO+
         apcSr4WoE2+ZdK6P9FDUn7CeygIrP4EHJZArizrCA1UOJFtBhoW9dUKT/cmB8LNGsN7O
         tGIqQGuAbdwzvMevtjznuXSjoxgQEiccoANuB7XmBtzw9DHbNe1V+bDFVhsnZDNwsHTM
         IS5GlZr5eaPxuuyZesTK4NwazPK/QSNMwXw9mlqzEqUjrgEt7PlqcjsGKoXgFANCPjxi
         TSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755716191; x=1756320991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o+T9CGnmjAzZRwZgyaBZUzAfDcVuwTSDkO7j8JTM/2c=;
        b=s+7EVfl/ENrX7koWjFy+ZiQgS9hh/+SAVRVvm5LoUyPpAWFn0shJvAYaSY1wuCL6g7
         0W84b20jpXQJcLyTEfQVcdaUDB9P98jHS4BZm4MwvOHtQ5mIE1NT8xdX4NaMoBXiyCSG
         3V1ht6ujqGlJP2uPBX1QSQwsC1+dJe816mE7ldM5LyN5j717xUIIjYlomv3NB7IEZqTe
         0OQm/VT9KcW8dd0I/zN/kYTIRzLKgXyvPHJXHcmVGMHcDWCPojTkxbsmpVdzeI17xvQF
         A4RmIEgwEwlHkoOG6uUct5UJ6EDMWAh4RZol1kViieMF7oei+9Gbh99e2OmRdH5VuHLg
         dMJw==
X-Forwarded-Encrypted: i=1; AJvYcCXRI0NUXjhMfFZPZkgXwLRq7aq5id86ayaxd3VzTPSeCFqBw0NAUi5CvuWXlg1NLu5x3L8xLejerQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsgq0sjYgAgSuX3eejuDGOZXU491ms7kBKTdVBLzR/HjyqaZ5H
	YWsW6m7/TLuhV/W22Zc/txWFOk07WzJtZMjzl3MNU7oh0xlf6V5UWXDE1nGv+Q==
X-Gm-Gg: ASbGncsBrbL5wty+us6/gkNoOupvdLSY8R37u1C6ch2lJvRohU3LVgSow1Nt5s0KjnR
	n+qDBn7ReVEzJj7QtL34X0hdf3XkNZADo79r1G1rbhw/ELybKOVrN6WPshvJS3HpKx5zdeRgKxk
	LVQPEVIxMrSqKnv5PhCkv31bq2cwP/jVpJW6/x6lfcyL7auOrF2risMTMBFIxWsBOH1ixSGjgEf
	A6dwLIMo+w57XrilrufgWeWQ2ANzKmoULuAP9GFtrcg2K8F3ksGX6vMPXEdA1c2qjsTsFfizkfX
	F9ywU1aB0+jiLKzIIWy5E4Kt1Lk8M6JSqJiHlZNlDySvwdTq7quS+4wL/jIW/vZe+i83/qZsBhN
	8iqh30ZxvCJC4YH8BZLHReivGD4rN318v
X-Google-Smtp-Source: AGHT+IFzp9aMW/C2FwFxEdd8tjcV+xEA8tcMutgt+Nyd9v2jion3NKHAsu8nzKy8xZvbj2dGHKw3gA==
X-Received: by 2002:a17:906:9f96:b0:af9:116c:61c4 with SMTP id a640c23a62f3a-afdf01e8fb6mr362592466b.48.1755716191253;
        Wed, 20 Aug 2025 11:56:31 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.113])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afdfc4bfe65sm94298866b.85.2025.08.20.11.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 11:56:30 -0700 (PDT)
Message-ID: <c6ea1a29-3a0a-4eee-b137-a0b2929f00df@gmail.com>
Date: Wed, 20 Aug 2025 19:57:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [zcrx-next 0/2] add support for synchronous refill
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1755468077.git.asml.silence@gmail.com>
 <175571405086.442349.7150561067887044481.b4-ty@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <175571405086.442349.7150561067887044481.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/25 19:20, Jens Axboe wrote:
> 
> On Sun, 17 Aug 2025 23:44:56 +0100, Pavel Begunkov wrote:
>> Returning buffers via a ring is efficient but can cause problems
>> when the ring doesn't have space. Add a way to return buffers
>> synchronously via io_uring "register" syscall, which should serve
>> as a slow fallback path.
>>
>> For a full branch with all relevant dependencies see
>> https://github.com/isilence/linux.git zcrx/for-next
>>
>> [...]
> 
> Applied, thanks!

Leave these and other series out please. I sent them for
review, but it'll be easier to keep in a branch and rebase
it if necessary. I hoped tagging with zcrx-next would be
good enough of a sign.

-- 
Pavel Begunkov


