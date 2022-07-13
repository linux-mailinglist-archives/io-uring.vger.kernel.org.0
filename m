Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04569573006
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 10:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiGMIEl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 04:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbiGMIEj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 04:04:39 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547F8E5DC2;
        Wed, 13 Jul 2022 01:04:35 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id p27-20020a05600c1d9b00b003a2f36054d0so707161wms.4;
        Wed, 13 Jul 2022 01:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IMbD90s21HdnddiL42xIyv27c0/QtqF4u8JsID8zNs0=;
        b=kCtcMtyKggjmPg2K17SKzaHN7Qw2OpNRYLnsafZdMWzloxrKm2i2o3ZoM7NHnarNx6
         cgQk4uqcZP85SOvHO9th9QVImxLKs37NMmpJflFUIfO1t53+efmMFmj1k0wnBrVr7NB4
         ZnkzO9iLaj7R6iTX7lZHfkKXZ213K5ZnSVF80wR1SlhHhdbi8qNRsNdbv+6pLEnkfMX4
         /YGnn8dhygDpguDVC0rrj9BOi+1YzfI5pU+gJBuWSz7jm3F6Q45/4PPxbfgnzLaS7tYT
         1vwn+30W9zBdjiAgFZ9hJRbtOBr5mpOAR04QP8hJJP8ucZw8fAEPOalqcwl6dBjODIVa
         jt0g==
X-Gm-Message-State: AJIora94gVnGINfKCR1ZlaPI58FKZrnOXV+bO3oW72b7speyLHJA+Nrx
        b3CZBIovbjv06sKKxsTCWc4=
X-Google-Smtp-Source: AGRyM1vwsh7bKCpn2lTmbIQEoG/5T6EX7m8IACBWbztC+wbdRF/oK3yyKEfzXUu/Co8455P2m9GISw==
X-Received: by 2002:a05:600c:3545:b0:3a2:f3e3:c382 with SMTP id i5-20020a05600c354500b003a2f3e3c382mr2774942wmq.142.1657699473799;
        Wed, 13 Jul 2022 01:04:33 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id n187-20020a1c27c4000000b003a199ed4f44sm1566011wmn.27.2022.07.13.01.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 01:04:33 -0700 (PDT)
Message-ID: <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me>
Date:   Wed, 13 Jul 2022 11:04:31 +0300
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220713053633.GA13135@lst.de>
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


>> I think the difference from scsi-generic and controller nvme passthru is
>> that this is a mpath device node (or mpath chardev). This is why I think
>> that users would expect that it would have equivalent multipath
>> capabilities (i.e. failover).
> 
> How is that different from /dev/sg?

/dev/sg it is not a multipath device.

Maybe the solution is to just not expose a /dev/ng for the mpath device
node, but only for bottom namespaces. Then it would be completely
equivalent to scsi-generic devices.

It just creates an unexpected mix of semantics of best-effort
multipathing with just path selection, but no requeue/failover...

>> In general, I think that uring passthru as an alternative I/O interface
>> and as such needs to be able to failover. If this is not expected from
>> the interface, then why are we exposing a chardev for the mpath device
>> node? why not only the bottom namespaces?
> 
> The failover will happen when you retry, but we leave that retry to
> userspace.  There even is the uevent to tell userspace when a new
> path is up.

If the user needs to do the retry, discover and understand namespace
paths, ANA states, controller states, etc. Why does the user need a
mpath chardev at all?

The user basically needs to understand everything including indirectly
path selection for the I/O. IMO it is cleaner for the user to just have 
the bottom devices and do the path selection directly.
