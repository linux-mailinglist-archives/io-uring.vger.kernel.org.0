Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59A714DDEE
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgA3Pe3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 10:34:29 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33366 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3Pe2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 10:34:28 -0500
Received: by mail-il1-f193.google.com with SMTP id s18so3430265iln.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 07:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=acW0X9oK1Ap7WOtrRwRlzwH0t6s+wm/kCwYsrvv0Vvc=;
        b=bgSc6uRkzBR7Cw466WY1vL/KAHyGD+JmbVG/5Cdb3zMu6AGI4Rd5K2/5qT6qJ86L0I
         +pAAlQbg56IqLWgGnWJiUMa3oI0dydIgTUfpUujeiGygjj5A/OgmwLE5tfI09VpYnY3Z
         eC05McBs7ulf3OexcAMapDWe/xFCznepUic9KPurMmxUyJ0T1yi3n5sswJPvZC1EBH+d
         5gScXt2Wf9oWEjBvHzxXk0jrx4FUpQ5PwV+vrvV8fmpD5/6wtmz3g2R71H7XPQg82oDl
         V0PXNkUAn6dyH/ECvNA8krgCj+bCTjCTZwYkYNKp+MBRJo8Ll4SoGXeHDPkY+4TPFQsW
         bS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=acW0X9oK1Ap7WOtrRwRlzwH0t6s+wm/kCwYsrvv0Vvc=;
        b=aZHsmJmt00CRNIRhqqWd4IrtLuPNqOQMshuQBzNxmn1da4m1G8gGBiLBr0AH3uSd7B
         RkHOcoDZYuDUwt1ZpGYOpRjqTAfhVdYI7Ki3Kxmi1YE6JkcTJniJOA+Wek7uICuG658Q
         EAXuUITcK1wdkYlQPTwAJBIYdp9szty/dL5yWM7kCliZuwoPS14TfrKDw8PnAXsWE3e/
         NPJ9zzwzV/AaThAJsrrrFTxNY71444XFFS2wrEzU4VWDBLH7m7SO82dE7lsNN6o0BS9J
         xLbwgFE7kJIZMhh+svYJtIV5YXjvrc3MpoV7lrG9yyqLrNdGZaLucEBZMJ8Wgi7od8x4
         3vJg==
X-Gm-Message-State: APjAAAV4bCRBb3YrNB73yMZSGpIAVMaYfEJsfZiLLCdpFCnvrg8M3JUp
        TupnKaekz+zN766PPnK7BLfExA==
X-Google-Smtp-Source: APXvYqx2g2iD9xV6L0g41fUDxMBsZAZ+c7Bt99Gi2vwbr7qEUsNXDVrwpSIxfOa5C1JFMh1d10zYqQ==
X-Received: by 2002:a92:d3cd:: with SMTP id c13mr4696511ilh.21.1580398467764;
        Thu, 30 Jan 2020 07:34:27 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u80sm1963076ili.77.2020.01.30.07.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 07:34:27 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Stefan Metzmacher <metze@samba.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
 <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
 <0b72d000-02be-9974-900f-d94af1cbc08a@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18629b74-d954-3939-fafa-c71c4423ac17@kernel.dk>
Date:   Thu, 30 Jan 2020 08:34:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0b72d000-02be-9974-900f-d94af1cbc08a@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/20 7:47 AM, Stefan Metzmacher wrote:
> Am 30.01.20 um 15:11 schrieb Jens Axboe:
>> On 1/30/20 3:26 AM, Christian Brauner wrote:
>>> On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
>>>> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>>>>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>>>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>>>> [...]
>>>>>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>>>>>> just having one link, it doesn't support a chain of them.
>>>>>>> [...]
>>>>>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>>>>>> implementation and use. And the fact that we'd have to jump through
>>>>>>>> hoops to make this work for a full chain.
>>>>>>>>
>>>>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>>>>>> This makes it way easier to use. Same branch:
>>>>>>>>
>>>>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>>>>
>>>>>>>> I'd feel much better with this variant for 5.6.
>>>>>>>
>>>>>>> Some general feedback from an inspectability/debuggability perspective:
>>>>>>>
>>>>>>> At some point, it might be nice if you could add a .show_fdinfo
>>>>>>> handler to the io_uring_fops that makes it possible to get a rough
>>>>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>>>>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>>>>>> helpful for debugging to be able to see information about the fixed
>>>>>>> files and buffers that have been registered. Same for the
>>>>>>> personalities; that information might also be useful when someone is
>>>>>>> trying to figure out what privileges a running process actually has.
>>>>>>
>>>>>> Agree, that would be a very useful addition. I'll take a look at it.
>>>>>
>>>>> Jann, how much info are you looking for? Here's a rough start, just
>>>>> shows the number of registered files and buffers, and lists the
>>>>> personalities registered. We could also dump the buffer info for
>>>>> each of them, and ditto for the files. Not sure how much verbosity
>>>>> is acceptable in fdinfo?
>>>>
>>>> At the moment, I personally am just interested in this from the
>>>> perspective of being able to audit the state of personalities, to make
>>>> important information about the security state of processes visible.
>>>>
>>>> Good point about verbosity in fdinfo - I'm not sure about that myself either.
>>>>
>>>>> Here's the test app for personality:
>>>>
>>>> Oh, that was quick...
>>>>
>>>>> # cat 3
>>>>> pos:    0
>>>>> flags:  02000002
>>>>> mnt_id: 14
>>>>> user-files: 0
>>>>> user-bufs: 0
>>>>> personalities:
>>>>>             1: uid=0/gid=0
>>>>>
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index c5ca84a305d3..0b2c7d800297 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -6511,6 +6505,45 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>>>         return submitted ? submitted : ret;
>>>>>  }
>>>>>
>>>>> +struct ring_show_idr {
>>>>> +       struct io_ring_ctx *ctx;
>>>>> +       struct seq_file *m;
>>>>> +};
>>>>> +
>>>>> +static int io_uring_show_cred(int id, void *p, void *data)
>>>>> +{
>>>>> +       struct ring_show_idr *r = data;
>>>>> +       const struct cred *cred = p;
>>>>> +
>>>>> +       seq_printf(r->m, "\t%5d: uid=%u/gid=%u\n", id, cred->uid.val,
>>>>> +                                               cred->gid.val);
>>>>
>>>> As Stefan said, the ->uid and ->gid aren't very useful, since when a
>>>> process switches UIDs for accessing things in the filesystem, it
>>>> probably only changes its EUID and FSUID, not its RUID.
>>>> I think what's particularly relevant for uring would be the ->fsuid
>>>> and the ->fsgid along with ->cap_effective; and perhaps for some
>>>> operations also the ->euid and ->egid. The real UID/GID aren't really
>>>> relevant when performing normal filesystem operations and such.
>>>
>>> This should probably just use the same format that is found in
>>> /proc/<pid>/status to make it easy for tools to use the same parsing
>>> logic and for the sake of consistency. We've adapted the same format for
>>> pidfds. So that would mean:
>>>
>>> Uid:	1000	1000	1000	1000
>>> Gid:	1000	1000	1000	1000
>>>
>>> Which would be: Real, effective, saved set, and filesystem {G,U}IDs
>>>
>>> And CapEff in /proc/<pid>/status has the format:
>>> CapEff:	0000000000000000
>>
>> I agree, consistency is good. I've added this, and also changed the
>> naming to be CamelCase, which is seems like most of them are. Now it
>> looks like this:
>>
>> pos:	0
>> flags:	02000002
>> mnt_id:	14
>> UserFiles:     0
>> UserBufs:     0
>> Personalities:
>>     1
>> 	Uid:	0		0		0		0
>> 	Gid:	0		0		0		0
>> 	Groups:	0
>> 	CapEff:	0000003fffffffff
>>
>> for a single personality registered (root). I have to indent it an extra
>> tab to display each personality.
> 
> That looks good.
> 
> Maybe also print some details of struct io_ring_ctx,
> flags and the ring sizes, ctx->cred.
> 
> Maybe details for io_wq and sqo_thread.

Yeah, I agree that we should probably just add a ton more, there's
plenty of information that would be useful. But let's start simple - I
forgot to CC you on the patch I just sent out, but it's basically the
above cleaned up. We dump information that's registered with the ring,
that's the theme right now. I'd be happy to add some of the state
information as well, we should do that as a separate patch.

> Maybe pending requests?
> I'm not sure about how io_wq threads work in detail.
> Is it possible that a large number of blocking request
> (against an external harddisk with disconnected cable)
> to block other blocking requests to a working ssd?
> It would be good to diagnose such situations from
> the output.

io_uring doesn't necessarily track pending requests, only if it has to.
For bounded request time IO, like the above, it'll depend on the
concurrency level. If you setup the ring with eg N entries, that'll be
at most N pending bounded requests. If all of those are blocked because
the disk isn't responding, yes, that could happen. At least until the
timeout happens.

> How is this supposed to be ABI-wise? Is it possible to change
> the output in later kernel versions?

We should always be able to append to the file, I'd just prefer if we
don't change the format of lines that have already been added.

-- 
Jens Axboe

