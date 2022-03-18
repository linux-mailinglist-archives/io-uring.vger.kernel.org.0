Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF47B4DDDC6
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 17:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiCRQIf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 12:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiCRQH7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 12:07:59 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBC359A71
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 09:06:32 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h6so1194307ild.4
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 09:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Hb5aL8VpjeFodb9/+mkO1n3FxGtsj0l87w/RhxVoBN8=;
        b=XsTpfBDb/2N6c9DikpxZvYoPOpu2zZjjKjsHus2ErRqoMLS44JTCEnUKfwPD03wWqM
         lxz3dQ1xG/raEDig6jcbYvweDDn1QOPHsbwKVvjEjDis+kDTKRlf0rkmGDdmJkSgIVCp
         juF6qMVHrVi1jzRft6wnCFcKGA+9kjoiB1ii4ITeYx2aZlyjoc+JKQ7Hvj/RkZwNDnSF
         +l7BC828l2mIssswr+Ejy5pvI5fQfCTHt+K+KhVl8Ec7m9Dyo1Wj/OfuDNRDiT0jWOI+
         1VYJ4F33H5JxWVCAwMY4s+zgQFz8mYg0hAv1vC4/tF5sdbpFArw8mic0K80mVt32OD5B
         nFHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hb5aL8VpjeFodb9/+mkO1n3FxGtsj0l87w/RhxVoBN8=;
        b=Vm1nym9cZ7tOjFh+oqZZ70owhiwCyyIJB8tzomd8+bu2F6AJp4YO0+fDw6gdNjPYWT
         RMFdCt3vIDfMmdyfga2NeZRAooi2dmiFgUzgU/aS59nVjCxv2KMYivE0tEhUbztXN+1S
         rfeT/Oxmyx343gzeK0MqHu8AZIKlSoTxRnImVj4D6FIMTXAJjj/ZqoEkwUc5U4mligMQ
         5OszAIG7qLE75KGOCtkwqdo8rMaWlbpZFJm2PJP1uiK72NTnLH4F+obD/7L6yJF8mJjW
         dcCzE6dz+3jYHWCb5NIZVgDpHOlHfB+NhiPhLW0odYV0r2MJmT/+sp4tZvSotNIwZBNs
         sKIQ==
X-Gm-Message-State: AOAM532132L8scLS/C/9YhEinjvLj4lBYwNWCmBZgK0rh4j5lqfRd3/A
        lLxKolGGO4CTKIRRPqxEmX6unwf/PwnToJSe
X-Google-Smtp-Source: ABdhPJyijmTHjPKdyTYvy7/a1guxOo+EsT80buIpQ7DOPh/QOapVK7YMsRNky/fmobqrlgxZNwWpDQ==
X-Received: by 2002:a05:6e02:1526:b0:2c7:b94e:195a with SMTP id i6-20020a056e02152600b002c7b94e195amr4271914ilu.225.1647619591442;
        Fri, 18 Mar 2022 09:06:31 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a3-20020a5ec303000000b006496b4dd21csm779205iok.5.2022.03.18.09.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 09:06:31 -0700 (PDT)
Message-ID: <ecf71a46-f628-3c28-517c-08020633d638@kernel.dk>
Date:   Fri, 18 Mar 2022 10:06:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 4/4] io_uring: optimise compl locking for non-shared rings
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <9c91a7dc445420230f7936d7f913eb212c1c07a3.1647610155.git.asml.silence@gmail.com>
 <3530662a-0ae0-996c-79ee-cc4db39b965a@kernel.dk>
 <7ef3335a-8e7c-d559-5a78-f48bf506f53c@gmail.com>
 <ce480edd-c82b-c094-39cd-d45d6b76e5a3@kernel.dk>
 <aa3c0800-feed-50f9-e8bb-d4b861c4265c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aa3c0800-feed-50f9-e8bb-d4b861c4265c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 9:32 AM, Pavel Begunkov wrote:
>>>> work with registered files (and ring fd) as that is probably a bigger
>>>> win than skipping the completion_lock if you're not shared anyway.
>>>
>>> It does work with fixed/registered files and registered io_uring fds.
>>
>> t/io_uring fails for me with registered files or rings, getting EINVAL.
>> Might be user error, but that's simply just setting CQ_PRIVATE for
>> setup.
> 
> One thing I changed in the tool is that the ring should be created
> by the submitter task, so move setup_ring into the submitter thread.
> Plan to get rid of this restriction though.

OK, thought it was probably something like that, you do end up with two
tctx if you init in main and pass to thread. But that's probably quite a
common way to do setup, so should deal with that in the future at least.
Just part of the stuff that would ultimately need polishing.

> Weird that it works only for you only without reg files/rings, will
> take a look.

I think the part above totally explains it.

> Attached io_uring.c that I used, it's based on some old version,
> so do_nop can't be set in argv but should turned in the source code.
> IORING_ENTER_REGISTERED_RING is always enabled.

Thanks!

-- 
Jens Axboe

