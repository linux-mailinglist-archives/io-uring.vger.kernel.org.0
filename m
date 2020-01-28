Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F91B14BD90
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 17:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgA1QTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 11:19:12 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:41692 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgA1QTL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 11:19:11 -0500
Received: by mail-io1-f50.google.com with SMTP id m25so14890069ioo.8
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 08:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zq6EXSAeuL4foEkIsADyKKzgdNZP2b5fR+tzcRgZADY=;
        b=JEy4f6w3XjHw2jKoV7KorIg8azI9n3MmsQImhFF6sC8nMqDfGq5zibZF3RPaD40sbt
         0vnrRKkzC/JbafIWFL3oEmQDj+CzV9cpWGKg4gvXSjrgwHt8OE40sNYv5GCLkaCcaFDi
         +6TO0rChdH/vm8wBaBOsa/3JvUTLcgxtM6uVfTghNeLi312lqXEPXkfg7bATZgJ/EX2w
         pRv72c38pxJ5+YH/kB52Rh18V5HbYQz0/8xgk1dz07QuW51YbBsV2oasJRdFW2uNu4KB
         xxVVNLiNj4smhFN71zyljmhk+eE46E12kcvuapRErvDWudWl2ewVTDX9CN0cnxgFRiIr
         mqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zq6EXSAeuL4foEkIsADyKKzgdNZP2b5fR+tzcRgZADY=;
        b=MngCkhQ2acXSJAIR278U7ZSceXFcJj6KVRlrMCDixiWhC7zZugW4ReZLIkNx1XXGU/
         93b1L3bh7HDcISJ4exUUFMQcjsz4qUaCrJoLGuzTuAoaknCkQf79N0fB9v+H8dLH1/Jg
         b7dwgMgjvHv0da8Kxjtsu1la2dkhVdvAY0KFjqXjVVtpxmDKStC72/h78mOAj92pEyE+
         aXksoMh5HtvHCm7NE4RWlyl3abGW4jXnMPloPzYrT3pb+RujoF83usDmNNBe+1YIIg68
         oRpC2/Ghl3aHZVAkjOzMNTUu5pNtuh8j2D6KxFGbnrNdzEf6WWcAY2+DPsj+ZGORdXaM
         yYrg==
X-Gm-Message-State: APjAAAWkviDuvmHUExhGlE6Hw81S0/ZIC65MpunOzz5T9ZAvHCx0WUTj
        s+/7LflYqOkFz2fH0YNHWcIYmg==
X-Google-Smtp-Source: APXvYqzZVO3He68XgKFAIobWN+KkcYYSisztLnRuLXMfijxC1VlQjTo6mt2ytKpbgD+JydxarreR2g==
X-Received: by 2002:a5e:8505:: with SMTP id i5mr16638864ioj.158.1580228350820;
        Tue, 28 Jan 2020 08:19:10 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f72sm6016297ilg.84.2020.01.28.08.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 08:19:10 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
Date:   Tue, 28 Jan 2020 09:19:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
> Am 28.01.20 um 17:10 schrieb Jens Axboe:
>> On 1/28/20 3:18 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>> now that we have IORING_FEAT_CUR_PERSONALITY...
>>>
>>> How can we optimize the fileserver case now, in order to avoid the
>>> overhead of always calling 5 syscalls before io_uring_enter()?:
>>>
>>>  /* gain root again */
>>>  setresuid(-1,0,-1); setresgid(-1,0,-1)
>>>  /* impersonate the user with groups */
>>>  setgroups(num, grps); setresgid(-1,gid,-1); setresuid(-1,uid,-1);
>>>  /* trigger the operation */
>>>  io_uring_enter();
>>>
>>> I guess some kind of IORING_REGISTER_CREDS[_UPDATE] would be
>>> good, together with a IOSQE_FIXED_CREDS in order to specify
>>> credentials per operation.
>>>
>>> Or we make it much more generic and introduce a credsfd_create()
>>> syscall in order to get an fd for a credential handle, maybe
>>> together with another syscall to activate the credentials of
>>> the current thread (or let a write to the fd trigger the activation
>>> in order to avoid an additional syscall number).
>>>
>>> Having just an fd would allow IORING_REGISTER_CREDS[_UPDATE]
>>> to be just an array of int values instead of a more complex
>>> structure to define the credentials.
>>
>> I'd rather avoid having to add more infrastructure for this, even if
>> credsfd_create() would be nifty.
>>
>> With that in mind, something like:
>>
>> - Application does IORING_REGISTER_CREDS, which returns some index
>>
>> - Add a IORING_OP_USE_CREDS opcode, which sets the creds associated
>>   with dependent commands
>> - Actual request is linked to the IORING_OP_USE_CREDS command, any
>>   link off IORING_OP_USE_CREDS will use those credentials
> 
> Using links for this sounds ok.

Great! I'll try and hack this up and see how it turns out.

>> - IORING_UNREGISTER_CREDS removes the registered creds
>>
>> Just throwing that out there, definitely willing to entertain other
>> methods that make sense for this. Trying to avoid needing to put this
>> information in the SQE itself, hence the idea to use a chain of links
>> for it.
>>
>> The downside is that we'll need to maintain an array of key -> creds,
>> but that's probably not a big deal.
>>
>> What do you think?
> 
> So IORING_REGISTER_CREDS would be a simple operation that just takes a
> snapshot of the current_cred() and returns an id that can be passed to
> IORING_OP_USE_CREDS or IORING_UNREGISTER_CREDS?

Right, you would not pass in any arguments, it'd have to be run from the
personality you wish to register. It simply returns an integer, which is
a key to use for IORING_OP_USE_CREDS, or at the end for
IORING_UNREGISTER_CREDS when you no longer wish to use this personality.

>> Ideally I'd like to get this done for 5.6 even if we
>> are a bit late, so you'll have everything you need with that release.
> 
> That would be great!

Crossing fingers...

-- 
Jens Axboe

