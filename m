Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D93F4E5948
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 20:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344344AbiCWTnB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 15:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbiCWTm6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 15:42:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8888BE14;
        Wed, 23 Mar 2022 12:41:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u26so3081257eda.12;
        Wed, 23 Mar 2022 12:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x5jJcCWNND08a/kl1cxTrhN4wD14TcjxcSdn0klR8Qw=;
        b=VoCz4F8clWIuOEdALXVnyNSFuOQ0p4ZDAKDuQdMbb1CHZfuP+1FZZQ3nsnw646cRYD
         p6DmW/OSE+kW/fnzJHt8QMmWlqKpcJ8AVoGrsWQ2SjVMXLfhPQqBmlpRLnxusm7Q+Ht5
         TzU2Nnd/gLJVk96rIDgIyIy6Rph8N+Fp8eCfR/TZrrhhKMmNvpNHfGfqeZsYEnM+tL2P
         12Kt6YgxuanOUTvrHU99TFAUIN3c8tGylNboY56KHfsLYQNvC7WnC0dgweETk/ZumQSt
         dTIw7yhLy9ojLLg2KxLYKAWFENnhMvTs7kU0oT5A1LfJXXGKkO7iiBL2t+eaS1BPct2L
         jQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x5jJcCWNND08a/kl1cxTrhN4wD14TcjxcSdn0klR8Qw=;
        b=KsAGQKUfobJob5VQiG6uI6KnhfhXcHKSsM1LhSC8ke7x5wgMoh+eetZKylUPOySa/o
         N9Ve8NDKcDGVPkvBexkLhMi4tSVUaE1A480wtt1ldjuVmmNYwuE6L2wpY0aYSWFuC+DL
         AGCVR6n54kPgS9BP9kgMD1Udz+HF/l92yF4e/7RIvGXyL+xPHYgJODM3JoEwMINVduk1
         GctmJgciFTJXvfdM5Zx/ScEitxYDcTuR2FWDdo0S+bMK4nJ+m0kdxETtlmNI50J57Rs/
         QdwRSDn+zZEkvePH9co46t5IFefd2Jn4wTJxvAhHfHl2vWVrzn/TMks/B3OvsnMfDD6I
         zh4A==
X-Gm-Message-State: AOAM530XE44LVwIPfnXToe2Bml0Ti0tZh12IF6BOluBssZ//VeLUY+kS
        btXsl/MQ4pPVZO5oLyDpa2Y7oqFOsmUZ6w==
X-Google-Smtp-Source: ABdhPJyj+501JuDpwR9KPC5PEbvLIaI5dgoqh+E3w83OqiTpoh7sP9qbmbaI9Enzy7gD/h8dgjPA0w==
X-Received: by 2002:a05:6402:26d3:b0:418:d202:d5dc with SMTP id x19-20020a05640226d300b00418d202d5dcmr2285382edd.138.1648064487522;
        Wed, 23 Mar 2022 12:41:27 -0700 (PDT)
Received: from [192.168.1.114] ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id e19-20020a056402105300b004162d0b4cbbsm370381edu.93.2022.03.23.12.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 12:41:26 -0700 (PDT)
Message-ID: <8f3cc170-1c24-da8a-37ec-f2e73eade46c@gmail.com>
Date:   Wed, 23 Mar 2022 19:40:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL
 in msg_flags
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Constantine Gavrilov <CONSTG@il.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
 <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/22 12:19, Jens Axboe wrote:
> On 3/23/22 4:31 AM, Constantine Gavrilov wrote:
>> I get partial receives on TCP socket, even though I specify
>> MSG_WAITALL with IORING_OP_RECV opcode. Looking at tcpdump in
>> wireshark, I see entire reassambled packet (+4k), so it is not a
>> disconnect. The MTU is smaller than 4k.
>>
>>  From the mailing list history, looks like this was discussed before
>> and it seems the fix was supposed to be in. Can someone clarify the
>> expected behavior?
>>
>> I do not think rsvmsg() has this issue.
> 
> Do you have a test case? I added the io-uring list, that's the
> appropriate forum for this kind of discussion.

MSG_WAITALL (since Linux 2.2)
        This flag requests that the operation block until the full
        request is satisfied.  However, the call may still return
        less data than requested if a signal is caught

My guess would be that it's either due to signals (including
task_works actively used by io_uring) or because of some
interoperability problem with NOWAIT.

-- 
Pavel Begunkov
