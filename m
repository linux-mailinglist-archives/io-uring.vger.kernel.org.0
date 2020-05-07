Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D451C9969
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgEGSfr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 14:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGSfq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 14:35:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586ACC05BD43
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 11:35:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v63so3398480pfb.10
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 11:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1KPghES8o/m1guSIPS4zYl9dIDeyxiIt7bR2Kaju31k=;
        b=oNBmExnyJLuQaRuJo0le/Xge5cDrrVkjZgilY6iqUT8Q2qcp3tiCWDVQLuf9ny67Pj
         C+UOziHRkt41hXL0SiS/yWG6M9NeY+IaHs8wQrhRWg6FQMgwO16Kj50rGa/6w4EdxjoE
         7GL0Pwc0MiQkUg2FJldB3thmwv6SHIzZEMyVeVR7D/OiO+9mmtObFz8YhEmAocbDxp0c
         yL9A4XweEg8UweHlX9JK61ZyYDzLAwBZlKo+EPTWjDy6saIxT7A4XNWDMXCHoM1KuMde
         Rphiix0WEKVfK2jygHtJFXVNcS0Ns2+DAPGkGGcB0ZbU3849zzSIFYR/mjKg2GDlukA6
         Dltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1KPghES8o/m1guSIPS4zYl9dIDeyxiIt7bR2Kaju31k=;
        b=fLu6//cT861B1lPIbZwUPTtKBsTiB37D+kHJLCHC4nzoX5rwoWtVOUfuaMGjTxNTjN
         koAYZjlu+O1W2ejyQSBp6QiXBGI7Lw3m607nj46WGDz5Ptue01cIbWz4jep2zycTRd1r
         cIVGUsVFcFkizypFMNKSxjIV7MyTZbsGNXjrLbNJVS3+wKA+x+9rUygLvDca6eOxYKVE
         J5VvNbinDgn5eeoVZyCdSqxm5sQEBCSFPPukz+mTPm3LzNMHxUAgmn+xPYDPCIQc6Is5
         PTys4Fq19kRnd5QfxGbM+Xu3PyOPmM4w1JE781UFMu5q+NzlZdUolG0YsDMwHxSEsmUD
         nJRQ==
X-Gm-Message-State: AGi0PubRQssLozmfI3GYICoa/VcP+GuHRK57zZltit32xLX3VD7Gcr1o
        WcLiE6iFPGDj0tM4feAQj5sNEg==
X-Google-Smtp-Source: APiQypKZZOaBKJxo5Ts58/wu7sjAw2WBE4TCd253BXco/mpOHvY9IHZA3GxU1ULOU99giX1qj17cNg==
X-Received: by 2002:a63:fd03:: with SMTP id d3mr12059978pgh.6.1588876544516;
        Thu, 07 May 2020 11:35:44 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1239? ([2620:10d:c090:400::5:ddfe])
        by smtp.gmail.com with ESMTPSA id p8sm436526pjd.10.2020.05.07.11.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 11:35:43 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
To:     Jeremy Allison <jra@samba.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
 <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
 <97508d5f-77a0-e154-3da0-466aad2905e8@kernel.dk>
 <20200507164802.GB25085@jeremy-acer>
 <01778c43-866f-6974-aa4a-7dc364301764@kernel.dk>
 <20200507183140.GD25085@jeremy-acer>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3130bca5-a2fb-a703-4387-65348fe1bdc8@kernel.dk>
Date:   Thu, 7 May 2020 12:35:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507183140.GD25085@jeremy-acer>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/20 12:31 PM, Jeremy Allison wrote:
> On Thu, May 07, 2020 at 10:50:40AM -0600, Jens Axboe wrote:
>> On 5/7/20 10:48 AM, Jeremy Allison wrote:
>>> On Thu, May 07, 2020 at 10:43:17AM -0600, Jens Axboe wrote:
>>>>
>>>> Just like for regular system calls, applications must be able to deal
>>>> with short IO.
>>>
>>> Thanks, that's a helpful definitive reply. Of course, the SMB3
>>> protocol is designed to deal with short IO replies as well, and
>>> the Samba and linux kernel clients are well-enough written that
>>> they do so. MacOS and Windows however..
>>
>> I'm honestly surprised that such broken clients exists! Even being
>> a somewhat old timer cynic...
>>
>>> Unfortunately they're the most popular clients on the planet,
>>> so we'll probably have to fix Samba to never return short IOs.
>>
>> That does sound like the best way forward, short IOs is possible
>> with regular system calls as well, but will definitely be a lot
>> more frequent with io_uring depending on the access patterns,
>> page cache, number of threads, and so on.
> 
> OK, I just want to be *REALLY CLEAR* what you're telling me
> (I've already written the pread/pwrite wrappers for Samba
> that deal with short IO but want to ensure I understand
> fully before making any changes to Samba).
> 
> You're saying that on a bog-standard ext4 disk file:
> 
> ret = pread(fd, buf, count, offset);
> 
> can return *less* than count bytes if there's no IO
> error and the file size is greater than offset+count
> and no one else is in the middle of a truncate etc. ?
> 
> And:
> 
> ret = pwrite(fd, buf, count, offset);
> 
> can return less* than count bytes if there's no IO
> error and there's ample space on disk ?
> 
> I have to say I've *never* seen that happen, and
> Samba is widely enough used that IO corruption from
> short reads/writes from MacOSX and Windows clients
> would have been widely reported by now.
> 
> Look at how quickly someone spotted disk corruption
> because of the change in userspace-visible behavior
> of the io_uring interface. We only shipped that code
> 03 March 2020 and someone *already* found it.

I _think_ that will only happen on regular files if you use RWF_NOWAIT
or similar, for regular blocking it should not happen. So I don't think
you're at risk there, though I do think that anyone should write
applications with short IOs in mind or they will run into surprises down
the line. Should have been more clear!

-- 
Jens Axboe

