Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A114F154974
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 17:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBFQmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 11:42:45 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42265 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbgBFQmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 11:42:44 -0500
Received: by mail-il1-f193.google.com with SMTP id x2so5617894ila.9
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 08:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hKgA97R2olaY6C2+8+rOCy+pH/axO3i15QhPSsxtG/A=;
        b=i3G6kqJJiXxE4GZ/TNj7LSjNzbN64dy9AATlcUICgGUZYqtSxE9AlEkN1ZKu0E+gA8
         qOunN0UKICDVpT+Exfbyiw1qHC5EyNQ0e4P5sHNkU5zPU0K/xn5FpywyT1RAXILSbrCI
         trvaYpaEfM3GWs+OCycm2tuO4XM+OQjstO1uDBmyq3Uc2XnRvnbOevj5kBYcmo5gY/kk
         8eZ9yBek4MqKs/TeSP+pAvpnEupNCLLAF1MOd0Ov0FTJ2HVAhSF0BHsIjsJDefUPqIik
         DqysLQjDfFlciqA5ENb5ADPljPc6H2bWJbkFKArujBlwYT9DB02eUjpSsJrqAy0ENgtn
         Y9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hKgA97R2olaY6C2+8+rOCy+pH/axO3i15QhPSsxtG/A=;
        b=FMyxacdO6Fev1yDgtNV5Pt5dbdH7vEx+UEtzTguMMSgcdqS8M+Q84t2S2tzWcATj0b
         Q5M9Ii+CUF5LxSrgJCs0GarYonKooi+DnDbmGMfYZm4HOe5Hk0djpZxsoNuVLmCjHcWA
         kf2LhFtg46H8B3sNSSZJ/rz/coUYKO4jk4irm/KHN8JmGUQWduYSImvc03dnyhXU0t8n
         NI4keXNylIpbXafX9Jft0R3FBX5giD7Mi6rIw7mA33LO1hRwRyvygO9V5zR9SlOvKg8u
         zPFVx0RPuYeZBCdkT9YLSkTkLLR9rr7vMG1ET2XNSA1r8aCg5ewmlF2LB/psjj07m03x
         7jcw==
X-Gm-Message-State: APjAAAWegPlbn9Vluc/tW3S3Xt5XXg3KSC/vLBNNw9mEhQjYGOU0ZuY1
        dspJz04v6JrZZX4eVJ9eX1ZHTEierTk=
X-Google-Smtp-Source: APXvYqxEnJfsUWh9Kg/r6zSU6cV7lRzOVVIquuFlpWnwUYAxQvfOF147PnAuYCclKZ5s5wSl0OiAlQ==
X-Received: by 2002:a92:d183:: with SMTP id z3mr4714174ilz.214.1581007356660;
        Thu, 06 Feb 2020 08:42:36 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u20sm3054iom.27.2020.02.06.08.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 08:42:36 -0800 (PST)
Subject: Re: [PATCH v1] io_uring_cqe_get_data() only requires a const struct
 io_uring_cqe *cqe
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200206160209.14432-1-metze@samba.org>
 <94d5b40d-a5d8-706f-ab5c-3a8bd512d831@kernel.dk>
 <a26428e4-39d7-972c-cc68-45f7230d51b9@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <95e6c04d-e66f-06f8-3a04-ac59b35c2ac7@kernel.dk>
Date:   Thu, 6 Feb 2020 09:42:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a26428e4-39d7-972c-cc68-45f7230d51b9@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 9:37 AM, Stefan Metzmacher wrote:
> Am 06.02.20 um 17:04 schrieb Jens Axboe:
>> On 2/6/20 9:02 AM, Stefan Metzmacher wrote:
>>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>>> ---
>>>  src/include/liburing.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>>> index faed2e7..44f18fd 100644
>>> --- a/src/include/liburing.h
>>> +++ b/src/include/liburing.h
>>> @@ -179,7 +179,7 @@ static inline void io_uring_sqe_set_data(struct io_uring_sqe *sqe, void *data)
>>>  	sqe->user_data = (unsigned long) data;
>>>  }
>>>  
>>> -static inline void *io_uring_cqe_get_data(struct io_uring_cqe *cqe)
>>> +static inline void *io_uring_cqe_get_data(const struct io_uring_cqe *cqe)
>>>  {
>>>  	return (void *) (uintptr_t) cqe->user_data;
>>>  }
>>
>> Applied, thanks.
> 
> Thanks!
> 
>> Unrelated to this patch, but I'd like to release a 0.4 sooner rather
>> than later.
> 
> Funny, I thought about that today:-)
> I prepared debian packaging for liburing-0.4 I'll send the patches soon.

Great!

> While doing that I found the following incompatible change against
> liburing-0.3:
> 
>  static inline void io_uring_prep_files_update(struct io_uring_sqe *sqe,
> -                                             int *fds, unsigned nr_fds)
> +                                             int *fds, unsigned nr_fds,
> +                                             int offset)
> 
> I'm not sure if we should do something about that.

Hmm, that wasn't on purpose. But for this specific case, I think we can
just pretend that never happened.

> It's also strange that in src/liburing.map LIBURING_0.3 doesn't
> inherit LIBURING_0.2. There's not a single symbol with @LIBURING_0.3.
> Also io_uring_{setup,enter,register} are still
> listed under LIBURING_0.1, but they're not in the library anymore.

That seems like a bug, I'd happily take a patch for that...

>> Let me know if you see any immediate work that needs doing
>> before that happens.
> 
> I had the idea to have a simple version of fd compounding.
> We already have IORING_OP_FILES_UPDATE in order to update
> specific indexes in the files array.
> I'm wondering if we could have specify an index where
> IORING_OP_ACCEPT, IORING_OP_OPENAT and IORING_OP_OPENAT2
> could store the generated fd into the fixed array.
> The index 0 is not valid, correct? So we can have it
> without a flag similar to the personality, and for
> all of these buf_index is not used.

Just to make sure I'm undestanding your proposal, you want the result
from those fd instantiating calls to be added to the array of registered
files, instead of having the application do that? If so, I think this is
another case where the BPF driven links would be useful, as we could
easily do it through that with an IORING_OP_FILES_UPDATE linked to
either one of those commands.

index 0 is valid, so we can't use that trick.

> While researching that I noticed that IOSQE_FIXED_FILE
> seems to be ignored for some new commands, I think that
> all commands with on input fd, should be able to use that flag.
> Can this be fixed before 5.6 final?

Do you have specifics? Generally the file grabbing happens as part of
request prep, and the individual opcodes should not need to bother with
it.

-- 
Jens Axboe

