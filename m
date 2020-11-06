Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF542A9702
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKFNaz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgKFNaz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:30:55 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E63C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:30:54 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id y12so1335746wrp.6
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=13l5KsjN/6dF1C5fDeluHL5CroS/5MtqLBlzXSVbO1A=;
        b=BhrEi7sDMN+o22J2vhltOU1VpgQAlANPAMknJfV49pVzH9I7PH4RehkFzZC9HXGCCj
         6eO6/GrLATvZtmwE7KgwbpxDxnweU1j391qj6c+em6BmIVJbR+oTdPcXjF26rMDQd3kU
         2NRKlMMhKnkX4ATj8EKNbtYmg75zTBTENvU4mlE658f5QovqlYTRamLyyWnU3d7m/bPg
         WJq32BZkjPYj9QskyWSeq82CWI0utrbCuD1yUMKBxT+joORXp8vy3HAOv8W6sELINEpt
         8KU/iLs92gCyUjHUKWuVUxCHCcXTdoFhvWnnfdL/IjSSOTB635lZZ+tN7oFBg7xTky6I
         zRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=13l5KsjN/6dF1C5fDeluHL5CroS/5MtqLBlzXSVbO1A=;
        b=jAJynj570zR+2xPpWxFstmsKtUclgfhKcgv9gUzXJwOeV6eKj+SroO3VeuQLSl1ATF
         Pk9CIkxYg39wHgcOoVYD4q4H/sMyeUjUuWsFANV+Y2tStkTOQ5IvqfFxq1DTTqXp8LCp
         50Ug4IMXQggFb3DtZ5Zg14giGwEaqdw0GFpZkjUNrMvVcoSdl3pqq3jPJTTY2gHD9nWn
         2h9cg7uxOxwXcnmv42/q/v6uEp6X5nDxIzDJTz6MjA9sVqIOESBS+sCL2KQiVbYSLC18
         E5OuuuF2RCMpeesd6QTov/IIfAd3KIEIy0mF8usH7SegECYFa9RaZxxLZbr1hmUX3Keq
         4n7g==
X-Gm-Message-State: AOAM5306KsvsuRtOR7b3OSze1afNgkp4gUbZhO7IwzOIRaBxZMiDTvbC
        cMYE5iKjpkibXNF8XwpFiOF/tz6cPk4=
X-Google-Smtp-Source: ABdhPJwYL/s/zjAZcobE291ToFuOz7xHDixH16HUNVAmtiGJue3LuPP29DXuhIhsuikuYhUD2uC2/A==
X-Received: by 2002:adf:f3c4:: with SMTP id g4mr2875369wrp.207.1604669453216;
        Fri, 06 Nov 2020 05:30:53 -0800 (PST)
Received: from [192.168.1.139] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id n6sm2279550wrj.60.2020.11.06.05.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 05:30:52 -0800 (PST)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
 <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
 <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
 <20201106100800.GA3431563@carbon.v>
 <b6e9eb08-86cd-b952-1c3a-4933a2f19404@gmail.com>
 <20201106131506.GA3989306@carbon.v>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <e510e624-c6d0-4f02-c539-33ffcce4f7c2@gmail.com>
Date:   Fri, 6 Nov 2020 13:27:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201106131506.GA3989306@carbon.v>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/11/2020 13:15, Dmitry Kadashev wrote:
> On Fri, Nov 06, 2020 at 12:49:05PM +0000, Pavel Begunkov wrote:
>> On 06/11/2020 10:08, Dmitry Kadashev wrote:
>>> On Thu, Nov 05, 2020 at 08:57:43PM +0000, Pavel Begunkov wrote:
>>> That's pretty much what do_unlinkat() does btw. Thanks Pavel for looking
>>> into this!
>>>
>>> Can I pick your brain some more? do_mkdirat() case is slightly
>>> different:
>>>
>>> static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
>>> {
>>> 	struct dentry *dentry;
>>> 	struct path path;
>>> 	int error;
>>> 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
>>>
>>> retry:
>>> 	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
>>>
>>> If we just change @pathname to struct filename, then user_path_create
>>> can be swapped for filename_create(). But the same problem on retry
>>> arises. Is there some more or less "idiomatic" way to solve this?
>>
>> I don't think there is, fs guys may have a different opinion but
>> sometimes it's hard to get through them.
>>
>> I'd take a filename reference before "retry:"
> 
> How do I do that? Just `++name.refcnt` or is there a helper function /
> better way?

I don't know, take a look around if there is one. In the end, a review and
guys familiar with this code will hopefully suggest a better way (if any).

-- 
Pavel Begunkov
