Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355C77359CE
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 16:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjFSOiv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 10:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjFSOiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 10:38:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A29A0
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 07:38:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-54f85f968a0so235658a12.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 07:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687185529; x=1689777529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TDQ/RHHDeTqyl38Zf0nLlV3b+33n9Qij8Ere1X3x75o=;
        b=mY96+WFnY/YW6/6SwDsCeAu1U8VMs7Yix3Ih/PMH548Q6l88NP2IM73kAyD9j3YZ6b
         Ckk9UmOzsclXv8k8efAjYqYZZzBXO6gPcxO9bJeyKN6CpP6PFacF7peNDsYnow4FwSmD
         Ey1eC7pUGsjKu17AcJFageO6LNIjeXYgdhzy/h4QCg6YbUFebz1rtNusP4JRF77kY8pL
         kRtMUjX7r/pusI9oDD0QMQZMLm3RdlEZb+5VMs3P8rOQCd9Bk+fol1nFlrjhFY6LAvQP
         8ruzNg+3p6DYRxUHHFKgFnniJyx6FO4YEW/Tw1cJdrLiaCk5WUD9exIlJBRCkQlNsfLi
         tIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687185529; x=1689777529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDQ/RHHDeTqyl38Zf0nLlV3b+33n9Qij8Ere1X3x75o=;
        b=RyYaEbsjo9IUlkxY2yNY0AJOUwoT3mx1dF/k3z5YmFo7gtW/IYsyy5xJFiPBrlz8I6
         /iMttGdfOuHdGoAEVZ5LtJTnG8X+B4KzntU+HK1atrMT95EgOGd0LVVopPA9nbni4GOa
         cYJXlXF2dtU7oPglTtZaXZ/4zYmVlVVZ5nn8tp+5HsQ2iEjEoYS+a+KGvvOmdG/LgcfA
         fd3YUsWDM/kUEjv7HQFd8rHJehZ4S1L2PPOojmLPkpECFVzAlwlJITrVeskIOoMAzQc9
         zicGHFLNFco/9JU8bp1MMjr9cW87/jb3Y4FAZxK9wdRWSdDoPzkiY5VZl2CyklzE8QSZ
         nkRg==
X-Gm-Message-State: AC+VfDxVNJzydtFjCAZAOjvH5TUDkbyhxkvx8NynQwQrDesS1GfxVJ04
        fDZleVh5VLetqEuSDCKN+scUHGx9l6DlfL/xJgw=
X-Google-Smtp-Source: ACHHUZ6Hf5ICRPhaHS7hQ1OTbRoi881o6Qi82VzwpLOfMz4kk3a0g4sq8MSkY03S/B2HVDMHrhYZPQ==
X-Received: by 2002:a05:6a21:329e:b0:116:696f:1dd1 with SMTP id yt30-20020a056a21329e00b00116696f1dd1mr13289907pzb.4.1687185529348;
        Mon, 19 Jun 2023 07:38:49 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o22-20020a635d56000000b00553c681155bsm1718158pgm.71.2023.06.19.07.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 07:38:48 -0700 (PDT)
Message-ID: <02ce6357-f28a-56d7-9c22-ffc1dc14f73d@kernel.dk>
Date:   Mon, 19 Jun 2023 08:38:47 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ead9cb99-1143-c3f3-bd7a-6d376ff7a802@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/23 7:27?AM, Stefan Metzmacher wrote:
> Am 19.06.23 um 15:09 schrieb Stefan Metzmacher:
>> Am 19.06.23 um 15:05 schrieb Jens Axboe:
>>> On 6/19/23 3:57?AM, Stefan Metzmacher wrote:
>>>> Hi Jens,
>>>>
>>>>> If the application sets ->msg_control and we have to later retry this
>>>>> command, or if it got queued with IOSQE_ASYNC to begin with, then we
>>>>> need to retain the original msg_control value. This is due to the net
>>>>> stack overwriting this field with an in-kernel pointer, to copy it
>>>>> in. Hitting that path for the second time will now fail the copy from
>>>>> user, as it's attempting to copy from a non-user address.
>>>>
>>>> I'm not 100% sure about the impact of this change.
>>>>
>>>> But I think the logic we need is that only the
>>>> first __sys_sendmsg_sock() that returns > 0 should
>>>> see msg_control. A retry because of MSG_WAITALL should
>>>> clear msg_control[len] for a follow up __sys_sendmsg_sock().
>>>> And I fear the patch below would not clear it...
>>>>
>>>> Otherwise the receiver/socket-layer will get the same msg_control twice,
>>>> which is unexpected.
>>>
>>> Yes agree, if we do transfer some (but not all) data and WAITALL is set,
>>> it should get cleared. I'll post a patch for that.
>>
>> Thanks!
>>
>>> Note that it was also broken before, just differently broken. The most
>>> likely outcome here was a full retry and now getting -EFAULT.
>>
>> Yes, I can see that it was broken before...
> 
> I haven't checked myself, but I'm wondering about the recvmsg case,
> I guess we would need to advance the msg_control buffer after each
> iteration, in order to avoid overwritting the already received messages
> on retry.
> 
> This all gets complicated with things like MSG_CTRUNC.
> 
> I guess it's too late to reject MSG_WAITALL together with msg_control
> for io_recvmsg() because of compat reasons,
> but as MSG_WAITALL is also processed in the socket layer, we could keep it
> simple for now and skip the this retry logic:
> 
>         if (flags & MSG_WAITALL)
>                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> 
> This might become something similar to this,
> but likely more complex, as would need to record kmsg->controllen == 0
> condition already in io_recvmsg_prep:
> 
>         if (flags & MSG_WAITALL && kmsg->controllen == 0)
>                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);

Yep agree, I think this is the best way - ensure that once we transfer
data with cmsg, it's a one-shot kind of deal.

Do you want to cut a patch for that one?

-- 
Jens Axboe

