Return-Path: <io-uring+bounces-1683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 874538B7513
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 14:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F31D51F22FBB
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 12:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0087132808;
	Tue, 30 Apr 2024 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ja+zeHMx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1BC12D741;
	Tue, 30 Apr 2024 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714478417; cv=none; b=JL3X2kmG61WL/ZT8nu1WIixzoq/6fbGdP4SxjcgxF2RCUepeHJQmu++XUl3lmMUGX39xd5blUFS25XESZHbia/P8X3ixzv+Nl34ir76Otf4sNv74IYzCptGyZXLkW7tE5XPIP8GePA4BYgPw6zgIBGF2Is0dgMyB7VQ8Xm6ZTHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714478417; c=relaxed/simple;
	bh=BSh9NGc/mQsL8gDMq6Tv3RcdflHNyBd72gHnKSXRn6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3hOqQW7Ji1fEmw6uFRjrTK8oonz7Yd+q7P8kFMB3iez8e8XgQqIry21yaUDzNgmz5R8Y4hn/eN7pPCua93D87aljYjZ10L/d8AKpRnH8xHzAXOCjmuTSnY+LQSO3cYUaSx/Q9jy9cvkZSDjVMAlOUvm6nz126YFqIhcpGQjOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ja+zeHMx; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-518a56cdbcfso8902155e87.2;
        Tue, 30 Apr 2024 05:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714478414; x=1715083214; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6wrsZKdSKAtNQDB064U7j9lty8GA8lRB060N34oQaaM=;
        b=Ja+zeHMxFYZGqXFfqBOVWdZg0I/7XfM1THnQFNmAevmKXCwe+Hin1qVkWPEuli+Mpm
         IsZ5O0jLZt1NhNnAW7hzZ/jHzV9hlKHoB5FfefaR1T7PsrECInssQlx1BDPZYtwW6zle
         8yaNONsiLul/kB1SlkpK7dn1bhy4LK3Ez1PptOoEy+0mErCP/7ntkr2kzRErOUk8d7np
         tHwtzVJzr6w2nMzdYVlNwchVmrTRPj85cBz1f8O2zGvokb5OTb8LHsMZTMpmR/GLurY9
         6n2myLtCzTbQ7mwgHnhj1mcmB6o1OOSYedBbH1nwwYFGvmxKvkJ2kn29dEOB6OSNzpYG
         c0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714478414; x=1715083214;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6wrsZKdSKAtNQDB064U7j9lty8GA8lRB060N34oQaaM=;
        b=Q7cqeCrXr9FfGPp69hV4uOhBt/NHiPB4cwb7zflgygbZfIE2YtHMGa41F9K6eRVqzS
         CI4EO0Wrg4ooV6JEWcMt5w62OE9vh0RwW1eUYOKjtYENr9JntBtqfNrUO9JoI9ebMruj
         02R/5xYSFmDK3FTdve5kWttsHRQ7F0jG9j6nPub/MbgxMx0qC278IHlTmUmjrxWNtUiN
         o/d/xiiDXSBltOr/cyygvT/9lHl+5P4BNxfHa3f3Twt3vR44HKVkGhfq9eJr/9UJcsA0
         GpcoXOoSeiqGP9D26w7hw6K/dKqAsUpX5jUklInR03sm4HJo782CibAQei0dw1DDZX0V
         fJ5A==
X-Forwarded-Encrypted: i=1; AJvYcCXV9Z5pFwcMFpNYQ76X2/68cCS1mvWPiTEfsDXSoGG2AZFwkdAKNbhAQoFI/cYxVRUyfU6cclYmnt3zIQlB3O4d6vOSTcD1zIwQEgt5jPFekVOibZDYKDzScjwkPqL8FMVzjF7lGg==
X-Gm-Message-State: AOJu0YxYjWuocT0a9kgkw4/3gPo5AiHcJHlTWl+BkzT6z9oYezEYJrY3
	li4k3RM3E61PwNE4+BYgpEQRnKO8tKnwsefrqDQhQy62Zv9ysne+0oBslQ==
X-Google-Smtp-Source: AGHT+IGl+7zlnRmNB7zHxYUznLxVcOl2Yek3qycj3dsGlL5IERowmduUwFCOGRNUNa9MTCZa+76q2Q==
X-Received: by 2002:ac2:421a:0:b0:51a:e2a2:7262 with SMTP id y26-20020ac2421a000000b0051ae2a27262mr10721892lfh.8.1714478413988;
        Tue, 30 Apr 2024 05:00:13 -0700 (PDT)
Received: from [192.168.42.150] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id dk21-20020a170907941500b00a55aee4bf74sm11109225ejc.79.2024.04.30.05.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 05:00:13 -0700 (PDT)
Message-ID: <81bc860f-0801-478b-adba-ea2a90cfe69e@gmail.com>
Date: Tue, 30 Apr 2024 13:00:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
 <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk> <Zie+RlbtckZJVE2J@fedora>
 <e0d52e3f-f599-42c8-b9f0-8242961291d0@gmail.com> <ZjBozhXCCs46OeWK@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZjBozhXCCs46OeWK@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:43, Ming Lei wrote:
> On Mon, Apr 29, 2024 at 04:24:54PM +0100, Pavel Begunkov wrote:
>> On 4/23/24 14:57, Ming Lei wrote:
>>> On Mon, Apr 22, 2024 at 12:16:12PM -0600, Jens Axboe wrote:
>>>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>>>> sqe->flags is u8, and now we have used 7 bits, so take the last one for
>>>>> extending purpose.
>>>>>
>>>>> If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
>>>>> from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
>>>>> IORING_OP_URING_CMD.
>>>>>
>>>>> io_slot_flags() return value is converted to `ULL` because the affected bits
>>>>> are beyond 32bit now.
>>>>
>>>> If we're extending flags, which is something we arguably need to do at
>>>> some point, I think we should have them be generic and not spread out.
>>>
>>> Sorry, maybe I don't get your idea, and the ext_flag itself is always
>>> initialized in io_init_req(), like normal sqe->flags, same with its
>>> usage.
>>>
>>>> If uring_cmd needs specific flags and don't have them, then we should
>>>> add it just for that.
>>>
>>> The only difference is that bit23~bit16 of sqe->uring_cmd_flags is
>>> borrowed for uring_cmd's ext flags, because sqe byte0~47 have been taken,
>>> and can't be reused for generic flag. If we want to use byte48~63, it has
>>> to be overlapped with uring_cmd's payload, and it is one generic sqe
>>> flag, which is applied on uring_cmd too.
>>
>> Which is exactly the mess nobody would want to see. And I'd also
> 
> The trouble is introduced by supporting uring_cmd, and solving it by setting
> ext flags for uring_cmd specially by liburing helper is still reasonable or
> understandable, IMO.
> 
>> argue 8 extra bits is not enough anyway, otherwise the history will
>> repeat itself pretty soon
> 
> It is started with 8 bits, now doubled when io_uring is basically
> mature, even though history might repeat, it will take much longer time

You're mistaken, only 7 bits are taken not because there haven't been
ideas and need to use them, but because we're out of space and we've
been saving it for something that might be absolutely necessary.

POLL_FIRST IMHO should've been a generic feature, but it worked around
being a send/recv specific flag, same goes for the use of registered
buffers, not to mention ideas for which we haven't had enough flag space.

>>> That is the only way I thought of, or any other suggestion for extending sqe
>>> flags generically?
>>
>> idea 1: just use the last bit. When we need another one it'd be time
>> to think about a long overdue SQE layout v2, this way we can try
>> to make flags u32 and clean up other problems.
> 
> It looks over-kill to invent SQE v2 just for solving the trouble in
> uring_cmd, and supporting two layouts can be new trouble for io_uring.

Sounds too uring_cmd centric, it's not specifically for uring_cmd, it's
just one of reasons. As for overkill, that's why I'm not telling you
to change the layour, but suggesting to take the last bit for the
group flag and leave future problems for the future.


> Also I doubt the problem can be solved in layout v2:
> 
> - 64 byte is small enough to support everything, same for v2
> 
> - uring_cmd has only 16 bytes payload, taking any byte from
> the payload may cause trouble for drivers
> 
> - the only possible change could still be to suppress bytes for OP
> specific flags, but it might cause trouble for some OPs, such as
> network.

Look up sqe's __pad1, for example


>> idea 2: the group assembling flag can move into cmds. Very roughly:
>>
>> io_cmd_init() {
>> 	ublk_cmd_init();
>> }
>>
>> ublk_cmd_init() {
>> 	io_uring_start_grouping(ctx, cmd);
>> }
>>
>> io_uring_start_grouping(ctx, cmd) {
>> 	ctx->grouping = true;
>> 	ctx->group_head = cmd->req;
>> }
> 
> How can you know one group is starting without any flag? Or you still
> suggest the approach taken in fused command?

That would be ublk's business, e.g. ublk or cmds specific flag


>> submit_sqe() {
>> 	if (ctx->grouping) {
>> 		link_to_group(req, ctx->group_head);
>> 		if (!(req->flags & REQ_F_LINK))
>> 			ctx->grouping = false;
>> 	}
>> }
> 
> The group needs to be linked to existed link chain, so reusing REQ_F_LINK may
> not doable.

Would it break zero copy feature if you cant?

-- 
Pavel Begunkov

