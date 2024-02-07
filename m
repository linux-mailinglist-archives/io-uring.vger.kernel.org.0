Return-Path: <io-uring+bounces-573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 564F084CF63
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 860321C26A5C
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE76823D9;
	Wed,  7 Feb 2024 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kr29iGln"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EBC823DA
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707325620; cv=none; b=lBJRDgbyBDBf7qta1buPx02d/VKX0sHUsA+/iCyAn0p7uAcuU35b9YaAR2jxQ/2RXv3o0v+K3Mbqt47gUY0uYu33HmtuqBt1g+rQTGT0OM9eHAnaO9Fyb7YwQhx7qS6I2qa5kJORXfDlKty/91C2SB+diyjsM14sRtSwzsDoNsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707325620; c=relaxed/simple;
	bh=7C63nunywPDaKHGJtv0HuEmtygpWagnoHLl4w6FxV6w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=SV5Mi55pKa64C5TtEzYmO8ulVtzAkTJVJv0pznem5VyuaZsWXeM0VUiQdWLAdtQoZ16sonyd/CqwH1FFTyByWCY6g1kgag/Net/kiJ9e1wE6QyfbRodMkegFtstkqOqGPycqvmEgz0ZSbjNZtGLrmM0wmLegotD2c7fDGJ7kvn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kr29iGln; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so8673739f.0
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707325616; x=1707930416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xmIJySLQtAnhGkfR6OomgcWUCiSOe3iOcnxQJEVYBLw=;
        b=kr29iGlngM3monLqHhHZWPcw6xYwWu+1uk0OJ4eZUrgNClwj7kxV6uCzaH2ItJCMTm
         qf7EeAPtzQNyRa/WPztayOjd1JXreRfwJ4a76N5friaiWQTXctB4DJxKqlN6Ly//pjLw
         CuEgBU8zSxJUAZjWOQjn2oCtdbwb6UF9vyKt6VICUsWhohI38WRlg5AbrfHh54F2ZFWO
         lszISVw98rNgmj+YbjU2g8Ts01ElZwLIMz0icozTetnkbDGZrd2qlOQMI1tqsET8mORQ
         T+oZBQefToneymFngCXy44dOTVp5zh5Jrn+rq+SR/Y2FGsAdwXH2YAdTM2O2R548GZ7m
         uEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707325616; x=1707930416;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xmIJySLQtAnhGkfR6OomgcWUCiSOe3iOcnxQJEVYBLw=;
        b=CXmlH0iPX6Z+VG60o7sNYGcg6GBZQy6l8d0QF1utw9vP6uMltMedlKge2Mx7sCyAt/
         FiNQav+CQkcF7pbzu14mQMoEOykcjtgImEOAbvlOpMnZLc4OqMAE0kqhCGHoEQCLkz5X
         OZeuFZsq7a/DrUSOWNIWy32VW2+TWS6BVjLx8AjdWLu+S80LeI1PaLI4/EE2+WJMpvMA
         6l0Qn6vtx0Fk4iVdtu4T/MZ287s8O/xStlEcI5zTztpFITM0rTi1cPYJEeeTpYzRrFJj
         7dwg9jUf77t0ukoIWWgYZBj3X73X3SuWZb8WtHYkuZ6SPZ65wYD824CkemFQhBGCxkhS
         RxdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYD2XSRMlmRk4YoT0tK528nwEba1ipz2ciJB1p3LYoV0SZR2JLmrsZlWTqjdg2AQa8GC9HXnt9hSoiDa0lI9l4sUbo6xswsek=
X-Gm-Message-State: AOJu0YzF9Nes4SEZ9gY2fFa61j92QM6e5vvmjrWKQUPApigTzM6HOl1y
	55oUOTGF4cVVQGQ0VneIVOTuKlE0B3YAONbgFA7Sa5bOG3VIE75v6zbIPmaWPyE=
X-Google-Smtp-Source: AGHT+IEJ7YPlhcSCpysbs+FVYkSCfo8S+sOZGzaA9plVAeULDmJue5z6Fab8vBCcpWc35HKdRPlLGw==
X-Received: by 2002:a6b:f308:0:b0:7c3:f836:aed with SMTP id m8-20020a6bf308000000b007c3f8360aedmr4173156ioh.0.1707325616390;
        Wed, 07 Feb 2024 09:06:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWnUqZzNY0xNhuFF9evr1Hpb0wZFgpmxd+i7aHP74vrlJJJyVvM95DALUsAlBp0DfB8OKdEkV+OgOEbCXvlXISZRv3PFGmAKXh8tOz47icXl+jdHhhw1KoYezird/BPKwnkmDvuFcXU+QJaE7IoQ3Sk50eBuso9fbwyotisFARBYSlvqvy8rkJlyjX6gKM=
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j9-20020a02a689000000b00471307ff92csm411038jam.173.2024.02.07.09.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 09:06:55 -0800 (PST)
Message-ID: <de25b878-15d5-4299-996d-74c122e21e6d@kernel.dk>
Date: Wed, 7 Feb 2024 10:06:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] BUG: unable to handle page fault for address:
 00000002de3ac841
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
 Ming Lei <ming.lei@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
 io-uring@vger.kernel.org
References: <CAGS2=Yr7_h6ZiOSjRNXjDeXDQJrcDE+4LW5cJYAuB_2WnZYGSw@mail.gmail.com>
 <b1668ac2-3fa3-45e6-ae79-a127cb095eba@kernel.dk>
In-Reply-To: <b1668ac2-3fa3-45e6-ae79-a127cb095eba@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/24 9:37 AM, Jens Axboe wrote:
> On 2/7/24 12:19 AM, Guangwu Zhang wrote:
>> HI,
>> Found the kernel issue with linux-block/for-next branch.
>> kernel repo https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>>
>> Reproducer :
>> 1. offline_online_cpu_in_bg
>> 2. some_io_in_bg
> 
> I don't know what these two things are. Would be nice with an actual
> reproducer. I can trivially write something that offline and onlines CPU
> in the background, and I did, but I cannot reproduce this issue. Ditto
> on "some_io_in_bg", what does that mean??

I managed to reproduce this, it takes:

- Using polled IO, but you didn't set hipri in the given command line you
  sent. What you sent cannot have been what was run, the trace as well
  shows that polled IO is being done.

- NVMe device with _no_ poll queues defined.

Anyway, the current branch should work fine. In the future, please do
include the full setup description and exactly what was run. This one was
easy to find, but may not be so lucky in the future.

-- 
Jens Axboe



