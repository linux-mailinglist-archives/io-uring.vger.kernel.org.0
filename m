Return-Path: <io-uring+bounces-4917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C43C9D4E07
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ADC32820C5
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 13:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0B21D9A6D;
	Thu, 21 Nov 2024 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIE48Exk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44A01D90DC;
	Thu, 21 Nov 2024 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732196710; cv=none; b=WkAXzJw/DgmJMkc0qW+EjevTdC5anyElDKEXwzJ3hMMh1AeP50AlQga3K/DKt5vOO/HGXjvhERtST3fBdNRcuKJjSCA8Wi+W90WRuILGa46Nv8tX6OW6wpRydkK2kWmqf5aFrqI7khj2S9OYRHoczrjbNOfUQ8b9yeemRv8zXqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732196710; c=relaxed/simple;
	bh=7xbOEIACai6GTHxKu2K+0Xjk6pLvs8k4GffFn7gJ+Ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pyBxtkuK8OeH8nTjWlLwWsP7isZWeEHRInMQEHYLGrUdrO4KHLEFUOGcHtsOwOlzkus426AKZWPoyLFRCSEecQozv8oi+0EFc5RAQP5j5wpin3OKx4zRcTqh6XbVQx6xTSNzOKF/38bqFQFHqdgAUY+qFxanJKF6SqdNpCtPO6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VIE48Exk; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa20c733e92so127715466b.0;
        Thu, 21 Nov 2024 05:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732196707; x=1732801507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4pq/XM0SZEFy5gATevhzqMaAH7wNKf6n+SB2NmScqXs=;
        b=VIE48Exk7rhFjzNzJfSWAoZ0MSpwvS96SV+MTAb5MOLHcE4/Z8U6BWN7ikP9dKjdwW
         4CBstLc4GYX2mrcv4h8gEpqmUVculvc4Dpe4AKW6wiNdvMoTCqM78slpE3dWC12WFly5
         UbzNLVNeCjSVNm2GlqHomRjpQHRx8iNJFPl2YK1GNWwZhgoED1/17kFPvilp17qLhibu
         hLDB2MWMru34GoqUTTGEbFcYu0d1+LPTEeei7N7+EfQKzPEfIowlBnoR9ri7oJIdtmLN
         tLC+grw1NHCoBlwVOfsmhU6W/VttTEzDA9JpPUWxJ5uV6sGTrW2G3rSmm+Il4Yx1DiBk
         XbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732196707; x=1732801507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4pq/XM0SZEFy5gATevhzqMaAH7wNKf6n+SB2NmScqXs=;
        b=DTis3cKDokQ8RabqXvSoYGxP3gX4WG7IRVJpE6PgWvj6RAWmPFI49eUOIxq3jvwwt2
         ow49Aw8VexYPM2Iht43khHpVSV++ghVcKYYfSQ5G7QvsOoM55B3kSPoloV1raQDKGHlf
         +XeiBZJ2Ed983QHkAct27iz0iiQGLw8gatGXiUgN3bjKsNdDe0ATKr4U8JSfcdpzeCNO
         RhHIRa3yyIwynD+/mKCjUE9QuR91wdbutX8jkfXeAMkOhvurWVS/YrQnN2X9PuGp/Y/t
         +P4AFNbmEy4VhyWzjDCuYDwrmAl6XMfZwfX1G7F8ULTuJhbYRqypuJVcCewjgDBWW36x
         /Xvg==
X-Forwarded-Encrypted: i=1; AJvYcCUzfRVBtETtal5+cQtUgr7q5yWUcHvs+hqipKy16JxZHxnYrd7wBqBLkR4/nCOACHwx3womk+lnN2cqtCYsbw==@vger.kernel.org, AJvYcCVxGNqYWvPFkJ8KbT9MW25NbfUNTQFM791KzT2REqHaU2emrID4EpC7ZRlmi+JIVL7iljj8JtscbA==@vger.kernel.org, AJvYcCWuDFPupk1HWNMBL3o5DLPy2L94K/arLXe+YzXEikiR9/h1Gjp54tI+jAxvYr9jJZ2POZN6DKCq1psV/g==@vger.kernel.org, AJvYcCXqqmAhQbB5kie6kBw8kJ5Sc4mk2XFy7onsYAgSMo8I0OzB51XUEiP6Y6Sxh8iskrwp2hXuv20fckBqBQo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm+X/vATfmNS++LUQk1IDxKBqPW/5IiKAcKCmtZlA5u8bJFYMU
	MTfxCGohAPMYwd3bTAQynpcByD5T1iBaS4FiJXyYtMlD3E9b0i7t
X-Gm-Gg: ASbGncscbkBHnG57+bh0c0qf1gf9ptF9cCeFn3HNDXjdClJCRTith1teWJ/p6PUmH9H
	bbG8M2cRiQNgJLsonF+yRggvH6yDfnuaJ59n8KbP/i6WQLr2cgXh9JgRkiY+RqlG3M4pIGNklEb
	Hihv3fZVnnUOoGYwmaxgIH95Qbhe9r+fq7Y89hh+yRgjn5joHnSlVbmeNZd6uvI8J0571oLlvkS
	U56rVmXe1oewZx+SSmLpIt45dlX+d59ldFzio1Hd5bDUfcA/s2vKu0KEmwTMw==
X-Google-Smtp-Source: AGHT+IFbrl+oIuZ5/IgECuefc9devB61urmQnzBxxeqoidxHMM0dOzQmgj0ok1K5viTP+eBfwwX3YQ==
X-Received: by 2002:a17:907:1c1e:b0:a9e:b08e:b02d with SMTP id a640c23a62f3a-aa4dd552153mr705616066b.18.1732196707044;
        Thu, 21 Nov 2024 05:45:07 -0800 (PST)
Received: from [192.168.42.195] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f431b3b6sm82710766b.171.2024.11.21.05.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 05:45:06 -0800 (PST)
Message-ID: <9081b86c-1496-4d03-8063-18637e14be49@gmail.com>
Date: Thu, 21 Nov 2024 13:45:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: "Darrick J. Wong" <djwong@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
 axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
 anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
 viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de>
 <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
 <ZzeNEcpSKFemO30g@casper.infradead.org>
 <20241120173517.GQ9425@frogsfrogsfrogs>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241120173517.GQ9425@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 17:35, Darrick J. Wong wrote:
> On Fri, Nov 15, 2024 at 06:04:01PM +0000, Matthew Wilcox wrote:
>> On Thu, Nov 14, 2024 at 01:09:44PM +0000, Pavel Begunkov wrote:
>>> With SQE128 it's also a problem that now all SQEs are 128 bytes regardless
>>> of whether a particular request needs it or not, and the user will need
>>> to zero them for each request.
>>
>> The way we handled this in NVMe was to use a bit in the command that
>> was called (iirc) FUSED, which let you use two consecutive entries for
>> a single command.
>>
>> Some variant on that could surely be used for io_uring.  Perhaps a
>> special opcode that says "the real opcode is here, and this is a two-slot
>> command".  Processing gets a little spicy when one slot is the last in
>> the buffer and the next is the the first in the buffer, but that's a SMOP.
> 
> I like willy's suggestion -- what's the difficulty in having a SQE flag
> that says "...and keep going into the next SQE"?  I guess that
> introduces the problem that you can no longer react to the observation
> of 4 new SQEs by creating 4 new contexts to process those SQEs and throw
> all 4 of them at background threads, since you don't know how many IOs
> are there.

Some variation on "variable size SQE" was discussed back in the day
as an option instead of SQE128. I don't remember why it was refused
exactly, but I'd think it was exactly the "spicy" moment Matthew
mentioned, especially since nvme passthrough was spanning its payload
across both parts of the SQE.

I'm pretty sure I can find more than a couple of downsides, like for
it to be truly generic you need a flag in each SQE and finding a bit
is not that easy, and also in terms of some overhead to everyone else
while this extension is not even needed. By the end of the day, the
main concern is how it's placed and not where specifically,
SQE / user memory / etc.

-- 
Pavel Begunkov

