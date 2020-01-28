Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D1414BF22
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 19:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgA1SEo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 13:04:44 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34622 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgA1SEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 13:04:44 -0500
Received: by mail-il1-f193.google.com with SMTP id l4so11504551ilj.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 10:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QkOPikTFWGd6EkDEB6d3CyXk7VJdtAlQAyhbj1b204Q=;
        b=j0snadR+nkaKoJfQhsezQp18UioFNFqQVsSyabvZV8ZJsyFd9vsHZC2ndYR+8na2BF
         uMxravMg1HvOCWq+ic2F3nCum664c8LEo5mOSLWH6Siq6MV1bNPFpIIGyog7GHSRRm9x
         8eARGGfltWId/7vOlLjbGZLAg6xVkN+uRDaTJ8eXEsKOJjoAtMUs7NR5jlFJVjXZCGFz
         ioK3YOVjGDg5oecj2+c6ch7AElIz4KzL7eXICu1Xh5L/F8x0N437Q3ZUjIiNjXrnNRyW
         a8o95C8ch22Y4kwEL8fc7iCRna39BpVXOykrHoJ7aogWXGp7zR/3kQ1e6TyDIl/WKpwC
         Caog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QkOPikTFWGd6EkDEB6d3CyXk7VJdtAlQAyhbj1b204Q=;
        b=YGVb0NfYbmhPTVCBbg5LVAaHUkJW4R2gMCiyAg1UTZzzjWs0hA66raLtcFO4DJHrGx
         RJvqqvAf1kl2d2Tutsl3PGjEIxz1iYcxRKH5l7D7hPE0a6OLcPUz/mc8yrR0WO7+0TtR
         BQdcRLKRHCITCN0CDvt33aR1tH3Nkfeuyul+XVAChVVTqVsEDBPIFbiUYK3/5QZNwXS+
         crVCDrQ4ybEGIlX+4jY7Y10aGzBASPpqapQWEW0yA0aIMZlQumlUH4VPg/sAg+QxmYkC
         07rLTHZJUSOX0+l2I1cSdr2X91ShwLJe5iXpKl2f5lxl/Jm4GBuYm87QdMwtzAXP/3ed
         9MzA==
X-Gm-Message-State: APjAAAWHd0LBuago5UYjPTVpuxp3bEN2ImHdlVJcJqHNQYo9SM31kmyW
        +hvPh+wsvaOzFizDPqtLw4RBfw==
X-Google-Smtp-Source: APXvYqwjjoCWsyM81+VMManfxYXzhJz0ZT/2FhMUAyABNm4cJLUjAKeiswdJsdyAjbGP2lksjrtKmg==
X-Received: by 2002:a92:7509:: with SMTP id q9mr19964501ilc.67.1580234683021;
        Tue, 28 Jan 2020 10:04:43 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n12sm4611657ion.25.2020.01.28.10.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 10:04:42 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
Message-ID: <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
Date:   Tue, 28 Jan 2020 11:04:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 10:19 AM, Jens Axboe wrote:
> On 1/28/20 9:19 AM, Jens Axboe wrote:
>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
>>> Am 28.01.20 um 17:10 schrieb Jens Axboe:
>>>> On 1/28/20 3:18 AM, Stefan Metzmacher wrote:
>>>>> Hi Jens,
>>>>>
>>>>> now that we have IORING_FEAT_CUR_PERSONALITY...
>>>>>
>>>>> How can we optimize the fileserver case now, in order to avoid the
>>>>> overhead of always calling 5 syscalls before io_uring_enter()?:
>>>>>
>>>>>  /* gain root again */
>>>>>  setresuid(-1,0,-1); setresgid(-1,0,-1)
>>>>>  /* impersonate the user with groups */
>>>>>  setgroups(num, grps); setresgid(-1,gid,-1); setresuid(-1,uid,-1);
>>>>>  /* trigger the operation */
>>>>>  io_uring_enter();
>>>>>
>>>>> I guess some kind of IORING_REGISTER_CREDS[_UPDATE] would be
>>>>> good, together with a IOSQE_FIXED_CREDS in order to specify
>>>>> credentials per operation.
>>>>>
>>>>> Or we make it much more generic and introduce a credsfd_create()
>>>>> syscall in order to get an fd for a credential handle, maybe
>>>>> together with another syscall to activate the credentials of
>>>>> the current thread (or let a write to the fd trigger the activation
>>>>> in order to avoid an additional syscall number).
>>>>>
>>>>> Having just an fd would allow IORING_REGISTER_CREDS[_UPDATE]
>>>>> to be just an array of int values instead of a more complex
>>>>> structure to define the credentials.
>>>>
>>>> I'd rather avoid having to add more infrastructure for this, even if
>>>> credsfd_create() would be nifty.
>>>>
>>>> With that in mind, something like:
>>>>
>>>> - Application does IORING_REGISTER_CREDS, which returns some index
>>>>
>>>> - Add a IORING_OP_USE_CREDS opcode, which sets the creds associated
>>>>   with dependent commands
>>>> - Actual request is linked to the IORING_OP_USE_CREDS command, any
>>>>   link off IORING_OP_USE_CREDS will use those credentials
>>>
>>> Using links for this sounds ok.
>>
>> Great! I'll try and hack this up and see how it turns out.
>>
>>>> - IORING_UNREGISTER_CREDS removes the registered creds
>>>>
>>>> Just throwing that out there, definitely willing to entertain other
>>>> methods that make sense for this. Trying to avoid needing to put this
>>>> information in the SQE itself, hence the idea to use a chain of links
>>>> for it.
>>>>
>>>> The downside is that we'll need to maintain an array of key -> creds,
>>>> but that's probably not a big deal.
>>>>
>>>> What do you think?
>>>
>>> So IORING_REGISTER_CREDS would be a simple operation that just takes a
>>> snapshot of the current_cred() and returns an id that can be passed to
>>> IORING_OP_USE_CREDS or IORING_UNREGISTER_CREDS?
>>
>> Right, you would not pass in any arguments, it'd have to be run from the
>> personality you wish to register. It simply returns an integer, which is
>> a key to use for IORING_OP_USE_CREDS, or at the end for
>> IORING_UNREGISTER_CREDS when you no longer wish to use this personality.
>>
>>>> Ideally I'd like to get this done for 5.6 even if we
>>>> are a bit late, so you'll have everything you need with that release.
>>>
>>> That would be great!
>>
>> Crossing fingers...
> 
> OK, so here are two patches for testing:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
> 
> #1 adds support for registering the personality of the invoking task,
> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
> just having one link, it doesn't support a chain of them.
> 
> I'll try and write a test case for this just to see if it actually works,
> so far it's totally untested. 
> 
> Adding Pavel to the CC.

Minor tweak to ensuring we do the right thing for async offload as well,
and it tests fine for me. Test case is:

- Run as root
- Register personality for root
- create root only file
- check we can IORING_OP_OPENAT the file
- switch to user id test
- check we cannot IORING_OP_OPENAT the file
- check that we can open the file with IORING_OP_USE_CREDS linked


-- 
Jens Axboe

