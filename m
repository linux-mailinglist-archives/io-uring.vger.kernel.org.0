Return-Path: <io-uring+bounces-2137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6239003AC
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 14:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF50B1C21748
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 12:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4465B190671;
	Fri,  7 Jun 2024 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCrGeahh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458C186E56;
	Fri,  7 Jun 2024 12:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717763578; cv=none; b=CO8y5/k4LsMWaCFWX20eyN5QxqmkxpgJ7lN23PKlmiVxwiTRgEEuBBLFl23eRRM9q4LM2lt5PJHDJDLnuJWswqtskITETcwlGSonJvg3uhfjISEdAPG2NFK1RhB0X6+s+Alc9AW325eXL3cDRj4GfrstWFJ3NwLuun6HwOiAawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717763578; c=relaxed/simple;
	bh=Mtuzg13utpsWBO44y/vZFgi+4GmxZ59OY7Pby3W91Ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aE5YKqCZG3VywzRX6/6MBkLzQ4MS9c6fTlVemJTW+lMXj8orYnHWOZGhe5Gwn0QqWvOz10MABNozkgqN/yuVw+NcB8k88cpq24Jb7q22FGYfkh29Nm+XCVxoaAnKiUSxMEgbgoUqT3n6HEX0dNlPMnaAnsDKizfdPRmvHiJLX3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SCrGeahh; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a68ca4d6545so373560166b.0;
        Fri, 07 Jun 2024 05:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717763575; x=1718368375; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=frzHWXcV3WTz8vkeTxeKgJVHQUILa1qKA6l4DtovpCM=;
        b=SCrGeahhQMYWofZJOLBj6k2grKOWcOF8lRjMfyzwF3W8caOqFn3bmt+q1wHI3yWpeo
         SBpFhwa2+ja1ZH3J+tPgUVInEwrOjx0NWLvbz5LcnVXiATNj2V93/6GTN9SyVITbdyl7
         5JHAfjQ0P2GZ1W3fO1zOSAyDiPx6jdhmxMELEPHUGE0j5NHc1fN5AnVAAeBlJSCi7STC
         +KxtTIrJoyt40xdWkxmWXwR8quborXlUOAZjgNR5nFJjldJz8ld3pqCaeEovuEIfeOBh
         Xd06OdBLthMh5HjR15G8lKYt16PnZ7xkWVrze5PwfDwkjhy96M8z91Abr8rMmDKiGCti
         1aJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717763575; x=1718368375;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frzHWXcV3WTz8vkeTxeKgJVHQUILa1qKA6l4DtovpCM=;
        b=YXObvMZucgRG6T8MrOTIZWePVQuxQmAdyPPzXD0daX7x3CtKI45VkM13ivSSlZCoac
         uFQGKvouRlDpTcuvAbsejdxLx4ZHu8vgscyCj7NzElSr87ZtGiVEBVfvEGdlAMMX/Oho
         GG+T9le8PqrfErcJySo2oBl502icUN3zknuxoBWRjQ1meHtvawrW8wIbYB6skFtFOcNA
         7ohVbUxuo0+DcBKNpC78PL2n/MWUSkml3wYadicf04gVG46IXG46zUHa1EaDqAdEtfJS
         EU8TIJ22md1GL8QwtN9nMxGK0Lj6V77lobh2WJflXKnQP5ST4fP9/Re5tLQ90be0c4I9
         UUdg==
X-Forwarded-Encrypted: i=1; AJvYcCX2FAv6szGYL6yfHggePIjSp/wFCnC28Wk39UCx0KU3IuM+pe/wz60rwtATidN2l9TnzVLfHUzzC1QJykhqQWHyUHxw9uM+0eM=
X-Gm-Message-State: AOJu0YzT8eQ1r+rsCruTV8G/hHNT5B91ZhvUEDi72F6O3fhKfXWYxTtX
	Q/0Bp46xJM5ASE9KQaiCAA5OOl5yOpt73BLfkMe2eqxuRdQNlY+s
X-Google-Smtp-Source: AGHT+IFqc9bKCkFHiAOABBh9Yn9ivHpLFB5L9eImJEICDlhZbGZ7+5EFJJTrVdNvUkR5Y98HrEp7Vg==
X-Received: by 2002:a17:907:97cd:b0:a6e:6555:4bcd with SMTP id a640c23a62f3a-a6e65554cadmr102225966b.35.1717763574532;
        Fri, 07 Jun 2024 05:32:54 -0700 (PDT)
Received: from [192.168.42.93] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c806ebd31sm241540966b.139.2024.06.07.05.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jun 2024 05:32:54 -0700 (PDT)
Message-ID: <06c5f635-b065-4ff1-9733-face599ddfe3@gmail.com>
Date: Fri, 7 Jun 2024 13:32:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/9] io_uring: support sqe group and provide group kbuf
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
 Hollin Liu <hollinisme@gmail.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <Zl0IvMTuFfDOu3Gj@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zl0IvMTuFfDOu3Gj@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/24 01:05, Ming Lei wrote:
> On Sat, May 11, 2024 at 08:12:03AM +0800, Ming Lei wrote:
>> Hello,
>>
>> The 1st 4 patches are cleanup, and prepare for adding sqe group.
>>
>> The 5th patch supports generic sqe group which is like link chain, but
>> allows each sqe in group to be issued in parallel and the group shares
>> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
>> sqe group & io link together. sqe group changes nothing on
>> IOSQE_IO_LINK.
>>
>> The 6th patch supports one variant of sqe group: allow members to depend
>> on group leader, so that kernel resource lifetime can be aligned with
>> group leader or group, then any kernel resource can be shared in this
>> sqe group, and can be used in generic device zero copy.
>>
>> The 7th & 8th patches supports providing sqe group buffer via the sqe
>> group variant.
>>
>> The 9th patch supports ublk zero copy based on io_uring providing sqe
>> group buffer.
>>
>> Tests:
>>
>> 1) pass liburing test
>> - make runtests
>>
>> 2) write/pass two sqe group test cases:
>>
>> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v2
>>
>> - covers related sqe flags combination and linking groups, both nop and
>> one multi-destination file copy.
>>
>> - cover failure handling test: fail leader IO or member IO in both single
>>    group and linked groups, which is done in each sqe flags combination
>>    test
>>
>> 3) ublksrv zero copy:
>>
>> ublksrv userspace implements zero copy by sqe group & provide group
>> kbuf:
>>
>> 	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v2
>> 	make test T=loop/009:nbd/061:nbd/062	#ublk zc tests
>>
>> When running 64KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
>> it is observed that perf is doubled.
>>
>> Any comments are welcome!
>>
>> V3:
>> 	- add IORING_FEAT_SQE_GROUP
>> 	- simplify group completion, and minimize change on io_req_complete_defer()
>> 	- simplify & cleanup io_queue_group_members()
>> 	- fix many failure handling issues
>> 	- cover failure handling code in added liburing tests
>> 	- remove RFC
> 
> Hello Jens and Pavel,
> 
> V3 should address all your comments, would you mind to take a look at
> this version?

I'll take a look this weekend

-- 
Pavel Begunkov

