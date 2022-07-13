Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC330573AB6
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 17:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiGMP7U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 11:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbiGMP7T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 11:59:19 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E953E0EA;
        Wed, 13 Jul 2022 08:59:18 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id i204-20020a1c3bd5000000b003a2fa488efdso1136290wma.4;
        Wed, 13 Jul 2022 08:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y2AcRM2dbenguVq8Sn45LnuUE26anJQ/q/pVY/6n1mI=;
        b=NGmFsK31K81LNnEuzLEkyqa079LU33gvDJxusPFpemorWRPip2CCK+nQy3kYMY3LWt
         slVCbGuOycWQI/HyDgVCtTJZcxtH9Z/TqEDgHB6Km9ikqYJ5j9Cwn+6xru3Uyhn2+/qg
         uVyRw2QcKOnRXj7P+Ltn/ydyYxNkL0yjScCOQRH2UavyG9+j/yD8rHhIuJ+1vgyjxOXx
         vqM326AfI5IGdaFZ1cndX1SDDTi9qHBU3N8UJUAijEH8MSfDAPEqm4SDOhC6h1mfd1Vv
         jFMp/mU8tcA3kCg/VBkNdtU3fqzhqM6rl63mEGahXlQU/fEqO2VR+kfyS6yyXNtJq0QD
         SdIA==
X-Gm-Message-State: AJIora+ZCgGQKFOcL2F7dCkcF8kTs/QWH3dQypLSX4t2Tl56k+IAqpJO
        40TJnKTNUsH+8MfjPtbGZIs=
X-Google-Smtp-Source: AGRyM1v89jFtIWf5Owe/3xq9jPWOLvLV7mOEFexlE0Il+i3C8RydeEbGQ74p0+J4bujEJipuYpHfag==
X-Received: by 2002:a05:600c:4fc8:b0:3a1:987c:82d4 with SMTP id o8-20020a05600c4fc800b003a1987c82d4mr4449032wmq.26.1657727956465;
        Wed, 13 Jul 2022 08:59:16 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p13-20020a5d458d000000b0021d728d687asm14103484wrq.36.2022.07.13.08.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 08:59:16 -0700 (PDT)
Message-ID: <c000ecc9-e570-0788-88fa-8225a4b9fa04@grimberg.me>
Date:   Wed, 13 Jul 2022 18:59:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de>
 <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me>
 <20220713053633.GA13135@lst.de>
 <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me>
 <20220713101235.GA27815@lst.de>
 <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
 <96f47d9b-fbfc-80da-4c38-f46986f14a43@suse.de>
 <7c7a093c-4103-b67d-c145-9d84aaae835e@grimberg.me>
 <04b475f6-506f-188b-d104-b27e9dffc1b8@suse.de>
 <66322f2d-fbde-7b9f-14f1-0651511d95b8@grimberg.me>
 <1d1d94ea-b67b-405c-c825-faf67f258558@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <1d1d94ea-b67b-405c-c825-faf67f258558@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>>>> Amongst all the other issue we've found the prime problem with 
>>>>> SG_IO is that it needs to be directed to the 'active' path.
>>>>> For the device-mapper has a distinct callout (dm_prepare_ioctl), 
>>>>> which essentially returns the current active path device. And then 
>>>>> the device-mapper core issues the command on that active path.
>>>>>
>>>>> All nice and good, _unless_ that command triggers an error.
>>>>> Normally it'd be intercepted by the dm-multipath end_io handler, 
>>>>> and would set the path to offline.
>>>>> But as ioctls do not use the normal I/O path the end_io handler is 
>>>>> never called, and further SG_IO calls are happily routed down the 
>>>>> failed path.
>>>>>
>>>>> And the customer had to use SG_IO (or, in qemu-speak, LUN 
>>>>> passthrough) as his application/filesystem makes heavy use of 
>>>>> persistent reservations.
>>>>
>>>> How did this conclude Hannes?
>>>
>>> It didn't. The proposed interface got rejected, and now we need to 
>>> come up with an alternative solution.
>>> Which we haven't found yet.
>>
>> Lets assume for the sake of discussion, had dm-mpath set a path to be
>> offline on ioctl errors, what would qemu do upon this error? blindly
>> retry? Until When? Or would qemu need to learn about the path tables in
>> order to know when there is at least one online path in order to retry?
>>
> IIRC that was one of the points why it got rejected.
> Ideally we would return an errno indicating that the path had failed, 
> but further paths are available, so a retry is in order.
> Once no paths are available qemu would be getting a different error 
> indicating that all paths are failed.

There is no such no-paths-available error.

> 
> But we would be overloading a new meaning to existing error numbers, or 
> even inventing our own error numbers. Which makes it rather awkward to use.

I agree that this sounds awkward.

> Ideally we would be able to return this as the SG_IO status, as that is 
> well capable of expressing these situations. But then we would need to 
> parse and/or return the error ourselves, essentially moving sg_io 
> funtionality into dm-mpath. Also not what one wants.

uring actually should send back the cqe for passthru, but there is no
concept like "Path error, but no paths are available".

> 
>> What is the model that a passthru consumer needs to follow when
>> operating against a mpath device?
> 
> The model really is that passthru consumer needs to deal with these errors:
> - No error (obviously)
> - I/O error (error status will not change with a retry)
> - Temporary/path related error (error status might change with a retry)
> 
> Then the consumer can decide whether to invoke a retry (for the last 
> class), or whether it should pass up that error, as maybe there are 
> applications with need a quick response time and can handle temporary 
> failures (or, in fact, want to be informed about temporary failures).
> 
> IE the 'DNR' bit should serve nicely here, keeping in mind that we might 
> need to 'fake' an NVMe error status if the connection is severed.

uring passthru sends the cqe status to userspace IIRC. But nothing in
there indicates about path availability. That would be something that
userspace would need to reconcile on its own from traversing sysfs or
alike...
