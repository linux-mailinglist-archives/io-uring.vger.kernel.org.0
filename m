Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BA52A81AA
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 15:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgKEO6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 09:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbgKEO6Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 09:58:24 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F56C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 06:58:24 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id a3so1960435wrx.13
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 06:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0dKL37EUlFqGMErChSI57ns/avHa6zgOSQi9i8D1sbU=;
        b=k43HHRzZoW9shYPgCTWRwPn3MJN1X+n5CfafLj9dg6HaYH6H3HqS8qjvrS27vUAduC
         d4mz56tO5gZvKjkLtey6f2pFKy/7B+XGCpVUUSnuakLEw8rntzTqBDJ3dJHPQGUbilVS
         ePxie+3/HTFMVvMC11L9fsuzGBR742daoujBl0DwsWZwGhgLoxa+gEb9l1bFLuQKQKKa
         SFjO/yvwdtejrLZpdsjOHQiDtb1M/VcT0HJtko7g0h2ltXYJegaFutXbwsc0MvC0vBIg
         DNGfBo909/8JlmX9q3AN/GUxEvJlN7BUiqMqf1xpukPemlVx6cvTjtwAW4zuL2RI3jvQ
         D8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0dKL37EUlFqGMErChSI57ns/avHa6zgOSQi9i8D1sbU=;
        b=Dxpj3/LupRZb3j3rMNBtdFIzvEO8VwamyjD3hdYZ2yg2vUkVBylgs4jp2RSDzcABVq
         TPKkMj51aQOVBS47bibdW1d5eLRX6ehjm+qPw4XYpewXOWBzIYQ+YifDu3JrDX+OJugD
         EtpaNvRSpoUcMvLXdkVxdYJs/AydPkvy93gIFGkC81Q3Ya5i+2Wjg8vPU0m1DLme1grf
         AXXekq6xPvLXLPknIiKtcIAPX8NRlU/abTfTKopePqHqAL+1ARG4zHdJ6/DHcq9O3HWB
         4tlgpefdEBnfIJE9dTBuF9ciAXOvgp/+fBUKR0HN5LbCb9Izj/1SBHyLioOvaevhHpFA
         To9w==
X-Gm-Message-State: AOAM530dbRS59TGaTNq/kJK67gGSdmBDqdFdn9SGbsigAmaykx81XkUE
        j3TNCx0SC2/800hFbXN24Tut1lUmHqc=
X-Google-Smtp-Source: ABdhPJztAgVKpLevc3R/CLIjPKWmSe30H859wybwv8ntYNDAZHgG/aRYJwupQia/h6nb216khDB6lQ==
X-Received: by 2002:adf:f6cc:: with SMTP id y12mr3476834wrp.107.1604588302639;
        Thu, 05 Nov 2020 06:58:22 -0800 (PST)
Received: from [192.168.1.47] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id u202sm3119169wmu.23.2020.11.05.06.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:58:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
Date:   Thu, 5 Nov 2020 14:55:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/11/2020 14:22, Pavel Begunkov wrote:
> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>> Hi Jens,
>>
>> I am trying to implement mkdirat support in io_uring and was using
>> commit 3c5499fa56f5 ("fs: make do_renameat2() take struct filename") as
>> an example (kernel newbie here). But either I do not understand how it
>> works, or on retry struct filename is used that is not owned anymore
>> (and is probably freed).
>>
>> Here is the relevant part of the patch:
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index d4a6dd772303..a696f99eef5c 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -4346,8 +4346,8 @@ int vfs_rename(struct inode *old_dir, struct
>> dentry *old_dentry,
>>  }
>>  EXPORT_SYMBOL(vfs_rename);
>>
>> -static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
>> -                       const char __user *newname, unsigned int flags)
>> +int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>> +                struct filename *newname, unsigned int flags)
>>  {
>>         struct dentry *old_dentry, *new_dentry;
>>         struct dentry *trap;
>> @@ -4359,28 +4359,28 @@ static int do_renameat2(int olddfd, const char
>> __user *oldname, int newdfd,
>>         struct filename *to;
>>         unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
>>         bool should_retry = false;
>> -       int error;
>> +       int error = -EINVAL;
>>
>>         if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
>> -               return -EINVAL;
>> +               goto put_both;
>>
>>         if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
>>             (flags & RENAME_EXCHANGE))
>> -               return -EINVAL;
>> +               goto put_both;
>>
>>         if (flags & RENAME_EXCHANGE)
>>                 target_flags = 0;
>>
>>  retry:
>> -       from = filename_parentat(olddfd, getname(oldname), lookup_flags,
>> -                               &old_path, &old_last, &old_type);
> 
> filename_parentat(getname(oldname), ...)
> 
> It's passing a filename directly, so filename_parentat() also takes ownership
> of the passed filename together with responsibility to put it. Yes, it should
> be destroying it inside.

Hah, basically filename_parentat() returns back the passed in filename if not
an error, so @oldname and @from are aliased, then in the end for retry path
it does.

```
put(from);
goto retry;
```

And continues to use oldname. The same for to/newname.
Looks buggy to me, good catch!

p.s. just noticed that you listed the original patch, not yours

> 
> struct filename {
> 	...
> 	int			refcnt;
> };
> 
> The easiest solution is to take an additional ref. Looks like it's not atomic,
> but double check to not add additional overhead.
> 
>> +       from = filename_parentat(olddfd, oldname, lookup_flags, &old_path,
>> +                                       &old_last, &old_type);
>>
>> With the new code on the first run oldname ownership is released. And if
>> we do end up on the retry path then it is used again erroneously (also
>> `from` was already put by that time).
>>
>> Am I getting it wrong or is there a bug?
>>
>> do_unlinkat that you reference does things a bit differently, as far as
>> I can tell the problem does not exist there.
>>
>> Thanks,
>> Dmitry
>>
> 

-- 
Pavel Begunkov
