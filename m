Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0562114348E
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2020 00:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgATXyG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jan 2020 18:54:06 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44651 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgATXyG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jan 2020 18:54:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id 62so490046pfu.11
        for <io-uring@vger.kernel.org>; Mon, 20 Jan 2020 15:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1HBSmKU6VWJGusJnZgNPYHvJl6U+C5QqbmbrNFUjXtk=;
        b=xthRybHMqUIJNhqfPBYcYwztkyKr8+8ajjlSNJ6UjpH4OmxIcm437+hwTsgWL9TChQ
         Y/rLMqSDuhYcSJDfdb9wE4iPQEoKdVjqIXADIQLhSSfaCkOswWLp/RQ7s0WNdM0YlsCc
         tVDJx2qLcIcJxggHsvGqOYhtdJy+WDIpk3HFI+mK1Dp9TX3Y8A74KBeD8hqizpEi+iLm
         mKOw6TV2KYVHbO2uuRrZwzcAZldFfaqysfnP2/YxwVpYvp3jwxzw8yX1J1HY67gDLpF5
         27JVuHnGyAbTG83SNXq2hZmfodnXDCo7j4HZ9CS7r/1Nahb+Pu8GZaP2pRL4K3zaA+Py
         ICvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HBSmKU6VWJGusJnZgNPYHvJl6U+C5QqbmbrNFUjXtk=;
        b=TDVUzaufWKh5rn5kL2SwsFnvxA/9Gfcn00h6bgX0/NqnGBjYhyQ/kdxycaWCt0Gf/p
         053nJ2q7HziHA7dSUGFOUSkKpNYonzOLyDfTSbXhoCH6GSHccsswfJESKjhQ+JuTFy9T
         /lwLWYxUuUx3p2mIKGT+xJJo8LqgQRYqsO4JL9aHXtFALvV9VoJxPaKuhzL6PR/iDZK5
         VTHSTNYNrxI52silI1kFj+qHA+eA/yWt6UgDGu+wWhgDlDBgpNJvrcq+kU9OweinIN3W
         7e5mu1nCd/FiqajQGbZ92kaQYEnCVuWqzrKyVhcpkzyb+Pjs3e5bhOXektefqMqAVvix
         4UXw==
X-Gm-Message-State: APjAAAV1XGE5uhFG2qgAhllwqCWokF7+YmkNLcNmhbDSev5X1fUYyiMB
        E0JwmjomU3ALgO8bU8mnQiA+Kw==
X-Google-Smtp-Source: APXvYqwh4IP0P2LQk3C0ppEeB6sPqpE/3ZKVaGx/ha45D3S0aKVy0xXWq+G0hiXpLhXU4vJdtIhPZg==
X-Received: by 2002:a63:e4f:: with SMTP id 15mr2221691pgo.398.1579564444923;
        Mon, 20 Jan 2020 15:54:04 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n4sm38125483pgg.88.2020.01.20.15.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 15:54:04 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix compat for IORING_REGISTER_FILES_UPDATE
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Eugene Syromiatnikov <esyr@redhat.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
References: <20200115163538.GA13732@asgard.redhat.com>
 <cce5ac48-641d-3051-d22c-dab7aaa5704c@kernel.dk>
 <20200115165017.GI1333@asgard.redhat.com>
 <a039f869-6377-b8b0-e170-0b5c17ebd4da@kernel.dk>
 <20200120235146.GA12351@altlinux.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ef31935e-7b4e-9e28-cf8f-ed3cb954db22@kernel.dk>
Date:   Mon, 20 Jan 2020 16:54:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120235146.GA12351@altlinux.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/20/20 4:51 PM, Dmitry V. Levin wrote:
> On Wed, Jan 15, 2020 at 09:53:27AM -0700, Jens Axboe wrote:
>> On 1/15/20 9:50 AM, Eugene Syromiatnikov wrote:
>>> On Wed, Jan 15, 2020 at 09:41:58AM -0700, Jens Axboe wrote:
>>>> On 1/15/20 9:35 AM, Eugene Syromiatnikov wrote:
>>>>> fds field of struct io_uring_files_update is problematic with regards
>>>>> to compat user space, as pointer size is different in 32-bit, 32-on-64-bit,
>>>>> and 64-bit user space.  In order to avoid custom handling of compat in
>>>>> the syscall implementation, make fds __u64 and use u64_to_user_ptr in
>>>>> order to retrieve it.  Also, align the field naturally and check that
>>>>> no garbage is passed there.
>>>>
>>>> Good point, it's an s32 pointer so won't align nicely. But how about
>>>> just having it be:
>>>>
>>>> struct io_uring_files_update {
>>>> 	__u32 offset;
>>>> 	__u32 resv;
>>>> 	__s32 *fds;
>>>> };
>>>>
>>>> which should align nicely on both 32 and 64-bit?
>>>
>>> The issue is that 32-bit user space would pass a 12-byte structure with
>>> a 4-byte pointer in it to the 64-bit kernel, that, in turn, would treat it
>>> as a 8-byte value (which might sometimes work on little-endian architectures,
>>> if there are happen to be zeroes after the pointer, but will be always broken
>>> on big-endian ones). __u64 is used in order to avoid special compat wrapper;
>>> see, for example, __u64 usage in btrfs or BPF for similar purposes.
>>
>> Ah yes, I'm an idiot, apparently not enough coffee yet. We'd need it in
>> a union for this to work. I'll just go with yours, it'll work just fine.
>> I will fold it in, I need to make some updates and rebase anyway.
> 
> I see the patch has missed v5.5-rc7.
> Jens, please make sure a fix is merged before v5.5 is out.

Ah shoot, I actually thought I added it for 5.6 only, but you are right,
it's in 5.5-rc as well. I'll ship a patch this week for 5.5.

-- 
Jens Axboe

