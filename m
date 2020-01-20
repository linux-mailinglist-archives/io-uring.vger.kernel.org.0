Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49CD142B77
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2020 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgATNEs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jan 2020 08:04:48 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:44650 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNEs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jan 2020 08:04:48 -0500
Received: by mail-lf1-f48.google.com with SMTP id v201so23982446lfa.11;
        Mon, 20 Jan 2020 05:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uIDh6673+36Mkl2ZvEw5xAC4bzmHdxN5e8zYJYWTzbs=;
        b=jPEoGq4nYojIAgVyPNmZxMeMDEhxW3IZXP2gd361txL8qpwK4SgihzYhK/7/wgvabX
         XftxodJlGYWrbE7BvxsJMDy2ETMfzgtnOUHLH2IRLEqNy1DkdK4svYENw+p8xHcSDzkY
         j51bN0cQ3l8oBuz1ZneBLH3iCSll82DdNdzxhbCZ8DajuztfuZro4bxEZc2ss87li6g8
         0UY/+lmXTJMKCFZvPnTtgn6XjphyxXnArSa4C3HhcwG0b4QJO/vPSb0R1CxuG8TKOabc
         E5OEpDYWmO/Cl05UWMJSFC+TQl0EVmJe72XabgMN52gDOncjcMR0rsj4qmvyVZU+P012
         SaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uIDh6673+36Mkl2ZvEw5xAC4bzmHdxN5e8zYJYWTzbs=;
        b=JLytokWsjKajAj2mvaGRTfsCKXT4kpQzOHs/aWE178bKAL/ALzINbihMw6eqDbqwd1
         K49H1L4Z/EmYWt8apQ1bVKaqaSXq17VcLYDGzjqRroNx05wRWQ/PGaffEdirwjamhhM+
         Nl6M0KjV/T2OWO/uCSEjtBjTiZUPAKI2IvSJewabV/McWBtTosaTJtIJN6beOVrso0w6
         yuxK7eREfyKdKAknzDrBSNftIG8qCAH0KvmRiYh1KQS5dRm429mxSgut+o9bvgITEXQA
         KA7Md/9P8nPcm8KmfiVLMPKrZ0ZBGi2VGeS5d0CKa65PztCZTVDS7E1dOIPCCFSh8sbS
         8G5g==
X-Gm-Message-State: APjAAAXGoKgR5mr0YbBm6OXCUcvuSVAcA9wHKsuTRp7pau1aSFbmIDhG
        NAywadNTFWzW5SE5zBb3KlA=
X-Google-Smtp-Source: APXvYqzFcIFzaEGo+wir8nSnvFOnz1W7nJsaZmNG4xQLmGT26eGdig80DhljY5xF1nECTgan8nQVmw==
X-Received: by 2002:ac2:5ec3:: with SMTP id d3mr13751765lfq.176.1579525486492;
        Mon, 20 Jan 2020 05:04:46 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id t7sm5562049ljo.7.2020.01.20.05.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 05:04:45 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
 <7324bbb7-8f7b-c0c6-6a45-48b8b77c4be8@kernel.dk>
 <da05b8e8-4ef4-7527-36d5-511a192460f0@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2fae1d5a-4dad-6435-04e9-e544c6c17f27@gmail.com>
Date:   Mon, 20 Jan 2020 16:04:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <da05b8e8-4ef4-7527-36d5-511a192460f0@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/20/2020 3:15 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>> Thanks!
>>>
>>> Another great feature would the possibility to make use of the
>>> generated fd in the following request.
>>>
>>> This is a feature that's also available in the SMB3 protocol
>>> called compound related requests.
>>>
>>> The client can compound a chain with open, getinfo, read, close
>>> getinfo, read and close get an file handle of -1 and implicitly
>>> get the fd generated/used in the previous request.
>>
>> Right, the "plan" there is to utilize BPF to make this programmable.
>> We really need something more expressive to be able to pass information
>> between SQEs that are linked, or even to decide which link to run
>> depending on the outcome of the parent.
>>
>> There's a lot of potential there!
> 
> I guess so, but I don't yet understand how BPF works in real life.
> 
> Is it possible to do that as normal user without special privileges?
> 
> My naive way would be using some flags and get res and pass fd by reference.
> 
Just have been discussing related stuff. See the link if curious
https://github.com/axboe/liburing/issues/58

To summarise, there won't be enough flags to cover all use-cases and it
will slow down the common path. There should be something with
zero-overhead if the feature is not used, and that's not the case with
flags. That's why it'd be great to have a custom eBPF program
(in-kernel) controlling what and how to do next.

I don't much about eBPF internals, but probably we will be able to
attach an eBPF program to io_uring instance. Though, not sure whether it
could be done without privileges.

-- 
Pavel Begunkov
