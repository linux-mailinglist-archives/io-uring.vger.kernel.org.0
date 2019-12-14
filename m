Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC6B11F393
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 19:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfLNSwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 13:52:19 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42093 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNSwT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 13:52:19 -0500
Received: by mail-pl1-f194.google.com with SMTP id x13so2650960plr.9
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2019 10:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JXNSYmiyVo7J45ItzV9PCSkFWIS1r+3A4E6slrSpFSE=;
        b=bGbeJVz1GOQY1Bp2BCxd3Mn6LcOg9sn6BjFkJNqwsqSIIipID4KY1YZBLQu/1pAWk+
         sxRqaJ+y++8TDXAXLcpNhnZ62XB+u0P1SatNnWQg3pVzs9p0UzMsqPb4qQfQj+SplYEn
         zRGInrElloEFrABG8nLWyy7AlxgUSj+XT9FIQR/ObsaaJcT55izkmbDtnFnPYhiyUQK/
         fnREpgyEQDQylGkFMi9oLTZ4LXh3sn9rDfZpx1AUxrvhSbcXTJELwG3h+awayONQO58o
         mRgvBY0CzIq6HF6f0pbHjlNW4A1pHXX4mP5/UE5DKzMc7cgPyYqsSTepERapkUQWR8To
         f4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JXNSYmiyVo7J45ItzV9PCSkFWIS1r+3A4E6slrSpFSE=;
        b=ROw5ogIiWowCm0yNAeLr285eZYTPZb0Icyp4Y3gxvlTeYuhlAje1WGMIXCxzPR5f1u
         iTseWTZV4Rk+chOn3quMURttxHwljS0ZstS8ninxWAsLb3VRUF8uDkOI16rMABBD0S2g
         DfyOhXHr00XjKnADbAbEV91/5gosBlY2jAtBlYf8wwEy4uFxo6rH9NyfcD/rUPvEgGPD
         X1OVscNBChJ5z0WyEZ+xPmD29Em2CbR60Kf4iDHSmO5f5/sC1v8GZfH3YE1p/haA1/tS
         Vymuv5i1TBKpnQyAgOHbFjUbxjCTnBK5SZwm4qLrlyLaNKW9Mb/kjrIJktHPlOZhhWdo
         1lGA==
X-Gm-Message-State: APjAAAWURxc7Fv07mEr6QneiDlgs2VxGaj94UVxQjqZodZyQPxgHCj/k
        tQgaeivh7AksHRgc8WZ4sb3mCu7I8g4xHw==
X-Google-Smtp-Source: APXvYqzFQqZ9ceh+DjkMnuxKikVaS5h6iykAvPcLfPTHyz1yFGU9Crpgey4Zl6K7IfqcIprbiJFfhg==
X-Received: by 2002:a17:902:70cb:: with SMTP id l11mr6594894plt.216.1576349538419;
        Sat, 14 Dec 2019 10:52:18 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a13sm16044703pfc.40.2019.12.14.10.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 10:52:17 -0800 (PST)
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
 <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
 <9b4f56c1-dce9-1acd-2775-e64a3955d8ee@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1f995281-4a56-a7de-d20b-14b0f64536c0@kernel.dk>
Date:   Sat, 14 Dec 2019 11:52:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9b4f56c1-dce9-1acd-2775-e64a3955d8ee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/19 10:56 AM, Pavel Begunkov wrote:
> 
> On 14/12/2019 20:12, Jann Horn wrote:
>> On Sat, Dec 14, 2019 at 4:30 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> This works almost like ioctl(2), except it doesn't support a bunch of
>>> common opcodes, (e.g. FIOCLEX and FIBMAP, see ioctl.c), and goes
>>> straight to a device specific implementation.
>>>
>>> The case in mind is dma-buf, drm and other ioctl-centric interfaces.
>>>
>>> Not-yet Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> It clearly needs some testing first, though works fine with dma-buf,
>>> but I'd like to discuss whether the use cases are convincing enough,
>>> and is it ok to desert some ioctl opcodes. For the last point it's
>>> fairly easy to add, maybe except three requiring fd (e.g. FIOCLEX)
>>>
>>> P.S. Probably, it won't benefit enough to consider using io_uring
>>> in drm/mesa, but anyway.
>> [...]
>>> +static int io_ioctl(struct io_kiocb *req,
>>> +                   struct io_kiocb **nxt, bool force_nonblock)
>>> +{
>>> +       const struct io_uring_sqe *sqe = req->sqe;
>>> +       unsigned int cmd = READ_ONCE(sqe->ioctl_cmd);
>>> +       unsigned long arg = READ_ONCE(sqe->ioctl_arg);
>>> +       int ret;
>>> +
>>> +       if (!req->file)
>>> +               return -EBADF;
>>> +       if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>> +               return -EINVAL;
>>> +       if (unlikely(sqe->ioprio || sqe->addr || sqe->buf_index
>>> +               || sqe->rw_flags))
>>> +               return -EINVAL;
>>> +       if (force_nonblock)
>>> +               return -EAGAIN;
>>> +
>>> +       ret = security_file_ioctl(req->file, cmd, arg);
>>> +       if (!ret)
>>> +               ret = (int)vfs_ioctl(req->file, cmd, arg);
>>
>> This isn't going to work. For several of the syscalls that were added,
>> special care had to be taken to avoid bugs - like for RECVMSG, for the
>> upcoming OPEN/CLOSE stuff, and so on.
>>
>> And in principle, ioctls handlers can do pretty much all of the things
>> syscalls can do, and more. They can look at the caller's PID, they can
>> open and close (well, technically that's slightly unsafe, but IIRC
>> autofs does it anyway) things in the file descriptor table, they can
>> give another process access to the calling process in some way, and so
>> on. If you just allow calling arbitrary ioctls through io_uring, you
>> will certainly get bugs, and probably security bugs, too.
>>
>> Therefore, I would prefer to see this not happen at all; and if you do
>> have a usecase where you think the complexity is worth it, then I
>> think you'll have to add new infrastructure that allows each
>> file_operations instance to opt in to having specific ioctls called
>> via this mechanism, or something like that, and ensure that each of
>> the exposed ioctls only performs operations that are safe from uring
>> worker context.
> 
> Sounds like hell of a problem. Thanks for sorting this out!

While the ioctl approach is tempting, for the use cases where it makes
sense, I think we should just add a ioctl type opcode and have the
sub-opcode be somewhere else in the sqe. Because I do think there's
a large opportunity to expose a fast API that works with ioctl like
mechanisms. If we have

IORING_OP_IOCTL

and set aside an sqe field for the per-driver (or per-user) and
add a file_operations method for sending these to the fd, then we'll
have a much better (and faster + async) API than ioctls. We could
add fops->uring_issue() or something, and that passes the io_kiocb.
When it completes, the ->io_uring_issue() posts a completion by
calling io_uring_complete_req() or something.

Outside of the issues that Jann outlined, ioctls are also such a
decade old mess that we have to do the -EAGAIN punt for all of them
like you did in your patch. If it's opt-in like ->uring_issue(), then
care could be taken to do this right and just have it return -EAGAIN
if it does need async context.

ret = fops->uring_issue(req, force_nonblock);
if (ret == -EAGAIN) {
	... usual punt ...
}

I think working on this would be great, and some of the more performance
sensitive ioctl cases should flock to it.

-- 
Jens Axboe

