Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646AD781F49
	for <lists+io-uring@lfdr.de>; Sun, 20 Aug 2023 20:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjHTSlx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Aug 2023 14:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjHTSlw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Aug 2023 14:41:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E88D2
        for <io-uring@vger.kernel.org>; Sun, 20 Aug 2023 11:40:50 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7748ca56133so30857639f.0
        for <io-uring@vger.kernel.org>; Sun, 20 Aug 2023 11:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692556850; x=1693161650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MjT7CZ9fGkNj69bOFC/CnWrq6Xp6pxnXfkJZHf8DBSs=;
        b=a5pm7KT6zLU4VeeEFM9MVlxYrTt3LT78BY7QcOLtXO93FGh24Xato+W/Kw2ZIM53Wo
         9OQGGVQKMeVXNtSafeKVEwWDBxp8fwiJaUKtEgibR1/+1IBcznJJ4bmfz5JRbAH0IDwm
         EvnrGAJQWJaxCkQixatYyle1LxGhwjDsvApzzYhQJl1V0tkZSdQlkaEsrxeZ5E2aN4nE
         TdFVzMyFd7I6b9vBmw/bUu7pRLqEdGVAgfL6JmvBNURYgmxputhm6bMYA8xY56QulLq8
         DJA+IioRi08WwqqlN8RD+ruQQmSw79r+oag95q7yce/gKOGkcmrvMupaMoD9vjTZLS5o
         NXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692556850; x=1693161650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MjT7CZ9fGkNj69bOFC/CnWrq6Xp6pxnXfkJZHf8DBSs=;
        b=ezmnbx6kbkz6dBScTmzf4nHglInNxv1ZnAhHq9uYfpyxBVbUlEUb2Ukyq/sYje3pPR
         i4po9/g6B6KfiVT8bVHu6k1nxAwSX+VIlotQyHqaosMUqrvhHCZvxgKH1xsSWiCVv5wY
         8/5/yxfVNl5ethYceCnC9mwP//UUSF1dowVwc2gcOT04hTRdsfvTRtLu4E4lYdUolGMB
         xBBFz7SwrqfJ6W+LZL+VqDJ3WqSodGy5U8pciox3u2qczzvYaPR/qSoK7Q1ATVGqID2C
         ptim0Z1ZV52o/7JdeNto2hcLiN4+EV0x8TLVgJ6+fwvMaH3sp8+vbZd6vgHyDCu0lGaP
         cUvw==
X-Gm-Message-State: AOJu0YylO5ykLg7WQZvTgWuoKDGofcmRTPp0cRP9dZ2XZbVTjEYppEc6
        6PjlT+G8QLyHzbqSHal8yEGOyQ==
X-Google-Smtp-Source: AGHT+IH5jeI8aXPGcO2sMI6RMmO1M2OwKV+n8kY0pSHEzPp7TXm1eZE5rO0JOZU/pKNuDY5HgsO2TQ==
X-Received: by 2002:a05:6e02:110:b0:349:582c:a68d with SMTP id t16-20020a056e02011000b00349582ca68dmr4438394ilm.3.1692556850060;
        Sun, 20 Aug 2023 11:40:50 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s75-20020a63774e000000b0056416526a5csm5016883pgc.59.2023.08.20.11.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Aug 2023 11:40:49 -0700 (PDT)
Message-ID: <91d99ef5-bc01-45d4-83f3-d5e9a5447fb8@kernel.dk>
Date:   Sun, 20 Aug 2023 12:40:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
 <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
 <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
 <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
 <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
 <b60cf9c7-b26d-4871-a3c9-08e030b68df4@kernel.dk>
 <1726ad73-fabb-4c93-8e8c-6d2aab9a0bb0@gmx.com>
 <7526b413-6052-4c2d-9e5b-7d0e4abee1b7@gmx.com>
 <8efc73c1-3fdc-4fc3-9906-0129ff386f20@kernel.dk>
 <22e28af8-b11b-4d0f-954b-8f5504f8d9e4@kernel.dk>
 <ZOJZE3YvBjYQl000@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZOJZE3YvBjYQl000@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/23 12:18 PM, Matthew Wilcox wrote:
> On Sun, Aug 20, 2023 at 08:11:04AM -0600, Jens Axboe wrote:
>> +static int io_get_single_event(struct io_event *event)
>> +{
>> +	int ret;
>> +
>> +	do {
>> +		/*
>> +		 * We can get -EINTR if competing with io_uring using signal
>> +		 * based notifications. For that case, just retry the wait.
>> +		 */
>> +		ret = io_getevents(io_ctx, 1, 1, event, NULL);
>> +		if (ret != -EINTR)
>> +			break;
>> +	} while (1);
>> +
>> +	return ret;
>> +}
> 
> Is there a reason to prefer this style over:
> 
> 	do {
> 		ret = io_getevents(io_ctx, 1, 1, event, NULL);
> 	} while (ret == -1 && errno == EINTR);
> 
> (we need to check errno, here, right?  Or is io_getevents() special
> somehow?)

Honestly, don't really care about the style, mostly cared about getting
a bug fixed. io_getevents() returns number of events claimed, or -errno.

-- 
Jens Axboe

