Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C29E69E7B8
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 19:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjBUSlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 13:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjBUSlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 13:41:49 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC74630289
        for <io-uring@vger.kernel.org>; Tue, 21 Feb 2023 10:41:45 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id 6so5097465wrb.11
        for <io-uring@vger.kernel.org>; Tue, 21 Feb 2023 10:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Scw32g81M9khyk6O1qWobs/WLeuyPSU8UFwNxPCVYis=;
        b=Wk/FV79jebiOgdffHk5XZq3NRHfg3ZtAV3xHu/Id8y1azQ+95Qd43chywLtt70kiOv
         sW2AVyU2km7gkICCdlyCFNnQWg+PJo8qSGMrBrm8shVpcQtXE86ge7sy21W65/ZP0X7G
         57GSyweqL3xv6l1rYGaFxZ4jEJGzXQ4fmK5fmx6yIjCrndKaP7ryaOcI9mb2GSjQpCgm
         BqS+9tKh97xCWrK9kfAJOR94HqcrbEtVXBdTfIIB/68n4lJH9c3910KA+vJtULs/QetS
         W5Ck2CaKGroOUxR2hI2Njg93zsddF2eOhAZxu75rnrBAG1FLztQF7OiOybFIUtYIq2GA
         B5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Scw32g81M9khyk6O1qWobs/WLeuyPSU8UFwNxPCVYis=;
        b=5LleWFKkPrVbEWW3UE1jU0IeUPCKb86wbN23n26yQxChzEePL1pv0y6BUupcXxttQf
         wiO1ibo/6Lxr8HcITiyzOlVYXW7rCc/lLe0jySGB/axtAoSU64hHSnvH+cKc+UUP+ykX
         V+sYna56NItdU9sGBwg9GtTUGqg4LRee1cCU8wdkSYN24xq+mVXH6JR+W2el5cnK3KqK
         rFVBYGyH1BbBlNAOYyo5g4R1pNAUW5iS7TV+6JbELrGl47KYdz3Qxm0FjPzPqFvNRomF
         7rkm4ehClUub91qwu+3rZzqaVAYtd6jw7+Ht1iY/WJeVCdL1BvlxkZH4G16fW4eCsmcq
         XR5A==
X-Gm-Message-State: AO0yUKWoUDv1MKF6CORasCXoNGOtUPBbynkD7XFAAv7O59AGnzlOqbl6
        Df1VM1YwxY9Mhll7zo1D+B0=
X-Google-Smtp-Source: AK7set/E0hmKQIm8UAMgbXEVA85TQiZaQSlIcrmoO161V3uWGgZckO0cZJOYS7QkSyAhXt+dPoAJVA==
X-Received: by 2002:adf:feca:0:b0:2c5:4bd4:b3a8 with SMTP id q10-20020adffeca000000b002c54bd4b3a8mr5961895wrs.4.1677004903836;
        Tue, 21 Feb 2023 10:41:43 -0800 (PST)
Received: from [192.168.8.100] (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id c23-20020a05600c149700b003e2066a6339sm2844558wmh.5.2023.02.21.10.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 10:41:43 -0800 (PST)
Message-ID: <8997a85b-2624-2713-3819-7d67745ace64@gmail.com>
Date:   Tue, 21 Feb 2023 18:40:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH for-next v2 1/1] io_uring/rsrc: disallow multi-source reg
 buffers
To:     Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org
References: <6d973a629a321aa73c286f2d64d5375327d5c02a.1676902832.git.asml.silence@gmail.com>
 <87y1oscrsj.fsf@suse.de> <f15b5f08-ba79-9d73-8967-74cf69930f86@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f15b5f08-ba79-9d73-8967-74cf69930f86@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/21/23 16:29, Jens Axboe wrote:
> On 2/20/23 7:53 AM, Gabriel Krisman Bertazi wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>
>>> If two or more mappings go back to back to each other they can be passed
>>> into io_uring to be registered as a single registered buffer. That would
>>> even work if mappings came from different sources, e.g. it's possible to
>>> mix in this way anon pages and pages from shmem or hugetlb. That is not
>>> a problem but it'd rather be less prone if we forbid such mixing.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/rsrc.c | 15 ++++++++-------
>>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index a59fc02de598..70d7f94670f9 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -1162,18 +1162,19 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
>>>   	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
>>>   			      pages, vmas);
>>>   	if (pret == nr_pages) {
>>> +		struct file *file = vmas[0]->vm_file;
>>> +
>>>   		/* don't support file backed memory */
>>>   		for (i = 0; i < nr_pages; i++) {
>>> -			struct vm_area_struct *vma = vmas[i];
>>> -
>>> -			if (vma_is_shmem(vma))
>>> +			if (vmas[i]->vm_file != file)
>>> +				break;
>>
>> Perhaps, return -EINVAL instead of -EOPNOTSUPP
> 
> Agree, -EOPNOTSUPP is OK for an unsupported case, but I think
> -EINVAL makes more sense for the weird case of mixed sources
> as it's unlikely to ever make sense to support that.

ok

-- 
Pavel Begunkov
