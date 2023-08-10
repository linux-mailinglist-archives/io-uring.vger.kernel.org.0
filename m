Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61627778F0
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 15:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjHJNA1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 09:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjHJNA0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 09:00:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C65E5D;
        Thu, 10 Aug 2023 06:00:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-99cdb0fd093so133318766b.1;
        Thu, 10 Aug 2023 06:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691672424; x=1692277224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o2IFYmxJ69iOtAnIBZxcgpw37s7rFsv/wEwdYi37y7A=;
        b=VAlgLTuZTZu7oNH68LpSRV/qYAOx4ESLfto9jVRmJy04nKNPx+whhf1iCd8/5U5ISA
         c5aMU1mk2NxD10kILB7vxRuuPjwSD6plO/N7fX/AaQVffZP1Az2+mG8yAP2IcC/2WRhq
         1v0ndgchr1szE1ZsIUexVpg+46WjBNsAqrEjB+cQb8T20Il02eraX/Vsk5ghhk/yJN4X
         DMT+z4WpNcJuZg7R9DcGcTZsydZrr95Li2idtMzvCDeQu1C7OgNp3V7umUPnv7IZ9UOn
         8GqiVSkFFRKS3VLus7dLf6+oZFugvkidWBnP4f4nkxCcQRI6YXD10F1VofQVJZ+rOlRA
         0U4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691672424; x=1692277224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2IFYmxJ69iOtAnIBZxcgpw37s7rFsv/wEwdYi37y7A=;
        b=UUhOogJX64zbQAsEKytKCWJlas8cvIjUi5VvcPRZ4sllXm3Rb7xBbLnaD8dbs24kVG
         y7UpF0LWRLgyaoOquT379U3RWOj/NV4KFEUVe0u0yjgXnZol2rqjuTTz85nsShtxCwpE
         P1zw93GoXN197Bb46doH4btud94k9l99euwdLLVMsWiJ1VNNxvdFfkoHSNIMa/HQa/A5
         LM23rvN4nnrzJfG4xXykz6my1saro42QbEJZ6oUvmPnwO/AL1CNDDNmQmTwALhFlEbRJ
         RcNVzadLRNpAixzU3i3YP2GD86pe6TorF4p75/iaXIx4j6uzRFej7ETUOkAU5xT4GtSQ
         FKLw==
X-Gm-Message-State: AOJu0YxXZce68NIET0dNF6Q60mFasy5gW7FSEzNSFRZ4IJAkBb5lMikB
        vnIJ9xgZ15gLGvm5xiCHWFxCOIjhPAY=
X-Google-Smtp-Source: AGHT+IEn+CAt80sEUd90Zm1hPRtjcxfPMLNrsqaFlSsx6n0h1EC4M2slFE7ZyupQp5png9pZ39siMQ==
X-Received: by 2002:a17:906:304b:b0:99b:674c:44eb with SMTP id d11-20020a170906304b00b0099b674c44ebmr2032503ejd.9.1691672424268;
        Thu, 10 Aug 2023 06:00:24 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.237.36])
        by smtp.gmail.com with ESMTPSA id n8-20020a1709065e0800b0096f6a131b9fsm909147eju.23.2023.08.10.06.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 06:00:23 -0700 (PDT)
Message-ID: <58840e8e-a8e5-41d6-bb25-48a3a1ffc3b8@gmail.com>
Date:   Thu, 10 Aug 2023 13:57:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Breno Leitao <leitao@debian.org>, sdf@google.com,
        axboe@kernel.dk
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
References: <20230808134049.1407498-1-leitao@debian.org>
 <20230808134049.1407498-3-leitao@debian.org>
 <64d392c0235c6_267bde294c3@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <64d392c0235c6_267bde294c3@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 14:21, Willem de Bruijn wrote:
> Breno Leitao wrote:
>> Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
>> level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
>> where a sockptr_t is either userspace or kernel space, and handled as
>> such.
>>
>> Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
>>
>> Differently from the getsockopt(2), the optlen field is not a userspace
>> pointers. In getsockopt(2), userspace provides optlen pointer, which is
>> overwritten by the kernel.  In this implementation, userspace passes a
>> u32, and the new value is returned in cqe->res. I.e., optlen is not a
>> pointer.
>>
>> Important to say that userspace needs to keep the pointer alive until
>> the CQE is completed.
> 
> What bad things can happen otherwise?
> 
> The kernel is not depending on a well behaved process for its
> correctness here, is it? Any user pages have to be pinned while

Right, it's the user api thing. There are always userspace progs
that would try to do:

submit_async() {
	char buf[20];
	do_submit(sqe = {buf = buf, ...});
}

submit_async();
wait_completions();


> kernel might refer to them, for instance.

fwiw, it's passed down as a user ptr, which will be eventually
used in copy_[from,to]_user() or so.

-- 
Pavel Begunkov
