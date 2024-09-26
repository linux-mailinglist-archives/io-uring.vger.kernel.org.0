Return-Path: <io-uring+bounces-3314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B004398736D
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 14:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFF5EB27723
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 12:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8739117799F;
	Thu, 26 Sep 2024 12:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qEyef5eV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E05D177998
	for <io-uring@vger.kernel.org>; Thu, 26 Sep 2024 12:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727353119; cv=none; b=DkpB1uhDjvOEoqP86Vil0BgReajN0CETdLE22g2Rr6R6xskffFRRGgaLZdMtkuDDiL/AY4vCe4YTem0KmZjSLt0vShkDg5JIxyjbHiytPupJL1qf4wGZU/yVbLfMk3877lWHapQ1A6IlJlubjb4LzvKPdYFaOf2FIt8wyIfVpfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727353119; c=relaxed/simple;
	bh=d+Z0RyEjKS6uda56/13jXpQMBLwISYOd3Cizbl8erBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tw51cUkCV8KvYcSlZYq6eGcVOX5CfE9Q4dPC0GNTPoeHH3aXUiMMSUo6UnAe8Tga98yGyIB2ToT5KImRjGwGfGfLpQ2XLoVdPWBRqWHv/Et4x2BIMsgX6gg5vb1KBbwBYveWsrDTNsEOeKdZgSn3NUb7rgPD4g3MoxUkLfaa890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qEyef5eV; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-82aa7c3b3dbso49351339f.2
        for <io-uring@vger.kernel.org>; Thu, 26 Sep 2024 05:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727353114; x=1727957914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l3PvbTQ2NHCkFTt3c8nU25MhOQ1fTQ8LPYFghcXRr48=;
        b=qEyef5eV4GNBOxUALXZFy1f3i1/sHfHdhxs4o4mjDqnq1vkHqyeak3IjjJ9y2RtI0o
         8ObEbbgzIVcN6K572zv3T/SAm92ywUDvFxXbMCO6bihEnS/Tn46MqKGg0qH6K/v8WfL7
         Ce+vSw0nzeubOiOJLwb4urW3NGevmQitmEZiWkO+lpiVXhssN9+XJsXYeH+N+LnEyOLY
         yStdgpzdQdgPRybQUak6RtUhZR3d+BeRzDlZpFm6zrvP7fz816A5tE4ia29JXXebaVBi
         TZKdHfeyxBS71GKUK0msnQccaLA8tnzERBlXPlqQo2kATvUg2W8k7INgh1UuOru0kCrP
         SncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727353114; x=1727957914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3PvbTQ2NHCkFTt3c8nU25MhOQ1fTQ8LPYFghcXRr48=;
        b=C3hkoxKbcrwNlJ6I544CRelTj3QaUGZgbRT7Bj0pbadGKoLJki1f9IjR1fBEPAS1xw
         VcMUxWBh9l8guhKLPR1Pn9EEodnMVSziNXuyyWnV/OHtxl6Il3+/nNN4OI15/E4LYBYo
         7O1+MzMJSG1/R5+R9/KCpQZt/so8ZJxiglXHoINnUryn2OdtPT8ZnIURZmTIf3ZGnR0i
         I3C8hpLznbDOHLzrcgsk7hjiQwal4xjJ3pCxonm/nCg3G3eiXDFBHLhq8woWg19JVhld
         1P7jKKsSzLDfYsPPPnrc+TGUAJZ4HE9TfIOZeMX93WVYhlVuSm8jgRf12lUnqtESyWIE
         MhsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfEcLvo5c4Xl02fVGapSUnqSzosN0DhAXUo1j0znGVdJYkimqzD9zbyylIVvy4mvThSFwRiHTJCw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQcxdPwmuwOoNad5pX1m6nqNckizQv2JoSx5Hr7VDw9LMus4ck
	e9ySxFJ4AQTlxGhOFldS22n1Fco3iYL/uFRn0D5xkmD3/cOedTD4uiDovOBAUQ66Rv8JIIhNLI4
	61mVm+w==
X-Google-Smtp-Source: AGHT+IHmQNZI/Qw6VKuH/KMfYX6pDhywvtXKiGgEPiHevfDmzI1AX/jrD1tdjv+AC/HzZkxk8gWW0g==
X-Received: by 2002:a05:6602:3421:b0:81f:75bf:6570 with SMTP id ca18e2360f4ac-83247d11b94mr627923639f.5.1727353114238;
        Thu, 26 Sep 2024 05:18:34 -0700 (PDT)
Received: from [172.19.0.169] ([99.196.129.234])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d40f0e93casm1679069173.34.2024.09.26.05.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 05:18:32 -0700 (PDT)
Message-ID: <4c04a1e0-39bf-48bd-86ab-9756d279901d@kernel.dk>
Date: Thu, 26 Sep 2024 06:18:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 0/8] io_uring: support sqe group and provide group kbuf
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <ZvU3Hrm41txC0S-9@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZvU3Hrm41txC0S-9@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/26/24 4:27 AM, Ming Lei wrote:
> Hello Pavel, Jens and Guys,
> 
> On Thu, Sep 12, 2024 at 06:49:20PM +0800, Ming Lei wrote:
>> Hello,
>>
>> The 1st 3 patches are cleanup, and prepare for adding sqe group.
>>
>> The 4th patch supports generic sqe group which is like link chain, but
>> allows each sqe in group to be issued in parallel and the group shares
>> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
>> sqe group & io link together. sqe group changes nothing on
>> IOSQE_IO_LINK.
>>
>> The 5th patch supports one variant of sqe group: allow members to depend
>> on group leader, so that kernel resource lifetime can be aligned with
>> group leader or group, then any kernel resource can be shared in this
>> sqe group, and can be used in generic device zero copy.
>>
>> The 6th & 7th patches supports providing sqe group buffer via the sqe
>> group variant.
>>
>> The 8th patch supports ublk zero copy based on io_uring providing sqe
>> group buffer.
>>
>> Tests:
>>
>> 1) pass liburing test
>> - make runtests
>>
>> 2) write/pass sqe group test case and sqe provide buffer case:
>>
>> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v3
>>
>> https://github.com/ming1/liburing/tree/sqe_group_v3
>>
>> - covers related sqe flags combination and linking groups, both nop and
>> one multi-destination file copy.
>>
>> - cover failure handling test: fail leader IO or member IO in both single
>>   group and linked groups, which is done in each sqe flags combination
>>   test
>>
>> - covers IORING_PROVIDE_GROUP_KBUF by adding ublk-loop-zc
>>
>> 3) ublksrv zero copy:
>>
>> ublksrv userspace implements zero copy by sqe group & provide group
>> kbuf:
>>
>> 	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v3
>> 	make test T=loop/009:nbd/061	#ublk zc tests
>>
>> When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
>> it is observed that perf is doubled.
>>
>>
>> V6:
>> 	- follow Pavel's suggestion to disallow IOSQE_CQE_SKIP_SUCCESS &
>> 	  LINK_TIMEOUT
>> 	- kill __io_complete_group_member() (Pavel)
>> 	- simplify link failure handling (Pavel)
>> 	- move members' queuing out of completion lock (Pavel)
>> 	- cleanup group io complete handler
>> 	- add more comment
>> 	- add ublk zc into liburing test for covering
>> 	  IOSQE_SQE_GROUP & IORING_PROVIDE_GROUP_KBUF 
> 
> Any comments on V6? So that I may address them in next version since
> v6 has small conflict with mainline.

It looks fine to me, don't know if Pavel has any comments. Maybe just
toss out a v7 so it applies cleanly? I'll kick off the 6.13 branch
pretty soon.

-- 
Jens Axboe

