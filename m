Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06C17359D7
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 16:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjFSOkk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 10:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjFSOkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 10:40:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9951AA
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 07:40:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-260a1ca3c8aso107949a91.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 07:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687185638; x=1689777638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E717NoDajKlhXpc/3sjbiIY54h7sD3Co46li00pfyIs=;
        b=01hMRbDpHV/De6iTam0gTqSwAnIQ3gdfXQFkzaCOeAvSNRoMipULJ9RXAQztCaSuJJ
         0qmwDRpNXn5UYWkYMQsHfxPPZRROvsDYsD1gdLHJxx9Ij9aylQoAyN4SOjhgaMua34/P
         zXVmgCyoofm9Z2cwO2EjBPfCr3xh78clRqGB3BoxEoQaQBIWtdZ2t4lIWbyNhxOex9TS
         sKwcQ7xoOEoQ9DAYXySMo1cMIor9mOo7x7u8hOZrJFglxTePM652a1kbIThPDZJP4Ei9
         78CjakBXYv5RlvZGxmECEfKIg9FhC/bOSXmHSiY7VPcFEgUo8kxit3X3zkgmTP9C+OAl
         gkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687185638; x=1689777638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E717NoDajKlhXpc/3sjbiIY54h7sD3Co46li00pfyIs=;
        b=luwu8On61Nj+S3NDT3MhCYta7PZKe309QAP3QUWZCnMoyz0cA4SI4/jZ+gfffTZPqR
         OXGbgmqKj14bkrP3765NOnkaKqzMG8YQdyjeDbK0zpaLdc26Q04SpjKx5pb6vwa+bLpK
         YQMDyekiNF7KAHwpbuVBbsWevFhUDEVmkOZkDq2DstAY1HzLfQmn73+8AraffLoV4RgS
         Fj6Gyvm4mra5YRD9n0gAJj66/sKvgcRdARtTtwT5s39kaS2rDef0lXCLrhHbQklO7CSL
         Wxd3RCRmNTQlZ5SZ9Nbj/UlaOh23awjouuirrfIME5PLfUZOrBrm4mRaMKr6v27shcYT
         aSLA==
X-Gm-Message-State: AC+VfDyqk6X+AYn8lFNbPQT0UtoJpsDUE841/Vp/1B9PitfSbiHXDpXQ
        5UT8r2HddmPNaaoRnWLNgjBk9jknPF/Ssb9y9ak=
X-Google-Smtp-Source: ACHHUZ6Nph0HBQU8SvB9HXg/v+u9xNiHfsjeeO+FuJYoLl+/iaaXA8RyJdcjYrqg1uJcJ6fIws7WPw==
X-Received: by 2002:a17:90b:4d85:b0:25b:88bc:bb6b with SMTP id oj5-20020a17090b4d8500b0025b88bcbb6bmr12440093pjb.2.1687185638210;
        Mon, 19 Jun 2023 07:40:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027d8d00b001b55de8f35esm2682496plm.213.2023.06.19.07.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 07:40:37 -0700 (PDT)
Message-ID: <3c5593c9-5919-4c3f-e321-471d378993cf@kernel.dk>
Date:   Mon, 19 Jun 2023 08:40:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: save msghdr->msg_control for retries
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
 <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
 <d98ebddb-89b9-e0d2-8390-69a3ab53b985@kernel.dk>
 <10d83431-656f-a70a-de4a-efe32af0d324@samba.org>
 <ead9cb99-1143-c3f3-bd7a-6d376ff7a802@samba.org>
 <02ce6357-f28a-56d7-9c22-ffc1dc14f73d@kernel.dk>
 <a0be6879-6b8c-ef4e-4416-29dd6a6f03a9@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a0be6879-6b8c-ef4e-4416-29dd6a6f03a9@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/23 8:40 AM, Stefan Metzmacher wrote:
> Am 19.06.23 um 16:38 schrieb Jens Axboe:
>> On 6/19/23 7:27?AM, Stefan Metzmacher wrote:
>>> Am 19.06.23 um 15:09 schrieb Stefan Metzmacher:
>>>> Am 19.06.23 um 15:05 schrieb Jens Axboe:
>>>>> On 6/19/23 3:57?AM, Stefan Metzmacher wrote:
>>>>>> Hi Jens,
>>>>>>
>>>>>>> If the application sets ->msg_control and we have to later retry this
>>>>>>> command, or if it got queued with IOSQE_ASYNC to begin with, then we
>>>>>>> need to retain the original msg_control value. This is due to the net
>>>>>>> stack overwriting this field with an in-kernel pointer, to copy it
>>>>>>> in. Hitting that path for the second time will now fail the copy from
>>>>>>> user, as it's attempting to copy from a non-user address.
>>>>>>
>>>>>> I'm not 100% sure about the impact of this change.
>>>>>>
>>>>>> But I think the logic we need is that only the
>>>>>> first __sys_sendmsg_sock() that returns > 0 should
>>>>>> see msg_control. A retry because of MSG_WAITALL should
>>>>>> clear msg_control[len] for a follow up __sys_sendmsg_sock().
>>>>>> And I fear the patch below would not clear it...
>>>>>>
>>>>>> Otherwise the receiver/socket-layer will get the same msg_control twice,
>>>>>> which is unexpected.
>>>>>
>>>>> Yes agree, if we do transfer some (but not all) data and WAITALL is set,
>>>>> it should get cleared. I'll post a patch for that.
>>>>
>>>> Thanks!
>>>>
>>>>> Note that it was also broken before, just differently broken. The most
>>>>> likely outcome here was a full retry and now getting -EFAULT.
>>>>
>>>> Yes, I can see that it was broken before...
>>>
>>> I haven't checked myself, but I'm wondering about the recvmsg case,
>>> I guess we would need to advance the msg_control buffer after each
>>> iteration, in order to avoid overwritting the already received messages
>>> on retry.
>>>
>>> This all gets complicated with things like MSG_CTRUNC.
>>>
>>> I guess it's too late to reject MSG_WAITALL together with msg_control
>>> for io_recvmsg() because of compat reasons,
>>> but as MSG_WAITALL is also processed in the socket layer, we could keep it
>>> simple for now and skip the this retry logic:
>>>
>>>          if (flags & MSG_WAITALL)
>>>                  min_ret = iov_iter_count(&kmsg->msg.msg_iter);
>>>
>>> This might become something similar to this,
>>> but likely more complex, as would need to record kmsg->controllen == 0
>>> condition already in io_recvmsg_prep:
>>>
>>>          if (flags & MSG_WAITALL && kmsg->controllen == 0)
>>>                  min_ret = iov_iter_count(&kmsg->msg.msg_iter);
>>
>> Yep agree, I think this is the best way - ensure that once we transfer
>> data with cmsg, it's a one-shot kind of deal.
>>
>> Do you want to cut a patch for that one?
> 
> No, sorry I'm busy with other stuff and not able to to do any testing...

OK that's fine, I'll post both.

-- 
Jens Axboe


