Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63E5608E5C
	for <lists+io-uring@lfdr.de>; Sat, 22 Oct 2022 18:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJVQHN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Oct 2022 12:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJVQHM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Oct 2022 12:07:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DDB15A1A
        for <io-uring@vger.kernel.org>; Sat, 22 Oct 2022 09:07:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so5660858pjb.2
        for <io-uring@vger.kernel.org>; Sat, 22 Oct 2022 09:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3cwE8aW8XE9R//Smi46rWuN8X7KQh2xLskFY+dpCrSs=;
        b=MJoy2jawuyRY3OGPhwy4qEiWRbnBSvWIsoiAputcEHFrZoP3e1JmAIOLjWlDIa+IvB
         JKhpe0/TaAXBEtNLG+oCJG2pAWlZZpBVBCJn7++EtLntfo+/coDGrFsqnSHaAEAaJSZd
         rPHR2TZzuLroEnmogAvvm7Cqeon/Xslg5IY3P1RYXoWZZU5b32aTwl0kIAz7N6ntsRkE
         V1cGfWDumO+4J0T4Eb2Yyh+4tEgy/ZdtWDLAk7YETtubSBTYBXKwDO/Bn7GmGEhTGfBn
         RjE+FhzGhO7TmGCECe1PtcrUe+XIvHMuqBYwo4v6d/aovHlAMvlFY/d5Y30GMdgDWjl1
         aXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3cwE8aW8XE9R//Smi46rWuN8X7KQh2xLskFY+dpCrSs=;
        b=tcTeweDNcPy13ijTNkMLShkqPocwWP2nrS+SZpXNZycvPQUI+NGuFV76aTfVKbkChH
         9R52luOG4uWjeEidbn3UsnXaO+SdKzJ79wD27+ePDAMhLWg3klQ11Djo/ZeRS/+NxUXS
         GXsoXaQBUzvDKSmjU54PeoqwtbSSgmfMBz8ggBb83ixrDM3AuATHa07eeXFgGXFo/cpO
         cFkk9NY9BFBm1hm11Ljqb/IUxMmMOw4R0cgfkXb1xIDTXQFA6NvsYVM0+GOBTmMrj/Ge
         ZPVIrEH9Hs3JL0FyGf0ecdJQP4rNJkl6oeMymF4n1WP7/48NobwEuhVHNzVu4WDFtDD1
         H0Og==
X-Gm-Message-State: ACrzQf2Me6C/HgbBSYZdWidObXcvsbV9zH3dlY0EGRDhYdj1lunHv048
        tCGqYHbo8D1Dguvny4g+m7+5og==
X-Google-Smtp-Source: AMsMyM7iQsYYi8nvU/BmgV+4LtNMdLB6z+x2swhB+Rlw16GawKmiy9UIBivzYSnAZmxR0FYp/VNj0A==
X-Received: by 2002:a17:90b:33d0:b0:20d:5edf:8b92 with SMTP id lk16-20020a17090b33d000b0020d5edf8b92mr28455362pjb.117.1666454830473;
        Sat, 22 Oct 2022 09:07:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 189-20020a6204c6000000b00565c860bf83sm17068086pfe.150.2022.10.22.09.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 09:07:09 -0700 (PDT)
Message-ID: <7852a65b-d0eb-74dd-63f1-08df3434a06e@kernel.dk>
Date:   Sat, 22 Oct 2022 10:07:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1666346426.git.asml.silence@gmail.com>
 <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
 <20221021091404.58d244af@kernel.org>
 <99ab0cb7-45ad-c67d-66f4-6b52c5e6ac33@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <99ab0cb7-45ad-c67d-66f4-6b52c5e6ac33@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/22 9:57 AM, Pavel Begunkov wrote:
> On 10/21/22 17:14, Jakub Kicinski wrote:
>> On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
>>> We need an efficient way in io_uring to check whether a socket supports
>>> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
>>> socket flags fields.
>>>
>>> Cc: <stable@vger.kernel.org> # 6.0
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>> ? include/linux/net.h | 1 +
>>> ? net/ipv4/tcp.c????? | 1 +
>>> ? net/ipv4/udp.c????? | 1 +
>>> ? 3 files changed, 3 insertions(+)
>>>
>>> diff --git a/include/linux/net.h b/include/linux/net.h
>>> index 711c3593c3b8..18d942bbdf6e 100644
>>> --- a/include/linux/net.h
>>> +++ b/include/linux/net.h
>>> @@ -41,6 +41,7 @@ struct net;
>>> ? #define SOCK_NOSPACE??????? 2
>>> ? #define SOCK_PASSCRED??????? 3
>>> ? #define SOCK_PASSSEC??????? 4
>>> +#define SOCK_SUPPORT_ZC??????? 5
>>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>
>> Any idea on when this will make it to Linus? If within a week we can
>> probably delay:
> 
> After a chat with Jens, IIUC he can take it and send out to
> Linus early. So, sounds like a good plan

Yes, and let's retain the name for now, can always be changed if we need
to make it more granular. I'll ship this off before -rc2.

-- 
Jens Axboe
