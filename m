Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE005706BB
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiGKPMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 11:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiGKPMg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 11:12:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFE474E0C;
        Mon, 11 Jul 2022 08:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=K+A7Xq0Dtg1M28AX2pm6iq7+K2wlhOA1YKzGE8z96xA=; b=ratBO5EA5ds+0wKQOD4let/B32
        Aj2p5qOJmxyMmtY0WdwaAVsGUumqNmum7z3V+13nIUCI3uwXpoGoMQYumZYYC8Fj0s6K5v6eJQCxf
        vcbx471HkEdRoS+ZJXccc7y07U8mAUhLrxoR9UJT8hYUE63gAGxZDC7l9HW9e6TiCpdBk3HSeh5Lb
        Zo6bAeTbGVzwoug5qeRckCXmmDQai/wsUwHN+Jy9FqXwY8JdjTjtfhtSWoHtZ9Tf8Re0puRh65VZ4
        5To4VC9qOKFVdSvaT/aqXun/rqArJjv/HTPqNueC7e+nLGfpScQIkP0Fo2WTi6cknKlOBXtAAzRhB
        XNppXIItFtblsBHmujlJOJDSMi6SwM23q6tVW2uzOTJXir+h3ptwR9doqsXd+qFuSu6PcQxBkU/GY
        xgBC4DDOlr5M/RXY00cpAcc/W4snU6cGCDjXYrVS19R12nyWHUpOjl9QcC0aD8hji7zmfR1ELKg+W
        zEpdqk34C2kWsJtW1OBIIWYE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oAv5D-004BnU-TL; Mon, 11 Jul 2022 15:12:23 +0000
Message-ID: <5c71b8f6-afec-8ef6-0a70-d13e71ded79c@samba.org>
Date:   Mon, 11 Jul 2022 17:12:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com>
 <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Sagi,

>> @@ -189,6 +190,12 @@ enum {
>>       NVME_REQ_USERCMD        = (1 << 1),
>>   };
>> +static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
>> +        struct io_uring_cmd *ioucmd)
>> +{

Shouldn't we have a BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
here?

>> +    return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
>> +}
>> +

>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>> index d734599cbcd7..57f4dfc83316 100644
>> --- a/include/linux/io_uring.h
>> +++ b/include/linux/io_uring.h
>> @@ -15,6 +15,8 @@ enum io_uring_cmd_flags {
>>       IO_URING_F_SQE128        = 4,
>>       IO_URING_F_CQE32        = 8,
>>       IO_URING_F_IOPOLL        = 16,
>> +    /* to indicate that it is a MPATH req*/
>> +    IO_URING_F_MPATH        = 32,

Isn't that nvme specific? If so I don't think it belongs in io_uring.h at all...

metze


