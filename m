Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F06E320645
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 17:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBTQq2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 11:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhBTQq2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 11:46:28 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A9AC061786
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 08:45:48 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t26so7395710pgv.3
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 08:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jTtWU2jKB8x02/6CYX3uUYRkf/v10iO8tpw+cFFAklQ=;
        b=LC82ksxPjJvW6JsVMUzJ8gaEuSoBXOvO7sZiftv/+3qdi9cxoWXLF8pngaB6LiNeeo
         eUa9lV8xLNa2Fkgg3dfqQFSZ9vqWnglOPMxfi7BdswZskeIBq/tAYZFBXJcd3YIRi9Va
         M0EzwGqVeIBdfFH5ZWczY2/XpV0Po1O4di2OyaWgv2mnAtfEI20ab23raH6Ql/hN3u8U
         eCSD/HjucrlBMRnFbdddwVlBHT5C0i3cSy5I/N3PLPQa5Ms3fyv0Kanu5XG19hWW7MAx
         2M8MwKFOee65JRBl0+rQC3LjFTNyyniBxzXotFFPGuweMsWl6M9tPwCU2eGOdUHWFNfv
         F4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jTtWU2jKB8x02/6CYX3uUYRkf/v10iO8tpw+cFFAklQ=;
        b=YD0sEeGnwiABLBbyu23gKfbPbK2FU7d5LCOuMGCvuBdj/N/uV945qbC2xaPpSpci/C
         FUAGl7soETOLqYkrBYhSj5a3xILqLr5dZDyaH7EG318OUaVZ7Fd0fLnSUsn6JiX09YtU
         JsXA54cgOLemvq3KkLBqB4JJowdOfRQu+Ana0O9/hSDRKL+x/vOKs+4xo6RznU/Y23Ah
         9UdzzwGdcOvYhZI7SWdFfh6LcWYnYFp4qArUTPXPYehvZFJgrJMsp/3L9+a5Za+ldNYz
         2mWC17HXXSYSqytxS/5jX0M7sdkpEjK1pH/0b0i34qneQCt5NdfVv0LlBMLueLYA7mpF
         OdYA==
X-Gm-Message-State: AOAM533ZYGdMP7grRfg+qsLR+DTJttQ9nVLcIzkYCcTJ+boqfC13ifVL
        iBOIhevdWCuCh02Sd4lYgw7pX4nmHhzldA==
X-Google-Smtp-Source: ABdhPJwNRUtVeaS1apy8trOYS9101PwO288HP5+DpQcsHh4Saj5ImDMyXN0GJvaO5Drzn1pNi5PcyA==
X-Received: by 2002:a05:6a00:15cc:b029:1ba:5282:3ab8 with SMTP id o12-20020a056a0015ccb02901ba52823ab8mr14529258pfu.77.1613839547097;
        Sat, 20 Feb 2021 08:45:47 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p19sm12279368pjo.7.2021.02.20.08.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 08:45:46 -0800 (PST)
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
 <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
 <187cbfad-0dfe-9a16-11f0-bfe18a6c7520@kernel.dk>
Message-ID: <58fe1e10-ed71-53f9-c47c-5e64066d3290@kernel.dk>
Date:   Sat, 20 Feb 2021 09:45:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <187cbfad-0dfe-9a16-11f0-bfe18a6c7520@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/21 7:50 AM, Jens Axboe wrote:
> On 2/19/21 8:57 PM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>> Am 28.01.21 um 03:19 schrieb Jens Axboe:
>>>>> Assuming that I got that right, that means that the pdu information
>>>>> doesn't actually go all the way to the end of the sqe, which currently
>>>>> is just a bunch of padding.  Was that intentional, or does this mean
>>>>> that io_uring_pdu could actually be 8 bytes longer?
>>>>
>>>> Also correct. The reason is actually kind of stupid, and I think we
>>>> should just fix that up. struct io_uring_cmd should fit within the first
>>>> cacheline of io_kiocb, to avoid bloating that one. But with the members
>>>> in there, it ends up being 8 bytes too big, if we grab those 8 bytes.
>>>> What I think we should do is get rid of ->done, and just have drivers
>>>> call io_uring_cmd_done() instead. We can provide an empty hook for that.
>>>> Then we can reclaim the 8 bytes, and grow the io_uring_cmd to 56 bytes.
>>>
>>> Pushed out that version:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v2
>>>
>>> which gives you the full 56 bytes for the payload command.
>>
>> I think we only have 48 bytes for the payload.
> 
> You are right, it's 64b minus 8 for the head, and 8 for user_data.
> 
>> I've rebased and improved your io_uring-fops.v2 on top of your io_uring-worker.v3.
> 
> Heh, I did that myself yesterday too, when I was folding in two fixes!
> 
>> See https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-fops
> 
> Had a quick look, and some good stuff in there. So thanks for that. One
> question, though - if you look at mine, you'll see I moved the force_nonblock
> to be using the issue_flags instead. You dropped that from the issue path,
> we definitely need that to be able to punt the request if we're in the
> nonblock/fast path.
> 
>>
>> I've changed the layout like this:
>>
>> struct io_uring_sqe {
>>         __u8    opcode;         /* type of operation for this sqe */
>>         __u8    flags;          /* IOSQE_ flags */
>>         union {
>>                 __u16   ioprio;         /* ioprio for the request */
>>                 __u16   cmd_personality; /* IORING_OP_URING_CMD */
>>         };
>>         __s32   fd;             /* file descriptor to do IO on */
>>         union {
>>                 __u64   off;    /* offset into file */
>>                 __u64   addr2;
>>                 __u64   cmd_user_data; /* IORING_OP_URING_CMD: data to be passed back at completion time */
>>         };
>>         union {
>>                 __u64   addr;   /* pointer to buffer or iovecs */
>>                 __u64   splice_off_in;
>>                 __u64   cmd_pdu_start; /* IORING_OP_URING_CMD: this is the start for the remaining 48 bytes */
>>         };
>>
>> And then use:
>>
>> struct io_uring_cmd_pdu {
>>        __u64 data[6]; /* 48 bytes available for free use */
>> };
>>
>> So we effectively have this:
>>
>> struct io_uring_cmd_sqe {
>>         __u8    opcode;         /* type of operation for this sqe */
>>         __u8    flags;          /* IOSQE_ flags */
>>         __u16   cmd_personality; /* IORING_OP_URING_CMD */
>>         __s32   fd;             /* file descriptor to do IO on */
>>         __u64   cmd_user_data; /* IORING_OP_URING_CMD: data to be passed back at completion time */
>>         union {
>>                 __u64   cmd_pdu_start; /* IORING_OP_URING_CMD: this is the start for the remaining 48 bytes */
>>                 struct io_uring_cmd_pdu cmd_pdu;
>>         };
>> }
>>
>> I think it's saner to have a complete block of 48 bytes available for the payload
>> and move personality and user_data to to top if opcode is IORING_OP_URING_CMD
>> instead of having a hole that can't be touched.
>>
>> I also finished the socket glue from struct file -> struct socket -> struct sock
>>
>> I think it compiles, but I haven't done any tests.
>>
>> What do you think?
> 
> I've been thinking along the same lines, because having a sparse sqe layout
> for the uring cmd is a pain. I do think 'personality' is a bit too specific
> to be part of the shared space, that should probably belong in the pdu
> instead if the user needs it. One thing they all have in common is that they'd
> need a sub-command, so why not make that u16 that?
> 
> There's also the option of simply saying that the uring_cmd sqe is just
> a different type, ala:
> 
> struct io_uring_cmd_sqe {
> 	__u8	opcode;		/* IO_OP_URING_CMD */
> 	__u8	flags;
> 	__u16	target_op;
> 	__s32	fd;
> 	__u64	user_data;
> 	strut io_uring_cmd_pdu cmd_pdu;
> };
> 
> which is essentially the same as your suggestion in terms of layout
> (because that is the one that makes the most sense), we just don't try
> and shoe-horn it into the existing sqe. As long as we overlap
> opcode/flags, then init is fine. And past init, sqe is already consumed.
> 
> Haven't tried and wire that up yet, and it may just be that the simple
> layout change you did is just easier to deal with. The important part
> here is the layout, and I certainly think we should do that. There's
> effectively 54 bytes of data there, if you include the target op and fd
> as part of that space. 48 fully usable for whatever.

OK, folded in some of your stuff, and pushed out a new branch. Find it
here:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3

I did notice while doing so that you put the issue flags in the cmd,
I've made them external again. Just seems cleaner to me, otherwise
you'd have to modify the command for reissue rather than just
pass in the flags directly.

I also retained struct file * in the cmd - that's a requirement for
the layout of io_kiocb, so might as well keep it in there and not
pass in the file. Plus that one won't ever change...

Since we just need that one branch in req init, I do think that your
suggestion of just modifying io_uring_sqe is the way to go. So that's
what the above branch does.

I tested the block side, and it works for getting the bs of the
device. That's all the testing that has been done so far :-)

Comments welcome! Would like to move this one forward and hopefully
target 5.13 for it.

-- 
Jens Axboe

