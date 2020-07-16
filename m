Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F389222D3A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgGPUva (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgGPUva (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:51:30 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114BEC08C5C0
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:51:30 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q74so7544583iod.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/OMgh93Kb2HkE6P0kAr28R6z12ut/xwA3vG3iFDckbI=;
        b=SlhjXoboBAxGh2VTbr9NcInkijK7jQpCCQnuS6p+0nfgmyeVsheY4bc3BdXFSkBPTD
         j3PQMvPR5EZ0k3Bz8aBB5FiDK5eypyjPNP42owrGwPGZalFhiDbNSwOk1bM4s3eSCZkC
         t1nHWdMiS5XFpAFhIGk1PPbIC5sxZ+0K5oQFobuIKINk+5fhlhrQu/zBAXEjKjL+37fc
         B6KHhfMuEiwftkGVc+I9WskJLKiqmTxyD0TGV3XaLT5nKUXr0t/bhvar61NQsvEBNFm8
         bk9eKcwh96dfrbzu5YVUq0wY8MOR9LXEocoukxOjqRuQYvzHQ7lq/lJ6VWFgpiEeWzYQ
         hvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/OMgh93Kb2HkE6P0kAr28R6z12ut/xwA3vG3iFDckbI=;
        b=q7ESHFhf213BYkYsgERxtgD+jjPxaz4qC1WeCj0vBHEnBGRTBWYyNGQx5meuZ698xp
         MbbX2X09KWBbEqAEbyMErhnPkioFObKrJHLJplHILIh25t7b9SYdutpFnpcoodP+1ZkE
         UYz+0Fd6i+l4bpjAHTajWFLW0hFThbAiL3Rug7n3QFRD7fZ2ErQrtNKLvObsEHc5V8HN
         n53rVpcxtQ8W97mzFoW9OsfyVI/KWyYEdSO8SbIruiknjpH/P3D8vE12mmAwvhIB+Hhv
         JsR22YMTc+8mjnLBGMWf+14SkZFptxpRK2yKXXO+0gma39J0OZK+860sK/Po1eMvNmL+
         yvGw==
X-Gm-Message-State: AOAM531IO+7F7GSavoRYVNMBbCTpL0y4CSkQX7iovWG6Tzses92Z3UcE
        +cN9+BE3ZKVahFBUT/Dz0++RUg==
X-Google-Smtp-Source: ABdhPJy2wUZWh2Y4jruQ6d5kCL/LKMYVm6LNd8/aYi1fc8AM2ykPWqla4cvX5vltX/y94v5ZxMTqlA==
X-Received: by 2002:a5e:a60d:: with SMTP id q13mr6237726ioi.199.1594932689231;
        Thu, 16 Jul 2020 13:51:29 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i12sm3469283ioi.48.2020.07.16.13.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 13:51:28 -0700 (PDT)
Subject: Re: [PATCH RFC v2 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-2-sgarzare@redhat.com>
 <ca242a15-576d-4099-a5f8-85c08985e3ff@gmail.com>
 <a2f109b2-adbf-147d-9423-7a1a4bf99967@kernel.dk>
 <20326d79-fb5a-2480-e52a-e154e056171f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <76879432-745d-a5ca-b171-b1391b926ea2@kernel.dk>
Date:   Thu, 16 Jul 2020 14:51:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20326d79-fb5a-2480-e52a-e154e056171f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/20 2:47 PM, Pavel Begunkov wrote:
> On 16/07/2020 23:42, Jens Axboe wrote:
>> On 7/16/20 2:16 PM, Pavel Begunkov wrote:
>>> On 16/07/2020 15:48, Stefano Garzarella wrote:
>>>> The enumeration allows us to keep track of the last
>>>> io_uring_register(2) opcode available.
>>>>
>>>> Behaviour and opcodes names don't change.
>>>>
>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>> ---
>>>>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>>>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 7843742b8b74..efc50bd0af34 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -253,17 +253,22 @@ struct io_uring_params {
>>>>  /*
>>>>   * io_uring_register(2) opcodes and arguments
>>>>   */
>>>> -#define IORING_REGISTER_BUFFERS		0
>>>> -#define IORING_UNREGISTER_BUFFERS	1
>>>> -#define IORING_REGISTER_FILES		2
>>>> -#define IORING_UNREGISTER_FILES		3
>>>> -#define IORING_REGISTER_EVENTFD		4
>>>> -#define IORING_UNREGISTER_EVENTFD	5
>>>> -#define IORING_REGISTER_FILES_UPDATE	6
>>>> -#define IORING_REGISTER_EVENTFD_ASYNC	7
>>>> -#define IORING_REGISTER_PROBE		8
>>>> -#define IORING_REGISTER_PERSONALITY	9
>>>> -#define IORING_UNREGISTER_PERSONALITY	10
>>>> +enum {
>>>> +	IORING_REGISTER_BUFFERS,
>>>> +	IORING_UNREGISTER_BUFFERS,
>>>> +	IORING_REGISTER_FILES,
>>>> +	IORING_UNREGISTER_FILES,
>>>> +	IORING_REGISTER_EVENTFD,
>>>> +	IORING_UNREGISTER_EVENTFD,
>>>> +	IORING_REGISTER_FILES_UPDATE,
>>>> +	IORING_REGISTER_EVENTFD_ASYNC,
>>>> +	IORING_REGISTER_PROBE,
>>>> +	IORING_REGISTER_PERSONALITY,
>>>> +	IORING_UNREGISTER_PERSONALITY,
>>>> +
>>>> +	/* this goes last */
>>>> +	IORING_REGISTER_LAST
>>>> +};
>>>
>>> It breaks userspace API. E.g.
>>>
>>> #ifdef IORING_REGISTER_BUFFERS
>>
>> It can, yes, but we have done that in the past. In this one, for
> 
> Ok, if nobody on the userspace side cares, then better to do that
> sooner than later.
> 
> 
>> example:
>>
>> commit 9e3aa61ae3e01ce1ce6361a41ef725e1f4d1d2bf (tag: io_uring-5.5-20191212)
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Dec 11 15:55:43 2019 -0700
>>
>>     io_uring: ensure we return -EINVAL on unknown opcod
>>
>> But it would be safer/saner to do this like we have the done the IOSQE_
>> flags.
> 
> IOSQE_ are a bitmask, but this would look peculiar
> 
> enum {
> 	__IORING_REGISTER_BUFFERS,
> 	...
> };
> define IORING_REGISTER_BUFFERS __IORING_REGISTER_BUFFERS

Yeah true of course, that won't really work for this case at all.

That said, I don't think it's a huge deal to turn it into an enum.


-- 
Jens Axboe

