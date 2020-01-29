Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B990A14CFB6
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgA2Rex (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 12:34:53 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36050 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgA2Rex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 12:34:53 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so658001iog.3
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 09:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RS1DFDQ3cicni2o9rbOFyYFhBMpwVecCUQEDSVkoDwg=;
        b=f3wAys+WveYuFDBxnAPHAHpU6yYCRD4crMfzi2H1heoOVSNTZo5MUA3PgcN5o0aoJ6
         MRG+Bd+x+zAZZeyAKKtCQGWNJy/LaOB8Ege5mS373yLkbmx6YNvtFAAiAeyUm1xzzv7T
         zy9WPKvjs+7o+zNYo8YKvCP6TuctWHCSeqbJvOmQfzG2WpWLWs1nwF6gcxk0gzmr/WMm
         TF54t7wVGNWthPmNRqqJtDga9w8L5u0CD7SY39n0KWenEnUGYpWlbsmbTRCNP0N6gLb7
         0N+Ikhll+2No3aSeGNGRfruLWBDvXME9QuJxUfNHpQ49kmhIvCWVO5462SadAIgQj7yr
         V9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RS1DFDQ3cicni2o9rbOFyYFhBMpwVecCUQEDSVkoDwg=;
        b=ijSVTTPMW5cNi6ebgfYV/clmKl1vKRQ2Flqxz1OEtFdulULQPvQFhZqaMxmNtReQ/F
         34cuhhnS/M4271Fuxceob13yK2N1kGGeAO6VlN7k0TMJmqW4s/BzWYpSiaVvl1BrHKDb
         AoXCEOxnJud4EQ8TFVzW3dxs+9Rp1zYdh56jOAIU/3qMXuipFrmZfJcWr/vd0JsWp1nr
         4ilf/9o3ckOaL9BswKW/CpK2InKkvoLUtJIbPURbpJDrpAhxSRK9oOcVVfiiVCh3ttXS
         oQvuritZAUvc951hDdJDLA3XNFv2DO5mery44BvlnRBb5nT3JsmB2yLlvge3vX4kXH7C
         VLoA==
X-Gm-Message-State: APjAAAWZwC/NXzgYJf+8SVcYJbASyX5SagGnzOUMONEwkdM8iL6QEO2b
        BeOY+g1qFt91Ng52ZAX+rX3xYw==
X-Google-Smtp-Source: APXvYqxzixmSYzM5AMy5FUquH2PzF1xx6EoouZ4y4a8of7fuVzOIvl8Yf8q86KED86KX0TqWtTFzAg==
X-Received: by 2002:a05:6638:618:: with SMTP id g24mr174277jar.87.1580319292373;
        Wed, 29 Jan 2020 09:34:52 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c3sm686078ioc.63.2020.01.29.09.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 09:34:51 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Jann Horn <jannh@google.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
Date:   Wed, 29 Jan 2020 10:34:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 7:59 AM, Jann Horn wrote:
> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
> [...]
>>>> #1 adds support for registering the personality of the invoking task,
>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>> just having one link, it doesn't support a chain of them.
> [...]
>> I didn't like it becoming a bit too complicated, both in terms of
>> implementation and use. And the fact that we'd have to jump through
>> hoops to make this work for a full chain.
>>
>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>> This makes it way easier to use. Same branch:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>
>> I'd feel much better with this variant for 5.6.
> 
> Some general feedback from an inspectability/debuggability perspective:
> 
> At some point, it might be nice if you could add a .show_fdinfo
> handler to the io_uring_fops that makes it possible to get a rough
> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
> helpful for debugging to be able to see information about the fixed
> files and buffers that have been registered. Same for the
> personalities; that information might also be useful when someone is
> trying to figure out what privileges a running process actually has.

Agree, that would be a very useful addition. I'll take a look at it.

-- 
Jens Axboe

