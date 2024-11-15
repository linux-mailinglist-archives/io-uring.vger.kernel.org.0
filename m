Return-Path: <io-uring+bounces-4722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5388F9CF1E0
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD4641F22418
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E751D63F3;
	Fri, 15 Nov 2024 16:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aY0zZh6l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F67818E047;
	Fri, 15 Nov 2024 16:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731688817; cv=none; b=YRaNFIkGJ0+Tk7qsp7ssBnAtUd0yOFdzO9NFSYr2vg6VDpDJ4CbrMSAeVveXj/iG6AT1t50Wmn5a5oKPnUt1P4q8FjV/jfNFgJe4wryZ3LuSyH47vauW3n2lJM/F6W9OSo8t8KsI3P+8g+RxGxWPXCSkMG00KNRufn9RS3TWN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731688817; c=relaxed/simple;
	bh=BmfhvPfduMFTiOJCjUktn+SsqKJieOL4flGGbgausyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eYvhV51o4UC3rceS1EnHghqpa49db4deWEpWzOX5hbpbgJanRlrXdaQh3+1a23CAJaodTAUiHnVzMwisY+tdsQDfkiray+BHYoErFq5IwQA/wMQOb/bfxwTBj0wIuE30mOO8OgSSY4ASk9VysFq3iaQbgW3uIIOg45N5R6aslRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aY0zZh6l; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431616c23b5so11966535e9.0;
        Fri, 15 Nov 2024 08:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731688813; x=1732293613; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DU23KB9CDaJ/ylEjpMmh487mXVL8GrqTA9sTg8RR2Yo=;
        b=aY0zZh6lPzbAP0UfSKpfhQi7JOcpf7+L9xPq1wuHHG0iKyxaW9H+0blBhFd3nbv+3Q
         n8h3tvYyBFz2149Kq5LPFOEFTytl+q6CN/JNFJVAjsw55RjwIlozZdGbCgZp6YvbhZ2o
         bAGmSYxrVjFdiTYOGZmlKgLWMAjRkojowQ11ReRifv4qLXfMGyzXVBYb/8cdc6k3DceO
         yNLOMaBELAtrbXvQBRhHymDz8t5ZSed+x2qdCW6TlY2NBtyvEzzPqCDN8en9hyTe4ZA8
         2OdQJcv2AgIu3WoX6NxX/wpUkfMNpFa/9AbXiuK+whKbvWAZqWLl2ZfdjchCrAgpGd0n
         xmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731688813; x=1732293613;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DU23KB9CDaJ/ylEjpMmh487mXVL8GrqTA9sTg8RR2Yo=;
        b=l49oppnxZ1ED6eIYxETTZhD9sPNmOc61D14MWvMMkGbxWelFMEH1UHjeAeDSiwS6r1
         MkNsTXvEDippXSluosA6sQKu9gBWQgce/yC35ZENEJMwJjHRyssesbnRE2inK/mcDMGu
         FustgIt2x+NBV2GQjtM7IVq5wCIFUtRLYqyY4IR420U5giKen1HKH+nWhsdGpYxPBcHx
         c7vOY9kUcj8m+lbvXFburiJQ7t/ZTqpQM4KRxaq2semWnS958MVhBctepn4tnNmoTzYb
         eqqn/XXFx/34dAkasoa41Y39jsRuW38kdma05QBySG6iA61vmJM/7UPrzFdlvEtdDkaw
         yhig==
X-Forwarded-Encrypted: i=1; AJvYcCUTLzMQaTXquosvCovtG8T30UG3t4Js919qA0cp4AcjOGdzcZNibzGEFfB1EvJ5aBFH43TMc4DuS7fLC2U=@vger.kernel.org, AJvYcCUqIwlgdDWq6haN4ejBQfX3k8XvkMDDM4LZSTw5AftcVaOFKILeriNVty81aPSBVv7wM6rsXam3Jul81gqxfg==@vger.kernel.org, AJvYcCVIHU9OzPUhk+2gfEXsz6aMHLXbSb8zccSjrzzUUG3DR/gnbIon7OBrsbonhsj7AX5PhuOwNprSl028Qw==@vger.kernel.org, AJvYcCX7oj9rZCIXw6vm2RfbzMgN1CgILOea5jFVt8eBjpHjL9ssukcXSRFDBtlEtq90KSqcmc6nq0JFIw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6VjneEWDSMVy09+5L4wPo+7ovRynjOgx60+3RRK4N/XEGf3Xl
	RBcxeEmddFc+m77Y2AtBNGw/m7oEgHizGvmudBSsZJQ/fqbzL2O1
X-Google-Smtp-Source: AGHT+IGYcRrADCDs0VXLudCPmoKNK8uAFXXrZZvU0GlTfdTzpK46osYHhclfaK73bM6gmSYsQl5j7Q==
X-Received: by 2002:a05:600c:3553:b0:431:405a:f93b with SMTP id 5b1f17b1804b1-432d9762473mr69603745e9.10.1731688813174;
        Fri, 15 Nov 2024 08:40:13 -0800 (PST)
Received: from [192.168.42.191] ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265668sm61720245e9.10.2024.11.15.08.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 08:40:12 -0800 (PST)
Message-ID: <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com>
Date: Fri, 15 Nov 2024 16:40:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de>
 <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
 <20241114151921.GA28206@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241114151921.GA28206@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 15:19, Christoph Hellwig wrote:
> On Thu, Nov 14, 2024 at 01:09:44PM +0000, Pavel Begunkov wrote:
>>> Eww.  I know it's frustration for your if maintainers give contradicting
>>> guidance, but this is really an awful interface.  Not only the pointless
>>
>> Because once you placed it at a fixed location nothing realistically
>> will be able to reuse it. Not everyone will need PI, but the assumption
>> that there will be more more additional types of attributes / parameters.
> 
> So?  If we have a strong enough requirement for something else we
> can triviall add another opcode.  Maybe we should just add different
> opcodes for read/write with metadata so that folks don't freak out
> about this?

IMHO, PI is not so special to have a special opcode for it unlike
some more generic read/write with meta / attributes, but that one
would have same questions.

FWIW, the series was steered from the separate opcode approach to avoid
duplicating things, for example there are 3 different OP_READ* opcodes
varying by the buffer type, and there is no reason meta reads wouldn't
want to support all of them as well. I have to admit that the effort is
a bit unfortunate on that side switching back a forth at least a couple
of times including attempts from 2+ years ago by some other guy.

>> With SQE128 it's also a problem that now all SQEs are 128 bytes regardless
>> of whether a particular request needs it or not, and the user will need
>> to zero them for each request.
> 
> The user is not going to create a SQE128 ring unless they need to,
> so this seem like a bit of an odd objection.

It doesn't bring this overhead to those who don't use meta/PI, that's
right, but it does add it if you want to mix it with nearly all other
request types, and that is desirable.

As I mentioned before, it's just one downside but not a deal breaker.
I'm more concerned that the next type of meta information won't be
able to fit into the SQE and then we'll need to solve the same problem
(indirection + optimising copy_from_user with other means) while having
PI as a special case. And that's more of a problem of the static
placing from previous version, e.g. it wouldn't be a problem if in the
long run it becomes sth like:

struct attr attr, *p;

if (flags & META_IN_USE_SQE128)
	p = sqe + 1;
else {
	copy_from_user(&attr);
	p = &attr;
}

but that shouldn't be PI specific.

-- 
Pavel Begunkov

