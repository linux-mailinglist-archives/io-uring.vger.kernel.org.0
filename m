Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31704573687
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 14:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiGMMnr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 08:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiGMMnp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 08:43:45 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A8625D9;
        Wed, 13 Jul 2022 05:43:44 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id z12so15342417wrq.7;
        Wed, 13 Jul 2022 05:43:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YNfmnBevLQmSX9o76Mh2mjvcTRQ7EQJDjtg54zLGl04=;
        b=YJ+Qm2hZgXq3ZrKv2hL8itINxKr5z3So9yv+ddxWpWeHGtphgtUcpLKTHrCwlMlb4Y
         bI1udR6f8JZeFzt3U5T0fgZy/0AIMfXFnfxLbgig03iVOw6Edu+InFBCTasg8wsvg4Ec
         LOR+36VRCqPqCeBFdUzmJmOOTy2Rs13jp7/8KbuAspAfJDpfL7+eVsCdkb6cL0rTscee
         Dbu3e1ddODCKCF0YjAiLLYtfRK73TLVPOV51Yki9+oygvrLeaZO3V1I85COJY1sTrdGB
         5gyL35UwyfRs23c86jMtI2xhqoAVgVCziZMjUBygZddVu0+I5FgH2druTHFZvgqQDz6D
         3EAg==
X-Gm-Message-State: AJIora8eHk1b0ic7pg6EM7xyU5+AcfYrSQTZbf8s7QsQefJCceKVQGud
        0KLjgO6V8x0t7rgHA+lYuvY=
X-Google-Smtp-Source: AGRyM1twAonTFmo1o0pkRBxXTqOM0VE5qj+d65TCkBzKOADontj9hlEjq4fJBLXpaLfXhOwP1f3IFA==
X-Received: by 2002:adf:ee8a:0:b0:21d:76f0:971e with SMTP id b10-20020adfee8a000000b0021d76f0971emr3238256wro.130.1657716222828;
        Wed, 13 Jul 2022 05:43:42 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id q6-20020a1cf306000000b003a2e92edeccsm2058462wmq.46.2022.07.13.05.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 05:43:42 -0700 (PDT)
Message-ID: <7c7a093c-4103-b67d-c145-9d84aaae835e@grimberg.me>
Date:   Wed, 13 Jul 2022 15:43:39 +0300
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <96f47d9b-fbfc-80da-4c38-f46986f14a43@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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



On 7/13/22 14:49, Hannes Reinecke wrote:
> On 7/13/22 13:00, Sagi Grimberg wrote:
>>
>>>> Maybe the solution is to just not expose a /dev/ng for the mpath device
>>>> node, but only for bottom namespaces. Then it would be completely
>>>> equivalent to scsi-generic devices.
>>>>
>>>> It just creates an unexpected mix of semantics of best-effort
>>>> multipathing with just path selection, but no requeue/failover...
>>>
>>> Which is exactly the same semanics as SG_IO on the dm-mpath nodes.
>>
>> I view uring passthru somewhat as a different thing than sending SG_IO
>> ioctls to dm-mpath. But it can be argued otherwise.
>>
>> BTW, the only consumer of it that I'm aware of commented that he
>> expects dm-mpath to retry SG_IO when dm-mpath retry for SG_IO submission
>> was attempted (https://www.spinics.net/lists/dm-devel/msg46924.html).
>>
>>  From Paolo:
>> "The problem is that userspace does not have a way to direct the 
>> command to a different path in the resubmission. It may not even have 
>> permission to issue DM_TABLE_STATUS, or to access the /dev nodes for 
>> the underlying paths, so without Martin's patches SG_IO on dm-mpath is 
>> basically unreliable by design."
>>
>> I didn't manage to track down any followup after that email though...
>>
> I did; 'twas me who was involved in the initial customer issue leading 
> up to that.
> 
> Amongst all the other issue we've found the prime problem with SG_IO is 
> that it needs to be directed to the 'active' path.
> For the device-mapper has a distinct callout (dm_prepare_ioctl), which 
> essentially returns the current active path device. And then the 
> device-mapper core issues the command on that active path.
> 
> All nice and good, _unless_ that command triggers an error.
> Normally it'd be intercepted by the dm-multipath end_io handler, and 
> would set the path to offline.
> But as ioctls do not use the normal I/O path the end_io handler is never 
> called, and further SG_IO calls are happily routed down the failed path.
> 
> And the customer had to use SG_IO (or, in qemu-speak, LUN passthrough) 
> as his application/filesystem makes heavy use of persistent reservations.

How did this conclude Hannes?
