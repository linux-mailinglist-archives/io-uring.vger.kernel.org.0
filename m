Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374345734D5
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 13:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiGMLBD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 07:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbiGMLBC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 07:01:02 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ABEF788C;
        Wed, 13 Jul 2022 04:01:00 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id v16so14929532wrd.13;
        Wed, 13 Jul 2022 04:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T18yAEcOYCg0I5dMCxK9RpYvXfa2NL1kjk3NiDP/j/A=;
        b=YBD3I4DhXonIRTBNBW9qTBVAVAVtmvrtdOrZKfz96tyHB768X2vp908p4FIMvIuKvM
         Xm7GvWiW1VEDaB4owB8szPuTGTUxXEcI1C5Xp573bd2GjAhQaSmq0YMr5BKxq65FkUmX
         tBAK2qmNth+DxH6xTT3c7iFEJbzJJsUxnnZz9/RZO5UMizq/gYgfYmrfN0xGSoTBBUkG
         V0J7hzZSS1agcv7K2naNkIJmZ+YWwM0egwbXS/Tspw62gGJ0pwhqgSv5rMqiXZphZH0Q
         nR78L6ccG8Qfs+q3FuQ6y6TmT/t1Xbd0uT3mz6g1CnhQPqWRZXFvC0hqMI++XPfFrYAe
         OsOQ==
X-Gm-Message-State: AJIora+ja/dyD7HoTTzs8+TOKkUdq9VWWo07ppjaVaskSMKalEttu4y+
        1KbLvqT+3VTmxWpvwWYnKgU=
X-Google-Smtp-Source: AGRyM1uLDJ5KrZQfhVzYZeqC7ptNaRIFw7vlxuL1wa/br2L1mpf8BiyQW/709le2PXqlVH1hmUZstQ==
X-Received: by 2002:a5d:4602:0:b0:21d:6784:cdcb with SMTP id t2-20020a5d4602000000b0021d6784cdcbmr2632040wrq.470.1657710059145;
        Wed, 13 Jul 2022 04:00:59 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d6681000000b0021d6924b777sm10417359wru.115.2022.07.13.04.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 04:00:58 -0700 (PDT)
Message-ID: <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
Date:   Wed, 13 Jul 2022 14:00:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220713101235.GA27815@lst.de>
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


>> Maybe the solution is to just not expose a /dev/ng for the mpath device
>> node, but only for bottom namespaces. Then it would be completely
>> equivalent to scsi-generic devices.
>>
>> It just creates an unexpected mix of semantics of best-effort
>> multipathing with just path selection, but no requeue/failover...
> 
> Which is exactly the same semanics as SG_IO on the dm-mpath nodes.

I view uring passthru somewhat as a different thing than sending SG_IO
ioctls to dm-mpath. But it can be argued otherwise.

BTW, the only consumer of it that I'm aware of commented that he
expects dm-mpath to retry SG_IO when dm-mpath retry for SG_IO submission
was attempted (https://www.spinics.net/lists/dm-devel/msg46924.html).

 From Paolo:
"The problem is that userspace does not have a way to direct the command 
to a different path in the resubmission. It may not even have permission 
to issue DM_TABLE_STATUS, or to access the /dev nodes for the underlying 
paths, so without Martin's patches SG_IO on dm-mpath is basically 
unreliable by design."

I didn't manage to track down any followup after that email though...

>> If the user needs to do the retry, discover and understand namespace
>> paths, ANA states, controller states, etc. Why does the user need a
>> mpath chardev at all?
> 
> The user needs to do that for all kinds of other resons anyway,
> as we don't do any retries for passthrough at all.

I still think that there is a problem with the existing semantics for
passthru requests over mpath device nodes.

Again, I think it will actually be cleaner not to expose passthru
devices for mpath at all if we are not going to support retry/failover.
