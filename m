Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC292B851F
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgKRTxq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 14:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRTxq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 14:53:46 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF300C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 11:53:45 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id o15so3406802wru.6
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 11:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QOXYemEzUXMisHOli6RSEubsGj0T9iv6R/wZwTBIK1A=;
        b=OnNc4uY0zyvYPAMZyCrjCwdIzuzeD+6usdgYHsX8tUMFHuKZ19MMM7Q58h4vZpPC3B
         dJTRZPJ0zzGM5AmK4UdOkklqK6BiIdGUVyCTk1PtmSuDr/OPAVVqHphETiBneUYtk6Xt
         PlQPy3LXokU45+x/X8xRN0lkdS3v1ytLCUfTLaLV4ZPrJ7k4BwNeekUPeDHfAGKUYS/b
         vc7WCwxV8vzsZQahgg/MkMp3qEZHeitV6+muXaGf6G+dxP2TkKBDFI8Agutb4rpl8+hm
         qVGiFOmgCmMksAwLz9yjASOoToKYRFwwzpxhy42f4WLvZKZDT2ej0cG2HtU15e6LYoAr
         sWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QOXYemEzUXMisHOli6RSEubsGj0T9iv6R/wZwTBIK1A=;
        b=JAVszl1L/kA1mvI4wxZTrwEuALmcQGFIP6WjV/v66cow/4MINCnyAMnE27E4N7gh99
         4JL8Y9PYDRKiDV85YHJn3MM1zubaAsUTq4/AQoAQa9T/O1VEi+TbpVkxF1xX8nYA0s1o
         x+8wuuMjC8w4D+1kNKTQ3x11IlzOkaEcpx/n8HeIVK7Xu5H2On/ZT87wgekPwLkqB47O
         eD1QJGXejtyh7YRisXXDdmEeM9p1WUTOdhWOjM00f+pPovQ6pfpEnmCVHsttHJORA+KK
         X7mjPS8epSm219KJKubz70zbYShfuFf5Bp8GHHyfQ3WR8lOqhNLyVdGMKtmPqew4Cmta
         ueRw==
X-Gm-Message-State: AOAM530e8N9kLGduq7Wvn+XP0vW3l6JIreq6tJooVca+I5fqwEiVxcNh
        eXzTUpHyci//82uRdEm8iFWO8KR4kYzsIA==
X-Google-Smtp-Source: ABdhPJxtTH+y9hVz9grcgjm9UWROhTtf132/EMmrFGS7z8f1du2yg0lie6iSF90Kh+d9EXCzc0N9yA==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr6927504wrv.371.1605729224280;
        Wed, 18 Nov 2020 11:53:44 -0800 (PST)
Received: from [192.168.1.144] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id d3sm37721070wrg.16.2020.11.18.11.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 11:53:43 -0800 (PST)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
 <80e87448-4a33-99cf-28ca-25f185c83943@samba.org>
 <578923eb-0219-ffec-7c45-e44d15372d41@gmail.com>
 <0ed8c305-66b6-7176-490f-0530fa7fa2cb@gmail.com>
 <085ba259-0910-bd3e-9136-c2efb69c5971@samba.org>
 <2ce56c6d-8d0b-7ab5-1b39-05956b6a2008@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11] io_uring: don't take fs for recvmsg/sendmsg
Message-ID: <67ad9045-9f9b-07ed-738c-60db5e1f01fb@gmail.com>
Date:   Wed, 18 Nov 2020 19:50:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2ce56c6d-8d0b-7ab5-1b39-05956b6a2008@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/11/2020 16:57, Stefan Metzmacher wrote:
> Am 18.11.20 um 17:27 schrieb Stefan Metzmacher:
>> Am 07.11.20 um 17:07 schrieb Pavel Begunkov:
>>> On 07/11/2020 16:02, Pavel Begunkov wrote:
>>>> On 07/11/2020 13:46, Stefan Metzmacher wrote:
>>>>> Hi Pavel,
>>>>>
>>>>>> We don't even allow not plain data msg_control, which is disallowed in __sys_{send,revb}msg_sock().
>>>>>
>>>>> Can't we better remove these checks and allow msg_control?
>>>>> For me it's a limitation that I would like to be removed.
>>>>
>>>> We can grab fs only in specific situations as you mentioned, by e.g.
>>>> adding a switch(opcode) in io_prep_async_work(), but that's the easy
>>>> part. All msg_control should be dealt one by one as they do different
>>>> things. And it's not the fact that they ever require fs.
>>>
>>> BTW, Jens mentioned that there is a queued patch that allows plain
>>> data msg_control. Are those not enough?
>>
>> You mean the PROTO_CMSG_DATA_ONLY check?
>>
>> It's not perfect, but better than nothing for a start.
> 
> What actually have in mind for my smbdirect socket driver [1]:
> 
> - I have a pipe that got filled by IORING_OP_SPLICE
> - The data in the pipe need to be "spliced" into a remote RDMA buffers,
>   but I can't use IORING_OP_SPLICE again, because the RDMA buffer descriptor [2]
>   array needs to be passed too.
> - I'd like to use IORING_OP_SENDMSG with MSG_OOB and msg_control.
>   msg_control would get the RDMA buffer descriptor array and the pipe fd.

If I get you right, you can't splice again because there is an RDMA header
that should go before payload data. Is that correct?

So you would need to do like in the pseudo-code below

payload = pipe.get_buffers();
iov[] = {&header, payload};
sendmsg(iov);

> The reverse operation (splicing data from remote RDMA buffers into a pipe)
> would be implemented with IORING_OP_RECVMSG with MSG_OOB and msg_control.
> 
> I guess my smbdirect socket driver would not qualify to be marked as PROTO_CMSG_DATA_ONLY, correct?
> 
> [1] https://git.samba.org/?p=metze/linux/smbdirect.git;a=blob;f=smbdirect_socket.c;h=a738854462b198e#l2076
> [2] https://docs.microsoft.com/ru-ru/openspecs/windows_protocols/ms-smbd/bee890cb-48f0-42a3-ba62-f1a3a19b0edc

-- 
Pavel Begunkov
