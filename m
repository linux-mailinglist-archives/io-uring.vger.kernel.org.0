Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A47856581F
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 16:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiGDOAz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 10:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiGDOAi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 10:00:38 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4FFDF54;
        Mon,  4 Jul 2022 07:00:13 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id n4so6241166wru.11;
        Mon, 04 Jul 2022 07:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9ya4FqHqG3w7UGSD1/owDFfHZARYDJr0su8IHEw0uLY=;
        b=u2W6OEJzurr1s0cM4gRNZuExODwYfJbbDNAhcWkWEQmVtOC8c9aWeVbCtywlVkFMHf
         Z8kaPZNzO4+JbgF4hDuNp1QQO69BRJBTSFidurUZ3sZ/uxki2XsKa2LdntbvHA7avBC1
         ntPSqgo+KFtIlAv+Oe4KstVna4m3bDtyUWUNHsbL9ZTNHWDo26BTQoPndEzVA+GKU8jk
         3GxDks2whClFXqyUtxMjvW0sm3YU0B8Wcbve+WrN10oABMaQoHH31NyVuYjj1IOA5HRs
         kEkoxUSjLrI+gQ9x0uTuvDo4Kfwfx68OTB1E15SmLvrAFhVEhC7hpC9xq5NNBpaNRH+T
         fl9A==
X-Gm-Message-State: AJIora9yaCFafEF59gBzoaEPKlQo2epfJP4UfkDDaFGkJcjQkIEcq5Bp
        TxXTUYmVmmYWmRRiBKZF37k=
X-Google-Smtp-Source: AGRyM1v1LYoyvj/v8X1NMSy3/FWqn7N3LsEjbrJF44Qf9HtE8RXp6cR/gCKtvcnH6TT0GuzulgcNLQ==
X-Received: by 2002:a05:6000:2a4:b0:21d:1896:763e with SMTP id l4-20020a05600002a400b0021d1896763emr27354562wry.248.1656943212101;
        Mon, 04 Jul 2022 07:00:12 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b003a17ab4e7c8sm18418946wmq.39.2022.07.04.07.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 07:00:11 -0700 (PDT)
Message-ID: <8cf1aef0-ea5b-a3df-266d-ae67674c96ae@grimberg.me>
Date:   Mon, 4 Jul 2022 17:00:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <da861bbb-1506-7598-fa06-32201456967d@grimberg.me> <YsLeR1QWPmqfNAQY@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <YsLeR1QWPmqfNAQY@T590>
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


>>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>>> index fdb81f2794cd..d218089cdbec 100644
>>> --- a/drivers/block/Kconfig
>>> +++ b/drivers/block/Kconfig
>>> @@ -408,6 +408,12 @@ config BLK_DEV_RBD
>>>    	  If unsure, say N.
>>> +config BLK_DEV_UBLK
>>> +	bool "Userspace block driver"
>>
>> Really? why compile this to the kernel and not tristate as loadable
>> module?
> 
> So far, this is only one reason: task_work_add() is required, which
> isn't exported for modules.

So why not exporting it?
Doesn't seem like a good justification to build it into the kernel.
