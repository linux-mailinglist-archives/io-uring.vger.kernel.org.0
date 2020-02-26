Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E1B17038B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 16:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgBZP6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 10:58:50 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36908 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgBZP6t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 10:58:49 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so2805875iln.4
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 07:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u9tetjlW+tDcSR4yUipSGe6x9DTuqaQhNQPPb+CDQbE=;
        b=UiNRpuEAyN8wzG92Np9jVjC506dWwHMYkjEyzKxh0jutz8V45Vq1FROghvg18dwCEB
         9oUfNe8K16yLnzBcB1t9D9mMaz+pyzc3qCo0ZHkmP2oyDY6aBKUasRX5DZQVsllhMFLG
         +ogzmF1ZCsUy0Q2RaduS5T9PR8WflpcaFPtLATuk9ewg9PWeGNH0a7WzgQGrrJABFIz5
         R9o3Xww/Qh+alNFpI/nCPt9AONcRhYW7Q7MRgDgcREfTadNP1AgFW8s1wESfX3yF2g8u
         flAyUqL3697kmQXD4dBIUS/5yUOvOVmmE8NDr67HOcm7MbUozOKsk5e/flvbQZncolfL
         BiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u9tetjlW+tDcSR4yUipSGe6x9DTuqaQhNQPPb+CDQbE=;
        b=FkM8xLfi8/mnaAV7bcTArcyxoxR/gT6oQRtY02gkixM3ueLb1BSA6xpbOxUDSdr2pv
         Go63vqI2pHqFzilUom2OafkOMXWC4reRg4IrPv7PF4hKY0yS6ck5oazqBYR19gPbgcsI
         dXNwhKCAHFPjy4vlPR+AMxpeaK6UWJ229QUnd20bB1nzoqQ1blADuC9JVA2UudjoiuW9
         5ln/NjjO0+nuetzVIN388MBHEdMfrQd2MnR9PwOUFidCk5YSM10UPAkiaakcW7cRt8/b
         eVtXeEifEQA9A0PhOJzxANnQ28YFrHO+Q7o7jp1wOsLS9J7Ysu5x9BQzSnXQhpdYydTY
         1swA==
X-Gm-Message-State: APjAAAU/jJVrumHupErabiwK2VOsAgVpEiCKaTADwLAws7SiWyzpYHY4
        ZPYCHaVVR05314b79Jq0F9Ll5MKNFnA97w==
X-Google-Smtp-Source: APXvYqxJiIOjf+VwFA5v3wJ61HRm5iIcx79nUhEJCQKxmcNVQnBbnRH4KSjEAeR6CQDwNeq7xsZTDQ==
X-Received: by 2002:a92:91c7:: with SMTP id e68mr6025346ill.161.1582732727744;
        Wed, 26 Feb 2020 07:58:47 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s69sm767693ilc.67.2020.02.26.07.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 07:58:47 -0800 (PST)
Subject: Re: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, io-uring@vger.kernel.org
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-2-bob.liu@oracle.com>
 <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
 <20200226155728.GA32543@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <af282e53-7dff-2df3-0d03-62e1bcdb0005@kernel.dk>
Date:   Wed, 26 Feb 2020 08:58:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226155728.GA32543@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/20 8:57 AM, Christoph Hellwig wrote:
> On Wed, Feb 26, 2020 at 07:24:06AM -0700, Jens Axboe wrote:
>> On 2/26/20 1:37 AM, Bob Liu wrote:
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index a3300e1..98fa3f1 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -62,6 +62,8 @@ enum {
>>>  	IORING_OP_NOP,
>>>  	IORING_OP_READV,
>>>  	IORING_OP_WRITEV,
>>> +	IORING_OP_READV_PI,
>>> +	IORING_OP_WRITEV_PI,
>>>  	IORING_OP_FSYNC,
>>>  	IORING_OP_READ_FIXED,
>>>  	IORING_OP_WRITE_FIXED,
>>
>> So this one renumbers everything past IORING_OP_WRITEV, breaking the
>> ABI in a very bad way. I'm guessing that was entirely unintentional?
>> Any new command must go at the end of the list.
>>
>> You're also not updating io_op_defs[] with the two new commands,
>> which means it won't compile at all. I'm guessing you tested this on
>> an older version of the kernel which didn't have io_op_defs[]?
> 
> And the real question is why we need ops insted of just a flag and
> using previously reserved fields for the PI pointer.

Yeah, should probably be a RWF_ flag instead, and a 64-bit SQE field
for the PI data. The 'last iovec is PI' is kind of icky.

-- 
Jens Axboe

