Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A493B8A2F
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhF3VsS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhF3VsR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:48:17 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D568C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:45:48 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id k16so4942136ios.10
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UbB/Fx9fr1qHq1rjojxhqJx8Qd61yb5/ShsI3E2CJ3o=;
        b=euK2zFj5FCHr3YUMM3f5s8Ib5o7DfheVuRRHNkc5p143E7OlvzWb/eBRPOpxEGceWo
         KoBmZtb7c8bZzlSnMDn1BJRB3iW4cKWMq1R6+jXD8ZHUwBV5IiQ3s8Himig2fTA6/Nyi
         +W4upjqtzyq/3UHQsJy6aLITEXUS7sZ1TF6l2bgX5FfWTkh5Q6WUMe2/XtEMsRUmgE4d
         /xDB8JFOYGQRBa/zAsoAdllZPM29sOD6GpKvRTQLqCXQ65DajR6uFzdURuOViBpPLjU3
         LleRC6GtxFwb5bN2UYOrDQwkJt4f1fxybYjBCOfBhs+THpSBhGktQDsD9BGKRod5bann
         AQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UbB/Fx9fr1qHq1rjojxhqJx8Qd61yb5/ShsI3E2CJ3o=;
        b=IoLdmvpFzR1VpLGRdylNA6RgbOeBahAv5TBDriBf3dU8q6vRZhi8p6cXooCuvNaP0g
         YU6zlvRrZnpOC/QH9H5V3EKTx1lqW1w8+Asuoz42Jw7gikErLh+bLfq0/epTfbPFej+4
         i5n9HpPnhuPPiRm8Luk3kmjGuMVUbx7KXQgPkVnnTG8kXoNM6nSq3sTPsABsQo6FJuM/
         pC6WU+ZXP3GHEKW/30x27mcQOltDxzNMRMFIl8AGqe4RralFXjmlBe9/hlwnk7s60amc
         fWV9xNP6+gVH1yIkUNcew/9U0snm39W8XP7Z0ybpCFE+78Cf3V+6dZY3q6mlyhrksKXk
         zfIg==
X-Gm-Message-State: AOAM531oGeVk8huGDgx+JHzeIfzmvlolpgMUtVyZMhKUQzCqnHbNL4wh
        hwqGEaRToHjIgxRSmsTOXxAAKKUM0zut8g==
X-Google-Smtp-Source: ABdhPJwrXCoR8n1pJl4O/5JjbKpGVSUcRlGkWOAuO9+xzvtlsO/DLdvY4ZqlAi7e5WzykAwXqzYyug==
X-Received: by 2002:a05:6638:c2:: with SMTP id w2mr10847133jao.38.1625089547885;
        Wed, 30 Jun 2021 14:45:47 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id l7sm7838581iol.53.2021.06.30.14.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:45:47 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
 <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
Date:   Wed, 30 Jun 2021 15:45:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 3:38 PM, Pavel Begunkov wrote:
> On 6/30/21 10:22 PM, Jens Axboe wrote:
>> On 6/30/21 3:19 PM, Pavel Begunkov wrote:
>>> On 6/30/21 10:17 PM, Jens Axboe wrote:
>>>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>>>> Whenever possible we don't want to fallback a request. task_work_add()
>>>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>>>> there is anyway only a relatively small gap between setting the flag
>>>>> and doing the final task_work_run().
>>>>>
>>>>> Also add likely for the hot path.
>>>>
>>>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>>>
>>>>> -	if (test_bit(0, &tctx->task_state) ||
>>>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>>>  		return 0;
>>>>
>>>> where the state is combined. In any case, it should be a separate
>>>> change. If there's an "Also" paragraph in a patch, then that's also
>>>> usually a good clue that that particular change should've been
>>>> separate :-)
>>>
>>> Not sure what's wrong with likely above, but how about drop
>>> this one then?
>>
>> Yep I did - we can do the exiting change separately, the commit message
> 
> I think 1-2 is good enough for 5.14, I'll just send it for-next
> 
>> just needs to be clarified a bit on why it's ok to do now. And that
> 
> It should have been ok to do before those 2 patches, but
> haven't tracked where it lost actuality.

Right, I was thinking it was related to the swapping of the signal
exit and task work run ordering. But didn't look that far yet...

-- 
Jens Axboe

