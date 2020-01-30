Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86614DF25
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 17:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgA3QbT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 11:31:19 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37573 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgA3QbT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 11:31:19 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so1918834pga.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 08:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kuybWa2NxUo8zxn1hgTzkhvYLFzeOQAuCN6ptTs++Ag=;
        b=KTU6Kr0JCG+HFsBgiVpxIEp4a05qg3ydknSpeepyifCE32IqHJ4YMJmas1RCQLgRL8
         jp3mYe9kLIdOVWqWpHxoRJMgKcsmPbTFUryw/CmEpYz7r2K7LjD8Ir8iJsmUs/V/V1vR
         f4FMApCCkuTu8kWrfirBRSWRb0bwzK6h25KXWwhS71XHJmpzrGSmXKqabybVlJLFP7T1
         dTD2P0XzGbfXcoVXeu7PfzIBSl7fPM6VTXQyTdicAUYuQeAyTDoQZ5XY/xknDOCpX+O+
         mHCA4ul8PLdOOnhbYKabcVkLwQF7AgelNI0CGbhNB7r/ccSM285qjpdG+OucCkAudDSm
         iCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kuybWa2NxUo8zxn1hgTzkhvYLFzeOQAuCN6ptTs++Ag=;
        b=kLz+Hqc8xTRpketVlkgBeBwJ+Gi4O+7Q+NLnvZ2kFXdMm8LDs2RvobTyBxT00dlGJP
         m6IBvU/v57L5ZIfT6zwIuR2wIopeC5u/d77ztKbGzIOPKGbquxN2MugsBIXpbu939hKU
         qlX6Ivr1gbWrcDtxnh4gx8Yc0J5GJ1WLR7e4s5+Pyhtyy1SP+RT/Fpt32cmKoVezT7qB
         BS3GxcoxyzNkzL0mnUAEnxClV+YWCi2mJ/Vfyu4Zi55VMLLxJDfEpJFXnDYUrymHHa7F
         nV8Yhoxwhp2Wvz9WUOBJSdAb6VImR7qKTOofZ0+7Fjp3dRAtSVOuKqp5C6DzfsvscOc5
         M40Q==
X-Gm-Message-State: APjAAAU1UNJeltxREM+msu3aQmm6NPWdiNu5rzNAqQC4pHJQtKsxtLkt
        zYyq9UQ48U2yCbKMX/peV8WoqIyPgMc=
X-Google-Smtp-Source: APXvYqyJwqMUiOkfko8eqYFLAts5IpORngbJV3b2JSlKw7WBxGYrywsVS8WUgVHSSIRlxwUnjoPOQg==
X-Received: by 2002:a63:4287:: with SMTP id p129mr5467157pga.122.1580401877517;
        Thu, 30 Jan 2020 08:31:17 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1132::1035? ([2620:10d:c090:180::90b5])
        by smtp.gmail.com with ESMTPSA id z26sm7389035pfa.90.2020.01.30.08.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 08:31:17 -0800 (PST)
Subject: Re: [PATCH v2 liburing] add helper functions to verify io_uring
 functionality
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <20200130160013.21315-1-glauber@scylladb.com>
 <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
 <CAD-J=zZURZV46Tzx4fC4EteD4ejL=axKaw-CjtyFmYhCYzKEdg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3338257d-009d-1db0-c77a-2bf06e5518f2@kernel.dk>
Date:   Thu, 30 Jan 2020 09:31:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zZURZV46Tzx4fC4EteD4ejL=axKaw-CjtyFmYhCYzKEdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/20 9:29 AM, Glauber Costa wrote:
> On Thu, Jan 30, 2020 at 11:13 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/30/20 9:00 AM, Glauber Costa wrote:
>>> It is common for an application using an ever-evolving interface to want
>>> to inquire about the presence of certain functionality it plans to use.
>>>
>>> Information about opcodes is stored in a io_uring_probe structure. There
>>> is usually some boilerplate involved in initializing one, and then using
>>> it to check if it is enabled.
>>>
>>> This patch adds two new helper functions: one that returns a pointer to
>>> a io_uring_probe (or null if it probe is not available), and another one
>>> that given a probe checks if the opcode is supported.
>>
>> This looks good, I committed it with minor changes.
>>
>> On top of this, we should have a helper that doesn't need a ring. So
>> basically one that just sets up a ring, calls io_uring_get_probe(),
>> then tears down the ring.
>>
> I'd be happy to follow up with that.
> 
> Just to be sure, the information returned by probe should be able to outlive the
> tear down of the ring, right ?

Yeah, same lifetime as the helper you have now, caller must free it once
done.

-- 
Jens Axboe

