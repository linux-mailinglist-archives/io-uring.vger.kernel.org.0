Return-Path: <io-uring+bounces-1794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FEF8BD407
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 19:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D50628147E
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 17:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47698157493;
	Mon,  6 May 2024 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="H+Au6r4F"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF602156962;
	Mon,  6 May 2024 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715017585; cv=none; b=KuLtLGu+wD3/tg2frBWuUwB0pS4MHFGV1oKoclmIBjbnx8zytQAyBW9xv0+6cq4TAE5J2aTID6Ikb7/MxJYI2BtXDCh4qqblu3MDUx48/aWda3DQnqnHg04CDOgA0y+ztVq9cpfop/UHPLc7PgvkMOla90Q6kPJrGLlTGKAF7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715017585; c=relaxed/simple;
	bh=vqnYuRDE7YAdIfHB4y1v8PCKhpIU6Ck4Nohhh0+FmK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpmTVM1JBBPxFiGEnppm8trlczDr+Sv+rczRjZZ0n2Id4X+a0agWSll8zFN2B4FgEq18R3kAsnsr8eynG4e/LcG5xRrtSQYzPfzv+ew2GAcIN6pp4DfKfcGbec93ZXqTKAgZb3KhaBFjFYG8PaWHWDJ2eXf7+V0QCE8LVT4UsCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=H+Au6r4F; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xw3p/mu9rqf4LynApLZg3ICv4KBQ9pI/cT8ZAvWfrvU=; b=H+Au6r4F4x1Z85+DNGjlJceQt6
	VaCVEcT4DEiGQbGVDh4OFym0kKFZBd86s6uXoJpPJTol6iKXqn0LG0HyJx8lIh8EDuo+2i5hrqN2O
	vk8Qm3pQwBYOe4xDEpVSHAJ94SfEJi+QIlADWRgaZl2lxVH8SKQJpWHxqdqPKPehOFIM8Su38HTbz
	tZmG9bvQ+46+S74+Tc+2yjeIEhU2KGEf6hYY0sJQDTqbdzLZTPufeLvN5VPgkNTHPOYPIkOVO0+81
	syykN+b+56a1Khj1sPfDj2zaRMDolfZReWyrBPwwCMLHxuCZrQqarp8odXqr9D7+gq22C7zDhtgFs
	CDqB8Lqc9X0g5Di3lkjVsfjGTFg7PxYd9cX9RXsShaBKDeLBvJeTRzcKI1+KkmZWflxdWQiL7szBw
	xvayOxyIs7UU8VHV51kSkC6VEOl3cP9Ch3jcC1obaPYpZYp8zP/YEf1lCPpQ6pc093IgCA0JBFcfa
	tXQCy/UeOaoa1sQS6m4mY1a7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s42Pk-00A49V-1t;
	Mon, 06 May 2024 17:46:12 +0000
Message-ID: <501ead34-d79f-442e-9b9a-ecd694b3015c@samba.org>
Date: Mon, 6 May 2024 19:46:08 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?] [io-uring?]
 general protection fault in __ep_remove)
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>,
 Bui Quang Minh <minhquangbui99@gmail.com>,
 Christian Brauner <brauner@kernel.org>,
 syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook> <202405031325.B8979870B@keescook>
 <20240503211109.GX2118490@ZenIV>
 <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 03.05.24 um 23:24 schrieb Linus Torvalds:
> On Fri, 3 May 2024 at 14:11, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> What we need is
>>          * promise that ep_item_poll() won't happen after eventpoll_release_file().
>> AFAICS, we do have that.
>>          * ->poll() not playing silly buggers.
> 
> No. That is not enough at all.
> 
> Because even with perfectly normal "->poll()", and even with the
> ep_item_poll() happening *before* eventpoll_release_file(), you have
> this trivial race:
> 
>    ep_item_poll()
>       ->poll()
> 
> and *between* those two operations, another CPU does "close()", and
> that causes eventpoll_release_file() to be called, and now f_count
> goes down to zero while ->poll() is running.
> 
> So you do need to increment the file count around the ->poll() call, I feel.
> 
> Or, alternatively, you'd need to serialize with
> eventpoll_release_file(), but that would need to be some sleeping lock
> held over the ->poll() call.
> 
>> As it is, dma_buf ->poll() is very suspicious regardless of that
>> mess - it can grab reference to file for unspecified interval.
> 
> I think that's actually much preferable to what epoll does, which is
> to keep using files without having reference counts to them (and then
> relying on magically not racing with eventpoll_release_file().

I think it's a very important detail that epoll does not take
real references. Otherwise an application level 'close()' on a socket
would not trigger a tcp disconnect, when an fd is still registered with
epoll.

I noticed that some parts of Samba currently rely on this when I tried
to convert tevent from epoll to IORING_OP_POLL_ADD (which takes a longer term reference)

And I guess there will be other applications also relying on the current epoll
behavior. That a closed fs automatically removes itself from epoll.

A short term reference just around ->poll() might be fine,
but please no reference via EPOLL_CTL_ADD.

Changing that can cause security problems in user space.

I haven't followed all details of this thread,
please ignore me if that's all clear already :-)

Thanks!
metze



