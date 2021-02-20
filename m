Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643E03205D2
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 15:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhBTOvm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 09:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhBTOvl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 09:51:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71F2C06178A
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:50:59 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so3824236pfk.1
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oau4zWWMB5uBOfBTp8SGUOcYtkty7su3Om3BnkoJ0YQ=;
        b=Xj/UGOy9YZkxMh4Jzcyh4Qe1umUC/TeQ+LKUtDI+xmoCD5CzvSMPIobRAU9OwcXcmP
         zSvX9hK+mz8irnB7pdAm8QSMRG5lpRmGvMV01m3wT5gvn6o/v4UJqEll9lsG4AI87U1Q
         D+E6hNLtHQgJsz1VuUAQtReofCdpAsQCMu3M2+LQmoxis7vQ0Peqh+rgocFjRaHKwcLm
         gfZKpnRG084G0ol46CTg+Rbyjq7zNpzqUXVjA90ULR97nYBrMlbDrnCNmZjXwNZi7cJ8
         DH2AXTWhVEs1YaMY0vWLbrXwWdTFg90Thomr+vKnFFNIIxmEU8vFEYN3Az1D4LPFUiLh
         XBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oau4zWWMB5uBOfBTp8SGUOcYtkty7su3Om3BnkoJ0YQ=;
        b=j0GgNmJA0TIRt8BwbQetd5wKQtPOzYkECS7tbklyD/pg97grumixTFJ27RIp6VYUkL
         nuow/DWawlW5B8reh00AmqmjkTxG2hs0ETpXpYyInJJXWgBTrmjqp0ty9TXONTpnVh8R
         Xvzwd04V6U80WkkOsAwTczxeERX16yFZj6xqxyODYO6HltizmGWGoY1wQKyDmmd6FkyT
         1n6syxAFNpo6UsWojayhLPDkbfUIBqLw0U7HT6s8aPmR9ARzgoBN4O5kpmZHUfLNp53Z
         /Wsb4XIDqdNHOPbo2r0r030+SWQ8zf7/Dy54mpEVAedf9sOxGNpdTHGddRAoT7sPBFKQ
         a49Q==
X-Gm-Message-State: AOAM532+93/9PQGREkH+Oq2LTPMvIN4YulF7l82NQc0uqi0clepxa6zH
        Jql7CMAnQYz4Mcb7dbeVLD/E4rAcIJmzfQ==
X-Google-Smtp-Source: ABdhPJzPVFHqpjx3/2MSCERbH2OukRXNQDStKdGcWqsMKrHN+BN5vbDGvuBXVjHKdWQSYPRftgngEA==
X-Received: by 2002:a63:2f86:: with SMTP id v128mr12578311pgv.241.1613832658410;
        Sat, 20 Feb 2021 06:50:58 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q4sm3441038pfs.134.2021.02.20.06.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 06:50:57 -0800 (PST)
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
To:     Stefan Metzmacher <metze@samba.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
 <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <187cbfad-0dfe-9a16-11f0-bfe18a6c7520@kernel.dk>
Date:   Sat, 20 Feb 2021 07:50:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 8:57 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> Am 28.01.21 um 03:19 schrieb Jens Axboe:
>>>> Assuming that I got that right, that means that the pdu information
>>>> doesn't actually go all the way to the end of the sqe, which currently
>>>> is just a bunch of padding.  Was that intentional, or does this mean
>>>> that io_uring_pdu could actually be 8 bytes longer?
>>>
>>> Also correct. The reason is actually kind of stupid, and I think we
>>> should just fix that up. struct io_uring_cmd should fit within the first
>>> cacheline of io_kiocb, to avoid bloating that one. But with the members
>>> in there, it ends up being 8 bytes too big, if we grab those 8 bytes.
>>> What I think we should do is get rid of ->done, and just have drivers
>>> call io_uring_cmd_done() instead. We can provide an empty hook for that.
>>> Then we can reclaim the 8 bytes, and grow the io_uring_cmd to 56 bytes.
>>
>> Pushed out that version:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v2
>>
>> which gives you the full 56 bytes for the payload command.
> 
> I think we only have 48 bytes for the payload.

You are right, it's 64b minus 8 for the head, and 8 for user_data.

> I've rebased and improved your io_uring-fops.v2 on top of your io_uring-worker.v3.

Heh, I did that myself yesterday too, when I was folding in two fixes!

> See https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-fops

Had a quick look, and some good stuff in there. So thanks for that. One
question, though - if you look at mine, you'll see I moved the force_nonblock
to be using the issue_flags instead. You dropped that from the issue path,
we definitely need that to be able to punt the request if we're in the
nonblock/fast path.

> 
> I've changed the layout like this:
> 
> struct io_uring_sqe {
>         __u8    opcode;         /* type of operation for this sqe */
>         __u8    flags;          /* IOSQE_ flags */
>         union {
>                 __u16   ioprio;         /* ioprio for the request */
>                 __u16   cmd_personality; /* IORING_OP_URING_CMD */
>         };
>         __s32   fd;             /* file descriptor to do IO on */
>         union {
>                 __u64   off;    /* offset into file */
>                 __u64   addr2;
>                 __u64   cmd_user_data; /* IORING_OP_URING_CMD: data to be passed back at completion time */
>         };
>         union {
>                 __u64   addr;   /* pointer to buffer or iovecs */
>                 __u64   splice_off_in;
>                 __u64   cmd_pdu_start; /* IORING_OP_URING_CMD: this is the start for the remaining 48 bytes */
>         };
> 
> And then use:
> 
> struct io_uring_cmd_pdu {
>        __u64 data[6]; /* 48 bytes available for free use */
> };
> 
> So we effectively have this:
> 
> struct io_uring_cmd_sqe {
>         __u8    opcode;         /* type of operation for this sqe */
>         __u8    flags;          /* IOSQE_ flags */
>         __u16   cmd_personality; /* IORING_OP_URING_CMD */
>         __s32   fd;             /* file descriptor to do IO on */
>         __u64   cmd_user_data; /* IORING_OP_URING_CMD: data to be passed back at completion time */
>         union {
>                 __u64   cmd_pdu_start; /* IORING_OP_URING_CMD: this is the start for the remaining 48 bytes */
>                 struct io_uring_cmd_pdu cmd_pdu;
>         };
> }
> 
> I think it's saner to have a complete block of 48 bytes available for the payload
> and move personality and user_data to to top if opcode is IORING_OP_URING_CMD
> instead of having a hole that can't be touched.
> 
> I also finished the socket glue from struct file -> struct socket -> struct sock
> 
> I think it compiles, but I haven't done any tests.
> 
> What do you think?

I've been thinking along the same lines, because having a sparse sqe layout
for the uring cmd is a pain. I do think 'personality' is a bit too specific
to be part of the shared space, that should probably belong in the pdu
instead if the user needs it. One thing they all have in common is that they'd
need a sub-command, so why not make that u16 that?

There's also the option of simply saying that the uring_cmd sqe is just
a different type, ala:

struct io_uring_cmd_sqe {
	__u8	opcode;		/* IO_OP_URING_CMD */
	__u8	flags;
	__u16	target_op;
	__s32	fd;
	__u64	user_data;
	strut io_uring_cmd_pdu cmd_pdu;
};

which is essentially the same as your suggestion in terms of layout
(because that is the one that makes the most sense), we just don't try
and shoe-horn it into the existing sqe. As long as we overlap
opcode/flags, then init is fine. And past init, sqe is already consumed.

Haven't tried and wire that up yet, and it may just be that the simple
layout change you did is just easier to deal with. The important part
here is the layout, and I certainly think we should do that. There's
effectively 54 bytes of data there, if you include the target op and fd
as part of that space. 48 fully usable for whatever.

-- 
Jens Axboe

