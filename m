Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0472A8767
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 20:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgKEThO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 14:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgKEThO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 14:37:14 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91760C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 11:37:14 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id k21so2981478ioa.9
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 11:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=itCT6vZ4VJceF+EMbrGyCYg65BWLXlYvp9Jnz109S+I=;
        b=hPcuCY3eOuUfxbljiDKcUrJqRyTlSyEpSYPLvZRdfxIWCtb4TTP2lYWTPQ6lhFRE31
         3HvCSlYZmJKLXSxM28z2W2VXbps2I3DFkiItGhBntyYwJfObpse0D/CX6rTxJlTVkF8l
         h8B4Ufzm60bt5I6xFLUYQkhTz3aKmRpbouo7hv+mUbHiyA+foF2SIe+d9B6RO3PPoAks
         teD/ibvwuOl6EuACQvC39rkvFVGmcVLMI0S/g5O3SZen8FeKXFua/4GTeUkBBAVRzrFW
         IGkLkBsrgNMsFNO6ZStTfkiLhkTP4qrcnninO2DLk62gKAMzy2ZIsiHvK/sM59zb48cz
         K/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=itCT6vZ4VJceF+EMbrGyCYg65BWLXlYvp9Jnz109S+I=;
        b=awIItbjsgV7pgqTGEGcQglb+WUq5XZ+BxJrMjF0e9VCp0JXrGMcCIVuLIUrDa+TaG/
         8OjZT849Y0WccEI/PMadS0+xrgde/PbHf9LIr3f7G/iPqO1BoghffrCb2VJFbo5W4Pzr
         pJeY4DJxkZOgwuXATSoyv4qHrSyhEvXXBmNMx2meXY/Fv6jBG0RXMzh4QMV+esLbA6mM
         MhVOj73oXJXvGliW1gVMnSlH6JbSoeKnxvwD5mg+px3p0hJ6Vzm+UlPRHPrAqbEbJr62
         yxzqjREE95nz/cfC8VTGPPXha6kOdaYkaZO4LnguqKptw5HpFDmVwv+69THMerUvbR4o
         r0ww==
X-Gm-Message-State: AOAM530p/hMbJ9M+gQtdeiY+GIHYoJxSOxw671mtcI32KtzkgJt528vP
        3K/I2HBEIOLWozzGjCE/v2b/nsG+GdDBwQ==
X-Google-Smtp-Source: ABdhPJzLa89od6NY8INPZlVlDUl815FiRDNPqAaqrbYL45xgYHjjLmxKGlm7a9OrOls0D0pxLf++NQ==
X-Received: by 2002:a05:6638:24cc:: with SMTP id y12mr3412450jat.144.1604605033571;
        Thu, 05 Nov 2020 11:37:13 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l12sm1530004ioq.16.2020.11.05.11.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 11:37:12 -0800 (PST)
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
Date:   Thu, 5 Nov 2020 12:37:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 7:55 AM, Pavel Begunkov wrote:
> On 05/11/2020 14:22, Pavel Begunkov wrote:
>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>>> Hi Jens,
>>>
>>> I am trying to implement mkdirat support in io_uring and was using
>>> commit 3c5499fa56f5 ("fs: make do_renameat2() take struct filename") as
>>> an example (kernel newbie here). But either I do not understand how it
>>> works, or on retry struct filename is used that is not owned anymore
>>> (and is probably freed).
>>>
>>> Here is the relevant part of the patch:
>>>
>>> diff --git a/fs/namei.c b/fs/namei.c
>>> index d4a6dd772303..a696f99eef5c 100644
>>> --- a/fs/namei.c
>>> +++ b/fs/namei.c
>>> @@ -4346,8 +4346,8 @@ int vfs_rename(struct inode *old_dir, struct
>>> dentry *old_dentry,
>>>  }
>>>  EXPORT_SYMBOL(vfs_rename);
>>>
>>> -static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
>>> -                       const char __user *newname, unsigned int flags)
>>> +int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>>> +                struct filename *newname, unsigned int flags)
>>>  {
>>>         struct dentry *old_dentry, *new_dentry;
>>>         struct dentry *trap;
>>> @@ -4359,28 +4359,28 @@ static int do_renameat2(int olddfd, const char
>>> __user *oldname, int newdfd,
>>>         struct filename *to;
>>>         unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
>>>         bool should_retry = false;
>>> -       int error;
>>> +       int error = -EINVAL;
>>>
>>>         if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
>>> -               return -EINVAL;
>>> +               goto put_both;
>>>
>>>         if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
>>>             (flags & RENAME_EXCHANGE))
>>> -               return -EINVAL;
>>> +               goto put_both;
>>>
>>>         if (flags & RENAME_EXCHANGE)
>>>                 target_flags = 0;
>>>
>>>  retry:
>>> -       from = filename_parentat(olddfd, getname(oldname), lookup_flags,
>>> -                               &old_path, &old_last, &old_type);
>>
>> filename_parentat(getname(oldname), ...)
>>
>> It's passing a filename directly, so filename_parentat() also takes ownership
>> of the passed filename together with responsibility to put it. Yes, it should
>> be destroying it inside.
> 
> Hah, basically filename_parentat() returns back the passed in filename if not
> an error, so @oldname and @from are aliased, then in the end for retry path
> it does.
> 
> ```
> put(from);
> goto retry;
> ```
> 
> And continues to use oldname. The same for to/newname.
> Looks buggy to me, good catch!

How about we just cleanup the return path? We should only put these names
when we're done, not for the retry path. Something ala the below - untested,
I'll double check, test, and see if it's sane.


diff --git a/fs/namei.c b/fs/namei.c
index a696f99eef5c..becb23ec07a8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4473,16 +4473,13 @@ int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 	if (retry_estale(error, lookup_flags))
 		should_retry = true;
 	path_put(&new_path);
-	putname(to);
 exit1:
 	path_put(&old_path);
-	putname(from);
 	if (should_retry) {
 		should_retry = false;
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-	return error;
 put_both:
 	if (!IS_ERR(oldname))
 		putname(oldname);

-- 
Jens Axboe

