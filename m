Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B7314D55A
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 04:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgA3DSg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 22:18:36 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:39598 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgA3DSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 22:18:36 -0500
Received: by mail-pg1-f176.google.com with SMTP id 4so885884pgd.6
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 19:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l8b66HLZqquKJK5/HZhF6W9dAJU/hiGlLZBjdr8DP70=;
        b=BXOLTySttJt2wANTj526X4/+vVylpFpelva0m/DJzx60X1jKsHwCGXnwuL0AiqLQUB
         YSlv/uquHVmBEezT5tAoA+bJycZWIHCOzoL9rij4wg5w4xY+/M/c2qM6eKUKplzAW2zq
         6c42R/4fGGA1VGC3Ej7YON7a2cL786XNc/R3PJ9WMkYciuQMl2SxiN8QVmsa/9RMq5yh
         ljbXi8seOWDS7zhkPyrr3NhOMTWsVpJ7Kw5rq21twtOblaI1wxaNLH8wc8n7rEhhZR2g
         V+gEC+Zpx2ZNJGQvj96jwizMugj2+epeZcZDDVLOLjJfdKMDCmDnmy76PWgzfm9t6USM
         /h5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8b66HLZqquKJK5/HZhF6W9dAJU/hiGlLZBjdr8DP70=;
        b=m4uRetnuoCrbYYzo6n77HyN7QIyFGl0wTbMtswPf2B25zagkV0y6eeHT0SBkGGiVf9
         tz2g8AkSnZLTDHQvX48o/t0W8DBR52W0Dwi94K1+PYbXXoDysMSEenKYHcZwAkcJgvLx
         dKuPsWGfYftTLMa4vzK5h0YJ4booovhtN8RjJMJfZwrCqg6m3+mkKoeFvBF2L5qAT0bq
         O6s7TrM97X5viKhSLPdUy2+ncqcWPOX4SQrJk85Znx+tcjtbbKZgUDTfj5tD2Yj1ZCFa
         ifAlwbQl6hy+4bQ1WOTAm4tk8SUnM5Mg8kl2sven4j+27fVJYEYf9DkLFHusQczg8FuB
         RUgw==
X-Gm-Message-State: APjAAAX1y1OqGGv+agC6FwLWBQMOQzzusHUJv61XIb50RWPqcgYehrXs
        7jUQc7+xilumC0B/92hrZ6Jlig==
X-Google-Smtp-Source: APXvYqwvYxfS6fyWAgx89JHT0OHowS2nS+zk387l1I/66IGCM+tB657iS22b4m29lENNed7gmZWPxg==
X-Received: by 2002:a62:ea06:: with SMTP id t6mr2884780pfh.73.1580354315491;
        Wed, 29 Jan 2020 19:18:35 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id fh24sm4078621pjb.24.2020.01.29.19.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 19:18:34 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <6372aa92-6b28-4a5f-ca6d-7741e1c8592e@kernel.dk>
Message-ID: <6f2e6ad3-30e5-fbe5-3b66-1fd32bc8f683@kernel.dk>
Date:   Wed, 29 Jan 2020 20:18:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6372aa92-6b28-4a5f-ca6d-7741e1c8592e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 7:20 PM, Jens Axboe wrote:
> On 1/29/20 6:08 PM, Jens Axboe wrote:
>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>> [...]
>>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>>> just having one link, it doesn't support a chain of them.
>>>> [...]
>>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>>> implementation and use. And the fact that we'd have to jump through
>>>>> hoops to make this work for a full chain.
>>>>>
>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>>> This makes it way easier to use. Same branch:
>>>>>
>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>
>>>>> I'd feel much better with this variant for 5.6.
>>>>
>>>> Some general feedback from an inspectability/debuggability perspective:
>>>>
>>>> At some point, it might be nice if you could add a .show_fdinfo
>>>> handler to the io_uring_fops that makes it possible to get a rough
>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>>> helpful for debugging to be able to see information about the fixed
>>>> files and buffers that have been registered. Same for the
>>>> personalities; that information might also be useful when someone is
>>>> trying to figure out what privileges a running process actually has.
>>>
>>> Agree, that would be a very useful addition. I'll take a look at it.
>>
>> Jann, how much info are you looking for? Here's a rough start, just
>> shows the number of registered files and buffers, and lists the
>> personalities registered. We could also dump the buffer info for
>> each of them, and ditto for the files. Not sure how much verbosity
>> is acceptable in fdinfo?
>>
>> Here's the test app for personality:
>>
>> # cat 3
>> pos:	0
>> flags:	02000002
>> mnt_id:	14
>> user-files: 0
>> user-bufs: 0
>> personalities:
>> 	    1: uid=0/gid=0
> 
> Here's one that adds the registered buffers and files as well. So
> essentially this shows any info on the registered parts.

Output of this version, using t/io_uring from fio:

# cat /proc/338/fdinfo/4
pos:	0
flags:	02000002
mnt_id:	14
user-files: 1
    0: nvme0n1p2
user-bufs: 128
    0: 55ea44b52000/4096
    1: 55ea44b54000/4096
    2: 55ea44b56000/4096
    3: 55ea44b58000/4096
    4: 55ea44b5a000/4096
    5: 55ea44b5c000/4096
    6: 55ea44b5e000/4096
    7: 55ea44b60000/4096
    8: 55ea44b62000/4096
    9: 55ea44b64000/4096
   10: 55ea44b66000/4096
   11: 55ea44b68000/4096
   12: 55ea44b6a000/4096
   13: 55ea44b6c000/4096
   14: 55ea44b6e000/4096
   15: 55ea44b70000/4096
   16: 55ea44b72000/4096
   17: 55ea44b74000/4096
   18: 55ea44b76000/4096
   19: 55ea44b78000/4096
   20: 55ea44b7a000/4096
   21: 55ea44b7c000/4096
   22: 55ea44b7e000/4096
   23: 55ea44b80000/4096
   24: 55ea44b82000/4096
   25: 55ea44b84000/4096
   26: 55ea44b86000/4096
   27: 55ea44b88000/4096
   28: 55ea44b8a000/4096
   29: 55ea44b8c000/4096
   30: 55ea44b8e000/4096
   31: 55ea44b90000/4096
   32: 55ea44b92000/4096
   33: 55ea44b94000/4096
   34: 55ea44b96000/4096
   35: 55ea44b98000/4096
   36: 55ea44b9a000/4096
   37: 55ea44b9c000/4096
   38: 55ea44b9e000/4096
   39: 55ea44ba0000/4096
   40: 55ea44ba2000/4096
   41: 55ea44ba4000/4096
   42: 55ea44ba6000/4096
   43: 55ea44ba8000/4096
   44: 55ea44baa000/4096
   45: 55ea44bac000/4096
   46: 55ea44bae000/4096
   47: 55ea44bb0000/4096
   48: 55ea44bb2000/4096
   49: 55ea44bb4000/4096
   50: 55ea44bb6000/4096
   51: 55ea44bb8000/4096
   52: 55ea44bba000/4096
   53: 55ea44bbc000/4096
   54: 55ea44bbe000/4096
   55: 55ea44bc0000/4096
   56: 55ea44bc2000/4096
   57: 55ea44bc4000/4096
   58: 55ea44bc6000/4096
   59: 55ea44bc8000/4096
   60: 55ea44bca000/4096
   61: 55ea44bcc000/4096
   62: 55ea44bce000/4096
   63: 55ea44bd0000/4096
   64: 55ea44bd2000/4096
   65: 55ea44bd4000/4096
   66: 55ea44bd6000/4096
   67: 55ea44bd8000/4096
   68: 55ea44bda000/4096
   69: 55ea44bdc000/4096
   70: 55ea44bde000/4096
   71: 55ea44be0000/4096
   72: 55ea44be2000/4096
   73: 55ea44be4000/4096
   74: 55ea44be6000/4096
   75: 55ea44be8000/4096
   76: 55ea44bea000/4096
   77: 55ea44bec000/4096
   78: 55ea44bee000/4096
   79: 55ea44bf0000/4096
   80: 55ea44bf2000/4096
   81: 55ea44bf4000/4096
   82: 55ea44bf6000/4096
   83: 55ea44bf8000/4096
   84: 55ea44bfa000/4096
   85: 55ea44bfc000/4096
   86: 55ea44bfe000/4096
   87: 55ea44c00000/4096
   88: 55ea44c02000/4096
   89: 55ea44c04000/4096
   90: 55ea44c06000/4096
   91: 55ea44c08000/4096
   92: 55ea44c0a000/4096
   93: 55ea44c0c000/4096
   94: 55ea44c0e000/4096
   95: 55ea44c10000/4096
   96: 55ea44c12000/4096
   97: 55ea44c14000/4096
   98: 55ea44c16000/4096
   99: 55ea44c18000/4096
  100: 55ea44c1a000/4096
  101: 55ea44c1c000/4096
  102: 55ea44c1e000/4096
  103: 55ea44c20000/4096
  104: 55ea44c22000/4096
  105: 55ea44c24000/4096
  106: 55ea44c26000/4096
  107: 55ea44c28000/4096
  108: 55ea44c2a000/4096
  109: 55ea44c2c000/4096
  110: 55ea44c2e000/4096
  111: 55ea44c30000/4096
  112: 55ea44c32000/4096
  113: 55ea44c34000/4096
  114: 55ea44c36000/4096
  115: 55ea44c38000/4096
  116: 55ea44c3a000/4096
  117: 55ea44c3c000/4096
  118: 55ea44c3e000/4096
  119: 55ea44c40000/4096
  120: 55ea44c42000/4096
  121: 55ea44c44000/4096
  122: 55ea44c46000/4096
  123: 55ea44c48000/4096
  124: 55ea44c4a000/4096
  125: 55ea44c4c000/4096
  126: 55ea44c4e000/4096
  127: 55ea44c50000/4096

-- 
Jens Axboe

