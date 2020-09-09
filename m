Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E542631A5
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgIIQWZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 12:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730469AbgIIQWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 12:22:20 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823CCC0612ED
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 07:24:50 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z25so3292394iol.10
        for <io-uring@vger.kernel.org>; Wed, 09 Sep 2020 07:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J42uWZO91Vl6z53QuSqgDQ5nEZPu3ErBMsf2V3eJXao=;
        b=vwgyAFNFY0Rk6tGpJrQKkFa2XORu9tkWL3MOvEnxMWQSsbJhAjs0wQkh45yfbxgWty
         P4LutOppwndoh6fYhlpY/FnHJ7s6roKt4SmQ4ZpkvlcGIxjeXF2o2A/OxCF6LlScMtNO
         sd1g73r4KiQVkYw0cr9Uby1XQGWuAPxYLmrDOkiYBuC6w2Lor4MVkXLDdEJOmCpTmfNV
         OooUgHeq067qTX1T/mzo/jYDU8gFVMGTX7A+wovVWcHT9Cn1BOV0cJ5c90cqkK04z5zV
         FQRf3f1tWU3m+KnOqKecj1nxHPOb0476pqidIdfBKhmVP8zKJt2dC5dXnsGG8kbtXB49
         uuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J42uWZO91Vl6z53QuSqgDQ5nEZPu3ErBMsf2V3eJXao=;
        b=e26Ve5JGXg5sMxx9MiFKR2zBQe41h7sU+onmGoTAlD79FGHxZXi3WvxfTootceqYFT
         1gDfOSE+/w82fgScr7397tpYvRydY6li5lQyfa5U5fhL+KDlACVvv1YpkeRljRddxq6G
         g42xQrGSd8FDKvDbnZx++7ChpdLpfgdO2I8zvC0JyGJI4eY66FSwzvnDmZ0ByprhPYIO
         3ZCs1XL/CFGI2PMudOzKifMrXcQ1ETxqx0WGZkrF8mHlmioTdLgzs8kkBvqRcxVB2dZ9
         oApq8rgtFVha0fmn8duCOklsNs2CGCQwEkz1UN19dQcvS+yJaOrAjlG0U3qynP7vfEpw
         ZeAA==
X-Gm-Message-State: AOAM533Iko7lPIpblPiYkWDoDhHdXs5ylikm5Tgh/o2Iax49oWE5mjeD
        vkYfg1ZSoxaoDz8PJ1uiTgF8DA==
X-Google-Smtp-Source: ABdhPJzw71ClM3e9xwflgpNGkqys4GZLnoSdxzDPCJW81NzzXlaCm+tbHvqOkGBBc4MqR9ZnkKGG6w==
X-Received: by 2002:a02:1142:: with SMTP id 63mr4314795jaf.73.1599661486949;
        Wed, 09 Sep 2020 07:24:46 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 2sm1457722ilj.24.2020.09.09.07.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 07:24:46 -0700 (PDT)
Subject: Re: [PATCH next] io_uring: fix task hung in io_uring_setup
To:     Hillf Danton <hdanton@sina.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>
References: <20200903132119.14564-1-hdanton@sina.com>
 <9bef23b1-6791-6601-4368-93de53212b22@kernel.dk>
 <8031fbe7-9e69-4a79-3b42-55b2a1a690e3@gmail.com>
 <20200908000339.2260-1-hdanton@sina.com>
 <20200909001943.18916-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e04aea6a-4049-da2e-e8e8-9025aa03268b@kernel.dk>
Date:   Wed, 9 Sep 2020 08:24:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909001943.18916-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 6:19 PM, Hillf Danton wrote:
> 
> On Tue, 8 Sep 2020 17:34:26 -0600 Jens Axboe wrote:
>> On 9/7/20 6:03 PM, Hillf Danton wrote:
>>> On Mon, 7 Sep 2020 06:55:04 Jens Axboe wrote:
>>>> On 9/7/20 2:50 AM, Pavel Begunkov wrote:
>>>>>
>>>>> BTW, I don't see the patch itself, and it's neither in io_uring, block
>>>>> nor fs mailing lists. Hillf, could you please CC proper lists next time?
>>>
>>> Yes, I can. So will I send io_uring patches with Pavel Cced.
>>
>> While that is nice, it should not be necessary. We need to ensure that your
>> emails reach the list, that's more important than needing to CC a specific
>> person, because it still means that everyone else doesn't see it.
>>
>> Do you get an error from vger, or does it simply not show up?
> 
> After tapping the send button for this message, I will receive a message
> from the sina mail server saying it failed to deliver it to one of the
> targets (abc@vger.kernel.org), which has been happing over the past a
> couple of years. One of the redhat guys, I can't remmenber his name,
> once tryied to help me solve the problem, by sending somebody@vger a
> message explaining what was going on, but failed. AFAIC there's a
> glitch in exchanging info between the sina server and the server at the
> vger end, and it seems it would take more time than thought to figure
> it out. So let it be for now.

Might be worthwhile to just have a gmail account for sending patches
and replying to list emails?

-- 
Jens Axboe

