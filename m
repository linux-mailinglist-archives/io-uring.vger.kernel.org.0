Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5C93464FA
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 17:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhCWQXH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 12:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhCWQWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 12:22:50 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17358C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 09:22:50 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id v26so18301301iox.11
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 09:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=E65N5dBdSastfupDoinU7CjcbcUwOs5GyrIfbgPRrxM=;
        b=GRrvuN20P4ql2GQRaGQREd/JeAzkv62PndfuFflouWqRrS3vPMSOWp/5qSHRcAbDPT
         VDysJznf4apQWcGRxpkTp7dnOQfs7AiaYUYIVO/8BGLh+keeSiyQILqcFU0dqf19KLvc
         u0XcimcWscUnoKqcGW2pmB/oMhafueVB2j4ZGWJYMFhFHEIrdYmqFYpvJ+bbs90kgsVA
         VUNG5gnkXf2s7uO/p3tT9w9lJcLyzxRxRp030ABJgSviaX+c0cVxsolkhPH0HVlgk4mw
         24S5GtSN7lLox11TyjkhblFmt79VOJLiXBB5byBhJfGGrxjpOayluyo8VTBViT4BUEOU
         AZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E65N5dBdSastfupDoinU7CjcbcUwOs5GyrIfbgPRrxM=;
        b=mx16uMcc+OyxtopTV/sPHjBzgOhZ78VTxx/mYHlLpZpnLe5pVp+wBimGMmwlCnStY6
         gZobhjper7IKa3Gp+kvXqVd/jicWdZnueI/6WdtHqbOVoGILfFXX7HZltahXnuL0SjWU
         44vPcay4vDgErmJySwOZdxSEd27VSsy+RJrvi3OrbTUanYHLZr/kXIidHjW+2OwykYb1
         m+AkUb/lOwAD8tvhOUDwkAGqvcgJPSdjcAUmpZccv7Cl3EemCeMrzVICfDmrzK4++sAg
         qn1a9Q4X9sNT2sei/YBsas7O1JUInd8kdtrREuGNdz2cdy1JBC5rL1GsFFu+Ess1c4bO
         nFTg==
X-Gm-Message-State: AOAM530Ja8pvs7C7IkKE3VPMXS/35fnM9eBFK7coRME/fRrB/NqCYJMt
        x+s6oXe8p4o35A9FTo5h0h+dWbw8Xbf27g==
X-Google-Smtp-Source: ABdhPJyGuegDHCUeS7bUX096u8uRgvfHfr2uZd05oLG5RNmTQ0eLUWJqYeoJBZ3j+4F1+7hY8oRXOQ==
X-Received: by 2002:a05:6638:224e:: with SMTP id m14mr5400711jas.8.1616516569499;
        Tue, 23 Mar 2021 09:22:49 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 13sm9515643ioz.40.2021.03.23.09.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:22:49 -0700 (PDT)
Subject: Re: [ANNOUNCEMENT] io_uring SQPOLL sharing changes
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Hao Xu <haoxu@linux.alibaba.com>
References: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
 <30563957-709a-73a2-7d54-58419089d61a@linux.alibaba.com>
 <1afd5237-4363-9178-917e-3132ba1b89c3@kernel.dk>
 <293e88d8-7fa5-edf4-226c-1e42dec9af67@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a6899a6-ece8-f2f8-3fbc-3adfcbf942b2@kernel.dk>
Date:   Tue, 23 Mar 2021 10:22:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <293e88d8-7fa5-edf4-226c-1e42dec9af67@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/21 10:09 PM, Joseph Qi wrote:
> 
> 
> On 3/22/21 10:49 PM, Jens Axboe wrote:
>> On 3/21/21 11:54 PM, Xiaoguang Wang wrote:
>>> hi Pavel,
>>>
>>>> Hey,
>>>>
>>>> You may have already noticed, but there will be a change how SQPOLL
>>>> is shared in 5.12. In particular, SQPOLL may be shared only by processes
>>>> belonging to the same thread group. If this condition is not fulfilled,
>>>> then it silently creates a new SQPOLL task.
>>>
>>> Thanks for your kindly reminder, currently we only share sqpoll thread
>>> in threads belonging to one same process.
>>
>> That's good to know, imho it is also the only thing that _really_ makes
>> sense to do.
>>
>> Since we're on the topic, are you actively using the percpu thread setup
>> that you sent out patches for earlier? That could still work within
>> the new scheme of having io threads, but I'd be curious to know first
>> if you guys are actually using it.
>>
> 
> Yes, we've already used percpu sqthread feature in our production
> environment, in which 16 application threads share the same sqthread,
> and it gains ~20% rt improvement compared with libaio.

Great! Any chance I can get you to re-post the patches against the
current tree?

-- 
Jens Axboe

