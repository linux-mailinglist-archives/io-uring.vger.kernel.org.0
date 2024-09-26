Return-Path: <io-uring+bounces-3316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3920E9879B9
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 21:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05B7B286123
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 19:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287CF170A3E;
	Thu, 26 Sep 2024 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JwcQNwyp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6043715C148;
	Thu, 26 Sep 2024 19:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727379952; cv=none; b=dZybqRKS93PzoPR/mDEVpfxrU+QW2WWE6ThP0dXh1rTu63DpVf6hnakIfxOYTfnFNx7+yapTLk1HJXce867j+RBwDlSGj6Gmnmc1YCIN5FMHnfM+L6BDQmsCsSgsjJv/rY/Nr62cAvs4zrfx80kScsW2k5l+kBDEbqkg24rDGds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727379952; c=relaxed/simple;
	bh=JXRs57grmnhd6jAYeyj45HDqOnwrfazHsmaoY4shRrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VoOfg8aNJn7U+MyD/lH4RDDT7pDdTqxyK5Tv9a1hSMl2ksyV02kfT//clx7y4ym94nnWOq4/VL0wq9eoDyZuuNtbfqva8k0IPk48aiNYz+7CMr5qWLvNupz21PSFGXb/Uc5nixDvQMjI9fSAiN5BAY0KR6LDQ4BWQg4hQnYhnAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JwcQNwyp; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42cde6b5094so12823835e9.3;
        Thu, 26 Sep 2024 12:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727379949; x=1727984749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5lqppjYfbw0Gc0GuYqfaaRgt6oJ/DL4NuoQMX3P3kXc=;
        b=JwcQNwyp5pCHve9A3gEa/FGaoRlxrpR5moW5bA5wbi4MouoqcR6Caj9XKI6GPRWM2o
         qF8rSVmE5llRYqrMzAR3RohTCB0ki1lctnLX2LvKLVO8UECAGOnMrzhq3dSHYD0oCI3h
         U4XLxJl434mJxXq5urtqH8TpJAfj9F/A9smBoOmAZPib2oSui3eMgO3C9sQlKdlb48n1
         YIYOZM7hQmaH7D2P3CuQCVyU5nunip1W8dpUuZ1QtSuhUkQkUtUgrnzEwhLs4alYJdxP
         KReFeBtstLMkoJHhQWg36iKOxWqZ/YnBhfLfbXZG6QlHDIvD6ZCEUSOZjRVfIj3TM0eE
         Kbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727379949; x=1727984749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lqppjYfbw0Gc0GuYqfaaRgt6oJ/DL4NuoQMX3P3kXc=;
        b=oPIa9wPq3ZfDdMFdW/zaZdbfCR7dNdiEPMYbX5xBTkWc0yCL9JB5nNG1n2nkVoiwMI
         5gKFbb1y0tUE4sxafB0SuPvvYEY7Kpg21T3x5GMpf2JonJSw2kn9zRm16Ni2Uf6T6/1X
         3PfzCdArhi1/1KR07e9yA00hRERf5GiBrdSQ5klTcIZnR+IEZn6chyRzCi19Bhl2bvNK
         /zrBeBplLkWmv+klOxfXcIOc3RN3/sL7cJW+xWSaWK41dGXadc3A8ol6EpJ3HuJFnNOY
         IT12Y6tJjrEm8XPOq/alTMNd5JmeH5/CyWmY/K3XBUsXSju7F5YhNFJspLgOYf9+tZ1m
         C6Jg==
X-Forwarded-Encrypted: i=1; AJvYcCXLFNPGfY5gkDFSxfXBxw9eCdtbaFD2//7UTrvTzZt3McKMnLVevT5/h6SCZ8ntCU3ee38tQ+kZSw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+tlMxan6PM+WVBl4Rln6DUYVffckxx4MivrOAmKgpUsPyUzDM
	ff0L2CkITb864cVWZNNyCe05/oWBsxPaNj2j3qjIrPGWC75wzSvs
X-Google-Smtp-Source: AGHT+IHS0DwE/GQVLy9KI05jifdypQtK3522OA0beGY+7okKIW3+YpinJ8C6kTZPNb1VJYbXXugmqg==
X-Received: by 2002:a05:600c:3b90:b0:42c:b5f1:4508 with SMTP id 5b1f17b1804b1-42f58464939mr4099705e9.23.1727379948333;
        Thu, 26 Sep 2024 12:45:48 -0700 (PDT)
Received: from [192.168.42.227] (218.173.55.84.rev.sfr.net. [84.55.173.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57de120esm7685175e9.17.2024.09.26.12.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 12:45:47 -0700 (PDT)
Message-ID: <96681ba9-3d56-4365-b509-391f9f8445e4@gmail.com>
Date: Thu, 26 Sep 2024 20:46:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 0/8] io_uring: support sqe group and provide group kbuf
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <ZvU3Hrm41txC0S-9@fedora> <4c04a1e0-39bf-48bd-86ab-9756d279901d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4c04a1e0-39bf-48bd-86ab-9756d279901d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/24 13:18, Jens Axboe wrote:
> On 9/26/24 4:27 AM, Ming Lei wrote:
>> Hello Pavel, Jens and Guys,
>>
>> On Thu, Sep 12, 2024 at 06:49:20PM +0800, Ming Lei wrote:
>>> Hello,
>>>
>>> The 1st 3 patches are cleanup, and prepare for adding sqe group.
>>>
>>> The 4th patch supports generic sqe group which is like link chain, but
>>> allows each sqe in group to be issued in parallel and the group shares
>>> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
>>> sqe group & io link together. sqe group changes nothing on
>>> IOSQE_IO_LINK.
>>>
>>> The 5th patch supports one variant of sqe group: allow members to depend
>>> on group leader, so that kernel resource lifetime can be aligned with
>>> group leader or group, then any kernel resource can be shared in this
>>> sqe group, and can be used in generic device zero copy.
>>>
>>> The 6th & 7th patches supports providing sqe group buffer via the sqe
>>> group variant.
>>>
>>> The 8th patch supports ublk zero copy based on io_uring providing sqe
>>> group buffer.
>>>
>>> Tests:
>>>
>>> 1) pass liburing test
>>> - make runtests
>>>
>>> 2) write/pass sqe group test case and sqe provide buffer case:
>>>
>>> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v3
>>>
>>> https://github.com/ming1/liburing/tree/sqe_group_v3
>>>
>>> - covers related sqe flags combination and linking groups, both nop and
>>> one multi-destination file copy.
>>>
>>> - cover failure handling test: fail leader IO or member IO in both single
>>>    group and linked groups, which is done in each sqe flags combination
>>>    test
>>>
>>> - covers IORING_PROVIDE_GROUP_KBUF by adding ublk-loop-zc
>>>
>>> 3) ublksrv zero copy:
>>>
>>> ublksrv userspace implements zero copy by sqe group & provide group
>>> kbuf:
>>>
>>> 	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v3
>>> 	make test T=loop/009:nbd/061	#ublk zc tests
>>>
>>> When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
>>> it is observed that perf is doubled.
>>>
>>>
>>> V6:
>>> 	- follow Pavel's suggestion to disallow IOSQE_CQE_SKIP_SUCCESS &
>>> 	  LINK_TIMEOUT
>>> 	- kill __io_complete_group_member() (Pavel)
>>> 	- simplify link failure handling (Pavel)
>>> 	- move members' queuing out of completion lock (Pavel)
>>> 	- cleanup group io complete handler
>>> 	- add more comment
>>> 	- add ublk zc into liburing test for covering
>>> 	  IOSQE_SQE_GROUP & IORING_PROVIDE_GROUP_KBUF
>>
>> Any comments on V6? So that I may address them in next version since
>> v6 has small conflict with mainline.
> 
> It looks fine to me, don't know if Pavel has any comments. Maybe just
> toss out a v7 so it applies cleanly? I'll kick off the 6.13 branch
> pretty soon.

Impl is not that straightforwardand warrants some prudence in
reviewing. I was visiting conferences, but going to take a look
next week or earlier.

-- 
Pavel Begunkov

